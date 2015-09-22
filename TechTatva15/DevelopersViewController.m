//
//  DevelopersViewController.m
//  TechTatva15
//
//  Created by YASH on 17/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "DevelopersViewController.h"
#import "RESideMenu.h"

@interface DevelopersViewController ()
{
    
    NSMutableArray *arrData;
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
    
    return arrData.count;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    
    [cell.textLabel setText:[arrData objectAtIndex:indexPath.row]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell setBackgroundColor:[UIColor colorWithRed:255/ 255.0 green:98/ 255.0 blue:90/ 255.0 alpha:1.0]];
    
    return cell;
    
}

- (void) setData
{
    
    arrData = [[NSMutableArray alloc] init];
    NSInteger iCount = 100;
    for (NSInteger i = 0; i < iCount; i++) {
        [arrData addObject:[NSString stringWithFormat:@"TEXT - %ld", (long)i]];
    }
    
    [devTable reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [devTable performAnimation:self.animationTableView finishBlock:^(bool finished) {
            
        }];
    });
    
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
