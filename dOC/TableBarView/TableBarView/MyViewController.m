//
//  MyViewController.m
//  TableBarView
//
//  Created by runo on 17/7/25.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "MyViewController.h"
#import "ViewController.h"
#import "ViewController_B.h"
#import "ViewController_C.h"

/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    ViewController *vc1 = [ViewController new];
    ViewController_B *vc2 = [ViewController_B new];
    ViewController_C *vc3 = [ViewController_C new];
    
    vc1.tabBarItem.title = @"vc1";
    vc2.tabBarItem.title = @"vc2";
    vc3.tabBarItem.title = @"vc3";
    
    
    NSArray *vcs = @[vc1,vc2,vc3];
    
    
    CGFloat width = 30;
    UIBezierPath *bpath = [UIBezierPath bezierPath];
    [bpath moveToPoint:CGPointMake(0, 0)];
    [bpath addLineToPoint:CGPointMake(kScreenWidth/2-width, 0)];
    
    [bpath addQuadCurveToPoint:CGPointMake(kScreenWidth/2+width, 0) controlPoint:CGPointMake(kScreenWidth/2, -width)];
    //[bpath addArcWithCenter:CGPointMake(kScreenWidth/2, 0) radius:width startAngle:M_PI endAngle:M_PI*2 clockwise:YES];
    [bpath addLineToPoint:CGPointMake(kScreenWidth, 0)];
    [bpath addLineToPoint:CGPointMake(kScreenWidth, 1)];
    [bpath addLineToPoint:CGPointMake(0, 1)];
    [bpath addLineToPoint:CGPointMake(0, 0)];

    self.tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.tabBar.layer.shadowRadius = 5;
    self.tabBar.layer.shadowPath = bpath.CGPath;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, 1);
    self.viewControllers = vcs;
    self.tabBar.layer.shadowOpacity = 1;
    self.tabBar.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    
    width += 6;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2-width, -width+width/2, width*2, width*2)];
    view.layer.cornerRadius = width;
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.tabBar addSubview:view];
    [self.tabBar sendSubviewToBack:view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
