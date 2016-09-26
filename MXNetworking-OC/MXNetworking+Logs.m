
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

+ (void)logRequest:(NSURLRequest *)request standardHeaders:(NSDictionary *)standardHeaders date:(NSDate *)date data:(NSData *)data statusCode:(NSInteger)statusCode andError:(NSError *)error {
    /*
     1. Add "-D DEBUG" to "Project -> Target -> Build Settings - Other Swift Flags -> Debug"
     2. Add "DEBUG=1" to "Project -> Target -> Build Settings - Apple LLVM x.x - Preprocessiong -> Preprocessor Macros -> Debug"
     */
    
#ifdef DEBUG
    NSString *sep = @"---------------------";
    NSString *log = [NSString stringWithFormat:@"\n%@\n%@\n%@", sep, [MXNetworking stringWithRequest:request standardHeaders:standardHeaders date:date data:data statusCode:statusCode andError:error], sep];
    // NSLog will not print the whole string while it's too long
    printf("%s", [log cStringUsingEncoding:NSUTF8StringEncoding]);
#endif
}

+ (NSString *)stringWithRequest:(NSURLRequest *)request standardHeaders:(NSDictionary *)standardHeaders date:(NSDate *)date data:(NSData *)data statusCode:(NSInteger)statusCode andError:(NSError *)error {
    NSString *log1 = [MXNetworking stringWithRequest:request standardHeaders:standardHeaders];
    NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:date];
    NSString *log2 = [NSString stringWithFormat:@"● Time Consuming: %lf", duration];
    NSString *log3 = [MXNetworking stringWithData:data statusCode:statusCode andError:error];
    NSString *log = [NSString stringWithFormat:@"%@\n%@\n%@", log1, log2, log3];
    return log;
}

#pragma mark Unicode
+ (NSString *)stringByReplacingUnicodeWithUTF8:(NSString *)string {
    if (string == nil) {
        return @"";
    }
    NSString *tempStr1 = [string stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    if (![tempStr1 containsString:@"\\U"]) {
        return string;
    }
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *tempStr4 = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:nil];
    NSString *result = [tempStr4 stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    if (result == nil) {
        result = @"";
    }
    return result;
}

+ (NSString *)stringWithRequest:(NSURLRequest *)request standardHeaders:(NSDictionary *)standardHeaders {
    NSMutableString *curlString = [NSMutableString new];
    [curlString appendString:@"curl -H"];
    
    // Content Type
    NSString *contentType = [request valueForHTTPHeaderField:kContentTypeKey];
    if(contentType.length)[curlString appendFormat:@" \"%@: %@\"", kContentTypeKey, contentType];
    
    // Method Type
    [curlString appendFormat:@" -X %@", request.HTTPMethod];
    
    // Data
    /*if(request.HTTPBody.length && request.HTTPBody.length < MAX_BODY_LENGTH)*/
    NSString *dataString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    if (dataString == nil) {
        dataString = @"";
    } else {
        dataString = [[dataString stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    }
    [curlString appendFormat:@" --data '%@'", dataString];
    
    // URL
    [curlString appendFormat:@" %@", request.URL.description];
    
    id headerString = ((standardHeaders != nil) ? standardHeaders : @"{}");
    
    NSString *log = [NSString stringWithFormat:@"● %@\n● Headers:\n%@", curlString, headerString];
    
    return [MXNetworking stringByReplacingUnicodeWithUTF8:log];
}

+ (NSString *)stringWithData:(NSData *)data statusCode:(NSInteger)statusCode andError:(NSError *)error {
    NSMutableString *log = [NSMutableString new];

    [log appendFormat:@"● Status Code: %zd", statusCode];

    if (error) {
        [log appendFormat:@"\n● Error:\n%@", ([error localizedDescription] ? [error localizedDescription] : [error description])];
    }
    
    id response = [MXNetworking parseJSONData:data];
    
    NSUInteger length = (data ? [data length] : 0);
    
    [log appendFormat:@"\n● Response [%zd]:", length];
    
    if (response) {
        [log appendFormat:@"\n%@", response];
    } else {
        [log appendString:@" NULL"];
    }
    
    /*data.length <= MAX_BODY_LENGTH*/
    /*@"Body data was too large; could not output"*/
    
    return [MXNetworking stringByReplacingUnicodeWithUTF8:log];
}

@end
