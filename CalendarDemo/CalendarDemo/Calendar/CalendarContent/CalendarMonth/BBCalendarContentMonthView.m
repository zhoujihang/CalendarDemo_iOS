//
//  CalendarContentMonthView.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/8.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBCalendarContentMonthView.h"
#import "BBCalendarMonthView.h"
#import "BBCalendarDayViewModel.h"
#import <Masonry/Masonry.h>
#import "NSDate+CalendarRemindExtension.h"
#import "NSDateComponents+CalendarRemindExtension.h"
#import "BBCalendarTool.h"
typedef NS_ENUM(NSUInteger, MonthScrollDirectionType) {
    MonthScrollDirectionTypeLeft,
    MonthScrollDirectionTypeRight,
};

@interface BBCalendarContentMonthView ()<UIScrollViewDelegate, BBCalendarMonthViewDelegate>
// 控件
@property (nonatomic, weak) UIScrollView *s_BackdropScrollView;
@property (nonatomic, strong) NSArray<BBCalendarMonthView *> *s_MonthViewArray;

// 当前正在显示的月份,只参与滑动时的逻辑判断
@property (nonatomic, assign) NSInteger s_PresentMonth;
@property (nonatomic, strong, readwrite) NSDateComponents *m_SelectedDateComponent;
@end

@implementation BBCalendarContentMonthView

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
        BBCalendarMonthView *monthView = [[BBCalendarMonthView alloc] init];
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
    BBCalendarMonthView *monthView = self.s_MonthViewArray[1];
    CGFloat height = [monthView intrinsicContentSize].height;
    return CGSizeMake(-1, height);
}

