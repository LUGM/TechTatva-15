//
//  FullScreenImageViewController.h
//  TechTatva15
//
//  Created by YASH on 17/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScreenImageViewController : UIViewController <NSURLConnectionDelegate>

@property (strong,nonatomic) NSString * requiredUrl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
