//
//  ResponseResult.h
//  CQFramework
//
//  Created by runo on 16/11/29.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    /**服务器bug*/
    FLAG_ServiceError,
    /**事务逻辑错误*/
    FLAG_TransactionFail,
    /**请求成功*/
    FLAG_OK,
    /**网络连接错误*/
    FLAG_NetworkError,
} Flag;

@interface ResponseResult : NSObject

@property(nonatomic,copy)NSString *errorMessageForShow;//!<要显示的信息
@property(nonatomic,copy)NSString *errorMessageOrigin;//!<原始错误信息
@property(nonatomic,strong)id originData;//!<其他信息
@property(nonatomic,strong)id DataResult;//!<返回的信息
@property(nonatomic,assign)Flag flag;//!<请求标志

-(instancetype)initWithResult:(NSDictionary *)dic NetworkIsCorrect:(BOOL)isCorrect;

@end
