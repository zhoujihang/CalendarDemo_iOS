//
//  CalendarTool.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/13.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBCalendarTool.h"
#import "solarterm.h"
#import "NSDateComponents+CalendarRemindExtension.h"
#import "NSDate+CalendarRemindExtension.h"

static NSString *const kChineseHolidayYuanDan = @"元旦";
static NSString *const kChineseHolidayChunJie = @"春节";
static NSString *const kChineseHolidayQingMing = @"清明节";
static NSString *const kChineseHolidayLaoDong = @"劳动节";
static NSString *const kChineseHolidayDuanWu = @"端午节";
static NSString *const kChineseHolidayZhongQiu = @"中秋节";
static NSString *const kChineseHolidayGuoQing = @"国庆节";

@implementation BBCalendarTool

+ (NSString *)chineseHolidayNameOfGregorianDateComponents:(NSDateComponents *)dateComponents{
    NSString *holiday = nil;
    
    NSDate *date = [dateComponents cre_localDate];
    NSInteger month = dateComponents.month;
    NSInteger day = dateComponents.day;
    NSInteger lunarMonth = [date cre_chineseMonth];
    NSInteger lunarDay = [date cre_chineseDay];
    
    NSString *solarTerm = [self solarTermOfGregorianDateComponents:dateComponents];
    if ([solarTerm isEqualToString:@"清明"]) {
        // 清明
        holiday = kChineseHolidayQingMing;
        return holiday;
    }
    if (month == 1 && day == 1) {
        // 元旦
        holiday = kChineseHolidayYuanDan;
    }else if(lunarMonth == 1 && lunarDay == 1){
        // 春节
        holiday = kChineseHolidayChunJie;
    }else if (month == 5 && day == 1){
        // 劳动
        holiday = kChineseHolidayLaoDong;
    }else if (lunarMonth == 5 && lunarDay == 5){
        // 端午
        holiday = kChineseHolidayDuanWu;
    }else if (lunarMonth == 8 && lunarDay == 15){
        // 中秋
        holiday = kChineseHolidayZhongQiu;
    }else if (month == 10 && day == 1){
        // 国庆
        holiday = kChineseHolidayGuoQing;
    }else{
        holiday = nil;
    }
    return holiday;
}


// 传入日期，获得24节气
+ (NSString *)solarTermOfGregorianDateComponents:(NSDateComponents *)dateComponents{
    NSString *solarTermString = nil;
    int solar = solarterm_index((int)dateComponents.year, (int)dateComponents.month, (int)dateComponents.day);
    if (solar >= 0 && solar < 24) {
        const char *solarChar = solarterm_name(solar);
        solarTermString = [NSString stringWithCString:solarChar encoding:NSUTF8StringEncoding];
    }
    return solarTermString;
}

+ (BOOL)isValidatedDateComponents:(NSDateComponents *)dateComponents{
    NSInteger year = dateComponents.year;
    if (year<1970) {return NO;}
    if (year>2070) {return NO;}
    
    return YES;
}

@end