#pragma mark - 逻辑
- (void)jumpToToday{
    NSDateComponents *todayDateCpt = [[NSDate date] cre_dateCompontentsYMDHMSWW];
    [self refreshWithSelectedDateComponents:todayDateCpt];
}
- (void)scrollToLeftMonth{
    CGPoint leftOffset = CGPointMake(0, 0);
    [self.s_BackdropScrollView setContentOffset:leftOffset animated:YES];
}
- (void)scrollToLeftMonthWithSelectedDateComponents:(NSDateComponents *)dateComponents{
    if (![BBCalendarTool isValidatedDateComponents:dateComponents]) {return;}
    
    self.m_SelectedDateComponent = [dateComponents copy];
    [self scrollToLeftMonth];
}
- (void)scrollToRightMonth{
    CGPoint rightOffset = CGPointMake(self.s_BackdropScrollView.frame.size.width*2, 0);
    [self.s_BackdropScrollView setContentOffset:rightOffset animated:YES];
}
- (void)scrollToRightMonthWithSelectedDateComponents:(NSDateComponents *)dateComponents{
    if (![BBCalendarTool isValidatedDateComponents:dateComponents]) {return;}
    
    self.m_SelectedDateComponent = [dateComponents copy];
    [self scrollToRightMonth];
}
- (void)refreshWithSelectedDateComponents:(NSDateComponents *)dateComponents{
    if (![BBCalendarTool isValidatedDateComponents:dateComponents]) {return;}
    self.m_SelectedDateComponent = dateComponents;
    [self resetCalendarContentDate];
}
#pragma mark - 滑动切换
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX == 0) {
        if ([self validateJumpToMonthWithDirection:MonthScrollDirectionTypeLeft]) {
            [self jumpToMonthWithDirection:MonthScrollDirectionTypeLeft];
        }
    }else if (offsetX == scrollView.frame.size.width*2){
        if ([self validateJumpToMonthWithDirection:MonthScrollDirectionTypeRight]) {
            [self jumpToMonthWithDirection:MonthScrollDirectionTypeRight];
        }
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGFloat targetOffsetX = (*targetContentOffset).x;
    BOOL canScroll = YES;
    if (targetOffsetX == 0) {
        canScroll = [self validateJumpToMonthWithDirection:MonthScrollDirectionTypeLeft];
    }else if (targetOffsetX == scrollView.frame.size.width*2){
        canScroll = [self validateJumpToMonthWithDirection:MonthScrollDirectionTypeRight];
    }
    if (!canScroll) {
        *targetContentOffset = CGPointMake(scrollView.frame.size.width, 0);
    }
}
// 得到左右滑动的后的目的日期
- (NSDateComponents *)targetDateComponentsWithDirection:(MonthScrollDirectionType)type{
    NSDateComponents *targetDateCpt = [self.m_SelectedDateComponent copy];
    NSInteger selectedMonth = self.m_SelectedDateComponent.month;
    if (type == MonthScrollDirectionTypeLeft) {
        NSInteger willPresentMonth = (self.s_PresentMonth-1)<=0 ? 12 : self.s_PresentMonth-1;
        if (willPresentMonth != selectedMonth) {
            targetDateCpt = [self.m_SelectedDateComponent cre_leftMonthFirstDayDateComponents];
        }
    }else{
        NSInteger willPresentMonth = (self.s_PresentMonth+1)>=13 ? 1 : self.s_PresentMonth+1;
        if (willPresentMonth != selectedMonth) {
            targetDateCpt = [self.m_SelectedDateComponent cre_rightMonthFirstDayDateComponents];
        }
    }
    return targetDateCpt;
}
// 校验能否左滑或者右滑
- (BOOL)validateJumpToMonthWithDirection:(MonthScrollDirectionType)type{
    NSDateComponents *targetDateComponents = [self targetDateComponentsWithDirection:type];
    if (![BBCalendarTool isValidatedDateComponents:targetDateComponents]) {
        return NO;
    }
    return YES;
}
// 执行左右滑动切换数据的动作
- (void)jumpToMonthWithDirection:(MonthScrollDirectionType)type{
    self.m_SelectedDateComponent = [self targetDateComponentsWithDirection:type];
    [self resetCalendarContentDate];
}
- (void)resetCalendarContentDate{
    self.s_PresentMonth = self.m_SelectedDateComponent.month;
    NSArray *monthArray = [self calendarMonthArrayForDateComponentsYMD:self.m_SelectedDateComponent];
    if (self.s_MonthViewArray.count != 3) {return;}
    if (monthArray.count != 3) {return;}
    
    BBCalendarMonthView *monthView1 = self.s_MonthViewArray[0];
    BBCalendarMonthView *monthView2 = self.s_MonthViewArray[1];
    BBCalendarMonthView *monthView3 = self.s_MonthViewArray[2];
    
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
- (NSArray<NSArray<BBCalendarDayViewModel *> *> *)calendarMonthArrayForDateComponentsYMD:(NSDateComponents *)dateComponentsYMD{
    NSDateComponents *currentMonthFirstDayDateCpt = [dateComponentsYMD cre_currentMonthFirstDayDateComponents];
    
    // 左边月份
    NSDateComponents *leftMonthFirstDayDateCpt = [currentMonthFirstDayDateCpt cre_leftMonthFirstDayDateComponents];
    NSArray *leftMonthDateComponentsArray = [self dateComponentsOfOneMonthPageForDateComponents:leftMonthFirstDayDateCpt];
    
    // 中间月份
    NSArray *currentMonthDateComponentsArray = [self dateComponentsOfOneMonthPageForDateComponents:currentMonthFirstDayDateCpt];
    
    // 右边月份
    NSDateComponents *rightMonthFirstDayDateCpt = [currentMonthFirstDayDateCpt cre_rightMonthFirstDayDateComponents];
    NSArray *rightMonthDateComponentsArray = [self dateComponentsOfOneMonthPageForDateComponents:rightMonthFirstDayDateCpt];
    
    // 日期模型转化为视图模型
    NSMutableArray *leftMonthViewModelMArr = [NSMutableArray arrayWithCapacity:leftMonthDateComponentsArray.count];
    for (int i=0; i<leftMonthDateComponentsArray.count; i++) {
        BBCalendarDayViewModel *vm = [BBCalendarDayViewModel modelFromDateComponents:leftMonthDateComponentsArray[i] withSelectedDateComponents:self.m_SelectedDateComponent currentMonthDateComponents:leftMonthFirstDayDateCpt];
        [leftMonthViewModelMArr addObject:vm];
    }
    NSMutableArray *currentMonthViewModelMArr = [NSMutableArray arrayWithCapacity:currentMonthDateComponentsArray.count];
    for (int i=0; i<currentMonthDateComponentsArray.count; i++) {
        BBCalendarDayViewModel *vm = [BBCalendarDayViewModel modelFromDateComponents:currentMonthDateComponentsArray[i] withSelectedDateComponents:self.m_SelectedDateComponent currentMonthDateComponents:dateComponentsYMD];
        [currentMonthViewModelMArr addObject:vm];
    }
    NSMutableArray *rightMonthViewModelMArr = [NSMutableArray arrayWithCapacity:rightMonthDateComponentsArray.count];
    for (int i=0; i<rightMonthDateComponentsArray.count; i++) {
        BBCalendarDayViewModel *vm = [BBCalendarDayViewModel modelFromDateComponents:rightMonthDateComponentsArray[i] withSelectedDateComponents:self.m_SelectedDateComponent currentMonthDateComponents:rightMonthFirstDayDateCpt];
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
    NSDateComponents *monthFirstDateCpt = [monthFirstDate cre_dateCompontentsYMDHMSWW];
    
    // 月份最后一天
    NSDate *monthLimitDate = [monthFirstDate cre_limitDateInCurrentMonth];
    NSDateComponents *monthLimitDateCpt = [monthLimitDate cre_dateCompontentsYMDHMSWW];
    
    NSInteger weekdayOfMonthFirstDate = monthFirstDateCpt.weekday;
    NSInteger weekdayOfmonthLastDate = monthLimitDateCpt.weekday;
    
    // 月历包含天数
    NSInteger dayNumber = weekdayOfMonthFirstDate-1 + monthLimitDateCpt.day + (7-weekdayOfmonthLastDate);
    
    NSDate *pageFirstDate = [monthFirstDate dateByAddingTimeInterval:-(weekdayOfMonthFirstDate-1)*daySeconds];
    NSDate *legalDate = pageFirstDate;
    NSMutableArray *dateCptMArr = [@[] mutableCopy];
    for (int i=0; i<dayNumber; i++) {
        legalDate = [pageFirstDate dateByAddingTimeInterval:i*daySeconds];
        NSDateComponents *legalDateCpt = [legalDate cre_dateCompontentsYMDHMSWW];
        [dateCptMArr addObject:legalDateCpt];
    }
    
    return [dateCptMArr copy];
}

#pragma mark - 代理
- (void)calendarMonthView:(BBCalendarMonthView *)monthView didClickWithDateComponent:(NSDateComponents *)dateComponent{
    if ([self.m_Delegate respondsToSelector:@selector(calendarContentMonthView:didClickWithDateComponents:)]) {
        [self.m_Delegate calendarContentMonthView:self didClickWithDateComponents:[dateComponent copy]];
    }
}

@end
