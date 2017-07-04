//
//  MVVMLoginViewController.m
//  ReactCocoaStudy
//
//  Created by runo on 17/7/4.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "MVVMLoginViewController.h"
#import "LoginViewModel.h"
#import "AccountModel.h"
#import "MainViewController.h"

@interface MVVMLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, strong) LoginViewModel *loginViewModel;

@end

@implementation MVVMLoginViewController

- (LoginViewModel *)loginViewModel{
    
    if (_loginViewModel == nil) {
        
        _loginViewModel = [[LoginViewModel alloc] init];
    }
    return _loginViewModel;
}

- (void)bindModel{
    
    //绑定数据
    RAC(self.loginViewModel.account,name) = _nameTF.rac_textSignal;
    RAC(self.loginViewModel.account,password) = _passwordTF.rac_textSignal;
    //绑定登录按钮
    RAC(self.loginBtn,enabled) = self.loginViewModel.loginBtnEnabelSignal;
    
    [RACObserve(self.loginViewModel, loginSuccess) subscribeNext:^(id  _Nullable x) {
       
        if ([x isEqualToNumber:@(YES)]) {
            MainViewController *mainVc = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
            [self presentViewController:mainVc animated:YES completion:nil];
            NSLog(@"present");
        }else{
            NSLog(@"登录失败");
        }
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self bindModel];
    
}

- (IBAction)loginAction:(id)sender {
    [self.loginViewModel.loginCommand execute:@(1)];
}

@end
