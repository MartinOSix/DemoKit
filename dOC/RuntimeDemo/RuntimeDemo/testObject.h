//
//  testObject.h
//  RuntimeDemo
//
//  Created by runo on 17/1/6.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface testObject : NSObject

@property(nonatomic,assign) NSInteger age;
@property(nonatomic,strong) NSString *strName;
@property(nonatomic,strong) NSArray *assets;
@property(nonatomic,strong) NSDictionary *classmate;

-(void)testPoint;
-(void)main;
@end
