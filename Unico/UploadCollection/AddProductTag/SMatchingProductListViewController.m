//
//  SMatchingProductListViewController.m
//  Wefafa
//
//  Created by chencheng on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMatchingProductListViewController.h"
#import "SUtilityTool.h"
#import "WaterFLayout.h"
#import "SSearchProductCollectionViewCell.h"

#import "SAddProductTagViewControlCenter.h"
#import "SDataCache.h"
#import "Toast.h"
#import "SSearchProductModel.h"
#import "SProductTagEditeInfo.h"

static NSString *productCellIndetifier = @"SSearchProductCollectionViewCellIdentifier";

@interface SMatchingProductListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
{
    UINavigationBar *_navigationBar;
    UINavigationItem *_navigationItem;
    
    WaterFLayout *_waterFLayout;
    UICollectionView *_collectionView;
    
    NSMutableArray *_productModelMutableArray;
    
    SProductTagEditeInfo *_selectedRroductTagEditeInfo;
}

@end




@implementation SMatchingProductListViewController

#pragma mark - 构造与析构

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _navigationItem = [[UINavigationItem alloc] init];
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
        _navigationItem.leftBarButtonItems = @[backButtonItem];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH-200)/2.0, 0, 200, 44)];
        titleLabel.font = FONT_SIZE(18);
        titleLabel.textColor = COLOR_WHITE;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"对应的单品";
        
        _navigationItem.titleView = titleLabel;

    }
    return self;
}



#pragma mark - 视图控制器接口

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if ([self.view.gestureRecognizers count] > 0)
    {
        for(UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers)
        {
            if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)gestureRecognizer;
            }
        }
    }
    if (screenEdgePanGestureRecognizer != nil)
    {
        [self.view removeGestureRecognizer:screenEdgePanGestureRecognizer];//此处禁止屏幕边界右滑时返回上一级界面的手势
    }
    
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavbar];
    
    //这里添加其他代码
    
    _waterFLayout = [[WaterFLayout alloc] init];
    _waterFLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44) collectionViewLayout:_waterFLayout];
    _collectionView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    _collectionView.alwaysBounceVertical = YES;
    
    //[_collectionView addFooterWithTarget:self action:@selector(loadMoreItems)];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SSearchProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:productCellIndetifier];
    [self.view addSubview:_collectionView];

    
    
    [self.view addSubview:_navigationBar];
    
    [self getItemList];
}

#pragma mark - UICollectionViewDataSource接口

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_productModelMutableArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SSearchProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:productCellIndetifier forIndexPath:indexPath];
    cell.isShowPrice = YES;
    SSearchProductModel *model = _productModelMutableArray[indexPath.row];
    cell.contentModel = model;
    return cell;
}


#pragma mark - UICollectionViewDelegate接口

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SSearchProductCollectionViewCell * cell =(SSearchProductCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    SSearchProductModel *model = [_productModelMutableArray objectAtIndex:[indexPath row]];
    
   /* SProductTagEditeInfo *productTagEditeInfo = [[SProductTagEditeInfo alloc] init];
    
    productTagEditeInfo.productId = [model.aID description];
    productTagEditeInfo.productCode = model.code;
    productTagEditeInfo.productImage = cell.productImage;
    productTagEditeInfo.productOriginImage = cell.productImage;
    
    productTagEditeInfo.productCategoryId = @"productCategoryId";
    productTagEditeInfo.productCategoryName = @"女装";
    
    productTagEditeInfo.productSubCategoryId = @"productSubCategoryId";
    productTagEditeInfo.productSubCategoryCode = @"productSubCategoryCode";
    productTagEditeInfo.productSubCategoryName = @"外套";

    productTagEditeInfo.productBrandId = @"productBrandId";
    productTagEditeInfo.productBrandName = @"ME & CITY";
    
    productTagEditeInfo.productColorId = @"productColorId";
    productTagEditeInfo.productColorCode = @"productColorCode";
    productTagEditeInfo.productColorName = @"白色";
    
    _selectedRroductTagEditeInfo = productTagEditeInfo;*/
    
    if (!_productTagEditeInfo) {
        _productTagEditeInfo=[[SProductTagEditeInfo alloc] init];
    }
    _productTagEditeInfo.productImage=cell.productImage;
    _productTagEditeInfo.productOriginImage=cell.productImage;
    _productTagEditeInfo.productImageUrl=model.mainImage;
    _productTagEditeInfo.productBrandId=[NSString stringWithFormat:@"%@",model.branD_ID];
    _productTagEditeInfo.productBrandCode=[NSString stringWithFormat:@"%@",model.brandCode];
    _productTagEditeInfo.productBrandName=[NSString stringWithFormat:@"%@",model.brand];
    _productTagEditeInfo.productId=[NSString stringWithFormat:@"%d",model.aID.intValue];
    _productTagEditeInfo.productCode=[NSString stringWithFormat:@"%@",model.code];
    _productTagEditeInfo.productName=[NSString stringWithFormat:@"%@",model.name];

//    NSString *haha;
//    haha = _productTagEditeInfo.productCode = model.code;
//    NSLog(@"productCode  == %@", haha);
//    haha = _productTagEditeInfo.productCategoryName = model.name;
//    NSLog(@"productCategoryName  == %@", haha);
//    haha = _productTagEditeInfo.productSubCategoryId = [@([model.aID integerValue]) stringValue];
//    NSLog(@"productSubCategoryId  == %@", haha);
//    haha = _productTagEditeInfo.productColorName = model.productColorName;
//    NSLog(@"productColorName  == %@", haha);
    
    _selectedRroductTagEditeInfo = _productTagEditeInfo;
    
    if (self.didFinishPickingProduct != nil)
    {
        self.didFinishPickingProduct(_selectedRroductTagEditeInfo);
    }
    
}

#pragma mark - WaterFLayoutDelegate接口

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(UI_SCREEN_WIDTH/ 2 - 15, 300 * SCALE_UI_SCREEN);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    return 0;
}



#pragma mark - 其他UI接口
/**
 *   构建导航栏
 */
- (void)setupNavbar
{
    [super setupNavbar];
    
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44)];
    [_navigationBar pushNavigationItem:_navigationItem animated:YES];
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/blackBarBg.jpg"] forBarMetrics:UIBarMetricsDefault];
    [_navigationBar setBarTintColor:[UIColor blackColor]];
    [self.view addSubview:_navigationBar];
    
    _navigationBar.layer.transform = CATransform3DMakeTranslation(0, 0, 5);
}

#pragma mark - 控件事件接口

- (void)backButtonClick:(id)sender
{
    if (self.back != nil)
    {
        self.back();
    }
}


#pragma mark - 获取网络数据的接口

/**
 *   获取下面商品列表的数据
 */
- (void)getItemList
{
    
    _productModelMutableArray = [SSearchProductModel modelArrayForDataArray:self.matchingProductDataArray];
    
    [_collectionView reloadData];
}

@end
