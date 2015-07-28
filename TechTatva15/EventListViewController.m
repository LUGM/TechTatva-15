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

@interface EventListViewController ()
{
    
    UIView *blurView;
    
}

@property NSIndexPath *previousSelectedCellIndexPath;
@property NSIndexPath *currentSelectedCellIndexPath;

@property NavigationMenuView *navigationDropDown;

@end

@implementation EventListViewController

@synthesize eventsTable, eventsSearchBar;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    blurView = nil;
    _navigationDropDown = nil;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStylePlain target:self action:@selector(loadDropDown)];
    
    self.selectedDay = @1;
    
    [self.daySelector removeAllSegments];
    [self.daySelector insertSegmentWithTitle:@"DAY 1" atIndex:0 animated:NO];
    [self.daySelector insertSegmentWithTitle:@"DAY 2" atIndex:1 animated:NO];
    [self.daySelector insertSegmentWithTitle:@"DAY 3" atIndex:2 animated:NO];
    [self.daySelector insertSegmentWithTitle:@"DAY 4" atIndex:3 animated:NO];
    
    
    
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
    
    return 20;
    
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
    cell.eventLabel.text =[NSString stringWithFormat:@"Event NAME %@", self.selectedDay];
    
    cell.categoryLabel.text = @"Category Name";
    
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
        return 218;
    
    else
        return 43;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView * blankView = [[UIView alloc]initWithFrame:CGRectZero];
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

- (IBAction)daySelectorIndexChanged:(id)sender
{
    
    //Stting day using the segmented controller.
    
    switch (self.daySelector.selectedSegmentIndex)
    {
        case 0:
            self.selectedDay = @1;
            break;
            
        case 1:
            self.selectedDay = @2;
            break;
            
        case 2:
            self.selectedDay = @3;
            break;
            
        case 3:
            self.selectedDay = @4;
            break;
        
        default:
            break;
            
    }
    
    [self.eventsTable reloadData];
}

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
        _navigationDropDown.frame = CGRectMake(190, 74, 128, 280);
        
        [self.view addSubview:_navigationDropDown];
        
        [_navigationDropDown.categoryButtonPressed addTarget:self action:@selector(categoryButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.eventButtonPressed addTarget:self action:@selector(eventButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.favouritesButtonPressed addTarget:self action:@selector(favouritesButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.resultsButtonPressed addTarget:self action:@selector(resultsButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.instafeedButtonPressed addTarget:self action:@selector(instafeedButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.aboutUsButtonPressed addTarget:self action:@selector(aboutUsButton) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}

- (void) categoryButton
{
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *eventListViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"categoryView"];
    [self presentViewController:eventListViewController animated:YES completion:nil];

}

- (void) eventButton
{
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *eventListViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"eventView"];
    [self presentViewController:eventListViewController animated:YES completion:nil];
    
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
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *eventListViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"resultsView"];
    [self presentViewController:eventListViewController animated:YES completion:nil];
    
}

- (void) instafeedButton
{
    
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *eventListViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"instagramView"];
    [self presentViewController:eventListViewController animated:YES completion:nil];
    
}

- (void) aboutUsButton
{
    
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *eventListViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"aboutUsView"];
    [self presentViewController:eventListViewController animated:YES completion:nil];
    
}

- (void) removeExtraViews
{
    
    [blurView removeFromSuperview];
    [_navigationDropDown removeFromSuperview];
    blurView = nil;
    _navigationDropDown = nil;
    
}

@end
