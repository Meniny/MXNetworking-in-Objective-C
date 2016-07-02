
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

#define MAX_BODY_LENGTH 16384

@implementation MXNetworking (Logs)

+ (void)logRequest:(NSURLRequest *)request {
//#ifdef DEBUG
//#ifdef NSLogSave
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
    NSLog(@"%@", curlString);
//#endif
}

+ (void)logReturnWithData:(NSData *)data statusCode:(NSInteger)statusCode andError:(NSError *)error {
//#ifdef DEBUG
//#ifdef NSLogSave
    NSLog(@"Status Code: %zd", statusCode);
    if(error) {
        NSLog(@"%@", error.description);
    }
    NSLog(@"%@", /*(data.length <= MAX_BODY_LENGTH ? */[self parseJSONData:data]/* : @"Body data was too large; could not output")*/);
//#endif
}

@end
