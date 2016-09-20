
//
//  MXNetworking+Logs.m
//  Meniny
//
//  Created by Meniny on 2014-09-03.
//  Copyright (c) 2014 Meniny. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import "MXNetworking+Logs.h"
#import "MXNetworking+Parsing.h"
#import "NSMutableURLRequest+Headers.h"

#define MAX_BODY_LENGTH 16384

@implementation MXNetworking (Logs)

+ (void)logRequest:(NSURLRequest *)request {
//#ifdef DEBUG
    NSLog(@"%@", [MXNetworking stringWithRequest:request]);
//#endif
}

+ (NSString *)stringWithRequest:(NSURLRequest *)request {
    NSMutableDictionary *standardHeaders = [[NSMutableURLRequest standardHeaders] mutableCopy];
//    NSMutableArray <NSString *>* headersArray = [NSMutableArray array];
//    for (NSString *key in [standardHeaders allKeys]) {
//        [headersArray addObject:[NSString stringWithFormat:@"%@: %@", key, [standardHeaders objectForKey:key]]];
//    }
    
    NSMutableString *log = [NSMutableString new];
    [log appendString:@"● Headers:"];
//    if ([headersArray count]) {
        [log appendString:@"\n"];
//        [log appendString:[headersArray componentsJoinedByString:@"\n"]];
        [log appendFormat:@"%@", standardHeaders];
//}

    NSMutableString *curlString = [NSMutableString new];
    [curlString appendString:@"curl -H"];
    
    // Content Type
    NSString *contentType = [request valueForHTTPHeaderField:kContentTypeKey];
    if(contentType.length)[curlString appendFormat:@" \"%@: %@\"", kContentTypeKey, contentType];
    
    // Method Type
    [curlString appendFormat:@" -X %@", request.HTTPMethod];
    
    // Data
    /*if(request.HTTPBody.length && request.HTTPBody.length < MAX_BODY_LENGTH)*/[curlString appendFormat:@" --data '%@'", [[[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@" "]];
    
    // URL
    [curlString appendFormat:@" %@", request.URL.description];
    
    [log appendFormat:@"\n● %@", curlString];
    
    return log;
}

+ (void)logReturnWithData:(NSData *)data statusCode:(NSInteger)statusCode andError:(NSError *)error {
    //#ifdef DEBUG
    NSLog(@"%@", [MXNetworking stringWithData:data statusCode:statusCode andError:error]);
    //#endif
}

+ (NSString *)stringWithData:(NSData *)data statusCode:(NSInteger)statusCode andError:(NSError *)error {
    NSMutableString *log = [NSMutableString new];

    [log appendFormat:@"● Status Code: %zd", statusCode];

    if(error) {
        [log appendFormat:@"\n● Error:\n%@", ([error localizedDescription] ? [error localizedDescription] : [error description])];
    }
    
    /*(data.length <= MAX_BODY_LENGTH ? *//* : @"Body data was too large; could not output")*/
    [log appendFormat:@"\n● Response:\n%@", [self parseJSONData:data]];
    
    return log;
}

+ (void)logRequest:(NSURLRequest *)request data:(NSData *)data statusCode:(NSInteger)statusCode andError:(NSError *)error {
    NSLog(@"\n%@\n%@", [MXNetworking stringWithRequest:request], [MXNetworking stringWithData:data statusCode:statusCode andError:error]);
}

@end
