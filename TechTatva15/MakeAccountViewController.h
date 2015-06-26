//
//  MakeAccountViewController.h
//  TechTatva15
//
//  Created by YASH on 25/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakeAccountViewController : UITableViewController
{
    
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *phoneTextField;
    
}

- (IBAction)registerButton:(UIButton *)sender;

@end
