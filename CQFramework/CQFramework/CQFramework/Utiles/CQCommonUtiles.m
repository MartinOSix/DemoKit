//
//  CQCommonUtiles.m
//  CQFramework
//
//  Created by runo on 16/11/7.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "CQCommonUtiles.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import "AFNetworking.h"
#import "CQColorDefine.h"

@implementation CQCommonUtiles

#pragma mark - 网络状态
+(BOOL)cqIsConnectNetwork{
    
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    SCNetworkReachabilityRef ref =SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr*)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接标示
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(ref, &flags);
    CFRelease(ref);
    
    if (!didRetrieveFlags) {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    return  (isReachable && !needsConnection) ? YES:NO;
}

+(void)cqStartNetworkStatusListener:(void (^)(NSString *))listener{
    //网络管理单列
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //设置监听回调
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSString *result = [NSString string];
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                result = @"UNKNOW";
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                result = @"WIFI";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                result = @"WAN";
                break;
            case AFNetworkReachabilityStatusNotReachable:
                result = @"NotReachable";
                break;
            default:
                break;
        }
        //在主线程回调数据
        listener(result);
    }];
    //开始监听
    [manager startMonitoring];
}

+(void)cqStopNetworkStatusListener{
    //网络管理单列
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager stopMonitoring];
}

#pragma mark - 提示框
+(void)cqShowWarningAlert:(NSString *)message
{
    [self cqShowTipsAlert:message Title:@"警告"];
}

+(void)cqShowTipsAlert:(NSString *)message{
    [self cqShowTipsAlert:message Title:@"提示"];
}

+(void)cqShowTipsAlert:(NSString *)message Title:(NSString *)title{
    UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:title message:message delegate:nil  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

+(void)cqShowTipsAlert:(NSString *)message AtController:(UIViewController *)vc YesAction:(void(^)(void))yesblock{
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (yesblock != nil) {
            yesblock();
        }
    }];
    [control addAction:yesAction];
    [vc presentViewController:control animated:YES completion:nil];
}

+(void)cqShowYesOrNoSheet:(UIViewController *)vc Title:(NSString *)title Message:(NSString *)message Yes:(void (^)(void))yesBlock No:(void (^)(void))noBlock{
    
    UIAlertController *control = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (yesBlock != nil) {
            yesBlock();
        }
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(noBlock != nil){
            noBlock();
        }
    }];
    [control addAction:noAction];
    [control addAction:yesAction];
    [vc presentViewController:control animated:YES completion:nil];
}

+(void)cqShowYesOrNoAlert:(UIViewController *)vc Title:(NSString *)title Message:(NSString *)message Yes:(void (^)(void))yesBlock No:(void (^)(void))noBlock{
    
    UIAlertController *control = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (yesBlock != nil) {
            yesBlock();
        }
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(noBlock != nil){
            noBlock();
        }
    }];
    [control addAction:yesAction];
    [control addAction:noAction];
    [vc presentViewController:control animated:YES completion:nil];
}

+(void)cqShowYesOrNoTextAlert:(UIViewController *)vc Title:(NSString *)title Message:(NSString *)message Yes:(void (^)(UITextField *textTF))yesBlock No:(void (^)(UITextField *textTF))noBlock{
    
    UIAlertController *control = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *txTF = nil;
    [control addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //一般做初始化
        textField.backgroundColor = kWhiteColor;
        textField.textColor = kBlackColor;
        textField.placeholder = @"输入框";
        txTF = textField;
    }];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //其实在这里已经可以拿到上面的Textfield
        if (([txTF.text rangeOfString:@"."].location != NSNotFound)||
            [txTF.text isEqualToString:@""] ||
            ([txTF.text rangeOfString:@" "].location != NSNotFound)
            ) {
            //[vc.view makeToast:@"非法文件名" duration:3.0f position:@"top"];
            [self cqShowYesOrNoTextAlert:vc Title:title Message:message Yes:yesBlock No:noBlock];
        }else{
            if (yesBlock != nil) {
                yesBlock(txTF);
            }
        }
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(noBlock != nil){
            noBlock(txTF);
        }
    }];
    [control addAction:yesAction];
    [control addAction:noAction];
    [vc presentViewController:control animated:YES completion:nil];
}

#pragma mark - 文件操作
+(NSString *)cqGetLibraryPath{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    return filePath;
}
+(NSString *)cqGetDocumentPath{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    return filePath;
}
+(NSString *)cqGetCachePath{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    return filePath;
}

