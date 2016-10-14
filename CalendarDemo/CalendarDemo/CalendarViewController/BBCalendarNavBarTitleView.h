//
//  CalendarNavBarTitleView.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/10.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBCalendarNavBarTitleView;
@protocol BBCalendarNavBarTitleViewDelegate <NSObject>

- (void)calendarNavBarTitleViewDidClickTitle:(BBCalendarNavBarTitleView *)titleView;
- (void)calendarNavBarTitleViewDidClickLeftBtn:(BBCalendarNavBarTitleView *)titleView;
- (void)calendarNavBarTitleViewDidClickRightBtn:(BBCalendarNavBarTitleView *)titleView;

@end

@interface BBCalendarNavBarTitleView : UIView

@property (nonatomic, weak) id<BBCalendarNavBarTitleViewDelegate> m_Delegate;

@property (nonatomic, copy) NSString *m_TitleString;

@end
