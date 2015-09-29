//
//  SDiscoveryHeaderTableView.m
//  Wefafa
//
//  Created by Jiang on 8/13/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryHeaderTableView.h"
#import "SDiscoveryFlexibleModel.h"
#import "ShowAdvertisementView.h"
#import "SRecommendCollocationCollectionView.h"
#import "SDiscoveryShowBannerTableView.h"
#import "SDiscoveryShowTopicView.h"
#import "SDiscoveryTodayFanView.h"
#import "SDesignerShowCollectionView.h"
#import "SDiscoveryBrandCollectionView.h"
#import "SDiscoveryProductCollectionView.h"
#import "SHeaderTitleView.h"
#import "SDiscoveryShowTitleView.h"
#import "SDiscoveryMenuCollectionView.h"
#import "SDiscoveryActiovityView.h"
#import "SDiscoveryFlashSaleView.h"
#import "SDiscoveryActivityShowProductView.h"
#import "SDiscoveryBrandZoneCollectionView.h"
#import "SDiscoverShowBigPicAndTitleView.h"//自由
#import "SDiscoveryShowConfigPicAndTextView.h"
#import "SDiscoveryBannerModel.h"
#import "SDiscoveryHeaderMoudleTool.h"

@interface SDiscoveryHeaderTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SDiscoveryHeaderTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        self.scrollEnabled = NO;
    }
    return self;
}

- (void)awakeFromNib{
    [self initSubViews];
}

- (void)initSubViews{
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.delegate = self;
    self.dataSource = self;
    self.tableFooterView = [UIView new];
}

#pragma mark - set and get
- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    [self reloadData];
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryFlexibleModel *model = _contentArray[indexPath.row];
    return [SDiscoveryHeaderMoudleTool getHeaderCellHeightWithModel:model];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryFlexibleModel *model = _contentArray[indexPath.row];
    int type = [model.type intValue];
    NSString *identifier = [NSString stringWithFormat:@"SDiscoveryFlexibleCell_%d", type];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.backgroundColor = UIColorFromRGB(0xf2f2f2);
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:[SDiscoveryHeaderMoudleTool cellContentViewWithModel:model]];
    }
    UIView *contentView = [cell viewWithTag:666];
    if (contentView) {
        contentView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, [SDiscoveryHeaderMoudleTool getHeaderCellHeightWithModel:model]);
        if ([contentView respondsToSelector:@selector(setTarget:)]) {
            [contentView setValue:_target forKey:@"target"];
        }
        if ([contentView respondsToSelector:@selector(setContentModel:)]) {
            [contentView setValue:model forKey:@"contentModel"];
        }
    }
    return cell;
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.tableDelegate respondsToSelector:@selector(tableScrollViewDidScroll:)]) {
        [self.tableDelegate tableScrollViewDidScroll:self];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self.tableDelegate respondsToSelector:@selector(tableBeginScroll:)]) {
        [self.tableDelegate tableBeginScroll:self];
    }
}

@end
