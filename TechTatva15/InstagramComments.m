//
//  InstagramComments.m
//  TechTatva15
//
//  Created by Sushant Gakhar on 17/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "InstagramComments.h"

@implementation InstagramComments

- (id) initWithDictionary:(NSDictionary *)dict
{
    
    self = [super init];
    if (self)
    {
        
        _instaComments = [dict objectForKey:@"comment"];
        
    }
    
    return  self;
    
}

@end
