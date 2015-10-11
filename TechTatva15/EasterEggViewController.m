//
//  EasterEggViewController.m
//  TechTatva15
//
//  Created by YASH on 17/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "EasterEggViewController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "AudioController.h"

@interface EasterEggViewController ()

@property (strong, nonatomic) AudioController *audioController;

@end

@implementation EasterEggViewController

/// There is a much easier method of adding and playing music (can be done in 10 lines, max), but I was getting an error at the time I started implementing it. Now, I realise what my mistake was, but I am too lazy to change it to a smaller implementation.

/// Check www.stackoverflow.com/questions/3631353/iphone-ipod-loop-background-music for that, and define an NSError object beforehand, if you use that code.

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _logoImage.image = [UIImage imageNamed:@"linuxtux.png"];
    self.backgroundImage.image = [UIImage imageNamed:@"devimg.png"];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    self.audioController = [[AudioController alloc] init];
    [self.audioController tryPlayMusic];
    
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
    
    if ([self isInternetAvailable])
    {
        
        [self loadGit];
        
    }
    else
    {
        
        UIAlertView *noNetAlert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Data connection unavailable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noNetAlert show];
        
    }
    
}

- (IBAction)facebookButtonPressed:(id)sender
{
    
    if ([self isInternetAvailable])
    {
        
        [self loadFacebook];
        
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
        
        [self loadYoutube];
        
    }
    else
    {
        
        UIAlertView *noNetAlert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Data connection unavailable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noNetAlert show];
        
    }
    
}

- (void) loadFacebook
{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/groups/lug2016/"]];
    [self.audioController pauseAudio];
    
}

- (void) loadGit
{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LUGM"]];
    [self.audioController pauseAudio];
    
}

- (void) loadYoutube
{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/watch?v=5Wqx5_2tSCM"]];
    [self.audioController pauseAudio];
    
}

- (BOOL) isInternetAvailable
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
    
}
@end
