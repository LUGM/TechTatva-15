//
//  InstagramViewController.m
//  TechTatva15
//
//  Created by YASH on 15/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#define LOWRES @"low_resolution"
#define HIGHDEF @"standard_resolution"

#import "InstagramViewController.h"
#import "InstagramCustomTableViewCell.h"
#import "SSJSONModel.h"
#import "InstagramImage.h"
#import "InstagramUser.h"
#import "UIImageView+WebCache.h"
#import "FullScreenImageViewController.h"
#import "PQFCirclesInTriangle.h"
#import "Reachability.h"
#import "NavigationMenuView.h"

@interface InstagramViewController () <SSJSONModelDelegate>
{

    SSJSONModel *jsonRequest;
    NSMutableArray *userArray;
    NSMutableArray *imagesArray;
    
    UITableView *instagramTable;
    UIView *background;
    UIView *blurView;
    
    NSIndexPath *selectedIndex;
    NSString *imgQualityStringForUrl;
    UIRefreshControl *refreshControl;

}

@property (nonatomic, strong) PQFCirclesInTriangle *circlesInTriangles;

@property NavigationMenuView *navigationDropDown;

@end

@implementation InstagramViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"#techtatva15";
    
    blurView = nil;
    _navigationDropDown = nil;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Explore" style:UIBarButtonItemStylePlain target:self action:@selector(loadDropDown)];
    
    instagramTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, self.view.frame.size.height)];
    instagramTable.delegate = self;
    instagramTable.dataSource = self;
    instagramTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:instagramTable];
    
    refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.tintColor = [UIColor blackColor];
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSAttributedString * attributeString = [[NSAttributedString alloc]initWithString:@"Loading"];
    refreshControl.attributedTitle = attributeString;
    [refreshControl addTarget:self action:@selector(sendDataRequest) forControlEvents:UIControlEventValueChanged];
    [instagramTable addSubview:refreshControl];
    
    background = [[UIView alloc] initWithFrame:self.view.frame];
    background.alpha = 0.75;
    [self.view addSubview:background];
    self.circlesInTriangles = [[PQFCirclesInTriangle alloc] initLoaderOnView:self.view];
    [self.circlesInTriangles show];
    
    [self sendDataRequest];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == ReachableViaWiFi||status == ReachableViaWWAN)
    {
        
        imgQualityStringForUrl = HIGHDEF;
        
    }
    
    else
    {
        
        imgQualityStringForUrl = LOWRES;
        
    }

    
}

- (void) viewDidLayoutSubviews
{
    
    instagramTable.contentInset = UIEdgeInsetsMake(64, 0, 10, 0);
    
}

- (void) previousView
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

# pragma mark Data Model Methods

- (void) sendDataRequest
{
    
    jsonRequest = [[SSJSONModel alloc] initWithDelegate:self];
    [jsonRequest sendRequestWithUrl:[NSURL URLWithString:@"https://api.instagram.com/v1/tags/techtatva15/media/recent?client_id=fd6b3100174e42d7aa7d546574e01c76"]];
    
}

- (void) jsonRequestDidCompleteWithDict:(NSDictionary *) dict model:(SSJSONModel *)JSONModel
{
    
    if (JSONModel == jsonRequest)
    {
        
        userArray = [[NSMutableArray alloc] init];
        imagesArray = [[NSMutableArray alloc]init];
        for (NSDictionary * dictionary in [dict objectForKey:@"data"])
        {
            
            InstagramUser * user = [[InstagramUser alloc]initWithDictionary:[dictionary objectForKey:@"user"]];
            [userArray addObject:user];
            
            InstagramImage * img = [[InstagramImage alloc]initWithDictionary:[[dictionary objectForKey:@"images"] objectForKey:imgQualityStringForUrl]];
            [imagesArray addObject:img];
            
            [refreshControl endRefreshing];
            
            [self viewDidLayoutSubviews];
            
        }
        
        [instagramTable reloadData];
        
        [self.circlesInTriangles hide];
        [self.circlesInTriangles remove];
        
        [background removeFromSuperview];
        background = nil;
        
    }
    
}

# pragma mark UITableView Data Source Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  [userArray count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellIdentifier = @"Cell";
    
    InstagramCustomTableViewCell * cell = (InstagramCustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"InstagramCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    InstagramUser * user = [userArray objectAtIndex:indexPath.row];
    cell.userName.text = user.username;
    
    InstagramImage * img = [imagesArray objectAtIndex:indexPath.row];
    [cell.mainImage sd_setImageWithURL:[NSURL URLWithString:img.url] placeholderImage:[UIImage imageNamed:@"TT15logomain"]];
    [cell.userImage sd_setImageWithURL:[NSURL URLWithString:user.profile_picture] placeholderImage:[UIImage imageNamed:@"TT15logomain"]];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 395;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView * blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    return blankView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark UITableView Delegate Methods

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [instagramTable deselectRowAtIndexPath:indexPath animated:YES];
    selectedIndex = indexPath;
    [self performSegueWithIdentifier:@"FullScreenImage" sender:self];
    
}

- (void )prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqual: @"FullScreenImage"])
    {
        
        FullScreenImageViewController *destination = segue.destinationViewController;
        InstagramImage * imageUrl = [imagesArray objectAtIndex:selectedIndex.row];
        destination.requiredUrl = imageUrl.url;
        
    }

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
        _navigationDropDown.frame = CGRectMake(0, 65, 170, 602);
        
        [self.view addSubview:_navigationDropDown];
        
        [_navigationDropDown.categoryButtonPressed addTarget:self action:@selector(categoryButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.eventButtonPressed addTarget:self action:@selector(eventButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.favouritesButtonPressed addTarget:self action:@selector(favouritesButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.resultsButtonPressed addTarget:self action:@selector(resultsButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.instafeedButtonPressed addTarget:self action:@selector(instafeedButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.aboutUsButtonPressed addTarget:self action:@selector(aboutUsButton) forControlEvents:UIControlEventTouchUpInside];
        [_navigationDropDown.logoutButtonPressed addTarget:self action:@selector(logoutButton) forControlEvents:UIControlEventTouchUpInside];
        
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
        UINavigationController *instagramViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"categoryView"];
        [self presentViewController:instagramViewController animated:YES completion:nil];
        
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
        UINavigationController *instagramViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"eventView"];
        [self presentViewController:instagramViewController animated:YES completion:nil];
        
    }
    
}

- (void) favouritesButton
{
    
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *instagramViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"favouritesView"];
    [self presentViewController:instagramViewController animated:YES completion:nil];
    
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
        UINavigationController *instagramViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"resultsView"];
        [self presentViewController:instagramViewController animated:YES completion:nil];
        
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
        UINavigationController *instagramViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"instagramView"];
        [self presentViewController:instagramViewController animated:YES completion:nil];
        
    }
    
}

- (void) aboutUsButton
{
    
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *instagramViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"aboutUsView"];
    [self presentViewController:instagramViewController animated:YES completion:nil];
    
}

- (void) logoutButton
{
    
    [self.navigationDropDown removeFromSuperview];
    self.navigationDropDown = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *instagramViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"firstLoginView"];
    [self presentViewController:instagramViewController animated:YES completion:nil];
    
    // Clear Favourites array here
    
}

- (void) removeExtraViews
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
