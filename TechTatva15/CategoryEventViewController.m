//
//  CategoryEventViewController.m
//  TechTatva15
//
//  Created by YASH on 04/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

// Fix placement of table view in this. Problem is visible when it runs

#import "CategoryEventViewController.h"

@interface CategoryEventViewController ()

@property NSIndexPath *previousSelectedCellIndexPath;
@property NSIndexPath *currentSelectedCellIndexPath;

@end

@implementation CategoryEventViewController

@synthesize categoryEventTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    Load nib for DayView here.
    //    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DayView" owner:self options:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark UITableView Data Source Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return  1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  20;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellIdentifier = @"Cell";
    
     CategoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"CategoryTableViewCell" owner:self options:nil];
    
    cell = [nib objectAtIndex:0];
    cell.indexPathForCell = indexPath;
    
    
    cell.eventNameLabel.text = [NSString stringWithFormat:@"Event No. %li", ((long)indexPath.row + 1)];
    cell.eventDetailsTextView.text = @"Details go here";
    return cell;
    
}


# pragma mark UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.previousSelectedCellIndexPath = self.currentSelectedCellIndexPath;  // <- save previously selected cell
    self.currentSelectedCellIndexPath = indexPath;
    if (self.previousSelectedCellIndexPath && !([self.previousSelectedCellIndexPath compare:self.currentSelectedCellIndexPath] == NSOrderedSame)) { // <- reload previously selected cell (if not nil)
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.previousSelectedCellIndexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if ((self.previousSelectedCellIndexPath)&&[self.previousSelectedCellIndexPath compare:self.currentSelectedCellIndexPath] == NSOrderedSame){
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.currentSelectedCellIndexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.currentSelectedCellIndexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (([self.currentSelectedCellIndexPath compare:indexPath] == NSOrderedSame)&& ([self.currentSelectedCellIndexPath compare:self.previousSelectedCellIndexPath]==NSOrderedSame)) {
        return 40;
    }
    else if(self.currentSelectedCellIndexPath != nil
            && [self.currentSelectedCellIndexPath compare:indexPath] == NSOrderedSame)
        return 250;
    
    else
        return 40;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
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

@end
