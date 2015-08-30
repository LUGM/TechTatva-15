//
//  EventsViewController.h
//  TechTatva15
//
//  Created by YASH on 19/08/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *eventTable;

@property (strong, nonatomic) NSNumber *daySelected;

@property (strong, nonatomic) NSIndexPath *selectedCellIndex;

@end
