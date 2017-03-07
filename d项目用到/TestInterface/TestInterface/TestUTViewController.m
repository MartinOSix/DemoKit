//
//  TestUTViewController.m
//  TestInterface
//
//  Created by runo on 17/3/1.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "TestUTViewController.h"
#import "AFNetworking.h"
#import "SBJson.h"
#import "CQURL.h"

#define kURL @"http://login.youshixi.com/loginApi/login"
#define kAddressURL @"http://stu1.youshixi.com/app/commonUtilService/getProAndCity"


@interface TestUTViewController ()

@property(nonatomic,strong)NSURLSessionDataTask *task;

@end

@implementation TestUTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //self.task = [self postParamenter:[self getParamenter] URL:kURL];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"重试" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 100, 30);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(retry) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    
}

-(void)test{
    
}

-(void)retry{
    
    if (self.task != nil && self.task.state == NSURLSessionTaskStateRunning) {
        return;
    }
    //self.task = [self postParamenter:[self getParamenter]  URL:kURL];
    self.task = [self postParamenter:nil  URL:kAddressURL];
}

-(NSURLSessionDataTask *)postParamenter:(NSDictionary *)dic URL:(NSString *)url{
    /*
    NSURL *aurl = [NSURL URLWithString:kURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[NSString stringWithFormat:@"username=18202976025&password=333333"] dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"--respData--%@",response);
        NSString *resp = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"-respString-%@",resp);
    }];
    [task resume];
    return task;
    */
    
    //打印请求参数
    NSLog(@"%@",dic);
    //配置请求引擎
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer.timeoutInterval = 30.0f;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //
    //额外请求头
    [manager.requestSerializer setValue:@"{\"token\":\"c0kM9S1/52VKGwj+mrYxk/LXuHBk22ah+/ooaZVRprw=\",\"username\":\"18202976025\"}" forHTTPHeaderField:@"appBaseInfo"];//加密
    //补充参数
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    
    for (NSString *key in dic.allKeys) {
        id obj = [dic objectForKey:key];
        //obj = [CQURL ToJson:obj];
        NSString *newkey = [CQURL ToJson:key];
        [mdic setObject:obj forKey:key];
    }
    
    NSLog(@"--post--%@",mdic);
    
    return [manager POST:url parameters:mdic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"--respData--%@",responseObject);
        NSString *resp = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"-respString-%@",resp);
        
        NSDictionary * dics= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //打印输出
        NSLog(@"--respDic--\n%@",dics);
        
        //打印模型定义属性
        if ([dics[@"Result"] isKindOfClass:[NSDictionary class]]) {
            
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
        NSLog(@"ErrorCode :%ld  \n ErrorMessage:%@  Error:%@",(long)error.code,erroMessage,error);
    }];
     
    
}

-(NSDictionary *)getParamenter{
    /*
    NSString *userName = @"";
    NSString *token = @"";
    NSString *deviceId = @"";
    NSString *deviceName = @"";
    NSString *requesttime = @"2015050605";
    NSString *language = @"中文";
    NSString *version = @"ios1.3";
    NSString *appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *model = @"";
    NSString *devicefrom = @"";
    NSString *networkType = @"";
    NSString *apptype = @"ios";
    NSString *appid = @"";
    
    NSDictionary *dic = @{@"userName":userName,
                          @"token":token,
                          @"deviceId":deviceId,
                          @"deviceName":deviceName,
                          @"requesttime":requesttime,
                          @"language":language,
                          @"version":version,
                          @"appversion":appversion,
                          @"model":model,
                          @"devicefrom":devicefrom,
                          @"networkType":networkType,
                          @"apptype":apptype,
                          @"appid":appid
                          };
     */
    NSDictionary *dic = @{@"username":@"18202976025",@"password":@"333333"};
    return dic;
}

@end
