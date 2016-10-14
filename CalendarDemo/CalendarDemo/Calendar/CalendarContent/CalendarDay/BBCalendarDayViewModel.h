//
//  CalendarDayViewModel.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/8.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface BBCalendarDayViewModel : NSObject

/// 圈圈颜色
@property (nonatomic, strong) UIColor *m_BackCircleColor;
/// 数字颜色
@property (nonatomic, strong) UIColor *m_NumberColor;
/// 农历颜色
@property (nonatomic, strong) UIColor *m_LunarColor;

/// 数字内容
@property (nonatomic, copy) NSString *m_NumberString;
/// 农历内容
@property (nonatomic, copy) NSString *m_LunarString;
/// 底部点点视图的颜色
@property (nonatomic, strong) NSArray *m_DotsColorArray;


@property (nonatomic, strong, readonly) NSDateComponents *m_DateComponents;


/**
 日期模型转月视图模型

 @param dateComponents             需要转换的日期模型
 @param selectedDateComponents     转为模型时需要显示为"选中"状态的日期
 @param currentMonthDateComponents 当前日历显示的月份，year、month为有效值

 @return CalendarDayView的模型视图
 */
+ (instancetype)modelFromDateComponents:(NSDateComponents *)dateComponents withSelectedDateComponents:(NSDateComponents *)selectedDateComponents currentMonthDateComponents:(NSDateComponents *)currentMonthDateComponents;

/**
 日期模型转周视图模型

 @param dateComponents         需要转换的日期模型
 @param selectedDateComponents 转为模型时需要显示为"选中"状态的日期

 @return CalendarDayView的模型视图
 */
+ (instancetype)modelFromDateComponents:(NSDateComponents *)dateComponents withSelectedDateComponents:(NSDateComponents *)selectedDateComponents;


@end
