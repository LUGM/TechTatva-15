//
//  DevViewTableViewCell.h
//  TechTatva15
//
//  Created by YASH on 23/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DevViewTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *devImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *jobLabel;

@end
