//
//  CalendarTool.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/13.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarTool : NSObject

// 传入日期，返回中国7个法定节假日名称，未找到则为nil
+ (NSString *)chineseHolidayNameOfGregorianDateComponents:(NSDateComponents *)dateComponents;


@end
