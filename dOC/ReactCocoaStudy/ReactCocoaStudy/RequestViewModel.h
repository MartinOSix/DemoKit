//
//  RequestViewModel.h
//  ReactCocoaStudy
//
//  Created by runo on 17/7/4.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestViewModel : NSObject<UITableViewDataSource>

@property (nonatomic, strong) RACCommand *requesCommand;
@property (nonatomic, strong) NSArray *models;

@end
