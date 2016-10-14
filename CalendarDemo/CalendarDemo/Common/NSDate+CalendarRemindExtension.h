//
//  NSDate+Extension.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/8.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CalendarRemindExtension)

- (NSDateComponents *)cre_dateCompontentsYMDHMSWW;

// 当前日期所在月份的第一天
- (NSDate *)cre_firstDateInCurrentMonth;
// 当前日期所在月份的最后一天
- (NSDate *)cre_limitDateInCurrentMonth;

#pragma mark - 农历日期
- (NSDateComponents *)cre_chineseDateComponents;
- (NSInteger)cre_chineseYear;
- (NSInteger)cre_chineseMonth;
- (NSInteger)cre_chineseDay;
- (NSString *)cre_chineseYearString;
- (NSString *)cre_chineseMonthString;
- (NSString *)cre_chineseDayString;


@end
