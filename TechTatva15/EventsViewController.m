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

@interface EventsViewController () <SSJSONModelDelegate>
{
    
    SSJSONModel *myJsonInstance;
    
    NSDictionary *json;
    
    NSArray *tempEventStorage;
    
    NSMutableArray *eventNames;
    NSMutableArray *eventCategoryIds;
    
}

@property NSIndexPath *previousSelectedIndexPath;
@property NSIndexPath *currentSelectedIndexPath;

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
    
    NSURL *eventsUrl;
    eventsUrl = [NSURL URLWithString:@"http://api.techtatva.in/events"];
    myJsonInstance = [[SSJSONModel alloc] initWithDelegate:self];
    myJsonInstance.delegate = self;
//    eventsUrl = [NSURL URLWithString:@"http://localhost:8888/events.json"];
    [myJsonInstance sendRequestWithUrl:eventsUrl];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DaySegmentedControlView" owner:self options:nil];
    _daySelector = [nib objectAtIndex:0];
    
    // 110 because search bar is 44 and status bar is 66.
    
    _daySelector.frame = CGRectMake(0, 66, self.view.frame.size.width, 45);
    [_daySelector.daySelectionControl addTarget:self action:@selector(daySelect) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_daySelector];
    
    // offset 89 = 45 for segmented control and 44 for search bar
    
    eventTable.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    self.view.backgroundColor = [UIColor grayColor];
    _daySelected = @1;
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

# pragma mark Data Helper Methods

- (void) jsonRequestDidCompleteWithDict:(id)response model:(SSJSONModel *)JSONModel
{
    
    if (JSONModel == myJsonInstance)
    {
        
        NSLog(@"%@",myJsonInstance.parsedJsonData);
        json = myJsonInstance.parsedJsonData;
        
        eventNames = [NSMutableArray new];
        eventCategoryIds = [NSMutableArray new];
        
        tempEventStorage = [json objectForKey:@"data"];
        
        for (NSDictionary *dict in tempEventStorage)
        {
            
//            if ([dict objectForKey:@"date"] isEqualToString:"07/10/2015") then add object and load table...check if date or Date in API
            
            [eventNames addObject:[dict objectForKey:@"event_name"]];
            [eventCategoryIds addObject:[dict objectForKey:@"cat_id"]];
            
        }
        
        [eventTable reloadData];
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }
    
}

# pragma mark Segmented Control Methods

- (void) daySelect
{
    
    switch (_daySelector.daySelectionControl.selectedSegmentIndex)
    {
            
        case 0:
            _daySelected = @1;
            [eventTable reloadData];
            break;
            
        case 1:
            _daySelected = @2;
            [eventTable reloadData];
            break;
            
        case 2:
            _daySelected = @3;
            [eventTable reloadData];
            break;
            
        case 3:
            _daySelected = @4;
            [eventTable reloadData];
            break;
            
        default:
            _daySelected = @1;
            [eventTable reloadData];
            break;
            
    }
    
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
    
    return tempEventStorage.count;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    
    eventViewTableViewCell *cell = (eventViewTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"eventViewTableViewCell" owner:self options:nil];
    
    cell = [nib objectAtIndex:0];
    
    cell.timeImageView = nil;
    cell.venueImageView = nil;
    cell.contactImageView = nil;
    cell.dateImageView = nil;
    cell.maxTeamMembersImageView = nil;
    
    cell.eventLabel.text = [eventNames objectAtIndex:indexPath.row];
    cell.dateLabel.text = [NSString stringWithFormat:@"Day %@", self.daySelected];
    cell.categoryLabel.text = @"Category";
    cell.maxTeamMembersLabel.text = @"Team members";
    cell.contactLabel.text = @"7022207520";
    cell.timeLabel.text = @"Midnight";
    cell.venueLabel.text = @"DeeTee";
    
    cell.indexPathForCell = indexPath;
    
    return cell;
    
}

# pragma mark Event Table Delegate Methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.previousSelectedIndexPath = self.currentSelectedIndexPath;
    self.currentSelectedIndexPath = indexPath;
    
    if (self.previousSelectedIndexPath && !([self.previousSelectedIndexPath compare:self.currentSelectedIndexPath] == NSOrderedSame))
    {
        
        [eventTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.previousSelectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
    else if ((self.previousSelectedIndexPath) && [self.previousSelectedIndexPath compare:self.currentSelectedIndexPath] == NSOrderedSame)
    {
        
        [eventTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.currentSelectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
    else
    {
        
        [eventTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.currentSelectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
//    [eventTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.currentSelectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
//    one of the above two is correct, check which
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (([self.currentSelectedIndexPath compare:indexPath] == NSOrderedSame) && ([self.currentSelectedIndexPath compare:self.previousSelectedIndexPath] == NSOrderedSame))
    {
        
        return 43;
        
    }
    
    else if ((self.currentSelectedIndexPath != nil) && [self.currentSelectedIndexPath compare:indexPath] == NSOrderedSame)
    {
        
        return 255;
        
    }
    
    else
    {
        
        return 43;
        
    }
    
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectZero];
    return blankView;
    
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
