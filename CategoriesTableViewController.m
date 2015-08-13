//
//  CategoriesTableViewController.m
//  TechTatva15
//
//  Created by YASH on 01/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//


// When data from APIs is ready to be loaded, uncomment the required commented lines.


#import "CategoriesTableViewController.h"
#import "NavigationMenuView.h"
#import "SSJSONModel.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "CategoryEventViewController.h"

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
    
    UIView *blurView;
    
}

@property NavigationMenuView *navigationDropDown;

@end

@implementation CategoriesTableViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    blurView = nil;
    _navigationDropDown = nil;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Explore" style:UIBarButtonItemStylePlain target:self action:@selector(loadDropDown)];
    
//    self.categoriesTable = [[UITableView alloc] init];
//    self.categoriesTable.delegate = self;
//    self.categoriesTable.dataSource = self;
    
    categoriesArray = @[@"Acumen", @"Airborne", @"Alacrity", @"Bizzmaestro", @"Cheminova", @"Constructure", @"Cryptoss", @"Electrific", @"Energia", @"Epsilon", @"Kraftwagen", @"Mechanize", @"Mechatron", @"Robotrek", @"Turing"];
    
//    imagesArray = @[""];     category image names to be entered in same order as categories named in array
    
    NSURL *categoriesUrl;
//    categoriesUrl = [NSURL URLWithString:@"http://api.techtatva.in/categories"];
    categoriesUrl = [NSURL URLWithString:@"http://localhost:8888/categories.json"];
    
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
    
//    cell.textLabel.text = [categoriesArray objectAtIndex:indexPath.row];
//    cell.imageView.image = [UIImage imageNamed:[imagesArray objectAtIndex:indexPath.row]];
//    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"categoryDetail" sender:self];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;          // check wanted cell size
    
}

- (IBAction)categoryInfoButton:(UIButton *)sender
{
    
    UIAlertView *categoryDetails = [[UIAlertView alloc] initWithTitle:@"Details" message:@"[categoryDescriptions objectAtIndex:indexPath.row]" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [categoryDetails show];
    
}

-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"push to category-events" sender:indexPath];
    
}

# pragma mark Data Helper Methods

- (void)jsonRequestDidCompleteWithDict:(id)response model:(SSJSONModel *)JSONModel
{
    
    if (JSONModel == myJsonInstance)
    {
        
        NSLog(@"%@",myJsonInstance.parsedJsonData);
        json = myJsonInstance.parsedJsonData;
        categoryNames =[NSMutableArray new];
        categoryDescriptions = [NSMutableArray new];
        categoryTypes = [NSMutableArray new];
        categoryIds = [NSMutableArray new];
        
        tempCategoryStorage = [json objectForKey:@"data"];
        
        for (NSDictionary * dict in tempCategoryStorage)
        {
            
            [categoryNames addObject:[dict objectForKey:@"cat_name"]];
            [categoryDescriptions addObject:[dict objectForKey:@"description"]];
            [categoryIds addObject:[dict objectForKey:@"cat_id"]];
            [categoryTypes addObject:[dict objectForKey:@"cat_type"]];
            
        }
        
        [self.tableView reloadData];
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }
    
}

# pragma mark Sidebar Methods

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
        _navigationDropDown.frame = CGRectMake(0, 0, 170, 602);
        
        [self.view addSubview:_navigationDropDown];
        
        [_navigationDropDown.categoryButtonPressed addTarget:self action:@selector(categoryButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.eventButtonPressed addTarget:self action:@selector(eventButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.favouritesButtonPressed addTarget:self action:@selector(favouritesButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.resultsButtonPressed addTarget:self action:@selector(resultsButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.instafeedButtonPressed addTarget:self action:@selector(instafeedButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.aboutUsButtonPressed addTarget:self action:@selector(aboutUsButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.logoutButtonPressed addTarget:self action:@selector(logoutButton) forControlEvents:UIControlEventTouchUpInside];
        
        _navigationDropDown.profilePhotoSidebar.layer.cornerRadius = 25;
        
    }
    
}

- (void) categoryButton
{
    
    if (![self isInternetAvailable])
    {
        
        UIAlertView *categoryViewConnectionAlert = [[UIAlertView alloc] initWithTitle:@"Data unavailable"
                                                                              message:@"Please recheck connection"
                                                                             delegate:self
                                                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [categoryViewConnectionAlert show];
        
    }
    
    else
    {
        
        [self.navigationDropDown removeFromSuperview];
        self.navigationDropDown = nil;
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *categoriestableViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"categoryView"];
        [self presentViewController:categoriestableViewController animated:YES completion:nil];
        
    }
    
}

- (void) eventButton
{
    
    if (![self isInternetAvailable])
    {
        
        UIAlertView *eventViewConnectionAlert = [[UIAlertView alloc] initWithTitle:@"Data unavailable"
                                                                           message:@"Please recheck connection"
                                                                          delegate:self
                                                                 cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [eventViewConnectionAlert show];
        
    }
    
    else
    {
        
        [self.navigationDropDown removeFromSuperview];
        self.navigationDropDown = nil;
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *categoriestableViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"eventView"];
        [self presentViewController:categoriestableViewController animated:YES completion:nil];
        
    }
    
}

- (void) favouritesButton
{
    
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *categoriestableViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"favouritesView"];
    [self presentViewController:categoriestableViewController animated:YES completion:nil];
    
}

- (void) resultsButton
{
    
    if (![self isInternetAvailable])
    {
        
        UIAlertView *resultsViewConnectionAlert = [[UIAlertView alloc] initWithTitle:@"Data unavailable"
                                                                             message:@"Please recheck connection"
                                                                            delegate:self
                                                                   cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [resultsViewConnectionAlert show];
        
    }
    
    else
    {
        
        [self.navigationDropDown removeFromSuperview];
        self.navigationDropDown = nil;
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *categoriestableViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"resultsView"];
        [self presentViewController:categoriestableViewController animated:YES completion:nil];
        
    }
    
}

- (void) instafeedButton
{
    if (![self isInternetAvailable])
    {
        
        UIAlertView *instagramViewConnectionAlert = [[UIAlertView alloc] initWithTitle:@"Data unavailable"
                                                                               message:@"Please recheck connection"
                                                                              delegate:self
                                                                     cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [instagramViewConnectionAlert show];
        
    }
    
    else
    {
        
        [self.navigationDropDown removeFromSuperview];
        self.navigationDropDown = nil;
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *categoriestableViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"instagramView"];
        [self presentViewController:categoriestableViewController animated:YES completion:nil];
        
    }
    
}

- (void)aboutUsButton
{
    
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *categoriestableViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"aboutUsView"];
    [self presentViewController:categoriestableViewController animated:YES completion:nil];
    
}

- (void)logoutButton
{
    
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *categoriestableViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"firstLoginView"];
    [self presentViewController:categoriestableViewController animated:YES completion:nil];
    
    // Clear Favourites array here
    
}

- (void)removeExtraViews
{
    
    [blurView removeFromSuperview];
    [_navigationDropDown removeFromSuperview];
    blurView = nil;
    _navigationDropDown = nil;
    
}

# pragma mark Connection Check

- (BOOL) isInternetAvailable
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"categoryDetail"]) {
        UINavigationController * navController = segue.destinationViewController;
        CategoryEventViewController * destController = [navController viewControllers][0];
        destController.title = [categoryNames objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
    NSLog(@" %@ ", sender);
    
    
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
