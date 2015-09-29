//
//  CommunityHotTableView.m
//  Wefafa
//
//  Created by wave on 15/8/17.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CommunityHotTableView.h"
#import "SUtilityTool.h"
#import "ShowAdvertisementView.h"
#import "SDiscoveryHeaderTableView.h"
#import "UIScrollView+MJRefresh.h"
#import "SDataCache.h"
#import "Toast.h"
#import "UIScrollView+paging.h"
//复用
#import "SStarStoreCellModel.h"
#import "STopicDetailViewController.h"
#import "SCollocationDetailViewController.h"
//新页面
#import "SStarStoreTableViewCell.h"
#import "CommunityHotCollectionViewTableCell.h"
//#import "CommunityHotHeaderView.h"
#import "CommunityHotTableViewCell.h"
#import "CommunityHotSecondTableView.h"
#import "StopicListModel.h"
#import "CommunityHotHeadView.h"


#import "PraiseBoxView.h"
#import "Dialog.h"
#import "SCollocationDetailNoneShopController.h"

typedef void (^moreBlock)(NSInteger section);

@interface Lastcell ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation Lastcell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _label = [UILabel new];
        [_label setTextColor:COLOR_C6];
        [_label setFont:FONT_t7];
        [_label setText:@"点击查看更多时尚达人"];
        [_label sizeToFit];
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)layoutSubviews {
    [_label setCenterY:self.height / 2];
    [_label setCenterX:UI_SCREEN_WIDTH / 2];
}

@end



@interface CommunityHotTableView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) ShowAdvertisementView *advertView;
@property (nonatomic, strong) SDiscoveryHeaderTableView *headerTableView;

@property (nonatomic) NSMutableArray *bannerAry;
@property (nonatomic, strong) NSArray *headerArray;
@property (nonatomic) NSMutableArray *dataArray;    //数据源
@property (nonatomic) CGFloat cellNowHeight;

@property (nonatomic) NSInteger pageIndex;

@property (nonatomic, strong) moreBlock moreBlock;

@property (nonatomic, strong) NSMutableArray *sectionHeadDictionary_Array;  //sectionHeadDictionary's array
@end

@implementation CommunityHotTableView
/*
- (void)setHeaderArray:(NSArray *)headerArray{
    _headerArray = headerArray;
    _headerTableView.contentArray = headerArray;
    
    CGFloat height = 0.0;
    for (SDiscoveryFlexibleModel *model in headerArray) {
        height += [_headerTableView getHeaderCellHeightWithModel:model];
    }
    _headerTableView.height = height + 10;
    
    [self beginUpdates];
    [self setTableHeaderView:_headerTableView];
    [self endUpdates];
}
*/
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if ( self == [super initWithFrame:frame style:style] ) {
        self.dataArray = [NSMutableArray new];
        NSMutableArray *tempArray = [NSMutableArray new];
        NSMutableArray *tempArray2 = [NSMutableArray new];
        [self.dataArray addObject:tempArray];
        [self.dataArray addObject:tempArray2];
        self.sectionHeadDictionary_Array = [NSMutableArray new];
        [self uiconfig];
        self.dataSource = self;
        self.delegate = self;
        self.moreBlock = ^(NSInteger section){
            //第几个section的more事件
            
        };
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100, 100, 100, 100);
        btn.backgroundColor = [UIColor redColor];
        [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btn];
    }
    return self;
}

- (void)click {
    [SUTILITY_TOOL_INSTANCE showPraiseBox];
}

