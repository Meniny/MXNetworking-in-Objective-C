//
//  NSJSONSerialization+RemovingNulls.m
//  IP Workspace
//
//  Created by Richard Turton & Meniny on 23/12/2013.
//  Copyright (c) 2013 VRG Interactive Inc. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import "NSJSONSerialization+RemovingNulls.h"

@implementation NSJSONSerialization (RemovingNulls)

+ (id)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)options error:(NSError *__autoreleasing *)error removingNulls:(BOOL)removingNulls ignoreArrays:(BOOL)ignoreArrays {
    // Mutable containers are required to remove nulls.
    if(removingNulls) {
        options = options | NSJSONReadingMutableContainers;
    }
    
    id JSONObject = [self JSONObjectWithData:data options:options error:error];
    
    if((error && *error) || !removingNulls)return JSONObject;
    
    [JSONObject recursivelyRemoveNullsIgnoringArrays:ignoreArrays];
    return JSONObject;
}

@end

@implementation NSMutableDictionary (RemovingNulls)

- (void)recursivelyRemoveNulls {
    [self recursivelyRemoveNullsIgnoringArrays:NO];
}

- (void)recursivelyRemoveNullsIgnoringArrays:(BOOL)ignoringArrays {
    // First, filter out directly stored nulls
    NSMutableArray *nullKeys = [NSMutableArray array];
    NSMutableArray *arrayKeys = [NSMutableArray array];
    NSMutableArray *dictionaryKeys = [NSMutableArray array];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
         if(object == [NSNull null])[nullKeys addObject:key];
         else if([object isKindOfClass:[NSDictionary  class]])[dictionaryKeys addObject:key];
         else if([object isKindOfClass:[NSArray class]])[arrayKeys addObject:key];
     }];
    
    // Remove all the nulls
    [self removeObjectsForKeys:nullKeys];
    
    // Recursively remove nulls from arrays
    for(id arrayKey in arrayKeys) {
        [self[arrayKey] recursivelyRemoveNullsIgnoringArrays:ignoringArrays];
    }
    
    // Cascade down the dictionaries
    for(id dictionaryKey in dictionaryKeys) {
        [self[dictionaryKey] recursivelyRemoveNullsIgnoringArrays:ignoringArrays];
    }
}

@end

@implementation NSMutableArray (RemovingNulls)

- (void)recursivelyRemoveNulls {
    [self recursivelyRemoveNullsIgnoringArrays:NO];
}

- (void)recursivelyRemoveNullsIgnoringArrays:(BOOL)ignoringArrays {
    // First, filter out directly stored nulls if required
    if(!ignoringArrays) {
        [self filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return (evaluatedObject != [NSNull null]);
        }]];
        
    }
    
    NSMutableIndexSet *arrayIndexes = [NSMutableIndexSet indexSet];
    NSMutableIndexSet *dictionaryIndexes = [NSMutableIndexSet indexSet];
    
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
         if([object isKindOfClass:[NSDictionary class]])[dictionaryIndexes addIndex:index];
         else if([object isKindOfClass:[NSArray class]])[arrayIndexes addIndex:index];
     }];
    
    // Recursively remove nulls from arrays
    for(NSMutableArray *containedArray in [self objectsAtIndexes:arrayIndexes]) {
        [containedArray recursivelyRemoveNullsIgnoringArrays:ignoringArrays];
    }
    
    // Cascade down the dictionaries
    for(NSMutableDictionary * containedDictionary in [self objectsAtIndexes:dictionaryIndexes]) {
        [containedDictionary recursivelyRemoveNullsIgnoringArrays:ignoringArrays];
    }
}

@end
