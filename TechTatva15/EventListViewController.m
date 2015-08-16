//
//  EventListViewController.m
//  TechTatva15
//
//  Created by YASH on 04/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

// Fix placement of table view in this. Problem is visible when it runs

#import "EventListViewController.h"
#import "eventViewTableViewCell.h"
#import "NavigationMenuView.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "SSJSONModel.h"
#import "Event.h"
#import "DaySegmentedControlView.h"

@interface EventListViewController () <SSJSONModelDelegate>
{
    
    UIView *blurView;
    
    SSJSONModel *myJsonInstance;
    
    NSDictionary *json;
    
    NSMutableArray *eventNames;
    NSMutableArray *eventIds;
    NSMutableArray *eventDescriptions;
    NSMutableArray *eventCategoryIds;
    NSMutableArray *eventMaxTeamMembers;
    
    NSArray *tempEventStorage;
    
}

@property NSIndexPath *previousSelectedCellIndexPath;
@property NSIndexPath *currentSelectedCellIndexPath;

@property NavigationMenuView *navigationDropDown;

@property DaySegmentedControlView *daySelector;

@end

@implementation EventListViewController

@synthesize eventsTable, eventsSearchBar;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 2.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
    
    eventsTable.scrollsToTop = YES;
    
    blurView = nil;
    _navigationDropDown = nil;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Explore" style:UIBarButtonItemStylePlain target:self action:@selector(loadDropDown)];
    
    NSURL *eventsUrl;
    
    eventsUrl = [NSURL URLWithString:@"http://api.techtatva.in/events"];
    myJsonInstance = [[SSJSONModel alloc] initWithDelegate:self];
//    eventsUrl = [NSURL URLWithString:@"http://localhost:8888/events.json"];
    
    [myJsonInstance sendRequestWithUrl:eventsUrl];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DaySegmentedControlView" owner:self options:nil];
    _daySelector = [nib objectAtIndex:0];
    _daySelector.frame = CGRectMake(0, 66, self.view.frame.size.width, 45);
    [_daySelector.daySelectionControl addTarget:self action:@selector(daySelect) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_daySelector];
    
    eventsTable.contentInset = UIEdgeInsetsMake(45, 0, 0, 0);
    
    _daySelected = @1;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark UITableView Data Source Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return tempEventStorage.count;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellIdentifier = @"Cell";
    
    eventViewTableViewCell * cell = (eventViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"eventViewTableViewCell" owner:self options:nil];
    
    cell = [nib objectAtIndex:0];
    
    cell.timeImageView = nil;
    cell.dateImageView = nil;
    cell.contactImageView = nil;
    cell.venueImageView = nil;
    
    // Will be updated later. Same image for all events. REMEMBER to adjust dimensions accordingly.
    
    
    //Feed all data here.
    
    cell.indexPathForCell = indexPath;
    
    //Day is diplayed in the event name text. Later, can be used to filter out results. Just use the self.selctedDay property wisely. TEEHEE :3
    
//    cell.eventLabel.text = [eventNames objectAtIndex:indexPath.row];
//    cell.categoryLabel.text = [eventCategoryIds objectAtIndex:indexPath.row];
    
    cell.eventLabel.text = [NSString stringWithFormat:@"Event %li Day %@", ((long)indexPath.row + 1), self.daySelected];
    cell.venueLabel.text = @"304, NLH";
    cell.timeLabel.text = @"3:30 PM";
    cell.contactLabel.text = @"+91 8424998388";
    cell.dateLabel.text = @"13/08/2015";
    
    return cell;
    
}

