//
//  NSURL+Runtime.h
//  RuntimeDemo
//
//  Created by runo on 17/7/3.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Runtime)

/**获取成员变量列表，只能获取到当前类，不能获取父类
 * 属性包括.h 文件中property .m文件中extension中定义的property，和 implement class{}中定义的成员变量
 */
+ (NSArray *)fetchIvarList;


/**
 *  获取的是属性列表，包括私有和公有属性
 */
+ (NSArray *)fetchPropertyList;

/**获取对象方法列表*/
+ (NSArray *)fetchInstanceMethodList;

/**获取类方法列表*/
+ (NSArray *)fetchClassMethodList;

/**获取协议列表*/
+ (NSArray *)fetchProtocolList;
@end
