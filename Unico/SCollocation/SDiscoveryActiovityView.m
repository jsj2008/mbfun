//
//  SDiscoveryActiovityView.m
//  Wefafa
//
//  Created by unico_0 on 7/10/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryActiovityView.h"
#import "SDiscoveryShowTitleView.h"
#import "ShowAdvertisementView.h"
#import "SDiscoveryFlexibleModel.h"
#import "SActivityReceiveModel.h"
#import "SActivityListViewController.h"
#import "SActivityDiscountViewController.h"
#import "SProductDetailViewController.h"
#import "JSWebViewController.h"
#import "SUtilityTool.h"
#import "Utils.h"

@interface SDiscoveryActiovityView ()<SDiscoveryShowTitleViewDelegate>
{
    long long int _endTime;
    NSTimer *showDateTimer;
    SDiscoveryShowTitleView *titleView;
}

@property (nonatomic, strong) ShowAdvertisementView *advertView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *countDown;
@property (nonatomic, strong) UIButton *showStateButton;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation SDiscoveryActiovityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    self.backgroundColor = [UIColor whiteColor];
    titleView = [[SDiscoveryShowTitleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40) title:@"限时折扣"];
    titleView.delegate = self;
    [self addSubview:titleView];
    
    _advertView = [[ShowAdvertisementView alloc]initWithFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, 115)];
    _advertView.hidden = YES;
    [self addSubview:_advertView];
    
    _countDown = [[UIView alloc]initWithFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, 40)];
    [self addSubview:_countDown];
    [self initCountDownView];
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, UI_SCREEN_WIDTH, 234.0 * UI_SCREEN_WIDTH/ 375.0)];
    [self addSubview:_contentView];
    [self initContentView];
}

- (void)setTarget:(UIViewController *)target{
    _target = target;
    _advertView.target = target;
}

- (void)initCountDownView{
    CGRect frame = CGRectMake(15.0 * UI_SCREEN_WIDTH/ 375.0, 0, 100, 40);
    _showStateButton = [[UIButton alloc]initWithFrame:frame];
    _showStateButton.userInteractionEnabled = NO;
    [_showStateButton setImage:[UIImage imageNamed:@"Unico/count_down_red.png"] forState:UIControlStateNormal];
    [_showStateButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_showStateButton setTitle:@"倒计时" forState:UIControlStateNormal];
    _showStateButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [_showStateButton setTitleColor:COLOR_C2 forState:UIControlStateNormal];
    _showStateButton.titleLabel.font = FONT_t6;
    [_countDown addSubview:_showStateButton];
    
    frame.origin.x = 80;
    frame.size.width = 150;
    _dateLabel = [[UILabel alloc]initWithFrame:frame];
    _dateLabel.font = FONT_T6;
    _dateLabel.textColor = COLOR_C10;
    [_countDown addSubview:_dateLabel];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 70, 0, 60, 39.5)];
    [button addTarget:self action:@selector(activityMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    button.contentHorizontalAlignment = UIViewContentModeRight;
    button.titleLabel.font = FONT_t7;
    [button setTitle:@"更多" forState:UIControlStateNormal];
    [button setTitleColor:COLOR_C6 forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"Unico/right_arrow"] forState:UIControlStateNormal];
    [_countDown addSubview:button];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 39.5, UI_SCREEN_WIDTH, 0.5);
    layer.backgroundColor = COLOR_C9.CGColor;
    [_countDown.layer addSublayer:layer];
}

- (void)initContentView{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentShowViewTap:)];
    CGFloat scale = UI_SCREEN_WIDTH/ 375.0;
    SDiscoveryActiovityContentView *firstView = [[SDiscoveryActiovityContentView alloc]initWithFrame:CGRectMake(0, 0, 141 * scale, _contentView.frame.size.height)];
    firstView.contentImageView.frame = CGRectMake(0, 30 * scale, 141 * scale, 141 * scale);
    firstView.titleLabel.frame = CGRectMake(10, CGRectGetMaxY(firstView.contentImageView.frame) + 10, 141 * scale - 20, 20);
    firstView.tag = 140;
    [firstView addGestureRecognizer:tap];
    [_contentView addSubview:firstView];
    int columnCount = 2;
    for (int i = 0; i < 4; i ++) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentShowViewTap:)];
        SDiscoveryActiovityContentView *view = [[SDiscoveryActiovityContentView alloc]initWithFrame:CGRectMake((i % columnCount) * (117 * scale) + CGRectGetMaxX(firstView.frame), (i / columnCount) * (_contentView.frame.size.height/ 2.0), 117 * scale, _contentView.frame.size.height/ 2.0)];
        view.tag = 141 + i;
        [view addGestureRecognizer:tap];
        [_contentView addSubview:view];
    }
}

