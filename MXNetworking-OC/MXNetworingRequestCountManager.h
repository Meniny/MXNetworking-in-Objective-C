//
//  MXNetworingRequestCountManager.h
//  MXNetworking-OC-Demo
//
//  Created by Meniny on 16/7/14.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXNetworingRequestCountManager : NSObject
+ (void)addCount;
- (void)addCount;
+ (void)subtractCount;
- (void)subtractCount;
+ (NSUInteger)currentCount;
- (NSUInteger)currentCount;
+ (instancetype)defaultManager;
@end
