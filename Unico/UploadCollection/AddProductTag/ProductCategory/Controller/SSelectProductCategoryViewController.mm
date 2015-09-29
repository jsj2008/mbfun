//
//  SSelectProductCategoryViewController.m
//  Wefafa
//
//  Created by chencheng on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SSelectProductCategoryViewController.h"
#import "SUtilityTool.h"
#import "SVerticalScrollButtonTabBar.h"
#import "WaterFLayout.h"
#import "SCategoryInfo.h"
#import "SCategorySubItemModel.h"
#import "SCategorySubItemCell.h"
#import "SScrollButtonTabBar.h"

#import "HttpRequest.h"
#import "Toast.h"

#define sizeK UI_SCREEN_WIDTH/750.0

@interface SSelectProductCategoryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UINavigationBar *_navigationBar;
    
    UIView *_lineV;
    
    ///一级类别选择按钮
    UIButton *_btnSelectCate;
    
    SVerticalScrollButtonTabBar *_verticalScrollButtonTabBar;
    NSMutableArray *_categoryInfoMutableArray;
    
    UICollectionView *_collectionView;
    WaterFLayout *_waterFLayout;
    
//    NSMutableArray *_categorySubitemMutableArrayMutableArray;
    
    ///一级目录数组
    NSMutableArray *_leve1TitleArray;
    ///二级目录数组
    NSMutableArray *_leve2TitleArray;
    
    ///选择的一级类别
    NSInteger _leve1Index;
}
@end

@implementation SSelectProductCategoryViewController

#pragma mark - 构造与析构

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
        self.navigationItem.leftBarButtonItems = @[backButtonItem];
        
        _btnSelectCate=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSelectCate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnSelectCate.backgroundColor=[UIColor clearColor];
        _btnSelectCate.frame=CGRectMake((UI_SCREEN_WIDTH-200)/2.0, 0, 200, 44);
        _btnSelectCate.titleLabel.font=FONT_SIZE(18);
        _btnSelectCate.selected=NO;
        _btnSelectCate.enabled=NO;
        [_btnSelectCate addTarget:self action:@selector(btnSelectCateClick:) forControlEvents:UIControlEventTouchUpInside];
