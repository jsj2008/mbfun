//
//  MainTableView.m
//  Wefafa
//
//  Created by su on 15/6/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "MainTableView.h"
#import "MJRefresh.h"
#import "SDataCache.h"
#import "SBannerViewCell.h"
#import "SContentOnePageCell.h"
#import "WeFaFaGet.h"
#import "Utils.h"
#import "SUtilityTool.h"
#import "SStarStoreViewController.h"

@interface MainTableView ()<UITableViewDataSource,UITableViewDelegate,kMainViewCellDelegate>
{
    NSMutableArray *dataArray;
    NSString *methodName;
    NSInteger page;
    
    UIView *noDataView;
}

@end

@implementation MainTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        _needUpload = NO;
        dataArray = [NSMutableArray arrayWithCapacity:0];
        [self setSeparatorColor:[UIColor whiteColor]];
        __weak typeof(self) weakSelf = self;
        [self addFooterWithCallback:^{
            [weakSelf requestCollectionDataIsPull:NO];
        }];
        [self addHeaderWithCallback:^{
            [weakSelf requestCollectionDataIsPull:YES];
        }];
    }
    return self;
}

- (void)refrashTableLogout
{
    if ([methodName isEqualToString:@"getCollocationListFollows"]) {
        if (!sns.isLogin) {
            [dataArray removeAllObjects];
            if (!noDataView) {
                noDataView = [self createNoDataView];
                [self addSubview:noDataView];
            }
            [self reloadData];
            return;
        }
    }
    [self requestCollectionDataIsPull:YES];
}

- (void)requestDataWithType:(kTableViewType)type
{
    if (_needUpload) {
        _needUpload = NO;
    }else{
        if (dataArray.count > 0) {
            [self reloadData];
            return;
        }
    }
    switch (type) {
        case kTableViewTypeAll:
            methodName = @"getCollocationList";
            break;
        case kTableViewTypeAttention:
            methodName = @"getCollocationListFollows";
            break;
        case kTableViewTypeHot:
            methodName = @"getCollocationListHot";
            break;
        default:
            break;
    }
    if (!sns.isLogin && [methodName isEqualToString:@"getCollocationListFollows"]) {
        [dataArray removeAllObjects];
        if (!noDataView) {
            noDataView = [self createNoDataView];
            [self addSubview:noDataView];
        }
        [self reloadData];
        return;
    }
    [self requestCollectionDataIsPull:YES];
}

- (void)requestCollectionDataIsPull:(BOOL)isPull
{
//    [MBProgressHUD showHUDAddedTo:self.ownerVC.view animated:YES];
    if (isPull) {
        [dataArray removeAllObjects];
        page = 0;
    }
    if (!methodName) return;
    NSDictionary *data = @{
                           @"m":@"Home",
                           @"a":methodName,
                           @"page":@(page)
                           };
    __weak typeof(self) weakSelf = self;
    [[SDataCache sharedInstance] quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSArray *array = [responseObject objectForKey:@"data"];
        
        [weakSelf updateTableViewWithArray:array success:YES];
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [weakSelf updateTableViewWithArray:nil success:NO];
    }];
}

- (void)updateTableViewWithArray:(NSArray *)array success:(BOOL)success
{
    [self footerEndRefreshing];
    [self headerEndRefreshing];
//    [MBProgressHUD hideAllHUDsForView:self.ownerVC.view animated:YES];
    
    if (success) {
        if (array.count == 0) {
            if (dataArray.count > 0) {
                [self setTableFooterView:[self createFootView]];
            }else{
                if ([methodName isEqualToString:@"getCollocationListFollows"]) {
                    if (!sns.isLogin) {
                        if (!noDataView) {
                            noDataView = [self createNoDataView];
                            [self addSubview:noDataView];
                        }
                    }
                }
            }
        }else{
            page ++;
            if ([self tableFooterView]) {
                [self setTableFooterView:nil];
            }
            for(NSDictionary *dict in array){
                if ([[dict objectForKey:@"show_type"] integerValue] == 1) {
                    SMBannerModle *model = [[SMBannerModle alloc] initWithDict:dict];
                    [dataArray addObject:model];
                }else{
                    SMDataModel *model = [[SMDataModel alloc] initWithDictionary:dict];
                    [dataArray addObject:model];
                }
            }
            
            if (noDataView) {
                [noDataView removeFromSuperview];
                noDataView = nil;
            }
        }
    }else{
        if ([methodName isEqualToString:@"getCollocationListFollows"]) {
            if (!sns.isLogin) {
                if (!noDataView) {
                    noDataView = [self createNoDataView];
                    [self addSubview:noDataView];
                }
            }
        }
    }
    [self reloadData];
}

#pragma mark UIButton click method

- (void)recommendDesigner
{
    if ([BaseViewController pushLoginViewController]) {
        SStarStoreViewController * starStoreVC = [[SStarStoreViewController alloc]init];
        [self.ownerVC.navigationController pushViewController:starStoreVC animated:YES];
    }
}

