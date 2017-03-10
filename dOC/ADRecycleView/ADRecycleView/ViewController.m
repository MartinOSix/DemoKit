//
//  ViewController.m
//  ADRecycleView
//
//  Created by runo on 17/3/10.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "ADRecycleView.h"

/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

@interface ViewController ()<ADRecycleViewDelegate>



@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    static ADRecycleView *adView = nil;
    adView = [[ADRecycleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    
    [self.view addSubview:adView.collectionView];
    adView.dataDelegate = self;
    [adView.collectionView reloadData];
    adView.animate = YES;
}

-(NSInteger)adRecycleViewADTotalCount{
    return 4;
}

-(void)adRecycleViewLoadDataWithImageView:(UIImageView *)adView WithIndex:(NSInteger)index{
    switch (index) {
        case 0:
            adView.backgroundColor = [UIColor yellowColor];
            break;
        case 1:
            adView.backgroundColor = [UIColor blueColor];
            break;
        case 2:
            adView.backgroundColor = [UIColor redColor];
            break;
        case 3:
            adView.backgroundColor = [UIColor purpleColor];
            break;
        default:
            break;
    }
}

-(void)adRecycleViewDidSelectViewAtIndex:(NSInteger)index{
    NSLog(@"--index-%zd-",index);
}


@end






