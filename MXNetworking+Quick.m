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

typedef enum : NSUInteger {
    MXRequestMethodTypeGET = 1,
    MXRequestMethodTypePOST = 2,
    MXRequestMethodTypePUT = 3,
    MXRequestMethodTypeDELETE = 4
} MXRequestMethodType;

@implementation MXNetworking (Quick)

+ (void)postUnauthorizedNotificationOnSucess:(FullResponseCallback)success method:(MXRequestMethodType)method url:(NSString *)urlString forType:(RequestType)type data:(NSData *)data {
    [User signInWithAccount:[User defaultUser].phoneNumber encryptPassword:[User defaultUser].passwordMD5String success:^(ResponseStatus status, id responseObject) {
        if (method == MXRequestMethodTypeGET) {
            [MXNetworking getRequestByAppending:urlString forType:type data:data callback:success];
        } else if (method == MXRequestMethodTypePOST) {
            [MXNetworking postRequestByAppending:urlString forType:type data:data callback:success];
        } else if (method == MXRequestMethodTypePUT) {
            [MXNetworking putRequestByAppending:urlString forType:type data:data callback:success];
        } else {
            [MXNetworking deleteRequestByAppending:urlString forType:type data:data callback:success];
        }
    } failure:^(ResponseStatus status, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowSignInNotification object:nil];
    }];
}

+ (BOOL)unauthorized:(ResponseStatus)status responseObject:(id)responseObject {
    if (status == ResponseStatus401) {
        return YES;
    } else {
        if ([responseObject isKindOfClass:[NSString class]] &&
            [(NSString *)responseObject containsString:@"凭证"]) {
//            NSString *s = NSStringWithFormat(@"%@", responseObject);
//            [MXAlertView alert:@[@(status), s] manuallyHide:YES];
            return YES;
        }
    }
    return NO;
}

+ (void)getRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data callback:(FullResponseCallback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self requestWithURL:[self URLByAppendingStringToBaseURL:urlString] forType:type httpMethod:kHTTPMethodGet data:data callback:^(ResponseStatus status, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if ([MXNetworking unauthorized:status responseObject:responseObject]) {
            [MXNetworking postUnauthorizedNotificationOnSucess:callback method:MXRequestMethodTypeGET url:urlString forType:type data:data];
        } else {
            if (callback) {
                callback(status, responseObject);
            }
        }
    }];
}

+ (void)postRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data callback:(FullResponseCallback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self requestWithURL:[self URLByAppendingStringToBaseURL:urlString] forType:type httpMethod:kHTTPMethodPost data:data callback:^(ResponseStatus status, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        UIAlert(@"POST", NSStringWithFormat(@"%zd\n%@", status, responseObject), @"OK");
        if ([MXNetworking unauthorized:status responseObject:responseObject]) {
            [MXNetworking postUnauthorizedNotificationOnSucess:callback method:MXRequestMethodTypePOST url:urlString forType:type data:data];
        } else {
            if (callback) {
                callback(status, responseObject);
            }
        }
    }];
}

+ (void)putRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data callback:(FullResponseCallback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self requestWithURL:[self URLByAppendingStringToBaseURL:urlString] forType:type httpMethod:kHTTPMethodPut data:data callback:^(ResponseStatus status, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if ([MXNetworking unauthorized:status responseObject:responseObject]) {
            [MXNetworking postUnauthorizedNotificationOnSucess:callback method:MXRequestMethodTypePUT url:urlString forType:type data:data];
        } else {
            if (callback) {
                callback(status, responseObject);
            }
        }
    }];
}

+ (void)deleteRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data callback:(FullResponseCallback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self requestWithURL:[self URLByAppendingStringToBaseURL:urlString] forType:type httpMethod:kHTTPMethodDelete data:data callback:^(ResponseStatus status, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if ([MXNetworking unauthorized:status responseObject:responseObject]) {
            [MXNetworking postUnauthorizedNotificationOnSucess:callback method:MXRequestMethodTypeDELETE url:urlString forType:type data:data];
        } else {
            if (callback) {
                callback(status, responseObject);
            }
        }
    }];
}
@end
