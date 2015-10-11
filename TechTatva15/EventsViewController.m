//
//  EventsViewController.m
//  TechTatva15
//
//  Created by YASH on 19/08/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "EventsViewController.h"
#import "eventViewTableViewCell.h"
#import "Reachability.h"
#import "DaySegmentedControlView.h"
#import "MBProgressHUD.h"
#import "SSJSONModel.h"
#import "Event.h"
#import "RESideMenu.h"
#import "ResultsModel.h"
#import <Parse/Parse.h>

@interface EventsViewController () <SSJSONModelDelegate>
{
    
    SSJSONModel *myJsonInstance;
    SSJSONModel *resultsJsonInstance;
    
    NSDictionary *json;
    NSDictionary *resultsDict;
    
    NSArray *tempEventStorage;
    NSArray *resultJsonResponse;
    
    NSIndexPath *cellSelectIndex;
    
    NSString *dayString;
    NSString *checkedCategoryUrl;
    NSString *checkedScheduleUrl;
    NSString *checkedResultUrl;
    
    NSMutableArray *eventsArray;
    NSMutableArray *preDaySortEventsArray;
    NSMutableArray *filteredArray;
    NSMutableArray *resultsArray;
    NSMutableArray *tempResultStorage;
    
}

@property DaySegmentedControlView *daySelector;

@end

@implementation EventsViewController

@synthesize eventTable;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Events";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 2.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
    
    eventTable.scrollsToTop = YES;
    
    eventTable.separatorColor = [UIColor orangeColor];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DaySegmentedControlView" owner:self options:nil];
    _daySelector = [nib objectAtIndex:0];
    
    // 110 because search bar is 44 and status bar is 66.
    
    _daySelector.frame = CGRectMake(0, 64, self.view.frame.size.width, 44);
    [_daySelector.daySelectionControl addTarget:self action:@selector(daySelect) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_daySelector];
    
    // offset 89 = 45 for segmented control and 44 for search bar
    
    eventTable.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    self.view.backgroundColor = [UIColor grayColor];
    _daySelected = @1;
    dayString = @"1";
    
    if ([self isInternetAvailable])
    {
        
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
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
        
        NSUserDefaults *eventVCDat = [NSUserDefaults standardUserDefaults];
        NSUserDefaults *eventResultsDat = [NSUserDefaults standardUserDefaults];
        
        if ([eventVCDat objectForKey:@"events"] != nil)
        {
            
            json = [eventVCDat objectForKey:@"events"];
            [self setData];
            
        }
        if ([eventResultsDat objectForKey:@"eventRes"] != nil)
        {
            
            resultsDict = [eventResultsDat objectForKey:@"eventRes"];
            [self setData];
            
        }
        
    }
    
}

