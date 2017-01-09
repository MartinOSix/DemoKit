//
//  ViewController_A.m
//  segment
//
//  Created by runo on 16/12/14.
//  Copyright © 2016年 com.runo. All rights reserved.
//

//多个子视图切换
#import "ViewController_A.h"
#import "SubViewController.h"

/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

@interface ViewController_A ()

@end

@implementation ViewController_A{
    UIView *_contentView;
    UISegmentedControl *_segment;
    SubViewController *_subA;
    SubViewController *_subB;
    SubViewController *_subC;
    NSArray *_subvcs;
    CATransition *animation;
    NSInteger _currentIndex;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _segment = ({
        UISegmentedControl *segm = [[UISegmentedControl alloc]initWithItems:@[@"标题一",@"标题二",@"标题三"]];
        [self.view addSubview:segm];
        segm.frame = CGRectMake(0, 100, kScreenWidth, 30);
        [segm addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
        segm;
    });
    
    _contentView = ({
        UIView *scv = [[UIView alloc]initWithFrame:CGRectMake(0, 130, kScreenWidth, 200)];
        scv.backgroundColor = [UIColor blackColor];
        [self.view addSubview:scv];
        scv;
    });
    
    _subA = ({
        SubViewController *sub = [[SubViewController alloc]init];
        sub.view.backgroundColor = [UIColor redColor];
        sub.vcName = @"1";
        sub;
    });
    _subB = ({
        SubViewController *sub = [[SubViewController alloc]init];
        sub.view.backgroundColor = [UIColor orangeColor];
        sub.vcName = @"2";
        sub;
    });
    _subC = ({
        SubViewController *sub = [[SubViewController alloc]init];
        sub.view.backgroundColor = [UIColor yellowColor];
        sub.vcName = @"3";
        sub;
    });
    
    [_contentView addSubview:_subA.view];
    _subvcs = @[_subA,_subB,_subC];
    //[self addChildViewController:_subA];
    //[self addChildViewController:_subB];
    //[self addChildViewController:_subC];
    _currentIndex = 0;
    
    animation = [CATransition animation];
    [animation setDuration:1];
    [animation setType: kCATransitionPush];
    [animation setSubtype: kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [_contentView.layer addAnimation:animation forKey:nil];
    
}


-(void)segmentClick:(UISegmentedControl *)semg{
    
    NSInteger index = semg.selectedSegmentIndex;
    if (index != _currentIndex) {
        /*
        [self transitionFromViewController:_subvcs[_currentIndex] toViewController:_subvcs[index] duration:0.3 options:UIViewAnimationOptionCurveLinear animations:nil completion:^(BOOL finished) {
            
            _currentIndex = index;
            
        }];
        */
        
        animation = [CATransition animation];
        [animation setDuration:1];
        [animation setType: kCATransitionPush];
        [animation setSubtype: kCATransitionFromRight];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [_contentView.layer addAnimation:animation forKey:nil];
        
        [_contentView addSubview:((SubViewController *)_subvcs[index]).view];
        [((SubViewController *)_subvcs[_currentIndex]).view removeFromSuperview];
        _currentIndex = index;
        
    }
    
}

@end
