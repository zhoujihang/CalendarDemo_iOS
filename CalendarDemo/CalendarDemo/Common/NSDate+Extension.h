//
//  NSDate+Extension.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/8.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

- (NSDateComponents *)ext_dateCompontentsYMDHMSWW;

// 当前日期所在月份的第一天
- (NSDate *)ext_firstDateInCurrentMonth;
// 当前日期所在月份的最后一天
- (NSDate *)ext_limitDateInCurrentMonth;

#pragma mark - 农历字符串
- (NSString *)ext_chineseYear;
- (NSString *)ext_chineseMonth;
- (NSString *)ext_chineseDay;


@end
