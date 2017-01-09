//
//  CQAFHttpSessionManagerConfigurator.m
//  CQFramework
//
//  Created by runo on 16/11/29.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "CQAFHttpSessionManagerConfigurator.h"
#import "AFNetworking.h"

@implementation CQAFHttpSessionManagerConfigurator

+(AFHTTPSessionManager *)cqNormalManager{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer.timeoutInterval = 30.f;
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    return manager;
}



@end
