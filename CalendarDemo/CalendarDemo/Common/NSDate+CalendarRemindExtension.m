//
//  NSDate+Extension.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/8.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "NSDate+CalendarRemindExtension.h"

@implementation NSDate (CalendarRemindExtension)

- (NSDateComponents *)cre_dateCompontentsYMDHMSWW{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorianCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:self];
    return dateComponents;
}


- (NSDate *)cre_firstDateInCurrentMonth{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *firstDateCpt = [self cre_dateCompontentsYMDHMSWW];
    firstDateCpt.day = 1;
    NSDate *firstDate = [gregorianCalendar dateFromComponents:firstDateCpt];
    return firstDate;
}
- (NSDate *)cre_limitDateInCurrentMonth{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *limitDateCpt = [self cre_dateCompontentsYMDHMSWW];
    NSInteger month = limitDateCpt.month;
    NSInteger year = limitDateCpt.year;
    if (month==12) {
        month = 1;
        year += 1;
    }else{
        month += 1;
    }
    limitDateCpt.year = year;
    limitDateCpt.month = month;
    limitDateCpt.day = 1;
    NSDate *limitDate = [gregorianCalendar dateFromComponents:limitDateCpt];
    NSInteger daySeconds = 24*60*60;
    limitDate = [limitDate dateByAddingTimeInterval:-1*daySeconds];
    return limitDate;
}

- (NSDateComponents *)cre_chineseDateComponents{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *dateCpt = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:self];
    return dateCpt;
}
- (NSInteger)cre_chineseYear{
    return [self cre_chineseDateComponents].year;
}
- (NSInteger)cre_chineseMonth{
    return [self cre_chineseDateComponents].month;
}
- (NSInteger)cre_chineseDay{
    return [self cre_chineseDateComponents].day;
}
- (NSString *)cre_chineseYearString{
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSInteger year = [self cre_chineseYear];
    NSString *yearString = [chineseYears objectAtIndex:year-1];
    return yearString;
}
- (NSString *)cre_chineseMonthString{
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    NSInteger month = [self cre_chineseMonth];
    NSString *monthString = [chineseMonths objectAtIndex:month-1];
    return monthString;
}
- (NSString *)cre_chineseDayString{
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    NSInteger day = [self cre_chineseDay];
    NSString *dayString = [chineseDays objectAtIndex:day-1];
    return dayString;
}



@end