- (void) setCorrectUrls
{
    
    NSURL *eventsUrl;
    NSURL *resultsUrl;
    eventsUrl = [NSURL URLWithString:checkedScheduleUrl];
    resultsUrl = [NSURL URLWithString:checkedResultUrl];
    
    myJsonInstance = [[SSJSONModel alloc] initWithDelegate:self];
    [myJsonInstance sendRequestWithUrl:eventsUrl];
    resultsJsonInstance = [[SSJSONModel alloc] initWithDelegate:self];
    [resultsJsonInstance sendRequestWithUrl:resultsUrl];
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

# pragma mark - Data Helper Methods

- (void) jsonRequestDidCompleteWithDict:(id)response model:(SSJSONModel *)JSONModel
{
    
    if (JSONModel == myJsonInstance)
    {
        
        json = myJsonInstance.parsedJsonData;
        
        NSUserDefaults *eventVCData = [NSUserDefaults standardUserDefaults];
        [eventVCData setObject:json forKey:@"events"];
        [eventVCData synchronize];
        NSLog(@"ORIGINAL : %@", json);
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        [self setData];
        
    }
    else if (JSONModel == resultsJsonInstance)
    {
     
        resultsDict = myJsonInstance.parsedJsonData;
        
        NSUserDefaults *eventResultVCData = [NSUserDefaults standardUserDefaults];
        [eventResultVCData setObject:resultsDict forKey:@"eventRes"];
        [eventResultVCData synchronize];
        
        [self setData];
        
    }
    
}

- (void) setData
{
    
    resultsArray = [[NSMutableArray alloc] init];
    preDaySortEventsArray = [[NSMutableArray alloc] init];
    tempEventStorage = [[NSMutableArray alloc] init];
    tempResultStorage = [[NSMutableArray alloc] init];
    
    tempEventStorage = [json objectForKey:@"data"];
    for (NSDictionary *dict in tempEventStorage)
    {
        
        Event *event = [[Event alloc] initWithDict:dict];
        [preDaySortEventsArray addObject:event];

    }
    
    for (NSDictionary *dict in tempResultStorage)
    {
        
        ResultsModel *result = [[ResultsModel alloc] initWithDict:dict];
        [resultsArray addObject:result];
        
    }
    [self filterEvents];
    
}

# pragma mark Day Methods

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

- (void) filterEvents
{
    
    eventsArray = [NSMutableArray new];
    
    for (Event *event in preDaySortEventsArray)
    {
        
        if ([event.day isEqualToString:dayString])
        {
            
            [eventsArray addObject:event];
            
        }
        
    }
    NSLog(@"EVENTS ARRAY : %@",eventsArray);
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    [eventTable reloadData];
    
}

# pragma mark Connection Check

- (BOOL) isInternetAvailable
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
    
}

