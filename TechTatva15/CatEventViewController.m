//
//  CatEventViewController.m
//  TechTatva15
//
//  Created by YASH on 16/08/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "CatEventViewController.h"
#import "DaySegmentedControlView.h"

@interface CatEventViewController ()

@property NSIndexPath *previousSelectedIndexPath;
@property NSIndexPath *currentSelectedIndexPath;

@property DaySegmentedControlView *daySelector;

- (IBAction)dismissVCBarButtonPressed:(UIBarButtonItem *)sender;

@end

@implementation CatEventViewController

@synthesize catEventTable;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 2.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
    
    UIBarButtonItem *dismissVC = [[UIBarButtonItem alloc] init];
    dismissVC.target = self;
    dismissVC.action = @selector(dismissVCBarButtonPressed:);
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DaySegmentedControlView" owner:self options:nil];
    _daySelector = [nib objectAtIndex:0];
    _daySelector.frame = CGRectMake(0, 66, self.view.frame.size.width, 45);
    [_daySelector.daySelectionControl addTarget:self action:@selector(daySelect) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_daySelector];
    
    catEventTable.contentInset = UIEdgeInsetsMake(45, 0, 0, 0);
    catEventTable.scrollsToTop = YES;
    self.view.backgroundColor = [UIColor grayColor];
    _daySelected = @1;
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

# pragma mark Table View Data Source Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 40;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CategoryTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    cell.indexPathForCell = indexPath;
    
    cell.eventNameLabel.text = [NSString stringWithFormat:@"Event no %li on day %@", ((long) indexPath.row + 1), _daySelected];
    cell.eventDetailsTextView.text = @"Add details here";
    
    return cell;
    
}

# pragma mark Table View Delegate Methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.previousSelectedIndexPath = self.currentSelectedIndexPath;
    self.currentSelectedIndexPath = indexPath;
    
    if (self.previousSelectedIndexPath && !([self.previousSelectedIndexPath compare:self.currentSelectedIndexPath] == NSOrderedSame))
    {
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.previousSelectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
    else if ((self.previousSelectedIndexPath) && [self.previousSelectedIndexPath compare:self.currentSelectedIndexPath] == NSOrderedSame)
    {
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.currentSelectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.currentSelectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (([self.currentSelectedIndexPath compare:indexPath] == NSOrderedSame) && ([self.currentSelectedIndexPath compare:self.previousSelectedIndexPath] == NSOrderedSame))
    {
        
        return 40;
        
    }
    
    else if (self.currentSelectedIndexPath != nil && [self.currentSelectedIndexPath compare:indexPath] == NSOrderedSame)
    {
        
        return  250;
        
    }
    
    else
    {
        
        return  40;
        
    }
    
}

# pragma  mark Segmented Control Methods

- (void) daySelect
{
    
    switch (_daySelector.daySelectionControl.selectedSegmentIndex)
    {
            
        case 0:
            _daySelected = @1;
            [catEventTable reloadData];
            break;
            
        case 1:
            _daySelected = @2;
            [catEventTable reloadData];
            break;
            
        case 2:
            _daySelected = @3;
            [catEventTable reloadData];
            break;
            
        case 3:
            _daySelected = @4;
            [catEventTable reloadData];
            break;
            
        default:
            _daySelected = @1;
            [catEventTable reloadData];
            break;
    }
    
}

- (IBAction)dismissVCBarButtonPressed:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//# pragma mark Segue Methods
//
//- (void) dismissThisController
//{
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//
//- (IBAction)dismissCatEventViewBarButton:(UIBarButtonItem *)sender
//{
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}
@end
