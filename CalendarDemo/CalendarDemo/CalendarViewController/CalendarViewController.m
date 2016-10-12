//
//  CalendarViewController.m
//  CalendarDemo
//
//  Created by zhoujihang on 16/9/29.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarView.h"
#import <Masonry/Masonry.h>
#import "CalendarNavBarView.h"

@interface CalendarViewController () <UITableViewDelegate, UITableViewDataSource, CalendarViewDelegate, CalendarNavBarViewDelegate>

@property (nonatomic, weak) CalendarNavBarView *s_NavBarView;
@property (nonatomic, weak) UIScrollView *s_BackdropScrollView;
@property (nonatomic, weak) CalendarView *s_CalendarView;
@property (nonatomic, weak) UITableView *s_remindTableView;
// 当 tableview 内容高度不足够高导致周视图无法完全覆盖月视图时，用此视图填充高度
@property (nonatomic, weak) UIView *s_BottomPaddingView;

@property (nonatomic, strong) MASConstraint *s_CalendarViewTopConstraint;
@property (nonatomic, strong) MASConstraint *s_RemindTableViewHeightConstraint;
@property (nonatomic, strong) MASConstraint *s_BottomPaddingViewHeightConstraint;
@property (nonatomic, assign) NSInteger s_RowNumber;
@end

@implementation CalendarViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)dealloc{
    self.s_BackdropScrollView.delegate = nil;
    NSLog(@"%s", __func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.s_RowNumber = 5;
    [self setupViews];
    [self setupConstraints];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.s_NavBarView];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
#warning message 模拟数据加载
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.s_RowNumber = 10;
        [self reloadRemindTableViewData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.s_RowNumber = 40;
            [self reloadRemindTableViewData];
        });
    });
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self updateRemindTableViewConstraints];
}

- (void)setupViews{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBarView];
    
    UIScrollView *backdropScrollView = [[UIScrollView alloc] init];
    backdropScrollView.delegate = self;
    backdropScrollView.backgroundColor = [UIColor whiteColor];
    backdropScrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    backdropScrollView.alwaysBounceVertical = YES;
    backdropScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:backdropScrollView];
    self.s_BackdropScrollView = backdropScrollView;
    
    UITableView *remindTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    remindTableView.delegate = self;
    remindTableView.dataSource = self;
    remindTableView.showsVerticalScrollIndicator = NO;
    [self.s_BackdropScrollView addSubview:remindTableView];
    self.s_remindTableView = remindTableView;
    
    UIView *bottomPaddingView = [[UIView alloc] init];
    bottomPaddingView.backgroundColor = [UIColor clearColor];
    [self.s_BackdropScrollView addSubview:bottomPaddingView];
    self.s_BottomPaddingView = bottomPaddingView;
    
    CalendarView *calendarView = [[CalendarView alloc] init];
    calendarView.m_Delegate = self;
    [self.s_BackdropScrollView addSubview:calendarView];
    self.s_CalendarView = calendarView;
}
- (void)setupNavigationBarView{
    CalendarNavBarView *navBarView = [[CalendarNavBarView alloc] init];
    navBarView.m_Delegate = self;
    [self.view addSubview:navBarView];
    self.s_NavBarView = navBarView;
    
    [self.s_NavBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
    }];
}
- (void)setupConstraints{
    [self.s_BackdropScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [self.s_CalendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.s_BackdropScrollView);
        make.centerX.equalTo(self.s_BackdropScrollView);
        self.s_CalendarViewTopConstraint = make.top.equalTo(self.s_BackdropScrollView);
    }];
    CGFloat calendarViewHeight = [self.s_CalendarView intrinsicContentSize].height;
    [self.s_remindTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.s_BackdropScrollView);
        make.centerX.equalTo(self.s_BackdropScrollView);
        make.top.equalTo(self.s_BackdropScrollView).offset(calendarViewHeight);
        self.s_RemindTableViewHeightConstraint = make.height.equalTo(@0);
    }];
    [self.s_BottomPaddingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.s_remindTableView.mas_bottom);
        make.left.right.bottom.equalTo(self.s_BackdropScrollView);
        self.s_BottomPaddingViewHeightConstraint = make.height.equalTo(@0);
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 控制日历视图本身的偏移，控制日历内部周视图的偏移
    if (scrollView == self.s_BackdropScrollView) {
        // 由于滚动的不连续性，每次都要纠正偏移位置
        CGPoint offset = scrollView.contentOffset;
        CGFloat topInset = scrollView.contentInset.top;
        if (offset.y <= -topInset) {
            // 到顶部时控制不让下滑
            scrollView.contentOffset = CGPointMake(0, -topInset);
            
            // 纠正星期名称控件的顶部偏移
            self.s_CalendarView.m_WeekNameViewTopOffset = 0;
            return;
        }
        
        CGFloat beginOffsetY = -topInset;
        CGFloat calendarViewHiddenHeight = [self.s_CalendarView intrinsicContentSize].height-self.s_CalendarView.m_MinHeight;
        CGFloat endOffsetY = beginOffsetY + calendarViewHiddenHeight;
        if (offset.y> beginOffsetY && offset.y <= endOffsetY) {
            // 修改星期名称控件的顶部偏移
            CGFloat weekNameViewTopOffset = offset.y - beginOffsetY;
            self.s_CalendarView.m_WeekNameViewTopOffset = weekNameViewTopOffset;
            
            // 纠正日历视图本身的偏移
            self.s_CalendarViewTopConstraint.offset = 0;
            [self.s_BackdropScrollView updateConstraintsIfNeeded];
             [self.s_BackdropScrollView layoutIfNeeded];
            return;
        }
        
        if (offset.y > endOffsetY) {
            // 修改日历视图本身的偏移
            CGFloat calendarViewTopOffset = offset.y - endOffsetY;
            self.s_CalendarViewTopConstraint.offset = calendarViewTopOffset;
            [self.s_BackdropScrollView updateConstraintsIfNeeded];
            [self.s_BackdropScrollView layoutIfNeeded];
            
            // 纠正星期名称控件的顶部偏移
            self.s_CalendarView.m_WeekNameViewTopOffset = calendarViewHiddenHeight;
            return;
        }
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    // 控制滑动终结位置，让月视图完全显示或者完全被周视图覆盖
    CGFloat targetOffsetY = (*targetContentOffset).y;
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    if (scrollView == self.s_BackdropScrollView) {
        CGFloat topInset = scrollView.contentInset.top;
        CGFloat beginOffsetY = -topInset;
        CGFloat endOffsetY = beginOffsetY + ([self.s_CalendarView intrinsicContentSize].height - self.s_CalendarView.m_MinHeight);
        CGFloat centerOffsetY = (endOffsetY+beginOffsetY)*0.4;
        
        if (targetOffsetY <= endOffsetY) {
            // 目标位置在月历范围内
            *targetContentOffset = CGPointMake(0, endOffsetY);
            if (currentOffsetY <= endOffsetY) {
                // 当前位置也在月历范围内
                if (targetOffsetY < centerOffsetY) {
                    *targetContentOffset = CGPointMake(0, beginOffsetY);
                }
            }
        }else{
            // 目标位置超出了月历范围
            if (currentOffsetY <= endOffsetY) {
                // 当前位置还在月历范围内
                *targetContentOffset = CGPointMake(0, endOffsetY);
            }
        }
        currentOffsetY = scrollView.contentOffset.y;
        targetOffsetY = (*targetContentOffset).y;
    }
}

