//
//  NSObject+CQObject.h
//  CarServiceLeague
//
//  Created by runo on 16/8/3.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>

_Pragma("clang assume_nonnull begin")

@interface NSObject (CQObject)

#pragma mark - Associate value
///=============================================================================
/// @name Associate value
///=============================================================================

/**
 Associate one object to `self`, as if it was a strong property (strong, nonatomic).
 
 @param value   The object to associate.
 @param key     The pointer to get value from `self`.
 */
- (void)cqSetAssociateValue:(nullable id)value withKey:(void *)key;

/**
 Associate one object to `self`, as if it was a weak property (week, nonatomic).
 
 @param value  The object to associate.
 @param key    The pointer to get value from `self`.
 */
- (void)cqSetAssociateWeakValue:(nullable id)value withKey:(void *)key;

/**
 Get the associated value from `self`.
 
 @param key The pointer to get value from `self`.
 */
- (nullable id)cqGetAssociatedValueForKey:(void *)key;

/**
 Remove all associated values.
 */
- (void)cqRemoveAssociatedValues;

@end

_Pragma("clang assume_nonnull end")
