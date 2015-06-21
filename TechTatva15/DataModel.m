//
//  DataModel.m
//  TechTatva15
//
//  Created by YASH on 22/06/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "DataModel.h"

@interface DataModel()
{
    
    NSMutableData *respondingData;
    
}

@end

@implementation DataModel

- (instancetype) initWithDelegate:(id<DataModelDelegate>)delegate
{
    
    if (self = [super init])
    {
        
        self.delegate = delegate;
        
    }
    return self;
    
}

- (void) sendRequestWithUrl:(NSURL *)url
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Make a url connection and send request
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
}

# pragma mark NSURLConnection Delegate Methods

- (void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    
    // Response received, variable initialisation for appending data in later method
    
    respondingData = [[NSMutableData alloc] init];
    
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    // Adding new data into previous data storing variable
    
    [respondingData appendData:data];
    
}

- (void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    
    // Data has been received, now parsing
    
    _jsonDictionary = [NSJSONSerialization JSONObjectWithData:respondingData options:kNilOptions error:nil];
    [self.delegate jsonRequestDidCompleteWithDict:_jsonDictionary model:self];
    
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    // Error checking method
    
}

@end