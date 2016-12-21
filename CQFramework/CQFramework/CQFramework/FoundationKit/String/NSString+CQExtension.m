//
//  NSString+CQExtension.m
//  CQFramework
//
//  Created by runo on 16/11/7.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "NSString+CQExtension.h"
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat"            //format类型警告
#pragma clang diagnostic ignored "-Wshorten-64-to-32" //long 到 int 的警告

@implementation NSString (CQExtension)

#pragma mark - 字符串判断
+ (BOOL)cqCheckPWD:(NSString *)pwd//6-16 位，字母数字组合
{
    NSString * regex = @"^[A-Za-z0-9]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return ([pred evaluateWithObject:pwd])? YES : NO ;
}

/**判断是否是身份证，判断条件有限，并不判断校验码是否正确，只是常规判断*/
-(BOOL)cqIsIDcardNumber:(NSString *)idCard{
    if ([NSString cqIsNullString:self]) {
        return NO;
    }
    NSString *regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0[1-9])||(1[0-2]))((0[1-9])||(1\\d)||(2\\d)||(3[0-1]))\\d{3}([0-9]||X)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

-(BOOL)cqIsPhoneNumber{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

+(BOOL)cqIsNullString:(NSString *)string{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

#pragma mark - 字符串编码
+(NSString *)cqCreateUUID{
    // Create universally unique identifier (object)
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    // Get the string representation of CFUUID object.
    NSString *uuidStr = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
    CFRelease(uuidObject);
    return uuidStr;
}

+(NSString *)cqDecodeGTMBase64:(NSString *)decodeStr{
    return [GTMBase64 stringByBase64String:decodeStr];
}

-(NSString *)cqEncodeWithGTMBase64{
    return [GTMBase64 base64StringBystring:self];
}
-(NSString *)cqGetMD5{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr,strlen(cStr),result);
    NSString *md5Str = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],result[8],result[9],result[10],result[11],result[12],result[13],result[14],result[15]];
    return md5Str;
}
-(NSString *)cqTrim{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    //去除字符串左右两边的空格和换行
    //去除指定字符串可以使用 [self stringByReplacingOccurrencesOfString:@"xxx" withString:@""];
    return [self stringByTrimmingCharactersInSet:set];
}

+(NSString *)cqEncodeDESWithString:(NSString *)string Key:(NSString *)key{
    CCOperation type = kCCDecrypt;
    NSString *aKey = key;
    const char * contentChar =[string UTF8String];
    char * keyChar =(char*)[aKey UTF8String];
    const char *miChar;
    miChar = encryptWithKeyAndType(contentChar, type, keyChar);
    return  [NSString stringWithCString:miChar encoding:NSUTF8StringEncoding];
}
+(NSString *)cqDecodeDESWithString:(NSString *)string Key:(NSString *)key{
    CCOperation type = kCCEncrypt;
    NSString *aKey = key;
    const char * contentChar =[string UTF8String];
    char * keyChar =(char*)[aKey UTF8String];
    const char *miChar;
    miChar = encryptWithKeyAndType(contentChar, type, keyChar);
    return  [NSString stringWithCString:miChar encoding:NSUTF8StringEncoding];
}

static const char* encryptWithKeyAndType(const char *text,CCOperation encryptOperation,char *key)
{
    NSString *textString=[[NSString alloc]initWithCString:text encoding:NSUTF8StringEncoding];
    //      NSLog(@”[[item.url description] UTF8String=%@”,textString);
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [GTMBase64 decodeData:[textString dataUsingEncoding:NSUTF8StringEncoding]];//转utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [textString dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    //CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //理解位type/typedef 缩写（效维护代码比：用int用long用typedef定义）
    size_t dataOutAvailable = 0; //size_t  操作符sizeof返结类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 00, dataOutAvailable);//已辟内存空间buffer首 1 字节值设值 0
    
    //NSString *initIv = @”12345678″;
    const void *vkey = key;
    const void *iv = (const void *) key; //[initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    //ccStatus =
    CCCrypt(encryptOperation,//  加密/解密
            kCCAlgorithmDES,//  加密根据哪标准（des3desaes）
            kCCOptionPKCS7Padding,//  选项组密码算(des:每块组加密  3DES：每块组加三同密)
            vkey,  //密钥    加密解密密钥必须致
            kCCKeySizeDES,//  DES 密钥（kCCKeySizeDES=8）
            iv, //  选初始矢量
            dataIn, // 数据存储单元
            dataInLength,// 数据
            (void *)dataOut,// 用于返数据
            dataOutAvailable,
            &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //解密data数据改变utf-8字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    }
    else //encryptOperation==0  （加密程加密数据转base64）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [GTMBase64 stringByEncodingData:data];
    }
    free(dataOut);//释放指针防止内存泄漏
    return [result UTF8String];
    
}

#pragma mark - 字符串计算
+(CGFloat)cqStringHeightFromFontSize:(CGFloat)fontSize{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    NSString *str = @"哈哈";
    CGSize LabeLsize = [str boundingRectWithSize:CGSizeMake(1000, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return LabeLsize.height;
}
-(CGSize)cqStringSize:(CGSize)maxSize FontSize:(CGFloat)fontSize{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize LabeLsize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return LabeLsize;
}
-(CGSize)cqStringSize:(CGSize)maxSize Font:(UIFont *)font{
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGSize LabeLsize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return LabeLsize;
}
-(CGFloat)cqStringSingleLineWidthWithFont:(CGFloat)font{
    CGFloat height = [[self class]cqStringHeightFromFontSize:font];
    return [self cqStringSize:CGSizeMake(0, height) FontSize:font].width;
}

+(NSString *)cqRoundUp:(float)number afterPoint:(int)position{
    /*
     NSRoundPlain,   // Round up on a tie ／／貌似取整 翻译出来是个圆 吗的垃圾百度翻译
     NSRoundDown,    // Always down == truncate  ／／只舍不入
     NSRoundUp,      // Always up    ／／ 只入不舍
     NSRoundBankers  // on a tie round so last digit is even  貌似四舍五入
     */
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:number];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

@end

#pragma clang diagnostic pop
