//
//  SSelectProductColorViewController.m
//  Wefafa
//
//  Created by chencheng on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SSelectProductColorViewController.h"
#import "SUtilityTool.h"
#import "WaterFLayout.h"
#import "SProductColorModel.h"
#import "SProductColorCell.h"
#import "SColorInfo.h"
#import "HttpRequest.h"
#import "Toast.h"

@interface SSelectProductColorViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UINavigationBar *_navigationBar;
    UIButton *_doneButton;
    
    WaterFLayout *_waterFLayout;
    UICollectionView *_collectionView;
    
    NSMutableArray *_productModelMutableArray;
    NSMutableArray *_colorArray;
    
    ///上一个选中的item
    NSInteger _isSelectItem;
}

@end

@implementation SSelectProductColorViewController

#pragma mark - 构造与析构

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
        self.navigationItem.leftBarButtonItems = @[backButtonItem];
        
        
        _doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.frame=CGRectMake(0, 0, 40, 18);
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:_doneButton];
        _doneButton.hidden=YES;
        UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_doneButton];
        
        self.navigationItem.rightBarButtonItems = @[nextButtonItem];
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH-200)/2.0, 0, 200, 44)];
        titleLabel.font = FONT_SIZE(18);
        titleLabel.textColor = COLOR_WHITE;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"选择颜色";
        
        self.navigationItem.titleView = titleLabel;
        _colorAry=nil;
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
    
    if (!self.colorAry) {
        [Toast makeToastActivity:@"正在努力加载..." hasMusk:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavbar];
    
    
    
    //这里添加其他代码
    
    float sizeK = UI_SCREEN_WIDTH/750;
    
    
    [self.view addSubview:_navigationBar];
    
    _isSelectItem=-1; //初始化
    
    _waterFLayout = [[WaterFLayout alloc] init];
    _waterFLayout.sectionInset = UIEdgeInsetsMake(30 * sizeK, 44 * sizeK, 30 * sizeK, 44 * sizeK);
    _waterFLayout.minimumColumnSpacing = 40 * sizeK;
    _waterFLayout.minimumInteritemSpacing = 20 * sizeK;
    _waterFLayout.columnCount = 4;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44) collectionViewLayout:_waterFLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    
    [_collectionView registerClass:[SProductColorCell class] forCellWithReuseIdentifier:@"ColorCell"];
    
    _collectionView.alwaysBounceVertical = YES;
    [self.view addSubview: _collectionView];
    
    [self getColorList];
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
    [_navigationBar pushNavigationItem:self.navigationItem animated:NO];
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/blackBarBg.jpg"] forBarMetrics:UIBarMetricsDefault];
    [_navigationBar setBarTintColor:[UIColor blackColor]];
    [self.view addSubview:_navigationBar];
    
    _navigationBar.layer.transform = CATransform3DMakeTranslation(0, 0, 5);
}

#pragma mark - UICollectionViewDataSource接口

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"_productModelMutableArray = %@", _productModelMutableArray);
    
    NSLog(@"[_productModelMutableArray count] = %lu", (unsigned long)[_productModelMutableArray count]);
    
    return [_productModelMutableArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ColorCell";
    
    SProductColorCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SProductColorModel *model = [_productModelMutableArray objectAtIndex:[indexPath row]];
    
    //数据方面的属性
    cell.productColorURL = model.productColorURL;
    cell.colorValue = model.colorValue;
    cell.colorName = model.colorName;
    cell.isSelected=model.isSelected;
    
    //布局属性
    cell.productColorRect = model.productColorRect;
    cell.titleLabelRect = model.titleLabelRect;
    
    cell.layer.borderWidth = 0;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate接口

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //取消上一个选中
    if (_isSelectItem>-1)
    {
        SProductColorModel *model = _productModelMutableArray[_isSelectItem];
        model.isSelected=NO;
        SProductColorCell *cell=(SProductColorCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_isSelectItem inSection:0]];
        cell.isSelected=NO;
    }
    
    if (_doneButton.hidden)
    {
        _doneButton.hidden=NO;
    }
    
    _isSelectItem=indexPath.item;
    SProductColorCell *cell=(SProductColorCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.isSelected=YES;
    SProductColorModel *model = _productModelMutableArray[_isSelectItem];
    model.isSelected=YES;
}

#pragma mark - WaterFLayoutDelegate接口

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SProductColorModel *model = [_productModelMutableArray objectAtIndex:[indexPath row]];
    
    return model.cellSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    return 0;
}



#pragma mark - 控件事件接口

- (void)backButtonClick:(id)sender
{
    if (self.back != nil)
    {
        self.back();
    }
}

- (void)doneButtonClick:(id)sender
{
    if (self.didFinishColor != nil)
    {
        if (_isSelectItem>-1)
        {
            SProductColorModel *productModel =_productModelMutableArray[_isSelectItem];
            self.didFinishColor(productModel.colorId, productModel.colorCode, productModel.colorName);
        }
    }
}

/**
 *   获取所有的颜色
 */
-(void)getColorList
{
    if (_productModelMutableArray == nil)
    {
        _productModelMutableArray = [[NSMutableArray alloc] init];
    }
    
    if(_colorAry){
        
        for(NSDictionary *colorDict in _colorAry)
        {
            SProductColorModel *productColorModel = [[SProductColorModel alloc] init];
            productColorModel.waterFLayout = _waterFLayout;
            productColorModel.productColorSize = CGSizeMake(140, 140);
            
            productColorModel.colorId = [[NSString alloc] initWithFormat:@"%@",colorDict[@"id"]];
            productColorModel.colorCode = [[NSString alloc] initWithFormat:@"%@",colorDict[@"coloR_CODE"]];
            productColorModel.colorName = colorDict[@"coloR_NAME"];
            productColorModel.productColorURL = colorDict[@"series_img"];
            productColorModel.colorValue = colorDict[@"coloR_VALUE"];
            
            [_productModelMutableArray addObject:productColorModel];
        }
        
        [_collectionView reloadData];
        return;
    }
    
    [HttpRequest productPostRequestPath:@"Product" methodName:@"BaseColorFilter" params:nil success:^(NSDictionary *dict) {
        NSArray *colorArray = dict[@"results"];
        
        NSLog(@"colorArray = %@", colorArray);
        
        if (![colorArray isKindOfClass:[NSArray class]])
        {
            //错误信息
            [Toast makeToast:@"服务端数据异常"];
            return;
        }
        
        for(NSDictionary *colorDict in colorArray)
        {
            SProductColorModel *productColorModel = [[SProductColorModel alloc] init];
            productColorModel.waterFLayout = _waterFLayout;
            productColorModel.productColorSize = CGSizeMake(140, 140);
            
            productColorModel.colorId = [[NSString alloc] initWithFormat:@"%@",colorDict[@"id"]];
            productColorModel.colorCode = [[NSString alloc] initWithFormat:@"%@",colorDict[@"coloR_CODE"]];
            productColorModel.colorName = colorDict[@"coloR_NAME"];
            productColorModel.productColorURL = colorDict[@"series_img"];
            productColorModel.colorValue = colorDict[@"coloR_VALUE"];
            
            [_productModelMutableArray addObject:productColorModel];
        }
        [Toast hideToastActivity];
        [_collectionView reloadData];

        
    } failed:^(NSError *error) {
        
        //错误信息
        [Toast makeToast: error.domain];
        
        [_collectionView reloadData];
    }];

    
}
/**
 *   获取所有的颜色
 */
-(void)setColorAry:(NSArray *)colorAry
{
    _colorAry=colorAry;
}

@end
