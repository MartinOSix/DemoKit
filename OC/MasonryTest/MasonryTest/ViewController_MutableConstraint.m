//
//  ViewController_MutableConstraint.m
//  MasonryTest
//
//  Created by runo on 16/12/5.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController_MutableConstraint.h"
#import "Masonry.h"
/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

@interface ViewController_MutableConstraint ()

@end

@implementation ViewController_MutableConstraint{
    
    UILabel *_redLabel;
    UILabel *_greenLabel;
    
    
    
}

/**动态改变约束*/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 100)];
    [self.view addSubview:view];
    _redLabel = [[UILabel alloc]init];
    _redLabel.backgroundColor = [UIColor redColor];
    [view addSubview:_redLabel];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.offset(0);
//        make.top.mas_offset(100);
//        make.height.mas_offset(100);
//    }];
    
    _redLabel.text = @"哈哈哈哈哈哈哈哈哈哈哈";
    
    
    _greenLabel = [[UILabel alloc]init];
    _greenLabel.backgroundColor = [UIColor greenColor];
    [view addSubview:_greenLabel];
    _greenLabel.text = @"哈哈哈哈哈哈哈哈哈哈哈";
    
    [_redLabel setContentCompressionResistancePriority:10 forAxis:UILayoutConstraintAxisHorizontal];
    [_greenLabel setContentCompressionResistancePriority:5 forAxis:UILayoutConstraintAxisHorizontal];
    
    [_redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_offset(0);
        //make.right.equalTo(_greenLabel.mas_left).offset(0);
        make.width.equalTo(view.mas_width).multipliedBy(1/2.0f);
    }];
    
    [_greenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_offset(0);
        make.left.equalTo(_redLabel.mas_right).offset(0);
    }];
    
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(0, 300, kScreenWidth, 30)];
    slider.maximumValue = 100;
    slider.value = 50;
    slider.minimumValue = 0;
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)sliderValueChange:(UISlider *)slider{
    
    
    NSLog(@"%.f",slider.value);
    [_redLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([_redLabel superview].mas_width).multipliedBy(slider.value/100.0f);
    }];
    
}

@end
