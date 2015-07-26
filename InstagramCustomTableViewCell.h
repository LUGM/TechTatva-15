//
//  InstagramCustomTableViewCell.h
//  TechTatva15
//
//  Created by YASH on 14/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramCustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end
