//
//  SocketManager.m
//  socketDemo
//
//  Created by runo on 16/12/12.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "SocketManager.h"

@interface SocketManager ()

@end

@implementation SocketManager


+(instancetype)shareInstance{
    
    static SocketManager *manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[SocketManager alloc]init];
    });
    return manager;
}


@end
