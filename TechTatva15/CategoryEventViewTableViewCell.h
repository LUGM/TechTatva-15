//
//  CategoryEventViewTableViewCell.h
//  TechTatva15
//
//  Created by YASH on 27/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryEventViewTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *eventNameLabel;

@property (strong, nonatomic) IBOutlet UITextView *eventDetailsTextView;

@property (strong, nonatomic) NSIndexPath *cellIndexPath;

- (IBAction)favouriteButtonPressed:(UIButton *)sender;

@end
