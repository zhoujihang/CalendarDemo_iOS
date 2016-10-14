//
//  CalendarMonthView.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/8.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBCalendarDayViewModel.h"
#import "BBCalendarDayView.h"

@class BBCalendarMonthView;
@protocol BBCalendarMonthViewDelegate <NSObject>

- (void)calendarMonthView:(BBCalendarMonthView *)monthView didClickWithDateComponent:(NSDateComponents *)dateComponent;

@end

@interface BBCalendarMonthView : UIView

@property (nonatomic, weak) id<BBCalendarMonthViewDelegate> m_Delegate;

/// 传入需要显示的日期模型,需要为7的倍数
@property (nonatomic, strong) NSArray<BBCalendarDayViewModel *> *m_DayViewModelArray;

@end
