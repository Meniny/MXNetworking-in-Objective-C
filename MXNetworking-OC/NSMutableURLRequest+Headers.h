//
//  NSMutableURLRequest+Headers.h
//  MXNetworking
//
//  Created by Meniny on 2014-09-02.
//  Copyright (c) 2014 Meniny. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (Headers)

+ (NSDictionary *)standardHeaders;
+ (void)setStandardHeaders:(NSDictionary *)standardHeaders;
+ (void)extendHeadersWithSelector:(SEL)extendedHeadersSelector;
// Discussion: Make sure your extendedHeadersSelector calls itself at the end of the implementation (ex: - (void)extendedHeaders{[self extendedHeaders]})
// extendedHeadersSelector: void method that call itself at the end of the implementation (ex: - (void)extendedHeaders{[self extendedHeaders]})

- (void)applyStandardHeaders;
// Discussion: This method is called internally.

@end
