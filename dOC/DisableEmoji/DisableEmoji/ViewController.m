//
//  ViewController.m
//  DisableEmoji
//
//  Created by runo on 17/5/8.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textfiel;
@property (weak, nonatomic) IBOutlet UILabel *outlabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textfiel.delegate = self;
    
}

- (IBAction)btnclick:(id)sender {
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    //判断加上输入的字符，是否超过界限
    
    //   限制苹果系统输入法  禁止输入表情
    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    //禁止输入emoji表情
    if ([self stringContainsEmoji:string]) {
        return NO;
    }
    
    return YES;
}

//判断是否输入了emoji 表情
- (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    NSLog(@"string %@,length %zd",string,string.length);
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                
                                const unichar hs = [substring characterAtIndex:0];
                                printf("-- %04X   %c\n",hs,hs);
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        printf("-- %04X \n",uc);
                                        if (0x1d000 <= uc && uc <= 0x1f9c0) {//1f935 //2666
                                            NSLog(@"pass 1");
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    //0x2666♦️  0x26AB⚫️
                                    if (ls == 0x20e3 || (0x203c <= hs && hs <= 0x3299)) {
                                        NSLog(@"pass 2");
                                        returnValue = YES;
                                    }
                                    if (substring.length == 3) {
                                        if ((0x0030 <= hs && hs <= 0x0039) || hs == 0x002a || hs == 0x0023) {
                                            returnValue = YES;
                                        }
                                    }
                                    
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        NSLog(@"pass 3");
                                        returnValue = YES;
                                        
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        NSLog(@"pass 4");
                                        returnValue = YES;
                                        
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        NSLog(@"pass 5");
                                        returnValue = YES;
                                        
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        NSLog(@"pass 6");
                                        returnValue = YES;
                                        
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        NSLog(@"pass 7");
                                        returnValue = YES;
                                    }else if (hs == 0x200d){
                                        NSLog(@"pass 8");
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}



@end
