//
//  ViewController_ScrollView.m
//  MasonryTest
//
//  Created by runo on 16/11/18.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController_ScrollView.h"
#import "Masonry.h"

/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

@interface ViewController_ScrollView ()

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *contentViews;

@end

@implementation ViewController_ScrollView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
    self.navigationController.navigationBar.translucent = NO;//透明度
    
    self.scrollView = ({
        UIScrollView *scv = [[UIScrollView alloc]init];
        scv.backgroundColor = [UIColor orangeColor];
        scv.pagingEnabled = YES;
        [self.view addSubview:scv];

        scv;
    });

    self.contentViews = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor redColor];
        [self.scrollView addSubview:view];
        view;
    });
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_offset(0);
    }];
    
    [self.contentViews mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.scrollView);
    }];
    //[self setConstraint];//纵向
    //[self setConstraint2];//横向
    //[self setConstraint3];// 3 x 3
    [self setConstraint4];//单列测试

}

-(void)setConstraint{
    
    
    [self.contentViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.scrollView.mas_width);
    }];
    
    UIView *previes = nil;
    for (int i = 0; i < 10; i ++) {
        
        UILabel *label = [[UILabel alloc]init];
        [self.contentViews addSubview:label];
        label.text = [NSString stringWithFormat:@"第%d个",i];
        label.backgroundColor = [UIColor whiteColor];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
           
            if (previes) {
                make.top.equalTo(previes.mas_bottom).mas_offset(10);
            }else{
                make.top.mas_offset(10);
            }
            make.left.mas_offset(10);
            make.right.mas_offset(-10);
            make.height.mas_offset(80);
            
        }];
        previes = label;
    }
    
    [self.contentViews mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(previes.mas_bottom).offset(10);
    }];
    
}

-(void)setConstraint2{
    
    [self.contentViews mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.height.equalTo(self.scrollView.mas_height);

    }];
    
    UIView *previes = nil;
    for (int i = 0; i < 10; i ++) {
        
        UILabel *label = [[UILabel alloc]init];
        [self.contentViews addSubview:label];
        label.text = [NSString stringWithFormat:@"第%d个",i];
        label.backgroundColor = [UIColor whiteColor];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (previes) {
                make.left.equalTo(previes.mas_right).mas_offset(10);
            }else{
                make.left.mas_offset(10);
            }
            make.top.mas_offset(10);
            make.bottom.mas_offset(-10);
            make.width.mas_offset(80);
            
        }];
        previes = label;
    }

    [self.contentViews mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(previes.mas_right).offset(10);
    }];
}

-(void)setConstraint3{
    
    [self.contentViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(0);
    }];
    
    NSMutableArray *marr = [NSMutableArray array];
    NSInteger size = 15;
    for (int i = 0 ; i < size; i++) {
        
        UILabel *label = [[UILabel alloc]init];
        [self.contentViews addSubview:label];
        label.text = [NSString stringWithFormat:@"第%d个",i];
        label.backgroundColor = [UIColor whiteColor];
        [marr addObject:label];
        if(arc4random()%2){
            label.text = @"拉萨积分地区为减肥前；了看见父亲为了；客服就去玩了快放假前为了看风景";
        }
        label.numberOfLines = 0;
        
    }
    
    for (int i = 0; i < size; i++) {
        
        UILabel *label = marr[i];
        [label setContentHuggingPriority:marr.count-i forAxis:UILayoutConstraintAxisVertical];
        //第一个
        if (i%3 == 0) {
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i>2) {
                    UILabel *upLabel = marr[i-3];
                    make.top.equalTo(upLabel.mas_bottom).offset(10);
                }else{
                    make.top.mas_offset(10);
                }
                make.left.mas_offset(10);
                make.width.mas_offset((kScreenWidth-40)/3);
                
                if (marr.count-1 >= i+3) {
                    UILabel *bottomLabel = marr[i+3];
                    make.bottom.equalTo(bottomLabel.mas_top).mas_offset(-10);
                }else{
                    make.bottom.lessThanOrEqualTo(@(-10));
                }
            }];
        }
        
        //第二个
        if(i%3 == 1){
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                //上
                if (i>2) {
                    UILabel *upLabel = marr[i-3];
                    make.top.equalTo(upLabel.mas_bottom).offset(10);
                }else{
                    make.top.mas_offset(10);
                }
                //左
                UILabel *leftLabel = marr[i-1];
                make.left.equalTo(leftLabel.mas_right).mas_offset(10);
                //宽
                make.width.mas_offset((kScreenWidth-40)/3);
                //下
                if (marr.count-1 >= i+3) {
                    UILabel *bottomLabel = marr[i+3];
                    make.bottom.equalTo(bottomLabel.mas_top).mas_offset(-10);
                }else{
                    make.bottom.lessThanOrEqualTo(@(-10));
                }
            }];
        }
        
        //第三个
        if (i%3==2) {
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                //上
                if (i>2) {
                    UILabel *upLabel = marr[i-3];
                    make.top.equalTo(upLabel.mas_bottom).offset(10);
                }else{
                    make.top.mas_offset(10);
                }
                //左
                UILabel *leftLabel = marr[i-1];
                make.left.equalTo(leftLabel.mas_right).mas_offset(10);
                //宽
                make.width.mas_offset((kScreenWidth-40)/3);
                //下
                if (marr.count-1 >= i+3) {
                    UILabel *bottomLabel = marr[i+3];
                    make.bottom.equalTo(bottomLabel.mas_top).mas_offset(-10);
                }else{
                    make.bottom.lessThanOrEqualTo(@-10);
                }
            }];
        }
    }
    
    [self.contentViews layoutIfNeeded];
    
