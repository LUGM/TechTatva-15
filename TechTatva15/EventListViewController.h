//
//  EventListViewController.h
//  TechTatva15
//
//  Created by YASH on 04/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventViewTableViewCell.h"
#import "DayView.h"

@interface EventListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *eventsTable;
@property (weak, nonatomic) IBOutlet UISearchBar *eventsSearchBar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *daySelector;

@property (strong, nonatomic) NSNumber *selectedDay;

- (IBAction)daySelectorIndexChanged:(id)sender;

@end