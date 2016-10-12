//
//  CalendarNavBarView.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/10.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarNavBarView;
@protocol CalendarNavBarViewDelegate <NSObject>

- (void)calendarNavBarViewDidClickBackBtn:(CalendarNavBarView *)view;
- (void)calendarNavBarViewDidClickTodayBtn:(CalendarNavBarView *)view;
- (void)calendarNavBarViewDidClickRightBtn:(CalendarNavBarView *)view;
- (void)calendarNavBarViewDidClickTitle:(CalendarNavBarView *)titleView;
- (void)calendarNavBarViewDidClickTitleLeftBtn:(CalendarNavBarView *)titleView;
- (void)calendarNavBarViewDidClickTitleRightBtn:(CalendarNavBarView *)titleView;
@end

@interface CalendarNavBarView : UIView

@property (nonatomic, weak) id<CalendarNavBarViewDelegate> m_Delegate;

@property (nonatomic, copy) NSString *m_TitleString;

@end