- (void)uiconfig {
    self.backgroundColor = COLOR_C4;
    self.tableFooterView = [UIView new];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    //header
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.tableHeaderView = view;
    //热门话题
    [self registerNib:[UINib nibWithNibName:@"CommunityHotCollectionViewTableCell" bundle:nil] forCellReuseIdentifier:communityHotCollectionViewTableCellID];
    //时尚达人
//    [self registerNib:[UINib nibWithNibName:@"CommunityHotTableViewCell" bundle:nil] forCellReuseIdentifier:communityHotTableViewCellID];
    [self registerNib:[UINib nibWithNibName:@"CommunityHotTableViewCell" bundle:nil] forCellReuseIdentifier:communityHotTableViewCellID];
//    //header
//    [self registerClass:NSClassFromString(@"CommunityHotHeaderView") forHeaderFooterViewReuseIdentifier:communityHotHeaderViewID];
    //header配置
//    _headerTableView = [[SDiscoveryHeaderTableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 80)];
//    _headerTableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
//    self.tableHeaderView = _headerTableView;
    __weak CommunityHotTableView *weakSelf = self;
    [self addHeaderWithCallback:^{
        _pageIndex = 0;
        [weakSelf requestCollectionDataIsPull:YES];
    }];
    [self.header beginRefreshing];
}
//时尚达人下
- (void)requestCollectionDataIsPull:(BOOL)pull {
    __weak __typeof(self) ws = self;
    NSDictionary *params = @{
                             @"m":@"Home",
                             @"a":@"getHotLayoutInfo",
                             @"page":@(_pageIndex)
                             };
    [SDATACACHE_INSTANCE quickGet:SERVER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id object) {
        //type = 14时尚达人
        //type = 15热门话题
        NSMutableArray * tempArr = [object[@"data"] mutableCopy];
        if (tempArr.count == 0 || !tempArr) {
            [Toast makeToast:@"请下拉刷新!"];
        }else {
            NSMutableArray *tempArray = [NSMutableArray new];
            for (NSDictionary * dictioary in tempArr) {
                if ([dictioary[@"type"] intValue] == 14) {
                    for (NSDictionary *dic in dictioary[@"config"]) {
                        SStarStoreCellModel * model = [[SStarStoreCellModel alloc]initStarStoreModelWithDic:dic];
                        [tempArray addObject:model];
                        ws.dataArray[1] = tempArray;
                    }
                }else if ([dictioary[@"type"] intValue] == 15) {
                    NSArray *tempArray = [NSArray new];
                    tempArray = [StopicListModel modelArrayForDataArray:dictioary[@"config"]];
                    [ws.dataArray[0] removeAllObjects];
                    [ws.dataArray[0] addObjectsFromArray:tempArray];
                }else if ([dictioary[@"type"] intValue] == 99999) {
                    [ws.sectionHeadDictionary_Array addObject:dictioary];
                }
            }
            [self reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    if (pull) [self.header endRefreshing]; else [self.footer endRefreshing];
}

- (void)pagingView {
    CommunityHotSecondTableView *tv = [CommunityHotSecondTableView new];
    self.secondScrollView = tv;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.parentVC.tabBarController setValue:scrollView forKey:@"controlScrollView"];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [_dataArray[section] count];
    }else{
        if ([_dataArray[section] count] > 0) {
            return [_dataArray[section] count] + 1;
        }
        else {
            return 0;
        }
    }
}
//CommunityHotCollectionModel
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *returnCell = nil;
    if (indexPath.section == 0) {
        //热门话题
        CommunityHotCollectionViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:communityHotCollectionViewTableCellID forIndexPath:indexPath];
        StopicListModel *model = [_dataArray[indexPath.section] objectAtIndex:indexPath.row];
//        CommunityHotCollectionModel *model = [_dataArray[indexPath.section] objectAtIndex:indexPath.row];
        [cell setmodel:model parentVC:self.parentVC];
        cell.jumpBlock = ^(StopicListModel*model){
            //话题详情
            STopicDetailViewController *controller = [[STopicDetailViewController alloc]init];
            controller.topicID = model.aID;
            controller.titleName = model.name;
            [self.parentVC.navigationController pushViewController:controller animated:YES];
        };
        cell.jumpToCollBlock = ^(StopicListContentModel*model){
            //FIXME:根据详情跳转规则跳转
            //搭配详情
            extern BOOL g_socialStatus;
            if (g_socialStatus)//是否处于社交状态
            {
                SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
                detailNoShoppingViewController.collocationId = model.aID;
                [self.parentVC.navigationController pushViewController:detailNoShoppingViewController animated:YES];
            }
            else
            {
                SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
                collocationDetailVC.collocationId = model.aID;
                [self.parentVC.navigationController pushViewController:collocationDetailVC animated:YES];
                
            }
        };
        returnCell = cell;
    }else {
        if (indexPath.row  == [_dataArray[indexPath.section] count]) {
            Lastcell *cell = [tableView dequeueReusableCellWithIdentifier:lastcellID];
            if (!cell) {
                cell = [[Lastcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lastcellID];
                //FIXME:高度计算有问题
                CGSize size = tableView.contentSize;
                size.height += 25;
                tableView.contentSize = size;
            }
            returnCell = cell;
        }else{
            //时尚达人
            CommunityHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:communityHotTableViewCellID forIndexPath:indexPath];
            cell.parentView = self;
            SStarStoreCellModel *model = [_dataArray[indexPath.section] objectAtIndex:indexPath.row];
            [cell model:model parentVC:self.parentVC indexPath:indexPath];
            returnCell = cell;
        }
    }
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return returnCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (indexPath.section == 0) {
        height = 5 + 92 * SCALE_UI_SCREEN + 30 + 8;
    }else {
        if (indexPath.row == [_dataArray[indexPath.section] count]) {
            return 55 * UI_SCREEN_WIDTH / 375;
        }
        height = 377*UI_SCREEN_WIDTH / 375;
//        height = 385;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0;
    if (_sectionHeadDictionary_Array.count == 0) {
        height = 1;
    }else {
        height = [[[[_sectionHeadDictionary_Array[section] objectForKey:@"config"] objectAtIndex:0] objectForKey:@"img_height"]floatValue];
    }
    return height;
//    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CommunityHotHeadView *view = [[CommunityHotHeadView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40)];
    view.section = section;
    view.block = self.moreBlock;
    view.backgroundColor = [UIColor whiteColor];
    view.title = section ? @"时尚达人" : @"热门话题";
    return view;
}

//- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
//    view.tintColor = [UIColor clearColor];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
