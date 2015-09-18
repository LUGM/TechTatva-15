//
//  AboutUsViewController.m
//  TechTatva15
//
//  Created by YASH on 17/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "AboutUsViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "RESideMenu.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self loadActualView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _aboutUsTextField.text = [NSString stringWithFormat:@"TechTatva is the annual, student run, National Level Technical Fest of Manipal Institue of Technology, Manipal. It is one of the largest technical fests of the South Zone of the country, witnessing participation from various prestigious institutes from across the nation. TechTatva comprises of a plethora of events, ranging across the various branches of engineering.\n\nFrugal Innovation – Do More with Less, the theme for this year seeks to extend the mindset of Jugaad, derived from the common Indian experience of innovating frugal, homespun, and simple solutions to the myriad problems that beset everyday life. This October 7th to 10th, TechTatva'15 aims to bear witness to a revamped Jugaadu methodology."];
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

# pragma mark - Button Methods

- (IBAction)facebookButtonPressed:(id)sender
{
    
    if ([self isInternetAvailable])
    {
        
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [self facebookWebView];
        
    }
    else
    {
        
        UIAlertView *noNetAlert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Data connection unavailable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noNetAlert show];
        
    }
    
}

- (IBAction)youtubeButtonPressed:(id)sender
{
    
    if ([self isInternetAvailable])
    {
        
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [self youtubeWebView];
        
    }
    else
    {
        
        UIAlertView *noNetAlert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Data connection unavailable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noNetAlert show];
        
    }
    
}

- (IBAction)twitterButtonPressed:(id)sender
{
    
    if ([self isInternetAvailable])
    {
        
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [self twitterWebView];
        
    }
    else
    {
        
        UIAlertView *noNetAlert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Data connection unavailable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noNetAlert show];
        
    }
}

- (IBAction)gPlusButtonPressed:(id)sender
{
    
    if ([self isInternetAvailable])
    {
        
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [self gPlusWebView];
        
    }
    else
    {
        
        UIAlertView *noNetAlert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Data connection unavailable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noNetAlert show];
        
    }
}

- (IBAction)instaButtonPressed:(id)sender
{
    
    if ([self isInternetAvailable])
    {
        
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [self instaWebView];
        
    }
    else
    {
        
        UIAlertView *noNetAlert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Data connection unavailable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noNetAlert show];
        
    }
}

//- (void) loadActualView
//{
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    _aboutUsTextField.text = [NSString stringWithFormat:@"TechTatva is the annual, student run, National Level Technical Fest of Manipal Institue of Technology, Manipal. It is one of the largest technical fests of the South Zone of the country, witnessing participation from various prestigious institutes from across the nation. TechTatva comprises of a plethora of events, ranging across the various branches of engineering.\n\nFrugal Innovation – Do More with Less, the theme for this year seeks to extend the mindset of Jugaad, derived from the common Indian experience of innovating frugal, homespun, and simple solutions to the myriad problems that beset everyday life. This October 7th to 10th, TechTatva'15 aims to bear witness to a revamped Jugaadu methodology."];
//    
//}

- (void) facebookWebView
{
    
    UIWebView *facebookLink = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [facebookLink loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.facebook.com/MITtechtatva"]]];
    [self.view addSubview:facebookLink];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    
}

- (void) instaWebView
{
    
    UIWebView *instaLink = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [instaLink loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.instagram.com/MITtechtatva"]]];
    [self.view addSubview:instaLink];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    
}

- (void) youtubeWebView
{
    
    UIWebView *youtubeLink = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [youtubeLink loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/TechTatva"]]];
    [self.view addSubview:youtubeLink];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    
}

- (void) twitterWebView
{
    
    UIWebView *twitterLink = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [twitterLink loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.twitter.com/MITtechtatva"]]];
    [self.view addSubview:twitterLink];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    
}

- (void) gPlusWebView
{
    
    UIWebView *gPlusLink = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [gPlusLink loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://plus.google.com/+techtatva"]]];
    [self.view addSubview:gPlusLink];
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
