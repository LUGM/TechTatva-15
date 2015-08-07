//
//  InstagramImage.m
//  TechTatva15
//
//  Created by YASH on 15/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "InstagramImage.h"

@implementation InstagramImage

- (id) initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        
        _url = [dict objectForKey:@"url"];
        
    }
    
    return  self;
    
}

@end