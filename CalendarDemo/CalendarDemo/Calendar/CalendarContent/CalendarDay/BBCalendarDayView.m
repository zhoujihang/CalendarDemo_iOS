//
//  CalendarDayView.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/8.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBCalendarDayView.h"
#import "UIImage+CalendarRemindExtension.h"
#import <Masonry/Masonry.h>
#import "BBCalendarDayBottomDotsView.h"

CGFloat const kCalendarDayViewMinHeight = 60;

@interface BBCalendarDayView ()

@property (nonatomic, weak) UIButton *s_BackDropBtn;
@property (nonatomic, weak) UILabel *s_NumberLabel;
@property (nonatomic, weak) UILabel *s_LunarLabel;
@property (nonatomic, weak) UIImageView *s_BackCircleImgView;
@property (nonatomic, weak) BBCalendarDayBottomDotsView *s_BottomDotsView;

@end

@implementation BBCalendarDayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    [self setupViews];
}
// 创建视图控件
- (void)setupViews{
    UIButton *backdropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backdropBtn.exclusiveTouch = YES;
    [backdropBtn addTarget:self action:@selector(backdropBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backdropBtn];
    self.s_BackDropBtn = backdropBtn;
    
    UIImageView *backCircleImgView = [[UIImageView alloc] init];
    backCircleImgView.image = nil;
    [self addSubview:backCircleImgView];
    self.s_BackCircleImgView = backCircleImgView;
    
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.textColor = [UIColor lightGrayColor];
    numberLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:numberLabel];
    self.s_NumberLabel = numberLabel;
    
    UILabel *lunarLabel = [[UILabel alloc] init];
    lunarLabel.textAlignment = NSTextAlignmentCenter;
    lunarLabel.textColor = [UIColor grayColor];
    lunarLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:lunarLabel];
    self.s_LunarLabel = lunarLabel;
    
    BBCalendarDayBottomDotsView *bottomDotsView = [[BBCalendarDayBottomDotsView alloc] init];
    [self addSubview:bottomDotsView];
    self.s_BottomDotsView = bottomDotsView;
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    // 设置子控件位置
    CGFloat diameter = 22;
    CGSize size = self.bounds.size;
    CGFloat maxY = 0;
    self.s_BackDropBtn.frame = CGRectMake(0, 0, size.width, size.height);
    self.s_NumberLabel.frame = CGRectMake(0, 0, size.width, diameter+4);
    self.s_BackCircleImgView.bounds = CGRectMake(0, 0, diameter, diameter);
    self.s_BackCircleImgView.center = CGPointMake(ceilf(self.s_NumberLabel.center.x), ceilf(self.s_NumberLabel.center.y)) ;
    maxY = CGRectGetMaxY(self.s_NumberLabel.frame);
    self.s_LunarLabel.frame = CGRectMake(0, maxY, size.width, 16);
    maxY = CGRectGetMaxY(self.s_LunarLabel.frame);
    self.s_BottomDotsView.frame = CGRectMake(0, maxY, size.width, size.height-maxY);
}
- (void)setM_Model:(BBCalendarDayViewModel *)m_Model{
    _m_Model = m_Model;
    
    self.s_BackCircleImgView.image = [self imageWithColor:m_Model.m_BackCircleColor];
    self.s_NumberLabel.textColor = m_Model.m_NumberColor;
    self.s_LunarLabel.textColor = m_Model.m_LunarColor;
    
    self.s_NumberLabel.text = m_Model.m_NumberString;
    self.s_LunarLabel.text = m_Model.m_LunarString;
    
    self.s_BottomDotsView.m_DotsColorArray = m_Model.m_DotsColorArray;
}

- (UIImage *)imageWithColor:(UIColor *)color{
    if (!color) {return nil;}
    
    return [UIImage cre_solidCircleImageWithDiameter:20 color:color];
}

- (void)backdropBtnDidClick:(UIButton *)sender{
    if ([self.m_Delegate respondsToSelector:@selector(calendarDayViewDidClick:)]) {
        [self.m_Delegate calendarDayViewDidClick:self];
    }
}


@end
