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

@interface CatEventViewController () <SSJSONModelDelegate>
{
    
    NSMutableArray *eventsArray;
    NSMutableArray *eventByCategoryArray;
    NSMutableArray *tempEventStorage;
    
    NSDictionary *json;
    
    SSJSONModel *myJsonInstance;
    
}

@property NSIndexPath *previousSelectedIndexPath;
@property NSIndexPath *currentSelectedIndexPath;

@property DaySegmentedControlView *daySelector;

- (IBAction)dismissVCBarButtonPressed:(UIBarButtonItem *)sender;

@end

@implementation CatEventViewController

@synthesize catEventTable;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    _daySelector.frame = CGRectMake(0, 66, self.view.frame.size.width, 45);
    [_daySelector.daySelectionControl addTarget:self action:@selector(daySelect) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_daySelector];
    
    catEventTable.contentInset = UIEdgeInsetsMake(45, 0, 0, 0);
    catEventTable.scrollsToTop = YES;
    self.view.backgroundColor = [UIColor grayColor];
    _daySelected = @1;
    
    NSURL *eventsUrl;
    
    if ([self isInternetAvailable])
    {
        
        eventsUrl = [NSURL URLWithString:@"http://api.techtatva.in/events"];
        
    }
    else
    {
        
        eventsUrl = [NSURL URLWithString:@"http://localhost:8888/events.json"];
        
    }

    myJsonInstance = [[SSJSONModel alloc] initWithDelegate:self];
    myJsonInstance.delegate = self;
    [myJsonInstance sendRequestWithUrl:eventsUrl];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
    cell.indexPathForCell = indexPath;
    
    Event *event = [eventByCategoryArray objectAtIndex:indexPath.row];
    
    cell.eventNameLabel.text = event.event;
    cell.eventDetailsTextView.text = event.description;
    
    return cell;
    
}

# pragma mark Table View Delegate Methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.previousSelectedIndexPath = self.currentSelectedIndexPath;
    self.currentSelectedIndexPath = indexPath;
    
    if (self.previousSelectedIndexPath && !([self.previousSelectedIndexPath compare:self.currentSelectedIndexPath] == NSOrderedSame))
    {
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.previousSelectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
    else if ((self.previousSelectedIndexPath) && [self.previousSelectedIndexPath compare:self.currentSelectedIndexPath] == NSOrderedSame)
    {
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.currentSelectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
//    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.currentSelectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //    one of the above two is correct, check which
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (([self.currentSelectedIndexPath compare:indexPath] == NSOrderedSame) && ([self.currentSelectedIndexPath compare:self.previousSelectedIndexPath] == NSOrderedSame))
    {
        
        return 40;
        
    }
    
    else if (self.currentSelectedIndexPath != nil && [self.currentSelectedIndexPath compare:indexPath] == NSOrderedSame)
    {
        
        return  250;
        
    }
    
    else
    {
        
        return  40;
        
    }
    
}

# pragma mark - Data Helper Methods

- (void) jsonRequestDidCompleteWithDict:(id)response model:(SSJSONModel *)JSONModel
{
    
    if (JSONModel == myJsonInstance)
    {
        
        NSLog(@"%@",myJsonInstance.parsedJsonData);
        json = myJsonInstance.parsedJsonData;
        
        eventsArray = [[NSMutableArray alloc] init];
        
        tempEventStorage = [json objectForKey:@"data"];
        
        for (NSDictionary *dict in tempEventStorage)
        {
            
            //            if ([dict objectForKey:@"date"] isEqualToString:"07/10/2015") then add object and load table...check if date or Date in API
            
            Event *event = [[Event alloc] initWithDict:dict];
            [eventsArray addObject:event];
            
        }
        
        [self filterByCategory];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }
    
}


# pragma  mark Segmented Control Methods

- (void) daySelect
{
    
    switch (_daySelector.daySelectionControl.selectedSegmentIndex)
    {
            
        case 0:
            _daySelected = @1;
            [catEventTable reloadData];
            break;
            
        case 1:
            _daySelected = @2;
            [catEventTable reloadData];
            break;
            
        case 2:
            _daySelected = @3;
            [catEventTable reloadData];
            break;
            
        case 3:
            _daySelected = @4;
            [catEventTable reloadData];
            break;
            
        default:
            _daySelected = @1;
            [catEventTable reloadData];
            break;
    }
    
}

# pragma mark Segue Methods

- (IBAction)dismissVCBarButtonPressed:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

# pragma mark - Event Sort Methods

- (void) filterByCategory
{
    
    eventByCategoryArray = [NSMutableArray array];
    
    for (Event *event in eventsArray)
    {
        
        if ([event.category isEqualToString:self.title])
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
