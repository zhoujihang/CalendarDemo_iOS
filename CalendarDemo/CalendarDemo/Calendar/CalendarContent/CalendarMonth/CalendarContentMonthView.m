//
//  CalendarContentMonthView.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/8.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "CalendarContentMonthView.h"
#import "CalendarMonthView.h"
#import "CalendarDayViewModel.h"
#import <Masonry/Masonry.h>
#import "NSDate+Extension.h"
#import "NSDateComponents+Extension.h"

typedef NS_ENUM(NSUInteger, MonthScrollDirectionType) {
    MonthScrollDirectionTypeLeft,
    MonthScrollDirectionTypeRight,
};

@interface CalendarContentMonthView ()<UIScrollViewDelegate, CalendarMonthViewDelegate>
// 控件
@property (nonatomic, weak) UIScrollView *s_BackdropScrollView;
@property (nonatomic, strong) NSArray<CalendarMonthView *> *s_MonthViewArray;

// 当前正在显示的月份,只参与滑动时的逻辑判断
@property (nonatomic, assign) NSInteger s_PresentMonth;
@property (nonatomic, strong, readwrite) NSDateComponents *m_SelectedDateComponent;
@end

@implementation CalendarContentMonthView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)dealloc{
    self.s_BackdropScrollView.delegate = nil;
}
- (void)setup{
    [self setupViews];
    [self setupConstraints];
    [self setupData];
}
- (void)setupViews{
    self.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *backdropScrollView = [[UIScrollView alloc] init];
    backdropScrollView.delegate = self;
    backdropScrollView.pagingEnabled = YES;
    backdropScrollView.showsHorizontalScrollIndicator = NO;
    backdropScrollView.bounces = NO;
    [self addSubview:backdropScrollView];
    self.s_BackdropScrollView = backdropScrollView;
    
    NSMutableArray *marr = [@[] mutableCopy];
    for (int i=0; i<3; i++) {
        CalendarMonthView *monthView = [[CalendarMonthView alloc] init];
        monthView.m_Delegate = self;
        [self.s_BackdropScrollView addSubview:monthView];
        [marr addObject:monthView];
    }
    self.s_MonthViewArray = [marr copy];
}
- (void)setupConstraints{
    [self.s_BackdropScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
        make.centerX.equalTo(self);
    }];
    if (self.s_MonthViewArray.count!=3) {return;}
    UIView *view1 = self.s_MonthViewArray[0];
    UIView *view2 = self.s_MonthViewArray[1];
    UIView *view3 = self.s_MonthViewArray[2];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.s_BackdropScrollView);
        make.top.bottom.equalTo(view2);
        make.width.equalTo(view2);
    }];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1.mas_right);
        make.right.equalTo(view3.mas_left);
        make.top.bottom.equalTo(self.s_BackdropScrollView);
        make.centerY.equalTo(self.s_BackdropScrollView);
        make.width.equalTo(self.s_BackdropScrollView);
    }];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.s_BackdropScrollView);
        make.top.bottom.equalTo(view2);
        make.width.equalTo(view2);
    }];
    
}
- (void)setupData{
    // 待布局完成后设置数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self jumpToToday];
    });
}

- (CGSize)intrinsicContentSize{
    if (self.s_MonthViewArray.count != 3) {
        return CGSizeMake(-1, -1);
    }
    CalendarMonthView *monthView = self.s_MonthViewArray[1];
    CGFloat height = [monthView intrinsicContentSize].height;
    return CGSizeMake(-1, height);
}

