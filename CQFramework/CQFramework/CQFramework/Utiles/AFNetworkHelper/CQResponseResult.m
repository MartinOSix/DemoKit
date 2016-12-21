//
//  CQResponseResult.m
//  CQFramework
//
//  Created by runo on 16/11/29.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "CQResponseResult.h"

@implementation CQResponseResult

-(instancetype )initWithResultData:(id)resultData Success:(BOOL)success Error:(NSError *)error{
    self = [super init];
    if (self) {
        self.resultData = resultData;
        self.isSuccess = success;
        self.errorEntity = error;
    }
    return self;
}

-(NSString *)errorInfo{
    
    if (self.errorEntity == nil) {
        return nil;
    }
    NSString *errorMessageForShow = nil;

    switch (self.errorEntity.code) {
        case -1001:
            errorMessageForShow = @"请求超时";
            break;
        case -1009:
            errorMessageForShow = @"无法连接服务器";
            break;
        case -1004:
            errorMessageForShow = @"未能连接到服务器";
            break;
        case -1011:
            errorMessageForShow = @"服务器不可用";
            break;
        case -999:
            errorMessageForShow = @"请求取消";//用户取消
            break;
        default:
            errorMessageForShow = self.errorEntity.localizedDescription;
            break;
    }
     
    return errorMessageForShow;
    
}

@end
