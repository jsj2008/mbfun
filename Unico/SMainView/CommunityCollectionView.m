//
//  CommunityCollectionView.m
//  Wefafa
//
//  Created by wave on 15/8/17.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CommunityCollectionView.h"
#import "CommunityCollectionViewCell.h"
#import "UIScrollView+MJRefresh.h"
#import "SUtilityTool.h"
#import "SDataCache.h"
#import "LNGood.h"
#import "SCollocationDetailNoneShopController.h"
#import "SCollocationDetailModel.h"
#import "WeFaFaGet.h"   

@interface CommunityCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>{
    //无我的喜欢背景视图
    UIView *placeholdView;
}
@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic) NSMutableArray *btnArray;
@property (nonatomic) NSMutableArray *dataArray;

@property (nonatomic, strong) NSNumber *userType;
@end

@implementation CommunityCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self uiconfig];
        self.dataSource = self;
        self.delegate = self;
        __weak __typeof(self) ws = self;
        self.block = ^(NSInteger userType){
            
            _userID = _userID ? _userID : @"";
            //男1 女2 童3
            if ([ws.userType integerValue] != userType||![_userID isEqualToString:@""]) {
                ws.userType = @(userType);
                //TODO:缓存优化，不需要每次都要重新请求数据
                [ws.header beginRefreshing];
            }
        };
        
        self.reloadBlock = ^(SCollocationDetailModel*model, BOOL islike) {
            NSUInteger integer = 0;
            for (LNGood *good in ws.dataArray) {
                if ([good.product_ID isEqualToString:model.aID]) {
                    integer = [ws.dataArray indexOfObject:good];
                    good.is_love = [@(islike) stringValue];
                    if ([good.is_love boolValue]) {
                        good.like_count = [@([good.like_count integerValue] + 1) stringValue];
                    }else{
                        good.like_count = [@([good.like_count integerValue] - 1) stringValue];
                    }
                }
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:integer inSection:0];
            [ws reloadItemsAtIndexPaths:@[indexPath]];
        };
    }
    return self;
}

- (void)uiconfig {
    self.backgroundColor = COLOR_C4;
    self.backgroundColor = [UIColor whiteColor];
    self.alwaysBounceVertical = YES;
    CGFloat height = 40*SCALE_UI_SCREEN;
    self.contentInset = UIEdgeInsetsMake(height*SCALE_UI_SCREEN, 0, 0, 0);
    [self registerNib:[UINib nibWithNibName:@"CommunityCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:communityCollectionViewCellID];
    __weak typeof(self) weakSelf = self;
    //默认女装  南1 女2 童3
    _userType = @(2);
    [self addHeaderWithCallback:^{
        [weakSelf requestCollectionDataIsPull:YES userType:weakSelf.userType];
    }];
    [self addFooterWithCallback:^{
        [weakSelf requestCollectionDataIsPull:NO userType:weakSelf.userType];
    }];
    [self.header beginRefreshing];
}

- (void)requestCollectionDataIsPull:(BOOL)pull userType:(NSNumber*)userType {
    if (pull) {
        _pageIndex = 0;
    }else {
//        _pageIndex = (_dataArray.count + 1) / 9;
        _pageIndex = (_dataArray.count + 9) / 10;
    }
    [self requestData:pull userType:userType];
}

- (void)clicked:(UIButton*)sender {
    for (UIButton *btn in _btnArray) {
        btn.selected = sender == btn;
    }
}

-(void)requestData:(BOOL)pull userType:(NSNumber*)userType{
    if (placeholdView) {
        [placeholdView removeFromSuperview];
        placeholdView = nil;
    }
//    NSString *userTypeStr = [userType intValue] ? [@([userType intValue]) stringValue] : @"";
//    getCollocationListByUserType($token=null,$userId = null,$userType = 1,$page=0)
    _userID = _userID ? _userID : @"";
    __weak CommunityCollectionView *ws = self;
    NSDictionary *param;
    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
    if([_userID isEqualToString:@""]){
//        param=@{
//                @"m" : @"Collocation",
//                @"a" : @"getCollocationListByUserType",
//                @"userType" : @([userType intValue])
//                };
        param=@{
                @"m" : @"Collocation",
                @"a" : @"getCollocationListByUserType",
                @"userType" : @([userType intValue]),
                @"token" : userToken,
                @"userId" : @"",
                @"userType" : @([userType intValue]),
                @"page" : @(_pageIndex)
                };
    }else{
        NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
        param=@{//
                @"m" : @"Collocation",
                @"a" : @"getUserLikeCollocationListByUserType",
                @"token" : userToken,
                @"userId" : _userID,
                @"userType" : @([userType intValue]),
                @"page" : @(_pageIndex)
                };
    }
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:param success:^(AFHTTPRequestOperation *operation, id object) {
        if (pull) {
            [ws headerEndRefreshing];
        }else {
            [ws footerEndRefreshing];
        }
        NSArray *array = object[@"data"];
        
        if (ws.pageIndex == 0) {
            ws.dataArray = [LNGood modelArrayForDataArray:array];
            [ws reloadData];
        }else{
            [ws.dataArray addObjectsFromArray:[LNGood modelArrayForDataArray:array]];
            [ws reloadData];
        }
        if(ws.dataArray.count==0){
            [self configNotifyViewWithTitle];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (pull) {
            [ws headerEndRefreshing];
        }else {
            [ws footerEndRefreshing];
        }
    }];
}

//- (void)reloadDataWithData:(LNGood*)model {
//    NSUInteger integer = [_dataArray indexOfObject:model];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:integer inSection:0];
//    [self reloadItemsAtIndexPaths:@[indexPath]];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.parentVC.tabBarController setValue:scrollView forKey:@"controlScrollView"];
}

#pragma mark - <UICollectionViewDelegate UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CommunityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:communityCollectionViewCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.userID=_userID;
    LNGood *model = _dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = 124 * SCALE_UI_SCREEN;
    CGFloat height = 200 * SCALE_UI_SCREEN;
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SCollocationDetailNoneShopController *collocationDetailVC = [[SCollocationDetailNoneShopController alloc] init];
    LNGood *model = _dataArray[indexPath.row];
    collocationDetailVC.collocationId =  model.product_ID ;
    __weak __typeof(self) ws = self;
    //搭配详情评论成功回调
    collocationDetailVC.commentDidSuccessSend = ^(NSNumber *count){
        model.comment_count = [@([count integerValue]) stringValue];
        [ws reloadItemsAtIndexPaths:@[indexPath]];
    };
    [self.parentVC.navigationController pushViewController:collocationDetailVC animated:YES];
}

//1男 2女
-(void)configNotifyViewWithTitle{
    if (placeholdView) {
        [placeholdView removeFromSuperview];
        placeholdView = nil;
    }
    placeholdView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, self.frame.size.height)];
    [placeholdView setBackgroundColor:COLOR_NORMAL];
    

    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (placeholdView.frame.size.height)/2-20, SCREEN_WIDTH, 20)];
    [messageLabel setFont:FONT_t5];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setTextColor:COLOR_C6];
    [messageLabel setTag:100];
    [messageLabel setText:@"您还未喜欢过搭配"];
    [placeholdView addSubview:messageLabel];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60)/2, messageLabel.frame.origin.y-messageLabel.frame.size.height-60, 60, 60)];
    [imgView setImage:[UIImage imageNamed:@"Unico/ico_nolike"]];
    imgView.contentMode=UIViewContentModeScaleAspectFill;
    [placeholdView addSubview:imgView];

    [self addSubview:placeholdView];
}
@end
