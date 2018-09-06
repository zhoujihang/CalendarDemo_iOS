//
//  CalendarDemoTests.m
//  CalendarDemoTests
//
//  Created by 周际航 on 2018/9/5.
//  Copyright © 2018年 zhoujihang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BBCalendarTool.h"

@interface CalendarDemoTests : XCTestCase

@end

@implementation CalendarDemoTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
}

- (void)testPerformanceExample {
    
    [self measureBlock:^{
    }];
}

- (void)testCalendarTool_guoqingjie {
    NSDateComponents *date = [self date2019_10_01];
    NSString *dateName = [BBCalendarTool chineseHolidayNameOfGregorianDateComponents:date];
    NSLog(@"zjh date:%@  dateName:%@", date, dateName);
    NSAssert(dateName.length > 0, @"2019-10-01未成功识别为国家法定节假日");
    NSAssert([dateName isEqualToString:@"国庆节"], @"2019-10-01未成功识别为国庆节");
}

- (void)testCalendarTool_noHoliday {
    NSDateComponents *date = [self date2019_10_02];
    NSString *dateName = [BBCalendarTool chineseHolidayNameOfGregorianDateComponents:date];
    NSLog(@"zjh date:%@  dateName:%@", date, dateName);
    NSAssert(dateName.length == 0, @"2019-10-02并非为国家法定节假日");
    NSAssert(![dateName isEqualToString:@"国庆节"], @"2019-10-02并非为国庆节");
}

//- (void)testCalendarTool_inRange_error {
//    NSDateComponents *date = [self date2019_10_01 ];
//    BOOL isValidate = [BBCalendarTool isValidatedDateComponents:date];
//    NSAssert(!isValidate, @"zjh date:%@ 应判定为在 1970-01-01, 2070-12-30 范围之内", date);
//}
- (void)testCalendarTool_inRange {
    NSDateComponents *date = [self date2019_10_01 ];
    BOOL isValidate = [BBCalendarTool isValidatedDateComponents:date];
    NSAssert(isValidate, @"zjh date:%@ 应判定为在 1970-01-01, 2070-12-30 范围之内", date);
}
- (void)testCalendarTool_outOfRange {
    NSDateComponents *date = [self date2100_10_01];
    BOOL isValidate = [BBCalendarTool isValidatedDateComponents:date];
    NSAssert(!isValidate, @"zjh date:%@ 应判定为在 1970-01-01, 2070-12-30 范围之外", date);
}

- (NSDateComponents *)date2019_10_01 {
    NSDateComponents *date = [[NSDateComponents alloc] init];
    date.year = 2019;
    date.month = 10;
    date.day = 01;
    return date;
}
- (NSDateComponents *)date2019_10_02 {
    NSDateComponents *date = [[NSDateComponents alloc] init];
    date.year = 2019;
    date.month = 10;
    date.day = 02;
    return date;
}
- (NSDateComponents *)date2100_10_01 {
    NSDateComponents *date = [[NSDateComponents alloc] init];
    date.year = 2100;
    date.month = 10;
    date.day = 01;
    return date;
}

@end
