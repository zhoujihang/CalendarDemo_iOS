//
//  LeftViewController.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/9/30.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "LeftViewController.h"
#import "BBCalendarViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"item1";
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    BBCalendarViewController *calendarVC = [[BBCalendarViewController alloc] init];
    [self.navigationController pushViewController:calendarVC animated:YES];
}

@end
