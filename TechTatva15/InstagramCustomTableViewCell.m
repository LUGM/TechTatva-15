//
//  InstagramCustomTableViewCell.m
//  TechTatva15
//
//  Created by YASH on 14/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "InstagramCustomTableViewCell.h"

@implementation InstagramCustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 5;
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}
@end