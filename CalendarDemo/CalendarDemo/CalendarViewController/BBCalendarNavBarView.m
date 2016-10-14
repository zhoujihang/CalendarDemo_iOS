//
//  CalendarNavBarView.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/10.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBCalendarNavBarView.h"
#import <Masonry/Masonry.h>
#import "BBCalendarNavBarTitleView.h"
#import "UIImage+CalendarRemindExtension.h"

@interface BBCalendarNavBarView () <BBCalendarNavBarTitleViewDelegate>

@property (nonatomic, weak) UIButton *s_BackBtn;
@property (nonatomic, weak) UIButton *s_TodayBtn;
@property (nonatomic, weak) BBCalendarNavBarTitleView *s_TitleView;
@property (nonatomic, weak) UIButton *s_RightBtn;

@end

@implementation BBCalendarNavBarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    self.backgroundColor = [UIColor redColor];
    [self setupViews];
    [self setupConstraints];
}
- (void)setupViews{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    self.s_BackBtn = backBtn;
    
    UIButton *todayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *circleImage = [UIImage cre_solidCircleImageWithDiameter:30 color:[UIColor lightGrayColor]];
    [todayBtn setBackgroundImage:circleImage forState:UIControlStateNormal];
    [todayBtn setBackgroundImage:circleImage forState:UIControlStateHighlighted];
    [todayBtn setTitle:@"今" forState:UIControlStateNormal];
    [todayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [todayBtn addTarget:self action:@selector(todayBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:todayBtn];
    self.s_TodayBtn = todayBtn;
    
    BBCalendarNavBarTitleView *titleView = [[BBCalendarNavBarTitleView alloc] init];
    titleView.m_Delegate = self;
    [self addSubview:titleView];
    self.s_TitleView = titleView;

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"添加提醒" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    self.s_RightBtn = rightBtn;
}
- (void)setupConstraints{
    [self.s_BackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(4);
        make.centerY.equalTo(self).offset(10);
    }];
    [self.s_TodayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.s_BackBtn.mas_right).offset(10);
        make.centerY.equalTo(self.s_BackBtn);
    }];
    [self.s_TitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.s_BackBtn);
    }];
    [self.s_RightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-8);
        make.centerY.equalTo(self.s_BackBtn);
    }];
}
- (void)setM_TitleString:(NSString *)m_TitleString{
    _m_TitleString = [m_TitleString copy];
    self.s_TitleView.m_TitleString = m_TitleString;
}

- (CGSize)intrinsicContentSize{
    CGFloat height = 64;
    return CGSizeMake(-1, height);
}

- (void)backBtnDidClick:(UIButton *)sender{
    if ([self.m_Delegate respondsToSelector:@selector(calendarNavBarViewDidClickBackBtn:)]) {
        [self.m_Delegate calendarNavBarViewDidClickBackBtn:self];
    }
}
- (void)todayBtnDidClick:(UIButton *)sender{
    if ([self.m_Delegate respondsToSelector:@selector(calendarNavBarViewDidClickTodayBtn:)]) {
        [self.m_Delegate calendarNavBarViewDidClickTodayBtn:self];
    }
}
- (void)rightBtnDidClick:(UIButton *)sender{
    if ([self.m_Delegate respondsToSelector:@selector(calendarNavBarViewDidClickRightBtn:)]) {
        [self.m_Delegate calendarNavBarViewDidClickRightBtn:self];
    }
}

#pragma mark - title 代理方法
- (void)calendarNavBarTitleViewDidClickTitle:(BBCalendarNavBarTitleView *)titleView{
    if ([self.m_Delegate respondsToSelector:@selector(calendarNavBarViewDidClickTitle:)]) {
        [self.m_Delegate calendarNavBarViewDidClickTitle:self];
    }
}
- (void)calendarNavBarTitleViewDidClickLeftBtn:(BBCalendarNavBarTitleView *)titleView{
    if ([self.m_Delegate respondsToSelector:@selector(calendarNavBarViewDidClickTitleLeftBtn:)]) {
        [self.m_Delegate calendarNavBarViewDidClickTitleLeftBtn:self];
    }
}
- (void)calendarNavBarTitleViewDidClickRightBtn:(BBCalendarNavBarTitleView *)titleView{
    if ([self.m_Delegate respondsToSelector:@selector(calendarNavBarViewDidClickTitleRightBtn:)]) {
        [self.m_Delegate calendarNavBarViewDidClickTitleRightBtn:self];
    }
}

@end
