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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //不加这个3d效果看不出来
    CATransform3D tran = CATransform3DIdentity;
    tran.m34 = -1.0/500.0;
    self.view.layer.sublayerTransform = tran;
    
    //3D转换，redView沿着y轴逆时针45°
    CATransform3D tran3d_1 = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    self.redView.layer.transform = tran3d_1;
    
//    //redView2 沿着y轴顺时针旋转45°，原点好像在视图中心
//    CATransform3D tran3d_2 = CATransform3DMakeRotation(-M_PI_4, 0, 1, 0);
//    self.redview2.layer.transform = tran3d_2;
    
    [self test];
    
}

-(void)test{
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIImage *digits = [UIImage imageNamed:@"number.png"];
    
    //通过显示layer内容的部分，来做到裁剪图片显示的效果
    for (UIView *view in self.viewArr) {
        view.layer.contents = ((__bridge id)digits.CGImage);
        view.layer.contentsRect = CGRectMake(0, 0, 0.1, 1.0);
        view.layer.contentsGravity = kCAGravityResizeAspect;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [self tick];
    
    
    
    __block CGAffineTransform transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:3 animations:^{
        //缩小一半
        transform = CGAffineTransformScale(transform, 0.5, 0.5);
        self.redview2.transform = transform;
    } completion:^(BOOL finished) {
        //还原缩小
        transform = CGAffineTransformScale(transform, 2, 2);
        self.redview2.transform = transform;
        [UIView animateWithDuration:3 animations:^{
            //顺时针90
            transform = CGAffineTransformRotate(transform, M_PI/2.0f);
            self.redview2.transform = transform;
        
        } completion:^(BOOL finished) {
            //还原顺时针
            transform = CGAffineTransformRotate(transform, -M_PI/2.0f);
            self.redview2.transform = transform;
            [UIView animateWithDuration:3 animations:^{
                //x轴右移200
                transform = CGAffineTransformTranslate(transform, 200, 0);
                self.redview2.transform = transform;
            
            } completion:^(BOOL finished) {
                //还原右移
                transform = CGAffineTransformTranslate(transform, -200, 0);
                self.redview2.transform = transform;
                [UIView animateWithDuration:3 animations:^{
                    //沿y轴逆时针45度
                    CATransform3D tran3d_2 = CATransform3DIdentity;
                    tran3d_2.m34 = -1.0/500.0f;
                    tran3d_2 = CATransform3DRotate(tran3d_2, M_PI_4, 0, 1, 0);
                    self.redview2.layer.transform = tran3d_2;
                } completion:^(BOOL finished) {
                    CATransform3D tran3d_2 = CATransform3DIdentity;
                    tran3d_2.m34 = -1.0/500.0f;
                    tran3d_2 = CATransform3DRotate(tran3d_2, 0, 0, 1, 0);
                    self.redview2.layer.transform = tran3d_2;
                }];
                
            }];
            
        }];
        
    }];
    
    
    
    
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
