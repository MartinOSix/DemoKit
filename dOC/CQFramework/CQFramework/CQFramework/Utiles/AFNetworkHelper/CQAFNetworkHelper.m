//
//  CQAFNetworkHelper.m
//  CQFramework
//
//  Created by runo on 16/11/29.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "CQAFNetworkHelper.h"
#import "CQConstantDefine.h"
#import "CQAFHttpSessionManagerConfigurator.h"
#import "CQResponseResult.h"
#import "AFNetworking.h"

#define ktAFHelperLog 1

@interface CQAFNetworkHelper ()

@end

@implementation CQAFNetworkHelper


+(instancetype)shareInstance{
    static CQAFNetworkHelper *helper = nil;
    kDISPATCH_ONCE_BLOCK(^{
        helper = [[CQAFNetworkHelper alloc]init];
    });
    return helper;
}

-(NSURLSessionDataTask *)cqPostParameter:(NSDictionary *)parameter URL:(NSString *)url CompleteBlock:(void(^)(CQResponseResult *result))resultBlock{

    //如果没有配置manager则用默认的manager
    AFHTTPSessionManager *manager = [CQAFHttpSessionManagerConfigurator cqNormalManager];
    NSString *defalutURL = @"https://www.baidu.com";//默认的URL
    if (url != nil) {
        defalutURL = url;
    }
    self.resultBlock = resultBlock;
    kDebugLog(ktAFHelperLog, @"%@ %@",defalutURL,parameter);
    ///WEAKSELF;//有种滥用weakself的感觉，不确定
    NSURLSessionDataTask *task = [manager POST:defalutURL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        kDebugLog(ktAFHelperLog, @"url %@\n success\n %@",defalutURL,[[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding] substringToIndex:10]);
        //数据回调
        CQResponseResult *result = [[CQResponseResult alloc]initWithResultData:responseObject Success:YES Error:nil];
        //block回调
        if (self.resultBlock) {
            self.resultBlock(result);
        }
        //代理回调
        if ([self.delegate respondsToSelector:@selector(cqGetPostResult:)]) {
            [self.delegate cqGetPostResult:result];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        kDebugLog(ktAFHelperLog, @"url  %@ failure\n ",url);
        //数据回调
        CQResponseResult *result = [[CQResponseResult alloc]initWithResultData:nil Success:NO Error:error];
        //block回调
        if (self.resultBlock) {
            self.resultBlock(result);
        }
        //代理回调
        if ([self.delegate respondsToSelector:@selector(cqGetPostResult:)]) {
            [self.delegate cqGetPostResult:result];
        }
    }];
    
    return task;
}

-(NSURLSessionDataTask *)cqPostParameter:(NSDictionary *)parameter CompleteBlock:(void(^)(CQResponseResult *result))resultBlock{
    
    //如果没有配置manager则用默认的manager
    if (self.manager == nil) {
        self.manager = [CQAFHttpSessionManagerConfigurator cqNormalManager];
    }
    self.resultBlock = resultBlock;
    NSString *defalutURL = @"https://www.baidu.com";//默认的URL
    if (self.postURL != nil) {
        defalutURL = self.postURL;
    }
    
    kDebugLog(ktAFHelperLog, @"%@ %@",defalutURL,parameter);
    ///WEAKSELF;//有种滥用weakself的感觉，不确定
    NSURLSessionDataTask *task = [self.manager POST:defalutURL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        kDebugLog(ktAFHelperLog, @"url %@\n success\n %@",defalutURL,[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        //数据回调
        CQResponseResult *result = [[CQResponseResult alloc]initWithResultData:responseObject Success:YES Error:nil];
        //block回调
        if (self.resultBlock) {
            self.resultBlock(result);
        }
        //代理回调
        if ([self.delegate respondsToSelector:@selector(cqGetPostResult:)]) {
            [self.delegate cqGetPostResult:result];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        kDebugLog(ktAFHelperLog, @"failure\n %@",error);
        //数据回调
        CQResponseResult *result = [[CQResponseResult alloc]initWithResultData:nil Success:NO Error:error];
        //block回调
        if (self.resultBlock) {
            self.resultBlock(result);
        }
        //代理回调
        if ([self.delegate respondsToSelector:@selector(cqGetPostResult:)]) {
            [self.delegate cqGetPostResult:result];
        }
    }];
    
    //保存请求任务
    self.currentTask = task;
    [[[self class]cqGetAllTaskArray] addObject:task];
    
    return task;
}

/**取消当前请求任务*/
-(void)cqCloseTask{
    
    [self.currentTask cancel];
    if ([[[self class] cqGetAllTaskArray] containsObject:self.currentTask]) {
        [[[self class]cqGetAllTaskArray] removeObject:self.currentTask];
    }
}

/**取消所有请求任务*/
+(void)cqCloseAllTask{
    for (NSURLSessionDataTask *task in [self cqGetAllTaskArray]) {
        [task cancel];
    }
    [[self cqGetAllTaskArray] removeAllObjects];
}

/**类变量存储所有的请求*/
+(NSMutableArray *)cqGetAllTaskArray{
    
    static NSMutableArray *allArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allArray = [NSMutableArray array];
    });
    return allArray;
}

@end
