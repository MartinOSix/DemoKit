//
//  UIView+CQExtension.m
//  CQFramework
//
//  Created by runo on 16/11/7.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "UIView+CQExtension.h"
#import "CQColorDefine.h"
#import <objc/runtime.h>

static const char *effectviewKey;//模糊View的key

@implementation UIView (CQExtension)

-(CGFloat)cqFrame_x{
    return self.frame.origin.x;
}
-(void)setCqFrame_x:(CGFloat)cqFrame_x{
    CGRect frame = self.frame;
    frame.origin.x = cqFrame_x;
    self.frame = frame;
}

-(CGFloat)cqFrame_y{
    return self.frame.origin.y;
}
-(void)setCqFrame_y:(CGFloat)cqFrame_y{
    CGRect frame = self.frame;
    frame.origin.y = cqFrame_y;
    self.frame = frame;
}

-(CGFloat)cqFrame_width{
    return self.frame.size.width;
}
-(void)setCqFrame_width:(CGFloat)cqFrame_width{
    CGRect frame = self.frame;
    frame.size.width = cqFrame_width;
    self.frame = frame;
}

-(CGFloat)cqFrame_height{
    return self.frame.size.height;
}
-(void)setCqFrame_height:(CGFloat)cqFrame_height{
    CGRect frame = self.frame;
    frame.size.height = cqFrame_height;
    self.frame = frame;
}

-(CGFloat)cqFrame_centerX{
    return self.center.x;
}
-(void)setCqFrame_centerX:(CGFloat)cqFrame_centerX{
    CGPoint point = self.center;
    point.x = cqFrame_centerX;
    self.center = point;
}

-(CGFloat)cqFrame_centerY{
    return self.center.y;
}
-(void)setCqFrame_centerY:(CGFloat)cqFrame_centerY{
    CGPoint point = self.center;
    point.y = cqFrame_centerY;
    self.center = point;
}

-(CGFloat)cqFrame_left{
    return self.frame.origin.x;
}
-(CGFloat)cqFrame_right{
    return self.frame.origin.x + self.frame.size.width;
}
-(CGFloat)cqFrame_top{
    return self.frame.origin.y;
}
-(CGFloat)cqFrame_bottom{
    return self.frame.origin.y+self.frame.size.height;
}
-(CGPoint)cqFrame_cornerCenter{
    return CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

-(CGPoint)cqFrame_origin{
    return self.frame.origin;
}
-(void)setCqFrame_origin:(CGPoint)cqFrame_origin{
    CGRect frame = self.frame;
    frame.origin = cqFrame_origin;
    self.frame = frame;
}

-(CGSize)cqFrame_size{
    return self.frame.size;
}
-(void)setCqFrame_size:(CGSize)cqFrame_size{
    CGRect frame = self.frame;
    frame.size = cqFrame_size;
    self.frame = frame;
}

//切圆角，还不能设置颜色
-(void)cqEachCornerRadius:(UIRectCorner)corner counerRadius:(CGFloat)radius{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //可能设置maskLayer.strokeColor就能设置颜色
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

-(BOOL)cqPoint:(CGPoint)point inSubView:(UIView *)subview{
    
    CGPoint aftPoint = [self convertPoint:point toView:subview];
    return aftPoint.x <= subview.frame.size.width && aftPoint.x >= 0 && aftPoint.y >= 0 &&aftPoint.y<= subview.frame.size.height;
    //下面没转而已，不知道对间隔了两层的view有没有用
    //return point.x >= subview.frame.origin.x && point.x <= subview.frame.origin.x+subview.frame.size.width && point.y >= subview.frame.origin.y && point.y <= subview.frame.origin.y+subview.frame.size.height;
}

-(void)cqShowBorder{
    [self cqShowBorderWithColor:kRedColor Width:1];
}

-(void)cqShowBorderWithColor:(UIColor *)color{
    [self cqShowBorderWithColor:color Width:1];
}

-(void)cqShowBorderWithColor:(UIColor *)color Width:(CGFloat)width{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

-(void)cqHideBorder{
    self.layer.borderWidth = 0;
    self.layer.borderColor = kClearColor.CGColor;
}

/**获取该View的截屏*/
-(UIImage *)cqImageFromSelfView{
    
    //    UIGraphicsBeginImageContext(self.bounds.size);
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
    
}

-(void)cqMakeBlurEffect:(UIBlurEffectStyle)style{
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:style];
    
    UIVisualEffectView *effectview = (UIVisualEffectView *)objc_getAssociatedObject(self, &effectviewKey);
    if (effectview != nil) {
        effectview.effect = blur;
        
        return;
    }else{
        effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        objc_setAssociatedObject(self, &effectviewKey, effectview, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        effectview.frame = self.bounds;
        [self addSubview:effectview];
    }
}

-(void)cqRemoveBlurEffect{
    
    UIVisualEffectView *effectview = (UIVisualEffectView *)objc_getAssociatedObject(self, &effectviewKey);
    if (effectview == nil) {
        return;
    }
    [effectview removeFromSuperview];
    objc_setAssociatedObject (self, &effectviewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)cqIntersectsWithView:(UIView *)view{
    //都先转换为相对于窗口的坐标，然后进行判断是否重合
    CGRect selfRect = [self convertRect:self.bounds toView:nil];
    CGRect viewRect = [view convertRect:view.bounds toView:nil];
    return CGRectIntersectsRect(selfRect, viewRect);
}

+(UIView *)cqCreateGradientView:(CGRect)frame StartColor:(UIColor *)startColor endColor:(UIColor *)endColor Direction:(NSInteger)direction{
    
    UIView *view = [[UIView alloc]initWithFrame:frame];
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc]init];
    gradientLayer.colors = @[(__bridge id)startColor.CGColor,(__bridge id)endColor.CGColor];
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(0, 0);
    
    switch (direction) {
        case 0://从左到右
            startPoint = CGPointMake(0, 1);
            endPoint = CGPointMake(1, 1);
            break;
        case 1://左上到右下
            startPoint = CGPointMake(0, 0);
            endPoint = CGPointMake(1, 1);
            break;
        case 2://坐下右上
            startPoint = CGPointMake(0, 1);
            endPoint = CGPointMake(1, 0);
            break;
        default:
            break;
    }
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [view.layer addSublayer:gradientLayer];
    return view;
}

-(UIViewController *)cqGetController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

+(UIWindow *)cqGetMainWindow{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    return keywindow;
}


@end
