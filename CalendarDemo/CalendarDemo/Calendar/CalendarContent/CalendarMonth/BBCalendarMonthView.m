//
//  CalendarMonthView.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/8.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBCalendarMonthView.h"
#import "BBCalendarDayView.h"

@interface BBCalendarMonthView ()<BBCalendarDayViewDelegate>

@property (nonatomic, strong) NSArray *s_AllDayViewArray;
@property (nonatomic, strong) NSArray *s_EyeableDayViewArray;

@end

@implementation BBCalendarMonthView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    [self setupViews];
}
- (void)setupViews{
    self.backgroundColor = [UIColor whiteColor];
    
    // 一个月份上最多显示42个
    NSMutableArray *marr = [@[] mutableCopy];
    for (int i=0; i<7*6; i++) {
        BBCalendarDayView *dayView = [[BBCalendarDayView alloc] init];
        dayView.hidden = YES;
        dayView.m_Delegate = self;
        [self addSubview:dayView];
        [marr addObject:dayView];
    }
    self.s_AllDayViewArray = [marr copy];
}
- (void)setM_DayViewModelArray:(NSArray<BBCalendarDayViewModel *> *)m_DayViewModelArray{
    _m_DayViewModelArray = [m_DayViewModelArray copy];
    
    [self setupEyeableDayViewArray];
    [self setupPosition];
}
- (void)setupEyeableDayViewArray{
    NSMutableArray *eyeableViewMArr = [@[] mutableCopy];
    for (int i=0; i<self.s_AllDayViewArray.count; i++) {
        BBCalendarDayView *dayView = self.s_AllDayViewArray[i];
        if (i<self.m_DayViewModelArray.count) {
            // 显示的视图
            dayView.hidden = NO;
            dayView.m_Model = self.m_DayViewModelArray[i];
            [eyeableViewMArr addObject:dayView];
        }else{
            // 隐藏的视图
            dayView.hidden = YES;
        }
    }
    self.s_EyeableDayViewArray = [eyeableViewMArr copy];
}
- (void)setupPosition{
    NSInteger maxColumn = 7;
    NSInteger maxRow = self.s_EyeableDayViewArray.count/7;
    CGFloat width = [UIScreen mainScreen].bounds.size.width/maxColumn;
    CGFloat height = [self intrinsicContentSize].height/maxRow;
    
    for (int i=0; i<self.s_EyeableDayViewArray.count; i++) {
        BBCalendarDayView *dayView = self.s_EyeableDayViewArray[i];
        NSInteger row = i/maxColumn;
        NSInteger column = i%maxColumn;
        CGFloat x = ceilf(column*width);
        CGFloat y = ceilf(row*height);
        dayView.frame = CGRectMake(x, y, ceilf(width), ceilf(height));
    }
}
- (CGSize)intrinsicContentSize{
    CGFloat height = kCalendarDayViewMinHeight*6;
    return CGSizeMake(-1, height);
}
- (void)calendarDayViewDidClick:(BBCalendarDayView *)view{
    if ([self.m_Delegate respondsToSelector:@selector(calendarMonthView:didClickWithDateComponent:)]) {
        [self.m_Delegate calendarMonthView:self didClickWithDateComponent:[view.m_Model.m_DateComponents copy]];
    }
}

@end
