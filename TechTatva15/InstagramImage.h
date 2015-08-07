//
//  InstagramImage.h
//  TechTatva15
//
//  Created by YASH on 15/07/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramImage : NSObject

@property (strong, nonatomic) NSString *url;

- (id) initWithDictionary : (NSDictionary *) dict;

@end