//
//  NSDateComponents+Extension.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/8.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateComponents (Extension)

- (NSDate *)ext_localDate;

// 本月包含多少天
- (NSInteger)ext_dayNumberOfCurrentMonth;

// dateComponents 本月第一天 的日期模型
- (NSDateComponents *)ext_currentMonthFirstDayDateComponents;
// dateComponents 本月最后一天 的日期模型
- (NSDateComponents *)ext_currentMonthLastDayDateComponents;
// dateComponents 的上一个月的第一天 的日期模型
- (NSDateComponents *)ext_leftMonthFirstDayDateComponents;
// dateComponents 的下一个月的第一天 的日期模型
- (NSDateComponents *)ext_rightMonthFirstDayDateComponents;
// 每次修改day值之后需要再次调用此方法保证 weekDay、weekOfMonth 值的正确
- (void)ext_updateWeekDayAndWeekOfMonthAfterChangeDayValue;

/**
 比较两个 NSDateComponents 之间，年、月 的大小，不考虑日。

 @param dateComponents 被比较的 dateComponents

 @return 比较结果，如 2000-10-01 和 2000-01-01 比较，返回 NSOrderedDescending
 */
- (NSComparisonResult)ext_compareToDateComponentsYM:(NSDateComponents *)dateComponents;
/**
 比较两个 NSDateComponents 之间，年、月、日 的大小。
 
 @param dateComponents 被比较的 dateComponents
 
 @return 比较结果，如 2000-10-01 和 2000-01-01 比较，返回 NSOrderedDescending
 */
- (NSComparisonResult)ext_compareToDateComponentsYMD:(NSDateComponents *)dateComponents;

@end
