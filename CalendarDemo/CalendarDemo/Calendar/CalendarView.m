//
//  CalendarView.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/9/29.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "CalendarView.h"
#import "CalendarWeekNameView.h"
#import "CalendarContentMonthView.h"
#import "CalendarContentWeekView.h"
#import <Masonry/Masonry.h>
#import "NSDate+Extension.h"
#import "NSDateComponents+Extension.h"
@interface CalendarView ()<CalendarContentMonthViewDelegate, CalendarContentWeekViewDelegate>
// 控件
@property (nonatomic, weak) CalendarWeekNameView *s_WeekNameView;
@property (nonatomic, weak) CalendarContentMonthView *s_CalendarContentMonthView;
@property (nonatomic, weak) CalendarContentWeekView *s_CalendarContentWeekView;
@property (nonatomic, strong, readwrite) NSDateComponents *m_CurrentDateComponents;

// 约束
@property (nonatomic, strong) MASConstraint *s_WeekNameViewTopConstraint;
@property (nonatomic, strong) MASConstraint *s_WeekViewTopConstraint;


@end

@implementation CalendarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)dealloc{

}
- (void)setup{
    [self setupViews];
    [self setupConstraints];
}
// 创建视图控件
- (void)setupViews{
    self.backgroundColor = [UIColor whiteColor];
    
    CalendarContentMonthView *monthView = [[CalendarContentMonthView alloc] init];
    monthView.m_Delegate = self;
    [self addSubview:monthView];
    self.s_CalendarContentMonthView = monthView;
    
    CalendarContentWeekView *weekView = [[CalendarContentWeekView alloc] init];
    weekView.m_Delegate = self;
    weekView.hidden = YES;
    [self addSubview:weekView];
    self.s_CalendarContentWeekView = weekView;
    
    CalendarWeekNameView *nameView = [[CalendarWeekNameView alloc] init];
    [self addSubview:nameView];
    self.s_WeekNameView = nameView;
}
// 设置控件约束关系
- (void)setupConstraints{
    [self.s_WeekNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        self.s_WeekNameViewTopConstraint = make.top.equalTo(self);
    }];
    CGFloat weekNameViewHeight = [self.s_WeekNameView intrinsicContentSize].height;
    
    [self.s_CalendarContentMonthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(weekNameViewHeight);
        make.left.right.bottom.equalTo(self);
    }];
    [self.s_CalendarContentWeekView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        self.s_WeekViewTopConstraint = make.top.equalTo(self).offset(weekNameViewHeight);
    }];
}

