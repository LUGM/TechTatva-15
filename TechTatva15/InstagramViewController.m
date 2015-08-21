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

@interface InstagramViewController () <SSJSONModelDelegate>
{

    SSJSONModel *jsonRequest;
    NSMutableArray *userArray;
    NSMutableArray *imagesArray;
    NSMutableArray *likesArray;
    NSMutableArray *commentsArray;
    
    UITableView *instagramTable;
    UIView *background;
    
    NSIndexPath *selectedIndex;
    NSString *imgQualityStringForUrl;
    UIRefreshControl *refreshControl;

}

@property (nonatomic, strong) PQFCirclesInTriangle *circlesInTriangles;

@end

@implementation InstagramViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 2.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
    
    self.title = @"#techtatva15";
    
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
    
    instagramTable.scrollsToTop = YES;
    
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
    
    instagramTable.contentInset = UIEdgeInsetsMake(66, 0, 10, 0);
    
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
    
    return 430;
    
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
