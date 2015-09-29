//
//  SBrandSotryViewController.m
//  Wefafa
//
//  Created by unico_0 on 6/13/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SBrandSotryViewController.h"
#import "SBrandHeaderReusableView.h"
#import "SBrandStoryDetailModel.h"
#import "SActivityBrandListModel.h"
#import "SSearchProductModel.h"
#import "SSearchProductCollectionViewCell.h"
#import "SCollocationDetailViewController.h"
#import "SWaterCollectionViewCell.h"
#import "UIScrollView+MJRefresh.h"
#import "SProductDetailViewController.h"
#import "SDataCache.h"
#import "HttpRequest.h"
#import "LNGood.h"
#import "WeFaFaGet.h"
#import "SUtilityTool.h"
#import "Toast.h"
#import "WaterFLayout.h"
#import "SCollocationLoversController.h"
#import "StopicSelectedButton.h"
#import "SFilterBrandController.h"

#import "SCollocationDetailNoneShopController.h"

@interface SBrandSotryViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, SBrandHeaderReusableViewDelegate>
{
    int _selectedIndex;
    int _sortSelectedIndex;
    BOOL _isSortSequence;
    NSInteger _pageIndex;
    CALayer *_topSelectedLineLayer;
    CALayer *_bottomSelectedLineLayer;
    
    CGFloat _beginOrigin_Y;
}

@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *showMyBrandButton;
- (IBAction)showMyBrandButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *showMyBrandCameraButton;

@property (nonatomic, strong) SBrandStoryDetailModel *headerModel;
@property (nonatomic, strong) NSMutableArray *productListArray;
@property (nonatomic, strong) NSMutableArray *collocationListArray;

@property (nonatomic, weak) UIView *selectedContentView;

@property (nonatomic, strong) NSMutableArray *topButtonArray;
@property (nonatomic, strong) NSMutableArray *bottomButtonArray;
@property (nonatomic, strong) NSMutableDictionary *brandFilterDictionary;
@property (nonatomic) WaterFLayout* flowLayout;
@end

static NSString *headerIdentifier = @"SBrandSotryHeaderIdentifier";
static NSString *productCellIdentifier = @"SBrandSotryProductCellIdentifier";
@implementation SBrandSotryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self initSubViews];
    [self requestBrandDetails];
//    [self requestCollocationListData];
}

- (void)initNavigationBar{
    [super setupNavbar];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/common_navi_transparentblack.png"] forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    self.navigationItem.leftBarButtonItems = @[left1];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.alpha = 1.0;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/common_navi_mixblack.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/common_navi_transparentblack.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self scrollViewDidScroll:_contentCollectionView];
    if (self.brandFilterDictionary) {
        [self requestProductListData];
    }
}

