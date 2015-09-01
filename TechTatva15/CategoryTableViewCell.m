//
//  CategoryTableViewCell.m
//  check category view cells
//
//  Created by Sushant Gakhar on 27/06/15.
//  Copyright (c) 2015 Sushant Gakhar. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)favouritedButtonActionPressed:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"favouritePressed" object:self.indexPathForMyCell];
}
@end
