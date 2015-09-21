//
//  CustomWebviewsViewController.m
//  TechTatva15
//
//  Created by Sushant Gakhar on 21/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "CustomWebviewsViewController.h"
#import "AboutUsViewController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"

@interface CustomWebviewsViewController ()

@end

@implementation CustomWebviewsViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *dismissVC = [[UIBarButtonItem alloc] init];
    dismissVC.target = self;
    dismissVC.action = @selector(dismissVCBarButtonPressed:);
    
//    NSNumber *flag;
    
    AboutUsViewController *detail = [[AboutUsViewController alloc] init];
    if ([detail.webviewNumber isEqualToString:@"Facebook"])
    {
     
        UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.facebook.com/MITtechtatva"]]];
        [self.view addSubview:webview];
//        self->webViewUrl = [NSURL URLWithString:@"https://www.facebook.com/MITtechtatva"];
        
    }
    else if ([detail.webviewNumber isEqualToString:@"Youtube"])
    {
        
//        flag = @2;
        UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/TechTatva"]]];
//        self->webViewUrl = [NSURL URLWithString:@"https://www.youtube.com/TechTatva"];
        
    }
    else if ([detail.webviewNumber isEqualToString:@"Instagram"])
    {
        
//        flag = @3;
        UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.instagram.com/MITtechtatva"]]];
//        self->webViewUrl = [NSURL URLWithString:@"https://www.instagram.com/MITtechtatva"];
        
    }
    else if ([detail.webviewNumber isEqualToString:@"Twitter"])
    {
        
//        flag = @4;
        UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.twitter.com/MITtechtatva"]]];
//        self->webViewUrl = [NSURL URLWithString:@"https://www.twitter.com/MITtechtatva"];
        
    }
    else if ([detail.webviewNumber isEqualToString:@"Gplus"])
    {
        
//        flag = @5;
        UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://plus.google.com/+techtatva"]]];
//       self-> webViewUrl = [NSURL URLWithString:@"https://plus.google.com/+techtatva"];
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark Connection Check

- (BOOL) isInternetAvailable
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
    
}

# pragma mark Segue Methods

- (IBAction)dismissVCBarButtonPressed:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
//    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    
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
