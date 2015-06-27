//
//  CategoryEventViewTableViewCell.m
//  TechTatva15
//
//  Created by YASH on 27/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "CategoryEventViewTableViewCell.h"

@implementation CategoryEventViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)favouriteButtonPressed:(UIButton *)sender
{
    
    // Add to favourites
    // Dummy alert view added
    UIAlertView *dummyFavouriteAV = [[UIAlertView alloc] initWithTitle:@"Favourite" message:@"button check" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [dummyFavouriteAV show];
    
}
@end
