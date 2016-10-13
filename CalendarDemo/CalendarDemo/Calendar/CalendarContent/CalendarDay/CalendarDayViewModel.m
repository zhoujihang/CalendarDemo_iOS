//
//  CalendarDayViewModel.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/8.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "CalendarDayViewModel.h"
#import "NSDate+Extension.h"
#import "NSDateComponents+Extension.h"
#import "CalendarTool.h"

@interface CalendarDayViewModel ()

@property (nonatomic, strong, readwrite) NSDateComponents *m_DateComponents;

@end

@implementation CalendarDayViewModel

+ (instancetype)modelFromDateComponents:(NSDateComponents *)dateComponents withSelectedDateComponents:(NSDateComponents *)selectedDateComponents currentMonthDateComponents:(NSDateComponents *)currentMonthDateComponents{
    
    BOOL isCurrentMonth = currentMonthDateComponents.year == dateComponents.year && currentMonthDateComponents.month == dateComponents.month;;
    return [self modelFromDateComponents:dateComponents withSelectedDateComponents:selectedDateComponents isCurrentMonth:isCurrentMonth];
}
+ (instancetype)modelFromDateComponents:(NSDateComponents *)dateComponents withSelectedDateComponents:(NSDateComponents *)selectedDateComponents{
    return [self modelFromDateComponents:dateComponents withSelectedDateComponents:selectedDateComponents isCurrentMonth:YES];
}

+ (instancetype)modelFromDateComponents:(NSDateComponents *)dateComponents withSelectedDateComponents:(NSDateComponents *)selectedDateComponents isCurrentMonth:(BOOL )isCurrentMonth{
    CalendarDayViewModel *model = [[CalendarDayViewModel alloc] init];
    model.m_DateComponents = dateComponents;
    model.m_BackCircleColor = [self backCircleColorWithDateComponents:dateComponents selectedDateComponents:selectedDateComponents isCurrentMonth:isCurrentMonth];
    model.m_NumberString = [self numberStringWithDateComponents:dateComponents isCurrentMonth:isCurrentMonth];
    model.m_NumberColor = [self numberColorWithDateComponents:dateComponents selectedDateComponents:selectedDateComponents isCurrentMonth:isCurrentMonth];
    model.m_LunarString = [self lunarStringWithDateComponents:dateComponents];
    model.m_LunarColor = [self lunarColorWithDateComponents:dateComponents isCurrentMonth:isCurrentMonth];
    model.m_DotsColorArray = [self dotsColorArrayWithDateComponents:dateComponents];
    return model;
}
#pragma mark - 分别计算各个属性
// 得到日期背景色
+ (UIColor *)backCircleColorWithDateComponents:(NSDateComponents *)dateCpt selectedDateComponents:(NSDateComponents *)selectedDateCpt isCurrentMonth:(BOOL)isCurrentMonth{
    if ([dateCpt ext_compareToDateComponentsYMD:selectedDateCpt] == NSOrderedSame && isCurrentMonth) {
        // 被选中
        return [UIColor redColor];
    }else{
        return nil;
    }
}
// 得到日期数字
+ (NSString *)numberStringWithDateComponents:(NSDateComponents *)dateCpt isCurrentMonth:(BOOL)isCurrentMonth{
    NSString *numberString = [NSString stringWithFormat:@"%ld", dateCpt.day];
    
    NSDateComponents *todayDateCpt = [[NSDate date] ext_dateCompontentsYMDHMSWW];
    if ([todayDateCpt ext_compareToDateComponentsYMD:dateCpt] == NSOrderedSame && isCurrentMonth) {
        // 今天
        numberString = @"今";
    }
    
    return numberString;
}
// 得到日期数字颜色
+ (UIColor *)numberColorWithDateComponents:(NSDateComponents *)dateCpt selectedDateComponents:(NSDateComponents *)selectedDateCpt isCurrentMonth:(BOOL)isCurrentMonth{
    UIColor *color = nil;
    
    if ([dateCpt ext_compareToDateComponentsYMD:selectedDateCpt] == NSOrderedSame) {
        // 被选中
        color = [UIColor whiteColor];
    }else{
        color = [UIColor blackColor];
    }
    
    if (!isCurrentMonth) {
        color = [UIColor lightGrayColor];
    }
    return color;
}
// 日期农历或节日名
+ (NSString *)lunarStringWithDateComponents:(NSDateComponents *)dateCpt{
    NSString *lunarString = [[dateCpt ext_localDate] ext_chineseDayString];
    NSString *chineseHoliday = [CalendarTool chineseHolidayNameOfGregorianDateComponents:dateCpt];
    lunarString = chineseHoliday.length>0 ? chineseHoliday : lunarString;
    return lunarString;
}
// 日期农历名的颜色
+ (UIColor *)lunarColorWithDateComponents:(NSDateComponents *)dateCpt isCurrentMonth:(BOOL)isCurrentMonth{
    UIColor *color = [UIColor blackColor];
    NSString *chineseHoliday = [CalendarTool chineseHolidayNameOfGregorianDateComponents:dateCpt];
    if (chineseHoliday.length>0) {
        color = [UIColor blueColor];
    }
    color = isCurrentMonth ? color : [UIColor lightGrayColor];
    return color;
}
// 日期下是否有红点
+ (NSArray<UIColor *> *)dotsColorArrayWithDateComponents:(NSDateComponents *)dateCpt{
    __block NSArray *dotsArray = nil;
    NSDictionary *dotsColorArrayDic = [self dotsColorArrayDic];
    [dotsColorArrayDic enumerateKeysAndObjectsUsingBlock:^(NSDateComponents *key, NSArray<UIColor *> *obj, BOOL *stop) {
        if ([dateCpt ext_compareToDateComponentsYMD:key] == NSOrderedSame) {
            dotsArray = obj;
            *stop = YES;
        }
    }];
    return dotsArray;
}

#pragma mark - 需要被标记有提醒的日期数据
+ (NSDictionary<NSDateComponents *, NSArray<UIColor *> *> *)dotsColorArrayDic{
    NSDate *today = [NSDate date];
    NSMutableDictionary *mdic = [@{} mutableCopy];
    NSInteger daySeconds = 24*60*60;
    NSArray *colorArray = @[[UIColor redColor],[UIColor blueColor],[UIColor grayColor],[UIColor yellowColor],[UIColor greenColor],[UIColor brownColor]];
    for (int i=0; i<colorArray.count; i++) {
        NSDate *date = [today dateByAddingTimeInterval:daySeconds*i];
        NSDateComponents *dateCpt = [date ext_dateCompontentsYMDHMSWW];
        NSArray *colorSubArray = [colorArray subarrayWithRange:NSMakeRange(0, i+1)];
        [mdic setObject:colorSubArray forKey:dateCpt];
    }
    return [mdic copy];
}



@end
