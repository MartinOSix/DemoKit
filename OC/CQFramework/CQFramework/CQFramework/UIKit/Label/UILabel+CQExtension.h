//
//  UILabel+CQExtension.h
//  CQFramework
//
//  Created by runo on 16/11/7.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CQExtension)

/**自适应高度*/
-(void)cqAdjustHeightWithDefault;
-(void)cqAdjustHeightWithWidth:(CGFloat)width Font:(UIFont *)font;
/**自适应宽度*/
-(void)cqAdjustWidthWithDefault;
-(void)cqAdjustWidthWithHeight:(CGFloat)height Font:(UIFont *)font;
/**
 *  自动调整高度
 *
 *  @param width  指定宽度
 *  @param font   所用字体，如果为nil则用当前label字体
 *  @param height 步进高度 ---> 最终高度 = 行数 * 这个高度
 */
-(void)cqAdjustHeightWithWidth:(CGFloat)width Font:(UIFont *)font StepHeight:(CGFloat)height;

@end
