//
//  Favourites.h
//  TechTatva15
//
//  Created by YASH on 20/09/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Favourites : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * categoryID;
@property (nonatomic, retain) NSString * contact;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * event;
@property (nonatomic, retain) NSString * eventID;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * maxTeamSize;
@property (nonatomic, retain) NSString * start;
@property (nonatomic, retain) NSString * stop;

@end
