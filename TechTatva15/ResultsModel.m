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
        self.categories = [dict objectForKey:@"Category"];
        self.name = [dict objectForKey:@"Event"];
        self.result = [dict objectForKey:@"Result"];
    }
    return self;
}

@end
