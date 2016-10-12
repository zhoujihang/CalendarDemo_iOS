//
//  CalendarWeekView.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/9.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarDayView.h"

@class CalendarWeekView;
@protocol CalendarWeekViewDelegate <NSObject>

- (void)calendarWeekView:(CalendarWeekView *)weekView didClickWithDateComponent:(NSDateComponents *)dateComponent;

@end

@interface CalendarWeekView : UIView

@property (nonatomic, weak) id<CalendarWeekViewDelegate> m_Delegate;

/// 传入需要显示的日期模型,个数必须为7
@property (nonatomic, strong) NSArray<CalendarDayViewModel *> *m_DayViewModelArray;


@end
