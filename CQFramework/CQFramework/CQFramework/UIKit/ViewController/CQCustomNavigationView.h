//
//  CQCustomNavigationView.h
//  CQFramework
//
//  Created by runo on 16/12/1.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQCustomNavigationView : UIView

@property(nonatomic,strong) UIColor *cqBackgroundColor;//!<default withe
@property(nonatomic,assign) BOOL cqIsTransparent;//!<default NO
@property(nonatomic,strong) UIImageView *cqBackgroundImageView;//!<懒加载
@property(nonatomic,strong) UIImageView *cqStatusBarImageView;//!<懒加载
@property(nonatomic,strong) UIView *cqNavigationBarView;//!<电池栏下面 44

@property(nonatomic,strong) UIView *cqNavigationLeftView;//!<左边区域
@property(nonatomic,strong) UIView *cqNavigationRightView;//!<右边区域
@property(nonatomic,strong) UIView *cqNavigationTitleView;//!<titleView

@property(nonatomic,strong) NSString *cqNavigationTitle;//!<标题
@property(nonatomic,strong) UIColor *cqNavigationTitleColor;
@property(nonatomic,strong) UIFont *cqNavigationTitleFont;

@property(nonatomic,strong) NSString *cqNavigationBackTitle;//!<返回键标题
@property(nonatomic,strong) UIView *cqNavigationDownSpliteLine;//!<分割线 0.5



@end

@interface CQNavBackView : UIControl
@property(nonatomic,strong) NSString *cqPreviousTitle;//!<上一层名字
@end














