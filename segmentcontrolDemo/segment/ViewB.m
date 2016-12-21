//
//  ViewB.m
//  segment
//
//  Created by runo on 16/12/12.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewB.h"



@implementation ViewB{
    UIButton *_btn;
    UITextField *_textF;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        
        _btn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 100, 30);
            btn.backgroundColor = [UIColor orangeColor];
            [btn setTitle:@"btna" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            btn;
        });
        
        _textF = ({
            UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(0, 30, 100, 30)];
            text.backgroundColor = [UIColor whiteColor];
            [self addSubview:text];
            text;
        });
        
    }
    return self;
}

-(void)btnclick{
    
    NSLog(@"btn 在viewB中被点击");
    if ([self.delegate respondsToSelector:@selector(viewBClickType:UserInfo:)]) {
        //userinfo 自己看情况，有需要传回去的数据就传,反正是字典
        [self.delegate viewBClickType:1 UserInfo:@{@"text":_textF.text}];
    }
    
}


@end
