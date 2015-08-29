//
//  CoreDataModel.m
//  TechTatva15
//
//  Created by YASH on 28/08/15.
//  Copyright (c) 2015 AppDev. All rights reserved.
//

#import "CoreDataModel.h"

@implementation CoreDataModel

+ (NSManagedObjectContext *) managedObjectContext
{
    
    NSManagedObjectContext *context = nil;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext) withObject:self])
    {
        
        context = [delegate managedObjectContext];
        
    }
    
    return context;
    
}
@end
