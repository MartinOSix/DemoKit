//
//  ViewA.m
//  segment
//
//  Created by runo on 16/12/12.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewA.h"

@interface ViewA ()

@property(nonatomic,strong)UIButton *btn;

@end

@implementation ViewA

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.btn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 100, 30);
            btn.backgroundColor = [UIColor orangeColor];
            [btn setTitle:@"btna" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            btn;
        });
        
    }
    return self;
}

-(void)btnclick{
    
    NSLog(@"btn 在viewA中被点击");
    if ([self.delegate respondsToSelector:@selector(viewAClickType:UserInfo:)]) {
        //userinfo 自己看情况，有需要传回去的数据就传,反正是字典
        [self.delegate viewAClickType:1 UserInfo:nil];
    }
    
}

@end
