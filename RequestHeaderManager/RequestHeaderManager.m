//
//  RequestHeaderManager.m
//  CloudWings
//
//  Created by Cloud Wings on 15/12/15.
//  Copyright © 2015年 Beijing Cloud Wings Information Technology Co. LTD. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import "RequestHeaderManager.h"
#import "NSMutableURLRequest+Headers.h"

#define AUTHORIZATION_KEY @"Authorization"

@interface RequestHeaderManager ()
@property (nonatomic, strong) NSMutableDictionary *header;
@end

@implementation RequestHeaderManager
+ (instancetype _Nonnull)sharedManager {
    static RequestHeaderManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.header = [NSMutableDictionary dictionary];
        
    });
    return sharedManager;
}

//- (void)setStandardHeaders {
//    [NSMutableURLRequest setStandardHeaders:self.header];
//}

- (BOOL)setAccessToken:(NSString * _Nullable)token {
    if (token != nil) {
        [self.header setObject:[@"Bearer " stringByAppendingString:token] forKey:AUTHORIZATION_KEY];
         [NSMutableURLRequest setStandardHeaders:self.header];
        return YES;
    }
    return NO;
}

- (BOOL)shouldSetAccessToken:(NSString *)token {
    if (token == nil) {
        return NO;
    }
    if (self.header == nil) {
        return YES;
    }
    NSString *tokenInHeader = [self.header objectForKey:AUTHORIZATION_KEY];
    if (tokenInHeader == nil) {
        return YES;
    }
    if (!tokenInHeader.length || ![tokenInHeader isEqualToString:token]) {
        return YES;
    }
    return NO;
}

@end
