//
//  DevelopersViewController.m
//  TechTatva15
//
//  Created by YASH on 17/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "DevelopersViewController.h"
#import "RESideMenu.h"
#import "DevViewTableViewCell.h"

@interface DevelopersViewController () <UITableViewDataSource, UITableViewDelegate>
{
    
    NSArray *namesArray;
    NSArray *jobsArray;
    NSArray *imagesArray;
    
    __weak IBOutlet UITableView *devTable;
    
}

@end

@implementation DevelopersViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    [self setAnimationTableView:AnimationRightToLeft];
    [self setData];
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (BOOL) canBecomeFirstResponder
{
    
    return YES;
    
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    if (motion == UIEventSubtypeMotionShake)
    {
        
        [self performSegueWithIdentifier:@"easterEgg" sender:self];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
}

# pragma mark - UI Table View Data Source Methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return namesArray.count;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    DevViewTableViewCell *cell = (DevViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DevViewCell" owner:self options:nil];
    
    cell = [nib objectAtIndex:0];
    
    cell.nameLabel.text = [namesArray objectAtIndex:indexPath.row];
    cell.jobLabel.text = [jobsArray objectAtIndex:indexPath.row];
    cell.devImage.layer.masksToBounds = YES;
    cell.devImage.layer.cornerRadius = 45;
    cell.devImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [namesArray objectAtIndex:indexPath.row]]];
    [cell.nameLabel setTextColor:[UIColor blackColor]];
    
    return cell;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [devTable deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void) setData
{
    
    namesArray = @[@"Kartik Arora", @"Yash Kumar Lal", @"Sushant Gakhar", @"Anuraag Baishya", @"Saketh Kaparthi", @"Manoj Bhat", @"Samarth Jain", @"Mayank Bansal", @"Rohil Vijaywargiya"];
    
    jobsArray = @[@"Team Leader", @"iOS Developer", @"iOS Developer", @"Android Develeoper", @"Android Developer", @"Graphic Designer", @"Team Co-ordinator", @"Windows Developer", @"Windows Developer"];
    
    [devTable reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [devTable performAnimation:self.animationTableView finishBlock:^(bool finished) {
            
        }];
    });
    
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectZero];
    return blankView;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)hamburgerLoader:(id)sender
{
    
    [self presentLeftMenuViewController:self];
    
}
@end