- (void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubViews{
    self.contentCollectionView.alwaysBounceVertical = YES;
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"SBrandHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:headerIdentifier];
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"SWaterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:waterCellIdentifier];
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"SSearchProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:productCellIdentifier];
    [self.contentCollectionView addFooterWithTarget:self action:@selector(requestAddData)];
    
    _flowLayout = [[WaterFLayout alloc]init];
    _flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _contentCollectionView.collectionViewLayout = _flowLayout;
    
    _showMyBrandButton.layer.masksToBounds = YES;
    _showMyBrandButton.layer.cornerRadius = 3;
    
    [self initSelectedContentView];
}

- (void)initSelectedContentView{
    _topButtonArray = [NSMutableArray array];
    _bottomButtonArray = [NSMutableArray array];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 99)];
    view.layer.masksToBounds = YES;
    view.backgroundColor = COLOR_C9;
    [self.contentCollectionView addSubview:view];
    _selectedContentView = view;
    
    NSArray *titleArray = @[@"搭配", @"单品"];
    int count = 2;
    for (int i = 0; i < count; i ++) {
        StopicSelectedButton *topButton = [[StopicSelectedButton alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/ count * i, 0.5, UI_SCREEN_WIDTH/ count - 0.5, 54)];
        topButton.titleLabel.font = FONT_t2;
        [topButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [topButton setTitleColor:COLOR_C2 forState:UIControlStateSelected];
        [topButton setTitleColor:COLOR_C7 forState:UIControlStateNormal];
        topButton.backgroundColor = [UIColor whiteColor];
        topButton.tag = 140 + i;
        [topButton addTarget:self action:@selector(topSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:topButton];
        [_topButtonArray addObject:topButton];
    }
    _topSelectedLineLayer = [CALayer layer];
    _topSelectedLineLayer.backgroundColor = COLOR_C1.CGColor;
    _topSelectedLineLayer.frame = CGRectMake(0, 51.5, 75, 3);
    _topSelectedLineLayer.zPosition = 5;
    [view.layer addSublayer:_topSelectedLineLayer];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 55.0, UI_SCREEN_WIDTH, 44)];
    backView.backgroundColor = [UIColor whiteColor];
    [view addSubview:backView];
    
    titleArray = @[@"默认", @"上新", @"价格", @"筛选"];
    count = 4;
    NSArray *imageNameArray = @[@"", @"", @"Unico/btn_sort_nomal", @"Unico/btn_selected_icon"];
    CGFloat origin_X = 0.0;
    for (int i = 0; i < count; i++) {
        origin_X = (70 + (UI_SCREEN_WIDTH - 75 * count)/ (count - 1)) * i;
        UIButton *bottomButton = [[UIButton alloc]initWithFrame:CGRectMake(origin_X, 55, 70, 44)];
        NSString *imageName = imageNameArray[i];
        if (![imageName isEqualToString:@""]) {
            [bottomButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            bottomButton.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
        }
        if (i == 3) {
            [bottomButton setImage:[UIImage imageNamed:@"Unico/btn_selected_icon_selected"] forState:UIControlStateSelected];
        }
        bottomButton.titleLabel.font = FONT_t4;
        [bottomButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [bottomButton setTitleColor:COLOR_C2 forState:UIControlStateSelected];
        [bottomButton setTitleColor:COLOR_C7 forState:UIControlStateNormal];
        bottomButton.tag = 180 + i;
        [bottomButton addTarget:self action:@selector(bottomSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:bottomButton];
        [_bottomButtonArray addObject:bottomButton];
    }
    
    _bottomSelectedLineLayer = [CALayer layer];
    _bottomSelectedLineLayer.backgroundColor = COLOR_C1.CGColor;
    _bottomSelectedLineLayer.frame = CGRectMake(0, 96.0, 40, 3);
    _bottomSelectedLineLayer.zPosition = 5;
    [view.layer addSublayer:_bottomSelectedLineLayer];
    
    [self topSelectedButton:[_topButtonArray firstObject]];
    [self bottomSelectedButton:[_bottomButtonArray firstObject]];
}

-(void)requestBrandDetails{
    [SDATACACHE_INSTANCE getBrandDetails:self.brandId complete:^(id data, NSError *error) {
        if (error) {
            [Toast makeToast:@"请求错误！" duration:1.5 position:@"center"];
        }else{
            self.headerModel = [[SBrandStoryDetailModel alloc]initWithDictionary:data];
        }
    }];
}

- (void)requestProductListData{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"brandId": _brandId,
                                                                           @"pageIndex": @(_pageIndex + 1),
                                                                           @"pageSize": @10}];
    if (_sortSelectedIndex == 2){
        params[@"sortInfo"] = @{@"SortField": @(3), @"Desc": @(!_isSortSequence)};
    }else if (_sortSelectedIndex != 0) {
        params[@"sortInfo"] = @{@"SortField": @(_sortSelectedIndex), @"Desc": @(!_isSortSequence)};
    }
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:params];
    if (self.brandFilterDictionary) {
        [dictionary setValuesForKeysWithDictionary:self.brandFilterDictionary];
    }
    [HttpRequest productPostRequestPath:nil methodName:@"ProductClsCommonSearchFilter" params:dictionary success:^(NSDictionary *dict) {
        [self.contentCollectionView footerEndRefreshing];
        if ([dict[@"isSuccess"] boolValue]) {
            NSMutableArray *array = [SSearchProductModel modelArrayForCategaryDataArray:dict[@"results"]];
            if (_pageIndex == 0) {
                if([array count]==0)
                {
                    //                    return ;
                }
                self.productListArray = array;
            }else{
                [self.productListArray addObjectsFromArray:array];
                [self.contentCollectionView reloadData];
            }
        }else{
            [Toast makeToast:dict[@"message"] duration:1.5 position:@"center"];
        }
    } failed:^(NSError *error) {
        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
    }];
}

