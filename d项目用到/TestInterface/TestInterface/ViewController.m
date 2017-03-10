//
//  ViewController.m
//  TestInterface
//
//  Created by runo on 16/11/17.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "CQURL.h"
#import "EntryString.h"
#import "NSArray+CQArray.h"

#define kURL @"http://27.221.58.35:8000/webapi/ajax/phoneapi.ashx"
#define kURL2 @"http://openapi.aodianyun.com/v2/LCPS.GetApp"

@interface ViewController ()

@property(nonatomic,strong)NSURLSessionDataTask *task;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test0217];
    self.task = [self postParamenter:[self getParamenter] NeedEntry:YES];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"重试" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 100, 30);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(retry) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

-(void)retry{
    
    if (self.task.state == NSURLSessionTaskStateRunning) {
        return;
    }
    self.task = [self postParamenter:[self getParamenter] NeedEntry:YES];
}

-(NSDictionary *)getParamenter{
    
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
/*
 deviceIDs : ["9764646","9794646"],
	osType : "ios",
	svcName : Submit_Binging,
	rmCode : "GDSZ20161124001",
	orderCode : "GDSZ20161124004"
 */
    /*
    [dic setObject:[CQURL ToJson:@[@"134000000009",@"134000000007"]] forKey:@"deviceIDs"];
    [dic setObject:[CQURL ToJson:@"GDSZ20161124001"] forKey:@"rmCode"];
    [dic setObject:[CQURL ToJson:@"GDSZ20161124004"] forKey:@"orderCode"];
    
    [dic setObject:@"Submit_Binging" forKey:@"svcName"];
    */
    [dic setObject:@"123456789" forKey:@"access_id"];
    [dic setObject:@"ABCDEFG" forKey:@"access_key"];
     return [dic copy];
    
}

-(NSURLSessionDataTask *)postParamenter:(NSDictionary *)dic NeedEntry:(BOOL)needEncrypt{
    
    //打印请求参数
    NSLog(@"%@",dic);
    //配置请求引擎
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer.timeoutInterval = 30.0f;
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //补充参数
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    //[mdic setObject:[CQURL ToJson:@"ios"] forKey:@"osType"];
    NSLog(@"%@",mdic);
    //逐个加密所有请求数据
    if (needEncrypt) {
        for (NSString *key in mdic.allKeys) {
            [mdic setObject:[EntryString encodeCryptWithContent:mdic[key]] forKey:key];
        }
        NSString *token = [EntryString getToken];
        //额外的请求头
        [manager.requestSerializer setValue:[EntryString encodeCryptWithContent:token] forHTTPHeaderField:@"token"];//加密
        [manager.requestSerializer setValue:[EntryString getTimeStampWithToken:token] forHTTPHeaderField:@"timestamp"];//不加密
    }
    
    return [manager POST:kURL2 parameters:mdic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSString *resp = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",resp);
        
        NSDictionary * dics= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //打印输出
        NSLog(@"\n%@",dics);
        
        //打印模型定义属性
        if ([dics[@"Result"] isKindOfClass:[NSDictionary class]]) {
           NSLog(@"\n%@",[self serializeModel:dics[@"Result"]]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString *erroMessage = nil;
        switch (error.code) {
            case -1001:
                erroMessage = @"请求超时";
                break;
            case -1009:
                erroMessage = @"无法连接服务器";
            case -1004:
                erroMessage = @"未能连接到服务器";
            default:
                erroMessage = @"网络异常,请稍后再试!";
                break;
        }
        //打印错误
        NSLog(@"ErrorCode :%ld  \n ErrorMessage:%@",(long)error.code,erroMessage);
    }];
    
}

-(NSString *)serializeModel:(NSDictionary *)dic{
    //将属性换成代码格式打印出来
    //@property(nonatomic,copy) NSString *<#property#>;//!<<#property#>
    NSMutableString *mstr = [[NSMutableString alloc]init];
    for (NSString *key in [dic allKeys]) {
        
        if ([[dic objectForKey:key] isKindOfClass:[NSString class]]) {
            [mstr appendFormat:@"@property(nonatomic,copy) NSString *%@;//!<\n",key];
        }else if ([[dic objectForKey:key] isKindOfClass:[NSArray class]]){
            [mstr appendFormat:@"@property(nonatomic,strong) NSArray *%@;//!<\n",key];
        }else if ([[dic objectForKey:key] isKindOfClass:[NSDictionary class]]){
            [mstr appendFormat:@"@property(nonatomic,copy) %@ *%@Model;//!<\n",key,key];
            [mstr appendFormat:@"Class  %@\n{\n",key];
            [mstr appendString:[self serializeModel:[dic objectForKey:key]]];
            [mstr appendFormat:@"}\n"];
        }
    }

    return [mstr copy];
}

#pragma mark 其他测试
-(void)test0217{
    
    NSString *key = @"key";
    key = [CQURL ToJson:key];
    
    NSDictionary *dic = @{key:@"value"};
    NSLog(@"%@",[dic allKeys]);
    NSLog(@"%@  %@",dic,dic[@"\"key\""]);
    
}

@end
