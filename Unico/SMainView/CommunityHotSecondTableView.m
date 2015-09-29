//
//  CommunityHotSecondTableView.m
//  Wefafa
//
//  Created by wave on 15/8/18.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CommunityHotSecondTableView.h"
#import "UIScrollView+MJRefresh.h"
#import "SDataCache.h"
#import "Toast.h"
#import "SStarStoreCellModel.h"
#import "SStarStoreTableViewCell.h"

@interface CommunityHotSecondTableView ()
@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic) CGFloat cellNowHeight;
@end

@implementation CommunityHotSecondTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if ( self == [super initWithFrame:frame style:style] ) {
//        //测试使用
//        self.contentSize = CGSizeMake(0, 729);
        self.dataArray = [NSMutableArray new];
        [self uiconfig];
    }
    return self;
}

- (void)uiconfig {
    __weak CommunityHotSecondTableView *ws = self;
    [self addFooterWithCallback:^{
        [ws requestCollectionDataIsPull:NO];
    }];
    [self.footer beginRefreshing];
}

- (void)requestCollectionDataIsPull:(BOOL)pull {
    [SDATACACHE_INSTANCE getStarDesignerList:0 complete:^(NSArray *data) {
        /*
         NSMutableArray * tempArr = [data mutableCopy];
         if (tempArr.count == 0 || !tempArr ) {
         [self layoutNoneDataView];
         }
         else{
         for (NSDictionary * dict in tempArr) {
         if ([dict[@"show_type"] integerValue] == 0) {
         SStarStoreCellModel * model = [[SStarStoreCellModel alloc]initStarStoreModelWithDic:dict];
         [_dataSource addObject:model];
         NSLog(@"%@",model.collocationList);
         }else if([dict[@"show_type"] integerValue] == 6){
         [bannerAry addObject:dict];
         }
         }
         if ([_dataSource count]==0&&[bannerAry count]==0) {
         [self layoutNoneDataView];
         }
         else
         [self setupTableView];
         }
         */
        NSMutableArray * tempArr = [data mutableCopy];
        if (tempArr.count == 0 || !tempArr) {
            [Toast makeToast:@"请下拉刷新!"];
        }else {
            for (NSDictionary * dict in tempArr) {
                if ([dict[@"show_type"] integerValue] == 0) {
                    SStarStoreCellModel * model = [[SStarStoreCellModel alloc]initStarStoreModelWithDic:dict];
                    [_dataArray addObject:model];
                }
            }
            [self reloadData];
        }
    }];
    if (!pull) {
        [self.footer endRefreshing];
    }
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SBrandCell";
    SStarStoreTableViewCell *cell = (SStarStoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SStarStoreTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
    }
    _cellNowHeight = cell.cellHeight;
    cell.parentVc = self;
    SStarStoreCellModel * model = (SStarStoreCellModel*)_dataArray[indexPath.row];
    [cell updateStarCellModel:model andIndex:(indexPath)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellNowHeight;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
