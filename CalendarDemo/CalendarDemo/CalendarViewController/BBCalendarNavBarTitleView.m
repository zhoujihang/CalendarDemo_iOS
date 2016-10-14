//
//  CalendarNavBarTitleView.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/10.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBCalendarNavBarTitleView.h"
#import <Masonry/Masonry.h>

@interface BBCalendarNavBarTitleView ()

@property (nonatomic, weak) UIButton *s_LeftBtn;
@property (nonatomic, weak) UIButton *s_RightBtn;
@property (nonatomic, weak) UIButton *s_TitleBtn;

@end

@implementation BBCalendarNavBarTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    [self setupViews];
    [self setupConstraints];
}
- (void)setupViews{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(leftBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.backgroundColor = [UIColor cyanColor];
    [self addSubview:leftBtn];
    self.s_LeftBtn= leftBtn;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(rightBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.backgroundColor = [UIColor cyanColor];
    [self addSubview:rightBtn];
    self.s_RightBtn = rightBtn;
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBtn addTarget:self action:@selector(titleBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:titleBtn];
    self.s_TitleBtn = titleBtn;
}
- (void)setupConstraints{
    [self.s_TitleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.s_LeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self.s_TitleBtn.mas_left).offset(-8);
        make.width.equalTo(@14);
        make.centerY.equalTo(self.s_TitleBtn);
    }];
    [self.s_RightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.left.equalTo(self.s_TitleBtn.mas_right).offset(8);
        make.width.equalTo(@14);
        make.centerY.equalTo(self.s_TitleBtn);
    }];
}


- (void)setM_TitleString:(NSString *)m_TitleString{
    _m_TitleString = [m_TitleString copy];
    
    [self.s_TitleBtn setTitle:m_TitleString forState:UIControlStateNormal];
    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize{
    CGFloat widht = 0;
    
    [self.s_TitleBtn sizeToFit];
    CGFloat titleWidth = self.s_TitleBtn.bounds.size.width;
    titleWidth = titleWidth==0 ? 70 : titleWidth;
    widht += 10;
    widht += 10;
    widht += titleWidth;
    widht += 10;
    widht += 10;
    return CGSizeMake(widht, 30);
}

- (void)leftBtnDidClick:(UIButton *)sender{
    if ([self.m_Delegate respondsToSelector:@selector(calendarNavBarTitleViewDidClickLeftBtn:)]) {
        [self.m_Delegate calendarNavBarTitleViewDidClickLeftBtn:self];
    }
}
- (void)rightBtnDidClick:(UIButton *)sender{
    if ([self.m_Delegate respondsToSelector:@selector(calendarNavBarTitleViewDidClickRightBtn:)]) {
        [self.m_Delegate calendarNavBarTitleViewDidClickRightBtn:self];
    }
}
- (void)titleBtnDidClick:(UIButton *)sender{
    if ([self.m_Delegate respondsToSelector:@selector(calendarNavBarTitleViewDidClickTitle:)]) {
        [self.m_Delegate calendarNavBarTitleViewDidClickTitle:self];
    }
}

@end
