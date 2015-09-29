//
//  SBaseAgilityViewController.m
//  Wefafa
//
//  Created by Mr_J on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseAgilityViewController.h"
#import "ShoppIngBagShowButton.h"
#import "SDiscoveryFlexibleHeaderView.h"
#import "MyShoppingTrollyViewController.h"
#import "SDiscoveryHeaderMoudleTool.h"
#import "UIScrollView+MJRefresh.h"
#import "SDiscoveryFlexibleModel.h"
#import "SAgilityNavigationBarTool.h"
#import "SHeaderTitleView.h"
#import "AppSetting.h"
#import "SUtilityTool.h"
#import "SDataCache.h"
#import "HttpRequest.h"
#import "WeFaFaGet.h"
#import "Toast.h"
#import "SMenuBottomModel.h"

@interface SBaseAgilityViewController () <SHeaderTitleCollectionViewDelegate>
{
    CGFloat _titleOrigin_Y;
}
@property (nonatomic, copy) NSString *selectedID;
@property (nonatomic, strong) SHeaderTitleView *titleView;

@end

static NSString *headerIdentifier = @"SDiscoveryFlexibleHeaderViewIdentifier";
@implementation SBaseAgilityViewController

- (instancetype)init
{
    self = [super initWithNibName:@"SBaseAgilityViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initSubViews];
    [self showCacheData];
    [_contentCollectionView headerBeginRefreshing];
}

- (void)initSubViews{
    _contentCollectionLayout = [WaterFLayout new];
    _contentCollectionLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64) collectionViewLayout:_contentCollectionLayout];
    _contentCollectionView.alwaysBounceVertical = YES;
    [self.view addSubview:_contentCollectionView];
    [_contentCollectionView registerClass:[SDiscoveryFlexibleHeaderView class] forSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:headerIdentifier];
    _contentCollectionView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    [_contentCollectionView addHeaderWithTarget:self action:@selector(requestData)];
    
    _titleView = [[SHeaderTitleView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 44)];
    _titleView.lineLayer.frame = CGRectMake(0, _titleView.height - 0.5, UI_SCREEN_WIDTH, 0.5);
    _titleView.lineLayer.backgroundColor = UIColorFromRGB(0xd9d9d9).CGColor;
    _titleView.hidden = YES;
    _titleView.headerTitleDelegate = self;
    [self.view addSubview:_titleView];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self setupNavbar];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    CGRect rect = self.navigationController.navigationBar.frame;
    rect.origin.y = 20;
    self.navigationController.navigationBar.frame = rect;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)scrollToTop{
    if (self.contentCollectionView.contentOffset.y == -self.contentCollectionView.contentInset.top) {
        [self.contentCollectionView headerBeginRefreshing];
        return;
    }
    [self.contentCollectionView setContentOffset:CGPointMake(0, -self.contentCollectionView.contentInset.top) animated:YES];
}

- (void)showCacheData{
    NSString *centerFilePath= [AppSetting getPersonalFilePath];
    NSString *filePath=[centerFilePath stringByAppendingPathComponent:_requestActionName];
    NSArray *dataDictionary = [[NSArray alloc]initWithContentsOfFile:filePath];
    if (!dataDictionary) return;
    self.contentHeaderModelArray = [SDiscoveryFlexibleModel modelArrayForDataArray:dataDictionary];
}

- (void)saveSacheData:(NSDictionary*)dict{
    NSString *centerFilePath= [AppSetting getPersonalFilePath];
    NSString *filePath=[centerFilePath stringByAppendingPathComponent:_requestActionName];
    [dict writeToFile:filePath atomically:YES];//写入
}

- (void)setupNavbar{
    [super setupNavbar];
    [self.tabBarController setValue:_layoutModel forKey:@"layoutModel"];
}

#pragma mark - request
- (void)requestData{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                     @"m": @"Home",
                                     @"a": @"getAppLayoutInfo",
                                     @"id":[Utils getSNSString:[NSString stringWithFormat:@"%@", _layoutModel.aID]]
                                 }];
    if (_selectedID) {
        params[@"cid"] = _selectedID;
    }
    [[SDataCache sharedInstance] quickGet:SERVER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id object) {
        [self.contentCollectionView headerEndRefreshing];
        [self saveSacheData:object[@"data"]];
        self.contentHeaderModelArray = [SDiscoveryFlexibleModel modelArrayForDataArray:object[@"data"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentCollectionView headerEndRefreshing];
        [Toast makeToast:kHomeNoneInternetTitle duration:2.0 position:@"center"];
    }];
}

#pragma mark - action
- (IBAction)touchActionToTop:(UIButton *)sender {
    [self.contentCollectionView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - title delegate
- (void)headerTitleCollectionView:(UICollectionView *)collectionView contentModel:(SHeaderTitleModel *)contenModel{
    self.selectedID = contenModel.aID;
    [self.contentCollectionView headerBeginRefreshing];
}

#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _contentHeaderModelArray? 1: 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0;
    _titleView.hidden = YES;
    for (SDiscoveryFlexibleModel *model in _contentHeaderModelArray) {
        if ([model.type intValue] == discoveryTitleCategory) {
            _titleOrigin_Y = height + 64;
            [self scrollViewDidScroll:collectionView];
            _titleView.contentModelArray = model.config;
            _titleView.pramsViewArray = _contentHeaderModelArray;
            _titleView.hidden = NO;
        }
        height += [SDiscoveryHeaderMoudleTool getHeaderCellHeightWithModel:model];
    }
    return height;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:WaterFallSectionHeader]) {
        SDiscoveryFlexibleHeaderView *headerReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        headerReusableView.target = self;
        headerReusableView.contentArray = _contentHeaderModelArray;
        reusableView = headerReusableView;
    }
    return reusableView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeZero;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tabBarController setValue:scrollView forKey:@"controlScrollView"];
    CGFloat offset_Y = _titleOrigin_Y - scrollView.contentOffset.y;
    offset_Y = offset_Y <= 64? 64: offset_Y;
    _titleView.top = offset_Y;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.tabBarController setValue:scrollView forKey:@"scrollViewBegin"];
}

#pragma mark - set and get
- (void)setContentHeaderModelArray:(NSMutableArray *)contentHeaderModelArray{
    _contentHeaderModelArray = contentHeaderModelArray;
    [self.contentCollectionView reloadData];
}

@end
