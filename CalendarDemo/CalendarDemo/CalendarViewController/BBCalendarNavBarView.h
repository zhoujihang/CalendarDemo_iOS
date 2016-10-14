//
//  CalendarNavBarView.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/10.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBCalendarNavBarView;
@protocol BBCalendarNavBarViewDelegate <NSObject>

- (void)calendarNavBarViewDidClickBackBtn:(BBCalendarNavBarView *)view;
- (void)calendarNavBarViewDidClickTodayBtn:(BBCalendarNavBarView *)view;
- (void)calendarNavBarViewDidClickRightBtn:(BBCalendarNavBarView *)view;
- (void)calendarNavBarViewDidClickTitle:(BBCalendarNavBarView *)titleView;
- (void)calendarNavBarViewDidClickTitleLeftBtn:(BBCalendarNavBarView *)titleView;
- (void)calendarNavBarViewDidClickTitleRightBtn:(BBCalendarNavBarView *)titleView;
@end

@interface BBCalendarNavBarView : UIView

@property (nonatomic, weak) id<BBCalendarNavBarViewDelegate> m_Delegate;

@property (nonatomic, copy) NSString *m_TitleString;

@end
