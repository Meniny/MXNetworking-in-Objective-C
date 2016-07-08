//
//  NSJSONSerialization+RemovingNulls.h
//  IP Workspace
//
//  Created by Richard Turton & Meniny on 23/12/2013.
//  Copyright (c) 2013 VRG Interactive Inc. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (RemovingNulls)

/// As the base class method, but pass YES to remove nulls from containers, optionally ignoring those in arrays.
+ (id)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)options error:(NSError *__autoreleasing *)error removingNulls:(BOOL)removingNulls ignoreArrays:(BOOL)ignoreArrays;

@end

@interface NSMutableDictionary (RemovingNulls)

- (void)recursivelyRemoveNulls;
- (void)recursivelyRemoveNullsIgnoringArrays:(BOOL)ignoringArrays;

@end

@interface NSMutableArray (RemovingNulls)

- (void)recursivelyRemoveNulls;
- (void)recursivelyRemoveNullsIgnoringArrays:(BOOL)ignoringArrays;

@end
