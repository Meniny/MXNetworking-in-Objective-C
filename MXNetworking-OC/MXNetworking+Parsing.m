//
//  MXNetworking+Parsing.m
//  Meniny
//
//  Created by Meniny on 2014-09-02.
//  Copyright (c) 2014 Meniny. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import "MXNetworking+Parsing.h"
#import "MXNetworking+Information.h"
//#import "UIDevice+Hardware.h"

const NSString * lineBreakString = @"\r\n";

const NSString * kContentDispositionKey = @"Content-Disposition";

@implementation MXNetworking (Parsing)

// JSON
+ (id)parseJSONData:(NSData *)JSONData {
    if(!JSONData)return nil;
    return ([NSJSONSerialization JSONObjectWithData:JSONData
                                            options:0
                                              error:nil
                                      removingNulls:YES
                                       ignoreArrays:NO] ? :
            [self stringFromData:JSONData]);
}

+ (NSData *)dataFromJSONObject:(id)jsonObject {
    if(!jsonObject)return nil;
    return [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:nil];
}

// Parameters
+ (NSString *)stringFromParameters:(NSDictionary *)dictionary {
    NSMutableString *parameterString = [NSMutableString new];
    for(NSString *key in dictionary.allKeys) {
        NSObject *object = dictionary[key];
        
        // We only want to add NSString objects to the string
//        if([object isKindOfClass:[NSString class]]) {
            [parameterString appendFormat:@"%@=%@&", key, object];
//        }
    }
    
    return parameterString;
}

+ (NSData *)dataFromParameters:(NSDictionary *)dictionary {
    return [self dataFromString:[self stringFromParameters:dictionary]];
}

// String
+ (NSString *)stringFromData:(NSData *)data {
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSData *)dataFromString:(NSString *)string {
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

// Multipart
+ (NSData *)multipartDataFromDictionary:(NSDictionary *)dictionary {
    NSString *boundaryString = [NSString stringWithFormat:@"--%@%@", [self boundaryString], lineBreakString];
    
    NSMutableData *multipartData = [NSMutableData new];
    for(NSString *key in dictionary.allKeys) {
        NSObject *object = dictionary[key];
        
        // Initial boundary data - DRY!
        [multipartData appendData:[self dataFromString:boundaryString]];
        
        NSMutableString *multipartString = [NSMutableString new];
        if([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
            [multipartString appendFormat:@"%@: form-data; name=\"%@\";%@", kContentDispositionKey, key, lineBreakString];
            [multipartString appendFormat:@"%@: text/plain%@%@", kContentTypeKey, lineBreakString, lineBreakString];
            [multipartString appendFormat:@"%@%@", object, lineBreakString];
            [multipartData appendData:[self dataFromString:multipartString]];
        }
        else if([object isKindOfClass:[UIImage class]]) {
            NSString *UUID = [NSUUID UUID].UUIDString;
            [multipartString appendFormat:@"%@: form-data; name=\"%@\"; filename=\"webshare%@.jpg\"%@", kContentDispositionKey, key, UUID, lineBreakString];
            [multipartString appendFormat:@"%@: image/jpeg%@%@", kContentTypeKey, lineBreakString, lineBreakString];
            [multipartData appendData:[self dataFromString:multipartString]];
            [multipartData appendData:UIImageJPEGRepresentation((UIImage *)object, 1.0f)];
            [multipartData appendData:[self dataFromString:lineBreakString.copy]];
        }
        else if([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
            [multipartString appendFormat:@"%@: form-data; name=\"%@\";%@", kContentDispositionKey, key, lineBreakString];
            [multipartString appendFormat:@"%@: %@%@%@", kContentTypeKey, kContentTypeJSON, lineBreakString, lineBreakString];
            [multipartString appendFormat:@"%@%@", [self stringFromData:[self dataFromJSONObject:object]], lineBreakString];
            [multipartData appendData:[self dataFromString:multipartString]];
        }
    }
    
    [multipartData appendData:[self dataFromString:[NSString stringWithFormat:@"--%@--%@", [self boundaryString], lineBreakString]]];
    
    return multipartData;
}

@end
