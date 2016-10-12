//
//  UIImage+Extension.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/9/30.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)ext_solidCircleImageWithDiameter:(CGFloat)diameter color:(UIColor *)color{
    if (!color) {return nil;}
    if (diameter<=0) {return nil;}
    
    UIImage *img;
    CGSize size = CGSizeMake(diameter, diameter);
    // 开启位图上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    // 取得当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [color set];
    
    CGFloat radius = size.width * 0.5; // 圆半径
    CGFloat centerX = size.width * 0.5; // 圆心
    CGFloat centerY = size.width * 0.5;
    CGContextAddArc(ctx, centerX, centerY, radius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);   // 画实心圆
    
    img = UIGraphicsGetImageFromCurrentImageContext();
   
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return img;
}

@end
