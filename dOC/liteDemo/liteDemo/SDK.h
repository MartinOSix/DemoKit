//
//  SDK.h
//  liteDemo
//
//  Created by runo on 16/12/8.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

/**单例的方式进行线程同步*/
@interface SDK : NSObject

@property(nonatomic,copy) void(^result)(NSString *result);
+(instancetype)sharInstance;

-(void)MethodA;
-(void)MethodB;

@end
