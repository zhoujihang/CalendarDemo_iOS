//
//  NSDateComponents+Extension.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/8.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "NSDateComponents+CalendarRemindExtension.h"
#import "NSDate+CalendarRemindExtension.h"
@implementation NSDateComponents (CalendarRemindExtension)

- (NSDate *)cre_localDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *date = [calendar dateFromComponents:self];
    return date;
}

- (NSInteger)cre_dayNumberOfCurrentMonth{
    NSDateComponents *lastDayOfCurrentMonth = [self cre_currentMonthLastDayDateComponents];
    NSInteger dayNumber = lastDayOfCurrentMonth.day;
    return dayNumber;
}
- (NSDateComponents *)cre_currentMonthFirstDayDateComponents{
    NSDateComponents *dateCpt = [self copy];
    dateCpt.day = 1;
    [dateCpt cre_updateWeekDayAndWeekOfMonthAfterChangeDayValue];
    return dateCpt;
}
- (NSDateComponents *)cre_currentMonthLastDayDateComponents{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *firstDayOfRightMonth = [self cre_rightMonthFirstDayDateComponents];
    NSDate *date = [calendar dateFromComponents:firstDayOfRightMonth];
    NSInteger daySeconds = 24*60*60;
    NSDate *targetDate = [date dateByAddingTimeInterval:-daySeconds];
    NSDateComponents *targetDateCpt = [targetDate cre_dateCompontentsYMDHMSWW];
    return targetDateCpt;
}
- (NSDateComponents *)cre_leftMonthFirstDayDateComponents{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *cpt = [self copy];
    cpt.day = 1;
    NSDate *date = [calendar dateFromComponents:cpt];
    NSInteger daySeconds = 24*60*60;
    NSDate *dateBefore15Day = [date dateByAddingTimeInterval:-15*daySeconds];
    NSDateComponents *targetDateComponents = [dateBefore15Day cre_dateCompontentsYMDHMSWW];
    targetDateComponents.day = 1;
    [targetDateComponents cre_updateWeekDayAndWeekOfMonthAfterChangeDayValue];
    return targetDateComponents;
}
// 获取指定 dateComponents 的下一个月的第一天 的日期模型
- (NSDateComponents *)cre_rightMonthFirstDayDateComponents{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *cpt = [self copy];
    cpt.day = 1;
    NSDate *date = [calendar dateFromComponents:cpt];
    NSInteger daySeconds = 24*60*60;
    NSDate *dateAfter45Day = [date dateByAddingTimeInterval:45*daySeconds];
    NSDateComponents *targetDateComponents = [dateAfter45Day cre_dateCompontentsYMDHMSWW];
    targetDateComponents.day = 1;
    [targetDateComponents cre_updateWeekDayAndWeekOfMonthAfterChangeDayValue];
    return targetDateComponents;
}
- (void)cre_updateWeekDayAndWeekOfMonthAfterChangeDayValue{
    NSDateComponents *newDateCpt = [[self cre_localDate] cre_dateCompontentsYMDHMSWW];
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
- (NSComparisonResult)cre_compareToDateComponentsYM:(NSDateComponents *)dateComponents{
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
- (NSComparisonResult)cre_compareToDateComponentsYMD:(NSDateComponents *)dateComponents{
    NSComparisonResult result = [self cre_compareToDateComponentsYM:dateComponents];
    
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

