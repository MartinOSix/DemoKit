//
//  NSAttributedString+CQExtension.h
//  CQFramework
//
//  Created by runo on 16/11/7.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSAttributedString (CQExtension)

+(NSAttributedString *)cqCreateAStrWith:(NSString *)str Color:(UIColor *)color FontSize:(CGFloat )fontsize;
+(NSAttributedString *)cqCreateAStrWith:(NSString *)str FontSize:(CGFloat)fontsize;
+(NSAttributedString *)cqCreateAStrWith:(NSString *)str Color:(UIColor *)color;
+(NSMutableAttributedString *)cqCreateMAStrWith:(NSString *)str Color:(UIColor *)color Range:(NSRange)range;
+(NSMutableAttributedString *)cqCreateMAStrWithStr:(NSString *)str Font:(UIFont *)font Range:(NSRange)range;

@end
