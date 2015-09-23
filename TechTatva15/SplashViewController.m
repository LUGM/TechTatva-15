//
//  SplashViewController.m
//  TechTatva15
//
//  Created by YASH on 06/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height == 568.0) && ((IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale) || !IS_OS_8_OR_LATER))
#define IS_STANDARD_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0  && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale)
#define IS_ZOOMED_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale > [UIScreen mainScreen].scale)
#define IS_STANDARD_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_ZOOMED_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale < [UIScreen mainScreen].scale)

#import "SplashViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SplashViewController ()
{
    
    MPMoviePlayerController *mMoviePlayer;
    
}

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


// trying something but not quite pulling it off, can be ignored but refer to http://stackoverflow.com/questions/7051208/emulating-splash-video-in-ios-application, its pretty interesting

//- (void)applicationDidFinishLaunching:(UIApplication *)application {
//    NSURL* mMovieURL;
//    NSBundle *bundle = [NSBundle mainBundle];
//    if(bundle != nil)
//    {
//        NSString *moviePath = [bundle pathForResource:@"testvideo" ofType:@"mov"];
//        if (moviePath)
//        {
//            mMovieURL = [NSURL fileURLWithPath:moviePath];
//        }
//    }
//    
//    mMoviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:mMovieURL];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlayBackDidFinish)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:mMoviePlayer.moviePlayer];
//    mMoviePlayer.moviePlayer.controlStyle = MPMovieControlStyleNone;
//    [mMoviePlayer.moviePlayer.backgroundView  addSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Screen Shot 2015-05-29 at 10.53.25 am.png"]]]];
//    mMoviePlayer.moviePlayer.scalingMode = MPMovieScalingModeFill;
//    [mMoviePlayer.view addSubview:mMoviePlayer.moviePlayer.view];
//    [mMoviePlayer.moviePlayer setFullscreen:YES animated:NO];
//    [mMoviePlayer.moviePlayer play];
//}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:mMoviePlayer];
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSString * stringPath;

    if (IS_IPHONE_5) {
        stringPath = [[NSBundle mainBundle] pathForResource:@"iphone5" ofType:@"mov"];
    }
    else if (IS_STANDARD_IPHONE_6) {
        stringPath = [[NSBundle mainBundle] pathForResource:@"iphone6" ofType:@"mov"];
    }
    else if (IS_STANDARD_IPHONE_6_PLUS) {
        stringPath = [[NSBundle mainBundle] pathForResource:@"iphone6p" ofType:@"mov"];
    }
    else {
        stringPath = [[NSBundle mainBundle] pathForResource:@"iphone4" ofType:@"mov"];
    }
    
    NSURL * fileUrl = [NSURL fileURLWithPath:stringPath];
    mMoviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:fileUrl];
    [mMoviePlayer setMovieSourceType:MPMovieSourceTypeFile];
    [mMoviePlayer.view setFrame:self.view.frame];
    [mMoviePlayer setFullscreen:YES];
    [mMoviePlayer setScalingMode:MPMovieScalingModeFill];
    [mMoviePlayer setControlStyle:MPMovieControlStyleNone];
    [self.view addSubview:mMoviePlayer.view];
    [mMoviePlayer play];

}


-(UIStatusBarStyle)preferredStatusBarStyle
{

    return UIStatusBarStyleLightContent;

}


-(void)playbackFinished
{
    
    [self performSegueWithIdentifier:@"FirstView" sender:self];       // segue into first view (still to be decided)
    
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
