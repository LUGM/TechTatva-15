//
//  CategoriesTableViewController.m
//  TechTatva15
//
//  Created by YASH on 01/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "CategoriesTableViewController.h"
#import "SSJSONModel.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "CatEventViewController.h"
#import "RESideMenu.h"
#import <Parse/Parse.h>

@interface CategoriesTableViewController () <SSJSONModelDelegate>
{
    
    NSDictionary *json;
    
    NSArray *categoriesArray;
    NSArray *tempCategoryStorage;
//    NSArray *imagesArray;
    
    SSJSONModel *myJsonInstance;
    
    NSMutableArray *categoryNames;
    NSMutableArray *categoryDescriptions;
    NSMutableArray *categoryIds;
    NSMutableArray *categoryTypes;
    
    NSString *checkedCategoryUrl;
    NSString *checkedScheduleUrl;
    NSString *checkedResultUrl;
    
}

@end

@implementation CategoriesTableViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 2.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
    
    self.tableView.scrollsToTop = YES;
    
    self.tableView.separatorColor = [UIColor orangeColor];
    
    if (![self isInternetAvailable])
    {
        
        NSUserDefaults *catData =[NSUserDefaults standardUserDefaults];
        
        if ([catData objectForKey:@"categories"] != nil)
        {
            
            json = [catData objectForKey:@"categories"];
            [self setData];
            NSLog(@"enters if ");
            
        }
        
    }
    
    else
    {
        
        [PFConfig getConfigInBackgroundWithBlock:^(PFConfig * config, NSError * error){
            NSLog(@"CATEGORY URL : %@", config[@"categories"]);
            NSLog(@"SCHEDULE URL : %@", config[@"schedule"]);
            NSLog(@"RESULTS URL : %@", config[@"results"]);
            
            checkedCategoryUrl = config[@"categories"];
            checkedScheduleUrl = config[@"schedule"];
            checkedResultUrl = config[@"results"];
            
            [self setCorrectUrls];
        }];
        // It is logging the categoriesUrl (initially null) in setCorrectUrls method first and then the config logs, even though the config logs are being called first
    
    }
    
}

- (void) setCorrectUrls
{
    
    NSURL *categoriesUrl;
    categoriesUrl = [NSURL URLWithString:checkedCategoryUrl];
    NSLog(@"categories url %@", categoriesUrl);
    
    myJsonInstance =[[SSJSONModel alloc] initWithDelegate:self];
    [myJsonInstance sendRequestWithUrl:categoriesUrl];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    
    return categoryNames.count;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.textLabel.text = [categoryNames objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[categoryNames objectAtIndex:indexPath.row]]];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController * navController = [storyboard instantiateViewControllerWithIdentifier:@"eventListNav"];
    CatEventViewController * destController = [navController viewControllers][0];
    destController.title = [categoryNames objectAtIndex:indexPath.row];
    destController.catid = [categoryIds objectAtIndex:indexPath.row];
    [self presentViewController:navController animated:YES completion:nil];

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;          // check wanted cell size
    
}

-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:[categoryNames objectAtIndex:indexPath.row] message:[categoryDescriptions objectAtIndex:indexPath.row] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectZero];
    return blankView;
    
}


# pragma mark Data Helper Methods

- (void)jsonRequestDidCompleteWithDict:(id)response model:(SSJSONModel *)JSONModel
{
    
    if (JSONModel == myJsonInstance)
    {

        json = myJsonInstance.parsedJsonData;
        
        NSUserDefaults *categoryData = [NSUserDefaults standardUserDefaults];
        [categoryData setObject:json forKey:@"categories"];
        [categoryData synchronize];
        
        [self setData];
        
    }
    
}

- (void) setData
{
    
    tempCategoryStorage = [json objectForKey:@"data"];
    NSLog(@"%@", tempCategoryStorage);
    categoryNames =[NSMutableArray new];
    categoryDescriptions = [NSMutableArray new];
    categoryTypes = [NSMutableArray new];
    categoryIds = [NSMutableArray new];
    for (NSDictionary * dict in tempCategoryStorage)
    {
        
        [categoryNames addObject:[dict objectForKey:@"categoryName"]];
        [categoryDescriptions addObject:[dict objectForKey:@"description"]];
        [categoryIds addObject:[dict objectForKey:@"categoryID"]];
        [categoryTypes addObject:[dict objectForKey:@"categoryType"]];
        
    }
    
    [self.tableView reloadData];
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
}

# pragma mark Connection Check

- (BOOL) isInternetAvailable
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
    
}

- (IBAction)hamburgerLoader:(id)sender
{
    
    [self presentLeftMenuViewController:self];
    
}

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
@end
