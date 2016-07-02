//
//  NSMutableURLRequest+Headers.m
//  Meniny
//
//  Created by Meniny on 2014-09-02.
//  Copyright (c) 2014 Meniny. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import "NSMutableURLRequest+Headers.h"
#import "NSObject+Swizzle.h"

static NSDictionary *standardHeaders = nil;

@implementation NSMutableURLRequest (Headers)

+ (NSDictionary *)standardHeaders{return standardHeaders;}
+ (void)setStandardHeaders:(NSDictionary *)_standardHeaders{standardHeaders = _standardHeaders;}

+ (void)extendHeadersWithSelector:(SEL)extendedHeadersSelector {
    [[self class] swizzleSelector:@selector(applyStandardHeaders) withLocalSelector:extendedHeadersSelector];
}

- (void)applyStandardHeaders {
    for(NSString *key in standardHeaders.allKeys) {
        [self setValue:standardHeaders[key] forHTTPHeaderField:key];
    }
}

@end
