//
//  Caculator.h
//  ReactCocoaStudy
//
//  Created by runo on 17/7/3.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Caculator : NSObject

@property (nonatomic, assign) BOOL isEqule;
@property (nonatomic, assign) int result;

-(Caculator *)caculator:(int(^)(int result))caculator;
-(Caculator *)equal:(BOOL(^)(int result))operation;

@end