//    
//    [self.contentViews mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        UILabel *label = [marr lastObject];
//        UILabel *label2 = marr[marr.count-2];
//        UILabel *label3 = marr[marr.count-3];
//        NSLog(@"\n%@ \n%@  \n%@",NSStringFromCGRect(label.frame),NSStringFromCGRect(label2.frame),NSStringFromCGRect(label3.frame));
//        
//        CGFloat label_H = label.frame.origin.y+label.frame.size.height;
//        CGFloat Label2_H = label2.frame.origin.y+label2.frame.size.height;
//        CGFloat Label3_H = label3.frame.origin.y+label3.frame.size.height;
//        
//        UILabel *labelF = (label_H>=Label2_H && label_H>=Label3_H)?label:Label2_H>=Label3_H?label2:label3;
//        
//        
//        make.bottom.equalTo(labelF.mas_bottom).offset(10);
//        /*
//        if (label != labelF) {
//          make.bottom.greaterThanOrEqualTo(label).offset(10).priority(1);
//        }
//        if (label2 != labelF) {
//          make.bottom.greaterThanOrEqualTo(label2).offset(10).priority(1);
//        }
//        if (label3 != labelF) {
//          make.bottom.greaterThanOrEqualTo(label3).offset(10).priority(1);
//        }
//        
//        */
//        /*
//        make.bottom.greaterThanOrEqualTo(label).offset(10).priority(10);
//        make.bottom.greaterThanOrEqualTo(label2).offset(10).priority(10);
//        make.bottom.greaterThanOrEqualTo(label3).offset(10).priority(10);
//        */
//        make.width.equalTo(self.scrollView.mas_width);
//    }];
//
    [self.contentViews layoutIfNeeded];
    
    UILabel *label = [marr lastObject];
    UILabel *label2 = marr[marr.count-2];
    UILabel *label3 = marr[marr.count-3];
    NSLog(@"\n%@ \n%@  \n%@",NSStringFromCGRect(label.frame),NSStringFromCGRect(label2.frame),NSStringFromCGRect(label3.frame));
}

//看一列的拉伸
-(void)setConstraint4{
    [self.contentViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.scrollView.mas_width);
    }];
    
    NSMutableArray *marr = [NSMutableArray array];
    NSInteger size = 15;
    for (int i = 0 ; i < size; i++) {
        
        UILabel *label = [[UILabel alloc]init];
        [self.contentViews addSubview:label];
        label.text = [NSString stringWithFormat:@"第%d个",i];
        label.backgroundColor = [UIColor whiteColor];
        [marr addObject:label];
        if(arc4random()%2){
            label.text = @"拉萨积分地区为减肥前；了看见父亲为了；客服就去玩了快放假前为了看风景";
        }
        label.numberOfLines = 0;
    }
    
    for (int i = 0; i < marr.count; i++) {
        
        UILabel *label = [marr objectAtIndex:i];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.right.mas_offset(-10);
            if (i > 0) {
                UILabel *uplabel = marr[i-1];
                make.top.equalTo(uplabel.mas_bottom).mas_offset(10);
            }else{
                make.top.mas_offset(10);
            }
            
            if(i < marr.count-1){
                UILabel *bottomLabel = marr[i+1];
                make.bottom.lessThanOrEqualTo(bottomLabel.mas_top).offset(-10);
            }else{
                make.bottom.lessThanOrEqualTo(@(-10));
            }
        }];
    }
//    [self.contentViews mas_makeConstraints:^(MASConstraintMaker *make) {
//        UILabel *label = [marr lastObject];
//        make.bottom.equalTo(label.mas_bottom).offset(10);
//    }];
}

@end
