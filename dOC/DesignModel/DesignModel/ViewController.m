//
//  ViewController.m
//  DesignModel
//
//  Created by runo on 17/2/20.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "StatePatternViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(100, 100, 100, 100);
    
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)btnClick{
    [self presentViewController:[NSClassFromString(@"MediatorPatternViewController") new] animated:YES completion:nil];
}


@end
