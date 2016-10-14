//
//  CalendarDayView.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/8.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBCalendarDayViewModel.h"

FOUNDATION_EXTERN CGFloat const kCalendarDayViewMinHeight;

@class BBCalendarDayView;
@protocol BBCalendarDayViewDelegate <NSObject>

- (void)calendarDayViewDidClick:(BBCalendarDayView *)view;

@end

@interface BBCalendarDayView : UIView

@property (nonatomic, weak) id<BBCalendarDayViewDelegate> m_Delegate;
@property (nonatomic, strong) BBCalendarDayViewModel *m_Model;

@end
