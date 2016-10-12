//
//  UIColor+Extension.h
//  Ayibang
//
//  Created by ayibang-mac on 15/7/31.
//  Copyright (c) 2015年 ayibang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)
+ (UIColor *)ext_hexColor:(NSString *)hexColor;
+ (UIColor *)ext_hexColor:(NSString *)hexColor addAlpha:(float)alpha;
@end
