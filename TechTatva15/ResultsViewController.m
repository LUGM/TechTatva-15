//
//  ResultsViewController.m
//  TechTatva15
//
//  Created by YASH on 22/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//


// UI customisations to be added, loads to do in this view still, check last year's app, it's a good reference //


#import "ResultsViewController.h"

@interface ResultsViewController ()
{
    
    DataModel *dataModelInstance;
    
    NSMutableArray *categoryNames;
    NSMutableArray *eventNames;
    NSMutableArray *particularEventResults;
    NSArray *json;
    
}

@end

@implementation ResultsViewController

@synthesize resultsSearchBar, myTable, resultViewSearchResult, areResultsFiltered;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        // Custom initialisation
        
    }
    
    return self;
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // self.resultViewSearchResults = [[NSArray alloc] init];
    
    NSURL *resultsUrl = [NSURL URLWithString:@"http://results.techtatva.in"];              // this has to be url of results page of website
    
    dataModelInstance = [[DataModel alloc] init];
    [dataModelInstance sendRequestWithUrl:resultsUrl];
    
    // Insert activity monitor here, which comes on screen and shows loading
    
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


- (void) jsonRequestDidCompleteWithDict:(NSArray *)array model:(DataModel *)JSONModel
{
    
    json = [[NSMutableArray alloc] init];
    json = dataModelInstance.jsonDictionary;
    
    categoryNames = [[NSMutableArray alloc] init];
    eventNames = [[NSMutableArray alloc] init];
    particularEventResults = [[NSMutableArray alloc] init];
    
    for (int x = 0; x < [json count]; x++)
    {
        
        [categoryNames addObject:[[json objectAtIndex:x] objectForKey:@"Category"]];
        [eventNames addObject:[[json objectAtIndex:x] objectForKey:@"Event"]];
        [particularEventResults addObject:[[json objectAtIndex:x] objectForKey:@"Result"]];
        
    }
    
    [myTable reloadData];
    
    // When data is finished loading, hide activity monitor here
    
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
        
        return resultViewSearchResult.count;
        
    }
    else
    {
        
        return json.count;
        
    }
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    
    if (areResultsFiltered == YES)
    {
        
        cell.textLabel.text = [resultViewSearchResult objectAtIndex:indexPath.row];
        
    }
    else
    {
        
        cell.textLabel.text = [eventNames objectAtIndex:indexPath.row];
        
    }
    
    
    cell.textLabel.text = [eventNames objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [categoryNames objectAtIndex:indexPath.row];
    
    return cell;
    
}

# pragma mark UITableView Delegate Methods

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

# pragma  mark Extra UITableView Methods

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;                  // Check this value according to wanted size of cell
    
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *emptyView = [[ UIView alloc] initWithFrame:CGRectZero];
    return emptyView;
    
}

# pragma mark UISearchBar Delegate Methods

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if (searchText.length == 0)
    {
        
        // Set boolean flag
        areResultsFiltered = NO;
        
    }
    
    else
    {
        
        // Set boolean flag
        areResultsFiltered = YES;
        
        // Alloc and init search result data
        resultViewSearchResult = [[NSMutableArray alloc] init];
        
        // Fast enumeration to loop through category names in table view
        for (NSString *eventName in eventNames)          // equivalent example is : for ( i in array)
        {
            
            NSRange eventNamesRange = [eventName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            // If category is found in search, it is added to search results array
            if (eventNamesRange.location != NSNotFound)
            {
                
                [resultViewSearchResult addObject:eventName];
                
            }
            
        }
        
    }
    
    // Reload table view
    [myTable reloadData];
    
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    
}

// Implement this as well
//- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    
//    
//    
//}

@end
