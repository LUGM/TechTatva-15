//
//  Events.m
//  Revels'15
//
//  Created by Shubham Sorte on 06/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#import "Event.h"

@implementation Event

-(id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if(self) {
        self.event = [dict objectForKey:@"event"];
        self.location = [dict objectForKey:@"location"];
        self.start = [dict objectForKey:@"start"];
        self.stop = [dict objectForKey:@"stop"];
        self.description = [dict objectForKey:@"description"];
        self.day = [dict objectForKey:@"day"];
        self.category = [dict objectForKey:@"category"];
        self.date = [dict objectForKey:@"date"];
        self.contact = [dict objectForKey:@"contact"];
    }
    return self;
}

@end

