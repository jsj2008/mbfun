//
//  SSearchCollocationViewController.m
//  Wefafa
//
//  Created by Jiang on 15/9/8.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SSearchCollocationViewController.h"
#import "SelectedSubContentView.h"

#import "SUtilityTool.h"
#import "SDataCache.h"
#import "Toast.h"
#import "UIScrollView+MJRefresh.h"

#import "SSearchCollocationCollectionView.h"
#import "SCollocationDetailNoneShopController.h"
#import "SCollocationDetailViewController.h"

#import "WaterFLayout.h"

#import "SWaterCollectionViewCell.h"
#import "BrandDetailTemptCollectionViewCell.h"
#import "StopicSelectedButton.h"

#import "SUploadColllocationControlCenter.h"

#import "SDataCache.h"
#import "LNGood.h"



@interface SSearchCollocationViewController ()
    <UIScrollViewDelegate,UICollectionViewDataSource,
    UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
    SelectedSubContentViewDelegate,SSearchCollocationCollectionViewDelegate,
    kMainViewCellDelegate>
{
    NSInteger _pageIndex;
    NSInteger _selectedIndex;
    
    CALayer *_topSelectedLineLayer;
    
    UIView *_showNoneData;
}
@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) WaterFLayout *flowLayout;

@property (nonatomic, weak) UIView *selectedContentView;

@property (nonatomic, strong) NSMutableArray *topButtonArray;

@property (nonatomic, strong) NSMutableArray *collocationListArray;
@end

static NSString *brandheaderIdentifier = @"brandDetailHeaderID";
static NSString *brandproductCellIdentifier = @"brandproductCellIdentifier";
@implementation SSearchCollocationViewController

- (void)setCollocationListArray:(NSMutableArray *)collocationListArray{
    _collocationListArray = collocationListArray;
    [self.contentCollectionView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COLOR_C4;
    _pageIndex = 0;
    _selectedIndex = 0;
    
    [self setupNavbar];
    [self initSubViews];
}

- (void)setupNavbar{
    [super setupNavbar];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage imageNamed:@"Unico/common_navi_mixblack.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    self.title = @"相关搭配";
    
    self.navigationItem.hidesBackButton = NO;
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 30)];
    titleView.backgroundColor = [UIColor clearColor];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(-5, 0, UI_SCREEN_WIDTH - 80, 30)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 6.0;
    
    CGRect rect = backView.bounds;
    if ([[[UIDevice currentDevice]systemVersion] intValue] < 8.0) {
        rect = CGRectInset(rect, -10, 0);
    }
    
    UIButton *backItemButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 44)];
    [backItemButton setImage:[UIImage imageNamed:@"Unico/community_camera"] forState:UIControlStateNormal];
    [backItemButton addTarget:self action:@selector(jumpViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:backItemButton];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
}

#pragma mark - 跳入相机
- (void)jumpViewController
{
    [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showUploadColllocationHomeViewWithAnimated:YES];
}

- (void)onBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubViews{
    _topButtonArray = [NSMutableArray array];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, 54)];
    view.layer.masksToBounds = YES;
    view.backgroundColor = COLOR_C9;
    [self.view addSubview:view];
    _selectedContentView = view;
    
    NSArray *imgHighArray = @[@"Unico/squarehighlight.png", @"Unico/sandaoganghighlight.png"];
    NSArray *imgShadowArray = @[@"Unico/squareshadow.png", @"Unico/sandaogangshadow.png"];
    int count = 2;
    for (int i=0; i<count; i++) {
        StopicSelectedButton *topButton = [[StopicSelectedButton alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/ count * i, 0.5, UI_SCREEN_WIDTH/ count , 54)];
        topButton.titleLabel.font = FONT_t2;
        
        [topButton setImage:[UIImage imageNamed:imgHighArray[i]] forState:UIControlStateSelected];
        [topButton setImage:[UIImage imageNamed:imgShadowArray[i]] forState:UIControlStateNormal];
        
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
    
    [self topSelectedButton:_topButtonArray[0]];
    
    [self initContentScrollView];
}

