//
//  ResultsModel.h
//  TechTatva15
//
//  Created by Shubham Sorte on 04/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultsModel : NSObject

@property (nonatomic, strong) NSString *categories;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *result;

@property(nonatomic,strong) NSDictionary *mainDictionary;

-(id)initWithDict:(NSDictionary*)dict;


@end
