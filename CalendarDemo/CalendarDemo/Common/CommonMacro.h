//
//  CommonMacro.h
//  TabBarTransitionDemo
//
//  Created by zhoujihang on 16/9/27.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#ifndef CommonMacro_h
#define CommonMacro_h


// log
#if DEBUG
#define CLog(format, ...) do {                                             \
fprintf(stderr, "<%s : line(%d)> %s\n",     \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                        \
printf("%s\n", [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);           \
} while (0)
#else
#define CLog(format, ...) nil
#endif

// 系统版本
#define SYSTEM_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
#define SYSTEM_VERSION_MORETHAN(version)        (([[[UIDevice currentDevice] systemVersion] floatValue] > (version))? (YES):(NO))
#define SYSTEM_VERSION_MORETHAN_EQUAL(version)  (([[[UIDevice currentDevice] systemVersion] floatValue] >= (version))? (YES):(NO))
#define SYSTEM_VERSION_EQUAL(version)           (([[[UIDevice currentDevice] systemVersion] floatValue] == (version))? (YES):(NO))
#define SYSTEM_VERSION_LESSTHAN_EQUAL(version)  (([[[UIDevice currentDevice] systemVersion] floatValue] <= (version))? (YES):(NO))
#define SYSTEM_VERSION_LESSTHAN(version)        (([[[UIDevice currentDevice] systemVersion] floatValue] < (version))? (YES):(NO))
#define SYSTEM_VERSION_LEFTCONTAIN_IN_RANGE(v1, v2)        (([[[UIDevice currentDevice] systemVersion] floatValue] >= (v1) && [[[UIDevice currentDevice] systemVersion] floatValue] < (v2))? (YES):(NO))

// 颜色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]


// 强弱引用
#define WeakSelf(type)  __weak typeof(type) weak##type = type;
#define StrongSelf(type)  __strong typeof(type) strong##type = weak##type;


// 角度弧度
#define DegreesToRadian(x) (M_PI * (x) / 180.0)
#define RadianToDegrees(radian) (radian*180.0)/(M_PI)


// 沙盒目录文件
#define kPathTemp NSTemporaryDirectory()
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]


#endif /* CommonMacro_h */
