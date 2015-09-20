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
        self.event = [dict objectForKey:@"event_name"];
        self.eventID = [dict objectForKey:@"event_id"];
        self.location = [dict objectForKey:@"venue"];
        self.start = [dict objectForKey:@"start_time"];
        self.stop = [dict objectForKey:@"end_time"];
//        self.duration = [dict objectForKey:@"Duration"];
        self.desc = [dict objectForKey:@"description"];
        self.day = [dict objectForKey:@"day"];
        self.category = [dict objectForKey:@"cat_name"];
        self.date = [dict objectForKey:@"date"];
        self.contact = [dict objectForKey:@"contact_name"];
        self.contactNumber = [dict objectForKey:@"contact_number"];
        self.maxTeamSize = [dict objectForKey:@"event_max_team_number"];
        self.catID = [dict objectForKey:@"cat_id"];
    }
    return self;
}

@end