#pragma mark datasource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    id objectName;
    if (dataArray.count > indexPath.row) {
        objectName = [dataArray objectAtIndex:indexPath.row];
    }
    if (objectName==nil) {
        return 0;
    }
    // 这行isEqual错了，另外临时这样处理。
    BOOL isBanner = [objectName isKindOfClass:[SMBannerModle class]];
    if (isBanner) {
        SMBannerModle *model = objectName;
        float tempHeight = [model.img_height floatValue];
        float tempWidth = [model.img_width floatValue];
        float floatPercent = UI_SCREEN_WIDTH/(tempWidth/2);
        height = floatPercent*tempHeight/2;
    }else{
        SMDataModel *model = objectName;
        height = [model.img_height floatValue] * UI_SCREEN_WIDTH/ [model.img_width floatValue];
        height += 70;//header高度
        height += 50;//底部高度
        height += 50;
        if (model.content_info.length > 0) {
            height += [model.content_info boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |
                         NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
            height += 15.0;
        }
        if (model.likeUserArray.count <= 0) {
            height -= 35.0;
        }
    }
    if (height < 10) {
        height = 100;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id objectName ;
    BOOL isBanner = NO;
    if (dataArray.count > indexPath.row) {
        objectName = [dataArray objectAtIndex:indexPath.row];
        isBanner = [objectName isKindOfClass:[SMBannerModle class]];
    }
    
    static NSString *SBannerViewCellIdentifier = @"SBannerViewCellIdentifier";
    static NSString *cellIdentifier = @"cellIdentifier";
    if (isBanner) {
        SBannerViewCell *cell = (SBannerViewCell *)[tableView dequeueReusableCellWithIdentifier:SBannerViewCellIdentifier];
        if (!cell) {
            cell = [[SBannerViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:SBannerViewCellIdentifier];
        }
//        cell.cellData = objectName;
        [cell updateCellUIWithModel:objectName];
        //高度
        return  cell;
        
    }else{
        SContentOnePageCell *cell = (SContentOnePageCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[SContentOnePageCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        cell.parentVc = self.ownerVC;
        [cell updateCellUIWithModel:objectName atIndex:indexPath.row];
        //高度
        return  cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id objectName = [dataArray objectAtIndex:indexPath.row];
    BOOL isBanner = [objectName isKindOfClass:[SMBannerModle class]];
    if (isBanner) {
        NSMutableDictionary *dict  = [NSMutableDictionary dictionaryWithCapacity:0];
        SMBannerModle *model = (SMBannerModle *)objectName;
        if (model.is_h5) {
            [dict setObject:model.is_h5 forKey:@"is_h5"];
        }
        if (model.jump_type) {
            [dict setObject:model.jump_type forKey:@"jump_type"];
        }
        if (model.tid) {
            [dict setObject:model.tid forKey:@"tid"];
        }
        if (model.url) {
            [dict setObject:model.url forKey:@"url"];
        }
        if (model.name) {
            [dict setObject:model.name forKey:@"name"];
        }
        [[SUtilityTool shared] jumpControllerWithContent:dict target:self.ownerVC];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[SContentOnePageCell class]]) {
        SContentOnePageCell *pageCell = (SContentOnePageCell *)cell;
        [pageCell removeVideo];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.ownerVC.tabBarController setValue:scrollView forKey:@"controlScrollView"];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.ownerVC.tabBarController setValue:scrollView forKey:@"scrollViewBegin"];
}

-(UIView*)createNoDataView{
    UIView *tempView = [SUTIL createUIViewByHeight:(UI_SCREEN_HEIGHT - 64) coordY:0];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH - 52)/2, 130, 52, 60)];
    [imgView setImage:[UIImage imageNamed:@"Unico/home_light"]];
    [tempView addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 210, UI_SCREEN_WIDTH, 25)];
    [label setText:@"你还没有任何关注"];
    [label setTextColor:[Utils HexColor:0X3B3B3B Alpha:1.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont boldSystemFontOfSize:16.0F]];
    [tempView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, UI_SCREEN_WIDTH, 20)];
    [label1 setText:@"看看推荐给你的吧"];
    [label1 setTextColor:[Utils HexColor:0X666666 Alpha:1.0]];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [label1 setFont:[UIFont systemFontOfSize:14.0F]];
    [tempView addSubview:label1];
    
    UIButton *recommendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recommendBtn setTitle:@"推荐关注" forState:UIControlStateNormal];
    [recommendBtn addTarget:self action:@selector(recommendDesigner) forControlEvents:UIControlEventTouchUpInside];
    [recommendBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [recommendBtn setTitleColor:[Utils HexColor:0X3B3B3B Alpha:1.0] forState:UIControlStateNormal];
    [recommendBtn setBackgroundColor:[Utils HexColor:0XFFDE00 Alpha:1.0]];
    [recommendBtn.layer setCornerRadius:5.0];
    [recommendBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [recommendBtn.layer setBorderWidth:1.0];
    [recommendBtn setFrame:CGRectMake((UI_SCREEN_WIDTH - 110)/2, 270, 110, 35)];
    [tempView addSubview:recommendBtn];
    return tempView;
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

- (void)kMainViewCellDeleteCellAtIndex:(NSInteger)indexCell
{
    [dataArray removeObjectAtIndex:indexCell];
    [self reloadData];
//    [Toast makeToast:@"删除成功"];
    [Toast makeToastSuccess:@"删除成功"];
}

- (void)kMainViewCellUploadCellAtIndex:(NSInteger)indexCell cellData:(NSMutableDictionary *)dict
{
    [self reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexCell inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
@end
