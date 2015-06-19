//
//  createaccountViewController.m
//  TechTatva15
//
//  Created by YASH on 07/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "createaccountViewController.h"

@interface createaccountViewController ()<UIActionSheetDelegate, UITextFieldDelegate>
{
    
    UIActionSheet *pickerViewActionSheet;
    UIDatePicker *datePicker;
    UIToolbar *pickerToolbar;
    UIView *dateView;
    
}

@property (strong, nonatomic) IBOutlet UITextField *dateOfBirthTextField;
@property (strong, nonatomic) NSArray *genderPickerArray;
@property (strong, nonatomic) NSArray *collegePickerArray;
@property (strong, nonatomic) NSArray *cityPickerArray;
@property (strong, nonatomic) NSArray *yearOfStudyPickerArray;

@end




/* only gender picker has been implemented even that doesnt work for some reason. implement the rest by adding them to storyboard and linking to view controller then defining data source and delegate protocols for each of them individually.
 youtube video that could help is at https://www.youtube.com/watch?v=BtmQp5aP304
 
 plus date time picker still has to be implemented that hasn't been done
 some resources for that are http://stackoverflow.com/questions/26796302/how-to-implement-date-picker-on-button-click-in-ios
 and http://stackoverflow.com/questions/24673349/uidatepicker-is-not-visible-in-ios-8
 look for youtube videos for stuff like this as well */

@implementation createaccountViewController



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.dateOfBirthTextField){
        [textField resignFirstResponder];
        float platformVersion = 8.0;
        
        
        //Check for iOS 8.0+
        if([[[UIDevice currentDevice] systemVersion] floatValue ] >= platformVersion)
        {
            
            
            // iOS8 DatePicker view implementation
            dateView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2.0, 320, 640)];
            pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
            pickerToolbar.barStyle=UIBarStyleBlackOpaque;
            [pickerToolbar sizeToFit];
            NSMutableArray *barItems = [[NSMutableArray alloc] init];
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dateChosen:)];
            [barItems addObject:barButtonItem];
            barButtonItem.tag = 123;
            [pickerToolbar setItems:barItems animated:YES];
            [dateView addSubview:pickerToolbar];
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 320.0, 300.0)];
            datePicker.datePickerMode = UIDatePickerModeDate;
            [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
            datePicker.backgroundColor = [UIColor whiteColor];
            [dateView addSubview:datePicker];
            
            
            [self.view addSubview:dateView];
            
        }
        else
        {
            
            //Pre iOS8.0 DatePicker implementation.
            datePicker = [[UIDatePicker alloc] init];
            
            pickerViewActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select the date!"
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:nil];
            
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 320.0, 300.0)];
            datePicker.datePickerMode = UIDatePickerModeDate;
            [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
            datePicker.tag = -1;
            pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
            pickerToolbar.barStyle=UIBarStyleBlackOpaque;
            [pickerToolbar sizeToFit];
            NSMutableArray *barItems = [[NSMutableArray alloc] init];
            UIBarButtonItem *batButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked)];
            [barItems addObject:batButtonItem];
            
            [pickerToolbar setItems:barItems animated:YES];
            [pickerViewActionSheet addSubview:pickerToolbar];
            [pickerViewActionSheet addSubview:datePicker];
            [pickerViewActionSheet showInView:self.view];
            [pickerViewActionSheet setBounds:CGRectMake(0,0,320, 464)];
            
        }
        
    }
}


//iOS8.0+ when the date has chosen, remove the corresponding view from the parent view.

-(void) dateChosen:(UIBarButtonItem *) barButton
{
    if(barButton.tag == 123)
    {
        [dateView removeFromSuperview];
        
    }
    
}


//Get the chosen date from the UIDatePicker to the corresponding UITextField.

-(void)dateChanged
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.dateOfBirthTextField.text = [dateFormatter stringFromDate:[datePicker date]];
}


//Pre iOS8.0 for closing the actionsheet

-(BOOL)closeDatePicker:(id)sender
{
    [pickerViewActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [self.dateOfBirthTextField resignFirstResponder];
    return YES;
}


//Pre iOS8.0

-(void)doneButtonClicked
{
    [self closeDatePicker:self];
}




- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // different data to be entered into a variety of pickers is defined here
    
    NSArray *genderData = [[NSArray alloc] initWithObjects:@"Male", @"Female", @"Other", nil];
    self.genderPickerArray = genderData;
    
    NSArray *collegeData = [[NSArray alloc] initWithObjects:@"Manipal Institute of Technology", @"Kasturba Medical College", nil];
    self.collegePickerArray = collegeData;
    
    NSArray *yearOfStudy = [[NSArray alloc] initWithObjects:@"First Year", @"Second Year", @"Third Year", @"Fourth Year", nil];
    self.yearOfStudyPickerArray = yearOfStudy;
    
    NSArray *cityOfOrigin = [[NSArray alloc] initWithObjects:@"Bangalore", @"Chennai", @"Hyderabad", @"Kolkata", @"Jamshedpur", @"Manipal", @"Mumbai", @"New Delhi", @"Patna", @"Varanasi", nil];
    self.cityPickerArray = cityOfOrigin;
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)registerPressed:(UIButton *)sender
{
    
    /* all the data in the fields filled by user will be stored into variables as soon as fields are filled
     when register button is pressed, it shows an activity monitor and sends al the data to the backend to be stored
     a temp id is generated there and sent back to the app which transitions into an alert view
     this alert view shows that user has been registered and the temp id is shown on screen */
    
    // assigning data entered into various variables and storing them using NSUserDefaults option (to try and implement comtinued login even after exiting app feature later on in development phase)
    
    // keyboard is not coming up in simulator, check what's up with that
    
    NSString *name = nameTextField.text;                         // this line of code assigns data enteres into variable
    NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
    [defaults1 setObject:name forKey:@"saveName"];
    
    NSString *email = emailTextField.text;                       // this line of code assigns data enteres into variable
    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
    [defaults2 setObject:email forKey:@"saveEmail"];
    
    NSString *phoneNumber = phoneNumberTextField.text;             // this line of code assigns data enters into variable
    NSUserDefaults *defaults3 = [NSUserDefaults standardUserDefaults];
    [defaults3 setObject:phoneNumber forKey:@"savePhoneNumber"];
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



// there is a button placed over the text field. the button is hidden from view but can be pressed by user. when it is pressed, first the picker which is initially hidden from view is revealed, and then gender is stored in variable of name genderEntered. he stored gender is also displayed in the gender text field during entry. try to use simliar implementation for other pickers as well, and other buttons haven't yet been linked either but they are on storyboard.

- (IBAction)genderButtonPressed:(id)sender
{
    
    _pickerGender.hidden = NO;
    NSString *genderEntered = [_genderPickerArray objectAtIndex:[_pickerGender selectedRowInComponent:0]];
    genderTextField.text = genderEntered;
    _pickerGender.hidden = YES;

}

#pragma mark - genderPicker Data Source Methods

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
    
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [_genderPickerArray count];
    
}

#pragma mark - genderPicker Delegate Methods

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row1 forComponent:(NSInteger)component
{
    
    return [_genderPickerArray objectAtIndex:row1];
    
}



@end
