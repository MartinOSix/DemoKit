//
//  ViewController.m
//  localizationDemoOC
//
//  Created by runo on 16/12/20.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 100, 90, 30)];
    label.text = NSLocalizedString(@"hehe", nil);
    [self.view addSubview:label];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
