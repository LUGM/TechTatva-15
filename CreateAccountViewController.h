//
//  CreateAccountViewController.h
//  TechTatva15
//
//  Created by Sushant Gakhar on 20/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateAccountViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextLabel;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextLabel;
@property (strong, nonatomic) IBOutlet UITextField *dateOfBirthTextLabel;
@property (strong, nonatomic) IBOutlet UITextField *genderTextLabel;
@property (strong, nonatomic) IBOutlet UITextField *cityTextLabel;
@property (strong, nonatomic) IBOutlet UITextField *collegeTextLabel;
@property (strong, nonatomic) IBOutlet UITextField *yearOfStudyTextLabel;

@property (strong, nonatomic) IBOutlet UIPickerView *optionsPickerView;

@property (strong, nonatomic) IBOutlet UIButton *submitButtonObject;

//DATA ARRAYS

@property (strong, nonatomic) NSArray *genderOptionsArray;
@property (strong, nonatomic) NSArray *cityOptionsArray;
@property (strong, nonatomic) NSArray *collegeOptionsArray;
@property (strong, nonatomic) NSArray *yearOfStudyOptionsArray;

//Misc Objects

@property (weak, nonatomic) UITextField *activeTextField;
@property (weak, nonatomic) NSArray *activeOptionsArray;

//OBJECTS FOR DATA COLLECTION

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *college;
@property (strong, nonatomic) NSString *yearOfStudy;
@property (strong, nonatomic) NSDate *dateOfBirth;

- (IBAction)submitButtonPressed:(UIButton *)sender;


@end
