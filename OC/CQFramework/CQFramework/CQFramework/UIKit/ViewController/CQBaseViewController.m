//
//  CQBaseViewController.m
//  CQFramework
//
//  Created by runo on 16/12/1.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "CQBaseViewController.h"
#import "CQConstantDefine.h"
#import "CQCustomNavigationView.h"
@interface CQBaseViewController ()

@end

@implementation CQBaseViewController

#pragma mark - 懒加载
/**屏蔽输入框上移的view*/
-(UIView *)cqShieldKeyBorad{
    
    if (_cqShieldKeyBorad == nil) {
        _cqShieldKeyBorad = [[UIView alloc]init];
        _cqShieldKeyBorad.frame = CGRectZero;
        [self.view addSubview:_cqShieldKeyBorad];
    }
    return _cqShieldKeyBorad;
}
/**是否隐藏状态栏*/
-(BOOL)prefersStatusBarHidden{
    return self.cqHidenStatusBar;
}
-(void)setCqHidenStatusBar:(BOOL)cqHidenStatusBar{
    _cqHidenCustomNavBar = cqHidenStatusBar;
    [self setNeedsStatusBarAppearanceUpdate];
}
/**状态栏样式*/
-(UIStatusBarStyle)preferredStatusBarStyle{
    switch (self.cqStatusBarType) {
        
        case CQStatusBarTypeBlack:
            return UIStatusBarStyleDefault;
            break;
        
        case CQStatusBarTypeWhite:
            return UIStatusBarStyleLightContent;
            break;
        default:
            break;
    }
    return UIStatusBarStyleDefault;
}

/**自定义导航栏*/
-(CQCustomNavigationView *)cqCustomNav{
    if (_cqCustomNav == nil) {
        _cqCustomNav = [[CQCustomNavigationView alloc]init];
        //NSLog(@"previousTitle %@",[CQNavigationUtiles cqGetPreviousController].title);
        //_cqCustomNav.cq_nav_backItemTitle = [CQNavigationUtiles cqGetPreviousController].title;
        if([_cqCustomNav.cqNavigationLeftView isKindOfClass:[CQNavBackView class]]){
            [((CQNavBackView *)_cqCustomNav.cqNavigationLeftView) addTarget:self action:@selector(cqPopBack) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _cqCustomNav;
}

/**隐藏自定义导航栏*/
-(void)setCqHidenNavigationBar:(BOOL)cqHidenNavigationBar{
    [self setCqHidenNavigationBar:cqHidenNavigationBar Animation:NO];
}

/**隐藏自定义导航栏 2*/
-(void)setCqHidenNavigationBar:(BOOL)cqHidenNavigationBar Animation:(BOOL)animation{
    CGRect frame = kScreenBounds;
    CGFloat alpha = 0;
    if (_cqHidenCustomNavBar == cqHidenNavigationBar) {
        return;
    }else{
        if (!cqHidenNavigationBar) {
            frame.origin.y = kNavigationHeight;
            frame.size.height -= kNavigationHeight;
            alpha = 1;
        }
    }
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            self.cqBaseContentView.frame = frame;
            self.cqCustomNav.alpha = alpha;
        }completion:^(BOOL finished) {
            self.cqCustomNav.hidden = cqHidenNavigationBar;
        }];
    }else{
        self.cqBaseContentView.frame = frame;
        self.cqCustomNav.hidden = cqHidenNavigationBar;
    }
    _cqHidenCustomNavBar = cqHidenNavigationBar;
}

/**自定义导航栏透明*/
-(void)setCqCustomNavBarTransparent:(BOOL)cqCustomNavBarTransparent{
    
    self.cqCustomNav.cqIsTransparent = cqCustomNavBarTransparent;
    _cqCustomNavBarTransparent = cqCustomNavBarTransparent;
}


/**主要放内容的ScrollView*/
-(UIScrollView *)cqBaseContentScrollView{
    if (_cqBaseContentScrollView == nil) {
        _cqBaseContentScrollView = [[UIScrollView alloc]init];
        _cqBaseContentScrollView.scrollEnabled = NO;
        _cqBaseContentScrollView.contentOffset = CGPointMake(0, 0);
        if (self.cqHidenCustomNavBar) {
            _cqBaseContentScrollView.frame = kScreenBounds;
        }else{
            CGRect fram = kScreenBounds;
            fram.origin.y = kNavigationHeight;
            fram.size.height -= kNavigationHeight;
            _cqBaseContentScrollView.frame = fram;
        }
    }
    return _cqBaseContentScrollView;
}

/**放内容的View*/
-(UIView *)cqBaseContentView{
    if (_cqBaseContentView == nil) {
        _cqBaseContentView = [[UIView alloc]init];
    
        if (self.cqHidenCustomNavBar) {
            _cqBaseContentView.frame = kScreenBounds;
        }else{
            CGRect fram = kScreenBounds;
            fram.origin.y = kNavigationHeight;
            fram.size.height -= kNavigationHeight;
            _cqBaseContentView.frame = fram;
        }
    }
    return _cqBaseContentView;
}


#pragma mark init
-(instancetype)init{
    self = [super init];
    if (self) {
        _cqHidenStatusBar = NO;
        _cqHidenSystemNavBar = YES;
        _cqHidenCustomNavBar = NO;
        _cqCustomNavBarTransparent = NO;
        _cqStatusBarType = CQStatusBarTypeBlack;
        _cqIsAreadyShow = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //这个好像在切换的时候不自动调整scrollviewContentInset
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.navigationController setNavigationBarHidden:_cqHidenSystemNavBar];
    
    if (!self.cqHidenCustomNavBar) {//不隐藏就创建自定义导航栏
        [self.view addSubview:self.cqCustomNav];
    }
    
    [self.view addSubview:self.cqBaseContentView];
    self.view.backgroundColor = [UIColor whiteColor];
    
}
/**将要消失*/
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.cqIsAreadyShow = NO;
}

/**将要显示*/
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //根据info.plist文件的配置判断状态栏用哪种形式
    NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
    if (![[infoDic objectForKey:@"UIViewControllerBasedStatusBarAppearance"] boolValue]) {
        if (_cqStatusBarType == CQStatusBarTypeWhite) {
            [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        }else{
            [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
        }
    }
    
    //处理系统导航栏显示
    [self.navigationController setNavigationBarHidden:_cqHidenSystemNavBar];
    //自定义导航栏标题
    if (self.navigationController.childViewControllers.count > 1) {
        _cqCustomNav.cqNavigationBackTitle = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count-2].title;
     
        if ([_cqCustomNav.cqNavigationLeftView isKindOfClass:[CQNavBackView class]]) {
            _cqCustomNav.cqNavigationLeftView.hidden = NO;
        }
        
    }else{
        if ([_cqCustomNav.cqNavigationLeftView isKindOfClass:[CQNavBackView class]]) {
            _cqCustomNav.cqNavigationLeftView.hidden = YES;
        }
    }

}

/**已经显示*/
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.cqIsAreadyShow = YES;
    
}


-(void)cqEnableBaseScrollView{
    
}


-(void)cqPopBack{
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    kfDebugLog(@"%@ 收到内存警告", NSStringFromClass([self class]));
}
-(void)dealloc{
    kfDebugLog(@"%@ 销毁", NSStringFromClass([self class]));
}

@end