+(BOOL)cqCreateDirectory:(NSString *)directoryPath{
    NSError *error = nil;
    BOOL result = [[NSFileManager defaultManager]createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (error != nil) {
        NSLog(@"%@",error);
        NSLog(@"创建文件夹失败");
    }
    return result;
}
+(BOOL)cqCreateFile:(NSString *)filePath{
    BOOL result = [[NSFileManager defaultManager]createFileAtPath:filePath contents:nil attributes:nil];
    if (!result) {
        NSLog(@"创建数据库文件失败");
    }
    return result;
}
+(BOOL)cqDeleteFile:(NSString *)filePath{
    if ([self cqFileIsExist:filePath]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        BOOL isSuccess = [fileManager removeItemAtPath:filePath error:&error];
        NSLog(@"cqDeleteFileError %@",error);
        return isSuccess;
    }else{
        NSLog(@"cqDeleteFile -- file already not exist");
        return YES;
    }
}
+(BOOL)cqFileIsExist:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    return isExist;
}
+(BOOL)cqMoveFileFrom:(NSString *)srcPath To:(NSString *)desPath{//src文件不再有
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = [fileManager moveItemAtPath:srcPath toPath:desPath error:nil];
    if (isSuccess) {
        NSLog(@"cqMoveFileFrom:To: success");
    }else{
        NSLog(@"cqMoveFileFrom:To: fail");
    }
    return isSuccess;
}
+ (unsigned long long)cqFolderSizeAtPath:(NSString*)folderPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:folderPath];
    if (isExist){
        NSEnumerator *childFileEnumerator = [[fileManager subpathsAtPath:folderPath] objectEnumerator];
        unsigned long long folderSize = 0;
        NSString *fileName = @"";
        while ((fileName = [childFileEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
            folderSize += [self cqFileSizeAtPath:fileAbsolutePath];
        }
        return folderSize;
    } else {
        NSLog(@"file is not exist");
        return 0;
    }
}
+ (unsigned long long)cqFileSizeAtPath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    if (isExist){
        unsigned long long fileSize = [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
        return fileSize;
    } else {
        NSLog(@"file is not exist");
        return 0;
    }
}
+(NSString *)cqSizeToString:(unsigned long long)size{//获得bit存储容量大小（字符串
    NSString *sizeStr = @"未知";
    if (size>=1024.0*1024.0*1024.0)
    {
        sizeStr=[NSString stringWithFormat:@"%0.2fG",size/1024.0/1024.0/1024.0f];
    }else if (size>=1024.0*1024.0)
    {
        sizeStr=[NSString stringWithFormat:@"%0.2fMB",size/1024.0/1024.0f];
        
    }else if(size > 0)
    {
        sizeStr=[NSString stringWithFormat:@"%0.0fKB",size/1024.0f];
        
    }else if (size == 0){
        sizeStr = @"0KB";
    }
    return sizeStr;
}


#pragma mark - 颜色
+(UIColor *)cqColorForHexString:(NSString *)hexStr{
    
    hexStr = [hexStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSInteger hexColor = strtoul([hexStr UTF8String], 0, 16);//将字符串按照16进制转化
    float red = ((float)((hexColor & 0xFF0000) >> 16));
    float green = ((float)((hexColor & 0xFF00) >> 8));
    float blue = ((float)(hexColor & 0xFF));
    return kCustomerColor(red, green, blue);
}
+(UIColor *)cqColorForHexString:(NSString *)hexStr Alpha:(CGFloat)alpha{
    hexStr = [hexStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSInteger hexColor = strtoul([hexStr UTF8String], 0, 16);
    float red = ((float)((hexColor & 0xFF0000) >> 16));
    float green = ((float)((hexColor & 0xFF00) >> 8));
    float blue = ((float)(hexColor & 0xFF));
    return kCustomerColorAlpha(red, green, blue,alpha);
}

#pragma mark - 其他
+(NSString *)cqGetSerialNumberString:(NSString *)numberStr{
    
    //序列化金钱字符串  “123123134.5” --> “123，123，134.5” */
    NSMutableString *mstr = [NSMutableString stringWithString:numberStr];
    
    NSRange dotRange = [numberStr rangeOfString:@"."];
    NSInteger startIndex = mstr.length-1;
    if (dotRange.location != NSNotFound) {
        startIndex = dotRange.location-1;
    }
    NSInteger count = 0;
    while (startIndex) {
        count++;
        if (count==3) {
            
            [mstr insertString:@"," atIndex:startIndex];
            count = 0;
        }
        startIndex--;
    }
    return [mstr copy];
}



+(NSArray *)cqGetAddressInfoList{
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"]];
    return arr;
}

+(NSArray *)cqGetChinaList{
    
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"]];
    if (arr == nil) {
        return  nil;
    }
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in arr) {
        [marr addObject:dic[@"value"]];
    }
    return [marr copy];
}
+(NSArray *)cqGetCitysByProvince:(NSString *)province{
    
    NSArray *arr = [self cqGetAddressInfoList];
    for (NSDictionary *dic in arr) {
        if ([dic[@"value"] isEqualToString:province]) {
            NSArray *arr2 = dic[@"children"];
            NSMutableArray *marr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic2 in arr2) {
                [marr addObject:dic2[@"value"]];
            }
            return [marr copy];
        }
    }
    return nil;
}
/**城市数组*/
+(NSArray *)cqGetCountyByCity:(NSString *)city{
    
    NSArray *arr = [self cqGetAddressInfoList];
    for (NSDictionary *province in arr) {
        for (NSDictionary *dic2 in province[@"children"]) {
            if ([dic2[@"value"] isEqualToString:city]) {
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dic3 in dic2[@"children"]) {
                    [marr addObject:dic3[@"value"]];
                }
                return marr;
            }
        }
    }
    return nil;
}

@end
