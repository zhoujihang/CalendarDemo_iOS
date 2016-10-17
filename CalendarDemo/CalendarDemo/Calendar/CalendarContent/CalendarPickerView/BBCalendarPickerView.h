//
//  BBCalendarPickerView.h
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/14.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBCalendarPickerView;
@protocol BBCalendarPickerViewDelegate <NSObject>

- (void)calendarPickerView:(BBCalendarPickerView *)pickerView didSelectYear:(NSInteger)year month:(NSInteger)month;

@end

@interface BBCalendarPickerView : UIView

@property (nonatomic, weak) id<BBCalendarPickerViewDelegate> m_Delegate;

@property (nonatomic, assign, readonly) NSInteger m_SelectedYear;
@property (nonatomic, assign, readonly) NSInteger m_SelectedMonth;

- (void)jumpToSelectedYear:(NSInteger)year month:(NSInteger)month;

@end
