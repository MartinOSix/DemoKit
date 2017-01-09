//
//  BaseAlert.h
//  CQFramework
//
//  Created by runo on 16/11/30.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BaseAlertShowAnimateTypeCenterScale,
    BaseAlertShowAnimateTypeFormDown,
} BaseAlertShowAnimateType;

typedef enum : NSUInteger {
    BaseAlertHidenAnimateTypeFormCenter,
    BaseAlertHidenAnimateTypeFormDown,
} BaseAlertHidenAnimateType;

/**只做显示消失控制*/
@interface BaseAlert : UIView

@property(nonatomic,assign)BOOL cqCanClickBackgroundExit;//!<能否点击退出 default yes
@property(nonatomic,assign)BaseAlertShowAnimateType showType;//!<显示模式
@property(nonatomic,assign)BaseAlertHidenAnimateType hidenType;//!<隐藏模式

/**如果为空默认添加到window上*/
-(void)cqShowAtController:(UIViewController *)viewController;
-(void)cqShowAtController:(UIViewController *)viewController WithType:(BaseAlertShowAnimateType)showType;

-(void)cqHiden;
-(void)cqHidenWithType:(BaseAlertHidenAnimateType)hidenType;

@end
