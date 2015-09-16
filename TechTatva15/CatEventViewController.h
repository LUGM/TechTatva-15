//
//  CatEventViewController.h
//  TechTatva15
//
//  Created by YASH on 16/08/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatEventViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *catEventTable;

@property (strong, nonatomic) NSNumber *daySelected;

@property (strong, nonatomic) NSIndexPath *selectedCellIndex;

@end
