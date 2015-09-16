//
//  AboutUsViewController.m
//  TechTatva15
//
//  Created by YASH on 17/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

# pragma mark - Button Methods

- (IBAction)facebookButtonPressed:(id)sender
{
    
    UIWebView *facebookLink = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [facebookLink loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.facebook.com"]]];
    [self.view addSubview:facebookLink];
    
}

- (IBAction)youtubeButtonPressed:(id)sender
{
    
    UIWebView *youtubeLink = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [youtubeLink loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.youtube.com"]]];
    [self.view addSubview:youtubeLink];
    
}

- (IBAction)twitterButtonPressed:(id)sender
{
    
    UIWebView *twitterLink = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [twitterLink loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.twitter.com"]]];
    [self.view addSubview:twitterLink];
    
}

- (IBAction)instaButtonPressed:(id)sender
{
    
    UIWebView *instaLink = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [instaLink loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.instagram.com"]]];
    [self.view addSubview:instaLink];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
