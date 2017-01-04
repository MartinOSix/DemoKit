//
//  ViewController_hover.m
//  MasonryTest
//
//  Created by runo on 17/1/3.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController_hover.h"
#import "Masonry.h"

/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

@interface ViewController_hover ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *containerSCV;
@property(nonatomic,strong) UIView *container;
@property(nonatomic,strong) UIView *hoverView;
@property(nonatomic,strong) UIImageView *titleImage;
@property(nonatomic,strong) UIImageView *downImage;

@end

@implementation ViewController_hover

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.containerSCV = ({
        UIScrollView *scv = [[UIScrollView alloc]init];
        [self.view addSubview:scv];
        scv.delegate = self;
        scv;
    });
    [self.containerSCV mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.left.right.bottom.mas_offset(0);
    }];
    
    self.container = ({
        UIView *view = [[UIView alloc]init];
        [self.containerSCV addSubview:view];
        view.backgroundColor = [UIColor orangeColor];
        view;
    });
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerSCV);
        make.width.equalTo(self.containerSCV.mas_width);
        make.height.equalTo(@(kScreenHeight * 2));
    }];
    
    self.titleImage = ({
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.image = [UIImage imageNamed:@"test"];
        [self.container addSubview:imageV];
        imageV;
    });
    [self.titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(200);
    }];
    
    self.hoverView = ({
        UIView *view = [[UIView alloc]init];
        
        view.backgroundColor = [UIColor greenColor];
        [self.container addSubview:view];
        view;
    });
    
    [self.hoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.height.mas_offset(60);
    }];
    
    self.downImage = ({
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.image = [UIImage imageNamed:@"downImag"];
        [self.container addSubview:imageV];
        imageV;
    });
    [self.downImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.mas_offset(0);
        make.height.mas_offset(2*kScreenHeight-200-60);
    }];
    
    [self.hoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleImage.mas_bottom).offset(0);
        make.bottom.equalTo(self.downImage.mas_top).offset(0);
    }];
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat imageH = self.titleImage.frame.size.height;
    CGFloat offsetY = scrollView.contentOffset.y;
    CGRect centeFrame = self.hoverView.frame;
    if (offsetY >= imageH) {
        [self.view addSubview:self.hoverView];
        [self.hoverView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.height.mas_offset(60);
        }];
        
        [self.titleImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.downImage.mas_top).mas_offset(-60);
        }];
        centeFrame.origin.y=0;
        self.hoverView.frame = centeFrame;
        
        [self.view setNeedsDisplay];
        [self.hoverView setNeedsDisplay];

    }else{
        [self.container addSubview:self.hoverView];
        [self.hoverView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.height.mas_offset(60);
            make.top.equalTo(self.titleImage.mas_bottom).offset(0);
            make.bottom.equalTo(self.downImage.mas_top).offset(0);
        }];
    }
    
    
}


@end
