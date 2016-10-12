//
//  NSDateComponents+Extension.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/8.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "NSDateComponents+Extension.h"
#import "NSDate+Extension.h"
@implementation NSDateComponents (Extension)

- (NSDate *)ext_localDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *date = [calendar dateFromComponents:self];
    return date;
}

- (NSInteger)ext_dayNumberOfCurrentMonth{
    NSDateComponents *lastDayOfCurrentMonth = [self ext_currentMonthLastDayDateComponents];
    NSInteger dayNumber = lastDayOfCurrentMonth.day;
    return dayNumber;
}
- (NSDateComponents *)ext_currentMonthFirstDayDateComponents{
    NSDateComponents *dateCpt = [self copy];
    dateCpt.day = 1;
    [dateCpt ext_updateWeekDayAndWeekOfMonthAfterChangeDayValue];
    return dateCpt;
}
- (NSDateComponents *)ext_currentMonthLastDayDateComponents{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *firstDayOfRightMonth = [self ext_rightMonthFirstDayDateComponents];
    NSDate *date = [calendar dateFromComponents:firstDayOfRightMonth];
    NSInteger daySeconds = 24*60*60;
    NSDate *targetDate = [date dateByAddingTimeInterval:-daySeconds];
    NSDateComponents *targetDateCpt = [targetDate ext_dateCompontentsYMDHMSWW];
    return targetDateCpt;
}
- (NSDateComponents *)ext_leftMonthFirstDayDateComponents{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *cpt = [self copy];
    cpt.day = 1;
    NSDate *date = [calendar dateFromComponents:cpt];
    NSInteger daySeconds = 24*60*60;
    NSDate *dateBefore15Day = [date dateByAddingTimeInterval:-15*daySeconds];
    NSDateComponents *targetDateComponents = [dateBefore15Day ext_dateCompontentsYMDHMSWW];
    targetDateComponents.day = 1;
    [targetDateComponents ext_updateWeekDayAndWeekOfMonthAfterChangeDayValue];
    return targetDateComponents;
}
// 获取指定 dateComponents 的下一个月的第一天 的日期模型
- (NSDateComponents *)ext_rightMonthFirstDayDateComponents{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *cpt = [self copy];
    cpt.day = 1;
    NSDate *date = [calendar dateFromComponents:cpt];
    NSInteger daySeconds = 24*60*60;
    NSDate *dateAfter45Day = [date dateByAddingTimeInterval:45*daySeconds];
    NSDateComponents *targetDateComponents = [dateAfter45Day ext_dateCompontentsYMDHMSWW];
    targetDateComponents.day = 1;
    [targetDateComponents ext_updateWeekDayAndWeekOfMonthAfterChangeDayValue];
    return targetDateComponents;
}
- (void)ext_updateWeekDayAndWeekOfMonthAfterChangeDayValue{
    NSDateComponents *newDateCpt = [[self ext_localDate] ext_dateCompontentsYMDHMSWW];
    self.year = newDateCpt.year;
    self.month = newDateCpt.month;
    self.day = newDateCpt.day;
    self.hour = newDateCpt.hour;
    self.minute = newDateCpt.minute;
    self.second = newDateCpt.second;
    self.weekday = newDateCpt.weekday;
    self.weekOfMonth = newDateCpt.weekOfMonth;
}
- (void)ext_regenerateDateComponentsAfterChangeDayValue{
}
- (NSComparisonResult)ext_compareToDateComponentsYM:(NSDateComponents *)dateComponents{
    NSInteger year = self.year;
    NSInteger month = self.month;
    
    NSInteger otherYear = dateComponents.year;
    NSInteger otherMonth = dateComponents.month;
    
    NSComparisonResult result = NSOrderedSame;
    if (year > otherYear) {
        result = NSOrderedDescending;
    }else if (year < otherYear) {
        result = NSOrderedAscending;
    }else{
        if (month > otherMonth) {
            result = NSOrderedDescending;
        }else if(month < otherMonth){
            result = NSOrderedAscending;
        }else{
            result = NSOrderedSame;
        }
    }
    return result;
}
- (NSComparisonResult)ext_compareToDateComponentsYMD:(NSDateComponents *)dateComponents{
    NSComparisonResult result = [self ext_compareToDateComponentsYM:dateComponents];
    
    if (result == NSOrderedSame) {
        NSInteger day = self.day;
        NSInteger otherDay = dateComponents.day;
        if (day > otherDay) {
            result = NSOrderedDescending;
        }else if (day < otherDay){
            result = NSOrderedAscending;
        }else{
            result = NSOrderedSame;
        }
    }
    return result;
}

@end

