//
//  EventDataModel.h
//  TechTatva15
//
//  Created by Sushant Gakhar on 08/08/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventDataModel : NSObject

@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSNumber *eventID;
@property (strong, nonatomic) NSString *eventDescription;
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) NSNumber *categoryID;
@property (strong, nonatomic) NSNumber *maximumNumberOfMembersInATeam;
@property (strong, nonatomic) NSNumber *startTiming;
@property (strong, nonatomic) NSNumber *endTiming;
@property (strong, nonatomic) NSNumber *contactNumber;
@property (strong, nonatomic) NSString *results;
@property (strong, nonatomic) NSString *personToContact;
@property  BOOL isFavourite;


+(EventDataModel*) createEventWithName:(NSString *)Event_Name EventID:(NSNumber *)Event_ID eventDescription:(NSString *)Event_Description categoryName:(NSString *)Category_Name CategoryID:(NSNumber *)Category_ID Maximum_Number_Of_MembersInATeam: (NSNumber*) Maximum_Number_Of_Members_In_A_Team StartingTime :(NSNumber *)Event_Starting_Team :(NSNumber *)Event_Starting_Time Event_Ending_Time:(NSNumber *)Event_Ending_Time Contact_Number:(NSNumber *)Contact_Number PersonToContact : (NSString*)Person_To_Contact eventResults:(NSString *)Event_Results;

@end
