//
//  SMainTopicTableView.m
//  Wefafa
//
//  Created by unico_0 on 7/9/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SMainTopicTableView.h"
#import "SDiscoveryShowTopicView.h"
#import "SDiscoveryShowBannerTableView.h"
#import "SDesignerShowCollectionView.h"
#import "SDiscoveryFlexibleModel.h"
#import "STopicListTableViewCell.h"
#import "STopicDetailViewController.h"
#import "SMyTopicViewController.h"
#import "SUtilityTool.h"
#import "SDiscoveryBrandZoneCollectionView.h"
#import "SDiscoveryShowConfigPicAndTextView.h"
#import "SDiscoveryFlexibleHeaderView.h"
#import "SDiscoveryHeaderTableView.h"
#import "SDiscoveryHeaderMoudleTool.h"

@interface SMainTopicTableView ()<STopicListTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SDiscoveryHeaderTableView *headerTableView;

@end

static NSString *cellIdentifier = @"STopicListTableViewCellIdentifier";
@implementation SMainTopicTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerNib:[UINib nibWithNibName:@"STopicListTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.delegate = self;
    self.dataSource = self;
    self.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    
    
    _headerTableView = [[SDiscoveryHeaderTableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 80)];
    _headerTableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.tableHeaderView = _headerTableView;
}

- (void)setTarget:(UIViewController *)target{
    _target = target;
    _headerTableView.target = target;
}

- (void)setContentArray:(NSMutableArray *)contentArray{
    _contentArray = contentArray;
    [self reloadData];
}

- (void)setHeaderArray:(NSArray *)headerArray{
    _headerArray = headerArray;
    _headerTableView.contentArray = headerArray;
    
    CGFloat height = 0.0;
    for (SDiscoveryFlexibleModel *model in headerArray) {
        height += [SDiscoveryHeaderMoudleTool getHeaderCellHeightWithModel:model];
    }
    _headerTableView.height = height + 10;
    
    [self beginUpdates];
    [self setTableHeaderView:_headerTableView];
    [self endUpdates];
}

- (CGFloat)getBannerAndContentHeight:(CGFloat)height model:(SDiscoveryFlexibleModel*)model{
    height *= SCALE_UI_SCREEN;
    if (model.banner_list.count > 0) {
        SDiscoveryBannerModel *bannerModel = model.banner_list[0];
        height += bannerModel.img_height.floatValue * UI_SCREEN_WIDTH/ bannerModel.img_width.floatValue;
    }
    return height;
}
#pragma mark touche action
- (void)topicTouchNextAction:(UIButton *)button contentModel:(StopicListModel *)model{
    STopicDetailViewController *controller = [[STopicDetailViewController alloc]init];
    controller.topicID = model.aID;
    controller.titleName = model.name;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    _target.navigationItem.backBarButtonItem = backItem;
    [_target.navigationController pushViewController:controller animated:YES];
}

- (void)topicForMyButtonAction:(UIButton*)sender{
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    SMyTopicViewController *controller = [[SMyTopicViewController alloc]init];
    [_target.navigationController pushViewController:controller animated:YES];
}

#pragma mark -dele

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.target.tabBarController setValue:scrollView forKey:@"controlScrollView"];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.target.tabBarController setValue:scrollView forKey:@"scrollViewBegin"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    STopicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.parentVC = _target;
    StopicListModel *model = _contentArray[indexPath.row];
    cell.contentModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
