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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(100, 100, 100, 30);
    [self.view addSubview:btn];
    
}

-(void)btnclick{
    
    NSString* sOriginPhoneNum = @"023－88888888"; // 中文分隔符－，导致无法拨打电话
    NSMutableCharacterSet *charSet = [[NSMutableCharacterSet alloc] init] ;
    [charSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    [charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    [charSet formUnionWithCharacterSet:[NSCharacterSet symbolCharacterSet]];
    NSArray *arrayWithNumbers = [sOriginPhoneNum componentsSeparatedByCharactersInSet:charSet];
    NSString *numberStr = [arrayWithNumbers componentsJoinedByString:@""];
    if (! numberStr) {
        numberStr = @"";  
    }  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
