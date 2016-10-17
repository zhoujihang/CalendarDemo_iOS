//
//  CalendarTool.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/13.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBCalendarTool : NSObject

// 传入日期，返回中国7个法定节假日名称，未找到则为nil
+ (NSString *)chineseHolidayNameOfGregorianDateComponents:(NSDateComponents *)dateComponents;

// dateComponents是否在 [197001, 207012]范围内
+ (BOOL)isValidatedDateComponents:(NSDateComponents *)dateComponents;

@end
