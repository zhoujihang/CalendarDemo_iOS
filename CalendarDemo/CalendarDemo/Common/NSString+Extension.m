//
//  NSString+Extension
//  Ayibang
//
//  Created by 阿姨帮 on 15/7/6.
//  Copyright (c) 2015年 ayibang. All rights reserved.
//

#import "NSString+Extension.h"
@implementation NSString (Extension)

- (CGSize)ext_sizeWithBoundingSize:(CGSize)boundingSize font:(UIFont *)font{
    CGRect labelRect = [self boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    return labelRect.size;
}

@end
