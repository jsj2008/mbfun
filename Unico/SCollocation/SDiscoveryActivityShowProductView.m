//
//  SDiscoveryActivityShowProductView.m
//  Wefafa
//
//  Created by unico_0 on 7/23/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryActivityShowProductView.h"
#import "SDiscoveryBannerModel.h"
#import "SDiscoveryActivityShowPlayerView.h"
#import "SActivityReceiveModel.h"
#import "SDiscoveryFlexibleModel.h"
#import "SDiscoveryShowTitleView.h"
#import "SActivityListViewController.h"
#import "MBAddShoppingViewController.h"
#import "SProductDetailViewController.h"
#import "SUtilityTool.h"

@interface SDiscoveryActivityShowProductView () <SDiscoveryShowTitleViewDelegate, SDiscoveryActivityShowPlayerViewDelegate>
{
    NSArray *_contentModelArray;
    SDiscoveryFlexibleModel *_contentModel;
    
    long long int _endTime;
    NSTimer *showDateTimer;
    SDiscoveryShowTitleView *titleView;
    BOOL _isActivityEnd;
}

@property (nonatomic, strong) ShowAdvertisementView *advertView;

@end

@implementation SDiscoveryActivityShowProductView
@synthesize contentModelArray = _contentModelArray;
@synthesize contentModel = _contentModel;

- (void)initSubViews{
    [super initSubViews];
    self.backgroundColor = [UIColor whiteColor];
    titleView = [[SDiscoveryShowTitleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40) title:@"限时折扣"];
    titleView.delegate = self;
    [self addSubview:titleView];
    
    _advertView = [[ShowAdvertisementView alloc]initWithFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, 115)];
    _advertView.hidden = YES;
    [self addSubview:_advertView];
    
    self.contentScrollView.frame = CGRectMake(0, 150, UI_SCREEN_WIDTH, 150);
    self.pageControl.currentPageIndicatorTintColor = COLOR_C1;
    self.pageControl.pageIndicatorTintColor = COLOR_C9;
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.contentScrollView.frame) + 10, UI_SCREEN_WIDTH, 15);
}

- (void)layoutSubviews{
    
}

#pragma mark 重置ImageView位置
- (void)resetScrollViewContentLocation{
    self.pageControl.currentPage = self.index;
    for (int i = 0; i < self.showPictureImageArray.count; i++) {
        NSInteger index = self.index - 1 + i;
        if (index < 0) {
            index = self.contentModelArray.count + index;
        }else if(index >= self.contentModelArray.count){
            index = index - self.contentModelArray.count;
        }
        SDiscoveryActivityShowPlayerView *activityView = self.showPictureImageArray[i];
        MBGoodsDetailsModel *currentModel = self.contentModelArray[index];
        activityView.contentModel = currentModel;
    }
    self.contentScrollView.contentOffset = CGPointMake(UI_SCREEN_WIDTH, 0);
}

- (void)scrollViewAddContentView{
    self.showPictureImageArray = [NSMutableArray array];
    CGRect rect = self.contentScrollView.bounds;
    rect.size.height = 150;
    for (int i = 0; i < 3; i++) {
        rect.origin.x = i * UI_SCREEN_WIDTH;
        SDiscoveryActivityShowPlayerView *activityView = [[SDiscoveryActivityShowPlayerView alloc]initWithFrame:rect];
        activityView.delegate = self;
        [self.contentScrollView addSubview:activityView];
        [self.showPictureImageArray addObject:activityView];
    }
    self.contentScrollView.contentOffset = CGPointMake(UI_SCREEN_WIDTH, 0);
}

- (void)setContentModel:(SDiscoveryFlexibleModel *)contentModel{
    _contentModel = contentModel;
    titleView.titleString=_contentModel.name;
    
    CGRect frame = self.contentScrollView.frame;
    if (contentModel.banner_list.count > 0) {
        _advertView.hidden = NO;
        _advertView.contentModelArray = contentModel.banner_list;
        frame.origin.y = 40 + _advertView.height;
    }else{
        _advertView.hidden = YES;
        frame.origin.y = 40;
    }
    self.contentScrollView.frame = frame;
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.contentScrollView.frame) + 10, UI_SCREEN_WIDTH, 20);
    SActivityReceiveModel *activityModel = [contentModel.config firstObject];
    self.contentModelArray = activityModel.productList;
    [self convertDate:activityModel.end_time];
}

