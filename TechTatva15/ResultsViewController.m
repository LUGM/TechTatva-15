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
#import "NavigationMenuView.h"

@interface ResultsViewController () <SSJSONModelDelegate>
{
    NSMutableArray *categoryNames;
    NSMutableArray *eventNames;
    NSMutableArray *particularEventResults;
    NSArray *json;
//    NSString *searchResult;                                                     change NSString to NSMutableArray
//    NSMutableArray *searchEventResult;                                               change NSString to NSMutableArray
    
    SSJSONModel *myJsonInstance;
    
    UIView *blurView;
}

@property NavigationMenuView *navigationDropDown;

@end

@implementation ResultsViewController

@synthesize myTable, resultsSearchBar; // searchResults, areResultsFiltered, searchResultsResult

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    blurView = nil;
    _navigationDropDown = nil;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Explore" style:UIBarButtonItemStylePlain target:self action:@selector(loadDropDown)];
    
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


- (void) loadDropDown
{
    
    if (self.navigationDropDown == nil)
    {
        
        blurView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        blurView.alpha = 0.9;
        [self.view addSubview:blurView];
        [blurView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeExtraViews)]];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NavigationMenuView" owner:self options:nil];
        _navigationDropDown = [nib objectAtIndex:0];
        _navigationDropDown.frame = CGRectMake(0, 40, 170, 584);
        
        [self.view addSubview:_navigationDropDown];
        
        [_navigationDropDown.categoryButtonPressed addTarget:self action:@selector(categoryButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.eventButtonPressed addTarget:self action:@selector(eventButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.favouritesButtonPressed addTarget:self action:@selector(favouritesButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.resultsButtonPressed addTarget:self action:@selector(resultsButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.instafeedButtonPressed addTarget:self action:@selector(instafeedButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.aboutUsButtonPressed addTarget:self action:@selector(aboutUsButton) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}

- (void) categoryButton
{
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *resultsViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"categoryView"];
    [self presentViewController:resultsViewController animated:YES completion:nil];
    
}

- (void) eventButton
{
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *resultsViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"eventView"];
    [self presentViewController:resultsViewController animated:YES completion:nil];
    
}

- (void) favouritesButton
{
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *resultsViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"favouritesView"];
    [self presentViewController:resultsViewController animated:YES completion:nil];
    
}

- (void) resultsButton
{
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *resultsViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"resultsView"];
    [self presentViewController:resultsViewController animated:YES completion:nil];
    
}

- (void) instafeedButton
{
    
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *resultsViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"instagramView"];
    [self presentViewController:resultsViewController animated:YES completion:nil];
    
}

- (void) aboutUsButton
{
    
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *resultsViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"aboutUsView"];
    [self presentViewController:resultsViewController animated:YES completion:nil];
    
}

- (void) removeExtraViews
{
    
    [blurView removeFromSuperview];
    [_navigationDropDown removeFromSuperview];
    blurView = nil;
    _navigationDropDown = nil;
    
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
