//
//  NSObject+Swizzle.h
//  Meniny
//
//  Created by Meniny on 2015-03-16.
//  Copyright (c) 2015 Meniny. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)

// Discussion: Switches the implementation of two methods. To call the originalSelector, instead call localSelector and vice-versa. Only use this method to swizzle local methods. If you swizzle a method from a superclass with a method from a subclass, whenever you call the method on the superclass, you will receive a 'NSInvalidArgumentException', as the superclass will not have the implementation added; instead, use swizzleSelector:withSuperclassSelector
// Call this to swap two methods on the same class level (not for subclasses)
+ (void)swizzleSelector:(SEL)originalSelector withLocalSelector:(SEL)localSelector;

// Discussion: Switches the implementation of two methods, adding the selector to the superclass. To call the originalSelector, instead call localSelector and vice-versa. This will not override superclass behaviour.
// Call this to swap methods, regardless of class level difference
+ (void)swizzleSuperclassSelector:(SEL)superclassSelector withLocalSelector:(SEL)localSelector;


@end
