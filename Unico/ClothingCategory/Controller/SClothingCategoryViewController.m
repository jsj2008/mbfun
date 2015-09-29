//
//  SClothingCategoryViewController.m
//  Wefafa
//
//  Created by chencheng on 15/7/28.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SClothingCategoryViewController.h"
#import "ModelBase.h"
#import "SDataCache.h"

#import "ClothingCategoryHeaderView.h"
#import "ClothingCategoryHeaderContentView.h"
#import "ClothingCategoryViewModel.h"
#import "SButtonTabBar.h"
#import "ClothingCategoryFilterViewController.h"

#import "WaterFLayout.h"
#import "SUtilityTool.h"

#import "SDataCache.h"
#import "UIScrollView+MJRefresh.h"

#import "Dialog.h"

#import "SProductDetailViewController.h"

#import "SFilterCollectionViewController.h"
#import "SSearchProductCollectionViewCell.h"
#import "SSearchProductModel.h"
#import "Dialog.h"
#import "Toast.h"
#import "HttpRequest.h"


#pragma mark - 成员变量的声明

/**
 *   品类详情视图控制器的成员变量
 */
@interface SClothingCategoryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
{
    WaterFLayout *_waterFLayout;
    UICollectionView *_collectionView;
    UIImageView      *_noTtemsTipImageView;//没有商品时候的提示
    UILabel          *_noTtemsTipLabel;//没有商品时候的提示
    ClothingCategoryHeaderContentView  *_headerContentView;
    
    
    NSString *_clothingCategoryId;//品类Id
    
    ClothingCategoryViewModel *_collectionModel;
    NSString *_currentTid;
    
    int _numberOfPage;
    int _currentPage;
    
    SCShortType _shortType;//排序方式
    
    NSMutableDictionary *_filterDictionary;//筛选字典
    
    UILabel *_titleLabel;
}

@end


#pragma mark - 类的实现




/**
 *   品类详情视图控制器的实现
 */

static NSString *productCellIndetifier = @"SSearchProductCollectionViewCellIdentifier";
@implementation SClothingCategoryViewController


#pragma mark - 属性接口

/**
 *   设置品类id
 */
- (void)setClothingCategoryId:(NSString *)clothingCategoryId
{
    if ([_clothingCategoryId isEqualToString:clothingCategoryId])
    {
        return;
    }
    
    _clothingCategoryId = [clothingCategoryId copy];
    
    
    if ([self isViewLoaded])//视图控制器如果已经viewDidLoad，则加载数据更新显示
    {
        [self getClothingCategoryDetails];
    }
}

#pragma mark - 初始化接口

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _collectionModel = [[ClothingCategoryViewModel alloc] init];
        
        _currentPage = 0;
        _numberOfPage = 10;
        
        
        _shortType = SCShortDefault; //默认排序
        
        _filterDictionary = nil;//默认没有筛选
    }
    
    return self;
}




#pragma mark - 视图控制器接口



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavbar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _waterFLayout = [[WaterFLayout alloc] init];
    _waterFLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64) collectionViewLayout:_waterFLayout];
    _collectionView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    _collectionView.alwaysBounceVertical = YES;
    
    [_collectionView addFooterWithTarget:self action:@selector(loadMoreItems)];
    
    [_collectionView registerClass:[ClothingCategoryHeaderView class] forSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:@"HeaderIdentifier"];
    [_collectionView registerNib:[UINib nibWithNibName:@"SSearchProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:productCellIndetifier];
    
    [self.view addSubview:_collectionView];
    
    
    _noTtemsTipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/noItems"]];
    _noTtemsTipImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _noTtemsTipLabel = [[UILabel alloc] init];
    _noTtemsTipLabel.textColor = COLOR_C6;
    _noTtemsTipLabel.textAlignment = NSTextAlignmentCenter;
    _noTtemsTipLabel.numberOfLines = 0;
    _noTtemsTipLabel.font = FONT_t5;
    _noTtemsTipLabel.text = @"抱歉，没有找到相关产品";
    
    [self getClothingCategoryDetails];// 第一次显示时加载数据
}

/**
 *   构建导航栏
 */
- (void)setupNavbar
{
    [super setupNavbar];
    
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,backButtonItem] ;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    _titleLabel.font = FONT_SIZE(18);
    _titleLabel.textColor = COLOR_WHITE;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = self.defaultTitle;
    
    self.navigationItem.titleView = _titleLabel;
}


#pragma mark - 其他UI接口

/**
 *   初始化头部视图
 */
