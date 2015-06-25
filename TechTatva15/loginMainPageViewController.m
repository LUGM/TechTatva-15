//
//  loginMainPageViewController.m
//  TechTatva15
//
//  Created by YASH on 07/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

// FILE TO BE DELETED.

#import "loginMainPageViewController.h"

@interface loginMainPageViewController ()

@end

@implementation loginMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookLoginPressed:(UIButton *)sender
{
    
    /* call facebook login webview
     i have an idea to call parse framework, store all received data into variables
     and then send it to custom backend to store */
    
}

- (IBAction)googleLoginPressed:(UIButton *)sender
{

    /* look up google+ login implementation in https://developers.google.com/+/mobile/ios/getting-started, store all received data into variables
     and then send it to custom backend to store */

}

- (IBAction)emailLoginPressed:(UIButton *)sender
{

    /* this feature will check if user entered email and password (or whatever kartik has thought up as an identifier)
     exists in backend storage and then allow user who has made account using the create account feature to login
     STEP 1: first only enter email field will be shown
     STEP 2: then when it is filled it will be sent for a validity check to custom backend
     STEP 3: if email is authenticated by backend, a password entry field appears
     STEP 4: user enters password into this field which is again sent to backend for verification
     STEP 5: if password is correct, login or else display error message as 'wrong password' */

}

- (IBAction)createAccountPressed:(UIButton *)sender
{

    // use either a segue or link button directly in storyboard to a new view which can collect user details //

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
