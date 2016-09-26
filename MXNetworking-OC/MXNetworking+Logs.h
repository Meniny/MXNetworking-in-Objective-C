//
//  MXNetworking+Logs.h
//  Meniny
//
//  Created by Meniny on 2014-09-03.
//  Copyright (c) 2014 Meniny. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import "MXNetworkingMethods.h"

@interface MXNetworking (Logs)
+ (void)logRequest:(NSURLRequest *)request standardHeaders:(NSDictionary *)standardHeaders date:(NSDate *)date data:(NSData *)data statusCode:(NSInteger)statusCode andError:(NSError *)error;
@end
