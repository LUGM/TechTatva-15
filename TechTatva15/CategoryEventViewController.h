//
//  CategoryEventViewController.h
//  TechTatva15
//
//  Created by YASH on 04/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryTableViewCell.h"

@interface CategoryEventViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *categoryEventTable;
@property (strong, nonatomic) NSNumber *selectedDay;
@property (strong, nonatomic) IBOutlet UISegmentedControl *daySelector;

- (IBAction)daySelectorIndexChanged:(id)sender;

@end
