//
//  CalendarContentWeekView.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/9.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBCalendarWeekView.h"
#import "BBCalendarDayView.h"
@class BBCalendarContentWeekView;
@protocol BBCalendarContentWeekViewDelegate <NSObject>

// 点击了具体的某个日期
- (void)calendarContentWeekView:(BBCalendarContentWeekView *)contentView didClickWithDateComponents:(NSDateComponents *)dateComponents;

@end

@interface BBCalendarContentWeekView : UIView

@property (nonatomic, weak) id<BBCalendarContentWeekViewDelegate> m_Delegate;
// 当前选中状态的日期,默认为今天
@property (nonatomic, strong, readonly) NSDateComponents *m_SelectedDateComponent;

- (void)jumpToToday;
- (void)refreshWithSelectedDateComponents:(NSDateComponents *)dateComponents;
@end
