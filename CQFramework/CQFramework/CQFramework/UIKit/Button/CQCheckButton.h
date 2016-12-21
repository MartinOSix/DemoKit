//
//  CQCheckButton.h
//  CQFramework
//
//  Created by runo on 16/11/7.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQCheckButton : UIControl

@property(nonatomic,assign) BOOL cqIsSelected;
@property(nonatomic,assign) BOOL cqCanTouchChange;//!<可否通过直接点击改变，选中状态,默认yes
@property(nonatomic,strong) UIColor *cqTitleColor;//!<默认标题颜色
@property(nonatomic,strong) UIColor *cqSelectTitleColor;//!<选中时标题颜色
@property(nonatomic,strong) NSString *cqTitle;
@property(nonatomic,strong) UIImage *cqNormalImg;
@property(nonatomic,strong) UIImage *cqSelectImg;
@property(nonatomic,strong) UIFont *cqTitleFont;
@property(nonatomic,assign) CGFloat iconHeight;//!<前面图标的宽高

+(CGFloat)CQCheckButtonWidtdWithTitle:(NSString *)title;

-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title;
-(CGFloat)cqCheckButtonWidthWidth;

@end
