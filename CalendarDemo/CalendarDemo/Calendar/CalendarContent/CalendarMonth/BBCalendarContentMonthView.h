//
//  CalendarContentMonthView.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/8.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBCalendarMonthView.h"
#import "BBCalendarDayView.h"
@class BBCalendarContentMonthView;
@protocol BBCalendarContentMonthViewDelegate <NSObject>
// 点击了具体的某个日期
- (void)calendarContentMonthView:(BBCalendarContentMonthView *)contentView didClickWithDateComponents:(NSDateComponents *)dateComponents;
@end

@interface BBCalendarContentMonthView : UIView

@property (nonatomic, weak) id<BBCalendarContentMonthViewDelegate> m_Delegate;

// 当前选中状态的日期，YMD有效
@property (nonatomic, strong, readonly) NSDateComponents *m_SelectedDateComponent;

- (void)jumpToToday;
- (void)scrollToLeftMonth;
- (void)scrollToLeftMonthWithSelectedDateComponents:(NSDateComponents *)dateComponents;
- (void)scrollToRightMonth;
- (void)scrollToRightMonthWithSelectedDateComponents:(NSDateComponents *)dateComponents;

- (void)refreshWithSelectedDateComponents:(NSDateComponents *)dateComponents;
@end
