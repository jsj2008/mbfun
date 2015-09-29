//
//  CommunityAttentionTableView.m
//  Wefafa
//
//  Created by wave on 15/8/17.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CommunityAttentionTableView.h"
#import "SUtilityTool.h"
#import "UIScrollView+MJRefresh.h"
#import "SDataCache.h"
#import "WeFaFaGet.h"

#import "SContentOnePageCell.h"
#import "SMDataModel.h"
#import "CommunityAttentionHeadView.h"
#import "CommunityAttentionMasterModel.h"
#import "CommunityAttentionTableViewCell.h"
#import "SMineViewController.h"
#import "LoginViewController.h"
#import "SMainViewController.h"
#import "CommunityKeyBoardAccessoryView.h"
#import "SProductListReturnTopControl.h"

static NSString *contentOnePageCellID = @"contentOnePageCellID";

@interface CommunityAttentionTableView () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, kMainViewCellDelegate, SProductListReturnTopControlDelegate>
@property (nonatomic,assign) int pageIndex;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic, strong) CommunityAttentionHeadView *firstHeadView;
@property (nonatomic, strong) CommunityAttentionMasterModel *masterModel;   //推荐达人model，关闭推荐达人再次打开时的数据源

@property (nonatomic, strong) CommunityAttentionTableViewCell *cellOfMaster; //达人cell

@property (nonatomic, strong) UIView *unloadView;                 //缺省数据提醒图（居中）
@property (nonatomic, strong) UIView *noneAttentionView;                 //缺省数据提醒图（居中）
@property (nonatomic, strong) SProductListReturnTopControl *topBtn;     //返回顶部按钮
@end

@implementation CommunityAttentionTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if ( self == [super initWithFrame:frame style:style] ) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dataArray = [NSMutableArray new];
        NSMutableArray *array = [NSMutableArray new];
        NSMutableArray *array2 = [NSMutableArray new];
        [_dataArray addObject:array];
        [_dataArray addObject:array2];
        self.dataSource = self;
        self.delegate = self;
        [self uiconfig];
        __weak __typeof(self) ws = self;
        self.reloadDataBlock = ^(NSInteger integer){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:integer inSection:1];
            [ws reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        self.masterCellReloadBlock = ^(BOOL isConcerned){
            ws.cellOfMaster.modelDidChangedBlock(isConcerned);
        };
        //注册登录、推出监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti_loginComplete) name:@"MBFUN_LOGIN_SUC" object:nil];
        //上传搭配
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadImageToQiNiuWithImage) name:@"uploadImageToQiNiuWithImage" object:nil];
    }
    return self;
}
#pragma mark - uploadImageToQiNiuWithImage
- (void)uploadImageToQiNiuWithImage {
    [self.header beginRefreshing];
}

#pragma mark - 未登录
- (void)unloadUIConfig {
    _unloadView = [UIView new];
    _unloadView.backgroundColor = COLOR_C4;
    _unloadView.frame = CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64);
    [self addSubview:_unloadView];
    
    //uiimage 125 to top
    UIImageView *imgView = [UIImageView new];
    [imgView setImage:[UIImage imageNamed:@"Unico/light.png"]];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [imgView sizeToFit];
    [imgView setCenterX:self.centerX];
    [_unloadView addSubview:imgView];
    
    //uilabel
    UILabel *label = [UILabel new];
    [label setText:@"您还未登录"];
    [label setTextColor:COLOR_C2];
    [label setFont:FONT_T2];
    [label sizeToFit];
    [label setCenterX:self.centerX];
    [label setTop:imgView.bottom + 20];
    [_unloadView addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击登陆" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 106, 35)];
    [btn setBackgroundColor:COLOR_C1];
    btn.layer.cornerRadius = 3;
    [btn setTop:label.bottom + 15];
    [btn addTarget:self action:@selector(loginClicked) forControlEvents:UIControlEventTouchUpInside];
    [_unloadView addSubview:btn];
}