# pragma mark UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.previousSelectedCellIndexPath = self.currentSelectedCellIndexPath;  // <- save previously selected cell
    self.currentSelectedCellIndexPath = indexPath;
    if (self.previousSelectedCellIndexPath && !([self.previousSelectedCellIndexPath compare:self.currentSelectedCellIndexPath] == NSOrderedSame)) { // <- reload previously selected cell (if not nil)
        [eventsTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.previousSelectedCellIndexPath]
                           withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if ((self.previousSelectedCellIndexPath)&&[self.previousSelectedCellIndexPath compare:self.currentSelectedCellIndexPath] == NSOrderedSame){
        [eventsTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.currentSelectedCellIndexPath]
                           withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [eventsTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.currentSelectedCellIndexPath]
                       withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (([self.currentSelectedCellIndexPath compare:indexPath] == NSOrderedSame)&& ([self.currentSelectedCellIndexPath compare:self.previousSelectedCellIndexPath]==NSOrderedSame)) {
        return 43;
    }
    else if(self.currentSelectedCellIndexPath != nil
            && [self.currentSelectedCellIndexPath compare:indexPath] == NSOrderedSame)
        return 255;
    
    else
        return 43;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView * blankView = [[UIView alloc]initWithFrame:CGRectZero];
    return blankView;
    
}

# pragma  mark Segmented Control Methods

- (void) daySelect
{
    
    switch (_daySelector.daySelectionControl.selectedSegmentIndex)
    {
            
        case 0:
            _daySelected = @1;
            [eventsTable reloadData];
            break;
            
        case 1:
            _daySelected = @2;
            [eventsTable reloadData];
            break;
            
        case 2:
            _daySelected = @3;
            [eventsTable reloadData];
            break;
            
        case 3:
            _daySelected = @4;
            [eventsTable reloadData];
            break;
            
        default:
            _daySelected = @1;
            [eventsTable reloadData];
            break;
    }
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

# pragma mark Sidebar Methods

- (void) loadDropDown
{
    
    if (self.navigationDropDown == nil)
    {
        
        blurView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        blurView.alpha = 0.9;
        [self.view addSubview:blurView];
        [blurView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeExtraViews)]];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NavigationMenuView" owner:self options:nil];
        _navigationDropDown = [nib objectAtIndex:0];
        _navigationDropDown.frame = CGRectMake(0, 65, 170, 602);
        
        [self.view addSubview:_navigationDropDown];
        
        [_navigationDropDown.categoryButtonPressed addTarget:self action:@selector(categoryButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.eventButtonPressed addTarget:self action:@selector(eventButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.favouritesButtonPressed addTarget:self action:@selector(favouritesButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.resultsButtonPressed addTarget:self action:@selector(resultsButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.instafeedButtonPressed addTarget:self action:@selector(instafeedButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.aboutUsButtonPressed addTarget:self action:@selector(aboutUsButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.registerButtonPressed addTarget:self action:@selector(registerButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.onlineEventsButtonPressed addTarget:self action:@selector(onlineEventsButton) forControlEvents:UIControlEventTouchUpInside];
        
        _navigationDropDown.sidebarImageView.layer.cornerRadius = 25;
        
    }
    
}

- (void) categoryButton
{
    
    if (![self isInternetAvailable])
    {
        
        UIAlertView *categoryViewConnectionAlert = [[UIAlertView alloc] initWithTitle:@"Data unavailable" message:@"Please recheck connection"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [categoryViewConnectionAlert show];
        
    }
    
    else
    {
        
        [self.navigationDropDown removeFromSuperview];
        self.navigationDropDown = nil;
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *eventListViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"categoryView"];
        [self presentViewController:eventListViewController animated:YES completion:nil];
        
    }
    
}

- (void) eventButton
{
    
    if (![self isInternetAvailable])
    {
        
        UIAlertView *eventViewConnectionAlert = [[UIAlertView alloc] initWithTitle:@"Data unavailable"
                                                                           message:@"Please recheck connection"
                                                                          delegate:self
                                                                 cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [eventViewConnectionAlert show];
        
    }
    
    else
    {
        
        [self.navigationDropDown removeFromSuperview];
        self.navigationDropDown = nil;
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *eventListViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"eventView"];
        [self presentViewController:eventListViewController animated:YES completion:nil];
        
    }
    
}

- (void) favouritesButton
{
    
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *eventListViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"favouritesView"];
    [self presentViewController:eventListViewController animated:YES completion:nil];
    
}

- (void) resultsButton
{
    
    if (![self isInternetAvailable])
    {
        
        UIAlertView *resultsViewConnectionAlert = [[UIAlertView alloc] initWithTitle:@"Data unavailable"
                                                                             message:@"Please recheck connection"
                                                                            delegate:self
                                                                   cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [resultsViewConnectionAlert show];
        
    }
    
    else
    {
        
        [self.navigationDropDown removeFromSuperview];
        self.navigationDropDown = nil;
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *eventListViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"resultsView"];
        [self presentViewController:eventListViewController animated:YES completion:nil];
        
    }
    
}

- (void) instafeedButton
{
    
    if (![self isInternetAvailable])
    {
        
        UIAlertView *instagramViewConnectionAlert = [[UIAlertView alloc] initWithTitle:@"Data unavailable"
                                                                               message:@"Please recheck connection"
                                                                              delegate:self
                                                                     cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [instagramViewConnectionAlert show];
        
    }
    
    else
    {
        
        [self.navigationDropDown removeFromSuperview];
        self.navigationDropDown = nil;
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *eventListViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"instagramView"];
        [self presentViewController:eventListViewController animated:YES completion:nil];
        
    }
    
}

- (void) aboutUsButton
{
    
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *eventListViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"aboutUsView"];
    [self presentViewController:eventListViewController animated:YES completion:nil];
    
}

- (void) registerButton
{
    
    if (![self isInternetAvailable])
    {
        
        UIAlertView *registerViewConnectionAlert = [[UIAlertView alloc] initWithTitle:@"Data unavailable"
                                                                               message:@"Please recheck connection"
                                                                              delegate:self
                                                                     cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [registerViewConnectionAlert show];
        
    }
    
    else
    {
        
        [self.navigationDropDown removeFromSuperview];
        self.navigationDropDown = nil;
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *eventListViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"registerView"];
        [self presentViewController:eventListViewController animated:YES completion:nil];
        
    }
    
}

- (void) onlineEventsButton
{
    
    if (![self isInternetAvailable])
    {
        
        UIAlertView *onlineEventsViewConnectionAlert = [[UIAlertView alloc] initWithTitle:@"Data unavailable"
                                                                               message:@"Please recheck connection"
                                                                              delegate:self
                                                                     cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [onlineEventsViewConnectionAlert show];
        
    }
    
    else
    {
        
        [self.navigationDropDown removeFromSuperview];
        self.navigationDropDown = nil;
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *eventListViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"onlineEventsView"];
        [self presentViewController:eventListViewController animated:YES completion:nil];
        
    }
    
}

- (void) removeExtraViews
{
    
    [blurView removeFromSuperview];
    [_navigationDropDown removeFromSuperview];
    blurView = nil;
    _navigationDropDown = nil;
    
}

# pragma mark Connection Check

- (BOOL) isInternetAvailable
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
    
}

#pragma mark Helper Methods

- (void)jsonRequestDidCompleteWithDict:(id)response model:(SSJSONModel *)JSONModel
{
    
    if (JSONModel == myJsonInstance)
    {
        
        NSLog(@"%@",myJsonInstance.parsedJsonData);
        json = myJsonInstance.parsedJsonData;
        
        eventNames = [NSMutableArray new];
        eventMaxTeamMembers = [NSMutableArray new];
        eventIds = [NSMutableArray new];
        eventDescriptions = [NSMutableArray new];
        eventCategoryIds = [NSMutableArray new];
        
        tempEventStorage = [json objectForKey:@"data"];
        for (NSDictionary * dict in tempEventStorage)
        {
            [eventIds addObject:[dict objectForKey:@"event_id"]];
            [eventNames addObject:[dict objectForKey:@"event_name"]];
            [eventMaxTeamMembers addObject:[dict objectForKey:@"event_max_team_number"]];
            [eventDescriptions addObject:[dict objectForKey:@"description"]];
            [eventCategoryIds addObject:[dict objectForKey:@"cat_id"]];
        }
        
        [eventsTable reloadData];
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }
    
}


@end
