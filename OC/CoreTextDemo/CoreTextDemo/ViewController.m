//
//  ViewController.m
//  CoreTextDemo
//
//  Created by runo on 16/9/22.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "CTDisplayView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CTDisplayView *view = [[CTDisplayView alloc]initWithFrame:CGRectMake(100, 100, 50, 100)];
    view.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:view];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
