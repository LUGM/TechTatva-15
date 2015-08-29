//
//  CategoryTableViewCell.h
//  check category view cells
//
//  Created by Sushant Gakhar on 27/06/15.
//  Copyright (c) 2015 Sushant Gakhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *eventDetailsTextView;

@property (strong, nonatomic) IBOutlet UIButton *favouritesButton;

@property (strong, nonatomic) NSIndexPath *indexPathForCell; //For managing data.

@end
