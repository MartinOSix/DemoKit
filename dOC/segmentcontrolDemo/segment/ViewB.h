//
//  ViewB.h
//  segment
//
//  Created by runo on 16/12/12.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewBDelegate <NSObject>

-(void)viewBClickType:(NSInteger)type UserInfo:(NSDictionary *)userinfo;

@end

@interface ViewB : UIView

@property(nonatomic,weak) id<ViewBDelegate> delegate;

@end
