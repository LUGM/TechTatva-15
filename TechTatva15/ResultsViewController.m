//
//  ResultsViewController.m
//  TechTatva15
//
//  Created by YASH on 22/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//


// UI customisations to be added, loads to do in this view still, check last year's app, it's a good reference
// In ResultsViewController .h and .m files, all commented lines are attempt to implement search, look at code again, it should work, with some changes maybe.


#import "ResultsViewController.h"
#import "SSJSONModel.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "ResultsModel.h"
#import "RESideMenu.h"

@interface ResultsViewController () <SSJSONModelDelegate>
{
    
    NSMutableArray *categoryNames;
    NSMutableArray *eventNames;
    NSMutableArray *particularEventResults;
    NSMutableArray * filteredArray;
    
    NSArray *json;
    
    SSJSONModel *myJsonInstance;
    
}

@end

@implementation ResultsViewController

@synthesize myTable;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 2.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
    
    myTable.scrollsToTop = YES;
    
    myTable.separatorColor = [UIColor orangeColor];
    
    // change the url, this one is unresponsive
    
    NSURL *resultsUrl = [NSURL URLWithString:@"http://results.techtatva.in"];
    myJsonInstance =[[SSJSONModel alloc] initWithDelegate:self];
    [myJsonInstance sendRequestWithUrl:resultsUrl];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
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


#pragma mark Helper Methods

- (void)jsonRequestDidCompleteWithDict:(id)response model:(SSJSONModel *)JSONModel
{
    
    if (JSONModel == myJsonInstance)
    {
        
        NSLog(@"%@",myJsonInstance.parsedJsonData);
        json = myJsonInstance.parsedJsonData;
//        categoryNames =[NSMutableArray new];
        particularEventResults = [NSMutableArray new];
        
        for (NSDictionary * dict in json)
        {
            ResultsModel * result = [[ResultsModel alloc] initWithDict:dict];
            [particularEventResults addObject:result];
        }
        
        [myTable reloadData];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }
    
}

# pragma mark UITableView Data Source Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        
        return [filteredArray count];
        
    }
    else
    {
        
        return [particularEventResults count];
        
    }
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        
    }
    
    ResultsModel * result = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        
        result = [filteredArray objectAtIndex:indexPath.row];
        
    }
    else
    {
        
        result = [particularEventResults objectAtIndex:indexPath.row];
        
    }
    
    cell.textLabel.text = result.name;
    cell.detailTextLabel.text = result.categories;
    
    return cell;
    
}

# pragma mark UITableView Delegate Methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ResultsModel * model = [particularEventResults objectAtIndex:indexPath.row];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        
        model = [filteredArray objectAtIndex:indexPath.row];
        
    }
    else
    {
        
        model = [particularEventResults objectAtIndex:indexPath.row];
        
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:model.name message:model.result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;                  // Check this value according to wanted size of cell
    
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
    {
        
        UIView *blankView = [[UIView alloc] initWithFrame:CGRectZero];
        return blankView;
        
    }

# pragma mark Content Filtering

- (void) filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [filteredArray removeAllObjects];
    
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@",searchText];
    filteredArray = [NSMutableArray arrayWithArray:[particularEventResults filteredArrayUsingPredicate:predicate]];
    
}

# pragma mark - UISearchDisplayController Delegate Methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
    
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
@end