- (void)setContentModel:(SDiscoveryFlexibleModel *)contentModel{
    _contentModel = contentModel;
    titleView.titleString = _contentModel.name;
    
    CGRect frame = _contentView.frame;
    CGRect countDownFrame = _countDown.frame;
    if (contentModel.banner_list.count > 0) {
        _advertView.hidden = NO;
        _advertView.contentModelArray = contentModel.banner_list;
        countDownFrame.origin.y = 40 + _advertView.height;
        frame.origin.y = 80 + _advertView.height;
    }else{
        _advertView.hidden = YES;
        countDownFrame.origin.y = 40;
        frame.origin.y = 80;
    }
    _contentView.frame = frame;
    _countDown.frame = countDownFrame;
    
    SActivityReceiveModel *activityModel = [contentModel.config firstObject];
    self.contentModelArray = activityModel.productList;
    [self convertDate:activityModel.end_time];
}

- (void)setContentModelArray:(NSArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    for (int i = 0; i < MIN(_contentView.subviews.count, contentModelArray.count); i++) {
        SDiscoveryActiovityContentView *view = _contentView.subviews[i];
        SActivityProductListModel *model = contentModelArray[i];
        [view.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.product_url]];
        view.titleLabel.text = [Utils getSNSRMBMoney:[NSString stringWithFormat:@"%f    ", model.price.floatValue]];
    }
}

#pragma mark - title delegate
- (void)showTitleTouchMoreButton:(UIButton*)sender{
    SActivityListViewController *controller = [SActivityListViewController new];
    [_target.navigationController pushViewController:controller animated:YES];
}

- (void)activityMoreButton:(UIButton*)sender{
    SActivityReceiveModel *activityModel = [_contentModel.config firstObject];
    if (activityModel.web_url && activityModel.web_url.length > 0) {
        JSWebViewController *webCV= [[JSWebViewController alloc] initWithUrl:activityModel.web_url];
        webCV.isPayResult = YES;
        [_target.navigationController pushViewController:webCV animated:YES];
        return;
    }
    SActivityDiscountViewController *controller = [SActivityDiscountViewController new];
    controller.activityID = activityModel.idStr;
    [_target.navigationController pushViewController:controller animated:YES];
}

- (void)contentShowViewTap:(UITapGestureRecognizer*)tap{
    NSInteger index = tap.view.tag - 140;
    if (index >= _contentModelArray.count) return;
    SActivityProductListModel *model = _contentModelArray[index];
    SProductDetailViewController *controller = [SProductDetailViewController new];
    controller.productID = model.product_sys_code;
    SActivityReceiveModel *activityModel = [_contentModel.config firstObject];
    controller.promotion_ID = activityModel.json;
    [_target.navigationController pushViewController:controller animated:YES];
}

- (void)showDate:(NSTimer*)timer{
    long long int current = [[NSDate date]timeIntervalSince1970];
    if (_endTime <= current) {
        _dateLabel.text = @"";
        [_showStateButton setTitle:@"活动已结束！" forState:UIControlStateNormal];
        [_showStateButton setImage:[UIImage imageNamed:@"Unico/activity_clock.png"] forState:UIControlStateNormal];
        [timer invalidate];
        timer = nil;
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
    [dateString appendFormat:@"%02d: %02d: %02d", (int)dateComponents.hour, (int)dateComponents.minute, (int)dateComponents.second];
    _dateLabel.text = dateString;
    [_showStateButton setImage:[UIImage imageNamed:@"Unico/count_down_red.png"] forState:UIControlStateNormal];
    [_showStateButton setTitle:@"倒计时" forState:UIControlStateNormal];
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

@end

@implementation SDiscoveryActiovityContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat scale = UI_SCREEN_WIDTH/ 375.0;
        self.backgroundColor = [UIColor whiteColor];
        _contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width - 20 * scale, frame.size.width - 20 * scale)];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        _contentImageView.center = CGPointMake(frame.size.width/ 2, frame.size.height/ 2 - 10 * scale);
        [self addSubview:_contentImageView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentImageView.frame), frame.size.width, 20)];
        _titleLabel.textColor = COLOR_C2;
        _titleLabel.font = FONT_t4;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        CALayer *rightLayer = [CALayer layer];
        rightLayer.backgroundColor = COLOR_C9.CGColor;
        rightLayer.zPosition = 5;
        rightLayer.frame = CGRectMake(self.width - 0.5, 0, 0.5, self.height);
        [self.layer addSublayer:rightLayer];
        
        CALayer *bottomLayer = [CALayer layer];
        bottomLayer.backgroundColor = COLOR_C9.CGColor;
        bottomLayer.zPosition = 5;
        bottomLayer.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
        [self.layer addSublayer:bottomLayer];
    }
    return self;
}

@end