- (void)initHeaderContentView
{
    _headerContentView = [[ClothingCategoryHeaderContentView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0)];//刚开始不知道高度、下面代码设定相应属性后会自适应高度
    
    if (self.hiddenHeaderImage)
    {
        _headerContentView.clothingCategoryIntroductionView.introductionImageURL = nil;
    }
    else
    {
        _headerContentView.clothingCategoryIntroductionView.introductionImageURL = _collectionModel.introductionImageURL;
    }
    
    _headerContentView.clothingCategoryIntroductionView.introductionText = _collectionModel.introductionText;
    
    [_headerContentView.clothingCategoryTabBar setCells:_collectionModel.categoryTabBarCellsArray];
    _headerContentView.clothingCategoryTabBar.backgroundColor = [UIColor whiteColor];
    
    //默认选项
    if ([_collectionModel.categoryTabBarCellsArray count] > 0)
    {
        int defaultIndex = 0;
        for (int i=0; i<[_collectionModel.categoryTabBarCellsArray count]; i++)
        {
            ClothingCategoryTabBarCell *cell = [_collectionModel.categoryTabBarCellsArray objectAtIndex:i];
            
            if ([cell.tid isEqualToString:self.defaultId])
            {
                defaultIndex = i;
                _titleLabel.text = cell.categoryName;
                break;
            }
        }
        _headerContentView.clothingCategoryTabBar.selectedIndex = defaultIndex;
        [_headerContentView.clothingCategoryTabBar layoutSubviews];
    }
    //清除默认信息
    self.defaultId = nil;
    
    [_headerContentView.clothingCategoryTabBar addTarget:self action:@selector(clothingCategoryTabBarValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    if (self.hiddenHeaderImage)//来自邦购的数据
    {
        
        
        UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
        
        newButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [newButton setTitle:@"上新" forState:UIControlStateNormal];
        
        
        UIButton *hotSaleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
        
        hotSaleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [hotSaleButton setTitle:@"热销" forState:UIControlStateNormal];
        
        CCButton *sortButton = [[CCButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        
        sortButton.rightImageView.image = [UIImage imageNamed:@"Unico/btn_sort_nomal"];
        [sortButton setTitle:@"价格" forState:UIControlStateNormal];
        sortButton.customState = 1;
        [sortButton addTarget:self action:@selector(sortButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        sortButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        CCButton *filterButton = [[CCButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-60-20, 0, 60, 44)];
        filterButton.rightImageView.image = [UIImage imageNamed:@"Unico/btn_selected_icon"];
        [filterButton setTitleColor:[UIColor colorWithRed:0xbb/255.0 green:0xbb/255.0 blue:0xbb/255.0 alpha:1] forState:UIControlStateNormal];
        [filterButton setTitle:@"筛选" forState:UIControlStateNormal];
        filterButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [filterButton addTarget:self action:@selector(filterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _headerContentView.filterButton = filterButton;
        [_headerContentView.buttonTabBar addSubview:filterButton];
        
        _headerContentView.buttonTabBar.autoLayoutButtons = NO;
        
        
        float d = (UI_SCREEN_WIDTH - 40)/3.0;
        
        newButton.center = CGPointMake(newButton.frame.size.width/2.0 + 20, newButton.center.y);
        
        hotSaleButton.center = CGPointMake(newButton.center.x + 1 * d - newButton.frame.size.width/2.0, newButton.center.y);
        
        sortButton.center = CGPointMake(newButton.center.x + 2 * d- newButton.frame.size.width/2.0, sortButton.center.y);
        
        [_headerContentView.buttonTabBar setButtons:@[newButton, hotSaleButton, sortButton]];
    }
    else//来自我们的数据
    {
        UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
        newButton.center = CGPointMake(UI_SCREEN_WIDTH/4.0, newButton.center.y);
        newButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [newButton setTitle:@"上新" forState:UIControlStateNormal];
        
        CCButton *sortButton = [[CCButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        sortButton.center = CGPointMake(UI_SCREEN_WIDTH * 3.0/4.0, sortButton.center.y);
        sortButton.rightImageView.image = [UIImage imageNamed:@"Unico/btn_sort_nomal"];
        [sortButton setTitle:@"价格" forState:UIControlStateNormal];
        sortButton.customState = 1;
        [sortButton addTarget:self action:@selector(sortButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        sortButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_headerContentView.buttonTabBar setButtons:@[newButton, sortButton]];
    }
    
    [_headerContentView.buttonTabBar addTarget:self action:@selector(buttonTabBarValueChanged:) forControlEvents:UIControlEventValueChanged];
}

/**
 *   更新头部视图
 */
- (void)updateHeaderView
{
    [self initHeaderContentView];
    [_collectionView reloadData];
}

/**
 *   更新下面的商品列表
 */
- (void)updateCollectionViewCells
{
    [_collectionView reloadData];
    
    if ([_collectionModel.categoryCollectionViewCellModelArray count] == 0)// 提示没有商品
    {
        float k = UI_SCREEN_WIDTH/750.0;
        
        float wh = _noTtemsTipImageView.image.size.height /  _noTtemsTipImageView.image.size.width;
        
        float imageWidth = _noTtemsTipImageView.image.size.width;
        
        if (_headerContentView.height > 200)
        {
            _noTtemsTipImageView.frame = CGRectMake((UI_SCREEN_WIDTH - imageWidth)/2.0, _headerContentView.height + 50*k, imageWidth, imageWidth * wh);
        }
        else
        {
            _noTtemsTipImageView.frame = CGRectMake((UI_SCREEN_WIDTH - imageWidth)/2.0, _headerContentView.height + 300*k, imageWidth, imageWidth * wh);
        }
        [_collectionView addSubview:_noTtemsTipImageView];
        
        
        _noTtemsTipLabel.frame = CGRectMake(_collectionView.width/4.0, _noTtemsTipImageView.frame.origin.y + _noTtemsTipImageView.frame.size.height, _collectionView.width/2.0, 100);
        [_collectionView addSubview:_noTtemsTipLabel];
        
        _noTtemsTipImageView.hidden = NO;
        _noTtemsTipLabel.hidden = NO;
    }
    else
    {
        [_noTtemsTipImageView removeFromSuperview];
        [_noTtemsTipLabel removeFromSuperview];
    }
}



#pragma mark - UICollectionViewDataSource接口

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_collectionModel.categoryCollectionViewCellModelArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SSearchProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:productCellIndetifier forIndexPath:indexPath];
    cell.isShowPrice = YES;
    SSearchProductModel *model = _collectionModel.categoryCollectionViewCellModelArray[indexPath.row];
    cell.contentModel = model;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *collectionReusableView = nil;
    
    if ([kind isEqualToString:WaterFallSectionHeader])
    {
        ClothingCategoryHeaderView *clothingCategoryHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderIdentifier" forIndexPath:indexPath];
        
        clothingCategoryHeaderView.contentView = _headerContentView;
        
        collectionReusableView = clothingCategoryHeaderView;
    }
    
    return collectionReusableView;
}

#pragma mark - UICollectionViewDelegate接口

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SSearchProductModel *model = _collectionModel.categoryCollectionViewCellModelArray[indexPath.row];
    
    SProductDetailViewController *productDetailViewController = [[SProductDetailViewController alloc] init];
    
    //    productDetailViewController.productID = model.aID.stringValue;
    productDetailViewController.productID = model.code;
    [self pushController:productDetailViewController animated:YES];
}

#pragma mark - WaterFLayoutDelegate接口

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(UI_SCREEN_WIDTH/ 2 - 15, 300 * SCALE_UI_SCREEN);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    return _headerContentView.height;
}

#pragma mark - UIScrollViewDelegate接口

/**
 *   实现标题栏的悬停处理
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.height
         && scrollView.contentSize.height > scrollView.height)
    {
        //出现加载更多的动画了 会出现闪烁，这里直接返回
        return;
    }
    
    /* if (scrollView.contentOffset.y >= (_headerContentView.height - _headerContentView.titleView.height)
     && scrollView.contentOffset.y < _headerContentView.height)
     {
     float ty = scrollView.contentOffset.y - (_headerContentView.height - _headerContentView.titleView.height);
     
     [self.navigationController.navigationBar setOrigin:CGPointMake(0, 20-ty)];//逐渐隐藏或显示
     }*/
    
    /*  if (scrollView.contentOffset.y < (_headerContentView.height - _headerContentView.titleView.height))
     {
     [self.navigationController.navigationBar setOrigin:CGPointMake(0, 20)];//重现
     }
     else if (scrollView.contentOffset.y > _headerContentView.height)
     {
     [self.navigationController.navigationBar setOrigin:CGPointMake(0, -44)];//隐藏
     }*/
    
    
    /* if (self.hiddenHeaderImage)//隐藏头部图片的悬停处理方式  把头部的cell显示出来
     {
     if (scrollView.contentOffset.y >= (_headerContentView.height-(_headerContentView.titleView.frame.size.height + _headerContentView.clothingCategoryTabBar.height)))//对标题栏的悬停处理
     {
     
     _headerContentView.clothingCategoryTabBar.frame = CGRectMake(_headerContentView.clothingCategoryTabBar.frame.origin.x, 64, _headerContentView.clothingCategoryTabBar.width, _headerContentView.clothingCategoryTabBar.height);
     [self.view addSubview:_headerContentView.clothingCategoryTabBar];
     
     
     _headerContentView.titleView.frame = CGRectMake(0, _headerContentView.clothingCategoryTabBar.frame.origin.y + _headerContentView.clothingCategoryTabBar.frame.size.height, _headerContentView.titleView.width, _headerContentView.titleView.height);
     [self.view addSubview:_headerContentView.titleView];
     
     //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
     }
     else//对标题栏的恢复滚动
     {
     
     
     _headerContentView.clothingCategoryTabBar.frame = CGRectMake(_headerContentView.clothingCategoryTabBar.frame.origin.x, _headerContentView.height-_headerContentView.titleView.height - _headerContentView.clothingCategoryTabBar.frame.size.height, _headerContentView.clothingCategoryTabBar.width, _headerContentView.clothingCategoryTabBar.height);
     [_headerContentView addSubview:_headerContentView.clothingCategoryTabBar];
     
     
     
     _headerContentView.titleView.frame = CGRectMake(0, _headerContentView.height-_headerContentView.titleView.height, _headerContentView.titleView.width, _headerContentView.titleView.height);
     [_headerContentView addSubview:_headerContentView.titleView];
     
     //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
     }
     }
     else*/
    {
        if (scrollView.contentOffset.y >= (_headerContentView.height-_headerContentView.titleView.frame.size.height+5))//对标题栏的悬停处理
        {
            _headerContentView.titleView.frame = CGRectMake(0, 64-5, _headerContentView.titleView.width, _headerContentView.titleView.height);
            [self.view addSubview:_headerContentView.titleView];
            
            //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
        else//对标题栏的恢复滚动
        {
            _headerContentView.titleView.frame = CGRectMake(0, _headerContentView.height-_headerContentView.titleView.height, _headerContentView.titleView.width, _headerContentView.titleView.height);
            [_headerContentView addSubview:_headerContentView.titleView];
            
            //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }
    }
}

#pragma mark - 控件事件接口

-(void)backButtonClick:(id)sender
{
    [self popAnimated:YES];
}

- (void)clothingCategoryTabBarValueChanged:(ClothingCategoryTabBar *)clothingCategoryTabBar
{
    NSLog(@"选择品类 %d", clothingCategoryTabBar.selectedIndex);
    [Toast makeToastActivity];
    ClothingCategoryTabBarCell *currentCell = [_headerContentView.clothingCategoryTabBar.cells objectAtIndex:clothingCategoryTabBar.selectedIndex];
    
    //更改标题
    _titleLabel.text = currentCell.categoryName;
    
    //每次默认选中 上新tab
    [_headerContentView.buttonTabBar setSelectedIndex:0 animated:YES];
    
    //排序按钮变为不确定，即上下箭头全部为灰色
    
    if (self.hiddenHeaderImage)
    {
        CCButton *sortButton = [_headerContentView.buttonTabBar.buttons objectAtIndex:2];
        sortButton.customState = 1;
        sortButton.rightImageView.image = [UIImage imageNamed:@"Unico/btn_sort_nomal"];
        _shortType = SCShortDefault;
        
    }
    else
    {
        CCButton *sortButton = [_headerContentView.buttonTabBar.buttons objectAtIndex:1];
        sortButton.customState = 1;
        sortButton.rightImageView.image = [UIImage imageNamed:@"Unico/btn_sort_nomal"];
        _shortType = SCShortDefault;
    }
    
    
    
    //清空下面的cell
    _collectionModel.categoryCollectionViewCellModelArray = nil;
    //[self updateCollectionViewCells];
    //_noTtemsTipImageView.hidden = YES;
    //_noTtemsTipLabel.hidden = YES;
    
    //停止下拉加载更多
    [_collectionView footerEndRefreshing];
    
    //重新获取下面每个cell的数据
    _currentPage = 0;
    _currentTid = currentCell.tid;
    [self getItemList];
}

- (void)sortButtonClick:(CCButton *)sortButton
{
    if (sortButton.customState == 1 || sortButton.customState == 3)
    {
        sortButton.rightImageView.image = [UIImage imageNamed:@"Unico/btn_sort_top"];//升序
        sortButton.customState = 2;
        
        _shortType = SCShortAscByPrice;
    }
    else if (sortButton.customState == 2)
    {
        sortButton.rightImageView.image = [UIImage imageNamed:@"Unico/btn_sort_bottom"];//降序
        sortButton.customState = 3;
        
        _shortType = SCShortDescByPrice;
    }
    
    ClothingCategoryTabBarCell *currentCell = [_headerContentView.clothingCategoryTabBar.cells objectAtIndex:_headerContentView.clothingCategoryTabBar.selectedIndex];
    
    //清空下面的cell
    _collectionModel.categoryCollectionViewCellModelArray = nil;
    
    //停止下拉加载更多
    [_collectionView footerEndRefreshing];
    
    //重新获取下面每个cell的数据
    _currentPage = 0;
    _currentTid = currentCell.tid;
    
    if (self.hiddenHeaderImage)
    {
        [_headerContentView.buttonTabBar setSelectedIndex:2 animated:YES];
    }
    else
    {
        [_headerContentView.buttonTabBar setSelectedIndex:1 animated:YES];
    }
    
    
    [self getItemList];
}

- (void)filterButtonClick:(CCButton *)filterButton
{
    SFilterCollectionViewController *filterCollectionViewController = [[SFilterCollectionViewController alloc] init];
    filterCollectionViewController.isBack=YES;
    
    
    SProductTagEditeInfo *parameterTagEditeInfo=[SProductTagEditeInfo new];
    parameterTagEditeInfo.productSubCategoryId = _currentTid;//三级Id
    
    filterCollectionViewController.parameterTagEditeInfo = parameterTagEditeInfo;
    
    filterCollectionViewController.didSelectedEnter =  ^(id sender){
        
        _filterDictionary =(NSMutableDictionary *)sender;
        
        NSLog(@"_filterDictionary = %@", _filterDictionary);
        
        if ([[_filterDictionary allKeys] count] == 0)
        {
            _filterDictionary = nil;//没有筛选
            
            //筛选按钮变灰色
            filterButton.rightImageView.image = [UIImage imageNamed:@"Unico/btn_selected_icon"];
            [filterButton setTitleColor:[UIColor colorWithRed:0xbb/255.0 green:0xbb/255.0 blue:0xbb/255.0 alpha:1] forState:UIControlStateNormal];
        }
        else
        {
            
            //筛选按钮变黑色
            //filterButton.rightImageView.image = [UIImage imageNamed:@"Unico/btn_selected_icon_selected"];
            //[filterButton setTitleColor:[UIColor colorWithRed:0x3b/255.0 green:0x3b/255.0 blue:0x3b/255.0 alpha:1] forState:UIControlStateNormal];
        }
        
        _currentPage = 0;
        //清空下面的cell
        _collectionModel.categoryCollectionViewCellModelArray = nil;
        
        [self updateCollectionViewCells];
        _noTtemsTipImageView.hidden = YES;
        _noTtemsTipLabel.hidden = YES;
        
        
        [self getItemList];
        
    };
    
    [self pushController:filterCollectionViewController animated:YES];
}

- (void)buttonTabBarValueChanged:(SButtonTabBar *)buttonTabBar
{
    NSLog(@"buttonTabBarValueChanged buttonTabBar.selectedIndex = %d", buttonTabBar.selectedIndex);
    if (self.hiddenHeaderImage)//来自邦购的数据
    {
        if (buttonTabBar.selectedIndex != 2)//价格排序
        {
            CCButton *sortButton = [buttonTabBar.buttons objectAtIndex:2];
            sortButton.rightImageView.image = [UIImage imageNamed:@"Unico/btn_sort_nomal"];//默认排序
            sortButton.customState = 1;
            
            _shortType = SCShortDefault;
        }
        
        if (buttonTabBar.selectedIndex == 0)//上新
        {
            ClothingCategoryTabBarCell *currentCell = [_headerContentView.clothingCategoryTabBar.cells objectAtIndex:_headerContentView.clothingCategoryTabBar.selectedIndex];
            _currentPage = 0;
            _currentTid = currentCell.tid;
            
            //清空下面的cell
            _collectionModel.categoryCollectionViewCellModelArray = nil;
            [self getItemList];
        }
        else if (buttonTabBar.selectedIndex == 1)//热销
        {
            ClothingCategoryTabBarCell *currentCell = [_headerContentView.clothingCategoryTabBar.cells objectAtIndex:_headerContentView.clothingCategoryTabBar.selectedIndex];
            _currentPage = 0;
            _currentTid = currentCell.tid;
            
            //清空下面的cell
            _collectionModel.categoryCollectionViewCellModelArray = nil;
            [self getItemList];
        }
        
    }
    else//来自我们的数据
    {
        if (buttonTabBar.selectedIndex != 1)
        {
            CCButton *sortButton = [buttonTabBar.buttons objectAtIndex:1];
            sortButton.rightImageView.image = [UIImage imageNamed:@"Unico/btn_sort_nomal"];//默认排序
            sortButton.customState = 1;
            
            _shortType = SCShortDefault;
        }
        
        if (buttonTabBar.selectedIndex == 0)//上新
        {
            ClothingCategoryTabBarCell *currentCell = [_headerContentView.clothingCategoryTabBar.cells objectAtIndex:_headerContentView.clothingCategoryTabBar.selectedIndex];
            _currentPage = 0;
            _currentTid = currentCell.tid;
            
            //清空下面的cell
            _collectionModel.categoryCollectionViewCellModelArray = nil;
            [self getItemList];
        }
    }
    
}

//上拉加载更多
- (void)loadMoreItems
{
    _currentPage = ((int)_collectionModel.categoryCollectionViewCellModelArray.count + 9)/ 10;
    
    
    NSLog(@"loadMoreItems _currentPage = %d", _currentPage);
    
    [self getItemList];
}

#pragma mark - 获取网络数据的接口

/**
 *   获取头部视图的数据
 */
- (void)getClothingCategoryDetails
{
    __weak typeof(self) weakSelf = self;
    
    //self.type = 1;
    
    //self.clothingCategoryId = @"2";
    
    NSLog(@"self.clothingCategoryId = %@  self.hiddenHeaderImage = %d", self.clothingCategoryId, self.hiddenHeaderImage);
    
    if (!self.hiddenHeaderImage)//这里接口不一样
    {
        [[SDataCache sharedInstance] getClothingCategoryDetailsWithFid:self.clothingCategoryId complete:^(id object) {
            
            NSLog(@"object = %@", object);
            
            //解析数据
            BOOL ret = [self parseClothingCategoryDetailsData:object];
            
            if (ret)
            {
                [weakSelf updateHeaderView];//刷新显示
            }
            
        } failure:^(NSError *error) {
            
            [weakSelf updateCollectionViewCells];
            
            //错误信息提示
            [Toast makeToast:kNoneInternetTitle];
        }];
    }
    else
    {
        [[SDataCache sharedInstance] newGetClothingCategoryDetailsWithFid:self.clothingCategoryId complete:^(id object) {
            
            NSLog(@"newGetClothingCategoryDetailsWithFid object = %@", object);
            
            //解析数据
            BOOL ret = [self newParseClothingCategoryDetailsData:object];
            
            if (ret)
            {
                [weakSelf updateHeaderView];//刷新显示
            }
            
        } failure:^(NSError *error) {
            
            [weakSelf updateCollectionViewCells];
            
            //错误信息提示
            [Toast makeToast:kNoneInternetTitle];
        }];
    }
}

/**
 *   获取下面商品列表的数据
 */
- (void)getItemList
{
    __weak typeof(self) weakSelf = self;
    
    NSLog(@"SClothingCategoryViewController getItemList");
    
    if (!self.hiddenHeaderImage)//来自我们的数据
    {
        if (_currentTid == nil)
        {
            _currentTid = @"";
        }

        

        
        //不支持筛选 和 热销
        [[SDataCache sharedInstance] getItemListForClsWith:_currentTid shortType:_shortType isNew:(_headerContentView.buttonTabBar.selectedIndex == 0) filterDictionary:nil page:_currentPage numberOfPage:_numberOfPage complete:^(id object) {
            [Toast hideToastActivity];
            [_collectionView footerEndRefreshing];
            
            
            if (_collectionModel.categoryCollectionViewCellModelArray == nil)
            {
                _collectionModel.categoryCollectionViewCellModelArray = [SSearchProductModel modelArrayForCategaryDataArray:object];
            }else{
                [_collectionModel.categoryCollectionViewCellModelArray addObjectsFromArray:[SSearchProductModel modelArrayForCategaryDataArray:object]];
            }
            [weakSelf updateCollectionViewCells];
            
            
            
        } failure:^(NSError *error) {
            [Toast hideToastActivity];
            [_collectionView footerEndRefreshing];
            
            [weakSelf updateCollectionViewCells];//刷新显示
            
            //错误信息提示
            [Toast makeToast:kNoneInternetTitle];
            
            closeDialogView(QFCloseDialogViewAnimationNone, ^(BOOL finished) {
                
            });
        }];
    }
    else//来之邦购的数据
    {
        
        NSLog(@"_currentTid = %@", _currentTid);
        
        
        NSDictionary *sortInfo = nil;
        
        NSLog(@"_headerContentView.buttonTabBar.selectedIndex = %d", _headerContentView.buttonTabBar.selectedIndex);
        
        NSLog(@"33 _currentPage = %d", _currentPage);
        
        if (_headerContentView.buttonTabBar.selectedIndex == 0)
        {
            sortInfo = @{@"sortField": @(3), @"desc": @(-1)};
        }
        else if (_headerContentView.buttonTabBar.selectedIndex == 2)//按价格排序
        {
            if (_shortType == SCShortDefault
                || _shortType == SCShortAscByPrice)
            {
                sortInfo = @{@"sortField":@(1), @"desc": @"1"};
            }
            else
            {
                sortInfo = @{@"sortField":@(1), @"desc": @"-1"};
            }
        }
        else if (_headerContentView.buttonTabBar.selectedIndex == 1)
        {
            sortInfo = @{@"sortField":@(2), @"desc": @"-1"};
        }
        
        
        NSLog(@"sortInfo = %@", sortInfo);
        
        if (_currentTid == nil)
        {
            _currentTid = @"";
        }
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"pageIndex": @(_currentPage+1), @"pageSize" : @20, @"CategoryId" : _currentTid, @"sortInfo":sortInfo}];
        
        
        NSLog(@"33333 dictionary = %@", dictionary);
        if (_filterDictionary != nil)
        {
            if ([[_filterDictionary allKeys]count]>0) {
                
                if([[_filterDictionary allKeys]containsObject:@"cid"])
                {
                    dictionary[@"CategoryId"]=_filterDictionary[@"cid"];
                }
                if([[_filterDictionary allKeys]containsObject:@"brand"])
                {
                    dictionary[@"brandCode"]=_filterDictionary[@"brand"];
                }
                if([[_filterDictionary allKeys]containsObject:@"sizeCode"])
                {
                    dictionary[@"sizeCode"]=_filterDictionary[@"sizeCode"];
                }
                if([[_filterDictionary allKeys]containsObject:@"color"])
                {
                    dictionary[@"color"]=_filterDictionary[@"color"];
                }
                if([[_filterDictionary allKeys]containsObject:@"priceRange"])
                {
                    dictionary[@"priceRange"]=_filterDictionary[@"priceRange"];
                }
                if([[_filterDictionary allKeys]containsObject:@"productId"])
                {
                    dictionary[@"productId"]=_filterDictionary[@"productId"];
                }
                if([[_filterDictionary allKeys]containsObject:@"discountRange"])
                {
                    dictionary[@"discountRange"]=_filterDictionary[@"discountRange"];
                    //            params[@"priceRange"]=_chooseDic[@"priceRange"];
                }
                //        params[@"pageIndex"]=@(1);
                
            }
            
            //[dictionary setValuesForKeysWithDictionary:_filterDictionary];
        }
        
        NSLog(@"4444 dictionary = %@", dictionary);
        
        
        [HttpRequest productPostRequestPath:@"Product" methodName:@"ProductClsCommonSearchFilter" params:dictionary success:^(NSDictionary *dict) {
            [Toast hideToastActivity];
            [_collectionView footerEndRefreshing];
            NSLog(@"ProductClsCommonSearchFilter dict = %@", dict);
            [Toast hideToastActivity];
            
            if (_currentPage == 0)
            {
                _collectionModel.categoryCollectionViewCellModelArray = nil;
            }
            
            if (_collectionModel.categoryCollectionViewCellModelArray == nil)
            {
                _collectionModel.categoryCollectionViewCellModelArray = [SSearchProductModel modelArrayForCategaryDataArray:dict[@"results"]];
            }
            else
            {
                [_collectionModel.categoryCollectionViewCellModelArray addObjectsFromArray:[SSearchProductModel modelArrayForCategaryDataArray:dict[@"results"]]];
            }
            
            [weakSelf updateCollectionViewCells];
            
            
            
        } failed:^(NSError *error) {
            [Toast hideToastActivity];
            [_collectionView footerEndRefreshing];
            
            [weakSelf updateCollectionViewCells];//刷新显示
            
            //错误信息提示
            [Toast makeToast:kNoneInternetTitle];
        }];
    }
}

#pragma mark - 解析网络数据的接口

/**
 *   解析头部数据
 */
- (BOOL) parseClothingCategoryDetailsData:(id)data
{
    //NSLog(@"头部数据:\n%@", data);
    
    NSDictionary *dictionary = data;
    
    if (![dictionary isKindOfClass:[NSDictionary class]])
    {
        //错误信息
        [Toast makeToast:@"网络错误!"];
        return NO;
    }
    
    _collectionModel.introductionImageURL = [NSURL URLWithString:dictionary[@"img"]];
    _collectionModel.introductionText = dictionary[@"info"];
    
    NSLog(@"_collectionModel.introductionImageURL = %@", _collectionModel.introductionImageURL);
    
    NSMutableArray *cellsMutableArray = [[NSMutableArray alloc] init];
    
    
    NSArray *middleCells = dictionary[@"middle"];
    
    if (![middleCells isKindOfClass:[NSArray class]])
    {
        //错误信息
        [Toast makeToast:@"网络错误!"];
        return NO;
    }
    
    for (int i=0; i<[middleCells count]; i++)
    {
        ClothingCategoryTabBarCell *cell = [[ClothingCategoryTabBarCell alloc] init];
        
        NSDictionary *middleCell = [middleCells objectAtIndex:i];
        
        if (![middleCell isKindOfClass:[NSDictionary class]])
        {
            //错误信息
            [Toast makeToast:@"网络错误!"];
            return NO;
        }
        cell.categoryImageURL = [NSURL URLWithString:[middleCell[@"small_img"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        cell.categoryName = middleCell[@"name"];
        cell.clothingCategoryId = middleCell[@"fixed_id"];
        cell.tid = middleCell[@"temp_id"];
        
        [cellsMutableArray addObject:cell];
    }
    
    if ([cellsMutableArray count] > 0)
    {
        //默认选项
        if ([self.defaultId length] > 0)
        {
            for (int i=0; i<[cellsMutableArray count]; i++)
            {
                ClothingCategoryTabBarCell *cell = [cellsMutableArray objectAtIndex:i];
                
                if ([cell.tid isEqualToString:self.defaultId])
                {
                    _titleLabel.text = cell.categoryName;
                    _currentTid = cell.tid;
                    break;
                }
            }
        }
        
        if (_currentTid == nil)
        {
            ClothingCategoryTabBarCell *currentCell = [cellsMutableArray objectAtIndex:0];
            
            _titleLabel.text = currentCell.categoryName;
            _currentTid = currentCell.tid;
        }
        
        _currentPage = 0;
        [self getItemList];
    }
    
    _collectionModel.categoryTabBarCellsArray = cellsMutableArray;
    
    return YES;
}


/**
 *   解析头部数据
 */
- (BOOL) newParseClothingCategoryDetailsData:(id)data
{
    NSLog(@"new 头部数据:\n%@", data);
    
    NSArray *dataArray = data;
    
    if (![dataArray isKindOfClass:[NSArray class]])
    {
        //错误信息
        [Toast makeToast:@"网络错误!"];
        return NO;
    }
    
    
    
    NSMutableArray *cellsMutableArray = [[NSMutableArray alloc] init];
    
    if ([dataArray count] == 0)
    {
        //错误信息
        [Toast makeToast:@"网络错误!"];
        return NO;
    }
    
    NSDictionary *dictionary = [dataArray objectAtIndex:0];
    
    
    //_collectionModel.introductionImageURL = [NSURL URLWithString:dictionary[@"url"]];
    //_collectionModel.introductionText = dictionary[@"info"];
    
    NSArray *middleCells = dictionary[@"subs"];
    
    if (![middleCells isKindOfClass:[NSArray class]])
    {
        //错误信息
        [Toast makeToast:@"网络错误!"];
        return NO;
    }
    
    for (int i=0; i<[middleCells count]; i++)
    {
        ClothingCategoryTabBarCell *cell = [[ClothingCategoryTabBarCell alloc] init];
        
        NSDictionary *middleCell = [middleCells objectAtIndex:i];
        
        if (![middleCell isKindOfClass:[NSDictionary class]])
        {
            //错误信息
            [Toast makeToast:@"网络错误!"];
            return NO;
        }
        cell.categoryImageURL = [NSURL URLWithString:[middleCell[@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        cell.categoryName = middleCell[@"name"];
        cell.clothingCategoryId = middleCell[@"parent_id"];
        cell.tid = middleCell[@"temp_id"];
        
        [cellsMutableArray addObject:cell];
    }
    
    if ([cellsMutableArray count] > 0)
    {
        //默认选项
        NSLog(@"self.defaultId = %@", self.defaultId);
        if ([self.defaultId length] > 0)
        {
            for (int i=0; i<[cellsMutableArray count]; i++)
            {
                ClothingCategoryTabBarCell *cell = [cellsMutableArray objectAtIndex:i];
                
                if ([cell.tid isEqualToString:self.defaultId])
                {
                    _titleLabel.text = cell.categoryName;
                    _currentTid = cell.tid;
                    break;
                }
            }
        }
        
        if (_currentTid == nil)
        {
            ClothingCategoryTabBarCell *currentCell = [cellsMutableArray objectAtIndex:0];
            
            _titleLabel.text = currentCell.categoryName;
            _currentTid = currentCell.tid;
        }
        
        _currentPage = 0;
        [self getItemList];
    }
    
    _collectionModel.categoryTabBarCellsArray = cellsMutableArray;
    
    return YES;
}


@end
