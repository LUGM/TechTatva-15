//
//  RegisterViewController.m
//  TechTatva15
//
//  Created by YASH on 17/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "RegisterViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "RESideMenu.h"
#import <Parse/Parse.h>

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    if ([self isInternetAvailable])
    {
        
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [PFConfig getConfigInBackgroundWithBlock:^(PFConfig * config, NSError * error){
            NSLog(@"CATEGORY URL : %@", config[@"register"]);
            [self loadWebView:config[@"register"]];
        }];
        
    }
    else
    {
        
        UIAlertView *noNetAlert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Data connection unavailable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noNetAlert show];
        self.view.backgroundColor = [UIColor grayColor];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void) loadWebView :(NSString*)registerURL
{
    
    UIWebView *registerWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [registerWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:registerURL]]];
    [self.view addSubview:registerWebView];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    
}

# pragma mark Connection Check

- (BOOL) isInternetAvailable
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)hamburgerLoader:(id)sender
{
    
    [self presentLeftMenuViewController:self];
    
}
@end
