//
//  EasterEggViewController.h
//  TechTatva15
//
//  Created by YASH on 17/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EasterEggViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
- (IBAction)gitButtonPressed:(id)sender;
- (IBAction)facebookButtonPressed:(id)sender;

@end
