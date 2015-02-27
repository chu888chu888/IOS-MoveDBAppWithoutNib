//
//  NSString+Base.m
//  noodleBlue
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 noodles. All rights reserved.
//

#import "NSString+Base.h"

@implementation NSString (Base)

//将日期转换成距离现在得时间
+ (NSString *)getDayFormatWith:(NSString *)inputTime {
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *beforeYesterday, *yesterday, *tomorrow, *afterTomorrow;
    
    beforeYesterday = [today dateByAddingTimeInterval: -2*secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    tomorrow = [today dateByAddingTimeInterval: +secondsPerDay];
    afterTomorrow = [today dateByAddingTimeInterval: +2*secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * beforeYesterdayString = [[beforeYesterday description] substringToIndex:10];
    NSString * tomorrowSting = [[tomorrow description] substringToIndex:10];
    NSString * afterTomorrowSting = [[afterTomorrow description] substringToIndex:10];
    
    NSString * dateString = [[inputTime description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:beforeYesterdayString])
    {
        return @"前天";
    }else if ([dateString isEqualToString:tomorrowSting])
    {
        return @"明天";
    }else if ([dateString isEqualToString:afterTomorrowSting])
    {
        return @"后天";
    }else
    {
        return @"";
    }
}

//获取星期
+ (NSString*)getWeekFormatWith:(NSString*)inputDateString {
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate* inputDate = [inputFormatter dateFromString:inputDateString];
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

//获取pm,am格式的时间
+ (NSString*)getTimeFormatWith:(NSString*)inputTimeString {
    if (inputTimeString==nil) {
        return @"";
    }
    
    NSString *timeString = [[[inputTimeString description] substringFromIndex:11] substringToIndex:5];
    NSString *minuteString = [timeString substringFromIndex:2] ;
    NSInteger hour = [[timeString substringToIndex:2] integerValue];
    NSString *hourSting;
    if (hour>12) {
        hourSting = [@(hour-12) stringValue];
    }else{
        hourSting = [@(hour) stringValue];
    }
    NSString *fomatTime;
    if (hour>=12) {
        fomatTime = [[hourSting stringByAppendingString:minuteString] stringByAppendingString:@" pm"];
    }else{
        fomatTime = [[hourSting stringByAppendingString:minuteString] stringByAppendingString:@" am"];
    }

    return fomatTime;
}

//判断是否为电话号码
- (BOOL)isPhoneString{
    NSString *regex = @"\\d{11}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

//判断是否为手机验证码
- (BOOL)isCodeString{
    NSString *regex = @"\\d{4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

//判断是否为邮箱
- (BOOL)isEmailString{
    NSString *regex = @"^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+([a-zA-Z0-9]{2,4})+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}


@end
