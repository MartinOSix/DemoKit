//
//  UILabel+CQExtension.m
//  CQFramework
//
//  Created by runo on 16/11/7.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "UILabel+CQExtension.h"
#import "UIView+CQExtension.h"
#import "NSString+CQExtension.h"

@implementation UILabel (CQExtension)


/**
 widt <= 0 表示用自己的width
 font == nil 表示用自己的font 下面几个一样
 */
-(void)cqAdjustHeightWithDefault{
    [self cqAdjustHeightWithWidth:0 Font:nil];
}

-(void)cqAdjustHeightWithWidth:(CGFloat)width Font:(UIFont *)font{
    
    CGFloat measureWidth = width;
    if (width <= 0) {
        measureWidth = self.cqFrame_width;
    }
    self.numberOfLines = 0;
    if (font == nil) {
        font = self.font;
    }
    CGSize size = [self.text cqStringSize:CGSizeMake(measureWidth, 0) Font:font];
    self.cqFrame_height = size.height;
}

//这个不好，带段落属性的可能要好
-(void)cqAdjustHeightWithWidth:(CGFloat)width Font:(UIFont *)font StepHeight:(CGFloat)height{
    
    self.numberOfLines = 0;
    if (font == nil) {
        font = self.font;
    }
    if (width <= 0){
        width = self.cqFrame_width;
    }
    CGSize size = [self.text cqStringSize:CGSizeMake(width, 0) Font:font];//目前总size
    CGFloat singleLineHeight = font.lineHeight;//单行高度
    CGFloat step = size.height/singleLineHeight;//计算出有几行
    self.cqFrame_height = step * height;
    
}

-(void)cqAdjustWidthWithDefault{
    [self cqAdjustWidthWithHeight:0 Font:nil];
}
-(void)cqAdjustWidthWithHeight:(CGFloat)height Font:(UIFont *)font{
    
    if (font == nil) {
        font = self.font;
    }
    if (height <= 0){
        height = self.cqFrame_height;
    }
    CGSize size = [self.text cqStringSize:CGSizeMake(0, height) Font:font];
    self.cqFrame_width = size.width;
}

@end
