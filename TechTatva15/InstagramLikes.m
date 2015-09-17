//
//  InstagramLikes.m
//  TechTatva15
//
//  Created by Sushant Gakhar on 17/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "InstagramLikes.h"

@implementation InstagramLikes

- (id) initWithDictionary:(NSDictionary *)dict
{
    
    self = [super init];
    if (self)
    {
        
        _instaLikes = [dict objectForKey:@"count"];
        
    }
    
    return  self;
    
}

@end