#pragma mark - 逻辑
- (void)jumpToToday{
    NSDateComponents *todayDateCpt = [[NSDate date] ext_dateCompontentsYMDHMSWW];
    [self refreshWithSelectedDateComponents:todayDateCpt];
}
- (void)scrollToLeftMonth{
    CGPoint leftOffset = CGPointMake(0, 0);
    [self.s_BackdropScrollView setContentOffset:leftOffset animated:YES];
}
- (void)scrollToLeftMonthWithSelectedDateComponents:(NSDateComponents *)dateComponents{
    self.m_SelectedDateComponent = [dateComponents copy];
    [self scrollToLeftMonth];
}
- (void)scrollToRightMonth{
    CGPoint rightOffset = CGPointMake(self.s_BackdropScrollView.frame.size.width*2, 0);
    [self.s_BackdropScrollView setContentOffset:rightOffset animated:YES];
}
- (void)scrollToRightMonthWithSelectedDateComponents:(NSDateComponents *)dateComponents{
    self.m_SelectedDateComponent = [dateComponents copy];
    [self scrollToRightMonth];
}
- (void)refreshWithSelectedDateComponents:(NSDateComponents *)dateComponents{
    self.m_SelectedDateComponent = dateComponents;
    self.s_PresentMonth = dateComponents.month;
    [self resetCalendarContentDate];
}
#pragma mark - 滑动切换
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX == 0) {
        [self jumpToMonthWithDirection:MonthScrollDirectionTypeLeft];
    }else if (offsetX == scrollView.frame.size.width*2){
        [self jumpToMonthWithDirection:MonthScrollDirectionTypeRight];
    }
}
- (void)jumpToMonthWithDirection:(MonthScrollDirectionType)type{
    NSInteger selectedMonth = self.m_SelectedDateComponent.month;
    if (type == MonthScrollDirectionTypeLeft) {
        self.s_PresentMonth = (self.s_PresentMonth-1)<=0 ? 12 : self.s_PresentMonth-1;
        if (self.s_PresentMonth != selectedMonth) {
            // 已选中日期，和将要显示月份不一致时，选中将要显示月份的第一天
            self.m_SelectedDateComponent = [self.m_SelectedDateComponent ext_leftMonthFirstDayDateComponents];
        }
    }else{
        self.s_PresentMonth = (self.s_PresentMonth+1)>=13 ? 1 : self.s_PresentMonth+1;
        if (self.s_PresentMonth != selectedMonth) {
            self.m_SelectedDateComponent = [self.m_SelectedDateComponent ext_rightMonthFirstDayDateComponents];
        }
    }
    
    [self resetCalendarContentDate];
}
- (void)resetCalendarContentDate{
    CLog(@"newCurrentMonth:%ld", self.s_PresentMonth);
    NSArray *monthArray = [self calendarMonthArrayForDateComponentsYMD:self.m_SelectedDateComponent];
    if (self.s_MonthViewArray.count != 3) {return;}
    if (monthArray.count != 3) {return;}
    
    CalendarMonthView *monthView1 = self.s_MonthViewArray[0];
    CalendarMonthView *monthView2 = self.s_MonthViewArray[1];
    CalendarMonthView *monthView3 = self.s_MonthViewArray[2];
    
    monthView1.m_DayViewModelArray = monthArray[0];
    monthView2.m_DayViewModelArray = monthArray[1];
    monthView3.m_DayViewModelArray = monthArray[2];
    
    self.s_BackdropScrollView.contentOffset = CGPointMake(self.s_BackdropScrollView.frame.size.width, 0);
    
    // 重置数据后，告诉外界最新日期
    if ([self.m_Delegate respondsToSelector:@selector(calendarContentMonthView:didClickWithDateComponents:)]) {
        [self.m_Delegate calendarContentMonthView:self didClickWithDateComponents:[self.m_SelectedDateComponent copy]];
    }
}
#pragma mark - 日历数据计算
/**
 给出2016-10-01日期模型，返回2016-09、2016-10、2016-11三个月份在日历上的视图模型数组

 @param dateComponentsYMD 指定的月份某一天的年、月、日的日期模型

 @return 以 dateComponentsYMD 为中心，3个月范围内的 CalendarDayViewModel 的数组，是3*n的二维数组(n为4*7、5*7、6*7)
 */
