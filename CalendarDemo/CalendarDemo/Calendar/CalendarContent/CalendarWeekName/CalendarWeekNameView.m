//
//  CalendarWeekNameView.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/9/29.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "CalendarWeekNameView.h"
#import <Masonry/Masonry.h>

@interface CalendarWeekNameView ()

@property (nonatomic, strong) NSArray *s_WeekNameArr;
@property (nonatomic, strong) NSArray *s_WeekNameLabelArr;

@end

@implementation CalendarWeekNameView

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
// 创建视图控件
- (void)setupViews{
    self.backgroundColor = [UIColor whiteColor];
    NSMutableArray *marr = [@[] mutableCopy];
    for (int i=0; i<self.s_WeekNameArr.count; i++) {
        NSString *name = self.s_WeekNameArr[i];
        UILabel *weekNameLabel = [[UILabel alloc] init];
        weekNameLabel.font = [UIFont systemFontOfSize:12];
        weekNameLabel.textColor = [UIColor lightGrayColor];
        weekNameLabel.textAlignment = NSTextAlignmentCenter;
        weekNameLabel.text = name;
        [marr addObject:weekNameLabel];
        [self addSubview:weekNameLabel];
    }
    self.s_WeekNameLabelArr = [marr copy];
}
// 设置控件约束关系
- (void)setupConstraints{
    UIView *firstView = [self.s_WeekNameLabelArr firstObject];
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.bottom.equalTo(self);
    }];
    
    for (int i=1; i<self.s_WeekNameLabelArr.count; i++) {
        UIView *aView = self.s_WeekNameLabelArr[i-1];
        UIView *bView = self.s_WeekNameLabelArr[i];
        
        [aView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(bView);
            make.width.equalTo(bView);
            make.right.equalTo(bView.mas_left);
        }];
    }
    
    UIView *lastView = [self.s_WeekNameLabelArr lastObject];
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
    }];
}
#pragma mark 高度
- (CGSize)sizeThatFits:(CGSize)size{
    CGSize intrinsicContentSize = [self intrinsicContentSize];
    return CGSizeMake(size.width, intrinsicContentSize.height);
}
- (CGSize)intrinsicContentSize{
    return CGSizeMake(-1, 30);
}
#pragma mark 懒加载
- (NSArray *)s_WeekNameArr{
    if (_s_WeekNameArr) {return _s_WeekNameArr;}
    
    _s_WeekNameArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    return _s_WeekNameArr;
}

@end
