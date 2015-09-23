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
#import "SocialView.h"
#import "WebViewController.h"

@interface AboutUsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property NSString * aboutUsString;
@property SocialView *buttons;
@property NSString * passURL;

@end

@implementation AboutUsViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    _aboutUsString = [NSString stringWithFormat:@"TechTatva is the annual, student run, National Level Technical Fest of Manipal Institue of Technology, Manipal. It is one of the largest technical fests of the South Zone of the country, witnessing participation from various prestigious institutes from across the nation. TechTatva comprises of a plethora of events, ranging across the various branches of engineering.\n\nFrugal Innovation – Do More with Less, the theme for this year seeks to extend the mindset of Jugaad, derived from the common Indian experience of innovating frugal, homespun, and simple solutions to the myriad problems that beset everyday life. This October 7th to 10th, TechTatva'15 aims to bear witness to a revamped Jugaadu methodology."];
    
    self.myTableView.backgroundColor = UIColorFromRGB(0xECF0F1);
    self.myTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 2.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
    
    self.myTableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

# pragma mark - Button Methods

- (void) facebookButton
{
    
    if ([self isInternetAvailable])
    {
        
        _passURL = @"https://www.facebook.com/MITtechtatva";
        [self performSegueWithIdentifier:@"customWebview" sender:self];
    }
    else
    {
        
        UIAlertView *noNetAlert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Data connection unavailable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noNetAlert show];
        
    }
    
}

- (void) youtubeButton 
{
    
    if ([self isInternetAvailable])
    {
        
        _passURL = @"https://www.youtube.com/TechTatva";
        [self performSegueWithIdentifier:@"customWebview" sender:self];
        
    }
    else
    {
        
        UIAlertView *noNetAlert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Data connection unavailable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noNetAlert show];
        
    }
    
}

- (void) twitterButton
{
    
    if ([self isInternetAvailable])
    {
        
        _passURL = @"https://www.twitter.com/MITtechtatva";
        [self performSegueWithIdentifier:@"customWebview" sender:self];
        
    }
    else
    {
        
        UIAlertView *noNetAlert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Data connection unavailable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noNetAlert show];
        
    }
}

- (void) gPlusButton
{
    
    if ([self isInternetAvailable])
    {
        
        _passURL = @"https://plus.google.com/+techtatva";
        [self performSegueWithIdentifier:@"customWebview" sender:self];
        
    }
    else
    {
        
        UIAlertView *noNetAlert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Data connection unavailable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noNetAlert show];
        
    }
}

- (void) instaButton 
{
    
    if ([self isInternetAvailable])
    {
        
        _passURL = @"https://www.instagram.com/MITtechtatva";
        [self performSegueWithIdentifier:@"customWebview" sender:self];
        
    }
    else
    {
        
        UIAlertView *noNetAlert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Data connection unavailable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noNetAlert show];
        
    }
    
}

# pragma mark Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellIdentifier = @"Cell";

    
    if (indexPath.section == 0)
    {
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.textLabel.text = _aboutUsString;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:18];
        return cell;
        
    }
    else if (indexPath.section == 1)
    {
        
        SocialView * cell = (SocialView*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SocialView" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell.facebookButton addTarget:self action:@selector(facebookButton) forControlEvents:UIControlEventTouchUpInside];
        [cell.instaButton addTarget:self action:@selector(instaButton) forControlEvents:UIControlEventTouchUpInside];
        [cell.gPlusButton addTarget:self action:@selector(gPlusButton) forControlEvents:UIControlEventTouchUpInside];
        [cell.twitterButton addTarget:self action:@selector(twitterButton) forControlEvents:UIControlEventTouchUpInside];
        [cell.youtubeButton addTarget:self action:@selector(youtubeButton) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }

    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = 0.0;
    if (indexPath.section == 0)
    {
        
        UILabel * label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.font = [UIFont fontWithName:@"Helvetica Neue Light" size:18];
        label.text = _aboutUsString;
        CGRect labelFrame = label.frame;
        labelFrame.size.width = _myTableView.frame.size.width;
        label.frame = labelFrame;
        [label sizeToFit];
        height = label.frame.size.height + 80;
        
    }
    
    if (indexPath.section == 1)
    {
        
        height = 75;
        
    }
    
    return height;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

        UIView * blank = [[UIView alloc] initWithFrame:CGRectZero];
        return blank;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 0;
    }
    return 20;
}
//- (void) loadActualView
//{
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    _aboutUsTextField.text = [NSString stringWithFormat:@"TechTatva is the annual, student run, National Level Technical Fest of Manipal Institue of Technology, Manipal. It is one of the largest technical fests of the South Zone of the country, witnessing participation from various prestigious institutes from across the nation. TechTatva comprises of a plethora of events, ranging across the various branches of engineering.\n\nFrugal Innovation – Do More with Less, the theme for this year seeks to extend the mindset of Jugaad, derived from the common Indian experience of innovating frugal, homespun, and simple solutions to the myriad problems that beset everyday life. This October 7th to 10th, TechTatva'15 aims to bear witness to a revamped Jugaadu methodology."];
//    
//}

//- (void) facebookWebView
//{
//    
//    UIWebView *facebookLink = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    [facebookLink loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.facebook.com/MITtechtatva"]]];
//    [self.view addSubview:facebookLink];
//    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
//    
//}
//
//- (void) instaWebView
//{
//    
//    UIWebView *instaLink = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    [instaLink loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.instagram.com/MITtechtatva"]]];
//    [self.view addSubview:instaLink];
//    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
//    
//}
//
//- (void) youtubeWebView
//{
//    
//    UIWebView *youtubeLink = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    [youtubeLink loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/TechTatva"]]];
//    [self.view addSubview:youtubeLink];
//    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
//    
//}
//
//- (void) twitterWebView
//{
//    
//    UIWebView *twitterLink = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    [twitterLink loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.twitter.com/MITtechtatva"]]];
//    [self.view addSubview:twitterLink];
//    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
//    
//}
//
//- (void) gPlusWebView
//{
//    
//    UIWebView *gPlusLink = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    [gPlusLink loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://plus.google.com/+techtatva"]]];
//    [self.view addSubview:gPlusLink];
//    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
//    
//}

# pragma mark Connection Check

- (BOOL) isInternetAvailable
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
    
}


# pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"customWebview"])
    {
        UINavigationController *navController = segue.destinationViewController;
        WebViewController * destination = [navController viewControllers][0];
        destination.url = _passURL;
    }
}

- (IBAction)hamburgerLoader:(id)sender
{
    
    [self presentLeftMenuViewController:self];
    
}
@end
