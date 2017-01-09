//
//  CQAFNetworkHelper.h
//  CQFramework
//
//  Created by runo on 16/11/29.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CQResponseResult,CQAFNetworkHelper,AFHTTPSessionManager;

@protocol CQAFNetworkHelperDelegate <NSObject>

-(void)cqGetPostResult:(CQResponseResult *)result;

@end

@interface CQAFNetworkHelper : NSObject

@property(nonatomic,strong)NSString *postURL;//!<请求地址
@property(nonatomic,strong)AFHTTPSessionManager *manager;//!<AF请求引擎
@property(nonatomic,strong)NSURLSessionDataTask *currentTask;//!<当前任务
@property(nonatomic,copy) void(^resultBlock)(CQResponseResult *result);//!<回调block
@property(nonatomic,weak) id <CQAFNetworkHelperDelegate> delegate;//!<回调代理

-(NSURLSessionDataTask *)cqPostParameter:(NSDictionary *)parameter CompleteBlock:(void(^)(CQResponseResult *result))resultBlock;

-(void)cqCloseTask;
+(void)cqCloseAllTask;

@end
