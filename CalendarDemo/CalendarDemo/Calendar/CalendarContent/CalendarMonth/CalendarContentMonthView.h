//
//  CalendarContentMonthView.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/8.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarMonthView.h"
#import "CalendarDayView.h"
@class CalendarContentMonthView;
@protocol CalendarContentMonthViewDelegate <NSObject>
// 点击了具体的某个日期
- (void)calendarContentMonthView:(CalendarContentMonthView *)contentView didClickWithDateComponents:(NSDateComponents *)dateComponents;
@end

@interface CalendarContentMonthView : UIView

@property (nonatomic, weak) id<CalendarContentMonthViewDelegate> m_Delegate;

// 当前选中状态的日期，YMD有效
@property (nonatomic, strong, readonly) NSDateComponents *m_SelectedDateComponent;

- (void)jumpToToday;
- (void)scrollToLeftMonth;
- (void)scrollToLeftMonthWithSelectedDateComponents:(NSDateComponents *)dateComponents;
- (void)scrollToRightMonth;
- (void)scrollToRightMonthWithSelectedDateComponents:(NSDateComponents *)dateComponents;

- (void)refreshWithSelectedDateComponents:(NSDateComponents *)dateComponents;
@end
