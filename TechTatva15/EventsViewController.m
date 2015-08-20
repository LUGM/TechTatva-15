//
//  EventsViewController.m
//  TechTatva15
//
//  Created by YASH on 19/08/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "EventsViewController.h"
#import "eventViewTableViewCell.h"
#import "NavigationMenuView.h"
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
    
//    UIView *blurView;
    
}

@property NSIndexPath *previousSelectedIndexPath;
@property NSIndexPath *currentSelectedIndexPath;

@property NavigationMenuView *navigationDropDown;

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
    
//    blurView = nil;
    _navigationDropDown = nil;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Explore" style:UIBarButtonItemStylePlain target:self action:@selector(loadDropDown)];
    
    NSURL *eventsUrl;
    eventsUrl = [NSURL URLWithString:@"http://api.techtatva.in/events"];
    myJsonInstance = [[SSJSONModel alloc] initWithDelegate:self];
    
    [myJsonInstance sendRequestWithUrl:eventsUrl];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DaySegmentedControlView" owner:self options:nil];
    _daySelector = [nib objectAtIndex:0];
    
    // 110 because search bar is 44 and status bar is 66.
    
    _daySelector.frame = CGRectMake(0, 110, self.view.frame.size.width, 45);
    [_daySelector.daySelectionControl addTarget:self action:@selector(daySelect) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_daySelector];
    
    // offset 89 = 45 for segmented control and 44 for search bar
    
    eventTable.contentInset = UIEdgeInsetsMake(89, 0, 0, 0);
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
    
    if (JSONModel == myJsonInstance.parsedJsonData)
    {
        
        NSLog(@"%@",myJsonInstance.parsedJsonData);
        json = myJsonInstance.parsedJsonData;
        
        eventNames = [NSMutableArray new];
        eventCategoryIds = [NSMutableArray new];
        
        tempEventStorage = [json objectForKey:@"data"];
        
        for (NSDictionary *dict in tempEventStorage)
        {
            
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

# pragma mark Sidebar Methods

- (void) loadDropDown
{
    
    if (self.navigationDropDown == nil)
    {
        
//        blurView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        blurView.alpha = 0.9;
//        [self.view addSubview:blurView];
//        [blurView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeExtraViews)]];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NavigationMenuView" owner:self options:nil];
        _navigationDropDown= [nib objectAtIndex:0];
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
        UINavigationController *eventsViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"categoryView"];
        [self presentViewController:eventsViewController animated:YES completion:nil];
        
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
        UINavigationController *eventsViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"eventView"];
        [self presentViewController:eventsViewController animated:YES completion:nil];
        
    }
    
}

- (void) favouritesButton
{
    
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *eventsViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"favouritesView"];
    [self presentViewController:eventsViewController animated:YES completion:nil];
    
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
        UINavigationController *eventsViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"resultsView"];
        [self presentViewController:eventsViewController animated:YES completion:nil];
        
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
        UINavigationController *eventsViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"instagramView"];
        [self presentViewController:eventsViewController animated:YES completion:nil];
        
    }
    
}

- (void) aboutUsButton
{
    
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *eventsViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"aboutUsView"];
    [self presentViewController:eventsViewController animated:YES completion:nil];
    
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
        UINavigationController *eventsViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"registerView"];
        [self presentViewController:eventsViewController animated:YES completion:nil];
        
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
        UINavigationController *eventsViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"onlineEventsView"];
        [self presentViewController:eventsViewController animated:YES completion:nil];
        
    }
    
}

//- (void) removeExtraViews
//{
//    
//    [blurView removeFromSuperview];
//    [_navigationDropDown removeFromSuperview];
//    blurView = nil;
//    _navigationDropDown = nil;
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
