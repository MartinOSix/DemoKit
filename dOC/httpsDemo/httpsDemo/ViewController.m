//
//  ViewController.m
//  httpsDemo
//
//  Created by runo on 16/11/22.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"


#define kOpenHttps YES

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer.timeoutInterval = 30.0f;
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    
    //https 验证
    if (kOpenHttps) {
        [manager setSecurityPolicy:[self getSecurityPolicy]];
    }
    
    
    [manager POST:@"https://www.baidu.com" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *resp = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",resp);
        
        NSDictionary * dics=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //打印输出
        NSLog(@"\n%@",dics);
        
        
        
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

-(AFSecurityPolicy *)getSecurityPolicy{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"certificate" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    //对应域名的校验我认为应该在url中去逻辑判断。
    securityPolicy.validatesDomainName = NO;
    if (certData) {
        NSSet *cerSet = [NSSet setWithArray:@[certData]];
        securityPolicy.pinnedCertificates = cerSet;
    }
    
    return securityPolicy;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
