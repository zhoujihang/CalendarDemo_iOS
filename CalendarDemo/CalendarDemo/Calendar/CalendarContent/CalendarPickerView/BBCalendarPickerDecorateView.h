//
//  BBCalendarPickerDecorateView.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/14.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBCalendarPickerDecorateView;
@protocol BBCalendarPickerDecorateViewDelegate <NSObject>

- (void)calendarPickerDecorateViewDidClickSelectBtn:(BBCalendarPickerDecorateView *)view;
- (void)calendarPickerDecorateViewDidClickCloseBtn:(BBCalendarPickerDecorateView *)view;

@end

@interface BBCalendarPickerDecorateView : UIView

@property (nonatomic, weak) id<BBCalendarPickerDecorateViewDelegate> m_Delegate;

@end
