//
//  CalendarMonthView.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/8.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarDayViewModel.h"
#import "CalendarDayView.h"

@class CalendarMonthView;
@protocol CalendarMonthViewDelegate <NSObject>

- (void)calendarMonthView:(CalendarMonthView *)monthView didClickWithDateComponent:(NSDateComponents *)dateComponent;

@end

@interface CalendarMonthView : UIView

@property (nonatomic, weak) id<CalendarMonthViewDelegate> m_Delegate;

/// 传入需要显示的日期模型,需要为7的倍数
@property (nonatomic, strong) NSArray<CalendarDayViewModel *> *m_DayViewModelArray;

@end
