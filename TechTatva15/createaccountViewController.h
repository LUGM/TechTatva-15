//
//  createaccountViewController.h
//  TechTatva15
//
//  Created by YASH on 07/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface createaccountViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *phoneNumberTextField;
    IBOutlet UITextField *genderTextField;
    
}
@property (weak, nonatomic) IBOutlet UIButton *genderButtonPressed;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerGender;


@end