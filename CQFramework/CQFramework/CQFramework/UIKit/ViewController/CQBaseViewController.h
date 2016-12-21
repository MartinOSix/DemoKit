//
//  CQBaseViewController.h
//  CQFramework
//
//  Created by runo on 16/12/1.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CQCustomNavigationView;
/**状态栏*/
typedef enum : NSUInteger {
    
    CQStatusBarTypeBlack,
    CQStatusBarTypeWhite,
    
} CQStatusBarType;

@interface CQBaseViewController : UIViewController


@property(nonatomic,assign) BOOL cqHidenCustomNavBar;//!<是否隐藏自定义的导航栏 default NO
@property(nonatomic,assign) BOOL cqHidenSystemNavBar;//!<是否隐藏系统导航栏 default YES
@property(nonatomic,assign) BOOL cqHidenStatusBar;//!<是否隐藏时间电池栏 default NO
@property(nonatomic,assign) BOOL cqCustomNavBarTransparent;//!<自定义导航栏是否透明 default NO
@property(nonatomic,assign) BOOL cqIsAreadyShow;//!<是否显示了

@property(nonatomic,strong) CQCustomNavigationView *cqCustomNav;//!<自定义导航栏
@property(nonatomic,assign) CQStatusBarType cqStatusBarType;//!<状态栏样式
@property(nonatomic,strong) UIImageView *cqBackGroundImageView;//!<全屏背景
@property(nonatomic,strong) UIView *cqBaseContentView;//!<内容View
@property(nonatomic,strong) UIScrollView *cqBaseContentScrollView;//!<主要还是放在上面，如果上面满了就直接把这个放到VC.view上
@property(nonatomic,strong) UIView *cqShieldKeyBorad;//!<屏蔽输入框上移，

-(void)cqPopBack;//!<返回

- (void)viewDidLoad NS_REQUIRES_SUPER;
-(void)viewDidAppear:(BOOL)animated NS_REQUIRES_SUPER;
-(void)viewWillAppear:(BOOL)animated NS_REQUIRES_SUPER;
-(void)viewWillDisappear:(BOOL)animated NS_REQUIRES_SUPER;

-(void)setCqHidenNavigationBar:(BOOL)cqHidenNavigationBar Animation:(BOOL)animation;
-(void)cqEnableBaseScrollView;

@end














