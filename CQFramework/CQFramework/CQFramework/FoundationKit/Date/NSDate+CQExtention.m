//
//  NSDate+CQExtention.m
//  CQFramework
//
//  Created by runo on 16/11/28.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "NSDate+CQExtention.h"

@implementation NSDate (CQExtention)

#pragma mark - 基本属性
-(NSInteger)cqCSTYear{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}
-(NSInteger)cqCSTMonth{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}
-(NSInteger)cqCSTDay{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}
-(NSInteger)cqCSTHour{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}
-(NSInteger)cqCSTMinute{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}
-(NSInteger)cqCSTSecond{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}
-(NSInteger)cqCSTNanosecond{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitNanosecond fromDate:self] nanosecond];
}

-(NSInteger)cqGMTYear{
    return [self cqSubDateFromDate:NSCalendarUnitYear];
}
-(NSInteger)cqGMTMonth{
    return [self cqSubDateFromDate:NSCalendarUnitMonth];
}
-(NSInteger)cqGMTDay{
    return [self cqSubDateFromDate:NSCalendarUnitDay];
}
-(NSInteger)cqGMTHour{
    return [self cqSubDateFromDate:NSCalendarUnitHour];
}
-(NSInteger)cqGMTMinute{
    return [self cqSubDateFromDate:NSCalendarUnitMinute];
}
-(NSInteger)cqGMTSecond{
    return [self cqSubDateFromDate:NSCalendarUnitSecond];
}
-(NSInteger)cqGMTNanosecond{
    return [self cqSubDateFromDate:NSCalendarUnitNanosecond];
}

-(NSInteger)cqSubDateFromDate:(NSCalendarUnit)flage{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDateComponents* comp1 = [calendar components:flage fromDate:self];
    NSInteger i = -1;
    switch (flage) {
        case NSCalendarUnitNanosecond:  i = [comp1 nanosecond];break;
        case NSCalendarUnitSecond:      i = [comp1 second];break;
        case NSCalendarUnitMinute:      i = [comp1 minute];break;
        case NSCalendarUnitHour:        i = [comp1 hour];break;
        case NSCalendarUnitDay:         i = [comp1 day];break;
        case NSCalendarUnitMonth:       i = [comp1 month];break;
        case NSCalendarUnitYear:        i = [comp1 year];break;
        default:
            break;
    }
    
    return i;
}

/**默认调用者是GMT时间 +0 */
-(NSInteger)cqWeekday{
    NSCalendar *cal = [NSCalendar currentCalendar];
    cal.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
    return [[cal components:NSCalendarUnitWeekday fromDate:self] weekday];
}

