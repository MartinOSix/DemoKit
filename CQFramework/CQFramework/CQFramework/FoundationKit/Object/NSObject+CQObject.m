//
//  NSObject+CQObject.m
//  CarServiceLeague
//
//  Created by runo on 16/8/3.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "NSObject+CQObject.h"
#import <objc/runtime.h>

@implementation NSObject (CQObject)

- (void)cqSetAssociateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cqSetAssociateWeakValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (void)cqRemoveAssociatedValues {
    objc_removeAssociatedObjects(self);
}

- (id)cqGetAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

@end
