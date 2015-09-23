//
//  ResultsModel.m
//  TechTatva15
//
//  Created by Shubham Sorte on 04/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "ResultsModel.h"

@implementation ResultsModel
-(id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if(self) {
        self.categories = [dict objectForKey:@"categoryName"];
        self.name = [dict objectForKey:@"eventName"];
        self.result = [dict objectForKey:@"result"];
    }
    return self;
}

@end
