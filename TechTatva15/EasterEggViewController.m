//
//  EasterEggViewController.m
//  TechTatva15
//
//  Created by YASH on 17/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "EasterEggViewController.h"

@interface EasterEggViewController ()

@end

@implementation EasterEggViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIAlertView *startAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"I solemnly swear that I am up to no good" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [startAlert show];
    
    _logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"linuxtux.png"]];
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    if (motion == UIEventSubtypeMotionShake)
    {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)gitButtonPressed:(id)sender
{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LUGM"]];
    
}

- (IBAction)facebookButtonPressed:(id)sender
{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/groups/lug2016/"]];
    
}

- (IBAction)siteLinkPressed:(id)sender
{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.lugmanipal.org"]];
    
}
@end