#pragma mark 添加列表
- (void)initContentScrollView
{
    _flowLayout = [[WaterFLayout alloc]init];
    _flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _contentCollectionView.collectionViewLayout = _flowLayout;
    CGRect frame = CGRectMake(0, 64+54, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64-54);
    _contentCollectionView = [[UICollectionView alloc] initWithFrame:frame
                                                collectionViewLayout:_flowLayout];
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    _contentCollectionView.backgroundColor = COLOR_C4;
    _contentCollectionView.alwaysBounceVertical = YES;
    [self.view addSubview:_contentCollectionView];
    
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"SWaterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:waterCellIdentifier];
    [self.contentCollectionView registerClass:NSClassFromString(@"BrandDetailTemptCollectionViewCell") forCellWithReuseIdentifier:brandproductCellIdentifier];
    
    [self.contentCollectionView addFooterWithTarget:self action:@selector(requestAddData)];
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
    
    //界面配置变换
    _flowLayout.columnCount = sender.tag - 140 ? 1 : 2;
    _flowLayout.sectionInset = sender.tag - 140 ? UIEdgeInsetsMake(10, 0, 10, 0) : UIEdgeInsetsMake(10, 10, 10, 10);
    _flowLayout.minimumInteritemSpacing = sender.tag - 140 ? 0 : 10;
    _contentCollectionView.collectionViewLayout = _flowLayout;
//    _contentCollectionView.backgroundColor = sender.tag - 140 ? COLOR_C11 : [UIColor whiteColor];
    
    if (_selectedIndex == 0) {
        if (_collocationListArray) {
            [self.contentCollectionView reloadData];
            return;
        }
        [self requestData];
    }else{
        if (_collocationListArray) {
            [self.contentCollectionView reloadData];
            return;
        }
        [self requestData];
    }
}

#pragma mark -
//m=Collocation&a=getCollocationForMyProduct" + "&pid=" + pid + "&page=" + page
- (void)requestData
{
    if (_topicTagString) {
        self.title = [NSString stringWithFormat:@"#%@", _topicTagString];
        [self requestDataForTopicTag];
    }else{
        [self requestDataForProductId];
    }
}

- (void)requestDataForProductId{
    NSDictionary *param = @{
                            @"m":@"Collocation",
                            @"a":@"getCollocationForMyProduct",
                            @"pid":self.productId,
                            @"page":@(_pageIndex),
                            };
    [[SDataCache sharedInstance] quickGet:SERVER_URL parameters:param success:^(AFHTTPRequestOperation *operation, id object) {
        [_contentCollectionView footerEndRefreshing];
        [_contentCollectionView headerEndRefreshing];
        if ([[NSString stringWithFormat:@"%@", object[@"status"]] isEqualToString:@"1"]) {
            if ([object[@"data"] count]<=0) {
                [self showNoneData];
            } else {
                NSMutableArray *tempArray = [NSMutableArray new];
                for (NSDictionary *dic in object[@"data"]) {
                    SMDataModel *model = [[SMDataModel alloc] initWithDictionary:dic];
                    [tempArray addObject:model];
                }
                
                if (tempArray.count < 10) {
                    _contentCollectionView.footerHidden = YES;
                }
                
                if (_pageIndex == 0) {
                    self.collocationListArray = tempArray;
                }else{
                    [self.collocationListArray addObjectsFromArray:tempArray];
                    self.collocationListArray = self.collocationListArray;
                }
            }
        } else {
            [self showNoneData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Toast makeToast:error.userInfo[@"info"]];
    }];
}

- (void)requestDataForTopicTag{
    if (!_topicTagString) return;
    NSDictionary *data = @{
                           @"m": @"Topic",
                           @"a": @"getCollocationListForTopic",
                           @"page": @(_pageIndex),
                           @"tab": _topicTagString
                           };
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        [_contentCollectionView footerEndRefreshing];
        [_contentCollectionView headerEndRefreshing];
        if (_pageIndex == 0) {
            NSMutableArray *tempArray = [NSMutableArray new];
            for (NSDictionary *dic in responseObject[@"data"]) {
                SMDataModel *model = [[SMDataModel alloc] initWithDictionary:dic];
                [tempArray addObject:model];
            }
            if (_pageIndex == 0) {
                self.collocationListArray = tempArray;
            }else{
                [self.collocationListArray addObjectsFromArray:tempArray];
                self.collocationListArray = self.collocationListArray;
            }
        }else{
            
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [Toast makeToast:kNoneInternetTitle];
        [_contentCollectionView headerEndRefreshing];
        [_contentCollectionView footerEndRefreshing];
    }];
}

