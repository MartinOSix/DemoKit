//
//  NSAttributedString+CQExtension.m
//  CQFramework
//
//  Created by runo on 16/11/7.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "NSAttributedString+CQExtension.h"

@implementation NSAttributedString (CQExtension)


+(NSAttributedString *)cqCreateAStrWith:(NSString *)str Color:(UIColor *)color FontSize:(CGFloat)fontsize{
    
    NSAttributedString *astr = [[NSAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontsize],NSForegroundColorAttributeName: color}];
    return astr;
}

+(NSAttributedString *)cqCreateAStrWith:(NSString *)str FontSize:(CGFloat)fontsize{
    NSAttributedString *astr = [[NSAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontsize]}];
    return astr;
}

+(NSAttributedString *)cqCreateAStrWith:(NSString *)str Color:(UIColor *)color{
    
    NSAttributedString *astr = [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName: color}];
    return astr;
}
+(NSMutableAttributedString *)cqCreateMAStrWith:(NSString *)str Color:(UIColor *)color Range:(NSRange)range{
    
    if (str == nil ) {
        return nil;
    }
    NSMutableAttributedString *mastr = [[NSMutableAttributedString alloc]initWithString:str];
    [mastr addAttribute:NSForegroundColorAttributeName value:color range:range];
    return mastr;
}

+(NSMutableAttributedString *)cqCreateMAStrWithStr:(NSString *)str Font:(UIFont *)font Range:(NSRange)range{
    if (str == nil) {
        return nil;
    }
    NSMutableAttributedString *mastr = [[NSMutableAttributedString alloc]initWithString:str];
    [mastr addAttribute:NSFontAttributeName value:font range:range];
    return mastr;
}

/**获取Attribute的Size*/
+(CGSize)cqGetSizeFormAStr:(NSAttributedString *)astr WithSize:(CGSize)size{
    
    if (astr == nil) {
        return CGSizeZero;
    }
    
    return [astr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}

@end
