//
//  ViewController.m
//  liteDemo
//
//  Created by runo on 16/12/8.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "ClassA.h"

@interface ViewController ()<UITextFieldDelegate>
//,UITextInputDelegate

@end

@implementation ViewController{
    UITextField *_field;
    BOOL needChange;
    BOOL isAlpha;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    NSLog(@"%@",[self chineseToPinyin:@"重叠" withSpace:YES]);
    //
    //    [[SDK sharInstance] MethodA];
    //    [[SDK sharInstance] MethodB];
    //    [SDK sharInstance].result = ^(NSString *result){
    //        NSLog(@"%@",result);
    //    };
    
    _field = ({
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, 100, 30)];
        field.delegate = self;
        field.inputDelegate = self;
        field.backgroundColor = [UIColor redColor];
        [self.view addSubview:field];
//        [field addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        field;
    });
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFiledEditChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:_field];
    
    
    
    
}


//- (void)selectionDidChange:(nullable id <UITextInput>)textInput{
//    NSLog(@"--didchange");
//}
//
//- (void)textDidChange:(nullable id <UITextInput>)textInput{
//    NSLog(@"--didchange2");
//}

-(void)textFiledEditChanged:(NSNotification *)notification{
    
    //NSLog(@"-length-%u",((UITextField *)notification.object).text.length);
    //NSLog(@"-ntext-%@",((UITextField *)notification.object).text);
    NSLog(@"后走");
    static NSString *beforStr = nil;
//    static NSTimeInterval beforTime = 0.0;
//    NSTimeInterval originImterval = [[NSDate date] timeIntervalSince1970];
    NSString *originStr = ((UITextField *)notification.object).text;
//    originStr = [self trimString:originStr];
    
    
    
    
//    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 获取当前键盘输入模式
//    NSLog(@"%@",lang);
//    //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
//    
    
    if ([beforStr isEqualToString:originStr]&& !needChange) {
        _field.text = [originStr uppercaseString];
    }else if(isAlpha){
        originStr = [originStr uppercaseString];
        _field.text = originStr;
    }
//    beforTime = originImterval;
    beforStr = originStr;
    needChange = NO;
    
    
//    UITextRange *selectedRange = [_field markedTextRange];
//    NSLog(@"%@",selectedRange);
//    
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    
//    NSLog(@"keyPath");
//    NSLog(@"%@",change);
//}
//
//-(NSString *)trimString:(NSString *)str{
//    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
//}
//
//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    NSLog(@"-end--");
//}
//
//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    
//    NSLog(@"-return-");
//    return YES;
//}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"先走");
    needChange = YES;
    
    NSString *alphabet = @"qwertyuiopasdfghjklzxcvbnm";
    NSRange rangeOf = [alphabet rangeOfString:string];
    if (range.length == 0 && rangeOf.location == NSNotFound) {
        isAlpha = NO;
    }else{
        isAlpha = YES;
    }
    return YES;
//    
//    NSLog(@"%@",string);
//    NSLog(@"%@",NSStringFromRange(range));
//    if ([string isEqualToString:@""]) {
//        return YES;
//    }
//    
//    NSMutableString *mstr = [NSMutableString stringWithString:textField.text];
//    NSLog(@"%@",mstr);
//    [mstr replaceCharactersInRange:range withString:[string uppercaseString]];
//    NSLog(@"%@",mstr);
//    textField.text = mstr;
//    return NO;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (NSString*)chineseToPinyin:(NSString*)chinese withSpace:(BOOL)withSpace {
//    if(chinese) {
//        CFStringRef hanzi = (__bridge CFStringRef)chinese;
//        CFMutableStringRef string =CFStringCreateMutableCopy(NULL,0, hanzi);
//        //普通话转拼音
//        CFStringTransform(string,NULL, kCFStringTransformMandarinLatin,NO);
//        //去掉音调
//        CFStringTransform(string,NULL, kCFStringTransformStripDiacritics,NO);
//        NSString*pinyin = (NSString*)CFBridgingRelease(string);
//        if(!withSpace) {
//            pinyin = [pinyin stringByReplacingOccurrencesOfString:@" "withString:@""];
//        }
//        return pinyin;
//    }
//    return nil;
//}

@end
