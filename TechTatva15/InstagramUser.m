//
//  InstagramUser.m
//  TechTatva15
//
//  Created by YASH on 15/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "InstagramUser.h"

@implementation InstagramUser

- (id) initWithDictionary:(NSDictionary *)dict
{
    
    self = [super init];
    if (self)
    {
        
        _profileName = [dict objectForKey:@"username"];
        _profilePicture = [dict objectForKey:@"profile_picture"];
    
    }
    
    return  self;
    
}

@end