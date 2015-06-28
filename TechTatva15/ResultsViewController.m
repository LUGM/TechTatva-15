//
//  ResultsViewController.m
//  TechTatva15
//
//  Created by YASH on 22/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//


// UI customisations to be added, loads to do in this view still, check last year's app, it's a good reference //


#import "ResultsViewController.h"
#import "SSJSONModel.h"
#import "MBProgressHUD.h"

@interface ResultsViewController () <SSJSONModelDelegate>
{
    NSMutableArray *categoryNames;
    NSMutableArray *eventNames;
    NSMutableArray *particularEventResults;
    NSArray *json;
    
    SSJSONModel *myJsonInstance;
}

@end

@implementation ResultsViewController

@synthesize myTable, resultsSearchBar, searchResults, areResultsFiltered, searchResultsResult;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

- (void)jsonRequestDidCompleteWithResponse:(id)response model:(SSJSONModel *)JSONModel
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
    if (areResultsFiltered == YES)
    {
        
        return searchResults.count;
        
    }
    else
    {
        
        return json.count;
        
    }
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (areResultsFiltered == YES)
    {
        
        cell.textLabel.text = [eventNames objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [categoryNames objectAtIndex:indexPath.row];
        
    }
    else
    {
        
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
        
    }
    
    return cell;
    
}

# pragma mark UITableView Delegate Methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (areResultsFiltered == NO)
    {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[eventNames objectAtIndex:indexPath.row] message:[particularEventResults objectAtIndex:indexPath.row] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[searchResults objectAtIndex:indexPath.row] message:[searchResultsResult objectAtIndex:indexPath.row] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
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

# pragma UISearchBar Delegate Methods

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if (searchText.length == 0)
    {
        
        areResultsFiltered = NO;
        
    }
    else
    {
        
        areResultsFiltered = YES;
        
        searchResults = [[NSMutableArray alloc] init];
        searchResultsResult = [[NSMutableArray alloc] init];
        
        for (NSString *searchResult in eventNames)
        {
            
            for (NSString *searchEventResult in particularEventResults)
            {
                
                NSRange searchResultRange = [searchResult rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                if (searchResultRange.location != NSNotFound)
                {
                    
                    [searchResults addObject:searchResult];
                    [searchResultsResult addObject:searchEventResult];
                     
                }
                
            }
            
        }
        
    }
    
    [myTable reloadData];
    
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    
}

@end
