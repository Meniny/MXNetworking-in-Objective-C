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

#import "MXNetworking+Quick.h"
#import "MXNetworking+Information.h"
#import <UIKit/UIKit.h>
#import "MXNetworingRequestCountManager.h"

typedef enum : NSUInteger {
    MXRequestMethodTypeGET = 1,
    MXRequestMethodTypePOST = 2,
    MXRequestMethodTypePUT = 3,
    MXRequestMethodTypeDELETE = 4
} MXRequestMethodType;

@implementation MXNetworking (Quick)

+ (void)getRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data callback:(FullResponseCallback)callback {
    [self requestWithURL:[self URLByAppendingStringToBaseURL:urlString] forType:type httpMethod:kHTTPMethodGet data:data callback:^(ResponseStatus status, id responseObject) {
        if (callback) {
            callback(status, responseObject);
        }
    }];
}

+ (void)postRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data callback:(FullResponseCallback)callback {
    [self requestWithURL:[self URLByAppendingStringToBaseURL:urlString] forType:type httpMethod:kHTTPMethodPost data:data callback:^(ResponseStatus status, id responseObject) {
        if (callback) {
            callback(status, responseObject);
        }
    }];
}

+ (void)putRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data callback:(FullResponseCallback)callback {
    [self requestWithURL:[self URLByAppendingStringToBaseURL:urlString] forType:type httpMethod:kHTTPMethodPut data:data callback:^(ResponseStatus status, id responseObject) {
        if (callback) {
            callback(status, responseObject);
        }
    }];
}

+ (void)deleteRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data callback:(FullResponseCallback)callback {
    [self requestWithURL:[self URLByAppendingStringToBaseURL:urlString] forType:type httpMethod:kHTTPMethodDelete data:data callback:^(ResponseStatus status, id responseObject) {
        if (callback) {
            callback(status, responseObject);
        }
    }];
}
@end
