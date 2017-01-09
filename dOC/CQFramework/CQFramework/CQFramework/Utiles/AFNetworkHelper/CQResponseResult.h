//
//  CQResponseResult.h
//  CQFramework
//
//  Created by runo on 16/11/29.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQResponseResult : NSObject

@property(nonatomic,strong) id resultData;//!<返回值
@property(nonatomic,assign)BOOL isSuccess;//!<是否请求成功
@property(nonatomic,strong)NSError *errorEntity;
@property(nonatomic,readonly) NSString *errorInfo;//!<错误信息

-(instancetype )initWithResultData:(id)resultData Success:(BOOL)success Error:(NSError *)error;

@end
