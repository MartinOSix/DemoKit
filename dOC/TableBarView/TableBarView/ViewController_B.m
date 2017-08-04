//
//  ViewController_B.m
//  TableBarView
//
//  Created by runo on 17/7/25.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController_B.h"

/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)
@interface ViewController_B ()

@end

@implementation ViewController_B

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 100)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor grayColor];
    view.layer.shadowOffset = CGSizeMake(0, -1);
    view.layer.shadowRadius = 10;
    
    UIBezierPath *bpath = [UIBezierPath bezierPath];
    [bpath moveToPoint:CGPointMake(0, 0)];
    [bpath addLineToPoint:CGPointMake(kScreenWidth/2-30, 0)];
    [bpath addArcWithCenter:CGPointMake(kScreenWidth/2, 0) radius:30 startAngle:M_PI endAngle:M_PI*2 clockwise:YES];
    [bpath addLineToPoint:CGPointMake(kScreenWidth, 0)];
    [bpath addLineToPoint:CGPointMake(kScreenWidth, 1)];
    [bpath addLineToPoint:CGPointMake(0, 1)];
    [bpath addLineToPoint:CGPointMake(0, 0)];
    
    view.layer.shadowPath = bpath.CGPath;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 1;
    
    view.layer.shadowOpacity = 1;
    view.clipsToBounds = NO;
    view.layer.masksToBounds = NO;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)btnclick{
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