//        size=[@"选择单品分类" sizeWithFont:lblTag.font constrainedToSize:CGSizeMake(MAXFLOAT, lblTag.frame.size.height)];
        self.navigationItem.titleView=_btnSelectCate;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_btnSelectCate.frame.size.width-108)/2, 0, 108, 44)];
        titleLabel.font = FONT_SIZE(18);
        titleLabel.textColor = COLOR_WHITE;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"选择单品分类";
        titleLabel.tag=1;
        [_btnSelectCate addSubview:titleLabel];
        
        UIImageView *imagev=[[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+3, 17, 0, 0)];
        imagev.tag=2;
        imagev.image=[UIImage imageNamed:@"btn_filter_downarrow"];
        imagev.contentMode=UIViewContentModeScaleAspectFit;
        [_btnSelectCate addSubview:imagev];
        
        
        
        _bcurrentCategoryAry=nil;
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
    
    if (_bcurrentCategoryAry.count<1) {
        [Toast makeToastActivity:@"正在努力加载..." hasMusk:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavbar];
    
    
    //这里添加其他代码
    
    _leve1Index=0;
    _leve1TitleArray=[NSMutableArray array];
    _leve2TitleArray=[NSMutableArray array];
    
    UIView *vi =[[UIView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, 88*sizeK)];
    vi.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:vi];
    
    
    _verticalScrollButtonTabBar = [[SVerticalScrollButtonTabBar alloc] initWithFrame:CGRectMake(0, 44, sizeK * 164, UI_SCREEN_HEIGHT - 44)];
    [self.view addSubview:_verticalScrollButtonTabBar];
    _verticalScrollButtonTabBar.selectedIndex=0;
    [_verticalScrollButtonTabBar addTarget:self action:@selector(changeProductListLeve2) forControlEvents:UIControlEventValueChanged];
    
    
    _waterFLayout = [[WaterFLayout alloc] init];
    _waterFLayout.sectionInset = UIEdgeInsetsMake(30 * sizeK, 48 * sizeK, 30 * sizeK, 48 * sizeK);
    _waterFLayout.minimumColumnSpacing = 80 * sizeK;
    _waterFLayout.minimumInteritemSpacing = 40* sizeK;
    _waterFLayout.columnCount = 3;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_verticalScrollButtonTabBar.frame.size.width, _verticalScrollButtonTabBar.frame.origin.y, UI_SCREEN_WIDTH-_verticalScrollButtonTabBar.frame.size.width, _verticalScrollButtonTabBar.frame.size.height) collectionViewLayout:_waterFLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    
    [_collectionView registerClass:[SCategorySubItemCell class] forCellWithReuseIdentifier:@"CategorySubItemCell"];
    
    _collectionView.alwaysBounceVertical = YES;
    [self.view addSubview: _collectionView];

    
    [self.view addSubview:_navigationBar];
    
    [self getCategoryList];
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
//    NSLog(@"numberOfItemsInSection _categorySubitemMutableArrayMutableArray = %@", _categorySubitemMutableArrayMutableArray);
    
    if ([_categoryInfoMutableArray count] > 0)
    {
        SCategoryInfo *scateInfo=_categoryInfoMutableArray[_leve1Index];
        if (!_verticalScrollButtonTabBar.selectedIndex) {
            _verticalScrollButtonTabBar.selectedIndex=0;
        }
        SCategoryInfo *scateInfo1=scateInfo.subArray[_verticalScrollButtonTabBar.selectedIndex];
        
        return scateInfo1.subArray.count;
    }
    else
    {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"CategorySubItemCell";
    
    SCategorySubItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    NSMutableArray *subitemMutableArray = [_categorySubitemMutableArrayMutableArray objectAtIndex:_verticalScrollButtonTabBar.selectedIndex];
//    
//    SCategorySubItemModel *model = [subitemMutableArray objectAtIndex:[indexPath row]];
    
    SCategoryInfo *scateInfo=_categoryInfoMutableArray[_leve1Index];
    SCategoryInfo *scateInfo1=scateInfo.subArray[_verticalScrollButtonTabBar.selectedIndex];
    
    SCategorySubItemModel *model = scateInfo1.subArray[indexPath.item];
    
    //数据方面的属性
    cell.categorySubItemImageURL = model.categorySubItemImageURL;
    cell.categorySubItemName = model.categorySubItemName;
    
    //布局属性
    cell.categorySubItemImageRect = model.categorySubItemImageRect;
    cell.categorySubItemNameLabelRect = model.categorySubItemNameLabelRect;
    
    cell.layer.borderWidth = 0;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate接口

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    SCategoryInfo *categoryInfo = [_categoryInfoMutableArray objectAtIndex:_verticalScrollButtonTabBar.selectedIndex];
//    
//    NSMutableArray *subitemMutableArray = [_categorySubitemMutableArrayMutableArray objectAtIndex:_verticalScrollButtonTabBar.selectedIndex];
//    
//    SCategorySubItemModel *subItemModel = [subitemMutableArray objectAtIndex:[indexPath row]];
    SCategoryInfo *scateInfo=_categoryInfoMutableArray[_leve1Index];
    SCategoryInfo *scateInfo1=scateInfo.subArray[_verticalScrollButtonTabBar.selectedIndex];
    SCategorySubItemModel *subItemModel=scateInfo1.subArray[indexPath.item];
    if (self.didFinishCategory != nil)
    {
        self.didFinishCategory(scateInfo.categoryId, scateInfo.categoryName, subItemModel.categorySubItemId, subItemModel.categorySubItemCode, subItemModel.categorySubItemName);
    }
}

#pragma mark - WaterFLayoutDelegate接口

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSMutableArray *subitemMutableArray = [_categorySubitemMutableArrayMutableArray objectAtIndex:_verticalScrollButtonTabBar.selectedIndex];
//    
//    SCategorySubItemModel *model = [subitemMutableArray objectAtIndex:[indexPath row]];
    
    SCategoryInfo *scateInfo=_categoryInfoMutableArray[_leve1Index];
    SCategoryInfo *scateInfo1=scateInfo.subArray[_verticalScrollButtonTabBar.selectedIndex];
    SCategorySubItemModel *model=scateInfo1.subArray[indexPath.item];
    
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

- (void)verticalScrollButtonTabBarValueChanged:(id)sender
{
    [_collectionView reloadData];
}


/**
 *   获取所有的类别
 */
