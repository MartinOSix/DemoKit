//
//  SocketManager.h
//  socketDemo
//
//  Created by runo on 16/12/12.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@protocol SocketManagerDelegate <NSObject>


-(void)didFailedConnect:(NSError *)error;


@end

@interface SocketManager : NSObject

@property(nonatomic,assign) BOOL state;//!<连接状态
@property(nonatomic,readonly,copy) NSString *hostName;//!<主机号
@property(nonatomic,readonly,assign) NSInteger port;//!<端口号

+(instancetype)shareInstance;

-(void)connectHost:(NSString *)host Port:(uint16_t)port;
-(void)disConnect;
-(void)sendMessage:(NSString *)sendMsg Tag:(long)tag;

@end
