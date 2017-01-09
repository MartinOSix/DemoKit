//
//  UIView+CQExtension.h
//  CQFramework
//
//  Created by runo on 16/11/7.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CQExtension)

@property(nonatomic,assign) CGFloat cqFrame_x;//!< frame.origin.x
@property(nonatomic,assign) CGFloat cqFrame_y;//!< frame.origin.y
@property(nonatomic,assign) CGFloat cqFrame_width;//!< frame.size.width
@property(nonatomic,assign) CGFloat cqFrame_height;//!< frame.size.height
@property(nonatomic,assign) CGPoint cqFrame_origin;//!< frame.origin
@property(nonatomic,assign) CGSize  cqFrame_size;//!< frame.size
@property(nonatomic,assign) CGFloat cqFrame_centerX;//!< frame.center.x
@property(nonatomic,assign) CGFloat cqFrame_centerY;//!< frme.center.y
@property(nonatomic,readonly,assign) CGFloat cqFrame_left;//!<frame.origin.x
@property(nonatomic,readonly,assign) CGFloat cqFrame_right;//!< frame.origin.x + frame.size.width
@property(nonatomic,readonly,assign) CGFloat cqFrame_top;//!<frame.origin.y
@property(nonatomic,readonly,assign) CGFloat cqFrame_bottom;//!<frame.origin.y + frame.size.height

/**自己view的中心点*/
-(CGPoint)cqFrame_cornerCenter;

/**判断一个点是否在该View的subview上*/
-(BOOL)cqPoint:(CGPoint)point inSubView:(UIView *)subview;
/**判断是否跟另一个View重叠*/
-(BOOL)cqIntersectsWithView:(UIView *)view;
/**给View的某个角设置圆角*/
-(void)cqEachCornerRadius:(UIRectCorner)corner counerRadius:(CGFloat)radius;
/**显示边界*/
-(void)cqShowBorder;
-(void)cqHideBorder;
-(void)cqShowBorderWithColor:(UIColor *)color;
-(void)cqShowBorderWithColor:(UIColor *)color Width:(CGFloat)width;
/**获取该View的截屏*/
-(UIImage *)cqImageFromSelfView;
/**模糊一个View*/
-(void)cqMakeBlurEffect:(UIBlurEffectStyle)style NS_AVAILABLE_IOS(8_0);
-(void)cqRemoveBlurEffect NS_AVAILABLE_IOS(8_0);

/**创建一个渐变颜色的View*/
+(UIView *)cqCreateGradientView:(CGRect)frame StartColor:(UIColor *)startColor endColor:(UIColor *)endColor Direction:(NSInteger)direction;

-(UIViewController *)cqGetController;
+(UIWindow *)cqGetMainWindow;

@end