#pragma mark - 没有关注对象
-(void)noneAttentionUIConfig {
    //不能滚动
    self.alwaysBounceVertical = YES;
    
    _noneAttentionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64)];

    _noneAttentionView.backgroundColor = [UIColor clearColor];//COLOR_NORMAL;
    _noneAttentionView.userInteractionEnabled = NO;
    [self addSubview:_noneAttentionView];
    
    UIView *view_ = [UIView new];
    view_.backgroundColor = [UIColor clearColor];
    view_.frame = _noneAttentionView.frame;
    [_noneAttentionView addSubview:view_];
    
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (_noneAttentionView.frame.size.height-20)/2, SCREEN_WIDTH, 13)];
    [messageLabel setFont:FONT_t5];
    [messageLabel setTextColor:COLOR_C6];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setText:@"您还没有关注其他人"];
    [view_ addSubview:messageLabel];
    
    
    UILabel *messageLabel_2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(messageLabel.frame)+5, SCREEN_WIDTH, 13)];
    [messageLabel_2 setFont:FONT_t5];
    [messageLabel_2 setTextColor:COLOR_C6];
    [messageLabel_2 setTextAlignment:NSTextAlignmentCenter];
    [messageLabel_2 setText:@"快去关注为您推荐的达人吧"];
    [view_ addSubview:messageLabel_2];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60)/2, messageLabel.frame.origin.y-messageLabel.frame.size.height-60, 60, 60)];
    [imgView setImage:[UIImage imageNamed:@"Unico/ico_nofollower"]];
    imgView.contentMode=UIViewContentModeScaleAspectFill;
    [view_ addSubview:imgView];
}

#pragma mark - 登录、推出
- (void)noti_loginOut {
//    if (!_unloadView) {
//        [self unloadUIConfig];
//    }
}

- (void)noti_loginComplete {
//    if (_unloadView) {
//        [_unloadView removeFromSuperview];
//        _unloadView = nil;
//    }
    [self.header beginRefreshing];
}

- (void)uiconfig {
    self.backgroundColor = COLOR_C4;
    self.sectionFooterHeight = 0;
    self.sectionHeaderHeight = 0;
    __weak CommunityAttentionTableView *ws = self;
    [self addHeaderWithCallback:^{
        ws.pageIndex = 0;
        [ws requestCollectionDataIsPull:YES];
    }];
    [self addFooterWithCallback:^{
        [ws requestCollectionDataIsPull:NO];
    }];
    [self.header beginRefreshing];
    //cell
    [self registerClass:NSClassFromString(@"SContentOnePageCell") forCellReuseIdentifier:contentOnePageCellID];
}

- (void)requestCollectionDataIsPull:(BOOL)isPull {
    NSDictionary *data = @{
                           @"m":@"Home",
                           @"a" : @"getCollocationListFollows",
                           @"page":@(_pageIndex)
                           };
    __weak typeof(self) weakSelf = self;
    [[SDataCache sharedInstance] quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        //attention data
        if (![[responseObject objectForKey:@"data"] isKindOfClass:NSClassFromString(@"NSDictionary")]) {
            //没有登录则返回字典类型，且数据为空
//            [Toast makeToast:@"数据错误"];
          
            [weakSelf updateTableViewWithArray:nil success:YES isPull:isPull];
            return ;
        }
        NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"collocation"];
        [weakSelf updateTableViewWithArray:array success:YES isPull:isPull];
        //recommend data only contains within pageIndex == 0
        if (isPull) {
            [self masterRequestData:[[responseObject objectForKey:@"data"] objectForKey:@"recommend"]];
        }
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        self.userInteractionEnabled = YES;
        [weakSelf updateTableViewWithArray:nil success:NO isPull:isPull];
    }];

}

- (void)masterRequestData:(NSDictionary*)dic {
    [_dataArray[0] removeAllObjects];
    if (_firstHeadView.arrowState == arrowDOWN) {
        _masterModel = [[CommunityAttentionMasterModel alloc] initWithDic:dic];
        [_dataArray[0] addObject:_masterModel];
    }
    [self reloadData];
}

