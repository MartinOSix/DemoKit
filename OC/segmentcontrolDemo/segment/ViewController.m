//
//  ViewController.m
//  segment
//
//  Created by runo on 16/12/12.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "ViewA.h"
#import "ViewB.h"
#import "ViewC.h"
#import "ViewController_A.h"

/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

@interface ViewController ()<UIScrollViewDelegate,ViewADelegate,ViewBDelegate>


@property(nonatomic,strong)UISegmentedControl *segment;
@property(nonatomic,strong)UIScrollView *scrollview;
@property(nonatomic,strong)ViewA *viewa;
@property(nonatomic,strong)ViewB *viewb;
@property(nonatomic,strong)ViewC *viewc;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segment = ({
        UISegmentedControl *segm = [[UISegmentedControl alloc]initWithItems:@[@"标题一",@"标题二",@"标题三"]];
        [self.view addSubview:segm];
        segm.frame = CGRectMake(0, 100, kScreenWidth, 30);
        [segm addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
        segm;
    });
    
    self.scrollview = ({
        UIScrollView *scv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 130, kScreenWidth, 200)];
        scv.delegate = self;
        [self.view addSubview:scv];
        scv;
    });
    
    ViewController_A *vca = [[ViewController_A alloc]init];
    vca.view.backgroundColor = [UIColor redColor];
    [self.scrollview addSubview:vca.view];
    
    
    /*
    self.viewa = ({
        ViewA  *viewa = [[ViewA alloc]init];
        viewa.frame = CGRectMake(0, 0, kScreenWidth, 200);
        viewa.backgroundColor = [UIColor redColor];
        viewa.delegate = self;
        [self.scrollview addSubview:viewa];
        viewa;
    });
    
    self.viewb = ({
        ViewB *view = [[ViewB alloc]init];
        view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, 200);
        view.backgroundColor = [UIColor greenColor];
        view.delegate = self;
        [self.scrollview addSubview:view];
        view;
    });
    
    self.viewc = ({
        ViewC *view = [[ViewC alloc]init];
        view.frame = CGRectMake(kScreenWidth * 2, 0, kScreenWidth, 200);
        view.backgroundColor = [UIColor blueColor];
        [self.scrollview addSubview:view];
        view;
    });
    */
    self.scrollview.contentSize = CGSizeMake(kScreenWidth*3, 200);
    self.scrollview.pagingEnabled = YES;
    self.segment.selectedSegmentIndex = 0;
}

-(void)addChildViewController:(UIViewController *)childController{
    
}

-(void)viewAClickType:(NSInteger)type UserInfo:(NSDictionary *)userinfo{
    
    switch (type) {
        case 1:
            NSLog(@"viewa中button点击事件在 Viewcontrol中执行");
            break;
        default:
            NSLog(@"其他事件");
            break;
    }
    
}

-(void)viewBClickType:(NSInteger)type UserInfo:(NSDictionary *)userinfo{
    switch (type) {
        case 1:
        {
            NSLog(@"viewB中button点击事件在 Viewcontrol中执行");
            NSLog(@"传回的数据  %@",userinfo[@"text"]);
        }
            break;
            
        default:
            break;
    }
}


-(void)segmentClick:(UISegmentedControl *)semg{
    
    NSInteger index = semg.selectedSegmentIndex;
    
    [self.scrollview setContentOffset:CGPointMake(kScreenWidth*index,0) animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x/kScreenWidth;
    self.segment.selectedSegmentIndex = index;
    
}

@end
