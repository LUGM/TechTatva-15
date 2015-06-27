//
//  eventViewTableViewCell.m
//  TechTatva15
//
//  Created by Sushant Gakhar on 26/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "eventViewTableViewCell.h"

@implementation eventViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)detailsButtonPressed:(UIButton *)sender
{
    UIAlertView *details = [[UIAlertView alloc] initWithTitle:@"Details" message:@"Put in all data for details from data source" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [details show];
}

- (IBAction)resultsButtonPressed:(UIButton *)sender
{
    UIAlertView *results = [[UIAlertView alloc] initWithTitle:@"Results" message:@"Displays results from all rounds here" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    
    [results show];
    
    //Data to be displayed according to the rounds that have taken place
}

- (IBAction)callButtonPressed:(UIButton *)sender
{
    
}
@end
