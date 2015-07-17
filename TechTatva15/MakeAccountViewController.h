//
//  MakeAccountViewController.h
//  TechTatva15
//
//  Created by YASH on 25/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakeAccountViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
    
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;


- (IBAction)registerButton:(UIButton *)sender;

@end
