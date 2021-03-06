//
//  CalendarView.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/9/29.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBCalendarView;
@protocol BBCalendarViewDelegate <NSObject>
// 点击了某个日期
- (void)calendarView:(BBCalendarView *)view didClickWithDateComponents:(NSDateComponents *)dateComponents;

@end

@interface BBCalendarView : UIView

@property (nonatomic, weak) id<BBCalendarViewDelegate> m_Delegate;

@property (nonatomic, assign) CGFloat m_WeekNameViewTopOffset;

/// 视图能显示的最小高度
@property (nonatomic, assign, readonly) CGFloat m_MinHeight;
@property (nonatomic, strong, readonly) NSDateComponents *m_CurrentDateComponents;

- (void)jumpToToday;
- (void)jumpToYear:(NSInteger)year month:(NSInteger)month;
- (void)scrollToLeftMonth;
- (void)scrollToRightMonth;
@end
