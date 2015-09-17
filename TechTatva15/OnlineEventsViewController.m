//
//  OnlineEventsViewController.m
//  TechTatva15
//
//  Created by YASH on 17/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "OnlineEventsViewController.h"

@interface OnlineEventsViewController ()

@end

@implementation OnlineEventsViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView *onlineEventsWebview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [onlineEventsWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://techtatva.in"]]];
    [self.view addSubview:onlineEventsWebview];
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
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
