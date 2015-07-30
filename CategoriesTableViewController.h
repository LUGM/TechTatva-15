//
//  CategoriesTableViewController.h
//  TechTatva15
//
//  Created by YASH on 01/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoriesTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    
    UITableView *categoriesTable;
    
}

- (IBAction)categoryInfoButton:(UIButton *)sender;

@end
