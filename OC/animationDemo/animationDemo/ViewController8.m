//
//  ViewController8.m
//  animationDemo
//
//  Created by runo on 16/9/29.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController8.h"

@interface ViewController8 ()

@property(nonatomic,strong)UIView *colorView;
@property(nonatomic,strong)CALayer *colorLayer;
@property(nonatomic,strong)UIButton *btn;

@end

@implementation ViewController8

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.colorView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        [self.view addSubview:view];
        view;
    });
    
    self.btn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 300, 100, 50);
        btn.backgroundColor = [UIColor redColor];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(btnCLick) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    
    _colorLayer = [CALayer layer];
    _colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    _colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.colorView.layer addSublayer:_colorLayer];
    
}

-(void)btnCLick{
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    self.colorLayer.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0f green:arc4random()%255/255.0f blue:arc4random()%255/255.0f alpha:1].CGColor;
    [CATransaction commit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
