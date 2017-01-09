//
//  ViewController.m
//  testReveal
//
//  Created by runo on 16/9/21.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    label.backgroundColor = [UIColor redColor];
    [self.view addSubview:label];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 300, 50, 50)];
    label1.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:label1];
    NSLog(@"呵呵呵呵");
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
