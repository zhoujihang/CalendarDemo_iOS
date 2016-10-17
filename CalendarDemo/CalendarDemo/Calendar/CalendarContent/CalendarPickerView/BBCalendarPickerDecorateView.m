//
//  BBCalendarPickerDecorateView.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/14.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBCalendarPickerDecorateView.h"
#import <Masonry/Masonry.h>
@interface BBCalendarPickerDecorateView ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *closeBtn;
@property (nonatomic, weak) UIButton *selectBtn;

@end

@implementation BBCalendarPickerDecorateView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    [self setupViews];
    [self setupConstraints];
}
- (void)setupViews{
    self.backgroundColor = [UIColor redColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"选择日期";
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    self.closeBtn = closeBtn;
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectBtn];
    self.selectBtn = selectBtn;
}
- (void)setupConstraints{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(8);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.selectBtn.mas_left).offset(-30);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-8);
    }];
}
- (CGSize)intrinsicContentSize{
    CGFloat height = 50;
    
    return CGSizeMake(-1, height);
}


- (void)selectBtnDidClick:(UIButton *)sender{
    if ([self.m_Delegate respondsToSelector:@selector(calendarPickerDecorateViewDidClickSelectBtn:)]) {
        [self.m_Delegate calendarPickerDecorateViewDidClickSelectBtn:self];
    }
}
- (void)closeBtnDidClick:(UIButton *)sender{
    if ([self.m_Delegate respondsToSelector:@selector(calendarPickerDecorateViewDidClickCloseBtn:)]) {
        [self.m_Delegate calendarPickerDecorateViewDidClickCloseBtn:self];
    }
}

@end
