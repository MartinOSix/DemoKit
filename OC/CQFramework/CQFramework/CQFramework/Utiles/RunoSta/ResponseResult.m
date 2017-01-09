//
//  ResponseResult.m
//  CQFramework
//
//  Created by runo on 16/11/29.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ResponseResult.h"
#import "CQConstantDefine.h"

@implementation ResponseResult

-(instancetype)initWithResult:(NSDictionary *)dic NetworkIsCorrect:(BOOL)isCorrect{
    self = [super init];
    if (self) {
        
        if (isCorrect) {
            
            NSString *status = dic[@"Status"];
            
            //业务逻辑错误
            if ([status isEqualToString:@"Fail"]) {
                self.errorMessageForShow = dic[@"Message"];
                self.errorMessageOrigin = dic[@"Message"];
                self.flag = FLAG_TransactionFail;
                
            //服务器bug
            }else if ([status isEqualToString:@"Error"]){
                self.errorMessageOrigin = dic[@"Message"];
                self.errorMessageForShow = @"服务器异常";
                self.flag = FLAG_ServiceError;
                
            //请求成功
            }else if([status isEqualToString:@"Success"]){
                
                if (dic[@"Result"] == nil) {
                    self.errorMessageForShow = @"暂无数据";
                    self.errorMessageOrigin = @"服务器状态成功，但无返回数据";
                    self.flag = FLAG_TransactionFail;
                
                }else{
                    self.DataResult = dic[@"Result"];
                    self.flag = FLAG_OK;
                }
            //本地解析Bug
            }else{
                self.errorMessageForShow = @"无法识别服务器返回数据";
                self.errorMessageOrigin = kJointString(@"服务器状态码解析错误  %@",status);
                self.flag = FLAG_ServiceError;
            }
            
            
        }else{
            //网络错误，由外部判断自行赋值
            self.flag = FLAG_NetworkError;
            self.errorMessageOrigin = @"networkerror";
            self.errorMessageForShow = @"networkerror";
        }
        
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"flag %d\n showMsg %@\n originMsg %@\n  result  %@", self.flag,self.errorMessageForShow,self.errorMessageOrigin,self.DataResult];
}

@end
