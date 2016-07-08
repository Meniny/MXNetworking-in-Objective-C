//
//  Meniny+Authentication.h
//  Meniny
//
//  Created by Meniny on 2014-08-28.
//  Copyright (c) 2014 Meniny. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import "MXNetworking.h"

FOUNDATION_EXTERN NSString * const kAuthorizationKey;

@interface MXNetworking (Authorization)

+ (NSString *)authorizationMethodWithUsername:(NSString *)username password:(NSString *)password url:(NSURL *)url andHTTPMethod:(NSString *)httpMethod;

@end