- (UIView *)showNoneData{
    if (!_showNoneData) {
        CGRect frame = CGRectMake(0, 200, self.view.frame.size.width, 200);
        UIView *view = [[UIView alloc]initWithFrame:frame];
        view.backgroundColor = [UIColor clearColor];
        view.opaque = NO;
        frame.origin.y = 0;
        frame.size.height = 160;
        UILabel *label = [[UILabel alloc]initWithFrame:frame];
        label.textColor = COLOR_C6;
        label.font = FONT_T3;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"暂无相关搭配";
        [view addSubview:label];
        
        [self.view addSubview:view];
        _showNoneData = view;
    }
    return _showNoneData;
}

- (void)requestAddData{
//    UIView *view = self.contentScrollView.subviews[_selectedIndex];
//    [view setValue:@NO forKey:@"isAbandonRefresh"];
//    NSArray *array = [view valueForKey:@"contentArray"];
//    _pageIndex = (array.count + _pageSize - 1)/ _pageSize;
    [self requestData];
}

#pragma mark - collection view delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _collocationListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *returnCell = nil;
    if (_selectedIndex == 0) {
        SWaterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:waterCellIdentifier forIndexPath:indexPath];
        cell.model = _collocationListArray[indexPath.row];
        returnCell = cell;
    } else {
        SMDataModel *model= _collocationListArray[indexPath.row];
        BrandDetailTemptCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:brandproductCellIdentifier forIndexPath:indexPath];
        cell.parentVc = self;
        cell.delegate = self;
        cell.isLikeBlock = ^(BOOL isLike){
            model.is_love = @(isLike);
            if (isLike) {
                model.like_count = [NSString stringWithFormat:@"%d", ([model.like_count intValue] + 1)];
            } else {
                model.like_count = [NSString stringWithFormat:@"%d", ([model.like_count intValue] - 1)];
            }
            
            [_contentCollectionView reloadData];
        };
        [cell updateCellUIWithModel:model atIndex:indexPath];
        returnCell = cell;
    }
    return returnCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    CGSize size = CGSizeMake((UI_SCREEN_WIDTH - 30)/ 2, 0);
    CGSize size = CGSizeZero;
    SMDataModel *goodsModel = _collocationListArray[indexPath.row];
    if (_selectedIndex == 0) {
        size = CGSizeMake((UI_SCREEN_WIDTH - 30)/ 2, 0);
        //        LNGood *goodsModel = _collocationListArray[indexPath.row];
        size.height = [goodsModel.img_height floatValue] * (size.width /[goodsModel.img_width floatValue]) + 60;
    }else{
        //        size.height = 300 * UI_SCREEN_WIDTH/ 375.0;
        /*********//*********/
        //        CGFloat height;
        //        LNGood *model;
        //        if (_productListArray.count > indexPath.row) {
        //            model = [_collocationListArray objectAtIndex:indexPath.row];
        //        }
        //        height = model.h * (size.width /model.w);  //图片高度
        //        height += 75 / 2;//header高度
        //        height += 40 / 2;//底部高度
        //        height += 36 / 2;//collectionview高度
        //        height += model.infoHeight;//文字高度
        //        size.height = height;
        /*********//*********/
        /*
        size = CGSizeMake(UI_SCREEN_WIDTH, 0);
        CGFloat height = 0;
        height = [goodsModel.img_height floatValue] * UI_SCREEN_WIDTH/ [goodsModel.img_width floatValue];
        height += 70;//header高度
        height += 50;//底部高度
        height += 50;
        if (goodsModel.content_info.length > 0) {
            height += [goodsModel.content_info boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
            height += 15.0;
        }
        if (goodsModel.likeUserArray.count <= 0) {
            height -= 35.0;
        }
        height -= 5;
        size.height = height;
         */
        goodsModel.commentHeight = 0;
        size = CGSizeMake(UI_SCREEN_WIDTH, 0);
        CGFloat height = 0;
        height = goodsModel.cellHeight;
        size.height = height;
    }
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedIndex == 0) {
        /*
         LNGood *good = _collocationListArray[indexPath.row];
         NSInteger collocationId  = [good.product_ID integerValue];
         if (collocationId<0) {
         return;
         }
         */
        SMDataModel *good = _collocationListArray[indexPath.row];
        NSString * collocationId  = [NSString stringWithFormat:@"%@",good.idValue];
        /* SCollocationDetailViewController *controller = [SCollocationDetailViewController new];
         controller.collocationId = collocationId;
         [self.navigationController pushViewController:controller animated:YES];*/
        extern BOOL g_socialStatus;
        if (g_socialStatus)//是否处于社交状态
        {
            SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
            detailNoShoppingViewController.smdataModel=good;
            detailNoShoppingViewController.isLikeBlock = ^(BOOL isLike){
                good.is_love = @(isLike);
                if (isLike) {
                    good.like_count = [NSString stringWithFormat:@"%d", ([good.like_count intValue] + 1)];
                } else {
                    good.like_count = [NSString stringWithFormat:@"%d", ([good.like_count intValue] - 1)];
                }
                
                [_contentCollectionView reloadData];
            };
            
            detailNoShoppingViewController.collocationId = collocationId;
            [self.navigationController pushViewController:detailNoShoppingViewController animated:YES];
        }else{
            SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
            collocationDetailVC.smdataModel=good;
            collocationDetailVC.isLikeBlock = ^(BOOL isLike){
                good.is_love = @(isLike);
                if (isLike) {
                    good.like_count = [NSString stringWithFormat:@"%d", ([good.like_count intValue] + 1)];
                } else {
                    good.like_count = [NSString stringWithFormat:@"%d", ([good.like_count intValue] - 1)];
                }
                [_contentCollectionView reloadData];
            };
            
            collocationDetailVC.collocationId = collocationId;
            [self.navigationController pushViewController:collocationDetailVC animated:YES];
        }
    }else{
        /*
         LNGood *good = _collocationListArray[indexPath.row];
         NSInteger collocationId  = [good.product_ID integerValue];
         if (collocationId<0) {
         return;
         }
         */
        SMDataModel *good = _collocationListArray[indexPath.row];
        NSString * collocationId  = good.idValue ;
        if (collocationId<0) {
            return;
        }
        extern BOOL g_socialStatus;
        if (g_socialStatus)//是否处于社交状态
        {
            SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
            detailNoShoppingViewController.smdataModel=good;
            
            detailNoShoppingViewController.collocationId = collocationId;
            [self.navigationController pushViewController:detailNoShoppingViewController animated:YES];
        }else{
            SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
            collocationDetailVC.smdataModel=good;
            
            collocationDetailVC.collocationId = collocationId;
            [self.navigationController pushViewController:collocationDetailVC animated:YES];
        }
    }
}



#pragma mark - delegate
#pragma mark - SelectedSubContentViewDelegate
- (void)selectedSubContentViewSelectedIndex:(NSInteger)index
{
//    [_contentScrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH * index, 0) animated:YES];
    _pageIndex = 0;
    _selectedIndex = index;
    [self requestData];
}

#pragma mark - SSearchCollocationCollectionViewDelegate

#pragma mark - scrollView delegate

#pragma mark - <kMainViewCellDelegate>
- (void)kMainViewCellDeleteCellAtIndex:(NSInteger)indexCell {
    [_collocationListArray removeObjectAtIndex:indexCell];
    //    [self reloadData];
    [self.contentCollectionView reloadData];
    //    [Toast makeToast:@"删除成功"];
    [Toast makeToastSuccess:@"删除成功"];
}

- (void)kMainViewCellUploadCellAtIndex:(NSInteger)indexCell cellData:(NSMutableDictionary *)dict {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexCell inSection:0];
    [self.contentCollectionView reloadItemsAtIndexPaths:@[indexPath]];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
