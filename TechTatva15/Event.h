//
//  Events.h
//  Revels'15
//
//  Created by Shubham Sorte on 06/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic,strong) NSString *event;
@property (nonatomic,strong) NSString *location;
@property (nonatomic,strong) NSString *start;
@property (nonatomic,strong) NSString *stop;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSNumber * day;
@property (nonatomic,strong) NSString * category;
@property (nonatomic,strong) NSString * date;
@property (nonatomic, retain) NSString * contact;

@property(nonatomic,strong) NSDictionary *mainDictionary;

-(id)initWithDict:(NSDictionary*)dict;

@end
