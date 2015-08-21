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

@interface ResultsViewController () <SSJSONModelDelegate>
{
    NSMutableArray *categoryNames;
    NSMutableArray *eventNames;
    NSMutableArray *particularEventResults;
    NSArray *json;
//    NSString *searchResult;                                                     change NSString to NSMutableArray
//    NSMutableArray *searchEventResult;                                               change NSString to NSMutableArray
    
    SSJSONModel *myJsonInstance;
    
}

@end

@implementation ResultsViewController

@synthesize myTable, resultsSearchBar; // searchResults, areResultsFiltered, searchResultsResult

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
    
    NSURL *resultsUrl = [NSURL URLWithString:@"http://results.techtatva.in"];              // this has to be url of results page of website
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
        categoryNames =[NSMutableArray new];
        eventNames = [NSMutableArray new];
        particularEventResults = [NSMutableArray new];
        
        for (NSDictionary * dict in json)
        {
            
            [categoryNames addObject:[dict objectForKey:@"Category"]];
            [eventNames addObject:[dict objectForKey:@"Event"]];
            [particularEventResults addObject:[dict objectForKey:@"Result"]];
            [myTable reloadData];
        
        }
        
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
//    if (_areResultsFiltered == YES)
//    {
//        
//        return _searchResults.count;
//        
//    }
//    else
//    {
//        
//        return json.count;
//        
//    }
    
    return json.count;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
//    if (_areResultsFiltered == NO)                                                     change YES to NO here
//    {
//        
//        cell.textLabel.text = [eventNames objectAtIndex:indexPath.row];
//        cell.detailTextLabel.text = [categoryNames objectAtIndex:indexPath.row];
//        
//    }
//    else
//    {
//        
//        cell.textLabel.text = [_searchResults objectAtIndex:indexPath.row];
//        
//    }
    
    cell.textLabel.text = [eventNames objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [categoryNames objectAtIndex:indexPath.row];
    
    return cell;
    
}

# pragma mark UITableView Delegate Methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (_areResultsFiltered == NO)
//    {
//
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[eventNames objectAtIndex:indexPath.row] message:[particularEventResults objectAtIndex:indexPath.row] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        
//    }
//    else
//    {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[_searchResults objectAtIndex:indexPath.row] message:[_searchResultsResult objectAtIndex:indexPath.row] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        
//    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[eventNames objectAtIndex:indexPath.row] message:[particularEventResults objectAtIndex:indexPath.row] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;                  // Check this value according to wanted size of cell
    
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *emptyView = [[ UIView alloc] initWithFrame:CGRectZero];
    return emptyView;
    
}

# pragma mark Connection Check

- (BOOL) isInternetAvailable
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
    
}


// In this method, find a way to loop over particularEventResults array together with eventNames array
// What is to be done is that if event 3 of eventNames array is stored in event 2 of searchResults array, object 3 of particularEventResults array should be stored as object 2 of searchEventResult array

//# pragma UISearchBar Delegate Methods
//
//- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    
//    if (searchText.length == 0)
//    {
//        
//        _areResultsFiltered = NO;
//        
//    }
//    else
//    {
//        
//        _areResultsFiltered = YES;
//        
//        _searchResults = [[NSMutableArray alloc] init];
//        _searchResultsResult = [[NSMutableArray alloc] init];
//        
//        for (searchResult in eventNames)
//        {
//
//            NSRange searchResultRange = [searchResult rangeOfString:searchText options:NSCaseInsensitiveSearch];
//            
//            if (searchResultRange.location != NSNotFound)
//            {
//                
//                [_searchResults addObject:searchResult];
//                [_searchResultsResult addObject:searchEventResult];
//                
//            }
//            
//        }
//        
//    }
//    
//    [myTable reloadData];
//    
//}
//
//- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    
//    [searchBar resignFirstResponder];
//    
//}
//
@end
