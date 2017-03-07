//
//  CQConstantDefine.h
//  CQFramework
//
//  Created by runo on 16/10/28.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#ifndef CQConstantDefine_h
#define CQConstantDefine_h

/**系统版本*/
#define ISIOS7 ([UIDevice currentDevice].systemVersion.floatValue>=7.0?1:0)
#define ISIOS10 ([[UIDevice currentDevice].systemVersion floatValue]>=10.0?1:0)
#define kSYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define kSYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define kSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define kSYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define kSYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/**屏幕尺寸*/
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

/**导航栏高度*/
#define kNavigationHeight 64
#define kNavigationBar_H 44.0f
#define kStatusBar_H 20.0f
#define kTabbar_H 48.f

/**字体*/
#define ksysFont(cqfont) [UIFont systemFontOfSize:cqfont]
#define kfont14 ksysFont(14)
#define kfont13 ksysFont(13)

/**由角度获取弧度 有弧度获取角度*/
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)
#define kAdianToDegrees(radian) (radian*180.0)/(M_PI)

/**快速定义随机数*/
#define karcNumber(cqint) (arc4random()%cqint+1)
#define karcNumberWithZero(cqint) (arc4random()%cqint)
#define karcNumber10 (arc4random()%10+1)

/**本地化宏定义*/
#define kLocalString @"LocalString"//本地化文件名
#define kGetLocakString(cqkey) NSLocalizedStringFromTable(cqkey, kLocalString, nil)//获取本地化文字
#define kDBVersionKey @"kDBVersionKey"//数据库版本key
#define kUseUserModel 1 //是否使用UserModel
#define kIsNeedEncrypt 1//是否使用加密请求

/**判断空字符串*/
#define kIsEmptyString(str) (str==nil || \
str==NULL || \
[str isKindOfClass:[NSNull class]] || \
[[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)?YES:NO



/***************系统日志打印*************< start >*************/

/**打印内存警告*/
#define  kMemoryWarning   NSLog(@"%@ 收到内存警告", NSStringFromClass([self class]))

#define kLogTotal 1
#define kLogController 1
#define kLogView 1
#define kLogNetwork 1
#define kLogTmp 1
#define kLogFramework 1

#ifndef __OPTIMIZE__ //如果是debug模式
    //ios10打印
    #define pNSLog(...) printf("\n%s[Line %d] %s\n",__PRETTY_FUNCTION__, __LINE__,[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
    //带行号列号打印
    #define kNSLog(fmt, ...) \
    NSLog((@"\n%s [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
    //条件打印某一类的Bug
    #define kDebugLog(cqSwitch,fmt,...) cqSwitch&kLogTotal?NSLog((@"\n%s [Line %d] \n" fmt), __PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__):nil
    #define kpDebugLog(cqSwitch,...) cqSwitch&kLogTotal?printf("\n%s[Line %d]\n%s\n",__PRETTY_FUNCTION__,__LINE__,[[NSString stringWithFormat:__VA_ARGS__]UTF8String]):nil

    #define kfDebugLog(fmt,...)  kLogFramework&kLogTotal?NSLog((@"\n%s [Line %d] Framework Error \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__):nil

#else

    #define pNSLog(...)
    #define kNSLog(fmt, ...)
    #define kDebugLog(cqSwitch,fmt,...)
    #define kfDebugLog(fmt,...)

#endif
/***************系统日志打印*************< end >*************/

/**字符串快速拼接*/
#define kJointString(fmt, ...) [NSString stringWithFormat:fmt, ##__VA_ARGS__]

/**快捷单例宏定义*/
#define kNotificationCenter [NSNotificationCenter defaultCenter]
/**引用定义*/
#define WEAKSELF typeof(self) __weak weakSelf = self
#define WEAKOBJECT(obj) typeof(obj) __weak weakObj = obj
#define STRONGOBJECT(obj) typeof(obj) __strong strongObj = obj

//GCD - 一次性执行
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken;\
dispatch_once(&onceToken, onceBlock)
//GCD - 在Main线程上运行
#define kDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock)
//GCD - 开启异步线程
#define kDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlock)

#endif /* CQConstantDefine_h */
