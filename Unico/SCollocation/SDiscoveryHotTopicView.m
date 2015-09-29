//
//  SDiscoveryHotTopicView.m
//  Wefafa
//
//  Created by Mr_J on 15/8/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SDiscoveryHotTopicView.h"
#import "SDiscoveryShowTitleView.h"
#import "ShowAdvertisementView.h"
#import "STopicListTableViewCell.h"
#import "SDiscoveryFlexibleModel.h"
#import "STopicDetailViewController.h"
#import "StopicListModel.h"
#import "STopicViewController.h"
#import "CommunityHotCollectionViewTableCell.h"
#import "SUtilityTool.h"
#import "SCollocationDetailViewController.h"
#import "SCollocationDetailNoneShopController.h"

@interface SDiscoveryHotTopicView ()<UITableViewDataSource, UITableViewDelegate, SDiscoveryShowTitleViewDelegate, STopicListTableViewCellDelegate>

@property (nonatomic, strong) ShowAdvertisementView *advertView;
@property (nonatomic, strong) SDiscoveryShowTitleView *titleView;
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) NSArray *contentArray;

@end

static NSString *cellIdentifier = @"CommunityHotCollectionViewTableCellIdentifier";
@implementation SDiscoveryHotTopicView

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
    _titleView = [[SDiscoveryShowTitleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40) title:@"热门话题"];
    _titleView.delegate = self;
    [self addSubview:_titleView];
    
    _advertView = [[ShowAdvertisementView alloc]initWithFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, 115)];
    _advertView.hidden = YES;
    [self addSubview:_advertView];
    
    _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, 20)];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.backgroundColor = COLOR_C4;
    [_contentTableView registerNib:[UINib nibWithNibName:@"CommunityHotCollectionViewTableCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    _contentTableView.layer.masksToBounds = YES;
    _contentTableView.scrollEnabled = NO;
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    [self addSubview:_contentTableView];
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

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    _contentTableView.height = contentArray.count * 200;
    [_contentTableView reloadData];
}

#pragma mark - delegate
- (void)showTitleTouchMoreButton:(UIButton*)sender{
    STopicViewController *controller = [STopicViewController new];
    [_target.navigationController pushViewController:controller animated:YES];
}

#pragma mark touche action
- (void)topicTouchNextAction:(UIButton *)button contentModel:(StopicListModel *)model{
    STopicDetailViewController *controller = [[STopicDetailViewController alloc]init];
    controller.topicID = model.aID;
    controller.titleName = model.name;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.target.navigationItem.backBarButtonItem = backItem;
    [self.target.navigationController pushViewController:controller animated:YES];
}

#pragma mark tabledelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommunityHotCollectionViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.jumpBlock = ^(StopicListModel*model){
        //话题详情
        STopicDetailViewController *controller = [[STopicDetailViewController alloc]init];
        controller.topicID = model.aID;
        controller.titleName = model.name;
        [self.target.navigationController pushViewController:controller animated:YES];
    };
    cell.jumpToCollBlock = ^(StopicListContentModel*model){
        //FIXME:根据详情跳转规则跳转
        //搭配详情
        extern BOOL g_socialStatus;
        if (g_socialStatus)//是否处于社交状态
        {
            SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
            detailNoShoppingViewController.collocationId = model.aID;
            [self.target.navigationController pushViewController:detailNoShoppingViewController animated:YES];
        }
        else
        {
            SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
            collocationDetailVC.collocationId = model.aID;
            [self.target.navigationController pushViewController:collocationDetailVC animated:YES];
            
        }
    };
    StopicListModel *model = _contentArray[indexPath.row];
    [cell setmodel:model parentVC:_target];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43 + 92 * SCALE_UI_SCREEN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
