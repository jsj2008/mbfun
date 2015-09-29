//
//  SDiscoveryFlashSaleView.m
//  Wefafa
//
//  Created by unico_0 on 7/22/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryFlashSaleView.h"
#import "SDiscoveryShowTitleView.h"
#import "ShowAdvertisementView.h"
#import "SDiscoveryActivityShowCollectionViewCell.h"
#import "SDiscoveryFlexibleModel.h"
#import "SActivityListViewController.h"
#import "SUtilityTool.h"
#import "SProductDetailViewController.h"
#import "SActivityDiscountViewController.h"
#import "JSWebViewController.h"

@interface SDiscoveryFlashSaleView () <SDiscoveryShowTitleViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    long long int _endTime;
    NSTimer *showDateTimer;
    SDiscoveryShowTitleView *titleView;
    UIImageView * showLabelView;//title图标
    UIButton *buttonMore;
    UILabel *showTimeStateLabel;
    
}
@property (nonatomic, strong) ShowAdvertisementView *advertView;
@property (nonatomic, weak) UIView *showTimeContentView;
@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) NSArray *contentModelArray;

@end

static NSString *cellIdentifier = @"SDiscoveryActivityShowCollectionViewCellIdentifier";
@implementation SDiscoveryFlashSaleView

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
    titleView = [[SDiscoveryShowTitleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40) title:@"活动"];
    titleView.delegate = self;
    [self addSubview:titleView];
    
    _advertView = [[ShowAdvertisementView alloc]initWithFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, 115 )];
    _advertView.hidden = YES;
    [self addSubview:_advertView];
    
    [self addShowConditionView:CGRectMake(0, 160, UI_SCREEN_WIDTH, 44)];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 204, UI_SCREEN_WIDTH, 150) collectionViewLayout:layout];
    _contentCollectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentCollectionView];
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SDiscoveryActivityShowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
}

- (void)addShowConditionView:(CGRect)frame{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    _showTimeContentView = view;
     showLabelView=[[UIImageView alloc]initWithFrame:CGRectMake(15,15, 15, 15)];
    [showLabelView setImage:[UIImage imageNamed:@"Unico/count_down_red.png"]];
    [view addSubview:showLabelView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15+22, 0, 200, frame.size.height)];
    label.font = FONT_t6;
    label.text=@"倒计时";
    label.textColor = COLOR_C2;
    [view addSubview:label];
    
    showTimeStateLabel=[[UILabel alloc]initWithFrame:CGRectMake(85, 0, 200, frame.size.height)];
    showTimeStateLabel.font = FONT_T6;
    showTimeStateLabel.text=@"";
    showTimeStateLabel.textColor = COLOR_C12;
    [view addSubview:showTimeStateLabel];
    
    buttonMore =[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonMore setFrame:CGRectMake(UI_SCREEN_WIDTH - 150, 0, 145, 39.5)];
    
    [buttonMore addTarget:self action:@selector(touchMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    buttonMore.imageEdgeInsets = UIEdgeInsetsMake(0, 80, 0, 0);
    buttonMore.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [buttonMore setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    buttonMore.titleLabel.font = FONT_t7;
    [buttonMore setTitle:@"更多" forState:UIControlStateNormal];
    [buttonMore setTitleColor:COLOR_C6 forState:UIControlStateNormal];
    [buttonMore setImage:[UIImage imageNamed:@"Unico/right_arrow"] forState:UIControlStateNormal];
    [view addSubview:buttonMore];
}

- (void)setContentModel:(SDiscoveryFlexibleModel *)contentModel{
    _contentModel = contentModel;
    titleView.titleString=_contentModel.name;
    CGRect frame = _contentCollectionView.frame;
    CGRect timeFrame = _showTimeContentView.frame;
    if (contentModel.banner_list.count > 0) {
        _advertView.hidden = NO;
        _advertView.contentModelArray = contentModel.banner_list;
        timeFrame.origin.y = 40 + _advertView.height;
        frame.origin.y = 85 + _advertView.height;
    }else{
        _advertView.hidden = YES;
        timeFrame.origin.y = 40;
        frame.origin.y = 85;
    }
    _contentCollectionView.frame = frame;
    _showTimeContentView.frame = timeFrame;
    
    SActivityReceiveModel *activityModel = [contentModel.config firstObject];
    self.contentModelArray = activityModel.productList;
    
    [buttonMore setTitle:[Utils getSNSString:activityModel.name] forState:UIControlStateNormal];
    buttonMore.imageEdgeInsets = UIEdgeInsetsMake(0, 130, 0, 0);
    [self convertDate:activityModel.end_time];
}

- (void)setContentModelArray:(NSArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    [_contentCollectionView reloadData];
}

- (void)touchMoreButton:(id)sender{
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

- (void)showTitleTouchMoreButton:(UIButton*)sender{
    SActivityListViewController *controller = [SActivityListViewController new];
    [self.target.navigationController pushViewController:controller animated:YES];
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
    long long int current = [[NSDate date]timeIntervalSince1970];
    if (_endTime <= current) {
        showTimeStateLabel.text = @"活动已结束！";
            showTimeStateLabel.hidden=NO;
        [showLabelView setImage:[UIImage imageNamed:@"Unico/activity_clock.png"]];
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
    showTimeStateLabel.text = dateString;
}

#pragma mark - collectionview delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentModelArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryActivityShowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    SActivityProductListModel *model = _contentModelArray[indexPath.row];
    cell.contentModel = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(110.0, 150.0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SActivityProductListModel *model = _contentModelArray[indexPath.row];
    SProductDetailViewController *productVC = [[SProductDetailViewController alloc]init];
    productVC.productID = [NSString stringWithFormat:@"%@",model.product_sys_code];
     [self.target.navigationController pushViewController:productVC animated:YES];
    
}
@end
