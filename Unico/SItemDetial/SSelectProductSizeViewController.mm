//
//  SSelectProductSizeViewController.m
//  Wefafa
//
//  Created by Funwear on 15/9/8.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SSelectProductSizeViewController.h"
#import "SUtilityTool.h"
#import "FliterContentCollectionViewCell.h"
#import "HttpRequest.h"
#import "FilterSizeCategoryModel.h"
#import "Toast.h"
@interface SSelectProductSizeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UINavigationBar *_navigationBar;
    UIButton *_doneButton;

    UICollectionView *_collectionView;
    
    //记录选中索引
    NSIndexPath *sizeCondition;
    
    NSArray *_sizeModelMutableArray;
}
@end
static NSString *cellIdentifier = @"FliterContentCollectionViewCellIdentifier";
@implementation SSelectProductSizeViewController
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
        titleLabel.text = @"选择尺码";
        
        self.navigationItem.titleView = titleLabel;
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavbar];
    
    
    
    //这里添加其他代码
    
    [self.view addSubview:_navigationBar];
    

    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.contentInset = UIEdgeInsetsMake(16, 16, 16, 16);
    
    _collectionView.allowsMultipleSelection = YES;
    [_collectionView registerNib:[UINib nibWithNibName:@"FliterContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
   
    [self.view addSubview: _collectionView];
    
//    [self getSizeList];
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
    [self.view addSubview:_navigationBar];
    
    _navigationBar.layer.transform = CATransform3DMakeTranslation(0, 0, 5);
}

#pragma mark - UICollectionViewDelegate接口
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _sizeModelMutableArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FliterContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSIndexPath *index = sizeCondition;
    cell.sizeModel = _sizeModelMutableArray[indexPath.row];

    if (index && indexPath.row == index.row) {
        [cell setSelected:YES];
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(UI_SCREEN_WIDTH - 30, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    return CGSizeMake((UI_SCREEN_WIDTH-16*4)/3, 36);
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (sizeCondition && indexPath.row ==sizeCondition.row) {
        sizeCondition = nil;
        _doneButton.hidden=YES;
    }else{
        sizeCondition = indexPath;
        _doneButton.hidden=NO;
    }
    [_collectionView reloadData];
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
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
        if (sizeCondition.row>-1)
        {
            FilterSizeCategoryModel *sizeModel =_sizeModelMutableArray[sizeCondition.row];
            self.didFinishColor(sizeModel.code,sizeModel.name);
        }
    }
}

/**
 *   获取所有的颜色
 */
-(void)setSizeAry:(NSArray *)sizeAry
{
    if (_sizeModelMutableArray == nil)
    {
        _sizeModelMutableArray = [[NSArray alloc] init];
    }
    _sizeModelMutableArray=[FilterSizeCategoryModel modelArrayForDataArray:sizeAry];
    [_collectionView reloadData];    
}
@end