-(void)requestCollocationListData{
    [SDATACACHE_INSTANCE getCollocationListForBrand:self.brandId page:_pageIndex complete:^(NSArray *data) {
        [self.contentCollectionView footerEndRefreshing];
        NSMutableArray *array = [LNGood modelArrayForDataArray:data];
        if (_pageIndex == 0) {
            self.collocationListArray = array;
        }else{
            [self.collocationListArray addObjectsFromArray:array];
            [self.contentCollectionView reloadData];
        }
    }];
}

- (void)setHeaderModel:(SBrandStoryDetailModel *)headerModel{
    _headerModel = headerModel;
    
    NSString *showString = [NSString stringWithFormat:@"晒出我的%@", headerModel.english_name];
    _showMyBrandButton.hidden = NO;
    _showMyBrandCameraButton.hidden = NO;
    [_showMyBrandButton setTitle:showString forState:UIControlStateNormal];
    CGSize showButtonSize = [showString sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:13]}];
    CGRect frame = _showMyBrandButton.frame;
    frame.origin.x = UI_SCREEN_WIDTH - showButtonSize.width - 35;
    _showMyBrandButton.frame = frame;
    
    StopicSelectedButton *button = _topButtonArray[0];
    button.subLabel.text = [Utils getSNSInteger:headerModel.coll_count.stringValue];
    button = _topButtonArray[1];
    button.subLabel.text = [Utils getSNSInteger:headerModel.item_count.stringValue];
    
    [self.contentCollectionView reloadData];
}

- (void)setCollocationListArray:(NSMutableArray *)collocationListArray{
    _collocationListArray = collocationListArray;
    [self.contentCollectionView reloadData];
}

- (void)setProductListArray:(NSMutableArray *)productListArray{
    _productListArray = productListArray;
    [self.contentCollectionView reloadData];
}

- (void)requestAddData{
    if (_selectedIndex == 0) {
        _pageIndex = (_collocationListArray.count + 9)/ 10;
        [self requestCollocationListData];
    }else{
        _pageIndex = (_productListArray.count + 9)/ 10;
        [self requestProductListData];
    }
}

#pragma mark - scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
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

#pragma mark - action 

- (void)topSelectedButton:(UIButton*)sender{
    for (UIButton *button in _topButtonArray) {
        button.selected = button == sender;
    }
    _pageIndex = 0;
    _selectedIndex = (int)sender.tag - 140;
    CGPoint position = _topSelectedLineLayer.position;
    position.x = sender.centerX;
    _topSelectedLineLayer.position = position;
    
//    _flowLayout.columnCount = sender.tag - 140 ? 2 : 3;
//    _contentCollectionView.collectionViewLayout = _flowLayout;
    
    if (_selectedIndex == 0) {
        if (_collocationListArray.count) {
            [self.contentCollectionView reloadData];
            return;
        }
        [self requestCollocationListData];
    }else{
        if (_productListArray.count) {
            [self.contentCollectionView reloadData];
            return;
        }
        [self requestProductListData];
    }
}

