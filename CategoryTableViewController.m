//
//  CategoryTableViewController.m
//  check category view cells
//
//  Created by Sushant Gakhar on 27/06/15.
//  Copyright (c) 2015 Sushant Gakhar. All rights reserved.
//

#import "CategoryTableViewController.h"

@interface CategoryTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSIndexPath *currentSelectedCellIndexPath;
@property NSIndexPath *previousSelectedCellIndexPath;

@end

@implementation CategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    self.previousSelectedCellIndexPath = self.currentSelectedCellIndexPath;  // <- save previously selected cell
    self.currentSelectedCellIndexPath = indexPath;
    if (self.previousSelectedCellIndexPath && !([self.previousSelectedCellIndexPath compare:self.currentSelectedCellIndexPath] == NSOrderedSame)) { // <- reload previously selected cell (if not nil)
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.previousSelectedCellIndexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if ((self.previousSelectedCellIndexPath)&&[self.previousSelectedCellIndexPath compare:self.currentSelectedCellIndexPath] == NSOrderedSame){
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.currentSelectedCellIndexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.currentSelectedCellIndexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (([self.currentSelectedCellIndexPath compare:indexPath] == NSOrderedSame)&& ([self.currentSelectedCellIndexPath compare:self.previousSelectedCellIndexPath]==NSOrderedSame)) {
        return 40;
    }
    else if(self.currentSelectedCellIndexPath != nil
            && [self.currentSelectedCellIndexPath compare:indexPath] == NSOrderedSame)
        return 250;
    
    else
        return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * blankView = [[UIView alloc]initWithFrame:CGRectZero];
    
    return blankView;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    
   CategoryTableViewCell * cell = (CategoryTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"CategoryTableViewCell" owner:self options:nil];
    
    cell = [nib objectAtIndex:0];
    cell.indexPathForCell = indexPath;
    
    
    cell.eventNameLabel.text = [NSString stringWithFormat:@"Event No. %li", ((long)indexPath.row + 1)];
    cell.eventDetailsTextView.text = @"Details go here";
      return cell;
}



- (IBAction)developDetailsButtonPressed:(id)sender
{
    //Segue from here to developer page.
}
@end
