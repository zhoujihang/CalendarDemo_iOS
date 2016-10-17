//
//  BBCalendarPickerView.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/14.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBCalendarPickerView.h"
#import <Masonry/Masonry.h>
#import "BBCalendarPickerDecorateView.h"

@interface BBCalendarPickerView () <UIPickerViewDelegate, UIPickerViewDataSource, BBCalendarPickerDecorateViewDelegate>

@property (nonatomic, weak) UIPickerView *s_MonthPickerView;
@property (nonatomic, weak) BBCalendarPickerDecorateView *s_DecorateView;

@property (nonatomic, strong) NSArray *s_YearArr;
@property (nonatomic, strong) NSArray *s_MonthArr;

@property (nonatomic, assign, readwrite) NSInteger m_SelectedYear;
@property (nonatomic, assign, readwrite) NSInteger m_SelectedMonth;

@end

@implementation BBCalendarPickerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    [self setupData];
    [self setupViews];
    [self setupConstraints];
}
- (void)setupViews{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UIPickerView *monthPickerView = [[UIPickerView alloc] init];
    monthPickerView.backgroundColor = [UIColor whiteColor];
    monthPickerView.delegate = self;
    monthPickerView.dataSource = self;
    [self addSubview:monthPickerView];
    self.s_MonthPickerView = monthPickerView;
    
    BBCalendarPickerDecorateView *decorateView = [[BBCalendarPickerDecorateView alloc] init];
    decorateView.m_Delegate = self;
    [self addSubview:decorateView];
    self.s_DecorateView = decorateView;
}
- (void)setupConstraints{
    [self.s_MonthPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@300);
        make.bottom.equalTo(self);
    }];
    [self.s_DecorateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.s_MonthPickerView);
        make.bottom.equalTo(self.s_MonthPickerView.mas_top);
    }];
}
- (void)setupData{
    // 选择范围从1970~2070共101年
    NSMutableArray *yearMArr = [@[] mutableCopy];
    for (int i=0; i<=100; i++) {
        [yearMArr addObject:@(1970+i)];
    }
    self.s_YearArr = [yearMArr copy];
    
    self.s_MonthArr = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12];
}

- (void)jumpToSelectedYear:(NSInteger)year month:(NSInteger)month{
    year = year>=1970 ?  year : 1970;
    year = year<=1970+100 ? year : 1970+100;
    month = month>=1 ? month : 1;
    month = month<=12 ? month : 12;
    
    self.m_SelectedYear = year;
    self.m_SelectedMonth = month;
    
    NSInteger yearRow = [self.s_YearArr indexOfObject:@(self.m_SelectedYear)];
    NSInteger monthRow = [self.s_MonthArr indexOfObject:@(self.m_SelectedMonth)];
    
    [self.s_MonthPickerView selectRow:yearRow inComponent:0 animated:NO];
    [self.s_MonthPickerView selectRow:monthRow inComponent:1 animated:NO];
    
    [self.s_MonthPickerView reloadAllComponents];
}

#pragma mark - pickview代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger row = 0;
    if (component == 0) {
        row = self.s_YearArr.count;
    }else if (component == 1){
        row = self.s_MonthArr.count;
    }
    return row;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title = @"";
    
    if (component == 0) {
        NSInteger year = [self.s_YearArr[row] integerValue];
        title = [NSString stringWithFormat:@"%ld", year];
    }else if (component == 1){
        NSInteger month = [self.s_MonthArr[row] integerValue];
        title = [NSString stringWithFormat:@"%ld", month];
    }
    
    return title;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        NSInteger year = [self.s_YearArr[row] integerValue];
        self.m_SelectedYear = year;
    }else if (component == 1){
        NSInteger month = [self.s_MonthArr[row] integerValue];
        self.m_SelectedMonth = month;
    }
}

#pragma mark - decorate delegate
- (void)calendarPickerDecorateViewDidClickSelectBtn:(BBCalendarPickerDecorateView *)view{
    if ([self.m_Delegate respondsToSelector:@selector(calendarPickerView:didSelectYear:month:)]) {
        [self.m_Delegate calendarPickerView:self didSelectYear:self.m_SelectedYear month:self.m_SelectedMonth];
    }
    [self removeFromSuperview];
}
- (void)calendarPickerDecorateViewDidClickCloseBtn:(BBCalendarPickerDecorateView *)view{
    [self removeFromSuperview];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}


@end
