//
//  WebViewController.m
//  TechTatva15
//
//  Created by YASH on 21/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

- (IBAction)dismissVCBarButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)openInSafari:(id)sender;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    NSLog(@"URL : %@", self.url);
    [self.webViewOutlet loadRequest:urlRequest];
    self.webViewOutlet.frame = self.view.bounds;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark Segue Methods

- (IBAction) dismissVCBarButtonPressed:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction) openInSafari:(id)sender
{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.url]];
    
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
