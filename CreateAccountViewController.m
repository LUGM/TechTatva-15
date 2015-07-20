//
//  CreateAccountViewController.m
//  TechTatva15
//
//  Created by Sushant Gakhar on 20/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "CreateAccountViewController.h"

@interface CreateAccountViewController ()

@end

@implementation CreateAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@"TITLE" message:@"Just being a little creative here. Maybe we can add some warnings/instructions for users entering the data. Or maybe just say hello. This alert view can easily be disabled" delegate:self cancelButtonTitle:@"Okay, got it!" otherButtonTitles: nil];
    [warning show];
    
    // Do any additional setup after loading the view.

    self.optionsPickerView.delegate = self;
    self.optionsPickerView.dataSource = self;
    self.genderTextLabel.delegate = self;
    self.cityTextLabel.delegate = self;
    self.collegeTextLabel.delegate = self;
    self.yearOfStudyTextLabel.delegate = self;
    
    self.optionsPickerView.hidden = YES;
    
    self.genderOptionsArray = @[@"Male", @"Female", @"Transgender"];
    self.yearOfStudyOptionsArray = @[@"1", @"2", @"3", @"4", @"5"];
   
    //Update the following arrays from backend; The following is dummy data.
    self.cityOptionsArray = @[@"City1", @"City2", @"City3"];
    self.collegeOptionsArray = @[@"College1", @"College2", @"College3"];
    
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    
    if([textField isEqual:self.genderTextLabel])
    {
        [textField resignFirstResponder];
        self.activeTextField = self.genderTextLabel;
        self.activeOptionsArray = self.genderOptionsArray;
    }
    
    else if([textField isEqual:self.cityTextLabel])
    {
        [textField resignFirstResponder];
        self.activeTextField = self.cityTextLabel;
        self.activeOptionsArray = self.cityOptionsArray;
    }
    
    else if([textField isEqual:self.collegeTextLabel])
    {
        [textField resignFirstResponder];
        self.activeTextField = self.collegeTextLabel;
        self.activeOptionsArray = self.collegeOptionsArray;
    }
    
    else if([textField isEqual:self.yearOfStudyTextLabel])
    {
        [textField resignFirstResponder];
        self.activeTextField = self.yearOfStudyTextLabel;
        self.activeOptionsArray = self.yearOfStudyOptionsArray;
    }
    
    [self.optionsPickerView reloadAllComponents];
    self.optionsPickerView.hidden = NO;
    self.optionsPickerView.hidden = NO;
    self.submitButtonObject.hidden = YES;
    
}




- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}





- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.activeOptionsArray count];
}





- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.activeOptionsArray[row];
}





-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    self.optionsPickerView.hidden = YES;
    self.submitButtonObject.hidden = NO;
    
    if([self.activeTextField isEqual:self.genderTextLabel])
    {
        self.genderTextLabel.text = self.activeOptionsArray[row];
    }
        
    if([self.activeTextField isEqual:self.cityTextLabel])
    {
        self.cityTextLabel.text = self.activeOptionsArray[row];
    }
    
    if([self.activeTextField isEqual:self.collegeTextLabel])
    {
        self.collegeTextLabel.text = self.collegeOptionsArray[row];
    }
    
    if([self.activeTextField isEqual: self.yearOfStudyTextLabel])
    {
        self.yearOfStudyTextLabel.text = self.yearOfStudyOptionsArray[row];
    }
}

    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitButtonPressed:(UIButton *)sender
{
    UIAlertView *incompleteDeatailsAlert = [[UIAlertView alloc] initWithTitle:@"Incomplete Details" message:@"Please enter all the details appropriately and then continue" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    
    
    if([self.nameTextField.text isEqual:@"" ]|| [self.emailTextLabel.text isEqual:@""] || [self.phoneNumberTextLabel.text isEqual:@""] || [self.genderTextLabel.text isEqual:@""] || [self.cityTextLabel.text isEqual:@""] || [self.collegeTextLabel.text isEqual:@""] || [self.yearOfStudyTextLabel.text isEqual:@""] )
    
        [incompleteDeatailsAlert show];
    
    else
    {
        self.name = self.nameTextField.text;
        self.email = self.emailTextLabel.text;
        self.phoneNumber = self.phoneNumberTextLabel.text;
        //DOB SAVING HERE
        self.city = self.cityTextLabel.text;
        self.college = self.collegeTextLabel.text;
        self.gender = self.genderTextLabel.text;
        self.yearOfStudy = self.yearOfStudyTextLabel.text;
    }
        
}
@end
