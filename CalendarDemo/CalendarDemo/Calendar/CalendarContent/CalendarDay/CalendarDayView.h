//
//  CalendarDayView.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/8.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarDayViewModel.h"

FOUNDATION_EXTERN CGFloat const kCalendarDayViewMinHeight;

@class CalendarDayView;
@protocol CalendarDayViewDelegate <NSObject>

- (void)calendarDayViewDidClick:(CalendarDayView *)view;

@end

@interface CalendarDayView : UIView

@property (nonatomic, weak) id<CalendarDayViewDelegate> m_Delegate;
@property (nonatomic, strong) CalendarDayViewModel *m_Model;

@end