//- (void)getCategoryList
//{
//    if (_categoryInfoMutableArray != nil)
//    {
//        [_categoryInfoMutableArray removeAllObjects];
//    }
//    else
//    {
//        _categoryInfoMutableArray = [[NSMutableArray alloc] init];
//    }
//    
//    if (_categorySubitemMutableArrayMutableArray != nil)
//    {
//        [_categorySubitemMutableArrayMutableArray removeAllObjects];
//    }
//    else
//    {
//        _categorySubitemMutableArrayMutableArray = [[NSMutableArray alloc] init];
//    }
//    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
//    [dict setObject:@"0" forKey:@"cid"];
//    
//    //[HttpRequest productGetRequestPath:@"Product" methodName:@"ProductCategorySubItemFilter" params:dict success:^(NSDictionary *dict)
//
//    [HttpRequest productGetRequestPath:@"Product" methodName:@"getProductCategoryList" params:dict success:^(NSDictionary *dict) {
//        [Toast hideToastActivity];
//        
//        NSArray *result = [dict objectForKey:@"results"];
//        
//        if (![result isKindOfClass:[NSArray class]])
//        {
//            //错误信息
//            [Toast makeToast:@"服务端数据异常"];
//            return;
//        }
//        
//        if (result.count <= 0)
//        {
//            //错误信息
//            [Toast makeToast:@"服务端无数据"];
//            return;
//        }
//        
//        for (int i=0; i<[result count]; i++)
//        {
//            NSDictionary *resultDictionary = [result objectAtIndex:i];
//            SCategoryInfo *categoryInfo = [[SCategoryInfo alloc] init];
//            categoryInfo.categoryId = resultDictionary[@"id"];
//            categoryInfo.categoryName = resultDictionary[@"name"];
//            categoryInfo.categoryCode = resultDictionary[@"code"];
//            [_categoryInfoMutableArray addObject:categoryInfo];
//            
//            NSArray *subItemArray = resultDictionary[@"subItem"];
//            
//            if (![subItemArray isKindOfClass:[NSArray class]])
//            {
//                //错误信息
//                [Toast makeToast:@"服务端数据异常"];
//                return;
//            }
//            
//            NSMutableArray *subItemModelMutableArray = [[NSMutableArray alloc] init];
//            for (int j=0; j<[subItemArray count]; j++)
//            {
//                NSDictionary *subItemDictionary = [subItemArray objectAtIndex:j];
//                SCategorySubItemModel *categorySubItemModel = [[SCategorySubItemModel alloc] init];
//                categorySubItemModel.collectionView = _collectionView;
//                categorySubItemModel.waterFLayout = _waterFLayout;
//                categorySubItemModel.categorySubItemId = subItemDictionary[@"id"];
//                categorySubItemModel.categorySubItemParentId = subItemDictionary[@"parent_id"];
//                categorySubItemModel.categorySubItemCode = subItemDictionary[@"code"];
//                categorySubItemModel.categorySubItemImageURL = [NSURL URLWithString:subItemDictionary[@"url"]];
//                categorySubItemModel.categorySubItemName = subItemDictionary[@"name"];
//                
//                float  sizeK = UI_SCREEN_WIDTH/750.0;
//                categorySubItemModel.categorySubItemImageSize = CGSizeMake(100 * sizeK, 100 * sizeK);
//                
//                [subItemModelMutableArray addObject:categorySubItemModel];
//            }
//            
//            [_categorySubitemMutableArrayMutableArray addObject:subItemModelMutableArray];
//        }
//        
//        NSMutableArray *titlesMutableArray = [[NSMutableArray alloc] init];
//        
//        for (int i=0; i<[_categoryInfoMutableArray count]; i++)
//        {
//            SCategoryInfo *categoryInfo = [_categoryInfoMutableArray objectAtIndex:i];
//            [titlesMutableArray addObject:categoryInfo.categoryName];
//        }
//        
//        _scrollButtonTabBar.titles = [titlesMutableArray copy];
//        
//        [_collectionView reloadData];
//        
//    } failed:^(NSError *error) {
//        
//        [Toast hideToastActivity];
//    }];
//
//}

- (void)getCategoryList
{
    if (_categoryInfoMutableArray != nil)
    {
        [_categoryInfoMutableArray removeAllObjects];
    }
    else
    {
        _categoryInfoMutableArray = [[NSMutableArray alloc] init];
    }
    
    
    if(_bcurrentCategoryAry&&_bcurrentCategoryAry.count!=0){
        [self initDataControls:_bcurrentCategoryAry];
        return;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:@"0" forKey:@"cid"];
    
    //[HttpRequest productGetRequestPath:@"Product" methodName:@"ProductCategorySubItemFilter" params:dict success:^(NSDictionary *dict)
    
    [HttpRequest productGetRequestPath:@"Product" methodName:@"getProductCategoryList" params:dict success:^(NSDictionary *dict) {
        [Toast hideToastActivity];
        
        NSArray *result = [dict objectForKey:@"data"];
        
        if (![result isKindOfClass:[NSArray class]])
        {
            //错误信息
            [Toast makeToast:@"服务端数据异常"];
            return;
        }
        
        if (result.count <= 0)
        {
            //错误信息
            [Toast makeToast:@"服务端无数据"];
            return;
        }
        [self initDataControls:result];
        
    } failed:^(NSError *error) {
        
        [Toast hideToastActivity];
    }];
    
}