/**默认调用者是GMT时间 +0 */
-(NSInteger)cqWeekdayOrdinal{
    NSCalendar *cal = [NSCalendar currentCalendar];
    cal.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
    return [[cal components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

/**默认调用者是GMT时间 +0 */
-(NSInteger)cqWeekOfMonth{
    NSCalendar *cal = [NSCalendar currentCalendar];
    cal.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
    return [[cal components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

/**默认调用者是GMT时间 +0 */
-(NSInteger)cqWeekOfYear{
    NSCalendar *cal = [NSCalendar currentCalendar];
    cal.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
    return [[cal components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

/**不知道 默认是GMT时间调用 +0 */
-(NSInteger)cqYearForWeekOfYear{
    NSCalendar *cal = [NSCalendar currentCalendar];
    cal.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
    return [[cal components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

/**几刻钟 默认是GMT时间调用 +0 */
-(NSInteger)cqQuarter{
    NSCalendar *cal = [NSCalendar currentCalendar];
    cal.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
    return [[cal components:NSCalendarUnitQuarter fromDate:self] quarter];
}

/**是否闰月 默认GMT时间调用 +0 */
-(BOOL)cqIsLeapMonth{
    NSCalendar *cal = [NSCalendar currentCalendar];
    cal.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
    return [[cal components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

/**默认调用者是CST时间  跟当前的CST时间比*/
-(BOOL)cqIsToday{
    if (fabs([self cqCSTDateToGMTDate].timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate cqCSTDate].cqGMTDay == self.cqGMTDay;
}

/**是否是昨天 默认调用者CST 也是跟当前SCT比*/
-(BOOL)cqIsYesterday{
    NSDate *added = [self cqDateByAddingDays:1];
    return [added cqIsToday];
}

/**是否是前天 默认调用者CST 也是跟当前SCT比*/
-(BOOL)cqIsBeforeYesterday{
    NSDate *added = [self cqDateByAddingDays:2];
    return [added cqIsToday];
}

/**是否是今年 默认调用者CST 也是跟当前CST比*/
-(BOOL)cqIsToyear{
    return self.cqGMTYear == [NSDate cqCSTDate].cqGMTYear;
}

/**是否闰年 默认调用者CST时间 也是跟当前CST比*/
-(BOOL)cqIsLeapYear{
    NSUInteger year = self.cqCSTYear;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

#pragma mark - 调整时间
/**调用的时间基本都是GMT时间 不会加八*/
-(nullable NSDate *)cqDateByAddingYears:(NSInteger)years{
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    calendar.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}
/**调用的时间基本都是GMT时间 不会加八*/
-(nullable NSDate *)cqDateByAddingMonths:(NSInteger)months{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}
/**调用的时间基本都是GMT时间 不会加八*/
-(nullable NSDate *)cqDateByAddingWeeks:(NSInteger)weeks{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}
/**调用的时间基本都是GMT时间 不会加八*/
-(nullable NSDate *)cqDateByAddingDays:(NSInteger)days{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}
/**调用的时间基本都是GMT时间 不会加八*/
- (nullable NSDate *)cqDateByAddingHours:(NSInteger)hours{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:hours];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}
/**调用的时间基本都是GMT时间 不会加八*/
- (nullable NSDate *)cqDateByAddingMinutes:(NSInteger)minutes{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMinute:minutes];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}
/**调用的时间基本都是GMT时间 不会加八*/
- (nullable NSDate *)cqDateByAddingSeconds:(NSInteger)seconds{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setSecond:seconds];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

#pragma mark - 格式转换
+(NSDate *)cqCSTDate{
    
    NSDate *anyDate = [NSDate date];
    return [self cqConvertGMTDateToCSTDate:anyDate];
}
/**单纯的少八个小时而已*/
-(NSDate *)cqCSTDateToGMTDate{
    
    return [self cqDateByAddingHours:-8];
}
/**单纯加八个小时*/
-(NSDate *)cqGMTDateToCSTDate{
    return [self cqDateByAddingHours:8];
}

/**比String显示的少八个小时 -8 */
+(NSDate *)cqGetGMTDateFromCSTString:(NSString *)CSTString Type:(CQDateFormatType)type{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[self cqFormatStringWithType:type]];
    NSDate *gmtDate = [formatter dateFromString:CSTString];
    return gmtDate;
}

/**比String显示的加八个小时 +8 */
+(NSDate *)cqGetCSTDateFromGMTString:(NSString *)CSTString Type:(CQDateFormatType)type{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
    [formatter setDateFormat:[self cqFormatStringWithType:type]];
    NSDate *gmtDate = [formatter dateFromString:CSTString];
    [gmtDate cqDateByAddingHours:8];
    return gmtDate;
}

/**
    其实默认 传入的String 都是GMTString
    然后要转成什么时间主要看自己设置时区
 */
+(NSDate *)cqGetAnyDateFromGMTString:(NSString *)GMTString Type:(CQDateFormatType)type{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.timeZone = [[NSTimeZone alloc]initWithName:@"CCT"];
    [formatter setDateFormat:[self cqFormatStringWithType:type]];
    NSDate *cstDate = [formatter dateFromString:GMTString];
    return cstDate;
}

/**时间不变  gmtString ==> gmtDate 一样  +0 */
+(NSDate *)cqGetCSTDateFromCSTString:(NSString *)CSTString Type:(CQDateFormatType)type{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
    [formatter setDateFormat:[self cqFormatStringWithType:type]];
    NSDate *cstDate = [formatter dateFromString:CSTString];
    return cstDate;
}

+(NSDate *)cqConvertGMTDateToCSTDate:(NSDate *)GMTDate{
    
    if (GMTDate == nil) {
        return nil;
    }
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:GMTDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:GMTDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* CSTDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:GMTDate] ;
    return CSTDate;
}

+(NSString *)cqNowCSTDateToStringWithType:(CQDateFormatType)type{
    
    NSDate *date = [NSDate date];
    return [date cqToCSTDateStringWithFormat:type];
}


/**调用的时间都是默认是 GMT时间，具体认为自己看着办 加 +8 */
-(NSString *)cqToCSTDateStringWithFormat:(CQDateFormatType)type{
    //会多八个小时
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:[NSDate cqFormatStringWithType:type]];
    NSString *cstString = [formater stringFromDate:self];
    return cstString;
}

/**调用的时间都是默认是 GMT时间，不加，+0 */
-(NSString *)cqToGMTDateStringWithFormat:(CQDateFormatType)type{
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
    [formater setDateFormat:[NSDate cqFormatStringWithType:type]];
    NSString *gmtString = [formater stringFromDate:self];
    return gmtString;
}

/**一种时间字符串转换成另一种  +0 */
-(NSString *)cqConvertDateString:(NSString *)originStr Type:(CQDateFormatType)originType ToDestinationType:(CQDateFormatType)destinationType{
    NSDate *date = [NSDate cqGetCSTDateFromCSTString:originStr Type:originType];
    return [date cqToGMTDateStringWithFormat:destinationType];
}

/**根据年月日时分秒创建时间，多的会进位，少的就借位*/
+(NSDate *)cqCreateDateByYear:(NSUInteger)year
                        Month:(NSUInteger)month
                          Day:(NSUInteger)day
                         Hour:(NSUInteger)hour
                          Min:(NSUInteger)min
                       Second:(NSUInteger)sec{
    
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    [comps setHour:hour];
    [comps setMinute:min];
    [comps setSecond:sec];
    [comps setTimeZone: [NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *referenceTime = [cal dateFromComponents:comps];
    return referenceTime;
}

#pragma mark - 间隔、比较
/**两个时间间隔 秒 S 永远是正数*/
+(NSTimeInterval)cqIntervalByDate:(NSDate *)date AndDate:(NSDate *)anotherDate{
    
    NSTimeInterval time1 = date.timeIntervalSince1970;
    NSTimeInterval time2 = anotherDate.timeIntervalSince1970;
    if (time1 >= time2) {
        return time1 - time2;
    }
    return time2 - time1;
}
/**两个时间间隔 秒 S 永远是正数*/
+(NSTimeInterval)cqIntervalByDateString:(NSString *)dateString AndDateString:(NSString *)anotherDateString Type:(CQDateFormatType)type{
    
    NSTimeInterval time1 = [self cqGetCSTDateFromCSTString:dateString Type:type].timeIntervalSince1970;
    NSTimeInterval time2 = [self cqGetCSTDateFromCSTString:anotherDateString Type:type].timeIntervalSince1970;
    if (time1 >= time2) {
        return time1 - time2;
    }
    return time2 - time1;
}

/** NSOrderedDescending dateA(未来) > dateB(过去) */
+(NSComparisonResult)cqCompareDate:(NSDate *)dateA AndDate:(NSDate *)dateB{
    return [dateA compare:dateB];
}
/** NSOrderedDescending dateA(未来) > dateB(过去) */
+(NSComparisonResult)cqCompareDateString:(NSString *)dateStrA AndDateString:(NSString *)dateStrB Type:(CQDateFormatType)type{
    
    NSDate *date = [NSDate cqGetCSTDateFromCSTString:dateStrA Type:type];
    NSDate *date2 = [NSDate cqGetCSTDateFromCSTString:dateStrB Type:type];
    return [date compare:date2];
}
/**是否同一天 Yes是  No否*/
+(BOOL)cqIsSameDay:(NSDate *)date1 date2:(NSDate *)date2{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

/**闯入秒数 获得 x时x分x秒 */
+(NSString *)cqIntervalStringByInterval:(NSTimeInterval)interval{
    
    long long intervalSec = (long long)fabs(interval);
    long day = intervalSec/(24*60*60);
    long hour = (intervalSec%(24*60*60))/(60*60);
    long min = (intervalSec%(60*60))/60;
    long sec = intervalSec%60;
    
    NSMutableString *mstr = [NSMutableString string];
    if (day > 0) {
        [mstr appendFormat:@"%ld天",day];
    }
    if (day > 0 || hour > 0) {
        [mstr appendFormat:@"%ld时",hour];
    }
    if (day > 0 || hour > 0 || min > 0) {
        [mstr appendFormat:@"%ld分",min];
    }
    [mstr appendFormat:@"%ld秒",sec];
    
    return [mstr copy];
}


/**根据类型获得对应的字符串*/
+(NSString *)cqFormatStringWithType:(CQDateFormatType)type{
    
    NSString *tmpString = nil;
    switch (type) {
        case CQDateFromatType1:
            tmpString = @"yyyy-MM-dd HH:mm:ss";
            break;
        case CQDateFromatType2:
            tmpString = @"yyyyMMddHHmmss";
            break;
        case CQDateFromatType3:
            tmpString = @"yyyy.MM.dd";
            break;
        case CQDateFromatType4:
            tmpString = @"yyyy-MM-dd";
            break;
        case CQDateFromatType5:
            tmpString = @"yyyy_MM_dd_HH_mm_ss";
            break;
        case CQDateFromatType6:
            tmpString = @"yyyy/MM/dd";
            break;
        case CQDateFromatType7:
            tmpString = @"yyyy-MM-dd HH:mm";
            break;
        case CQDateFromatType8:
            tmpString = @"MM-dd HH:mm";
            break;
        case CQDateFromatType9:
            tmpString = @"yyyyMMdd000000";
            break;
        default:
            break;
    }
    return tmpString;
}


@end
