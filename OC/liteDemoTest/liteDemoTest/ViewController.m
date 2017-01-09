//
//  ViewController.m
//  liteDemoTest
//
//  Created by runo on 16/11/15.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test1];
}

//测试 const 关键字
-(void)test1{
    
    int a = 10;
    int b = 20;
    int const *p = &a;
    
//    int * const p = &a;
//    const int *p; //*p只读
//    const  int   * const p //p和*p都只读
//    int  const  * const  p   //p和*p都只读
    p = &b;
    NSLog(@"%d %d  %d",*p,a,b);
    
    
    //同一个内存地址获取的数据不同
    const int end = 10;
    int *contaner = &end;
    *contaner = 12;
    NSLog(@"%p  %p",&end,contaner);
    NSLog(@"%d  %d",*contaner,end);
    
}


@end
