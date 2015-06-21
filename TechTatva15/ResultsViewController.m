//
//  ResultsViewController.m
//  TechTatva15
//
//  Created by YASH on 22/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

/* Sushant, ye files ko storyboard se connect kar de, nahi ho raha humse :p
 Code samajhne mei problem ho toh batana, theek hi lag raha generally */

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
    
    NSURL *resultsUrl = [NSURL URLWithString:@"xyz"];              // xyz is url of results page of website
    
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

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return json.count;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    
    cell.textLabel.text = [categoryNames objectAtIndex:indexPath.row];          // Category names shown in cell
    cell.detailTextLabel.text = [eventNames objectAtIndex:indexPath.row];       // Event name corresponding to category
    
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

@end
