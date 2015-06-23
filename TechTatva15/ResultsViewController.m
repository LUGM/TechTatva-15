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

@property (strong, nonatomic) NSArray *resultViewSearchResults;  // Variable will store results of search in resultView

@end

@implementation ResultsViewController

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
    
    self.resultViewSearchResults = [[NSArray alloc] init];
    
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
    
    [_resultsTable reloadData];
    
    // When data is finished loading, hide activity monitor here
    
}

# pragma mark Table View Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        
        return [self.resultViewSearchResults count];
        
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
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        
        cell.textLabel.text = [self.resultViewSearchResults objectAtIndex:indexPath.row];
        
    }
    
    else
    {
        cell.detailTextLabel.text = [categoryNames objectAtIndex:indexPath.row];          // Event names shown in cell
        cell.textLabel.text = [eventNames objectAtIndex:indexPath.row];       // Category name corresponding to event
    }
    
    return cell;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;                  // Check this value according to wanted size of cell
    
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *emptyView = [[ UIView alloc] initWithFrame:CGRectZero];
    return emptyView;
    
}

# pragma mark Search Methods

- (void) filterContentForSearchText:(NSString *) searchText scope:(NSString *) scope
{
    
    NSPredicate *resultViewPredicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", searchText];
    self.resultViewSearchResults = [self->eventNames filteredArrayUsingPredicate:resultViewPredicate];
    
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
    
}

@end
