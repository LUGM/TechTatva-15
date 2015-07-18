//
//  EmailSignInTableViewController.h
//  TechTatva15
//
//  Created by YASH on 18/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailSignInTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)signInButton:(UIButton *)sender;

@end
