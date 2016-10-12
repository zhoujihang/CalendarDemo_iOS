//
//  UIColor+Extension.m
//  Ayibang
//
//  Created by ayibang-mac on 15/7/31.
//  Copyright (c) 2015年 ayibang. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)
+ (UIColor *)ext_hexColor:(NSString *)hexColor {
    
    return [self ext_hexColor:hexColor addAlpha:1.0];
    
}
+ (UIColor *)ext_hexColor:(NSString *)hexColor addAlpha:(float)alpha {
    NSString *colorString = [hexColor copy];
    if ([colorString hasPrefix:@"#"]) {
        colorString = [colorString substringFromIndex:1];
    }
    
    if ([colorString length]!=6) return nil;
    
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[colorString substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[colorString substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[colorString substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:alpha];
    
}

@end
