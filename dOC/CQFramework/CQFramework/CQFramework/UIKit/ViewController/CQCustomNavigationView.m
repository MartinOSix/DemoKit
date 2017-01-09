//
//  CQCustomNavigationView.m
//  CQFramework
//
//  Created by runo on 16/12/1.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "CQCustomNavigationView.h"
#import "UIView+CQExtension.h"
#import "CQConstantDefine.h"
#import "NSString+CQExtension.h"
/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)
#define ktNavigationHeight 64
#define ktStatusBarHeight 20
#define ktDefaultTtitleFont 20
#define ktDefaultTextFont 17



@interface CQBackIndicatorView : UIView
@end

@implementation CQCustomNavigationView

@synthesize cqNavigationTitleView = _cqNavigationTitleView;

-(instancetype)init{
    self = [super init];
    if (self) {
        
        _cqBackgroundColor = [UIColor whiteColor];
        _cqIsTransparent = NO;
        self.frame = CGRectMake(0, 0, kScreenWidth, ktNavigationHeight);
        [self cqNavigationDownSpliteLine];
        self.cqNavigationLeftView = [[CQNavBackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/3, kNavigationBar_H-1)];
        self.cqNavigationLeftView.hidden = YES;
    }
    return self;
}

/**导航栏下划线*/
-(UIView *)cqNavigationDownSpliteLine{
    
    if (_cqNavigationDownSpliteLine == nil) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, ktNavigationHeight-0.5, kScreenWidth, 0.5)];
        view.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:view];
        _cqNavigationDownSpliteLine = view;
    }
    return _cqNavigationDownSpliteLine;
}
/**整个nav背景图*/
-(UIImageView *)cqBackgroundImageView{
    if (_cqBackgroundImageView == nil) {
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:imgV];
        [self sendSubviewToBack:imgV];//放到最下层
        _cqBackgroundImageView = imgV;
    }
    return _cqBackgroundImageView;
}
/**状态栏背景图*/
-(UIImageView *)cqStatusBarImageView{
    
    if (_cqStatusBarImageView == nil) {
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, ktStatusBarHeight)];
        [self addSubview:imgV];
        _cqStatusBarImageView = imgV;
    }
    return  _cqStatusBarImageView;
}
/**导航栏正常显示区域*/
-(UIView *)cqNavigationBarView{
    
    if (_cqNavigationBarView == nil) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, ktStatusBarHeight, kScreenWidth, ktNavigationHeight-ktStatusBarHeight)];
        
        [self addSubview:view];
        [self sendSubviewToBack:view];
        _cqNavigationBarView = view;
    }
    return _cqNavigationBarView;
}

/**标题*/
-(void)setCqNavigationTitle:(NSString *)cqNavigationTitle{
    
    if (kIsEmptyString(cqNavigationTitle)) {
        return;
    }
    CGSize titleSize = [cqNavigationTitle cqStringSize:CGSizeMake(0, ktNavigationHeight-1) FontSize:ktDefaultTtitleFont];
    self.cqNavigationTitleView.frame = CGRectMake(0, 0, titleSize.width, kNavigationBar_H-1);
    self.cqNavigationTitleView.center = self.cqNavigationBarView.cqFrame_cornerCenter;
    if ([self.cqNavigationTitleView isKindOfClass:[UILabel class]]) {
        ((UILabel *)self.cqNavigationTitleView).text = cqNavigationTitle;
    }
    _cqNavigationTitle = cqNavigationTitle;
    
}
/**返回键标题*/
-(void)setCqNavigationBackTitle:(NSString *)cqNavigationBackTitle{
    
    if (cqNavigationBackTitle == nil) {
        return;
    }
    if ([self.cqNavigationLeftView isKindOfClass:[CQNavBackView class]]) {
        ((CQNavBackView *)self.cqNavigationLeftView).cqPreviousTitle = cqNavigationBackTitle;
    }
}

#pragma mark - Title left right
/**TitleView*/
-(UIView *)cqNavigationTitleView{
    
    if (_cqNavigationTitleView == nil) {
        UILabel *label = [[UILabel alloc]init];
        label.cqFrame_size = CGSizeMake(100, 30);
        label.font = [UIFont systemFontOfSize:ktDefaultTtitleFont];
        label.textAlignment = NSTextAlignmentCenter;
        label.center = self.cqNavigationBarView.cqFrame_cornerCenter;
        [self.cqNavigationBarView addSubview:label];
        _cqNavigationTitleView = label;
    }
    return _cqNavigationTitleView;
}

-(void)setCqNavigationRightView:(UIView *)cqNavigationRightView{
    
    if (_cqNavigationRightView != nil) {
        [_cqNavigationRightView removeFromSuperview];
        _cqNavigationRightView = nil;
    }
    if (cqNavigationRightView == nil) {
        return;
    }
    [self.cqNavigationBarView addSubview:cqNavigationRightView];
    //右边距 20
    CGFloat marginRight = 15;
    
    self.cqFrame_x = kScreenWidth - marginRight - self.cqFrame_width;
    self.center = CGPointMake(self.cqFrame_x + (self.cqFrame_width)/2, self.cqNavigationBarView.cqFrame_height/2);
    _cqNavigationRightView = cqNavigationRightView;
}

-(void)setCqNavigationLeftView:(UIView *)cqNavigationLeftView{
    
    if (_cqNavigationLeftView != nil) {
        [_cqNavigationLeftView removeFromSuperview];
        _cqNavigationLeftView = nil;
    }
    if (cqNavigationLeftView == nil) {
        return;
    }
    //右边距边距 15
    CGFloat marginLeft = 15;
    cqNavigationLeftView.center = CGPointMake(marginLeft+cqNavigationLeftView.cqFrame_width/2, self.cqNavigationBarView.cqFrame_height/2);
    [self.cqNavigationBarView addSubview:cqNavigationLeftView];
    _cqNavigationLeftView = cqNavigationLeftView;
}

