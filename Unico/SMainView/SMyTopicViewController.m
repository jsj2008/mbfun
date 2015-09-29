//
//  SMyTopicViewController.m
//  Wefafa
//
//  Created by wave on 15/7/20.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMyTopicViewController.h"
#import "WeFaFaGet.h"
#import "WaterFLayout.h"
#import "StopicSelectedButton.h"
#import "Utils.h"
#import "SUtilityTool.h"
#import "SDataCache.h"
#import "SMyTopicHeaderCollectionReusableView.h"
#import "SWaterCollectionViewCell.h"
#import "SSearchProductCollectionViewCell.h"
#import "UIScrollView+MJRefresh.h"
#import "Toast.h"
#import "LoginViewController.h"
#import "SMyTopicModel.h"   //话题model
#import "SMyTopicPicModel.h"  //照片model
#import "SMyTopicCollectionViewCell.h"      //话题cell
#import "SMyTopicPicCollectionViewCell.h"   //照片cell
#import "SMyTopicHeadModel.h"
#import "StopicListModel.h"
#import "STopicDetailViewController.h"
#import "SCollocationDetailViewController.h"
#import "SCollocationDetailNoneShopController.h"
#import "ShoppIngBagShowButton.h"
#import "HttpRequest.h"
#import "MyShoppingTrollyViewController.h"

static NSString *myTopicWaterFallSectionHeader = @"myTopicWaterFallSectionHeader";
static NSString *myTopicTopicCellIdentifier = @"myTopicTopicCellIdentifier";
static NSString *myTopicPicCellIdentifier = @"myTopicPicCellIdentifier";

@interface SMyTopicViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSInteger _pageIndex;
    NSInteger _selecetBtnIndex;
    CGFloat _beginOrigin_Y;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *listTopicArray;
@property (nonatomic, strong) NSMutableArray *listPicArray;
@property (nonatomic, strong) NSMutableArray *topButtonArray;
@property (nonatomic, strong) NSMutableArray *bottomButtonArray;
@property (nonatomic, strong) CALayer *selectedLineLayer;
@property (nonatomic ,strong) UIView *selectedContentView;
@property (nonatomic, strong) WaterFLayout* flowLayout;
@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagButton;
@property (nonatomic, strong) SMyTopicHeadModel *headerModel;
@end

@implementation SMyTopicViewController

- (void)setHeaderModel:(SMyTopicHeadModel *)headerModel {
    _headerModel = headerModel;
    [_collectionView reloadData];
}

- (void)requestCarCount{

    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
        [Toast hideToastActivity];
        NSInteger total = [dict[@"total"] integerValue];
        if (total==0) {
            return ;
        }
        
        int count = [dict[@"results"][0][@"count"] intValue];
        if (count!=0) {
            self.shoppingBagButton.titleLabel.hidden=NO;
            [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]] forState:UIControlStateNormal];
        }else
        {
            self.shoppingBagButton.titleLabel.hidden=YES;
            [self.shoppingBagButton setTitle:@"" forState:UIControlStateNormal];
        }
        //        [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]] forState:UIControlStateNormal];
    } failed:^(NSError *error) {
        [Toast hideToastActivity];
        
    }];
}
- (void)onCart {
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *vc1=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_C3;
    _listTopicArray = [NSMutableArray new];
    _listPicArray = [NSMutableArray new];
    
    _block = ^{
        [self requesetData];
    };
    
    [self initNavigationBar];
    [self initSubViews];
    [self requesetData];
}

