//
//  RunoAFHelper.m
//  CQFramework
//
//  Created by runo on 16/11/29.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "RunoAFHelper.h"
#import "CQAFNetworkHelper.h"
#import "AFHTTPSessionManager.h"
#import "CQAFHttpSessionManagerConfigurator.h"
#import "CQResponseResult.h"
#import "ResponseResult.h"

#import "NSDate+CQExtention.h"
#import "NSString+CQExtension.h"

#import "CQJSONParser.h"
#import "CQConstantDefine.h"


#define kkey @"%$#@^!*&"  //加密秘钥
#define ktRunoAFLog 1

@implementation RunoAFHelper

+(CQAFNetworkHelper *)rnPostParameter:(NSDictionary *)dic Result:(void(^)(ResponseResult *rnResult))resultBlock{
    
    CQAFNetworkHelper *cqaf = [[CQAFNetworkHelper alloc]init];
    cqaf.postURL = @"http://27.221.58.35:8000//WebAPI/Ajax/phoneAPI.ashx";//请求的URL
    cqaf.manager = [CQAFHttpSessionManagerConfigurator cqNormalManager];
    
    NSMutableDictionary *parmeterDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [parmeterDic setObject:[CQJSONParser objToJsonString:@"ios"] forKey:@"osType"];
    
    kDebugLog(ktRunoAFLog, @"%@",parmeterDic);
    BOOL isSecret = YES;
    if (isSecret) {
        
        for (NSString *key in parmeterDic.allKeys) {
            [parmeterDic setObject:[NSString cqEncodeDESWithString:parmeterDic[key] Key:kkey] forKey:key];
        }
        NSString *token = [self getToken];
        //额外的请求头
        [cqaf.manager.requestSerializer setValue:[NSString cqEncodeDESWithString:token Key:kkey] forHTTPHeaderField:@"token"];//加密
        [cqaf.manager.requestSerializer setValue:[self getTimeStampWithToken:token] forHTTPHeaderField:@"timestamp"];//不加密
    }
    
    
    
    [cqaf cqPostParameter:parmeterDic CompleteBlock:^(CQResponseResult *cqresult) {
       
        //请求成功
        if (cqresult.isSuccess) {
            NSDictionary * dics=[NSJSONSerialization JSONObjectWithData:cqresult.resultData options:NSJSONReadingMutableContainers error:nil];
            kDebugLog(ktRunoAFLog, @"%@",dics);
            ResponseResult * result=[[ResponseResult alloc] initWithResult:dics NetworkIsCorrect:YES];
            if (resultBlock) {
                resultBlock(result);
            }
        
        }else{
        //请求失败
            ResponseResult * result=[[ResponseResult alloc] initWithResult:nil NetworkIsCorrect:NO];
            NSError *error = cqresult.errorEntity;
            switch (error.code) {
                case -1001:
                    result.errorMessageForShow = @"请求超时";
                    break;
                case -1009:
                    result.errorMessageForShow = @"无法连接服务器";
                    break;
                case -1004:
                    result.errorMessageForShow = @"未能连接到服务器";
                    break;
                case -1011:
                    result.errorMessageForShow = @"服务器不可用";
                    break;
                default:
                    result.errorMessageForShow = @"网络异常,请稍后再试!";
                    break;
            }
            kDebugLog(ktRunoAFLog, @"%@",result);
            if (resultBlock) {
                resultBlock(result);
            }
            
        }
        
    }];
    
    return cqaf;
    
}

+(NSString *)getToken{
    
    NSString *resultStr = [NSDate cqNowCSTDateToStringWithType:CQDateFromatType2];
    return resultStr;
}

+(NSString *)getTimeStampWithToken:(NSString *)str{
    
    NSString *resultStr = [NSDate cqNowCSTDateToStringWithType:CQDateFromatType2];
    if (str.length > 14) {
        resultStr = [str substringToIndex:15];
    }
    return resultStr;
}

@end
