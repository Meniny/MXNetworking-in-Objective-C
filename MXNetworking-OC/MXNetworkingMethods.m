//
//  MXNetworking.m
//  Meniny
//
//  Created by Meniny on 2012-09-10.
//  Copyright (c) 2012 Meniny. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import "MXNetworkingMethods.h"
#import "MXNetworking+Parsing.h"
#import "NSMutableURLRequest+Headers.h"
#import "MXNetworking+Information.h"
#import "MXNetworking+Logs.h"
#import "Reachability.h"
#import "MXNetworingRequestCountManager.h"

NSString * const kContentLengthKey = @"Content-Length";
NSString * const kContentTypeKey   = @"Content-Type";

NSString * const kHTTPMethodGet    = @"GET";
NSString * const kHTTPMethodPost   = @"POST";
NSString * const kHTTPMethodPut    = @"PUT";
NSString * const kHTTPMethodDelete = @"DELETE";

NSString * const kContentTypeData      = @"x-www-form-urlencoded";
NSString * const kContentTypeJSON      = @"application/json";
NSString * const kContentTypeMultipart = @"multipart/form-data";

@interface MXNetworking ()
@end

@implementation MXNetworking

+ (void)requestWithURL:(NSURL *)url forType:(RequestType)type httpMethod:(NSString *)httpMethod data:(NSData *)data callback:(FullResponseCallback)callback {
    if(![self networkReachable]) {
        if (callback) {
            callback(ResponseStatusNoNetwork, nil, [MXNetworking errorWithURL:url]);
        }
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        MXNetworkingRequestCompletion completion = ^(ResponseStatus status, NSData *responseData, NSError *error) {
            [MXNetworking callbackActionWithStatusCode:status data:responseData error:error callback:callback];
        };
        switch(type) {
            case RequestTypeURL: {
                [MXNetworking startSynchronousConnectionWithURL:url
                                                 withHTTPMethod:httpMethod
                                                     completion:completion];
                break;
            }
                
            case RequestTypeJSON: {
                [MXNetworking startSynchronousConnectionWithURL:url
                                                       JSONData:data
                                                 withHTTPMethod:httpMethod
                                                     completion:completion];
                break;
            }
                
            case RequestTypeData: {
                
                [MXNetworking startSynchronousConnectionWithURL:url
                                                           data:data
                                                 withHTTPMethod:httpMethod
                                                     completion:completion];
                break;
            }
                
            case RequestTypeMultipart: {
                [MXNetworking startSynchronousConnectionWithURL:url
                                                  multipartData:data
                                                 withHTTPMethod:httpMethod
                                                     completion:completion];
                break;
            }
        }
    });
}

+ (void)requestWithURL:(NSURL *)url forType:(RequestType)type httpMethod:(NSString *)httpMethod data:(NSData *)data timeOut:(NSTimeInterval)timeOut callback:(FullResponseCallback)callback {
    if(![self networkReachable]) {
        callback(ResponseStatusNoNetwork, nil, [MXNetworking errorWithURL:url]);
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        MXNetworkingRequestCompletion completion = ^(ResponseStatus status, NSData *responseData, NSError *error) {
            [MXNetworking callbackActionWithStatusCode:status data:responseData error:error callback:callback];
        };
       switch(type) {
           case RequestTypeURL: {
               [MXNetworking startSynchronousConnectionWithURL:url
                                                withHTTPMethod:httpMethod
                                                       timeOut:timeOut
                                                    completion:completion];
               break;
           }
               
           case RequestTypeJSON: {
               [MXNetworking startSynchronousConnectionWithURL:url
                                                      JSONData:data
                                                       timeOut:timeOut
                                                withHTTPMethod:httpMethod
                                                    completion:completion];
               break;
           }
               
           case RequestTypeData: {
               [MXNetworking startSynchronousConnectionWithURL:url
                                                          data:data
                                                withHTTPMethod:httpMethod
                                                       timeOut:timeOut
                                                    completion:completion];
               break;
           }
               
           case RequestTypeMultipart: {
               [MXNetworking startSynchronousConnectionWithURL:url
                                                 multipartData:data
                                                withHTTPMethod:httpMethod
                                                       timeOut:timeOut
                                                    completion:completion];
               break;
           }
               
            default: {
               NSLog(@"do not support the type");
               break;
           }
       }
    });
}

+ (NSError *)errorWithURL:(NSURL *)url {
    return [NSError errorWithDomain:[url absoluteString] code:0 userInfo:@{NSLocalizedDescriptionKey: @"No Network"}];
}

+ (void)callbackActionWithStatusCode:(ResponseStatus)statusCode data:(NSData *)data error:(NSError *)error callback:(FullResponseCallback)callback {
    dispatch_async(dispatch_get_main_queue(), ^ {
        if (callback) {
            callback(statusCode, [self parseJSONData:data], error);
        }
    });
}

