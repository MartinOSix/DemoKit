//
//  NSString+CQExtension.h
//  CQFramework
//
//  Created by runo on 16/11/7.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (CQExtension)

#pragma mark - 字符串判断
+(BOOL)cqCheckPWD:(NSString *)pwd;
+(BOOL)cqIsNullString:(NSString *)string;
-(BOOL)cqIsIDcardNumber:(NSString *)idCard;
-(BOOL)cqIsPhoneNumber;

#pragma mark - 字符串编码
+(NSString *)cqCreateUUID;
-(NSString *)cqGetMD5;
+(NSString *)cqDecodeGTMBase64:(NSString *)decodeStr;
-(NSString *)cqEncodeWithGTMBase64;
-(NSString *)cqTrim;

+(NSString *)cqEncodeDESWithString:(NSString *)string Key:(NSString *)key;
+(NSString *)cqDecodeDESWithString:(NSString *)string Key:(NSString *)key;


#pragma mark - 字符串计算
+(CGFloat)cqStringHeightFromFontSize:(CGFloat)fontSize;
-(CGSize)cqStringSize:(CGSize)maxSize FontSize:(CGFloat)fontSize;
-(CGSize)cqStringSize:(CGSize)maxSize Font:(UIFont *)font;
-(CGFloat)cqStringSingleLineWidthWithFont:(CGFloat)font;
+(NSString *)cqRoundUp:(float)number afterPoint:(int)position;//取小数点后几位

@end
