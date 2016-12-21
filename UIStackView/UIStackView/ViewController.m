//
//  ViewController.m
//  UIStackView
//
//  Created by runo on 16/12/15.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController.h"
/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)
@interface ViewController ()

@property(nonatomic,strong) UIStackView *stackView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stackView = ({
        UIStackView *view = [[UIStackView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 300)];
        view.backgroundColor = [UIColor blackColor];
        view.axis = UILayoutConstraintAxisHorizontal;
        view.spacing = 10;
        view.distribution = UIStackViewDistributionFillEqually;
        view.alignment = UIStackViewAlignmentFill;
        [self.view addSubview:view];
        view;
    });
    
    for (int i = 0; i < 10; i++) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:[self arcNumber] green:[self arcNumber] blue:[self arcNumber] alpha:1];
        
        [self.stackView addArrangedSubview:view];
    }
}

-(CGFloat )arcNumber{
    CGFloat f = (arc4random()%255)/255.00f;
    NSLog(@"%.2f",f);
    return f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
