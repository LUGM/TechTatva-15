//
//  InstagramUser.h
//  TechTatva15
//
//  Created by YASH on 15/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramUser : NSObject

@property (strong, nonatomic) NSString *profileName;
@property (strong, nonatomic) NSString *profilePicture;

- (id) initWithDictionary : (NSDictionary *) dict;

@end