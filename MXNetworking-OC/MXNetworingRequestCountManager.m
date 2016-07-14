//
//  MXNetworingRequestCountManager.m
//  MXNetworking-OC-Demo
//
//  Created by Meniny on 16/7/14.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import "MXNetworingRequestCountManager.h"

@interface MXNetworingRequestCountManager ()
@property (nonatomic, assign) NSUInteger count;
@end

@implementation MXNetworingRequestCountManager
+ (instancetype)defaultManager {
    static MXNetworingRequestCountManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MXNetworingRequestCountManager new];
    });
    return instance;
}

+ (void)addCount {
    [MXNetworingRequestCountManager defaultManager].count += 1;
}

- (void)addCount {
    self.count += 1;
}

+ (void)subtractCount {
    [MXNetworingRequestCountManager defaultManager].count -= 1;
}

- (void)subtractCount {
    self.count -= 1;
}

+ (NSUInteger)currentCount {
    return [[MXNetworingRequestCountManager defaultManager] currentCount];
}

- (NSUInteger)currentCount {
    return [self count];
}
@end
