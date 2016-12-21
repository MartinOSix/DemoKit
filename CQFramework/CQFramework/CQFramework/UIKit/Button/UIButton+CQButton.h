//
//  UIButton+CQButton.h
//  AVPlayer
//
//  Created by runo on 16/6/6.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CQButton)

#pragma mark - 设置标题颜色
-(void)cqSetNormalTitle:(NSString *)title;
-(void)cqSetNormalTitleColor:(UIColor *)color;
-(void)cqSetNormalTitleFont:(UIFont *)font;
-(void)cqSetNormalTitle:(NSString *)title Color:(UIColor *)color;
-(void)cqSetNormalTitle:(NSString *)title Color:(UIColor *)color Font:(UIFont *)font;

-(void)cqSetFocusedTitleColor:(UIColor *)color;
-(void)cqSetHighlightedTitleColor:(UIColor *)color;
-(void)cqSetSelectedTitleColor:(UIColor *)color;
-(void)cqSetNormalBackgroundImage:(UIImage *)image;//!<图片
-(void)cqSetSelectBackgroundImage:(UIImage *)image;//!<选中时背景图片

-(void)cqSetNormalImage:(UIImage *)image;
-(void)cqSetSelectedImage:(UIImage *)image;

@end
