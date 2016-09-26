//
//  MXNetworking+Information.h
//  Meniny
//
//  Created by Meniny on 2014-09-02.
//  Copyright (c) 2014 Meniny. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import "MXNetworkingMethods.h"

@interface MXNetworking (Information)

+ (BOOL)networkReachable;

// Needs to be set before any network connections using baseURLByAppendingString
+ (NSString *)baseURLString;
+ (void)setBaseURLString:(NSString *)baseURLString;
+ (NSURL *)URLByAppendingStringToBaseURL:(NSString *)specificAPICallString;
/**
 * append parameters like url?param1=value1&param2=value2
 */
+ (NSString *)urlByAppendingParameters:(NSDictionary <NSString *, id> *)args toURL:(NSString *)url;
/**
 * append argument like url/argument
 */
+ (NSString *)urlByAppendingArgument:(NSString *)argument toURL:(NSString *)url;

// Basic Timeout - Default is 30 seconds
+ (NSTimeInterval)timeoutInterval;
+ (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval;

// Allows the statusbar network indicator to show during network connections - Default is YES
+ (BOOL)shouldShowNetworkIndicator;
+ (void)setShouldShowNetworkIndicator:(BOOL)shouldShowNetworkIndicator;

// Needs to be set before any multipart network connections
+ (NSString *)boundaryString;
+ (void)setBoundaryString:(NSString *)boundaryString;

// Default Value: NSURLRequestUseProtocolCachePolicy
// Other common values are NSURLRequestReloadIgnoringLocalAndRemoteCacheData (ignore all caching) and NSURLRequestReturnCacheDataElseLoad
+ (NSURLRequestCachePolicy)cachePolicy;
+ (void)setCachePolicy:(NSURLRequestCachePolicy)cachePolicy;
+ (void)clearCache;

@end
