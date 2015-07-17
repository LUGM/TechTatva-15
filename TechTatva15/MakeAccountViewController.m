//
//  MakeAccountViewController.m
//  TechTatva15
//
//  Created by YASH on 25/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "MakeAccountViewController.h"

@interface MakeAccountViewController ()

@end

@implementation MakeAccountViewController

@synthesize nameTextField, emailTextField, phoneTextField;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    
// The following lines define the data to be shown in various pickers. Second line of each segment assigns the data to corresponding picker array.
    
//    NSArray *genderData = [[NSArray alloc] initWithObjects:@"Male", @"Female", @"Other", nil];
//    self.genderPickerArray = genderData;
//    
//    NSArray *collegeData = [[NSArray alloc] initWithObjects:@"Manipal Institute of Technology", @"Kasturba Medical College", nil];
//    self.collegePickerArray = collegeData;
//    
//    NSArray *yearOfStudy = [[NSArray alloc] initWithObjects:@"First Year", @"Second Year", @"Third Year", @"Fourth Year", nil];
//    self.yearOfStudyPickerArray = yearOfStudy;
//    
//    NSArray *cityOfOrigin = [[NSArray alloc] initWithObjects:@"Bangalore", @"Chennai", @"Hyderabad", @"Kolkata", @"Jamshedpur", @"Manipal", @"Mumbai", @"New Delhi", @"Patna", @"Varanasi", nil];
//    self.cityPickerArray = cityOfOrigin;
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 7;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 0;
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)registerButton:(UIButton *)sender
{
    
    NSString *name = nameTextField.text;
    NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
    [defaults1 setObject:name forKey:@"saveName"];
    
    NSString *email = emailTextField.text;
    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
    [defaults2 setObject:email forKey:@"email"];
    
    NSString *phoneNumber = phoneTextField.text;
    NSUserDefaults *defaults3 = [NSUserDefaults standardUserDefaults];
    [defaults3 setObject:phoneNumber forKey:@"savePhoneNumber"];
    
}
@end