// 每次对remindtableview做reload之后都需要做约束的更新
- (void)reloadRemindTableViewData{
    [self.s_remindTableView reloadData];
    [self updateRemindTableViewConstraints];
}
- (void)updateRemindTableViewConstraints{
    // 下一个runloop取contentSize比较保险
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat calendarMinHeight = self.s_CalendarView.m_MinHeight;
        CGSize remindTableViewContentSize = self.s_remindTableView.contentSize;
        CGFloat bottomPadding = [UIScreen mainScreen].bounds.size.height - 64 - calendarMinHeight - remindTableViewContentSize.height;
        bottomPadding = bottomPadding>=0 ? bottomPadding : 0;
        // 根据tableview内容高度修改其frame高度约束
        self.s_RemindTableViewHeightConstraint.equalTo(@(remindTableViewContentSize.height));
        self.s_BottomPaddingViewHeightConstraint.equalTo(@(bottomPadding));
        
        [self.s_BackdropScrollView updateConstraintsIfNeeded];
        [self.s_BackdropScrollView layoutIfNeeded];
    });
}
#pragma mark - 逻辑方法

#pragma mark - tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.s_RowNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld,%ld",(long)indexPath.section,(long)indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"tap:%@",indexPath);
}

#pragma makr - CalendarNavBarView代理方法
- (void)calendarNavBarViewDidClickBackBtn:(CalendarNavBarView *)view{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)calendarNavBarViewDidClickTodayBtn:(CalendarNavBarView *)view{
    [self.s_CalendarView jumpToToday];
}
- (void)calendarNavBarViewDidClickRightBtn:(CalendarNavBarView *)view{
    CLog(@"添加提醒");
}
- (void)calendarNavBarViewDidClickTitle:(CalendarNavBarView *)titleView{
    CLog(@"弹出滚筒");
}
- (void)calendarNavBarViewDidClickTitleLeftBtn:(CalendarNavBarView *)titleView{
    [self.s_CalendarView scrollToLeftMonth];
}
- (void)calendarNavBarViewDidClickTitleRightBtn:(CalendarNavBarView *)titleView{
    [self.s_CalendarView scrollToRightMonth];
}
#pragma mark - CalendarView代理方法
- (void)calendarView:(CalendarView *)view didClickWithDateComponents:(NSDateComponents *)dateComponents{
    CLog(@"点击：%@", dateComponents);
    NSString *currentYear = [NSString stringWithFormat:@"%ld", dateComponents.year];
    NSString *currentMonth = [NSString stringWithFormat:@"%ld", dateComponents.month];
    NSString *title = [NSString stringWithFormat:@"%@年%@月", currentYear, currentMonth];
    self.s_NavBarView.m_TitleString = title;
}


@end