- (NSArray<NSArray<CalendarDayViewModel *> *> *)calendarMonthArrayForDateComponentsYMD:(NSDateComponents *)dateComponentsYMD{
    NSDateComponents *currentMonthFirstDayDateCpt = [dateComponentsYMD ext_currentMonthFirstDayDateComponents];
    
    // 左边月份
    NSDateComponents *leftMonthFirstDayDateCpt = [currentMonthFirstDayDateCpt ext_leftMonthFirstDayDateComponents];
    NSArray *leftMonthDateComponentsArray = [self dateComponentsOfOneMonthPageForDateComponents:leftMonthFirstDayDateCpt];
    
    // 中间月份
    NSArray *currentMonthDateComponentsArray = [self dateComponentsOfOneMonthPageForDateComponents:currentMonthFirstDayDateCpt];
    
    // 右边月份
    NSDateComponents *rightMonthFirstDayDateCpt = [currentMonthFirstDayDateCpt ext_rightMonthFirstDayDateComponents];
    NSArray *rightMonthDateComponentsArray = [self dateComponentsOfOneMonthPageForDateComponents:rightMonthFirstDayDateCpt];
    
    // 日期模型转化为视图模型
    NSMutableArray *leftMonthViewModelMArr = [NSMutableArray arrayWithCapacity:leftMonthDateComponentsArray.count];
    for (int i=0; i<leftMonthDateComponentsArray.count; i++) {
        CalendarDayViewModel *vm = [CalendarDayViewModel modelFromDateComponents:leftMonthDateComponentsArray[i] withSelectedDateComponents:self.m_SelectedDateComponent currentMonthDateComponents:leftMonthFirstDayDateCpt];
        [leftMonthViewModelMArr addObject:vm];
    }
    NSMutableArray *currentMonthViewModelMArr = [NSMutableArray arrayWithCapacity:currentMonthDateComponentsArray.count];
    for (int i=0; i<currentMonthDateComponentsArray.count; i++) {
        CalendarDayViewModel *vm = [CalendarDayViewModel modelFromDateComponents:currentMonthDateComponentsArray[i] withSelectedDateComponents:self.m_SelectedDateComponent currentMonthDateComponents:dateComponentsYMD];
        [currentMonthViewModelMArr addObject:vm];
    }
    NSMutableArray *rightMonthViewModelMArr = [NSMutableArray arrayWithCapacity:rightMonthDateComponentsArray.count];
    for (int i=0; i<rightMonthDateComponentsArray.count; i++) {
        CalendarDayViewModel *vm = [CalendarDayViewModel modelFromDateComponents:rightMonthDateComponentsArray[i] withSelectedDateComponents:self.m_SelectedDateComponent currentMonthDateComponents:rightMonthFirstDayDateCpt];
        [rightMonthViewModelMArr addObject:vm];
    }
    
    return @[leftMonthViewModelMArr, currentMonthViewModelMArr, rightMonthViewModelMArr];
}
// 给 2016-10-01 日，则返回 2016-09-25 到 2016-11-05 的日期集合
- (NSArray<NSDateComponents *> *)dateComponentsOfOneMonthPageForDateComponents:(NSDateComponents *)dateComponents{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger daySeconds = 24*60*60;
    
    // 月份第一天
    NSDate *monthFirstDate = [calendar dateFromComponents:dateComponents];
    NSDateComponents *monthFirstDateCpt = [monthFirstDate ext_dateCompontentsYMDHMSWW];
    
    // 月份最后一天
    NSDate *monthLimitDate = [monthFirstDate ext_limitDateInCurrentMonth];
    NSDateComponents *monthLimitDateCpt = [monthLimitDate ext_dateCompontentsYMDHMSWW];
    
    NSInteger weekdayOfMonthFirstDate = monthFirstDateCpt.weekday;
    NSInteger weekdayOfmonthLastDate = monthLimitDateCpt.weekday;
    
    // 月历包含天数
    NSInteger dayNumber = weekdayOfMonthFirstDate-1 + monthLimitDateCpt.day + (7-weekdayOfmonthLastDate);
    
    NSDate *pageFirstDate = [monthFirstDate dateByAddingTimeInterval:-(weekdayOfMonthFirstDate-1)*daySeconds];
    NSDate *legalDate = pageFirstDate;
    NSMutableArray *dateCptMArr = [@[] mutableCopy];
    for (int i=0; i<dayNumber; i++) {
        legalDate = [pageFirstDate dateByAddingTimeInterval:i*daySeconds];
        NSDateComponents *legalDateCpt = [legalDate ext_dateCompontentsYMDHMSWW];
        [dateCptMArr addObject:legalDateCpt];
    }
    
    return [dateCptMArr copy];
}

#pragma mark - 代理
- (void)calendarMonthView:(CalendarMonthView *)monthView didClickWithDateComponent:(NSDateComponents *)dateComponent{
    if ([self.m_Delegate respondsToSelector:@selector(calendarContentMonthView:didClickWithDateComponents:)]) {
        [self.m_Delegate calendarContentMonthView:self didClickWithDateComponents:[dateComponent copy]];
    }
}

@end
