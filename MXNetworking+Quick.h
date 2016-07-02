//
//  MXNetworking+Quick.h
//  Meniny
//
//  Created by Meniny on 16/3/17.
//  Copyright © 2016年 Meniny. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import "MXNetworking.h"

@interface MXNetworking (Quick)

+ (void)getRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data callback:(FullResponseCallback)callback;
+ (void)postRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data callback:(FullResponseCallback)callback;
+ (void)putRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data callback:(FullResponseCallback)callback;
+ (void)deleteRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data callback:(FullResponseCallback)callback;
@end
