//
//  CQCommonUtiles.h
//  CQFramework
//
//  Created by runo on 16/11/7.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CQCommonUtiles : NSObject

#pragma mark - 网络状态
+(BOOL)cqIsConnectNetwork;//判断是否有网
+(void)cqStartNetworkStatusListener:(void(^)(NSString *networkStatus))listener;
+(void)cqStopNetworkStatusListener;//停止网络状态监听

#pragma mark - 提示框
+(void)cqShowWarningAlert:(NSString *)message;//警告框
+(void)cqShowTipsAlert:(NSString *)message;//提示框
+(void)cqShowTipsAlert:(NSString *)message Title:(NSString *)title;//弹框，带标题
+(void)cqShowTipsAlert:(NSString *)message AtController:(UIViewController *)vc YesAction:(void(^)(void))yesblock;//带确定事件的提示弹出框
+(void)cqShowYesOrNoAlert:(UIViewController *)vc Title:(NSString *)title Message:(NSString *)message Yes:(void(^)(void))yesBlock No:(void(^)(void))noBlock;//确定取消框,中间弹出
+(void)cqShowYesOrNoSheet:(UIViewController *)vc Title:(NSString *)title Message:(NSString *)message Yes:(void(^)(void))yesBlock No:(void(^)(void))noBlock;//确定弹出框，底部弹出
+(void)cqShowYesOrNoTextAlert:(UIViewController *)vc Title:(NSString *)title Message:(NSString *)message Yes:(void (^)(UITextField *textTF))yesBlock No:(void (^)(UITextField *textTF))noBlock;//显示输入文本框的alert

#pragma mark - FileOprator
//获取沙盒文件夹路径
+(NSString *)cqGetLibraryPath;
+(NSString *)cqGetDocumentPath;
+(NSString *)cqGetCachePath;

+(BOOL)cqCreateDirectory:(NSString *)directoryPath;
+(BOOL)cqCreateFile:(NSString *)filePath;
+(BOOL)cqDeleteFile:(NSString *)filePath;
+(BOOL)cqFileIsExist:(NSString *)filePath;
+(BOOL)cqMoveFileFrom:(NSString *)srcPath To:(NSString *)desPath;//src文件不再有

+ (unsigned long long)cqFolderSizeAtPath:(NSString*)folderPath;
+ (unsigned long long)cqFileSizeAtPath:(NSString *)filePath;
+(NSString *)cqSizeToString:(unsigned long long)size;//获得bit存储容量大小（字符串

#pragma mark - Color
+(UIColor *)cqColorForHexString:(NSString *)hexStr;
+(UIColor *)cqColorForHexString:(NSString *)hexStr Alpha:(CGFloat)alpha;

#pragma mark - Other
+(NSString *)cqGetSerialNumberString:(NSString *)numberStr;

+(NSArray *)cqGetAddressInfoList;
+(NSArray *)cqGetChinaList;//所有 省
+(NSArray *)cqGetCitysByProvince:(NSString *)province;//这个省的 所有市
+(NSArray *)cqGetCountyByCity:(NSString *)city;//这个市的 所有区县

@end
