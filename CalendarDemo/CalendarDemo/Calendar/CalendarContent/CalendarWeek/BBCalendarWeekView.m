//
//  CalendarWeekView.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/9.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBCalendarWeekView.h"

@interface BBCalendarWeekView ()<BBCalendarDayViewDelegate>

@property (nonatomic, strong) NSArray *s_DayViewArray;

@end

@implementation BBCalendarWeekView


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
    
    NSMutableArray *marr = [@[] mutableCopy];
    NSInteger maxColumn = 7;
    CGFloat width = [UIScreen mainScreen].bounds.size.width/maxColumn;
    CGFloat height = [self intrinsicContentSize].height;
    for (int i=0; i<maxColumn; i++) {
        BBCalendarDayView *dayView = [[BBCalendarDayView alloc] init];
        NSInteger row = i/maxColumn;
        NSInteger column = i%maxColumn;
        CGFloat x = ceilf(column*width);
        CGFloat y = ceilf(row*height);
        dayView.frame = CGRectMake(x, y, ceilf(width), ceilf(height));
        dayView.m_Delegate = self;
        [self addSubview:dayView];
        [marr addObject:dayView];
    }
    self.s_DayViewArray = [marr copy];
}
- (void)setM_DayViewModelArray:(NSArray<BBCalendarDayViewModel *> *)m_DayViewModelArray{
    _m_DayViewModelArray = [m_DayViewModelArray copy];
    
    for (int i=0; i<m_DayViewModelArray.count; i++) {
        if (i>self.s_DayViewArray.count) {break;}
        BBCalendarDayView *dayView = self.s_DayViewArray[i];
        dayView.m_Model = self.m_DayViewModelArray[i];
    }
}
- (CGSize)intrinsicContentSize{
    CGFloat height = kCalendarDayViewMinHeight;
    return CGSizeMake(-1, height);
}
- (void)calendarDayViewDidClick:(BBCalendarDayView *)view{
    if ([self.m_Delegate respondsToSelector:@selector(calendarWeekView:didClickWithDateComponent:)]) {
        [self.m_Delegate calendarWeekView:self didClickWithDateComponent:[view.m_Model.m_DateComponents copy]];
    }
}
@end
