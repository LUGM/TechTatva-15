//
//  WebViewController.h
//  TechTatva15
//
//  Created by YASH on 21/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webViewOutlet;

@property (strong, nonatomic) NSString *url;

@end