- (CGSize)intrinsicContentSize{
    CGFloat height = 0;
    
    height += [self.s_WeekNameView intrinsicContentSize].height;
    height += [self.s_CalendarContentMonthView intrinsicContentSize].height;
    height = ceilf(height);
    return CGSizeMake(-1, height);
}
// 修改顶部weeknameview的位置
- (void)setM_WeekNameViewTopOffset:(CGFloat)m_WeekNameViewTopOffset{
    _m_WeekNameViewTopOffset = m_WeekNameViewTopOffset;
    CGFloat weekNameViewHeight = [self.s_WeekNameView intrinsicContentSize].height;
    CGFloat calendarViewHeight = [self intrinsicContentSize].height;
    CGFloat calendarViewMinHeight = weekNameViewHeight + kCalendarDayViewMinHeight;
    
    // 修改星期视图的位置
    CGFloat nameViewNewTopOffset = m_WeekNameViewTopOffset >= 0 ? m_WeekNameViewTopOffset : 0;
    nameViewNewTopOffset = nameViewNewTopOffset <= calendarViewHeight-calendarViewMinHeight ? nameViewNewTopOffset : calendarViewHeight-calendarViewMinHeight;
    self.s_WeekNameViewTopConstraint.offset = nameViewNewTopOffset;
    
    // 修改隐藏的周历视图的位置
    NSDateComponents *selectedDateCpt = [self.m_CurrentDateComponents copy];
//    CLog(@"------ year:%ld  month:%ld  day:%ld  hour:%ld  min:%ld  second:%ld  weekday:%ld  weekOfMonth:%ld",  self.m_CurrentDateComponents.year,  self.m_CurrentDateComponents.month,  self.m_CurrentDateComponents.day,  self.m_CurrentDateComponents.hour,  self.m_CurrentDateComponents.minute,  self.m_CurrentDateComponents.second,  self.m_CurrentDateComponents.weekday,  self.m_CurrentDateComponents.weekOfMonth);
//    CLog(@">>>>>> year:%ld  month:%ld  day:%ld  hour:%ld  min:%ld  second:%ld  weekday:%ld  weekOfMonth:%ld", selectedDateCpt.year, selectedDateCpt.month, selectedDateCpt.day, selectedDateCpt.hour, selectedDateCpt.minute, selectedDateCpt.second, selectedDateCpt.weekday, selectedDateCpt.weekOfMonth);
    NSDateComponents *lastDayOfMonthDateComponents = [selectedDateCpt ext_currentMonthLastDayDateComponents];
    NSInteger rowNumber = lastDayOfMonthDateComponents.weekOfMonth;
    CGFloat rowHeight = kCalendarDayViewMinHeight*6.0/rowNumber;
    
    self.s_CalendarContentWeekView.hidden = YES;
    if (selectedDateCpt) {
        NSInteger selectedRow = selectedDateCpt.weekOfMonth - 1;
        
        CGFloat weekViewLimitShowTopOffset = selectedRow * rowHeight + weekNameViewHeight;
        CGFloat weekViewTopOffset = nameViewNewTopOffset + weekNameViewHeight;
        
        if (weekViewTopOffset > weekViewLimitShowTopOffset) {
            self.s_WeekViewTopConstraint.offset = weekViewTopOffset;
            self.s_CalendarContentWeekView.hidden = NO;
        }
    }
    
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}
- (CGFloat)m_MinHeight{
    CGFloat minHeight = 0;
    minHeight += [self.s_WeekNameView intrinsicContentSize].height;
    minHeight += kCalendarDayViewMinHeight;
    
    return minHeight;
}
- (NSDateComponents *)m_SelectedDateComponents{
    return self.s_CalendarContentMonthView.m_SelectedDateComponent;
}
- (void)jumpToToday{
    [self.s_CalendarContentMonthView jumpToToday];
}
- (void)scrollToLeftMonth{
    [self.s_CalendarContentMonthView scrollToLeftMonth];
}
- (void)scrollToRightMonth{
    [self.s_CalendarContentMonthView scrollToRightMonth];
}


#pragma mark - CalendarContentMonthView 代理
- (void)calendarContentMonthView:(CalendarContentMonthView *)contentView didClickWithDateComponents:(NSDateComponents *)dateComponents{
    [self calendarDidClickDateComponents:dateComponents];
}
#pragma mark - CalendarContentWeekView 代理
- (void)calendarContentWeekView:(CalendarContentWeekView *)contentView didClickWithDateComponents:(NSDateComponents *)dateComponents{
    [self calendarDidClickDateComponents:dateComponents];
}

#pragma mark -
- (void)calendarDidClickDateComponents:(NSDateComponents *)dateComponents{
    self.m_CurrentDateComponents = [dateComponents copy];
    
    // 修改month视图
    NSDateComponents *monthViewCurrentMonthDateCpt = self.s_CalendarContentMonthView.m_SelectedDateComponent;
    if (!monthViewCurrentMonthDateCpt || [monthViewCurrentMonthDateCpt ext_compareToDateComponentsYMD:dateComponents] != NSOrderedSame) {
        // 选中了不同日期,需要更新月视图
        NSComparisonResult result = [self.m_CurrentDateComponents ext_compareToDateComponentsYM:monthViewCurrentMonthDateCpt];
        if (result == NSOrderedAscending) {
            // 点击左边月份
            [self.s_CalendarContentMonthView scrollToLeftMonthWithSelectedDateComponents:dateComponents];
        }else if(result == NSOrderedDescending){
            // 点击右边月份
            [self.s_CalendarContentMonthView scrollToRightMonthWithSelectedDateComponents:dateComponents];
        }else{
            // 点击当前月份
            [self.s_CalendarContentMonthView refreshWithSelectedDateComponents:dateComponents];
        }
    }
    // 修改week视图
    NSDateComponents *weekViewCurrentMonthDateCpt = self.s_CalendarContentWeekView.m_SelectedDateComponent;
    if (!weekViewCurrentMonthDateCpt || [weekViewCurrentMonthDateCpt ext_compareToDateComponentsYMD:dateComponents] != NSOrderedSame) {
        // 选中了不同日期,需要更新周视图
        [self.s_CalendarContentWeekView refreshWithSelectedDateComponents:dateComponents];
    }
    
    if ([self.m_Delegate respondsToSelector:@selector(calendarView:didClickWithDateComponents:)]) {
        [self.m_Delegate calendarView:self didClickWithDateComponents:[self.m_CurrentDateComponents copy]];
    }
}

@end
