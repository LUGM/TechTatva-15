//
//  eventViewTableViewCell.h
//  TechTatva15
//
//  Created by Sushant Gakhar on 26/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eventViewTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *eventLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UIImageView *venueImageView;
@property (strong, nonatomic) IBOutlet UILabel *venueLabel;
@property (strong, nonatomic) IBOutlet UIImageView *timeImageView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *dateImageView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *contactImageView;
@property (strong, nonatomic) IBOutlet UILabel *contactLabel;

@property (strong, nonatomic) IBOutlet UIButton *callButtonPressed;    // Button represented as 'CB'
@property (strong, nonatomic) IBOutlet UIButton *detailsButtonPressed; // Button represented as 'D'
@property (strong, nonatomic) IBOutlet UIButton *resultsButtonPressed; // Button represented as 'R'

@end