-(void)setCqNavigationTitleView:(UIView *)cqNavigationTitleView{
    
    if (_cqNavigationTitleView != nil) {
        [_cqNavigationTitleView removeFromSuperview];
        _cqNavigationTitleView = nil;
    }
    if (cqNavigationTitleView == nil) {
        return;
    }
    CGFloat right_x = kScreenWidth;
    if (self.cqNavigationRightView) {
        right_x = self.cqNavigationRightView.cqFrame_x;
    }
    CGFloat left_x = 0;
    if (self.cqNavigationLeftView) {
        left_x = self.cqNavigationLeftView.cqFrame_right;
    }

    //先判断居中位置适不适合
    CGFloat titleL = kScreenWidth/2 - cqNavigationTitleView.cqFrame_width/2;
    CGFloat titleR = kScreenWidth/2 + cqNavigationTitleView.cqFrame_width/2;
    
    if (titleL > left_x && titleR < right_x) {//中间合适
        
        cqNavigationTitleView.center = self.cqNavigationBarView.cqFrame_cornerCenter;
        
    }else if ((right_x - left_x) > cqNavigationTitleView.cqFrame_width){//两个部件中间
        
        cqNavigationTitleView.center = CGPointMake((right_x-left_x)/2+left_x, self.cqNavigationBarView.cqFrame_height/2);
        
    }else {//不合适的情况下 强行居中
        kfDebugLog(@"导航栏标题强行居中");
        cqNavigationTitleView.center = self.cqNavigationBarView.cqFrame_cornerCenter;
        
    }
    
    [self.cqNavigationBarView addSubview:cqNavigationTitleView];
    [self.cqNavigationBarView bringSubviewToFront:cqNavigationTitleView];
    _cqNavigationTitleView = cqNavigationTitleView;
    
}

-(void)setCqNavigationTitleColor:(UIColor *)cqNavigationTitleColor{
    if ([self.cqNavigationTitleView isKindOfClass:[UILabel class]]) {
        ((UILabel *)self.cqNavigationTitleView).textColor = cqNavigationTitleColor;
        _cqNavigationTitleColor = cqNavigationTitleColor;
    }
}

-(void)setCqNavigationTitleFont:(UIFont *)cqNavigationTitleFont{
    if ([self.cqNavigationTitleView isKindOfClass:[UILabel class]]) {
        ((UILabel *)self.cqNavigationTitleView).font = cqNavigationTitleFont;
        _cqNavigationTitleFont = cqNavigationTitleFont;
    }
}

/**背景是否透明*/
-(void)setCqIsTransparent:(BOOL)cqIsTransparent{
    self.backgroundColor = [UIColor clearColor];
    _cqIsTransparent = cqIsTransparent;
}

@end

#pragma mark - 返回按钮
#pragma mark Class CQNavBackView
@interface CQNavBackView ()

@property(nonatomic,strong) UILabel *titlelabel;
@property(nonatomic,strong) CQBackIndicatorView *backIndView;

@end

@implementation CQNavBackView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backIndView = ({
            CQBackIndicatorView *view = [[CQBackIndicatorView alloc]initWithFrame:CGRectMake(8, 12, 12, 21)];
            view.backgroundColor = [UIColor clearColor];
            view.userInteractionEnabled = NO;
            [self addSubview:view];
            view;
        });
        self.titlelabel = ({
            UILabel *label = [[UILabel alloc]init];
            NSString *title = @"Back";
            label.textColor = [UIColor colorWithRed:0.f green:122/255.0f blue:1.0f alpha:1.0];
            label.text = title;
            label.font = [UIFont systemFontOfSize:ktDefaultTextFont];
            CGSize defaultSize = [title cqStringSize:CGSizeMake(0, 21) FontSize:ktDefaultTextFont];
            label.frame = CGRectMake(26, 12, defaultSize.width, 21);
            [self addSubview:label];
            frame.size.width = CGRectGetMaxX(label.frame);
            self.frame = frame;
            label;
        });
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setCqPreviousTitle:(NSString *)cqPreviousTitle{
    
    _cqPreviousTitle = cqPreviousTitle;
    CGSize defaultSize = [cqPreviousTitle cqStringSize:CGSizeMake(0, 21) FontSize:ktDefaultTextFont];
    if (CGRectGetMinX(self.titlelabel.frame)+defaultSize.width > kScreenWidth/3) {
        return;
    }else{
        CGRect fram = self.titlelabel.frame;
        fram.size.width = defaultSize.width;
        self.titlelabel.frame = fram;
        fram = self.frame;
        fram.size.width = CGRectGetMaxX(self.titlelabel.frame);
        self.frame = fram;
        self.titlelabel.text = cqPreviousTitle;
    }
}


@end


#pragma mark Class CQBackIndicatorView


@implementation CQBackIndicatorView

-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 2);  //线宽
    //    CGContextSetAllowsAntialiasing(context, true);
    //CGContextSetRGBStrokeColor(context, 255, 255, 255, 1);
    CGContextSetRGBStrokeColor(context, 0 / 255.0, 122 / 255.0, 255 / 255.0, 1.0);  //线的颜色
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, rect.size.width, 0);  //起点坐标
    CGContextAddLineToPoint(context, 3, rect.size.height/2);   //终点坐标
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
    
}

@end
