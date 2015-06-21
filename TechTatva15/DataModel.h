//
//  DataModel.h
//  TechTatva15
//
//  Created by YASH on 22/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataModel;

@protocol DataModelDelegate

- (void) jsonRequestDidCompleteWithDict:(NSArray *)array model:(DataModel*)JSONModel;

@end

@interface DataModel : NSObject <NSURLConnectionDelegate>

@property (weak, nonatomic) id <DataModelDelegate> delegate;
@property (strong) NSArray *jsonDictionary;


@property (strong) NSURL *url;

- (void) sendRequestWithUrl:(NSURL*) url;
- (instancetype) initWithDelegate : (id <DataModelDelegate>) delegate;

@end