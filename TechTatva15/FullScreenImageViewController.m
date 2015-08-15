//
//  FullScreenImageViewController.m
//  TechTatva15
//
//  Created by YASH on 17/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "FullScreenImageViewController.h"
#import "MBProgressHUD.h"

@interface FullScreenImageViewController () <MBProgressHUDDelegate>
{
    MBProgressHUD * hud;
}

@property (nonatomic) NSMutableData *imageData;
@property (nonatomic) NSUInteger totalBytes;
@property (nonatomic) NSUInteger receivedBytes;

@property (nonatomic, strong) UIImageView *imageView;

- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;

@end

@implementation FullScreenImageViewController

- (void) viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor orangeColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 2.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveImage)];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    self.scrollView.backgroundColor = [UIColor blackColor];
    [self sendRequestWithUrl:[NSURL URLWithString:_requiredUrl]];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
    [self.scrollView addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) saveImage
{
    
    if (_imageView.image == nil)
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Loading" message:@"Wait for the Image to load" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    else
    {
        
        UIImage* imageToSave = [_imageView image]; // alternatively, imageView.image
        
        // Save it to the camera roll / saved photo album
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil);
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Done" message:@"Saved in Photo Library" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}



- (void) singleTap
{
    
    if (self.navigationController.navigationBar.hidden == YES)
    {
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    }
    else
    {
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
    }
    
}

- (void) sendRequestWithUrl:(NSURL*)Url
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.scrollView animated:YES];
    hud.delegate = self;
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    NSURLRequest * request = [NSURLRequest requestWithURL:Url];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    
}

#pragma mark - Add the image

- (void) addTheImage
{
    
    // 1
    UIImage *image = [UIImage imageWithData:_imageData];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
    self.imageView.center = self.navigationController.view.center;
    [self.scrollView addSubview:self.imageView];
    
    // 2
    self.scrollView.contentSize = image.size;
    
    // 3
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
    
    
    // 4
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    
    // 5
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = minScale;
    
    // 6
    [self centerScrollViewContents];
    
}

- (void) centerScrollViewContents
{
    
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width)
    {
        
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
        
    }
    
    else
    {
        
        contentsFrame.origin.x = 0.0f;
    
    }
    
    if (contentsFrame.size.height < boundsSize.height)
    {
        
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    
    }
    
    else
    {
        
        contentsFrame.origin.y = 0.0f;
    
    }
    
    self.imageView.frame = contentsFrame;
    
}

- (void) scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer
{
    
    // 1
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    // 2
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    // 3
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // 4
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
    
}

- (void) scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer
{
    
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
    
}

- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    // Return the view that you want to zoom
    return self.imageView;
    
}

#pragma mark NSURLConnection Delegate Methods

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *dict = httpResponse.allHeaderFields;
    NSString *lengthString = [dict valueForKey:@"Content-Length"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *length = [formatter numberFromString:lengthString];
    self.totalBytes = length.unsignedIntegerValue;
    
    self.imageData = [[NSMutableData alloc] initWithCapacity:self.totalBytes];
    
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    // Append the new data to the instance variable you declared
    [self.imageData appendData:data];
    self.receivedBytes += data.length;
    hud.progress = (float)self.receivedBytes/self.totalBytes;
    
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    [self addTheImage];
    [hud hide:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    // The request has failed for some reason!
    // Check the error var
    
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
