//
//  AboutUsViewController.h
//  TechTatva15
//
//  Created by YASH on 17/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController

- (IBAction)hamburgerLoader:(id)sender;

@property (strong, nonatomic) NSString *webviewNumber;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
