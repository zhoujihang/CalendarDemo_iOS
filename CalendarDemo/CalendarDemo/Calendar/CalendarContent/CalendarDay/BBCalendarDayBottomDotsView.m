//
//  CalendarDayBottomDotsView.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/10/9.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBCalendarDayBottomDotsView.h"
#import "UIImage+CalendarRemindExtension.h"

@interface BBCalendarDayBottomDotsView ()

@property (nonatomic, strong) NSMutableArray<CALayer *> *s_DotsLayerMArr;
/// 点点的直径
@property (nonatomic, assign) CGFloat diameter;
/// 点点间的间隔
@property (nonatomic, assign) CGFloat padding;

@end

@implementation BBCalendarDayBottomDotsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = NO;
    self.diameter = 6;
    self.padding = 2;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat viewWidth = ceilf(self.bounds.size.width);
    if (viewWidth == 0) {return;}
    
    NSInteger count = self.s_DotsLayerMArr.count;
    count = count<=6 ? count : 6;
    if (count == 0) {return;}
    
    CALayer *layer1 = count>=1 ? self.s_DotsLayerMArr[0] : nil;
    CALayer *layer2 = count>=2 ? self.s_DotsLayerMArr[1] : nil;
    CALayer *layer3 = count>=3 ? self.s_DotsLayerMArr[2] : nil;
    CALayer *layer4 = count>=4 ? self.s_DotsLayerMArr[3] : nil;
    CALayer *layer5 = count>=5 ? self.s_DotsLayerMArr[4] : nil;
    CALayer *layer6 = count>=6 ? self.s_DotsLayerMArr[5] : nil;
    
    CGFloat centerX1 = ceilf(viewWidth/2-self.padding-self.diameter);
    CGFloat centerX2 = ceilf(viewWidth/2);
    CGFloat centerX3 = ceilf(viewWidth/2+self.padding+self.diameter);
    CGFloat centerY1 = ceilf(self.padding+self.diameter*0.5);
    CGFloat centerY2 = ceilf(self.padding*2+self.diameter*1.5);
    switch (count) {
        case 6:{
            layer6.position = CGPointMake(centerX3, centerY2);
        }
        case 5:{
            layer5.position = CGPointMake(centerX2, centerY2);
        }
        case 4:{
            layer4.position = CGPointMake(centerX1, centerY2);
        }
        case 3:{
            layer3.position = CGPointMake(centerX3, centerY1);
            layer2.position = CGPointMake(centerX2, centerY1);
            layer1.position = CGPointMake(centerX1, centerY1);
        }
            break;
        case 2:{
            CGFloat centerX = ceilf(viewWidth/2-(self.padding+self.diameter)/2);
            layer1.position = CGPointMake(centerX, centerY1);
            centerX = ceilf(viewWidth/2+(self.padding+self.diameter)/2);
            layer2.position = CGPointMake(centerX, centerY1);
        }
            break;
        case 1:{
            CGFloat centerX = ceilf(viewWidth/2);
            layer1.position = CGPointMake(centerX, centerY1);
        }
            break;
        default:
            break;
    }
}
- (void)setM_DotsColorArray:(NSArray *)m_DotsColorArray{
    _m_DotsColorArray = m_DotsColorArray;
    NSInteger count = m_DotsColorArray.count;
    count = count<=6 ? count : 6;
    
    for (CALayer *layer in self.s_DotsLayerMArr) {
        [layer removeFromSuperlayer];
    }
    self.s_DotsLayerMArr = [@[] mutableCopy];
    
    for (int i=0; i<count; i++) {
        UIColor *color = m_DotsColorArray[i];
        CALayer *layer = [CALayer layer];
        layer.bounds = CGRectMake(0, 0, self.diameter, self.diameter);
        layer.contents = (__bridge id)([self solidCircleImageWithColor:color].CGImage);
        [self.layer addSublayer:layer];
        [self.s_DotsLayerMArr addObject:layer];
    }
    
    [self layoutIfNeeded];
}
- (UIImage *)solidCircleImageWithColor:(UIColor *)color{
    UIImage *image = [UIImage cre_solidCircleImageWithDiameter:self.diameter color:color];
    return image;
}

@end
