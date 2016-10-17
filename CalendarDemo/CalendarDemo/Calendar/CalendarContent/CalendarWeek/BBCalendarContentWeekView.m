//
//  CalendarContentWeekView.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/9.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBCalendarContentWeekView.h"
#import "BBCalendarWeekView.h"
#import "BBCalendarDayViewModel.h"
#import <Masonry/Masonry.h>
#import "NSDate+CalendarRemindExtension.h"
#import "NSDateComponents+CalendarRemindExtension.h"
#import "BBCalendarTool.h"
typedef NS_ENUM(NSUInteger, WeekScrollDirectionType) {
    WeekScrollDirectionTypeLeft,
    WeekScrollDirectionTypeRight,
};

@interface BBCalendarContentWeekView ()<UIScrollViewDelegate, BBCalendarWeekViewDelegate>
// 控件
@property (nonatomic, weak) UIScrollView *s_BackdropScrollView;
@property (nonatomic, strong) NSArray<BBCalendarWeekView *> *s_WeekViewArray;

@property (nonatomic, strong, readwrite) NSDateComponents *m_SelectedDateComponent;

@end

@implementation BBCalendarContentWeekView
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
        BBCalendarWeekView *weekView = [[BBCalendarWeekView alloc] init];
        weekView.m_Delegate = self;
        [self.s_BackdropScrollView addSubview:weekView];
        [marr addObject:weekView];
    }
    self.s_WeekViewArray = [marr copy];
}
- (void)setupConstraints{
    [self.s_BackdropScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
        make.centerX.equalTo(self);
    }];
    if (self.s_WeekViewArray.count!=3) {return;}
    UIView *view1 = self.s_WeekViewArray[0];
    UIView *view2 = self.s_WeekViewArray[1];
    UIView *view3 = self.s_WeekViewArray[2];
    
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
- (CGSize)intrinsicContentSize{
    if (self.s_WeekViewArray.count != 3) {
        return CGSizeMake(-1, -1);
    }
    BBCalendarWeekView *weekView = self.s_WeekViewArray[1];
    CGFloat height = [weekView intrinsicContentSize].height;
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
        // 滑到左边
        if ([self validateJumpToWeekWithDirection:WeekScrollDirectionTypeLeft]) {
            [self jumpToWeekWithDirection:WeekScrollDirectionTypeLeft];
        }
    }else if(offsetX == self.s_BackdropScrollView.frame.size.width*2){
        // 滑到右边
        if ([self validateJumpToWeekWithDirection:WeekScrollDirectionTypeRight]) {
            [self jumpToWeekWithDirection:WeekScrollDirectionTypeRight];
        }
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGFloat targetOffsetX = (*targetContentOffset).x;
    BOOL canScroll = YES;
    if (targetOffsetX == 0) {
        canScroll = [self validateJumpToWeekWithDirection:WeekScrollDirectionTypeLeft];
    }else if (targetOffsetX == scrollView.frame.size.width*2){
        canScroll = [self validateJumpToWeekWithDirection:WeekScrollDirectionTypeRight];
    }
    if (!canScroll) {
        *targetContentOffset = CGPointMake(scrollView.frame.size.width, 0);
    }
}
- (NSDateComponents *)targetDateComponentsWithDirection:(WeekScrollDirectionType)type{
    NSInteger daySecondes = 24*60*60;
    NSInteger weekDay = self.m_SelectedDateComponent.weekday;
    NSInteger addingSeconds = type==WeekScrollDirectionTypeRight ? (7-weekDay+1)*daySecondes : -(weekDay-1+7)*daySecondes;
    NSDate *date = [self.m_SelectedDateComponent cre_localDate];
    NSDate *nextDate = [date dateByAddingTimeInterval:addingSeconds];
    NSDateComponents *targetDateCpt = [nextDate cre_dateCompontentsYMDHMSWW];
    return targetDateCpt;
}
- (BOOL)validateJumpToWeekWithDirection:(WeekScrollDirectionType)type{
    NSDateComponents *targetDateCpt = [self targetDateComponentsWithDirection:type];
    
    if (![BBCalendarTool isValidatedDateComponents:targetDateCpt]) {
        return NO;
    }
    
    return YES;
}
// 切换到下个星期，同时选中星期天
- (void)jumpToWeekWithDirection:(WeekScrollDirectionType)type{
    self.m_SelectedDateComponent = [self targetDateComponentsWithDirection:type];
    
    [self resetCalendarContentDate];
}
- (void)resetCalendarContentDate{
    NSArray *weekArray = [self calendarWeekArrayForDateComponentsYMD:self.m_SelectedDateComponent];
    if (self.s_WeekViewArray.count != 3) {return;}
    if (weekArray.count != 3) {return;}
    
    BBCalendarWeekView *weekView1 = self.s_WeekViewArray[0];
    BBCalendarWeekView *weekView2 = self.s_WeekViewArray[1];
    BBCalendarWeekView *weekView3 = self.s_WeekViewArray[2];
    
    weekView1.m_DayViewModelArray = weekArray[0];
    weekView2.m_DayViewModelArray = weekArray[1];
    weekView3.m_DayViewModelArray = weekArray[2];
    
    self.s_BackdropScrollView.contentOffset = CGPointMake(self.s_BackdropScrollView.frame.size.width, 0);
    
    // 重置数据后，告诉外界最新日期
    if ([self.m_Delegate respondsToSelector:@selector(calendarContentWeekView:didClickWithDateComponents:)]) {
        [self.m_Delegate calendarContentWeekView:self didClickWithDateComponents:[self.m_SelectedDateComponent copy]];
    }
}
#pragma mark - 日历数据计算
/**
 给出2016-10-01日期模型，返回三个周在日历上的视图模型数组
 
 @param dateComponentsYMD 指定的月份第一天的年、月、日的日期模型
 
 @return 以 dateComponentsYMD 为中心，3个周范围内的 CalendarDayViewModel 的数组，是3*7的二维数组
 */
