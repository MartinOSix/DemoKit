//
//  LoginViewModel.h
//  ReactCocoaStudy
//
//  Created by runo on 17/7/4.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountModel.h"

@interface LoginViewModel : NSObject

@property (nonatomic, strong) AccountModel *account;
@property (nonatomic, strong) RACSignal *loginBtnEnabelSignal;
@property (nonatomic, strong) RACCommand *loginCommand;
@property (nonatomic, assign) BOOL loginSuccess;

@end
