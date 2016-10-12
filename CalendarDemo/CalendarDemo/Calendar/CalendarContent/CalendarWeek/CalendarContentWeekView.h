//
//  CalendarContentWeekView.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/9.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarWeekView.h"
#import "CalendarDayView.h"
@class CalendarContentWeekView;
@protocol CalendarContentWeekViewDelegate <NSObject>

// 点击了具体的某个日期
- (void)calendarContentWeekView:(CalendarContentWeekView *)contentView didClickWithDateComponents:(NSDateComponents *)dateComponents;

@end

@interface CalendarContentWeekView : UIView

@property (nonatomic, weak) id<CalendarContentWeekViewDelegate> m_Delegate;
// 当前选中状态的日期,默认为今天
@property (nonatomic, strong, readonly) NSDateComponents *m_SelectedDateComponent;

- (void)jumpToToday;
- (void)refreshWithSelectedDateComponents:(NSDateComponents *)dateComponents;
@end
