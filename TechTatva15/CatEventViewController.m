//
//  CatEventViewController.m
//  TechTatva15
//
//  Created by YASH on 16/08/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "CatEventViewController.h"
#import "DaySegmentedControlView.h"
#import "Reachability.h"
#import "SSJSONModel.h"
#import "MBProgressHUD.h"
#import "Event.h"
#import "CategoryTableViewCell.h"
#import "CoreDataModel.h"
#import "Favourites.h"
#import <Parse/Parse.h>

@interface CatEventViewController () <SSJSONModelDelegate>
{
    
    NSMutableArray *eventsArray;
    NSMutableArray *eventByCategoryArray;
    NSMutableArray *tempEventStorage;
    
    NSString *dayString;
    
    NSDictionary *json;
    
    SSJSONModel *myJsonInstance;
    
    NSString *checkedCategoryUrl;
    NSString *checkedScheduleUrl;
    NSString *checkedResultUrl;
    
}

@property DaySegmentedControlView *daySelector;

- (IBAction)dismissVCBarButtonPressed:(UIBarButtonItem *)sender;

@end

@implementation CatEventViewController

@synthesize catEventTable;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"CAT ID : %@",self.catid);
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 2.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
    
    UIBarButtonItem *dismissVC = [[UIBarButtonItem alloc] init];
    dismissVC.target = self;
    dismissVC.action = @selector(dismissVCBarButtonPressed:);
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DaySegmentedControlView" owner:self options:nil];
    _daySelector = [nib objectAtIndex:0];
    _daySelector.frame = CGRectMake(0, 64, self.view.frame.size.width, 44);
    [_daySelector.daySelectionControl addTarget:self action:@selector(daySelect) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_daySelector];
    
    catEventTable.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    catEventTable.scrollsToTop = YES;
    self.view.backgroundColor = [UIColor grayColor];
    _daySelected = @1;
    dayString = @"1";
    
    catEventTable.separatorColor = [UIColor orangeColor];
    
    if ([self isInternetAvailable])
    {
        
        [PFConfig getConfigInBackgroundWithBlock:^(PFConfig * config, NSError * error){
            NSLog(@"CATEGORY URL : %@",config[@"categories"]);
            NSLog(@"SCHEDULE URL : %@",config[@"schedule"]);
            NSLog(@"RESULTS URL : %@",config[@"results"]);
            
            checkedCategoryUrl = config[@"categories"];
            checkedScheduleUrl = config[@"schedule"];
            checkedResultUrl = config[@"results"];
            [self setCorrectUrls];

        }];
    
    }
    else
    {
        
        NSUserDefaults *evData =[NSUserDefaults standardUserDefaults];
        //        NSLog(@"Data is %@", [evData objectForKey:@"data"]);
        
        if ([evData objectForKey:@"events"] != nil)
        {
            
            json = [evData objectForKey:@"events"];
            NSLog(@"json here is %@", json);
            [self loadData];
            
        }
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToFavourites:) name:@"favouritePressed" object:nil];
    
}

- (void) setCorrectUrls
{
    
    NSURL *eventsUrl;
    eventsUrl = [NSURL URLWithString:checkedScheduleUrl];
    
    myJsonInstance =[[SSJSONModel alloc] initWithDelegate:self];
    [myJsonInstance sendRequestWithUrl:eventsUrl];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

# pragma mark Table View Data Source Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [eventByCategoryArray count];
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CategoryTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    if (cell == nil) {
        cell = [[CategoryTableViewCell alloc] init];
    }
    cell.indexPathForMyCell = indexPath;
    
    Event *event = [eventByCategoryArray objectAtIndex:indexPath.row];
    
    cell.eventNameLabel.text = event.event;
    cell.eventDetailsTextView.text = event.desc;
    
//    [cell.favouritesButton addTarget:self action:@selector(addToFavourites:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

# pragma mark Table View Delegate Methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [catEventTable beginUpdates];
    
    if (![indexPath compare:_selectedCellIndex] == NSOrderedSame)
    {
        
        _selectedCellIndex = indexPath;
        
    }
    
    else
    {
        
        _selectedCellIndex = nil;
        
    }
    
    [catEventTable deselectRowAtIndexPath:indexPath animated:YES];
    [catEventTable endUpdates];
    
}

