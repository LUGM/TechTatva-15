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
#import "DayView.h"

@interface EventListViewController ()

@property NSIndexPath *previousSelectedCellIndexPath;
@property NSIndexPath *currentSelectedCellIndexPath;
@property DayView *DayView;

@end

@implementation EventListViewController

@synthesize eventsTable, eventsSearchBar;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Load nib for DayView here. Still not loading in view though.
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DayView.xib" owner:self options:nil];
    _DayView = [nib objectAtIndex:0];
    _DayView.frame = CGRectMake(0, 64, 320, 50);
    _DayView.alpha = 0.85;
    
    // Add functionality i.e. change date when specific buttons are pressed
    
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
@end
