//
//  solarterm.h
//  ChineseCalendar
//
//  Created by Tony Li on 6/4/12.
//  Copyright (c) 2012 Tony Li. All rights reserved.
//

/**
 @see https://github.com/autopear/LunarCalendar
 使用 c 文件，需要在pch中间中加入 #ifdef __OBJC__     #endif 的宏判断
 */

#ifndef ChineseCalendar_solarterm_h
#define ChineseCalendar_solarterm_h

// 传入 NSCalendarIdentifierGregorian 类型的日期如：2016-10-01 对应的年月日
int solarterm_index(int year, int month, int day);

const char *solarterm_name(const int index);

#endif
