//
//  BaseAlert.m
//  CQFramework
//
//  Created by runo on 16/11/30.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "BaseAlert.h"
#import "UIView+CQExtension.h"

#define ktAnimationTime 0.35
/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

@interface BaseAlert ()

@property(nonatomic,strong)UIButton *coverBtn;//!<背景Btn

@end

@implementation BaseAlert

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.cqCanClickBackgroundExit = NO;
        self.hidenType = BaseAlertHidenAnimateTypeFormCenter;
        self.showType = BaseAlertShowAnimateTypeCenterScale;
    }
    return self;
}

/**传nil 就是直接添加在window上*/
-(void)cqShowAtController:(UIViewController *)viewController{
    [self cqShowAtController:viewController WithType:self.showType];
}

-(void)cqShowAtController:(UIViewController *)viewController WithType:(BaseAlertShowAnimateType)showType{
    
    UIView *superView = [UIView cqGetMainWindow];
    //这个判断要试
    if ([viewController isKindOfClass:[UIViewController class]]) {
        superView = viewController.view;
    }
    
    UIButton *cover = [[UIButton alloc]init];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.3;
    cover.frame = superView.bounds;
    [cover addTarget:self action:@selector(coverBackgroundClick) forControlEvents:UIControlEventTouchUpInside];
    self.coverBtn = cover;
    [superView addSubview:cover];
    [superView addSubview:self];
    
    if (showType == BaseAlertShowAnimateTypeCenterScale) {
        
        self.center = superView.cqFrame_cornerCenter;
        self.transform = CGAffineTransformMakeScale(0, 0);
        self.alpha = 0;
        [UIView animateWithDuration:ktAnimationTime animations:^{
            self.alpha = 1;
            self.transform = CGAffineTransformMakeScale(1, 1);
        }];
        
    }else if (showType == BaseAlertShowAnimateTypeFormDown) {
        
        CGRect originFram = self.frame;
        self.frame = CGRectMake(originFram.origin.x, kScreenHeight, originFram.size.width, originFram.size.height);
        [UIView animateWithDuration:ktAnimationTime animations:^{
            self.frame = originFram;
        }];
        
    }
    
}

-(void)coverBackgroundClick{
    if (self.cqCanClickBackgroundExit) {
        [self cqHiden];
    }
}

-(void)cqHiden{
    [self cqHidenWithType:self.hidenType];
}

-(void)cqHidenWithType:(BaseAlertHidenAnimateType)hidenType{
    
    if (hidenType == BaseAlertHidenAnimateTypeFormCenter) {
        
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.alpha = 1;
        [UIView animateWithDuration:ktAnimationTime animations:^{
           self.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self.coverBtn removeFromSuperview];
            [self removeFromSuperview];
            self.alpha = 1;
            self.transform = CGAffineTransformMakeScale(1, 1);
        }];
        
    }else if (hidenType == BaseAlertHidenAnimateTypeFormDown){
        
        CGRect originFrame = self.frame;
        [UIView animateWithDuration:ktAnimationTime animations:^{
            self.cqFrame_y = kScreenHeight;
        } completion:^(BOOL finished) {
            [self.coverBtn removeFromSuperview];
            [self removeFromSuperview];
            self.frame = originFrame;
        }];
    }
    
}

@end