+ (NSMutableURLRequest *)requestWithURL:(NSURL *)url HTTPMethod:(NSString *)httpMethod{return [self requestWithURL:url HTTPMethod:httpMethod data:nil];}
+ (NSMutableURLRequest *)requestWithURL:(NSURL *)url HTTPMethod:(NSString *)httpMethod data:(NSData *)data{return [self requestWithURL:url HTTPMethod:httpMethod data:data contentType:nil];}
+ (NSMutableURLRequest *)requestWithURL:(NSURL *)url HTTPMethod:(NSString *)httpMethod data:(NSData *)data contentType:(NSString *)contentType {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:self.cachePolicy
                                                       timeoutInterval:self.timeoutInterval];
    [request applyStandardHeaders];
    [request setHTTPMethod:httpMethod];
    if(data.length) {
        [request setValue:@(data.length).stringValue forHTTPHeaderField:kContentLengthKey];
        [request setHTTPBody:data];
    }
    if(contentType.length)[request setValue:contentType forHTTPHeaderField:kContentTypeKey];
    return request;
}

+ (NSMutableURLRequest *)requestWithURL:(NSURL *)url HTTPMethod:(NSString *)httpMethod data:(NSData *)data contentType:(NSString *)contentType timeOut:(NSTimeInterval)timeOut {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:self.cachePolicy
                                                       timeoutInterval:timeOut];
    [request applyStandardHeaders];
    [request setHTTPMethod:httpMethod];
    if(data.length) {
        [request setValue:@(data.length).stringValue forHTTPHeaderField:kContentLengthKey];
        [request setHTTPBody:data];
    }
    if(contentType.length)[request setValue:contentType forHTTPHeaderField:kContentTypeKey];
    return request;
}

// URL
+ (void)startSynchronousConnectionWithURL:(NSURL *)url withHTTPMethod:(NSString *)httpMethod completion:(MXNetworkingRequestCompletion)completion {
    [self sendRequest:[self requestWithURL:url HTTPMethod:httpMethod] timeOut:NO completion:completion];
}

+ (void)startSynchronousConnectionWithURL:(NSURL *)url withHTTPMethod:(NSString *)httpMethod timeOut:(NSTimeInterval)timeOut completion:(MXNetworkingRequestCompletion)completion {
    [self sendRequest:[self requestWithURL:url HTTPMethod:httpMethod data:nil contentType:nil timeOut:timeOut] timeOut:YES completion:completion];
}

// JSON
+ (void)startSynchronousConnectionWithURL:(NSURL *)url JSONData:(NSData *)JSONData withHTTPMethod:(NSString *)httpMethod  completion:(MXNetworkingRequestCompletion)completion {
    [self sendRequest:[self requestWithURL:url HTTPMethod:httpMethod data:JSONData contentType:kContentTypeJSON] timeOut:NO completion:completion];
}

+ (void)startSynchronousConnectionWithURL:(NSURL *)url JSONData:(NSData *)JSONData timeOut:(NSTimeInterval)timeOut  withHTTPMethod:(NSString *)httpMethod  completion:(MXNetworkingRequestCompletion)completion {
    [self sendRequest:[self requestWithURL:url HTTPMethod:httpMethod data:JSONData contentType:kContentTypeJSON timeOut:timeOut] timeOut:YES completion:completion];
}

// Data
+ (void)startSynchronousConnectionWithURL:(NSURL *)url data:(NSData *)data withHTTPMethod:(NSString *)httpMethod completion:(MXNetworkingRequestCompletion)completion {
    [self sendRequest:[self requestWithURL:url HTTPMethod:httpMethod data:data contentType:kContentTypeData] timeOut:NO completion:completion];
}

+ (void)startSynchronousConnectionWithURL:(NSURL *)url data:(NSData *)data withHTTPMethod:(NSString *)httpMethod timeOut:(NSTimeInterval)timeOut completion:(MXNetworkingRequestCompletion)completion {
    [self sendRequest:[self requestWithURL:url HTTPMethod:httpMethod data:data contentType:kContentTypeData timeOut:timeOut] timeOut:YES completion:completion];
}

// Multipart Form
+ (void)startSynchronousConnectionWithURL:(NSURL *)url multipartData:(NSData *)data withHTTPMethod:(NSString *)httpMethod  completion:(MXNetworkingRequestCompletion)completion {
    NSMutableURLRequest *request = [self requestWithURL:url
                                             HTTPMethod:httpMethod
                                                   data:data
                                            contentType:[NSString stringWithFormat:@"%@;%@", kContentTypeMultipart, (self.boundaryString.length ? [@" boundary=" stringByAppendingString:self.boundaryString] : @"")]];
    [self sendRequest:request timeOut:NO completion:completion];
}

+ (void)startSynchronousConnectionWithURL:(NSURL *)url multipartData:(NSData *)data withHTTPMethod:(NSString *)httpMethod timeOut:(NSTimeInterval)timeOut completion:(MXNetworkingRequestCompletion)completion {
    [self sendRequest:[self requestWithURL:url HTTPMethod:httpMethod data:data contentType:kContentTypeMultipart timeOut:timeOut] timeOut:YES completion:completion];
}

