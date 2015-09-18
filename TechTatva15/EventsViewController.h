//
//  EventsViewController.h
//  TechTatva15
//
//  Created by YASH on 19/08/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UITableView *eventTable;

@property (strong, nonatomic) NSNumber *daySelected;

@property (strong, nonatomic) NSIndexPath *selectedCellIndex;

@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) NSMutableArray *searchResultsResult;  //   result of event that has been searched
@property BOOL areResultsFiltered;

- (IBAction)hamburgerLoader:(id)sender;


@end
