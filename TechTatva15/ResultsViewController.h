//
//  ResultsViewController.h
//  TechTatva15
//
//  Created by YASH on 22/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface ResultsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,DataModelDelegate>

@property (weak, nonatomic) IBOutlet UITableView *resultsTable;

@end
