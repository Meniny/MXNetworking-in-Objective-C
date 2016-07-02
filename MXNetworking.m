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

#import "MXNetworking.h"
#import "MXNetworking+Parsing.h"
#import "NSMutableURLRequest+Headers.h"
#import "MXNetworking+Information.h"
#import "MXNetworking+Logs.h"
#import "Reachability.h"

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

+ (NSMutableURLRequest *)requestWithURL:(NSURL *)url HTTPMethod:(NSString *)httpMethod;
+ (NSMutableURLRequest *)requestWithURL:(NSURL *)url HTTPMethod:(NSString *)httpMethod data:(NSData *)data;
+ (NSMutableURLRequest *)requestWithURL:(NSURL *)url HTTPMethod:(NSString *)httpMethod data:(NSData *)data contentType:(NSString *)contentType;
+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode;
+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url JSONData:(NSData *)JSONData withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode;
+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url data:(NSData *)data withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode;
+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url multipartData:(NSData *)data withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode;
+ (NSData *)sendRequest:(NSMutableURLRequest *)request withStatusCodePointer:(NSInteger *)statusCode;

@end

@implementation MXNetworking

+ (void)requestWithURL:(NSURL *)url forType:(RequestType)type httpMethod:(NSString *)httpMethod data:(NSData *)data callback:(FullResponseCallback)callback {
    if(![self networkReachable]) {
        if (callback) {
            callback(ResponseStatusNoNetwork, nil);
        }
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
       NSInteger statusCode = 0;
       NSData *returnData = nil;
       switch(type) {
           case RequestTypeURL: {
               returnData = [MXNetworking startSynchronousConnectionWithURL:url
                                                                  withHTTPMethod:httpMethod
                                                                      statusCode:&statusCode];
               break;
           }
               
           case RequestTypeJSON: {
               returnData = [MXNetworking startSynchronousConnectionWithURL:url
                                                                        JSONData:data
                                                                  withHTTPMethod:httpMethod
                                                                      statusCode:&statusCode];
               break;
           }
               
           case RequestTypeData: {
               
               returnData = [MXNetworking startSynchronousConnectionWithURL:url
                                                                            data:data
                                                                  withHTTPMethod:httpMethod
                                                                      statusCode:&statusCode];
               break;
           }
               
           case RequestTypeMultipart: {
               returnData = [MXNetworking startSynchronousConnectionWithURL:url
                                                                   multipartData:data
                                                                  withHTTPMethod:httpMethod
                                                                      statusCode:&statusCode];
               break;
           }
       }
        dispatch_async(dispatch_get_main_queue(), ^ {
            if (callback) {
                callback((ResponseStatus)statusCode, [self parseJSONData:returnData]);
            }
        });
    });
}

+ (void)requestWithURL:(NSURL *)url forType:(RequestType)type httpMethod:(NSString *)httpMethod data:(NSData *)data timeOut:(NSTimeInterval)timeOut callback:(FullResponseCallback)callback {
    if(![self networkReachable]) {
        callback(ResponseStatusNoNetwork, nil);
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
       NSInteger statusCode = 0;
       NSData *returnData = nil;
       switch(type) {
           case RequestTypeJSON: {
               returnData = [MXNetworking startSynchronousConnectionWithURL:url
                                                                        JSONData:data
                                                                         timeOut:timeOut
                                                                  withHTTPMethod:httpMethod
                                                                      statusCode:&statusCode];
               break;
           }
               
           case RequestTypeMultipart: {
               returnData = [MXNetworking startSynchronousConnectionWithURL:url
                                                                   multipartData:data
                                                                  withHTTPMethod:httpMethod
                                                                      statusCode:&statusCode
                                                                         timeOut:timeOut];
               break;
           }
               
            default: {
               NSLog(@"do not support the type");
               break;
           }
       }
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            if (callback) {
                callback((ResponseStatus)statusCode, [self parseJSONData:returnData]);
            }
        });
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
+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode {
    return [self sendRequest:[self requestWithURL:url HTTPMethod:httpMethod] withStatusCodePointer:statusCode];
}

// JSON
+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url JSONData:(NSData *)JSONData withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode {
    return [self sendRequest:[self requestWithURL:url HTTPMethod:httpMethod data:JSONData contentType:kContentTypeJSON] withStatusCodePointer:statusCode];
}

+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url JSONData:(NSData *)JSONData timeOut:(NSTimeInterval)timeOut  withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode {
    return [self sendRequest:[self requestWithURL:url HTTPMethod:httpMethod data:JSONData contentType:kContentTypeJSON timeOut:timeOut] withStatusCodePointer:statusCode];
}

// Data
+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url data:(NSData *)data withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode {
    return [self sendRequest:[self requestWithURL:url HTTPMethod:httpMethod data:data contentType:kContentTypeData] withStatusCodePointer:statusCode];
}

// Multipart Form
+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url multipartData:(NSData *)data withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode {
    return [self sendRequest:[self requestWithURL:url
                                       HTTPMethod:httpMethod
                                             data:data
                                      contentType:[NSString stringWithFormat:@"%@;%@", kContentTypeMultipart, (self.boundaryString.length ? [@" boundary=" stringByAppendingString:self.boundaryString] : @"")]]
       withStatusCodePointer:statusCode];
}

+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url multipartData:(NSData *)data withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode timeOut:(NSTimeInterval)timeOut {
    return [self sendRequest:[self requestWithURL:url HTTPMethod:httpMethod data:data contentType:kContentTypeMultipart timeOut:timeOut] withStatusCodePointer:statusCode];
}

+ (NSData *)sendRequest:(NSMutableURLRequest *)request withStatusCodePointer:(NSInteger *)statusCode {
    [self logRequest:request];
    
    if (self.shouldShowNetworkIndicator) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    *statusCode = [(NSHTTPURLResponse *)response statusCode];
    
    [self logReturnWithData:returnData statusCode:*statusCode andError:error];
    
    if (self.shouldShowNetworkIndicator) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    
    return returnData;
}

@end