- (void)initNavigationBar{
    [super setupNavbar];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/common_navi_transparentblack.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    self.navigationItem.leftBarButtonItems = @[left1];
    self.title = @"我的话题";
    _shoppingBagButton = [[ShoppIngBagShowButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    [_shoppingBagButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_shoppingBagButton setImage:[UIImage imageNamed:@"Unico/cart"] forState:UIControlStateNormal];
    [_shoppingBagButton addTarget:self action:@selector(onCart) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:_shoppingBagButton];
    self.navigationItem.rightBarButtonItems=@[rightItem1];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self initNavigationBar];
    [self scrollViewDidScroll:_collectionView];
    [self requestCarCount];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.alpha = 1.0;
    self.navigationController.navigationBarHidden = NO;
}

- (void)onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubViews{
    _flowLayout = [[WaterFLayout alloc]init];
    _flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_flowLayout];
    [_collectionView setShowsVerticalScrollIndicator:NO];
    _collectionView.backgroundColor = COLOR_C4;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"SMyTopicHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:myTopicWaterFallSectionHeader];
    [_collectionView registerNib:[UINib nibWithNibName:@"SMyTopicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:myTopicTopicCellIdentifier];
    [_collectionView registerNib:[UINib nibWithNibName:@"SMyTopicPicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:myTopicPicCellIdentifier];
    [_collectionView addFooterWithTarget:self action:@selector(requestAddData)];
    [self.view addSubview:_collectionView];
    
    [self initSelectedContentView];
}

- (void)initSelectedContentView{
    _topButtonArray = [NSMutableArray array];
    _bottomButtonArray = [NSMutableArray array];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 99)];
    view.layer.masksToBounds = YES;
    view.backgroundColor = COLOR_C9;
    [_collectionView addSubview:view];
    _selectedContentView = view;
    
    NSArray *titleArray = @[@"我参与的话题", @"我发布的照片"];
    int count = 2;
    for (int i = 0; i < count; i ++) {
        StopicSelectedButton *topButton = [[StopicSelectedButton alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/ count * i, 0.5, UI_SCREEN_WIDTH/ count - 0.5, 54)];
//        topButton.titleLabel.font = FONT_t2;
        [topButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [topButton setTitleColor:COLOR_C2 forState:UIControlStateSelected];
        [topButton setTitleColor:COLOR_C6 forState:UIControlStateNormal];
        topButton.backgroundColor = [UIColor whiteColor];
        topButton.tag = i;
        [topButton addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:topButton];
        [_topButtonArray addObject:topButton];
    }
    _selectedLineLayer = [CALayer layer];
    _selectedLineLayer.backgroundColor = COLOR_C1.CGColor;
    _selectedLineLayer.frame = CGRectMake(0, 51.5, 75, 3);
    _selectedLineLayer.zPosition = 5;
    [view.layer addSublayer:_selectedLineLayer];
    
    [self selectedButton:[_topButtonArray firstObject]];
}

- (void)requesetData {
//    m=Topic
//    1.获取界面上方用户信息 a= getMyTopic($token = null)
//    2.获取我的话题搭配列表 a= getMyCollocationListForTopic($token = null,$page= 0)
//    3.获取我的话题列表 a=getMyTopicList($token = null,$page= 0)
    
    NSDictionary *param = @{ @"m" : @"Topic",
                             @"a" : @"MyTopic",
                             @"token" :  [SDataCache sharedInstance].userInfo[@"token"]};
    
    [[SDataCache sharedInstance] get:@"Topic" action:@"getMyTopic" param:param success:^(AFHTTPRequestOperation *operation, id object) {
        NSDictionary *dictionary = (NSDictionary *)object;
        if ([[dictionary objectForKey:@"status"] intValue] == 1) {
            self.headerModel = [[SMyTopicHeadModel alloc] initWithDic:dictionary[@"data"]];
        }
        [self headConfig];
    }
    fail:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    }];
}

- (void)headConfig {
    StopicSelectedButton *button = _topButtonArray[0];
    button.subLabel.text = [Utils getSNSInteger:_headerModel.topicCount];
    button = _topButtonArray[1];
    button.subLabel.text = [Utils getSNSInteger:_headerModel.collCount];
}

- (void)requestAddData {
    if (_selecetBtnIndex) { //照片
        _pageIndex = (_listPicArray.count + 9) / 10;
        [self requestPicData];
    }else {
        _pageIndex = (_listTopicArray.count + 9) / 10;
        [self requestTopicData];
    }
}

-(void) selectedButton:(UIButton*)sender {
    for (UIButton *btn in _topButtonArray) {
        btn.selected = btn == sender;
        btn.titleLabel.font = btn == sender ? FONT_T4 : FONT_t4;
    }
    _selecetBtnIndex = sender.tag;
    
    CGPoint point = _selectedLineLayer.position;
    point.x = sender.centerX;
    [_selectedLineLayer setPosition:point];
    
    if (sender.tag == 0) {
        if (_listTopicArray.count) {
            [self changeLayout];
            [_collectionView reloadData];
        }else {
            _pageIndex = _listTopicArray.count / 10;
            [self requestTopicData];
        }
    }else {
        if (_listPicArray.count) {
            [self changeLayout];
            [_collectionView reloadData];
        }else {
            _pageIndex = _listPicArray.count / 10;
            [self requestPicData];
        }
    }
}

- (void)changeLayout {
    if (_selecetBtnIndex) {
        _flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _flowLayout.minimumColumnSpacing = 10;
        _flowLayout.minimumInteritemSpacing = 10;
        _flowLayout.columnCount = 2;
    }else {
        _flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _flowLayout.minimumColumnSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.columnCount = 1;
    }
    [_collectionView setCollectionViewLayout:_flowLayout animated:NO];
}

- (void)requestTopicData {
//a=getMyTopicList($token = null,$page= 0)
    NSDictionary *param = @{ @"token" :  [SDataCache sharedInstance].userInfo[@"token"],
                                 @"page" : @(_pageIndex)};
    [[SDataCache sharedInstance] get:@"Topic" action:@"getMyTopicList" param:param success:^(AFHTTPRequestOperation *operation, id object) {
        NSLog(@"object ---- %@", object);
        NSDictionary *dictionary = (NSDictionary*)object;
        NSArray *dataArray = dictionary[@"data"];
        if ([dictionary[@"status"] intValue] == 1) {
            if (_pageIndex == 0) {
                _listTopicArray = [StopicListModel modelArrayForDataArray:dataArray];
            }else {
                [_listPicArray addObjectsFromArray:[StopicListModel modelArrayForDataArray:dataArray]];
            }
            [self changeLayout];
            [_collectionView reloadData];
            [self requesetWithSuccess];
        }
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error ---- %@", error);
        [self requesetWithSuccess];
    }];
}

- (void)requestPicData {
    //    a= getMyCollocationListForTopic($token = null,$page= 0)
    NSDictionary *param = @{ @"token" : [SDataCache sharedInstance].userInfo[@"token"],
                             @"page" : @(_pageIndex) };
    [[SDataCache sharedInstance] get:@"Topic" action:@"getMyCollocationListForTopic" param:param success:^(AFHTTPRequestOperation *operation, id object) {
        NSLog(@"object ---- %@", object);
        NSDictionary *dictionary = (NSDictionary*)object;
        if ([dictionary[@"status"] intValue] == 1) {
            NSMutableArray *temptArray = [NSMutableArray new];
            for (NSDictionary *dic in dictionary[@"data"]) {
                SMyTopicPicModel *model = [[SMyTopicPicModel alloc]initWithDic:dic];
                [temptArray addObject:model];
                if (_pageIndex == 0) {
                    _listPicArray = temptArray;
                }else {
                    [_listPicArray addObjectsFromArray:temptArray];
                }
            }
            [self changeLayout];
            [_collectionView reloadData];
            [self requesetWithSuccess];
        }
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error ---- %@", error);
        [self requesetWithSuccess];
    }];
}

- (void)requesetWithSuccess {
    [_collectionView headerEndRefreshing];
    [_collectionView footerEndRefreshing];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selecetBtnIndex) { //照片
        return _listPicArray.count;
    }else {
        return _listTopicArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    if (_selecetBtnIndex) { //照片
        SMyTopicPicCollectionViewCell *picCell = [collectionView dequeueReusableCellWithReuseIdentifier:myTopicPicCellIdentifier forIndexPath:indexPath];
        picCell.model = _listPicArray[indexPath.row];
        picCell.collectionView = self;
        cell = picCell;
    }else { //话题
        SMyTopicCollectionViewCell *topicCell = [collectionView dequeueReusableCellWithReuseIdentifier:myTopicTopicCellIdentifier forIndexPath:indexPath];
        topicCell.contentModel = _listTopicArray[indexPath.row];
        topicCell.parentVC = self;
        cell = topicCell;
    }
    return cell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:WaterFallSectionHeader]) {
        SMyTopicHeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:myTopicWaterFallSectionHeader forIndexPath:indexPath];
        view.model = _headerModel;
        view.targer = self;
        reusableView = view;
        
        CGFloat height = 55;
        CGRect frame = view.selectedButtonContentView.frame;
        frame.size.height = height;
        frame.origin.y = view.height - height;
        view.selectedButtonContentView.frame = frame;
        _beginOrigin_Y = frame.origin.y;
        
        _selectedContentView.frame = frame;
        [self scrollViewDidScroll:collectionView];
        
        [_collectionView bringSubviewToFront:_selectedContentView];

    }
    return reusableView;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section {
    return 320;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    if (_selecetBtnIndex) { //照片
        if (!_listPicArray.count) {
            size = CGSizeMake((UI_SCREEN_WIDTH - 30)/ 2, 300 * UI_SCREEN_WIDTH/ 375.0);
            return size;
        }
//        size = CGSizeMake((UI_SCREEN_WIDTH - 30)/ 2, 300 * UI_SCREEN_WIDTH/ 375.0);
        size = CGSizeMake((UI_SCREEN_WIDTH - 30)/ 2, 0);
        SMyTopicPicModel *model = _listPicArray[indexPath.row];
        CGFloat height = [model.img_height floatValue];
        CGFloat width = [model.img_width floatValue];
        size.height = height * (size.width /width) + 60;
    }else {
        size = CGSizeMake(UI_SCREEN_WIDTH, 200.0);
    }
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_selecetBtnIndex) {
//        SMyTopicPicModel *model = _listPicArray[indexPath.row];
//        SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
//        collocationDetailVC.collocationId =  [model.aid intValue];
//        [self.navigationController pushViewController:collocationDetailVC animated:YES];

        SMyTopicPicModel *model = _listPicArray[indexPath.row];
        extern BOOL g_socialStatus;
        if (g_socialStatus)//是否处于社交状态
        {
            SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
            detailNoShoppingViewController.collocationId = model.aid ;
            [self.navigationController pushViewController:detailNoShoppingViewController animated:YES];
        }
        else
        {
            SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
                collocationDetailVC.collocationId = model.aid ;
            [self.navigationController pushViewController:collocationDetailVC animated:YES];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint location = scrollView.contentOffset;
    CGRect frame = _selectedContentView.frame;
    if (location.y > _beginOrigin_Y) {
        frame.origin.y = location.y;
    }else{
        frame.origin.y = _beginOrigin_Y;
    }
    _selectedContentView.frame = frame;
    
    if (_beginOrigin_Y - location.y <= 0) {
        self.navigationController.navigationBar.alpha = 0;
    }else if(_beginOrigin_Y - location.y >= 44){
        self.navigationController.navigationBar.alpha = 1;
    }else{
        self.navigationController.navigationBar.alpha = (_beginOrigin_Y - location.y)/ 44.0;
    }

}

@end
