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

@interface CalendarDayViewModel ()

@property (nonatomic, strong, readwrite) NSDateComponents *m_DateComponents;

@end

@implementation CalendarDayViewModel


+ (instancetype)modelFromDateComponents:(NSDateComponents *)dateComponents comparedToCurrentMonthDateComponents:(NSDateComponents *)currentMonthDateComponents withSelectedDateComponents:(NSDateComponents *)selectedDateComponents{
    
    CalendarDayViewModel *model = [self modelFromDateComponents:dateComponents withSelectedDateComponents:selectedDateComponents];
    
    BOOL isCurrentMonth = currentMonthDateComponents.year == dateComponents.year && currentMonthDateComponents.month == dateComponents.month;
    
    // 是否被选中
    if ([dateComponents ext_compareToDateComponentsYMD:selectedDateComponents] == NSOrderedSame && isCurrentMonth) {
        // 被选中
        model.m_BackCircleColor = [UIColor redColor];
        model.m_LunarColor = [UIColor blackColor];
        model.m_NumberColor = [UIColor whiteColor];
    }else{
        model.m_BackCircleColor = nil;
        // 是否当月
        if (isCurrentMonth) {
            model.m_NumberColor = [UIColor blackColor];
            model.m_LunarColor = [UIColor blackColor];
        }else{
            model.m_NumberColor = [UIColor lightGrayColor];
            model.m_LunarColor = [UIColor lightGrayColor];
        }
    }
    
    return model;
}

+ (instancetype)modelFromDateComponents:(NSDateComponents *)dateComponents withSelectedDateComponents:(NSDateComponents *)selectedDateComponents{
    CalendarDayViewModel *model = [[CalendarDayViewModel alloc] init];
    model.m_DateComponents = dateComponents;
    
    // 是否今日
    NSDateComponents *todayCpt = [[NSDate date] ext_dateCompontentsYMDHMSWW];
    if ([dateComponents ext_compareToDateComponentsYMD:todayCpt] == NSOrderedSame) {
        // 今天
        model.m_NumberString = @"今";
    }else{
        model.m_NumberString = [NSString stringWithFormat:@"%ld", dateComponents.day];
    }
    
    model.m_NumberColor = [UIColor blackColor];
    model.m_LunarColor = [UIColor blackColor];
    
    // 是否被选中
    if ([dateComponents ext_compareToDateComponentsYMD:selectedDateComponents] == NSOrderedSame) {
        // 被选中
        model.m_BackCircleColor = [UIColor redColor];
        model.m_NumberColor = [UIColor whiteColor];
    }
    
    // 获得农历日期
    NSString *chineseDay = [[dateComponents ext_localDate] ext_chineseDay];
    model.m_LunarString = chineseDay;
    
    // 设置底部点点视图，后6天每天都有点点
    NSDictionary *dotsColorArrayDic = [self dotsColorArrayDic];
    [dotsColorArrayDic enumerateKeysAndObjectsUsingBlock:^(NSDateComponents *key, NSArray<UIColor *> *obj, BOOL *stop) {
        if ([dateComponents ext_compareToDateComponentsYMD:key] == NSOrderedSame) {
            model.m_DotsColorArray = obj;
            *stop = YES;
        }
    }];
    
    return model;
}




+ (NSDictionary<NSDateComponents *, NSArray<UIColor *> *> *)dotsColorArrayDic{
    static NSDictionary *_dotsColorArrayDic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
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
        _dotsColorArrayDic = [mdic copy];
    });
    return _dotsColorArrayDic;
}



@end