- (NSArray<NSArray<BBCalendarDayViewModel *> *> *)calendarWeekArrayForDateComponentsYMD:(NSDateComponents *)dateComponentsYMD{
    NSDate *date = [dateComponentsYMD cre_localDate];
    NSDateComponents *dateCpt = [date cre_dateCompontentsYMDHMSWW];
    
    NSInteger weekday = dateCpt.weekday;
    NSInteger leftDayNumber = 7+weekday-1;
    NSInteger daySecondes = 24*60*60;
    NSDate *firstFridayDate = [date dateByAddingTimeInterval:-leftDayNumber*daySecondes];
    
    NSMutableArray *weekMArr = [@[] mutableCopy];
    NSDate *legalDate;
    for (int i=0; i<3; i++) {
        NSMutableArray *dayMArr = [@[] mutableCopy];
        for (int j=0; j<7; j++) {
            NSInteger dayNumber = i*7+j;
            legalDate = [firstFridayDate dateByAddingTimeInterval:dayNumber*daySecondes];
            NSDateComponents *dateCpt = [legalDate cre_dateCompontentsYMDHMSWW];
            [dayMArr addObject:dateCpt];
        }
        [weekMArr addObject:[dayMArr copy]];
    }
    NSArray *leftWeekDateComponentsArr = weekMArr[0];
    NSArray *currentWeekDateComponentsArr = weekMArr[1];
    NSArray *rightWeekDateComponentsArr = weekMArr[2];
    
    // 日期模型转化为视图模型
    NSMutableArray *leftWeekViewModelMArr = [NSMutableArray arrayWithCapacity:7];
    for (int i=0; i<leftWeekDateComponentsArr.count; i++) {
        BBCalendarDayViewModel *vm = [BBCalendarDayViewModel  modelFromDateComponents:leftWeekDateComponentsArr[i] withSelectedDateComponents:self.m_SelectedDateComponent];
        [leftWeekViewModelMArr addObject:vm];
    }
    
    NSMutableArray *currentWeekViewModelMArr = [NSMutableArray arrayWithCapacity:7];
    for (int i=0; i<currentWeekDateComponentsArr.count; i++) {
        BBCalendarDayViewModel *vm = [BBCalendarDayViewModel  modelFromDateComponents:currentWeekDateComponentsArr[i] withSelectedDateComponents:self.m_SelectedDateComponent];
        [currentWeekViewModelMArr addObject:vm];
    }
    
    NSMutableArray *rightWeekViewModelMArr = [NSMutableArray arrayWithCapacity:7];
    for (int i=0; i<rightWeekDateComponentsArr.count; i++) {
        BBCalendarDayViewModel *vm = [BBCalendarDayViewModel  modelFromDateComponents:rightWeekDateComponentsArr[i] withSelectedDateComponents:self.m_SelectedDateComponent];
        [rightWeekViewModelMArr addObject:vm];
    }
    return @[leftWeekViewModelMArr, currentWeekViewModelMArr, rightWeekViewModelMArr];
}
// 给 2016-10-01 日，则返回 其所在 周 的日期集合
- (NSArray<NSDateComponents *> *)dateComponentsOfOneMonthPageForDateComponents:(NSDateComponents *)dateComponents{
    NSInteger daySeconds = 24*60*60;
    
    NSInteger weekday = dateComponents.weekday;
    NSDate *date = [dateComponents cre_localDate];
    NSDate *fridayDate = [date dateByAddingTimeInterval:(weekday-1)*daySeconds];
    
    NSMutableArray *marr = [@[] mutableCopy];
    NSDate *legalDate;
    for (int i=0; i<7; i++) {
        legalDate = [fridayDate dateByAddingTimeInterval:i*daySeconds];
        NSDateComponents *dateCpt = [legalDate cre_dateCompontentsYMDHMSWW];
        [marr addObject:dateCpt];
    }
    return [marr copy];
}

#pragma mark - 代理
- (void)calendarWeekView:(BBCalendarWeekView *)weekView didClickWithDateComponent:(NSDateComponents *)dateComponent{
    
    // 切换完后，选中当前日期并回调
    if ([self.m_Delegate respondsToSelector:@selector(calendarContentWeekView:didClickWithDateComponents:)]) {
        [self.m_Delegate calendarContentWeekView:self didClickWithDateComponents:[dateComponent copy]];
    }
}

@end
