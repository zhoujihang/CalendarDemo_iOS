//
//  CalendarNavBarTitleView.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/10.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarNavBarTitleView;
@protocol CalendarNavBarTitleViewDelegate <NSObject>

- (void)calendarNavBarTitleViewDidClickTitle:(CalendarNavBarTitleView *)titleView;
- (void)calendarNavBarTitleViewDidClickLeftBtn:(CalendarNavBarTitleView *)titleView;
- (void)calendarNavBarTitleViewDidClickRightBtn:(CalendarNavBarTitleView *)titleView;

@end

@interface CalendarNavBarTitleView : UIView

@property (nonatomic, weak) id<CalendarNavBarTitleViewDelegate> m_Delegate;

@property (nonatomic, copy) NSString *m_TitleString;

@end