- (void)convertDate:(NSString*)string{
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:string];
    _endTime = [date timeIntervalSince1970];
    if (showDateTimer) {
        [showDateTimer invalidate];
    }
    showDateTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(showDate:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:showDateTimer forMode:NSRunLoopCommonModes];
    [showDateTimer fire];
}

- (void)showDate:(NSTimer*)timer{
    long long int current = [[NSDate date] timeIntervalSince1970];
    if (_endTime <= current) {
        _isActivityEnd = YES;
        [timer invalidate];
        timer = nil;
        for (SDiscoveryActivityShowPlayerView *activityView in self.showPictureImageArray) {
            activityView.surplusTimeString = @"";
        }
        return;
    }
    NSMutableString *dateString = [NSMutableString stringWithString:@""];
    NSDate *date =[NSDate dateWithTimeIntervalSince1970:_endTime];
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendarstart = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendarstart components:NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit|NSYearCalendarUnit fromDate:currentDate  toDate:date options:0];
    if (dateComponents.year > 0){
        [dateString appendFormat:@"%d年", abs((int)dateComponents.year)];
    }
    if (dateComponents.day > 0) {
        [dateString appendFormat:@"%d天 ", (int)dateComponents.day];
    }
    [dateString appendFormat:@"%02d时%02d分%02d秒", (int)dateComponents.hour, (int)dateComponents.minute, (int)dateComponents.second];
    for (SDiscoveryActivityShowPlayerView *activityView in self.showPictureImageArray) {
        activityView.surplusTimeString = dateString;
    }
}

- (void)setContentModelArray:(NSArray *)contentModelArray{
    if (contentModelArray.count > 5) {
        contentModelArray = [contentModelArray subarrayWithRange:NSMakeRange(0, 5)];
    }
    _contentModelArray = contentModelArray;
    
    if (contentModelArray == nil || contentModelArray.count == 0) {
        self.contentScrollView.scrollEnabled = NO;
        [self.timer invalidate];
        return;
    }else if(contentModelArray.count == 1){
        self.pageControl.hidden = YES;
        if (self.timer) {
            [self.timer invalidate];
        }
    }else{
        if (!self.timer) {
            [self startTimer];
        }
        self.pageControl.hidden = NO;
    }
    self.index = 0;
    self.pageControl.numberOfPages = contentModelArray.count;
    [self resetScrollViewContentLocation];
    if (contentModelArray.count <= 1) {
        self.contentScrollView.scrollEnabled = NO;
    }else{
        self.contentScrollView.scrollEnabled = YES;
    }
    NSDate *date = [NSDate dateWithTimeInterval:5.0 sinceDate:[NSDate date]];
    [self.timer setFireDate:date];
}

- (void)showTitleTouchMoreButton:(UIButton*)sender{
    SActivityListViewController *controller = [SActivityListViewController new];
    [self.target.navigationController pushViewController:controller animated:YES];
}

- (void)activityGoodsBuyNow:(UIButton *)button model:(SActivityProductListModel *)model{
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    SActivityReceiveModel *activityModel = [_contentModel.config firstObject];
    MBAddShoppingViewController *controller = [[MBAddShoppingViewController alloc]initWithNibName:@"MBAddShoppingViewController" bundle:nil];
    controller.fromControllerName = [NSString stringWithFormat:@"首页 or 发现 配置活动:%@", activityModel.name];
    controller.promotion_ID = [NSString stringWithFormat:@"%@",activityModel.json];
    controller.showType = typeBuyNow;
    controller.itemAry =@[model.product_sys_code];
    [self.target.navigationController pushViewController:controller animated:YES];
}

- (void)activityGoodsTouchContentImage:(UIImageView *)imageView model:(SActivityProductListModel *)model{
    SActivityReceiveModel *activityModel = [_contentModel.config firstObject];
    SProductDetailViewController *controller = [SProductDetailViewController new];
    controller.productID = model.product_sys_code;
    controller.promotion_ID =[NSString stringWithFormat:@"%@", activityModel.idStr];
    [self.target.navigationController pushViewController:controller animated:YES];
}

@end
