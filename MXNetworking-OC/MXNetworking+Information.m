//
//  MXNetworking+Information.m
//  Meniny
//
//  Created by Meniny on 2014-09-02.
//  Copyright (c) 2014 Meniny. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import "MXNetworking+Information.h"
#import "Reachability.h"

static NSTimeInterval timeoutInterval = 30.0f;
static BOOL showsActivityIndicator    = YES;
static NSString *baseURLString        = @"";
static NSString *boundaryString       = nil;
static NSURLRequestCachePolicy policy = NSURLRequestUseProtocolCachePolicy;

@implementation MXNetworking (Information)

+ (BOOL)networkReachable{return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);}

// Base URL
+ (NSString *)baseURLString{return baseURLString;}

+ (void)setBaseURLString:(NSString *)_baseURLString{
    baseURLString = _baseURLString;
}

+ (NSURL *)URLByAppendingStringToBaseURL:(NSString *)specificAPICallString {
    NSString *url;
    if ([self baseURLString] != nil && [[self baseURLString] length]) {
        if ([specificAPICallString hasPrefix:@"/"] || [[self baseURLString] hasSuffix:@"/"]) {
            url = [NSString stringWithFormat:@"%@%@", [self baseURLString], specificAPICallString];
        } else {
            url = [NSString stringWithFormat:@"%@/%@", [self baseURLString], specificAPICallString];
        }
    } else {
        url = specificAPICallString;
    }
    return [NSURL URLWithString:[url stringByReplacingOccurrencesOfString:@"//" withString:@"/"]];
}

+ (NSString *)urlByAppendingParameters:(NSDictionary <NSString *, id> *)params toURL:(NSString *)url {
    NSMutableString *paramtersString = [NSMutableString string];
    for (NSInteger i = 0; i < params.allKeys.count; i++) {
        NSString *key = params.allKeys[i];
        [paramtersString appendFormat:@"%@%@=%@", (i ? @"&" : @"?"), key, params[key]];
    }
    return [url stringByAppendingString:paramtersString];
}

+ (NSString *)urlByAppendingArgument:(NSString *)argument toURL:(NSString *)url {
    return [url stringByAppendingFormat:@"%@%@", ([url hasSuffix:@"/"] ? @"" : @"/"), argument];
}

// Timeout
+ (NSTimeInterval)timeoutInterval{return timeoutInterval;}
+ (void)setTimeoutInterval:(NSTimeInterval)_timeoutInterval{timeoutInterval = _timeoutInterval;}

// Network Indicator
+ (BOOL)shouldShowNetworkIndicator{return showsActivityIndicator;}
+ (void)setShouldShowNetworkIndicator:(BOOL)shouldShowNetworkIndicator{showsActivityIndicator = shouldShowNetworkIndicator;}

+ (NSString *)boundaryString{return (boundaryString ? : @"");}
+ (void)setBoundaryString:(NSString *)_boundaryString{boundaryString = _boundaryString;}

// Cache Policy
+ (NSURLRequestCachePolicy)cachePolicy{return policy;}
+ (void)setCachePolicy:(NSURLRequestCachePolicy)cachePolicy{policy = cachePolicy;}
+ (void)clearCache {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
