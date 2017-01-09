//
//  NSDate+CQDate.m
//  CQUtils
//
//  Created by runo on 16/5/17.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import "NSDate+CQDate.h"



#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat"

@implementation NSDate (CQDate)

#pragma mark - Component Properties
-(NSInteger)cqYear{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

-(NSInteger)cqMonth{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

-(NSInteger)cqDay{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}
/**比Date中的小时少八个小时,不要少的可以用cqHourFormDate*/
-(NSInteger)cqHour{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

-(NSInteger)cqMinute{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

-(NSInteger)cqSecond{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

-(NSInteger)cqNanosecond{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

-(NSInteger)cqWeekday{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

-(NSInteger)cqWeekdayOrdinal{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

-(NSInteger)cqWeekOfMonth{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

-(NSInteger)cqWeekOfYear{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

-(NSInteger)cqYearForWeekOfYear{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

-(NSInteger)cqQuarter{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

-(BOOL)cqIsLeapMonth{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

-(BOOL)cqIsToday{
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate new].cqDay == self.cqDay;
}
#if 0
-(BOOL)cqIsYesterday{
    NSDate *added = [self dateByAddingDays:1];
    return [added cqIsToday];
}

-(BOOL)cqIsBeforeYesterday{
    NSDate *added = [self dateByAddingDays:2];
    return [added cqIsToday];
}
#endif
-(BOOL)cqIsToyear{
    return self.cqYear == [NSDate cqNowDate].cqYear;
}

-(BOOL)cqIsLeapYear{
    NSUInteger year = self.cqYear;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

#pragma mark - Date modify
-(nullable NSDate *)cqDateByAddingYears:(NSInteger)years{
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}
-(nullable NSDate *)cqDateByAddingMonths:(NSInteger)months{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}
-(nullable NSDate *)cqDateByAddingWeeks:(NSInteger)weeks{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}
-(nullable NSDate *)cqDateByAddingDays:(NSInteger)days{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
- (nullable NSDate *)cqDateByAddingHours:(NSInteger)hours{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
- (nullable NSDate *)cqDateByAddingMinutes:(NSInteger)minutes{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
- (nullable NSDate *)cqDateByAddingSeconds:(NSInteger)seconds{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

/**yyyy-MM-dd HH:mm:ss*/
-(NSString *)cqToString{
    
    return  [self cqToStringWithFormatString:CQDateFromatType1];
}

-(NSString *)cqToStringWithFormatString:(CQDateFromatType)formatString{
    
    NSDateFormatter * formater=[[NSDateFormatter alloc] init];
    [formater setDateStyle:NSDateFormatterShortStyle];
    [formater setTimeStyle:NSDateFormatterNoStyle];
    
    [formater setDateFormat:[NSDate cqFormatStringWithType:CQDateFromatType1]];
    NSString *str2 = [formater stringFromDate:self];
    
    [formater setDateFormat:[NSDate cqFormatStringWithType:formatString]];
    
    //NSTimeZone *localTimeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [formater setTimeZone:localTimeZone];
    NSString *str = [formater stringFromDate:self];
    
    NSDate *date2 = [NSDate cqGetDateString:str2 FormatType:CQDateFromatType1];
    if ([self isEqualToDate:date2]) {
        NSLog(@"一致");
    }else{
        date2 = [date2 dateByAddingTimeInterval:-16*60*60];
        str = [formater stringFromDate:date2];
    }
    //NSLog(@"%@  %@",self,str);
    
    return str;
}

/**yyyy-MM-dd HH:mm:ss*/
+(NSString *)cqNowString{
    NSDate *date = [NSDate cqNowDate];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return [date cqToString];
}

+(NSDate *)cqNowDate{
    return [NSDate cqGetNowDateFromatAnDate:[NSDate date]];
}

+(NSString *)cqNowDateToStringWithFormatString:(CQDateFromatType)formatString{
    NSDate *date = [NSDate cqGetNowDateFromatAnDate:[NSDate date]];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    return [date cqToStringWithFormatString:formatString];
}

+(NSDate *)cqGetDateFromString:(NSString *)string{
    
    return [NSDate cqGetDateString:string FormatType:CQDateFromatType1];
    
}

+(NSDate *)cqGetDateString:(NSString *)dateString FormatType:(CQDateFromatType)format {
    
    NSDateFormatter * formater=[[NSDateFormatter alloc] init];
    formater.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formater setDateFormat:[NSDate cqFormatStringWithType:format]];
    NSDate *gmtDate = [formater dateFromString:dateString];
    return gmtDate;//[NSDate cqGetNowDateFromatAnDate:gmtDate];
    
}

+(NSString *)cqConvertTypeStringToAnotherTypeString:(NSString *)dataTypeString OrignType:(CQDateFromatType)orgType DestinationType:(CQDateFromatType)desType{
    
    NSDate *date = [self cqGetDateString:dataTypeString FormatType:orgType];
//    date = [date dateByAddingTimeInterval:-60*60*8];
    return [date cqToStringWithFormatString:desType];
}

-(NSTimeInterval)cqTimeIntervalSinceNow{
    
    return [[NSDate cqGetNowDateFromatAnDate:[NSDate date]] timeIntervalSinceDate:self];
    
}

/**anyDate + 8小时*/
+ (NSDate *)cqGetNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate] ;
    return destinationDateNow;
}

+(NSString *)cqGetHisvideoTime:(NSString *)fileName{
    
    NSString * sub=[fileName substringWithRange:NSMakeRange(8, 15)];
    sub=[sub stringByReplacingOccurrencesOfString:@"_" withString:@""];
    NSDate *date = [NSDate cqGetDateString:sub FormatType:CQDateFromatType2];
    return [date cqToString];
    
    
}

+(NSString *)cqGetDateWithTimeIntervalSince1970:(NSTimeInterval)time Type:(CQDateFromatType)type{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:[NSDate cqFormatStringWithType:type]];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
    
}

+(NSTimeInterval )cqCaculateBeforTime:(NSString *)btime AfterTime:(NSString *)afterTime Type:(CQDateFromatType)type{
    
    NSDate *btimeDate = [NSDate cqGetDateString:btime FormatType:type];
                         //cqGetDateWithFormatString:type DateString:btime];
    NSDate *afterDate = [NSDate cqGetDateString:afterTime FormatType:type];
                         //cqGetDateWithFormatString:type DateString:afterTime];
    NSTimeInterval time = afterDate.timeIntervalSince1970 - btimeDate.timeIntervalSince1970;
    
    return time;
}
+(NSTimeInterval)cqCaculateDateBeforTime:(NSDate *)btime AfterTime:(NSDate *)afterTime{
    NSTimeInterval time = afterTime.timeIntervalSince1970 - btime.timeIntervalSince1970;
    return time;
}

+(NSString *)cqIntervalString:(NSTimeInterval)interval{
    
    NSMutableString *intervalStr = [NSMutableString stringWithString:@""];
    if (interval < 0) {
        return @"时间已到";
    }
    
    long sec = (long)interval;
    long day = sec/(3600*24);
    long hour = (sec-day*(3600*24))/(60*60);
    long min = (sec - hour*(60*60) - day*(3600*24))/60;
    
//    long month = sec/(3600*24*30);
//    long year = sec/(3600*24*365);

//    if (year > 0) {
//        [intervalStr appendFormat:@"%ld年",year];
//    }else if (month > 0) {
//        [intervalStr appendFormat:@"%ld月",month];
//    }else
    if (day > 0) {
        [intervalStr appendFormat:@"%ld天",day];
    }
    if (hour > 0) {
        [intervalStr appendFormat:@"%ld小时",hour];
    }
    if (min > 0) {
        [intervalStr appendFormat:@"%ld分钟",min];
    }
    if (sec < 60) {
        [intervalStr appendFormat:@"%ld秒",sec];
    }

    return intervalStr;
}
/**计算时间与当前时间的间隔 一共有 xx秒/时/分前 昨天 前天 月-日 时：分  年月日时分*/
-(NSString *)dateIntervalWithNow{
    
    NSString *tail = nil;
    NSDate *nowDate = [NSDate cqNowDate];
    NSComparisonResult cmpResult = [self compare:nowDate];
    if ([self compare:nowDate] == NSOrderedAscending) {
        tail = @"前";
    }else if([self compare:nowDate] == NSOrderedDescending){
        tail = @"后";
    }else{
        return @"现在";//几乎不可能
    }
    /**没写今天明天,但是以后的时间都会走到 type8里面*/
    NSTimeInterval interval = 0;
    if (cmpResult == NSOrderedAscending) {
        interval = [NSDate cqCaculateDateBeforTime:self AfterTime:nowDate];
    }else{
        interval = [NSDate cqCaculateDateBeforTime:nowDate AfterTime:self];
    }
    if (interval<60*60*24) {
        NSString *str = [NSString stringWithFormat:@"%@%@",[NSDate cqIntervalString:interval],tail];
        return str;
    //}else if ([self cqIsYesterday]){
    //    return @"昨天";
    //}else if ([self cqIsBeforeYesterday]){
    //    return @"前天";
    }else if (![self cqIsToyear]){
        return [self cqToStringWithFormatString:CQDateFromatType7];
    }else{
        return [self cqToStringWithFormatString:CQDateFromatType8];
    }
    return nil;
}

+(NSString *)cqHMSStringWithInterval:(NSTimeInterval)interval{
    
    NSUInteger time = (NSUInteger)interval;
    NSInteger hour = time/3600;
    NSInteger minute = (time/60)%60;
    NSInteger second = time%60;
    return [NSString stringWithFormat:@"%02i:%02i:%02i",hour,minute,second];
}

/**
 *  根据类型获得对应的字符串
 *
 *  @param type 格式类型
 *
 *  @return 对应类型的字符串
 */
+(NSString *)cqFormatStringWithType:(CQDateFromatType)type{
    
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

+(NSComparisonResult)cqCompareDateString:(NSString *)date1 AndDateString:(NSString *)date2 DateType:(CQDateFromatType)type{
    
    NSDate *dateA = [self cqGetDateString:date1 FormatType:type];
    NSDate *dateB = [self cqGetDateString:date2 FormatType:type];
    return [dateA compare:dateB];
    
}

+(BOOL)cqIsSameDay:(NSDate *)date1 date2:(NSDate *)date2{
    
        NSCalendar* calendar = [NSCalendar currentCalendar];
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
        NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
        NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
        
        return [comp1 day]   == [comp2 day] &&
        [comp1 month] == [comp2 month] &&
        [comp1 year]  == [comp2 year];

}
#pragma mark - 获取date中的年月日
-(NSUInteger)cqYearFromDate{
    return [self cqSubDateFromDate:NSCalendarUnitYear];
}
-(NSUInteger)cqMonthFromDate{
    return [self cqSubDateFromDate:NSCalendarUnitMonth];
}
-(NSUInteger)cqDayFromDate{
    return [self cqSubDateFromDate:NSCalendarUnitDay];
}
-(NSInteger)cqHourFormDate{
    return [self cqSubDateFromDate:NSCalendarUnitHour];
}
-(NSInteger)cqMinFormDate{
    return [self cqSubDateFromDate:NSCalendarUnitMinute];
}

-(NSInteger)cqSubDateFromDate:(NSCalendarUnit)flage{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateComponents* comp1 = [calendar components:flage fromDate:self];
    switch (flage) {
        case NSCalendarUnitMinute:return [comp1 minute];break;
        case NSCalendarUnitHour:return [comp1 hour];break;
        case NSCalendarUnitDay:return [comp1 day];break;
        case NSCalendarUnitMonth:return [comp1 month];break;
        case NSCalendarUnitYear:return [comp1 year];break;
        default:
            break;
    }
    return 0;
}

#pragma mark - 根据指定时间创建时间对象
/**原样获取时分秒不变*/
+(NSDate *)cqCreateDateYear:(NSUInteger)year Month:(NSUInteger)month Day:(NSUInteger)day Hour:(NSUInteger)hour Min:(NSUInteger)min Second:(NSUInteger)sec{
#if 1
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    [comps setHour:hour];
    [comps setMinute:min];
//    [comps setTimeZone:[NSTimeZone localTimeZone]];
    [comps setTimeZone: [NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *referenceTime = [cal dateFromComponents:comps];
    return referenceTime;
#else
    NSString *string = [NSString stringWithFormat:@"%u-%u-%u %u:%u:%u",year,month,day,hour,min,sec];
    return [NSDate cqGetDateFromString:string];
#endif
}

@end

#pragma clang diagnostic pop
