//
//  FavouritesViewController.h
//  TechTatva15
//
//  Created by YASH on 28/08/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface FavouritesViewController : UIViewController <SWTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *favouritesTable;

@property (strong, nonatomic) NSIndexPath *selectedCellIndex;

@end
