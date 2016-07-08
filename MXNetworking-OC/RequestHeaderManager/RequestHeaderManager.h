//
//  RequestHeaderManager.h
//  CloudWings
//
//  Created by Cloud Wings on 15/12/15.
//  Copyright © 2015年 Beijing Cloud Wings Information Technology Co. LTD. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import <Foundation/Foundation.h>

@interface RequestHeaderManager : NSObject
+ (instancetype _Nonnull)sharedManager;

- (BOOL)setAccessToken:(NSString * _Nullable)token;
- (BOOL)shouldSetAccessToken:(NSString * _Nullable)token;
@end
