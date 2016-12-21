//
//  UITextField+CQExtension.m
//  CQFramework
//
//  Created by runo on 16/11/30.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "UITextField+CQExtension.h"

/** 通过这个属性名，就可以修改textField内部的占位文字颜色 */
static NSString * const CQPlaceholderColorKeyPath = @"placeholderLabel.textColor";

@implementation UITextField (CQExtension)

-(void)setCqPlaceholderColor:(UIColor *)cqPlaceholderColor{
    // 这3行代码的作用：1> 保证创建出placeholderLabel，2> 保留曾经设置过的占位文字
    NSString *placeholder = self.placeholder;
    self.placeholder = @" ";
    self.placeholder = placeholder;
    
    // 处理placeholderColor为nil的情况：如果是nil，恢复成默认的占位文字颜色
    if (cqPlaceholderColor == nil) {
        cqPlaceholderColor = [UIColor colorWithRed:0 green:0 blue:0.0980392 alpha:0.22];
    }
    // 设置占位文字颜色
    [self setValue:cqPlaceholderColor forKeyPath:CQPlaceholderColorKeyPath];
}

-(UIColor *)cqPlaceholderColor{
    return [self valueForKeyPath:CQPlaceholderColorKeyPath];
}


@end
