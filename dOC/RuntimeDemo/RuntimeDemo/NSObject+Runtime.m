//
//  NSURL+Runtime.m
//  RuntimeDemo
//
//  Created by runo on 17/7/3.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>

@implementation NSObject (Runtime)

//获取对象属性
+ (NSArray *)fetchIvarList
{
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(self, &count);
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++ )
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        const char *ivarName = ivar_getName(ivarList[i]);
        const char *ivarType = ivar_getTypeEncoding(ivarList[i]);
        
        /* type 对应列表
         #define _C_ID       '@'
         #define _C_CLASS    '#'
         #define _C_SEL      ':'
         #define _C_CHR      'c'
         #define _C_UCHR     'C'
         #define _C_SHT      's'
         #define _C_USHT     'S'
         #define _C_INT      'i'
         #define _C_UINT     'I'
         #define _C_LNG      'l'
         #define _C_ULNG     'L'
         #define _C_LNG_LNG  'q'
         #define _C_ULNG_LNG 'Q'
         #define _C_FLT      'f'
         #define _C_DBL      'd'
         #define _C_BFLD     'b'
         #define _C_BOOL     'B'
         #define _C_VOID     'v'
         #define _C_UNDEF    '?'
         #define _C_PTR      '^'
         #define _C_CHARPTR  '*'
         #define _C_ATOM     '%'
         #define _C_ARY_B    '['
         #define _C_ARY_E    ']'
         #define _C_UNION_B  '('
         #define _C_UNION_E  ')'
         #define _C_STRUCT_B '{'
         #define _C_STRUCT_E '}'
         #define _C_VECTOR   '!'
         #define _C_CONST    'r'
         */
        
        dic[@"type"] = [NSString stringWithUTF8String: ivarType];
        dic[@"ivarName"] = [NSString stringWithUTF8String: ivarName];

        [mutableList addObject:dic];
    }
    free(ivarList);
    return [NSArray arrayWithArray:mutableList];
}

+ (NSArray *)fetchPropertyList
{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList(self, &count);
    
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        const char *propertyName = property_getName(propertyList[i]);
        const char *propertyAttr = property_getAttributes(propertyList[i]);
        dic[@"propertyName"] = [NSString stringWithUTF8String:propertyName];
        dic[@"propertyAttr"] = [NSString stringWithUTF8String:propertyAttr];
        [mutableList addObject:dic];
    }
    free(propertyList);
    return [NSArray arrayWithArray:mutableList];
}

+ (NSArray *)fetchInstanceMethodList
{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(self, &count);
    
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++)
    {
        Method method = methodList[i];
        SEL methodName = method_getName(method);
        [mutableList addObject:NSStringFromSelector(methodName)];
    }
    free(methodList);
    return [NSArray arrayWithArray:mutableList];
}

+ (NSArray *)fetchClassMethodList
{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(object_getClass(self), &count);
    Class cls = object_getClass(self);
    
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++)
    {
        Method method = methodList[i];
        SEL methodName = method_getName(method);
        [mutableList addObject:NSStringFromSelector(methodName)];
    }
    free(methodList);
    return [NSArray arrayWithArray:mutableList];
}

+ (NSArray *)fetchProtocolList
{
    unsigned int count = 0;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(self, &count);
    
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++ )
    {
        Protocol *protocol = protocolList[i];
        const char *protocolName = protocol_getName(protocol);
        [mutableList addObject:[NSString stringWithUTF8String:protocolName]];
    }
    
    return [NSArray arrayWithArray:mutableList];
}



@end
