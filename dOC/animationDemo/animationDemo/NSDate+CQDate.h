//
//  NSDate+CQDate.h
//  CQUtils
//
//  Created by runo on 16/5/17.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <Foundation/Foundation.h>

_Pragma("clang assume_nonnull begin")

///时间格式枚举
typedef NS_ENUM(NSInteger, CQDateFromatType) {
                            ///   yyyy-MM-dd HH:mm:ss
    CQDateFromatType1 = 0,  ///   yyyyMMddHHmmss
    CQDateFromatType2,      ///   yyyy.MM.dd
    CQDateFromatType3,      ///   yyyy-MM-dd
    CQDateFromatType4,      ///   yyyy_MM_dd_HH_mm_ss
    CQDateFromatType5,      ///   yyyy/MM/dd
    CQDateFromatType6,      ///   yyyy-MM-dd HH:mm
    CQDateFromatType7,      ///   MM-dd HH:mm
    CQDateFromatType8,      ///   yyyyMMdd000000
    CQDateFromatType9
    /*
        这里注释错位对齐，这样提示看到的是对应的
        在这里添加了之后还要在cqFormatStringWithType添加相应的case
     */
};

@interface NSDate (CQDate)


#pragma mark - Component Properties
@property(nonatomic,readonly) NSInteger cqYear;//!<年
@property(nonatomic,readonly) NSInteger cqMonth;//!<月
@property(nonatomic,readonly) NSInteger cqDay;//!<天
@property(nonatomic,readonly) NSInteger cqHour;//!<时,当前时区的hour，在源UTC时间加八
@property(nonatomic,readonly) NSInteger cqMinute;//!<分
@property(nonatomic,readonly) NSInteger cqSecond;//!<秒
@property(nonatomic,readonly) NSInteger cqNanosecond;//!<毫秒
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

#pragma mark - Date modify
-(nullable NSDate *)cqDateByAddingYears:(NSInteger)years;
-(nullable NSDate *)cqDateByAddingMonths:(NSInteger)months;
-(nullable NSDate *)cqDateByAddingWeeks:(NSInteger)weeks;
-(nullable NSDate *)cqDateByAddingDays:(NSInteger)days;
- (nullable NSDate *)cqDateByAddingHours:(NSInteger)hours;
- (nullable NSDate *)cqDateByAddingMinutes:(NSInteger)minutes;
- (nullable NSDate *)cqDateByAddingSeconds:(NSInteger)seconds;

/**获取当前时间字符串 yyyy-MM-dd HH:mm:ss*/
+(NSString *)cqNowString;
/**当前时区时间*/
+(NSDate *)cqNowDate;

/**
 *  当前时间转化为指定格式的字符串
 *
 *  @param formatString 字符串格式
 *
 *  @return 转化后的字符串
 */
+(NSString *)cqNowDateToStringWithFormatString:(CQDateFromatType)formatString;

/**
 *  将 yyyy-MM-dd HH:mm:ss 格式的字符串转化成date
 *
 *  @param string yyyy-MM-dd HH:mm:ss 格式的字符串
 *
 *  @return date
 */
+(NSDate *)cqGetDateFromString:(NSString *)string;

/**
 *  字符串转时间
 *
 *  @param format     时间格式
 *  @param dateString 该格式的时间字符串
 *
 *  @return 时间
 */
+(NSDate *)cqGetDateString:(NSString *)dateString FormatType:(CQDateFromatType)format;

/**
 *  获取时间间隔中有_的时间
 *
 *  @param fileName 时间
 *
 *  @return 标准时间
 */
+(NSString *)cqGetHisvideoTime:(NSString*)fileName;

/**
 *  根据时间戳获取指定type的时间字符串
 *
 *  @param time 时间戳
 *  @param type 时间格式类型
 *
 *  @return 时间字符串
 */
+(NSString *)cqGetDateWithTimeIntervalSince1970:(NSTimeInterval)time Type:(CQDateFromatType)type;

/**计算两个时间字符串的间隔秒数 */
+(NSTimeInterval)cqCaculateBeforTime:(NSString *)btime AfterTime:(NSString *)afterTime Type:(CQDateFromatType)type;
+(NSTimeInterval)cqCaculateDateBeforTime:(NSDate *)btime AfterTime:(NSDate *)afterTime;

/**根据时间间隔计算间隔了几分秒时月年*/
+(NSString *)cqIntervalString:(NSTimeInterval)interval;
/**计算时间与当前时间的间隔*/
-(NSString *)dateIntervalWithNow;

/**根据秒数获得 00：00：00*/
+(NSString *)cqHMSStringWithInterval:(NSTimeInterval)interval;

/**根据UTC时间获取当前时区时间*/
+ (NSDate *)cqGetNowDateFromatAnDate:(NSDate *)anyDate;

/**比较两个时间字符串的前后顺序*/
+(NSComparisonResult)cqCompareDateString:(NSString *)date1 AndDateString:(NSString *)date2 DateType:(CQDateFromatType)type;

/**从一种类型的时间字符串转换成另一种类型的时间字符串*/
+(NSString *)cqConvertTypeStringToAnotherTypeString:(NSString *)dataTypeString OrignType:(CQDateFromatType)orgType DestinationType:(CQDateFromatType)desType;

/**获得当前时区下现在时间与这个时间的差*/
-(NSTimeInterval)cqTimeIntervalSinceNow;
/**判断是否是同一天*/
+(BOOL)cqIsSameDay:(NSDate *)date1 date2:(NSDate *)date2;
/**
 *  date转字符串
 *  @return 返回 yyyy-MM-dd HH:mm:ss 格式字符串
 */
-(NSString *)cqToString;

/**
 *  已制定格式转化字符串
 *  @param formatString 要转化的格式
 *  @return 转化后的字符串
 */
-(NSString *)cqToStringWithFormatString:(CQDateFromatType)type;


#pragma mark - 获取date中的年月日
-(NSUInteger)cqYearFromDate;//!<UTC year
-(NSUInteger)cqMonthFromDate;//!<UTC month
-(NSUInteger)cqDayFromDate;//!<UTC day
-(NSInteger)cqHourFormDate;//!<UTC hour
-(NSInteger)cqMinFormDate;//!<UTC minte

#pragma mark - 根据指定时间创建时间对象
+(NSDate *)cqCreateDateYear:(NSUInteger)year Month:(NSUInteger)month Day:(NSUInteger)day Hour:(NSUInteger)hour Min:(NSUInteger)min Second:(NSUInteger)sec;
@end

_Pragma("clang assume_nonnull end")
