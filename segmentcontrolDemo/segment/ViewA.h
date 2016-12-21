//
//  ViewA.h
//  segment
//
//  Created by runo on 16/12/12.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ViewADelegate <NSObject>
/**type 自己定义   比如type==1  buttona 点击  type =2 其他什么的，ViewB和ViewC写法跟着一样，自己根据实际情况改*/

-(void)viewAClickType:(NSInteger)type UserInfo:(NSDictionary *)userinfo;

@end

@interface ViewA : UIView

@property(nonatomic,weak) id<ViewADelegate> delegate;

@end
