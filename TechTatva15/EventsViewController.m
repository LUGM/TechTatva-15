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

@interface EventsViewController () <SSJSONModelDelegate>
{
    
    SSJSONModel *myJsonInstance;
    SSJSONModel *resultsJsonInstance;
    
    NSDictionary *json;
    
    NSArray *tempEventStorage;
    NSArray *resultJsonResponse;
    
    NSIndexPath *cellSelectIndex;
    
    NSString *dayString;
    
    NSMutableArray *eventsArray;
    NSMutableArray *preDaySortEventsArray;
    NSMutableArray *filteredArray;
    NSMutableArray *resultsArray;
//    NSMutableArray *resultsFilteredArray;
    
}

@property DaySegmentedControlView *daySelector;

@end

@implementation EventsViewController

@synthesize eventTable;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    NSURL *eventsUrl;
    NSURL *resultsUrl;
    
    if ([self isInternetAvailable])
    {
        
        NSLog(@"Enters if");
    
        eventsUrl = [NSURL URLWithString:@"http://schedule.techtatva.in"];
        resultsUrl = [NSURL URLWithString:@"http://results.techtatva.in"];
        
        myJsonInstance = [[SSJSONModel alloc] initWithDelegate:self];
        myJsonInstance.delegate = self;
        resultsJsonInstance = [[SSJSONModel alloc] initWithDelegate:self];
        resultsJsonInstance.delegate = self;
        [resultsJsonInstance sendRequestWithUrl:resultsUrl];
        [myJsonInstance sendRequestWithUrl:eventsUrl];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    }
    else
    {
        
//        eventsUrl = [NSURL URLWithString:@"http://localhost:8888/Events.json"];
//        resultsUrl = [NSURL URLWithString:@"http://localhost:8888/Results.json"];
        
        NSUserDefaults *eventVCDat =[NSUserDefaults standardUserDefaults];
        //        NSLog(@"Data is %@", [evData objectForKey:@"data"]);
        
        if ([eventVCDat objectForKey:@"events"] != nil)
        {
            
            json = [eventVCDat objectForKey:@"events"];
//            NSLog(@"json here is %@", json);
//            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            [self setData];
            
        }
        
    }
    
//    myJsonInstance = [[SSJSONModel alloc] initWithDelegate:self];
//    myJsonInstance.delegate = self;
//    resultsJsonInstance = [[SSJSONModel alloc] initWithDelegate:self];
//    resultsJsonInstance.delegate = self;
//    [resultsJsonInstance sendRequestWithUrl:resultsUrl];
//    [myJsonInstance sendRequestWithUrl:eventsUrl];
    
//    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
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
        
//        NSLog(@"%@",myJsonInstance.parsedJsonData);
        json = myJsonInstance.parsedJsonData;
        
        NSUserDefaults *eventVCData = [NSUserDefaults standardUserDefaults];
        [eventVCData setObject:json forKey:@"events"];
        [eventVCData synchronize];
        NSLog(@"ORIGINAL : %@",json);
        
//        resultsArray = [[NSMutableArray alloc] init];
//        preDaySortEventsArray = [[NSMutableArray alloc] init];
//        
//        tempEventStorage = [json objectForKey:@"data"];
//        
//        for (NSDictionary *dict in tempEventStorage)
//        {
//
//            Event *event = [[Event alloc] initWithDict:dict];
//            [preDaySortEventsArray addObject:event];
//            
//        }
//        
//        [self filterEvents];
//        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        [self setData];
        
    }
    else if (JSONModel == resultsJsonInstance)
    {
     
        NSLog(@"results json log%@",resultsJsonInstance.parsedJsonData);
        
//        [self asyncResultRequest];
        
    }
    
}

- (void) setData
{
    
    resultsArray = [[NSMutableArray alloc] init];
    preDaySortEventsArray = [[NSMutableArray alloc] init];
    tempEventStorage = [[NSMutableArray alloc] init];
    
    tempEventStorage = [json objectForKey:@"data"];
    for (NSDictionary *dict in tempEventStorage)
    {
        
        Event *event = [[Event alloc] initWithDict:dict];
        [preDaySortEventsArray addObject:event];

    }
    [self filterEvents];
    
}

- (void) fetchedData:(NSData *) response
{
    
    NSError *error;
    
    resultJsonResponse = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    
    NSLog(@"results array %@", resultJsonResponse);
    
    //    resultJsonResponse = resultsJsonInstance.parsedJsonData;
    
    for (NSDictionary *dictionary in resultJsonResponse)
    {
        
        ResultsModel *result = [[ResultsModel alloc] initWithDict:dictionary];
        [resultsArray addObject:result];
        
    }
    
}

// check if it will be main queue or current queue in sendAsynReq call, has to run in parallel

- (void) asyncResultRequest
{
    
    NSURL *resultUrl;
    
    if ([self isInternetAvailable])
    {
        
        NSLog(@"Enters if");

        resultUrl = [NSURL URLWithString:@"results.techtatva.in"];
        
    }
    else
    {
        
        resultUrl = [NSURL URLWithString:@"http://localhost:8888/Results.json"];
        
    }

    NSURLRequest *requestSent = [NSURLRequest requestWithURL:resultUrl];
    
    [NSURLConnection sendAsynchronousRequest:requestSent queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         
         [self fetchedData:data];
         
     }];
    
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
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
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
    
    CGPoint pointClicked = [sender convertPoint:CGPointZero toView:self.eventTable];
    NSIndexPath *requiredIndexPath = [self.eventTable indexPathForRowAtPoint:pointClicked];
    Event * event = [eventsArray objectAtIndex:requiredIndexPath.row];
    
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
