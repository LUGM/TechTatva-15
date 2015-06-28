//
//  SplashViewController.m
//  TechTatva15
//
//  Created by YASH on 06/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

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
    
    NSString * stringPath = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mov"];
    
    NSURL * fileUrl = [NSURL fileURLWithPath:stringPath];
    mMoviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:fileUrl];
    [mMoviePlayer setMovieSourceType:MPMovieSourceTypeFile];
    [mMoviePlayer.view setFrame:CGRectMake(0,0,375,640)];                    //check dimensions once again
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
    
    [self performSegueWithIdentifier:@"firstView" sender:self];       // segue into first view (still to be decided)
    
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