///获取二级分类
-(void)changeProductListLeve1
{
    [_leve2TitleArray removeAllObjects];
    SCategoryInfo *scate=_categoryInfoMutableArray[_leve1Index];
    
    _verticalScrollButtonTabBar.selectedIndex=0;
    
    for (SCategoryInfo *sca in scate.subArray) {
        [_leve2TitleArray addObject:[[NSString alloc]initWithFormat:@"%@",sca.categoryName]];
    }
    _verticalScrollButtonTabBar.titles=[_leve2TitleArray copy];
    [_collectionView reloadData];
}

///获取三级分类
-(void)changeProductListLeve2
{
    [_collectionView reloadData];
}

-(void)initDataControls:(NSArray *)ary{
    [Toast hideToastActivity];
    //遍历一级目录
    [ary enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        [_leve1TitleArray addObject:[[NSString alloc]initWithFormat:@"%@",obj[@"name"]]];
        SCategoryInfo *scateInfo=[[SCategoryInfo alloc] init];
        scateInfo.categoryName=[[NSString alloc]initWithFormat:@"%@",obj[@"name"]];
        scateInfo.categoryId=[[NSString alloc]initWithFormat:@"%@",obj[@"id"]];
        scateInfo.subArray=[NSMutableArray array];
        NSArray *subResult=obj[@"subs"];
        
        NSMutableArray *leve1Arr=[NSMutableArray array];
        [subResult enumerateObjectsUsingBlock:^(NSDictionary *obj1, NSUInteger idx1, BOOL *stop1) {
            
            SCategoryInfo *scateInfo1=[[SCategoryInfo alloc] init];
            scateInfo1.categoryName=[[NSString alloc]initWithFormat:@"%@",obj1[@"name"]];
            scateInfo1.categoryId=[[NSString alloc]initWithFormat:@"%@",obj1[@"id"]];
            scateInfo1.subArray=[NSMutableArray array];
            
            //                [_leve2TitleArray addObject:[[NSString alloc]initWithFormat:@"%@",obj1[@"name"]]];
            NSArray *subsResult=obj1[@"subs"];
            NSMutableArray *leve2Arr=[NSMutableArray array];
            
            for (NSDictionary *dicc in subsResult) {
                SCategorySubItemModel *categorySubItemModel = [[SCategorySubItemModel alloc] init];
                categorySubItemModel.collectionView = _collectionView;
                categorySubItemModel.waterFLayout = _waterFLayout;
                categorySubItemModel.categorySubItemId = dicc[@"id"];
                categorySubItemModel.categorySubItemParentId = dicc[@"parent_id"];
                //                    categorySubItemModel.categorySubItemCode = dicc[@"code"];
                categorySubItemModel.categorySubItemImageURL = [NSURL URLWithString:dicc[@"url"]];
                categorySubItemModel.categorySubItemName = dicc[@"name"];

                categorySubItemModel.categorySubItemImageSize = CGSizeMake(100 * sizeK, 100 * sizeK);
                
                [leve2Arr addObject:categorySubItemModel];
            }
            scateInfo1.subArray=leve2Arr;
            [leve1Arr addObject:scateInfo1];
        }];
        scateInfo.subArray=leve1Arr;
        //添加一级目录
        [_categoryInfoMutableArray addObject:scateInfo];
    }];
    
    UILabel *titleLabel=(UILabel*)[_btnSelectCate viewWithTag:1];
    NSString *tit=_leve1TitleArray[_leve1Index];
    if (_leve1TitleArray.count==1) {
        titleLabel.frame=CGRectMake((_btnSelectCate.frame.size.width-tit.length*18)/2, 0, tit.length*18, 44);
        _btnSelectCate.enabled=NO;
    }
    else
    {
        titleLabel.frame=CGRectMake((_btnSelectCate.frame.size.width-(tit.length+1)*18)/2, 0, tit.length*18, 44);
        _btnSelectCate.enabled=YES;
        UIImageView *imageTitle=(UIImageView*)[_btnSelectCate viewWithTag:2];
        imageTitle.frame=CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+3, 17, 10, 10);
    }
    titleLabel.text=_leve1TitleArray[_leve1Index];
    
    SCategoryInfo *scate=_categoryInfoMutableArray[0];
    
    for (SCategoryInfo *sca in scate.subArray) {
        [_leve2TitleArray addObject:[[NSString alloc]initWithFormat:@"%@",sca.categoryName]];
    }
    _verticalScrollButtonTabBar.titles=[_leve2TitleArray copy];
    [Toast hideToastActivity];
    [_collectionView reloadData];
}
-(void)setBcurrentCategoryAry:(NSArray *)bcurrentCategoryAry{
    _bcurrentCategoryAry=bcurrentCategoryAry;
}

