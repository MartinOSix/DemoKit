//
//  ViewController.m
//  replaceEmoji
//
//  Created by runo on 17/3/28.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "ViewController.h"

/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

@interface ViewController ()

@property(nonatomic,strong) UITextField *inputTF;
@property(nonatomic,strong) UIButton *convertBTN;
@property(nonatomic,strong) UIButton *convertBTN1;
@property(nonatomic,strong) NSString *codeString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    
    self.inputTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 30)];
    self.inputTF.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.inputTF];
    // 哈哈 😆你好一😀最后🇿🇼字符㉿
    self.convertBTN1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.convertBTN1 addTarget:self action:@selector(convertToService) forControlEvents:UIControlEventTouchUpInside];
    self.convertBTN1.frame = CGRectMake(0, 150, kScreenWidth, 30);
    self.convertBTN1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.convertBTN1];
    
    self.convertBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.convertBTN addTarget:self action:@selector(convertToLabel) forControlEvents:UIControlEventTouchUpInside];
    self.convertBTN.frame = CGRectMake(0, 200, kScreenWidth, 30);
    self.convertBTN.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.convertBTN];
    
    UIImage *image = [UIImage imageNamed:@"smiles_02_07.png"];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    imageV.image = image;
    [self.view addSubview:imageV];
    
}

-(void)convertToService{
    NSString *string = self.inputTF.text;
    self.codeString = [self convertEmojiString:string];
    NSLog(@"%@",self.codeString);
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         //😛😛😝😚😚😚😚😚😚😚😚
         if (substringRange.length>0) {
             
             NSLog(@"-s- %@",substring);
             for(int i = 0; i < substringRange.length; i++){
                 const unichar hs = [substring characterAtIndex:i];
                 NSLog(@"-c- %i",hs);
             }
         }
         
     }];
    NSLog(@"%@",[NSString stringWithFormat:@"%c%c",55357,56858]);
}

-(void)convertToLabel{
    //😀
    NSString *str = [self decodeString:self.codeString];
    NSLog(@"%@",str);
    
}




//输入字符，转成传输服务器的字符串
-(NSString *)convertEmojiString:(NSString *)emojiString{
    
    NSString *inputStr = emojiString;
    NSMutableString *outPutString = [NSMutableString string];
    [inputStr enumerateSubstringsInRange:NSMakeRange(0, [inputStr length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         NSString *codeStr = [substring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         NSString *ecodeStr = [self codeStringFormEmojiCode:codeStr];
         if (ecodeStr.length == 0) {
             [outPutString appendString:substring];
         }else{
             [outPutString appendString:ecodeStr];
         }
     }];
    
    return outPutString;
}

//服务器的字符串转成可以显示的字符串
-(NSString *)decodeString:(NSString *)serviceString{
    
    NSMutableString *outPutString = [NSMutableString string];
    NSRange range = [serviceString rangeOfString:@"[cq_"];
    BOOL hasReturn = range.location != NSNotFound;
    NSInteger serviceLocation = 0;
    BOOL normalEnd = YES;
    while (hasReturn) {
        
        NSInteger length = range.location - serviceLocation;
        NSString *additionString = [serviceString substringWithRange:NSMakeRange(serviceLocation, length)];
        [outPutString appendString:additionString];
        serviceLocation += additionString.length;
        //判断特殊字符
        range.length += 5;
        if (range.location + range.length > serviceString.length) {
            [outPutString appendString:[serviceString substringFromIndex:range.location]];
            normalEnd = NO;
            break;
        }
        NSString *emojiCodeStr = [serviceString substringWithRange:range];
        NSString *emoji = [self emojiFormEmojiCodeStr:emojiCodeStr];
        
        if (emoji.length == 0) {
            [outPutString appendString:[emojiCodeStr substringToIndex:4]];
            serviceLocation += 4;
            range.location += 4;
        }else{
            [outPutString appendString:emoji];
            serviceLocation += 9;
            range.location += range.length;
        }
        range = [serviceString rangeOfString:@"[cq_" options:NSLiteralSearch range:NSMakeRange(range.location, serviceString.length-range.location)];
        hasReturn = range.location != NSNotFound;
        NSLog(@"%@",outPutString);
        
    }
    if (serviceLocation < serviceString.length && normalEnd) {
        [outPutString appendString:[serviceString substringFromIndex:serviceLocation]];
    }
    
    return outPutString;
    
}

/** %F0%9F%98%80 ->  [cq_haha]*/
-(NSString *)codeStringFormEmojiCode:(NSString *)codeStr{
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"emojiBirdge" ofType:@"plist" ]];
    NSString *str = [dic objectForKey:codeStr];
    if (str == nil) {
        str = @"";
    }
    return str;
}

/**[cq_haha]  ->  😀*/
-(NSString *)emojiFormEmojiCodeStr:(NSString *)emojiCode{
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"emoji" ofType:@"plist" ]];
    NSString *str = [dic objectForKey:emojiCode];
    if (str == nil) {
        str = @"";
    }
    return str;
}

@end
