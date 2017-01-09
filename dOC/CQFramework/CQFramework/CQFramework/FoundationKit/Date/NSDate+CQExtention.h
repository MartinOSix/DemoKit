//
//  NSDate+CQExtention.h
//  CQFramework
//
//  Created by runo on 16/11/28.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CQDateFormatType) {
    
    /**yyyy-MM-dd HH:mm:ss*/
    CQDateFromatType1 = 0,
    
    /**yyyyMMddHHmmss*/
    CQDateFromatType2,
    
    /**yyyy.MM.dd*/
    CQDateFromatType3,
    
    /**yyyy-MM-dd*/
    CQDateFromatType4,
    
    /**yyyy_MM_dd_HH_mm_ss*/
    CQDateFromatType5,
    
    /**yyyy/MM/dd*/
    CQDateFromatType6,
    
    /**yyyy-MM-dd HH:mm*/
    CQDateFromatType7,
    
    /**MM-dd HH:mm*/
    CQDateFromatType8,
    
    /**yyyyMMdd000000*/
    CQDateFromatType9
    
    // 在这里添加了之后还要在cqFormatStringWithType添加相应的case
};



// CST 北京时间(CST 但是代表的时区是 GMT-6)    GMT  国际时间
@interface NSDate (CQExtention)

#pragma mark - 基本属性
@property(nonatomic,readonly) NSInteger cqCSTYear;//!<年 +8
@property(nonatomic,readonly) NSInteger cqCSTMonth;//!<月 +8
@property(nonatomic,readonly) NSInteger cqCSTDay;//!<天 +8
@property(nonatomic,readonly) NSInteger cqCSTHour;//!<时 +8
@property(nonatomic,readonly) NSInteger cqCSTMinute;//!<分 +8
@property(nonatomic,readonly) NSInteger cqCSTSecond;//!<秒 +8
@property(nonatomic,readonly) NSInteger cqCSTNanosecond;//!<毫秒 +8

@property(nonatomic,readonly) NSInteger cqGMTYear;//!<年 +0
@property(nonatomic,readonly) NSInteger cqGMTMonth;//!<月 +0
@property(nonatomic,readonly) NSInteger cqGMTDay;//!<天 +0
@property(nonatomic,readonly) NSInteger cqGMTHour;//!<时 +0
@property(nonatomic,readonly) NSInteger cqGMTMinute;//!<分 +0
@property(nonatomic,readonly) NSInteger cqGMTSecond;//!<秒 +0
@property(nonatomic,readonly) NSInteger cqGMTNanosecond;//!<毫秒 +0

@property(nonatomic,readonly) NSInteger cqWeekdayOrdinal;//!<本月的第几个星期几
@property(nonatomic,readonly) NSInteger cqWeekday;//!<星期几 ？
@property(nonatomic,readonly) NSInteger cqWeekOfMonth;//!<本月第几周 1~5
@property(nonatomic,readonly) NSInteger cqWeekOfYear;//!<本年第几周 1~53
@property(nonatomic,readonly) NSInteger cqYearForWeekOfYear;//!<不知道?
@property(nonatomic,readonly) NSInteger cqQuarter;//!<几刻钟 15分钟为一刻 1~4
@property(nonatomic,readonly) BOOL cqIsLeapMonth;//!<是否是闰月，农历中的
@property(nonatomic,readonly) BOOL cqIsLeapYear;//!<是否是闰年
@property(nonatomic,readonly) BOOL cqIsToday;//!<是否是今天
@property(nonatomic,readonly) BOOL cqIsYesterday;//!<是否是昨天
@property(nonatomic,readonly) BOOL cqIsBeforeYesterday;//!<是否是前天
@property(nonatomic,readonly) BOOL cqIsToyear;//!<是否是今年,比较当前时区

#pragma mark - 调整时间
-(NSDate *)cqDateByAddingYears:(NSInteger)years;
-(NSDate *)cqDateByAddingMonths:(NSInteger)months;
-(NSDate *)cqDateByAddingWeeks:(NSInteger)weeks;
-(NSDate *)cqDateByAddingDays:(NSInteger)days;
-(NSDate *)cqDateByAddingHours:(NSInteger)hours;
-(NSDate *)cqDateByAddingMinutes:(NSInteger)minutes;
-(NSDate *)cqDateByAddingSeconds:(NSInteger)seconds;

#pragma mark - 格式转换
+(NSDate *)cqCSTDate;
-(NSDate *)cqCSTDateToGMTDate;
-(NSDate *)cqGMTDateToCSTDate;
+(NSDate *)cqConvertGMTDateToCSTDate:(NSDate *)GMTDate;
+(NSDate *)cqGetGMTDateFromCSTString:(NSString *)CSTString Type:(CQDateFormatType)type;
+(NSDate *)cqGetCSTDateFromGMTString:(NSString *)CSTString Type:(CQDateFormatType)type;
+(NSDate *)cqGetCSTDateFromCSTString:(NSString *)CSTString Type:(CQDateFormatType)type;

+(NSString *)cqNowCSTDateToStringWithType:(CQDateFormatType)type;
-(NSString *)cqToCSTDateStringWithFormat:(CQDateFormatType)type;
-(NSString *)cqToGMTDateStringWithFormat:(CQDateFormatType)type;
-(NSString *)cqConvertDateString:(NSString *)originStr Type:(CQDateFormatType)originType ToDestinationType:(CQDateFormatType)destinationType;

+(NSDate *)cqCreateDateByYear:(NSUInteger)year
                        Month:(NSUInteger)month
                          Day:(NSUInteger)day
                         Hour:(NSUInteger)hour
                          Min:(NSUInteger)min
                       Second:(NSUInteger)sec;

#pragma mark - 间隔、比较
+(NSTimeInterval)cqIntervalByDate:(NSDate *)date AndDate:(NSDate *)anotherDate;
+(NSTimeInterval)cqIntervalByDateString:(NSString *)dateString AndDateString:(NSString *)anotherDateString Type:(CQDateFormatType)type;

+(NSComparisonResult)cqCompareDate:(NSDate *)dateA AndDate:(NSDate *)dateB;
+(NSComparisonResult)cqCompareDateString:(NSString *)dateStrA AndDateString:(NSString *)dateStrB Type:(CQDateFormatType)type;
+(BOOL)cqIsSameDay:(NSDate *)date1 date2:(NSDate *)date2;
+(NSString *)cqIntervalStringByInterval:(NSTimeInterval)interval;

/*
 .timeIntervalSinceNow   是将调用时间当成GMTDate 与CST时间八个小时前的GMTDate比较
 
 
 */

@end
