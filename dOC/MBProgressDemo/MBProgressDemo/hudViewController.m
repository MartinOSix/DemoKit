//
//  hudViewController.m
//  MBProgressDemo
//
//  Created by runo on 17/3/8.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "hudViewController.h"
#import "UIView+HUD.h"

/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

@interface hudViewController ()

@property(nonatomic,strong) UIView *testView;

@end

@implementation hudViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn =[ UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 70, 30);
    [btn setTitle:@"显示" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    
    UIButton *btn1 =[ UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(100, 200, 70, 30);
    [btn1 setTitle:@"隐藏" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(hiden) forControlEvents:UIControlEventTouchUpInside];
    btn1.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn1];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    
    self.testView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, kScreenWidth, kScreenHeight-200)];
    [self.testView addGestureRecognizer:tap];
    [self.view addSubview:self.testView];
}

-(void)tapClick{
    NSLog(@"tap");
}

-(void)start{
    
    [self.testView hudShowActivityMessageInWindow:@"abc"];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        static int i = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.testView hudShowActivityMessageInWindow:[NSString stringWithFormat:@"progress %zd  ",i]];
        });
        i++;
        NSLog(@"--");
    }];
    
    
}

-(void)hiden{
    [self.testView hudHidenActivity];
}

@end
