//
//  LeftMenuViewController.m
//  TechTatva15
//
//  Created by Shubham Sorte on 20/08/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "RESideMenu.h"

@interface LeftMenuViewController () <UITableViewDataSource,UITableViewDelegate>

@property NSArray *optionsArray;

@end

@implementation LeftMenuViewController

@synthesize contentsTable;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _optionsArray = @[@"Categories",@"Events",@"Favourites", @"Results", @"InstaFeed", @"Online Events", @"Featured Events", @"Register", @"About Us"];
    
    contentsTable.contentInset = UIEdgeInsetsMake(88, 0, 0, 0);
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _optionsArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellIdentifier = @"Cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.textLabel.text = _optionsArray[indexPath.row];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
    {
        
        UIStoryboard * mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        
        UINavigationController * viewController =[mainStoryBoard instantiateViewControllerWithIdentifier:@"categoryView"];
        
        [self.sideMenuViewController setContentViewController:viewController animated:YES];
        
    }
    
    if (indexPath.row == 1)
    {
        
        UIStoryboard * mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        
        UINavigationController * viewController =[mainStoryBoard instantiateViewControllerWithIdentifier:@"eventView"];
        
        [self.sideMenuViewController setContentViewController:viewController animated:YES];
        
    }
    
    if (indexPath.row == 2)
    {
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        UINavigationController * viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"favouritesView"];
        
        [self.sideMenuViewController setContentViewController:viewController animated:YES];
        
    }
    
    if (indexPath.row == 3)
    {
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        UINavigationController * viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"resultsView"];
        
        [self.sideMenuViewController setContentViewController:viewController animated:YES];
        
    }
    
    if (indexPath.row == 4)
    {
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        UINavigationController * viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"instagramView"];
        
        [self.sideMenuViewController setContentViewController:viewController animated:YES];
        
    }
    
    if (indexPath.row == 5)
    {
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        UINavigationController * viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"onlineEventsView"];
        
        [self.sideMenuViewController setContentViewController:viewController animated:YES];
        
    }
    
    if (indexPath.row == 6)
    {
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        UINavigationController * viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"registerView"];
        
        [self.sideMenuViewController setContentViewController:viewController animated:YES];
        
    }
    
    if (indexPath.row == 7)
    {
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        UINavigationController * viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"aboutUsView"];
        
        [self.sideMenuViewController setContentViewController:viewController animated:YES];
        
    }
    
     [self.sideMenuViewController hideMenuViewController];
    
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
