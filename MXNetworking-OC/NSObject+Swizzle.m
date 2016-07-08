//
//  NSObject+Swizzle.m
//  Meniny
//
//  Created by Meniny on 2015-03-16.
//  Copyright (c) 2015 Meniny. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import <objc/runtime.h>
#import "NSObject+Swizzle.h"

@implementation NSObject (Swizzle)

+ (void)swizzleSelector:(SEL)originalSelector withLocalSelector:(SEL)localSelector {
    // Switches local implementations
    method_exchangeImplementations(class_getInstanceMethod([self class], originalSelector), class_getInstanceMethod([self class], localSelector));
}

+ (void)swizzleSuperclassSelector:(SEL)superclassSelector withLocalSelector:(SEL)localSelector {
    Class class = [self class];
    
    // Capture the original method now, before switching the implementation with class_addMethod
    Method superclassMethod = class_getInstanceMethod(class, superclassSelector);
    Method localMethod = class_getInstanceMethod(class, localSelector);
    
    // Add local implementation of superclass method, with the new selector's implementation; fails if the selector is already local
    if(class_addMethod(class, superclassSelector, method_getImplementation(localMethod), method_getTypeEncoding(localMethod))) {
        // Replaces the superclass' method's implementation with local method's
        class_replaceMethod(class, localSelector, method_getImplementation(superclassMethod), method_getTypeEncoding(superclassMethod));
    }
    // If the superclassSelector is declared in the current class (not inherited), the method cannot be added, but simply needs to swap implementations with the new local method
    else [self swizzleSelector:superclassSelector withLocalSelector:localSelector];
}

@end
