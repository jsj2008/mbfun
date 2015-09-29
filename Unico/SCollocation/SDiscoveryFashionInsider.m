//
//  SDiscoveryFashionInsider.m
//  Wefafa
//
//  Created by Mr_J on 15/8/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SDiscoveryFashionInsider.h"
#import "SDiscoveryShowTitleView.h"
#import "ShowAdvertisementView.h"
#import "SDiscoveryFlexibleModel.h"
#import "SDiscoverShowBigPicAndTitleView.h"
#import "SStarStoreTableViewCell.h"
#import "SDesignerViewController.h"

#import "CommunityHotTableViewCell.h"

@interface SDiscoveryFashionInsider () <SDiscoveryShowTitleViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ShowAdvertisementView *advertView;
@property (nonatomic, strong) SDiscoveryShowTitleView *titleView;
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) NSArray *contentArray;

@end

@implementation SDiscoveryFashionInsider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    _titleView = [[SDiscoveryShowTitleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40) title:@"时尚达人"];
    _titleView.delegate = self;
    [self addSubview:_titleView];
    
    _advertView = [[ShowAdvertisementView alloc]initWithFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, 115)];
    _advertView.hidden = YES;
    [self addSubview:_advertView];
    
    _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, 20)];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.layer.masksToBounds = YES;
    _contentTableView.scrollEnabled = NO;
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    [self addSubview:_contentTableView];
    [_contentTableView registerNib:[UINib nibWithNibName:@"CommunityHotTableViewCell" bundle:nil] forCellReuseIdentifier:communityHotTableViewCellID];
}

- (void)setTarget:(UIViewController *)target{
    _target = target;
    _advertView.target = _target;
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    CGFloat compareWidth = (UI_SCREEN_WIDTH-30)/2;
    CGFloat bigRitio = 16.0/9;
    CGFloat height = (71 + compareWidth * bigRitio) * contentArray.count;
    height -= contentArray.count > 0? 5: 0;
    _contentTableView.height = height;
    [_contentTableView reloadData];
}

- (void)setContentModel:(SDiscoveryFlexibleModel *)contentModel{
    _contentModel = contentModel;
    CGRect frame = _contentTableView.frame;
    if (contentModel.banner_list.count > 0) {
        _advertView.hidden = NO;
        _advertView.contentModelArray = contentModel.banner_list;
        frame.origin.y = 40 + _advertView.height;
    }else{
        _advertView.hidden = YES;
        frame.origin.y = 40;
    }
    _contentTableView.frame = frame;
    self.titleView.titleString = contentModel.name;
    self.contentArray = contentModel.config;
}

- (void)showTitleTouchMoreButton:(UIButton *)sender{
    SDesignerViewController *controller = [SDesignerViewController new];
    [self.target.navigationController pushViewController:controller animated:YES];
}

#pragma mark - delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contentArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat compareWidth = (UI_SCREEN_WIDTH-30)/2;
//    CGFloat bigRitio = 16.0/ 9;
//    return 71 + compareWidth * bigRitio;
    CGFloat height = 0;
    height = 377*UI_SCREEN_WIDTH / 375;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellIdentifier = @"SBrandCell";
//    SStarStoreTableViewCell *cell = (SStarStoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (!cell) {
//        cell = [[SStarStoreTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
//    }
//    cell.parentVc = self.target;
//    SStarStoreCellModel * model = (SStarStoreCellModel*)_contentArray[indexPath.row];
//    [cell updateStarCellModel:model andIndex:(indexPath)];
//    return cell;
    CommunityHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:communityHotTableViewCellID forIndexPath:indexPath];
    cell.parentVC = self.target;
    SStarStoreCellModel *model = _contentArray[indexPath.row];//[_dataArray[indexPath.section] objectAtIndex:indexPath.row];
    [cell model:model parentVC:self.target indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
