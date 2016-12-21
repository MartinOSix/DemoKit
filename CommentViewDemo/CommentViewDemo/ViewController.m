//
//  ViewController.m
//  CommentViewDemo
//
//  Created by runo on 16/10/27.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "CommentView.h"
#import "SJPhotoPicker.h"
#import "BViewController.h"

@interface ViewController ()

@property(nonatomic,strong)CommentView *cview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    

    [self test1];
    
    
    
}

-(void)test1{
    self.cview = [[CommentView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 300)];
    self.cview.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_cview];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 400, 100, 30);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"获取数据" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(hahha) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

-(void)hahha{
    
    BViewController *bv = [BViewController new];
    /*
     UIViewAnimationOptionLayoutSubviews            = 1 <<  0,
     UIViewAnimationOptionAllowUserInteraction      = 1 <<  1, // turn on user interaction while animating
     UIViewAnimationOptionBeginFromCurrentState     = 1 <<  2, // start all views from current value, not initial value
     UIViewAnimationOptionRepeat                    = 1 <<  3, // repeat animation indefinitely
     UIViewAnimationOptionAutoreverse               = 1 <<  4, // if repeat, run animation back and forth
     UIViewAnimationOptionOverrideInheritedDuration = 1 <<  5, // ignore nested duration
     UIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6, // ignore nested curve
     UIViewAnimationOptionAllowAnimatedContent      = 1 <<  7, // animate contents (applies to transitions only)
     UIViewAnimationOptionShowHideTransitionViews   = 1 <<  8, // flip to/from hidden state instead of adding/removing
     UIViewAnimationOptionOverrideInheritedOptions  = 1 <<  9, // do not inherit any options or animation type
     
     UIViewAnimationOptionCurveEaseInOut            = 0 << 16, // default
     UIViewAnimationOptionCurveEaseIn               = 1 << 16,
     UIViewAnimationOptionCurveEaseOut              = 2 << 16,
     UIViewAnimationOptionCurveLinear               = 3 << 16,
     
     UIViewAnimationOptionTransitionNone            = 0 << 20, // default
     UIViewAnimationOptionTransitionFlipFromLeft    = 1 << 20,
     UIViewAnimationOptionTransitionFlipFromRight   = 2 << 20,
     UIViewAnimationOptionTransitionCurlUp          = 3 << 20,
     UIViewAnimationOptionTransitionCurlDown        = 4 << 20,
     UIViewAnimationOptionTransitionCrossDissolve   = 5 << 20,
     UIViewAnimationOptionTransitionFlipFromTop     = 6 << 20,
     UIViewAnimationOptionTransitionFlipFromBottom
     */
    
    
    //[self.navigationController pushViewController:bv animated:YES];
#if 1
    [UIView transitionFromView:self.view
                        toView:bv.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished)
    {
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:bv];
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        window.rootViewController = nav;
        
    }];
#endif
    
 
    NSLog(@"%@",self.cview.commentString);
    NSLog(@"%lu",(unsigned long)self.cview.selectImages.count);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(getmsg:) name:cqSelectFillNotification object:nil];
}

-(void)getmsg:(NSNotification *)not{
    NSLog(@"图片选择满了");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:cqSelectFillNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
