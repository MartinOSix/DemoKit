//
//  CommentView.h
//  CommentViewDemo
//
//  Created by runo on 16/10/27.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentView;
@protocol CommentViewDelegate <NSObject>
/**当选择图片的时候该控件会自动调整frame，添加代理用来在使用的该控件的View中调整该控件下方其他View的位置*/
-(void)commentViewAutoAdjustFrame:(CommentView *)commentView;

@end

@interface CommentView : UIView

@property(nonatomic,weak) id<CommentViewDelegate> delegate;
@property(nonatomic,readonly,strong) NSString *commentString;//!<输入的文本
@property(nonatomic,readonly,strong) NSMutableArray *selectImages;//!<输入的图片

+(UIViewController *)cqGetController:(UIView *)view;

@end