+ (void)sendRequest:(NSMutableURLRequest *)request timeOut:(BOOL)timeOut completion:(MXNetworkingRequestCompletion)completion {
    if ([MXNetworking shouldShowNetworkIndicator]) {
        [MXNetworingRequestCountManager addCount];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
    NSURLSession *session;
    
    if (timeOut) {
        NSURLSessionConfiguration *configuration = [[[NSURLSession sharedSession] configuration] copy];
        [configuration setTimeoutIntervalForRequest:[request timeoutInterval]];
        [configuration setTimeoutIntervalForResource:[request timeoutInterval]];
        session = [NSURLSession sessionWithConfiguration:configuration];
    } else {
        session = [NSURLSession sharedSession];
    }
    
    NSDate *start = [NSDate date];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        ResponseStatus statusCode;
        if (response) {
            statusCode = (ResponseStatus)((NSHTTPURLResponse *)response).statusCode;
        } else {
            statusCode = ResponseStatusNoNetwork;
        }
        
        [MXNetworking logRequest:request standardHeaders:[NSMutableURLRequest standardHeaders] date:start data:data statusCode:statusCode andError:error];
        
        if ([MXNetworking shouldShowNetworkIndicator]) {
            [MXNetworingRequestCountManager subtractCount];
            if (![MXNetworingRequestCountManager currentCount]) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
        }
        
        if (completion) {
            completion(statusCode, data, error);
        }
    }];
    
    [task resume];
}

@end

@implementation MXNetworking (Quick)

+ (void)getRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data callback:(FullResponseCallback)callback {
    [self requestWithURL:[self URLByAppendingStringToBaseURL:urlString]
                 forType:type
              httpMethod:kHTTPMethodGet
                    data:data
                callback:^(ResponseStatus status, id responseObject, NSError *error) {
        if (callback) {
            callback(status, responseObject, error);
        }
    }];
}

+ (void)getRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data timeOut:(NSTimeInterval)timeOut callback:(FullResponseCallback)callback {
    [self requestWithURL:[self URLByAppendingStringToBaseURL:urlString]
                 forType:type
              httpMethod:kHTTPMethodGet
                    data:data
                 timeOut:timeOut
                callback:^(ResponseStatus status, id responseObject, NSError *error) {
                    if (callback) {
                        callback(status, responseObject, error);
                    }
                }];
}

+ (void)postRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data callback:(FullResponseCallback)callback {
    [self requestWithURL:[self URLByAppendingStringToBaseURL:urlString]
                 forType:type
              httpMethod:kHTTPMethodPost
                    data:data
                callback:^(ResponseStatus status, id responseObject, NSError *error) {
        if (callback) {
            callback(status, responseObject, error);
        }
    }];
}

+ (void)postRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data timeOut:(NSTimeInterval)timeOut callback:(FullResponseCallback)callback {
    [self requestWithURL:[self URLByAppendingStringToBaseURL:urlString]
                 forType:type
              httpMethod:kHTTPMethodPost
                    data:data
                 timeOut:timeOut
                callback:^(ResponseStatus status, id responseObject, NSError *error) {
                    if (callback) {
                        callback(status, responseObject, error);
                    }
                }];
}

+ (void)putRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data callback:(FullResponseCallback)callback {
    [self requestWithURL:[self URLByAppendingStringToBaseURL:urlString]
                 forType:type
              httpMethod:kHTTPMethodPut
                    data:data
                callback:^(ResponseStatus status, id responseObject, NSError *error) {
                    if (callback) {
                        callback(status, responseObject, error);
                    }
                }];
}

+ (void)putRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data timeOut:(NSTimeInterval)timeOut callback:(FullResponseCallback)callback {
    [self requestWithURL:[self URLByAppendingStringToBaseURL:urlString]
                 forType:type
              httpMethod:kHTTPMethodPut
                    data:data
                 timeOut:timeOut
                callback:^(ResponseStatus status, id responseObject, NSError *error) {
        if (callback) {
            callback(status, responseObject, error);
        }
    }];
}

+ (void)deleteRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data callback:(FullResponseCallback)callback {
    [self requestWithURL:[self URLByAppendingStringToBaseURL:urlString]
                 forType:type
              httpMethod:kHTTPMethodDelete
                    data:data
                callback:^(ResponseStatus status, id responseObject, NSError *error) {
        if (callback) {
            callback(status, responseObject, error);
        }
    }];
}

+ (void)deleteRequestByAppending:(NSString *)urlString forType:(RequestType)type data:(NSData *)data timeOut:(NSTimeInterval)timeOut callback:(FullResponseCallback)callback {
    [self requestWithURL:[self URLByAppendingStringToBaseURL:urlString]
                 forType:type
              httpMethod:kHTTPMethodDelete
                    data:data
                 timeOut:timeOut
                callback:^(ResponseStatus status, id responseObject, NSError *error) {
        if (callback) {
            callback(status, responseObject, error);
        }
    }];
}

@end