- (void)updateTableViewWithArray:(NSArray*)array success:(BOOL)success isPull:(BOOL)isPull {
    [self footerEndRefreshing];
    [self headerEndRefreshing];
//    [Toast hideToastActivity];
    
    if (array.count != 0 && success && isPull) {
        [_dataArray[0] removeAllObjects];
        [_dataArray[1] removeAllObjects];
        _pageIndex = 0;
    }
    
    if (array.count == 0 && ((NSArray*)_dataArray[1]).count == 0) {
        if (!_noneAttentionView) {
            [self noneAttentionUIConfig];
        }
    }else {
        if (_noneAttentionView) {
            for (UIView *view in _noneAttentionView.subviews) {
                [view removeFromSuperview];
            }
            [_noneAttentionView removeFromSuperview];
            _noneAttentionView = nil;
            self.alwaysBounceVertical = YES;
        }
    }
    if (success) {
        if (array.count == 0) {
            if ([_dataArray[1] count] > 0) {
                [self setTableFooterView:[self createFootView]];
            }else{

            }
        }else{
            _pageIndex ++;
            if ([self tableFooterView]) {
                [self setTableFooterView:nil];
            }
            //collocation
            //recommend
//            for(NSDictionary *dict in array){
            for(NSDictionary *dict in array){
                /*
                if ([[dict objectForKey:@"show_type"] integerValue] == 1) {
                    SMBannerModle *model = [[SMBannerModle alloc] initWithDict:dict];
                    [_dataArray addObject:model];
                }else{
                    SMDataModel *model = [[SMDataModel alloc] initWithDictionary:dict];
                    [_dataArray addObject:model];
                }
                */
                if ([[dict objectForKey:@"show_type"] integerValue] == 0) {
                    SMDataModel *model = [[SMDataModel alloc] initWithDictionary:dict];
//                    [_dataArray addObject:model];
                    [_dataArray[1] addObject:model];
                }
            }
        }
    }else{
    
    }
    NSLog(@"[_dataArray[1] count] ==== %d",(int)[_dataArray[1] count]);
    [self reloadData];
}

