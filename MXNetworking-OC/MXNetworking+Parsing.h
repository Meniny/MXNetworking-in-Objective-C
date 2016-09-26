//
//  MXNetworking+Parsing.h
//  Meniny
//
//  Created by Meniny on 2014-09-02.
//  Copyright (c) 2014 Meniny. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import <UIKit/UIKit.h>
#import "MXNetworkingMethods.h"

@interface MXNetworking (Parsing)

// JSON
+ (id)parseJSONData:(NSData *)JSONData;
// Return: An NSDictionary, NSArray or NSString
// Discussion: This method will read the json data, dropping all null values and convert it to an NSDictionary or NSArray, if possible; returns an NSString if the data doesn't follow the json format
+ (NSData *)dataFromJSONObject:(id)jsonObject;
// jsonObject: This object must be an NSDictionary or NSArray, otherwise it will fail

// Parameters
+ (NSString *)stringFromParameters:(NSDictionary *)dictionary;
+ (NSData *)dataFromParameters:(NSDictionary *)dictionary;

// String
+ (NSString *)stringFromData:(NSData *)data;
+ (NSData *)dataFromString:(NSString *)string;

// Multipart
+ (NSData *)multipartDataFromDictionary:(NSDictionary *)dictionary;
// dictionary: Pass in the key value pairs for your multipart request using an NSDictionary. The allowed value types are NSString (plain text), UIImage (jpeg image) and NSDictionary/NSArray (json)

@end