- (void) tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!self.catEventTable.isDragging)
    {
        
        [catEventTable beginUpdates];
        [catEventTable reloadData];
        [catEventTable endUpdates];
        
    }
    
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([indexPath compare:_selectedCellIndex] == NSOrderedSame)
    {
        
        return  255.f;
        
    }
    
    return 43.f;
    
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectZero];
    return blankView;
    
}


# pragma mark - Data Helper Methods

- (void) jsonRequestDidCompleteWithDict:(id)response model:(SSJSONModel *)JSONModel
{
    
    if (JSONModel == myJsonInstance)
    {
        
        json = myJsonInstance.parsedJsonData;
        
        NSUserDefaults *eventData = [NSUserDefaults standardUserDefaults];
        [eventData setObject:json forKey:@"events"];
        [eventData synchronize];
        
        [self loadData];
        
    }
    
}

- (void) loadData
{
    
    eventsArray = [[NSMutableArray alloc] init];
    
    tempEventStorage = [json objectForKey:@"data"];
    
    for (NSDictionary *dict in tempEventStorage)
    {
        
        Event *event = [[Event alloc] initWithDict:dict];
        [eventsArray addObject:event];
        
    }
    
    [self filterEvents];
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
}


# pragma  mark Segmented Control Methods

- (void) daySelect
{
    
    switch (_daySelector.daySelectionControl.selectedSegmentIndex)
    {
            
        case 0:
            _daySelected = @1;
            dayString = @"1";
            break;
            
        case 1:
            _daySelected = @2;
            dayString = @"2";
            break;
            
        case 2:
            _daySelected = @3;
            dayString = @"3";
            break;
            
        case 3:
            _daySelected = @4;
            dayString = @"4";
            break;
            
        default:
            _daySelected = @1;
            dayString = @"1";
            break;
    }
    
    [self filterEvents];
}

# pragma mark - Favourites Methods

- (void)addToFavourites:(id)someObject
{
    
    NSIndexPath *indexPath = [someObject valueForKey:@"object"];
    NSLog(@"index is %ld",(long)indexPath.row);
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Favourites"];
    NSError *error = nil;
    
    Event *event = [eventByCategoryArray objectAtIndex:indexPath.row];
    NSArray *fetchedArray = [[CoreDataModel managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    NSInteger eventAlreadyThere = 0;
    
    for (int i=0; i<fetchedArray.count; i++)
    {
        
        Event *checkForFav = [fetchedArray objectAtIndex:i];
        if ([checkForFav.event isEqualToString:event.event])
        {
            
            eventAlreadyThere = 1;
            UIAlertView *addedAlert = [[UIAlertView alloc]initWithTitle:@"Event Already Added!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [addedAlert show];
            break;
        }
        
    }
    
    if (eventAlreadyThere == 0)
    {
        NSManagedObjectContext * context = [CoreDataModel managedObjectContext];
        
        Favourites *favouriteEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Favourites" inManagedObjectContext:context];
        
        favouriteEvent.event = event.event;
        favouriteEvent.location = event.location;
        favouriteEvent.start = event.start;
        favouriteEvent.stop = event.stop;
//        favouriteEvent.duration = event.duration;
        favouriteEvent.category = event.category;
        favouriteEvent.desc = event.desc;
        favouriteEvent.contact = event.contact;
        favouriteEvent.date = event.date;
        favouriteEvent.day = event.day;
        favouriteEvent.maxTeamSize = event.maxTeamSize;
        
        if (![context save:&error])
        {
            
            NSLog(@"%@",error);
            
        }
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Added" message:@"Event Successfully Added To Favourites" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}

# pragma mark Segue Methods

- (IBAction)dismissVCBarButtonPressed:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

# pragma mark - Event Sort Methods

- (void) filterEvents
{
    
    eventByCategoryArray = [NSMutableArray new];
    
    for (Event *event in eventsArray)
    {
        
        if ([event.catID isEqualToString:self.catid] && [event.day isEqualToString:dayString])
        {
            
            [eventByCategoryArray addObject:event];
            
        }
        
    }
    
    [catEventTable reloadData];
    
}

# pragma mark Connection Check

- (BOOL) isInternetAvailable
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