# pragma mark Event Table Data Source Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        
        return [filteredArray count];
        
    }
    else
    {
        
        return eventsArray.count;
        
    }
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    eventViewTableViewCell *cell = (eventViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"eventViewTableViewCell" owner:self options:nil];
    
    cell = [nib objectAtIndex:0];

    if (cell == nil)
    {
        
        cell = [[eventViewTableViewCell alloc] init];
        
    }
    
    Event *event = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        
        event = [filteredArray objectAtIndex:indexPath.row];
        
    }
    
    else
    {
        
        event = [eventsArray objectAtIndex:indexPath.row];
        
    }
    
    cell.venueLabel.text = event.location;
    cell.eventLabel.text = event.event;
    cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@", event.start, event.stop];
    cell.contactLabel.text = [NSString stringWithFormat:@"%@ %@", event.contact, event.contactNumber];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@",event.date];
    cell.maxTeamMembersLabel.text = [NSString stringWithFormat:@"Max Team Size : %@", event.maxTeamSize];
    cell.categoryLabel.text = event.category;
    
    cell.indexPathForCell = indexPath;
    [cell.detailsButton addTarget:self action:@selector(detailsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.callButton addTarget:self action:@selector(callCatHead:) forControlEvents:UIControlEventTouchUpInside];
    [cell.resultButton addTarget:self action:@selector(showEventResult:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

# pragma mark Event Table Delegate Methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cellSelectIndex = indexPath;
    
    [tableView beginUpdates];
    
    if (![indexPath compare:_selectedCellIndex] == NSOrderedSame)
    {
        
        _selectedCellIndex = indexPath;
        
    }
    
    else
    {
        
        _selectedCellIndex = nil;
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView endUpdates];
    
}

- (void) tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!self.eventTable.isDragging)
    {
    
        [eventTable beginUpdates];
        [eventTable reloadData];
        [eventTable endUpdates];
        
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

# pragma mark - Cell Button Methods

- (void) detailsButtonPressed: (id)sender
{
    
    Event *event = nil;

    if ([self.searchDisplayController isActive])
    {
        
        CGPoint pointClicked = [sender convertPoint:CGPointZero toView:self.searchDisplayController.searchResultsTableView];
        NSIndexPath *requiredIndexPath = [self.searchDisplayController.searchResultsTableView indexPathForRowAtPoint:pointClicked];
        
        event = [filteredArray objectAtIndex:requiredIndexPath.row];
        
    }
    
    else
    {
        
        CGPoint pointClicked = [sender convertPoint:CGPointZero toView:eventTable];
        NSIndexPath *requiredIndexPath = [eventTable indexPathForRowAtPoint:pointClicked];
        
        event = [eventsArray objectAtIndex:requiredIndexPath.row];
        
    }
    UIAlertView *detailsAlert = [[UIAlertView alloc] initWithTitle:event.event message:event.desc delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    NSLog(@"check event here %@", event);
    
    [detailsAlert show];
    
}

- (void) showEventResult: (id) sender
{
    
    Event *event = nil;
    ResultsModel *result = nil;
    
    if ([self.searchDisplayController isActive])
    {
        
        CGPoint pointClicked = [sender convertPoint:CGPointZero toView:self.searchDisplayController.searchResultsTableView];
        NSIndexPath *requiredIndexPath = [self.searchDisplayController.searchResultsTableView indexPathForRowAtPoint:pointClicked];
        
        event = [filteredArray objectAtIndex:requiredIndexPath.row];
        for (ResultsModel *res in resultsArray)
        {
            
            if ([event.event compare:res.name])
            {
                
                result = res;
                
            }
            
        }
        
    }
    
    else
    {
        
        CGPoint pointClicked = [sender convertPoint:CGPointZero toView:eventTable];
        NSIndexPath *requiredIndexPath = [eventTable indexPathForRowAtPoint:pointClicked];
        
        event = [eventsArray objectAtIndex:requiredIndexPath.row];
        for (ResultsModel *res in resultsArray)
        {
            
            NSLog(@"results data only %@", res);
            
            if ([event.event compare:res.name])
            {
                
                result = res;
                
            }
            
        }
        
    }
    
    UIAlertView *resultAlert = [[UIAlertView alloc] initWithTitle:result.name message:result.result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [resultAlert show];
    
}

# pragma mark - Content Filtering

-(void) filterContentForSearchText:(NSString*) searchText scope:(NSString*)scope
{
    
    [filteredArray removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event contains[c]%@", searchText];
    
    filteredArray = [NSMutableArray arrayWithArray:[eventsArray filteredArrayUsingPredicate:predicate]];
    
}

# pragma mark - UISearchDisplayController Delegate Methods

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
    
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
    
}

# pragma mark - Call feature

- (void) callCatHead: (id) sender
{
    
    Event *event = nil;
    
    if ([self.searchDisplayController isActive])
    {
        
        CGPoint pointClicked = [sender convertPoint:CGPointZero toView:self.searchDisplayController.searchResultsTableView];
        NSIndexPath *requiredIndexPath = [self.searchDisplayController.searchResultsTableView indexPathForRowAtPoint:pointClicked];
        
        event = [filteredArray objectAtIndex:requiredIndexPath.row];
        
    }
    
    else
    {
        
        CGPoint pointClicked = [sender convertPoint:CGPointZero toView:eventTable];
        NSIndexPath *requiredIndexPath = [eventTable indexPathForRowAtPoint:pointClicked];
        
        event = [eventsArray objectAtIndex:requiredIndexPath.row];
        
    }

    
    NSString *getPhoneNumber = [[event.contactNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt://+91%@", getPhoneNumber]];
    NSURL *phonecheckUrl = [NSURL URLWithString:[NSString stringWithFormat:@"+91%@", getPhoneNumber]];
    NSLog(@"Checking phone number to be called is : %@", phonecheckUrl);
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
    {
        
        [[UIApplication sharedApplication] openURL:phoneUrl];
        
    }
    else
    {
        
        UIAlertView *noCallAlert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Calling feature unavailable" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noCallAlert show];
        
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

- (IBAction)hamburgerLoader:(id)sender
{
    
    [self presentLeftMenuViewController:self];
    
}
@end
