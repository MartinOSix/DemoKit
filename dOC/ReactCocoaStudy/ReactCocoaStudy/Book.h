//
//  Book.h
//  ReactCocoaStudy
//
//  Created by runo on 17/7/4.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (nonatomic, strong) NSString *name;


+ (Book *)bookWithDict:(NSDictionary *)dic;

@end
