//
//  ViewController.m
//  JSPathDemo2
//
//  Created by runo on 16/12/21.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor orangeColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
 
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)btnclick{
    self.view.backgroundColor = [UIColor blueColor];
    UILabel *label = [[UILabel alloc]init];
    
    NSMutableString *mstr = [[NSMutableString alloc]initWithData:[@"hahaha" dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