-(void)btnSelectCateClick:(UIButton*)sender
{
    UIView *cateSelectView=[self.view viewWithTag:100860];
    UITableView *cateTableView=(UITableView*)[self.view viewWithTag:10011];
    if (!cateTableView) {
        cateSelectView=[[UIView alloc] initWithFrame:CGRectMake(0, 44,UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44)];
        cateSelectView.backgroundColor=[UIColor blackColor];
        cateSelectView.alpha=0;
        cateSelectView.tag=100860;
        [self.view addSubview:cateSelectView];
        
        cateTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44) style:UITableViewStylePlain];
        cateTableView.backgroundColor=[UIColor clearColor];
        cateTableView.tag=10011;
        cateTableView.delegate=self;
        cateTableView.dataSource=self;
        cateTableView.rowHeight=88*(UI_SCREEN_WIDTH/750.0);
        cateTableView.separatorColor=COLOR_C9;
        cateTableView.tableFooterView=[UIView new];
        [self.view addSubview:cateTableView];
        
        [UIView animateWithDuration:.1 animations:^{
            cateSelectView.alpha=.4f;
            UIImageView *imageTitle=(UIImageView*)[_btnSelectCate viewWithTag:2];
            imageTitle.transform=CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            sender.selected=YES;
            [cateTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
        }];
    }
    else
    {
        sender.selected=NO;
        
        [UIView animateWithDuration:.1 animations:^{
            [cateTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
            UIImageView *imageTitle=(UIImageView*)[_btnSelectCate viewWithTag:2];
            imageTitle.transform=CGAffineTransformMakeRotation(M_PI*2);
            cateSelectView.alpha=0;
        } completion:^(BOOL finished) {
            
            [cateTableView removeFromSuperview];
            [cateSelectView removeFromSuperview];
        }];
    }
}

#pragma mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_btnSelectCate.selected) {
        return _categoryInfoMutableArray.count;
    }
    else
    {
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cateCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.separatorInset=UIEdgeInsetsMake(88*sizeK, 34*sizeK, 0, 0);
        
        UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(34*sizeK, 0, UI_SCREEN_WIDTH-100*sizeK, 88*sizeK)];
        lblTitle.tag=1;
        lblTitle.font=FONT_t4;
        lblTitle.textColor=COLOR_C2;
        [cell addSubview:lblTitle];
        
        UIImageView *imageV=[[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-74*sizeK, 24*sizeK, 40*sizeK, 40*sizeK)];
        imageV.tag=2;
        [cell addSubview:imageV];
    }
    
    UILabel *lblTitle=(UILabel*)[cell viewWithTag:1];
    UIImageView *imageV=(UIImageView*)[cell viewWithTag:2];
    SCategoryInfo *scate=_categoryInfoMutableArray[indexPath.row];
    lblTitle.text=scate.categoryName;
    
    if (indexPath.row==_leve1Index) {
        [imageV setImage:[UIImage imageNamed:@"Unico/item_select"]];
    }
    else
    {
        imageV.image=nil;
    }
    
    return cell;
}

#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_leve1Index==indexPath.row) {
        [self btnSelectCateClick:_btnSelectCate];
        return;
    }
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_leve1Index inSection:0]];
    UIImageView *imageV=(UIImageView*)[cell viewWithTag:2];
    imageV.image=nil;
    _leve1Index=indexPath.row;
    cell=[tableView cellForRowAtIndexPath:indexPath];
    UILabel *titleLabel=(UILabel*)[_btnSelectCate viewWithTag:1];
    NSString *tit=_leve1TitleArray[_leve1Index];
    titleLabel.frame=CGRectMake((_btnSelectCate.frame.size.width-(tit.length+1)*18)/2, 0, tit.length*18, 44);
    titleLabel.text=_leve1TitleArray[_leve1Index];
    UIImageView *imageTitle=(UIImageView*)[_btnSelectCate viewWithTag:2];
    imageTitle.frame=CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+3, 17, 10, 10);
    [self btnSelectCateClick:_btnSelectCate];
    [self changeProductListLeve1];
}

@end
