//
//  ViewController.m
//  OpenOtherAPP
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
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)btnclick:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"main://www.shixueqian.com/abc?title=hello&content=helloworld"];
    [[UIApplication sharedApplication]openURL:url options:nil completionHandler:^(BOOL success) {
        NSLog(@"%@",[NSDate date]);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
