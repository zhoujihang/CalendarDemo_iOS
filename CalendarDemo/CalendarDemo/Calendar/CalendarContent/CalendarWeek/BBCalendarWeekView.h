//
//  CalendarWeekView.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/9.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBCalendarDayView.h"

@class BBCalendarWeekView;
@protocol BBCalendarWeekViewDelegate <NSObject>

- (void)calendarWeekView:(BBCalendarWeekView *)weekView didClickWithDateComponent:(NSDateComponents *)dateComponent;

@end

@interface BBCalendarWeekView : UIView

@property (nonatomic, weak) id<BBCalendarWeekViewDelegate> m_Delegate;

/// 传入需要显示的日期模型,个数必须为7
@property (nonatomic, strong) NSArray<BBCalendarDayViewModel *> *m_DayViewModelArray;


@end
