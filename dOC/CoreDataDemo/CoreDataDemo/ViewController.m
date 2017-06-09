//
//  ViewController.m
//  CoreDataDemo
//
//  Created by runo on 17/6/5.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"
@interface CustomView : UIScrollView<UIGestureRecognizerDelegate>

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"-- %@,%f",str, ceil(2.5));
    int a = 10,b = 20;
    int *p = &a;
    *p = 20;
    printf("%d %d \n",a,*p);
    
    CustomView *cview =[[CustomView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    cview.backgroundColor = [UIColor redColor];
    [self.view addSubview:cview];
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    NSMutableArray *marr2 = [mutableArray mutableCopy];
    int it = 1;
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"vc touch began");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



@implementation CustomView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"customer view touch began");
    [self.nextResponder touchesBegan:touches withEvent:event];
}




@end
