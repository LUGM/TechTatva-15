//
//  EventDataModel.m
//  TechTatva15
//
//  Created by Sushant Gakhar on 08/08/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "EventDataModel.h"

@implementation EventDataModel

+(EventDataModel*) createEventWithName:(NSString *)Event_Name EventID:(NSNumber *)Event_ID eventDescription:(NSString *)Event_Description categoryName:(NSString *)Category_Name CategoryID:(NSNumber *)Category_ID Maximum_Number_Of_MembersInATeam:(NSNumber *)Maximum_Number_Of_Members_In_A_Team StartingTime:(NSNumber *)Event_Starting_Team :(NSNumber *)Event_Starting_Time Event_Ending_Time:(NSNumber *)Event_Ending_Time Contact_Number:(NSNumber *)Contact_Number PersonToContact:(NSString *)Person_To_Contact eventResults:(NSString *)Event_Results
{
    EventDataModel *event = [[EventDataModel alloc] init];
    
    event.eventName = Event_Name;
    event.eventID = Event_ID;
    event.eventDescription = Event_Description;
    event.categoryName = Category_Name;
    event.categoryID = Category_ID;
    event.maximumNumberOfMembersInATeam = Maximum_Number_Of_Members_In_A_Team;
    event.startTiming = Event_Starting_Time;
    event.endTiming = Event_Ending_Time;
    event.contactNumber = Contact_Number;
    event.personToContact = Person_To_Contact;
    event.results = Event_Results;
    event.isFavourite = NO;
    
    return event;
    
}

@end