- (void)bottomSelectedButton:(UIButton*)sender{
    _sortSelectedIndex = (int)sender.tag - 180;
    if (_sortSelectedIndex == 3) {
        if (sender.selected){
            sender.selected = NO;
            self.brandFilterDictionary = nil;
            [self requestProductListData];
        }else{
            sender.selected = YES;
            self.brandFilterDictionary = [NSMutableDictionary dictionary];
            SFilterBrandController *controller = [[SFilterBrandController alloc]initWithNibName:@"SFilterCollectionViewController" bundle:nil];
            controller.brandFilterDictionary = self.brandFilterDictionary;
            [self.navigationController pushViewController:controller animated:YES];
        }
        return;
    }
    for (int i = 0; i < 3; i++) {
        UIButton *button = _bottomButtonArray[i];
        button.selected = button == sender;
    }
    _pageIndex = 0;
    if (_sortSelectedIndex != 2) {
        _isSortSequence = NO;
        UIButton *button = _bottomButtonArray[2];
        [button setImage:[UIImage imageNamed:@"Unico/btn_sort_nomal"] forState:UIControlStateNormal];
    }else{
        _isSortSequence = !_isSortSequence;
        NSString *imageName = @"";
        if (_isSortSequence) {
            imageName = @"Unico/btn_sort_top";
        }else{
            imageName = @"Unico/btn_sort_bottom";
        }
        [sender setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    CGPoint position = _bottomSelectedLineLayer.position;
    position.x = sender.centerX;
    if (_sortSelectedIndex == 2) {
        position.x += 5;
    }
    _bottomSelectedLineLayer.position = position;
    
    [self requestProductListData];
}

#pragma mark - header delegate

- (void)brandHeader:(SBrandHeaderReusableView *)headerView likeButton:(UIButton*)button{
    
    SDataCache *dataChche = [SDataCache sharedInstance];
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    
    if (button.selected){
        [dataChche delLikeBrand:dataChche.userInfo[@"token"] brandId:[NSString stringWithFormat:@"%@",_brandId] complete:^(id data) {
            if ([data intValue] == 1) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"brandRefresh" object:nil userInfo:nil];
                
                NSString *string = [NSString stringWithFormat:@"取消喜欢%@成功！", _headerModel.english_name];
                [Toast makeToastSuccess:string];
                for (SBrandStoryUserModel *model in _headerModel.like_user_list) {
                    if ([model.user_id isEqualToString:sns.ldap_uid]) {
                        [_headerModel.like_user_list removeObject:model];
                        break;
                    }
                }
                _headerModel.is_love = @NO;
                int like_count = [_headerModel.like_count intValue] -1;
                _headerModel.like_count = [NSNumber numberWithInt:like_count];
                
                [self.contentCollectionView reloadData];
            }
        }];
    }else{
        [dataChche likeBrand:dataChche.userInfo[@"token"] brandId:[NSString stringWithFormat:@"%@",_brandId] complete:^(id data) {
            if ([data intValue] == 1) {
                NSString *string = [NSString stringWithFormat:@"成功喜欢%@！", _headerModel.english_name];
                [Toast makeToastSuccess:string];
                SBrandStoryUserModel *model = [SBrandStoryUserModel new];
                model.head_img = sns.myStaffCard.photo_path;
                model.user_id = sns.ldap_uid;
                [_headerModel.like_user_list insertObject:model atIndex:0];
                _headerModel.is_love = @YES;
                int like_count = [_headerModel.like_count intValue] +1;
                _headerModel.like_count = [NSNumber numberWithInt:like_count];
                
                [self.contentCollectionView reloadData];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"brandRefresh" object:nil userInfo:nil];
                
            }
        }];
    }
}
-(void)brandHeader:(SBrandHeaderReusableView *)headerView moreButton:(UIButton *)button
{
    SCollocationLoversController *loverController = [[SCollocationLoversController alloc] init];
    loverController.brandId =[NSString stringWithFormat:@"%ld",(long)self.brandId];
    [self.navigationController pushViewController:loverController animated:YES];
}
#pragma mark - collectionVIew delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (_selectedIndex == 0) {
        count = _collocationListArray.count;
    }else{
        count = _productListArray.count;
    }
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake((UI_SCREEN_WIDTH - 30)/ 2, 0);
    if (_selectedIndex == 0) {
        LNGood *goodsModel = _collocationListArray[indexPath.row];
        size.height = goodsModel.h * (size.width /goodsModel.w) + 60;
    }else{
        size.height = 300 * UI_SCREEN_WIDTH/ 375.0;
    }
    return size;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *returnCell = nil;
    if (_selectedIndex == 0) {
        SWaterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:waterCellIdentifier forIndexPath:indexPath];
        cell.contentGoodsModel = _collocationListArray[indexPath.row];
        returnCell = cell;
        
    }else{
        SSearchProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:productCellIdentifier forIndexPath:indexPath];
        cell.isShowPrice = YES;
        if (indexPath.row<[_productListArray count])
        {
            cell.contentModel = _productListArray[indexPath.row];
        }
        returnCell = cell;
    }
    return returnCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedIndex == 0) {
        LNGood *good = _collocationListArray[indexPath.row];
        NSString * collocationId  = good.product_ID;
        if (collocationId<0) {
            return;
        }
       /* SCollocationDetailViewController *controller = [SCollocationDetailViewController new];
        controller.collocationId = collocationId;
        [self.navigationController pushViewController:controller animated:YES];*/
        extern BOOL g_socialStatus;
        if (g_socialStatus)//是否处于社交状态
        {
            SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
            detailNoShoppingViewController.collocationId = collocationId;
            [self.navigationController pushViewController:detailNoShoppingViewController animated:YES];
        }else{
            SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
            collocationDetailVC.collocationId = collocationId;
            [self.navigationController pushViewController:collocationDetailVC animated:YES];
        }
    }else{
        SActivityBrandListModel *model = _productListArray[indexPath.row];
        SProductDetailViewController *controller = [SProductDetailViewController new];
//        controller.productID = model.aID.stringValue;
        controller.productID = [NSString stringWithFormat:@"%@",model.code];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:WaterFallSectionHeader]) {
        SBrandHeaderReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        view.delegate = self;
        view.jumpController = self;
        view.contentModel = _headerModel;
        reusableView = view;
        
        CGFloat height = _selectedIndex == 0? 55: 99;
        for (NSLayoutConstraint *layout in view.selectedButtonContentView.constraints) {
            if (layout.firstAttribute == NSLayoutAttributeHeight){
                layout.constant = height;
            }
        }
        CGRect frame = view.selectedButtonContentView.frame;
        frame.size.height = height;
        frame.origin.y = view.height - height;
        view.selectedButtonContentView.frame = frame;
        _beginOrigin_Y = frame.origin.y;
        
        frame.origin = _selectedContentView.frame.origin;
        _selectedContentView.frame = frame;
        [self scrollViewDidScroll:collectionView];
        
        [_contentCollectionView bringSubviewToFront:_selectedContentView];
    }
    return reusableView;
}

#pragma mark ADD Header AND Footer
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    CGSize size = [[NSString stringWithFormat:@"    %@", _headerModel.story] boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
    size.height -= _selectedIndex == 0? 44: 0;
    return 430 * UI_SCREEN_WIDTH/ 320 + size.height;
}

- (IBAction)showMyBrandButtonAction:(UIButton *)sender {
    NSDictionary *info = @{@"type":@(CoverTagTypeBrand),
                           @"text":_headerModel.english_name,
                           @"id":_headerModel.aID
                           };
    [[SUtilityTool shared] showCamera:info];
}
@end
