//
//  ViewController_Center.m
//  MasonryTest
//
//  Created by runo on 16/12/5.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController_Center.h"
#import "Masonry.h"
@interface ViewController_Center ()

@end

@implementation ViewController_Center{
    UIView *_redView;
    UIView *_greenView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _redView = [[UIView alloc]init];
    _redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_redView];
    [_redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.width.mas_offset(100);
        make.height.mas_offset(100);
    }];
    
    _greenView = [[UIView alloc]init];
    _greenView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_greenView];
    [_greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_redView.mas_right);
        make.bottom.equalTo(_redView.mas_top).offset(-10);
        make.width.mas_offset(100);
        make.height.mas_offset(100);
    }];
    
}


@end
