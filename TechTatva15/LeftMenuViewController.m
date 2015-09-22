//
//  LeftMenuViewController.m
//  TechTatva15
//
//  Created by Shubham Sorte on 20/08/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "RESideMenu.h"
#import "MBProgressHUD.h"

@interface LeftMenuViewController () <UITableViewDataSource,UITableViewDelegate>

@property NSArray *optionsArray;

@end

@implementation LeftMenuViewController

@synthesize contentsTable;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _optionsArray = @[@"Categories",@"Events",@"Favourites", @"Results", @"InstaFeed", @"Online Events", @"Register", @"About Us", @"Developers"];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    contentsTable = ({
        contentsTable = [[UITableView alloc] initWithFrame:self.view.frame];
        contentsTable.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        contentsTable.delegate = self;
        contentsTable.dataSource = self;
        contentsTable.contentInset = UIEdgeInsetsMake(88, 0, 0, 0);
        contentsTable.opaque = NO;
        contentsTable.backgroundColor = [UIColor clearColor];
        contentsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        contentsTable.bounces = NO;
        contentsTable.scrollsToTop = NO;
        contentsTable;
        });

    [self.view addSubview:contentsTable];
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
    
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] init];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:18.0];
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
    
    if (indexPath.row == 8)
    {
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        UINavigationController * viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"developerView"];
        
        [self.sideMenuViewController setContentViewController:viewController animated:YES];
        
    }
    
     [self.sideMenuViewController hideMenuViewController];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:0.75f];
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
