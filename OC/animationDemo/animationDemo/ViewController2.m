//
//  ViewController2.m
//  animationDemo
//
//  Created by runo on 16/9/28.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController2.h"
#import "NSDate+CQDate.h"
@interface ViewController2 ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewArr;
@property(nonatomic,strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *redview2;

@end

@implementation ViewController2

-(UIButton *)customButton{
    
    CGRect frame = CGRectMake(0, 0, 150, 50);
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.cornerRadius = 10;
    
    frame = CGRectMake(20, 10, 110, 30);
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = @"Hello";
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [btn addSubview:label];
    return btn;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CATransform3D tran = CATransform3DIdentity;
    tran.m34 = -1.0/500.0;
    self.view.layer.sublayerTransform = tran;
    CATransform3D tran3d_1 = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    self.redView.layer.transform = tran3d_1;
    
    CATransform3D tran3d_2 = CATransform3DMakeRotation(-M_PI_4, 0, 1, 0);
    self.redview2.layer.transform = tran3d_2;
    
    
    
}

-(void)test{
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    UIButton *btn = [self customButton];
    btn.center = CGPointMake(50, 150);
    [self.view addSubview:btn];
    
    UIButton *btn2 = [self customButton];
    
    btn2.center = CGPointMake(250, 150);
    btn2.alpha = 0.5;
    [self.view addSubview:btn2];
    
    
    
    
    
    UIImage *digits = [UIImage imageNamed:@"number.png"];
    
    for (UIView *view in self.viewArr) {
        view.layer.contents = ((__bridge id)digits.CGImage);
        view.layer.contentsRect = CGRectMake(0, 0, 0.1, 1.0);
        view.layer.contentsGravity = kCAGravityResizeAspect;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [self tick];
    
    
    //CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/4.0f);
    //self.redView.layer.affineTransform = transform;
    CGAffineTransform transform = CGAffineTransformIdentity;
    //scale by 50%
    transform = CGAffineTransformScale(transform, 0.5, 0.5);
    //rotate by 30 degrees
    transform = CGAffineTransformRotate(transform, M_PI/2.0f);
    transform = CGAffineTransformTranslate(transform, 200, 0);
    
    //self.redView.layer.affineTransform = transform;
    
    CATransform3D transform3d = CATransform3DMakeRotation(M_PI_4, 1, 1, 0);
    //self.redView.layer.transform = transform3d;
    
    CATransform3D tran3d_2 = CATransform3DIdentity;
    tran3d_2.m34 = -1.0/500.0f;
    tran3d_2 = CATransform3DRotate(tran3d_2, M_PI_4, 0, 1, 0);
    self.redView.layer.transform = tran3d_2;
    
}

-(void)setDigit:(NSInteger)digit forView:(UIView *)view{
    view.layer.contentsRect = CGRectMake(digit*0.1, 0, 0.1, 1.0);
}

-(void)tick{
    NSDate *date = [NSDate date];
    [self setDigit:date.cqHour/10 forView:self.viewArr[0]];
    [self setDigit:date.cqHour%10 forView:self.viewArr[1]];
    
    [self setDigit:date.cqMinute/10 forView:self.viewArr[2]];
    [self setDigit:date.cqMinute%10 forView:self.viewArr[3]];
    
    [self setDigit:date.cqSecond/10 forView:self.viewArr[4]];
    [self setDigit:date.cqSecond%10 forView:self.viewArr[5]];
    
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