- (UIView *)createFootView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 100)];
    [footView setBackgroundColor:[Utils HexColor:0XF2F2F2 Alpha:1.0]];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH - 190)/2, 20, 190, 1.0)];
    [line setBackgroundColor:[Utils HexColor:0XE2E2E2 Alpha:1.0]];
    [footView addSubview:line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(line.frame.origin.x + 50, 0, 90, 41)];
    [label setText:@"没有更多"];
    [label setBackgroundColor:[Utils HexColor:0XF2F2F2 Alpha:1.0]];
    [label setTextColor:[Utils HexColor:0X333333 Alpha:1.0]];
    [label setFont:[UIFont systemFontOfSize:14.0F]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [footView addSubview:label];
    return footView;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.parentVC.tabBarController setValue:scrollView forKey:@"controlScrollView"];
    CGPoint point = scrollView.contentOffset;
    //返回顶部按钮
    if (!_topBtn) {
        _topBtn = [[SProductListReturnTopControl alloc] initWithFrame:CGRectMake(3 * UI_SCREEN_WIDTH - 50, UI_SCREEN_HEIGHT-150, 30, 30)];
        _topBtn.hidden = YES;
        _topBtn.delegate = self;
        [self.superview insertSubview:_topBtn atIndex:100];
    }
    if (_topBtn.hidden && point.y >= UI_SCREEN_HEIGHT) {
        _topBtn.hidden = NO;
    }else if(!_topBtn.hidden && point.y < UI_SCREEN_HEIGHT){
        _topBtn.hidden = YES;
    }
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *returnCell = nil;
    if (indexPath.section == 0) {
        CommunityAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:communityAttentionTableViewCellID];
        if (!cell) {
            cell = [[CommunityAttentionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:communityAttentionTableViewCellID];
            _cellOfMaster = cell;
        }
        cell.model = [_dataArray[0] objectAtIndex:0];
        returnCell = cell;
    }
    else {
    SMDataModel *model = _dataArray[1][indexPath.row];
    SContentOnePageCell *cell = (SContentOnePageCell *)[tableView dequeueReusableCellWithIdentifier:contentOnePageCellID];
    if (!cell) {
        cell = [[SContentOnePageCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:contentOnePageCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        cell.delegate = self;
        __weak __typeof(self) ws = self;
        cell.likeAnimationBlock = ^(SContentOnePageCell*cell, BOOL isLike){
            CGRect rect = cell.frame;
            rect.size.height -= 79 + 50;
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            [ws addSubview:imgView];
            UIImage *img = [UIImage new];
            if (isLike) {
                img = [UIImage imageNamed:@"Unico/community_like22.png"];
            }
            [imgView setImage:img];
            imgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.3, 0.3);
            imgView.alpha = 0.2;
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                if (isLike) {
                    ws.scrollEnabled = NO;
                }
                imgView.alpha = 0.8;
                imgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7f, 0.7f);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    imgView.alpha = 0.2;
                    imgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.3, 0.3);
                } completion:^(BOOL finished) {
                    ws.scrollEnabled = YES;
                    [imgView removeFromSuperview];
                }];
            }];
        };
        cell.commentBTnClicked = ^(SMDataModel* dataModel, NSInteger cellIndex){
            if (dataModel == nil) {
                [[SMainViewController instance] hideKeyBoard];
            }else {
                [[SMainViewController instance] callKeyBoardwithModel:dataModel integer:cellIndex];
            }
        };
        
        cell.parentVc = self.parentVC;
        [cell updateCellUIWithModel:model atIndex:indexPath.row];
        returnCell = cell;
    }
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  returnCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70 * SCALE_UI_SCREEN;
    }else {
        SMDataModel *model = _dataArray[1][indexPath.row];
        CGFloat height = 0;
        height = model.cellHeight;
//            //FIXME:第一个cell高度少算一个灰色底高
//        if (indexPath.section == 1 && indexPath.row == 0) {
//            height += 14;
//        }
        return height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 32 * SCALE_UI_SCREEN;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *returnView = nil;
    if (section == 0) {
        if (!_firstHeadView) {
            _firstHeadView = [[CommunityAttentionHeadView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 32)];
        }
        returnView = _firstHeadView;
        __weak   __typeof(self) ws = self;
        _firstHeadView.insertBlock = ^(Arrowstate state) {
            if (state == arrowDOWN) {    //箭头向下
                if (ws.masterModel) {
                    [ws.dataArray[0] removeAllObjects];
                    [ws.dataArray[0] addObject:ws.masterModel];
                    NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:0];
                    [ws reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
                }
            }else {
                [ws.dataArray[0] removeAllObjects];
                NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:0];
                [ws reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
            }
        };
    }else {
        returnView = nil;
    }
    return returnView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //推荐达人
        SMineViewController *vc = [SMineViewController new];
        CommunityAttentionMasterModel *model = [_dataArray[0] objectAtIndex:0];
        vc.person_id = model.user_id;
        [self.parentVC.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - <kMainViewCellDelegate>
- (void)kMainViewCellDeleteCellAtIndex:(NSInteger)indexCell {
//    [_collocationListArray removeObjectAtIndex:indexCell];
//    //    [self reloadData];
//    [self.contentCollectionView reloadData];
//    //    [Toast makeToast:@"删除成功"];
//    [Toast makeToastSuccess:@"删除成功"];

    SMDataModel *model = [_dataArray[1] objectAtIndex:indexCell];
    for (SMLikeUser *user in model.likeUserArray) {
        if ([user.user_id isEqualToString:sns.ldap_uid]) {
            [model.likeUserArray removeObject:user];
            [self reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexCell inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    [Toast makeToastSuccess:@"删除成功"];
}

- (void)kMainViewCellUploadCellAtIndex:(NSInteger)indexCell cellData:(NSMutableDictionary *)dict {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexCell inSection:0];
//    [self.contentCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexCell inSection:1];
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -
#pragma mark - SProductListReturnTopControlDelegate
-(void)returnTopControlClick {
    [self setContentOffset:CGPointZero animated:YES];
}

@end
