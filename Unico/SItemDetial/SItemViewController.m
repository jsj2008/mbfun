//
//  SItemViewController.m
//  Wefafa
//
//  Created by unico on 15/5/18.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//
#import "SItemViewController.h"
#import "SItemListViewController.h"
#import "SItemCell.h"
#import "SUtilityTool.h"
#import "HttpRequest.h"
#import "Toast.h"
#import "BrandModel.h"
#import "MBBrandViewController.h"
#import "SSearchResultViewController.h"
#import "SFilterCollectionViewController.h"
#import "FilterPirceRangeModel.h"
#import "FilterColorCategoryModel.h"
#import "FilterBrandCategoryModel.h"

#import "Utils.h"

@interface SItemViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate>
{
    //滚动时加载
    BOOL scrollLoading;
    UIScrollView *listBtnScrollView;
    NSMutableArray *_categoryArray;//总数据源
    
    NSMutableArray *listButtonTitleArr;//左边分类栏按钮列表数据源
    NSMutableArray *collectionDataArr;//右边collectionview数据源
    
    UIView * yellowIndicatorBar;

}

@property (nonatomic) UIView *selectView;
@property (nonatomic) NSInteger cellNowHeight;
//// 底部视图
@end

@implementation SItemViewController
#define BUTTON_TAG_BASE 10000
static NSString *SItemCellIdentifier = @"SItemCell";

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    // Do any additional setup after loading the view.
    // TODO: 判断登陆状态，如果没有登录，显示登录界面。
    _cellNowHeight = 100;
    [self categoryListRequest];
//    [self updateUI];
//    UIButton *tempBtn = [SUTILITY_TOOL_INSTANCE createTitleButtonAction:@"搜索" bgColor:COLOR_BLACK fontColor:COLOR_WHITE fontStyle:FONT_SIZE(12) rect:CGRectMake(0, 100, 50, 50) target:self action:@selector(test1:)];
//    [self.view addSubview:tempBtn];
    
}

-(void)test1:(id)selector{
    SItemListViewController *vc = [SItemListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) updateUI{
    float offset = 0;
    UIColor *tempColor;
    UIButton *tempButton;
    float navigatorHeight = self.navigationController.navigationBar.height+20;
    offset += navigatorHeight;
    UIView *tempView = [SUTILITY_TOOL_INSTANCE createUIViewByHeight:88/2 coordY:offset];
    [self.view addSubview:tempView];
    tempView.backgroundColor = COLOR_WHITE;
    UISearchBar *searchBar = [UISearchBar new];
    //暂时加1像素，去掉底色线
    searchBar.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 88/2+1);
    [searchBar setBarTintColor:[UIColor whiteColor]];
    searchBar.placeholder = @"搜索商品 品牌 货号";
    searchBar.delegate = self;
    [tempView addSubview:searchBar];
    
    offset += tempView.height;
//    listButtonTitleArr = @[@"男装",@"女装",@"箱包",@"家具",@"男童",@"女童",@"男婴"];
    listBtnScrollView = [SUTILITY_TOOL_INSTANCE createScrollView:self rect:CGRectMake(0, offset+1, 164/2, UI_SCREEN_HEIGHT - navigatorHeight -tempView.height)];
    listBtnScrollView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    [self.view addSubview:listBtnScrollView];
    for (int i =0; i<listButtonTitleArr.count; i++) {
        tempButton = [SUTILITY_TOOL_INSTANCE createTitleButtonAction:listButtonTitleArr[i] bgColor:COLOR_WHITE fontColor:COLOR_C2 fontStyle:FONT_t5 rect:CGRectMake(0,  i*(100/2), 164/2, 100/2) target:self action:@selector(selectType:)];
        
        if (i == 0) {
            tempColor = COLOR_WHITE;
        }else{
            tempColor = UIColorFromRGB(0xf2f2f2);
        }
        tempButton.backgroundColor =tempColor;
        tempButton.tag = BUTTON_TAG_BASE+i;
        [listBtnScrollView addSubview:tempButton];
    }
//    for (int i =0; i<listButtonTitleArr.count-1; i++) {
//        tempButton = [SUTILITY_TOOL_INSTANCE createTitleButtonAction:listButtonTitleArr[i+1] bgColor:COLOR_WHITE fontColor:COLOR_C2 fontStyle:FONT_t5 rect:CGRectMake(0,  i*(100/2), 164/2, 100/2) target:self action:@selector(selectType:)];
//
//        if (i == 0) {
//            tempColor = COLOR_WHITE;
//        }else{
//            tempColor = UIColorFromRGB(0xf2f2f2);
//        }
//        tempButton.backgroundColor =tempColor;
//        tempButton.tag = BUTTON_TAG_BASE+i+1;
//         [listBtnScrollView addSubview:tempButton];
//    }
    yellowIndicatorBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 50)];
    yellowIndicatorBar.backgroundColor = UIColorFromRGB(0xfedc32);
    [listBtnScrollView addSubview:yellowIndicatorBar];
    
    listBtnScrollView.contentSize = CGSizeMake(80, 100/2*(listButtonTitleArr.count+1));
    
    for (NSInteger i = 0; i < listButtonTitleArr.count ;i ++) {
        NSString *name = [listButtonTitleArr objectAtIndex:i];
        if ([name isEqualToString:_modelName]) {
            [self selectIndexTypeWithTag:i];
            break;
        }
    }
}

- (void)selectIndexTypeWithTag:(NSInteger)tag
{
    [self.view endEditing:YES];
    [yellowIndicatorBar setOrigin:CGPointMake(0, (tag)*50)];
    
    UIColor *tempColor;
    
    if (tag > listButtonTitleArr.count || tag < 0) {
        return;
    }
    NSInteger indexBtn = 0;
    for (int i = 0; i<listButtonTitleArr.count; i++) {
       UIButton *tempButton = (UIButton*)[listBtnScrollView viewWithTag:(BUTTON_TAG_BASE+i)];
        if (i == tag) {
            tempColor = COLOR_WHITE;
            indexBtn = i;
        }else{
            tempColor = UIColorFromRGB(0xf2f2f2);
        }
        [tempButton setBackgroundColor:tempColor];
    }
    [listBtnScrollView scrollRectToVisible:CGRectMake(0, indexBtn * 50, 82, 50) animated:YES];
    [collectionDataArr removeAllObjects];
    BrandModel *model = _categoryArray[tag];
    NSArray * temp = model.subItems;
    [collectionDataArr addObjectsFromArray:temp];
    [self.collectionView reloadData];
    [listBtnScrollView becomeFirstResponder];
}

-(void)selectType:(id)selector{
    UIButton *tempButton = (UIButton*)selector;
    int type = (int)(tempButton.tag - BUTTON_TAG_BASE);
    [self selectIndexTypeWithTag:type];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupNavbar];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}


- (void) edgePanHandler:(UIScreenEdgePanGestureRecognizer*)recognizer{
    NSLog(@"edgePanHandler");
    // 此处应该被swap覆盖了，不会执行
}

- (void) swipeLeftHandler:(UISwipeGestureRecognizer*)recognizer{
    NSLog(@"swipeLeftHandler");
    // 左滑显示个人信息暂时。
}

- (void) swipeRightHandler:(UISwipeGestureRecognizer*)recognizer{
    NSLog(@"swipeRightHandler");
    // TODO : 滑动出现我的。
    
}

//设置导航栏
- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIView *tempView;
    CGRect navRect = self.navigationController.navigationBar.frame;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
    
    // 这里可以试试 UIBarButtonItem的customView来处理2个btn
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -10;// TODO 负数无效这里
    UIBarButtonItem *right1 =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_filter"] style:UIBarButtonItemStylePlain target:self action:@selector(onList:)];
    self.navigationItem.rightBarButtonItems = @[spacer,right1] ;
    
    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    UILabel *tempLable = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"单品" fontStyle:FONT_SIZE(18) color:COLOR_WHITE rect:CGRectMake(0, 0, 0, 0) isFitWidth:YES isAlignLeft:YES];
    self.navigationItem.titleView = tempLable;
    
}

-(void)onBack:(id)sender{
    [self popAnimated:YES];
}

-(void)searchContent:(id)sender{
    NSLog(@"搜索");
}


-(void)onList:(id)sender{
    NSLog(@"列表");
//    SItemListViewController *vc = [SItemListViewController new];
//    [self pushController:vc animated:YES];
    SFilterCollectionViewController *vc = [[SFilterCollectionViewController alloc] initWithNibName:@"SFilterCollectionViewController" bundle:nil];
    vc.didSelectedEnter = ^(id sender)
    {
        NSDictionary *dic =(NSDictionary *)sender;
        FilterPirceRangeModel *priceRangeModel = dic[@"pirceRangeModel"];
        FilterColorCategoryModel *colorModel= dic[@"colorModel"];
        FilterBrandCategoryModel *brandModel=dic[@"brandModel"];
        NSString *textStr = [NSString stringWithFormat:@"%@%@%@",[Utils getSNSString:priceRangeModel.name] ,[Utils getSNSString:colorModel.coloR_NAME],[Utils getSNSString:brandModel.branD_NAME]];
        [self searchBarTextSearch:textStr];
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}







//-(void)dealData:(NSArray*)data
//{
//    // track black screen
//    NSLog(@"dealData");
//    for(NSInteger i = 0;i<[data count];i++)
//    {
//        NSMutableDictionary *dataAry = [NSMutableDictionary dictionaryWithDictionary:[data objectAtIndex:i]];
//        [SGLOBAL_DATA_INSTANCE.specialArray addObject:dataAry];
//    }
//    SGLOBAL_DATA_INSTANCE.specialLastIndex += [data count];
//    [self.collectionView reloadData];
//}
//设置collectionView的header部分
-(void) updateHeaderView:(UICollectionReusableView*) headerView{
   
}

//设置collectionView
- (void)setupCollectionView {
    if (!collectionDataArr) {
        collectionDataArr = [[NSMutableArray alloc]init];
    }
    if (_categoryArray.count>0) {
        BrandModel *model = _categoryArray[0];
        NSArray * temp = model.subItems;
        [collectionDataArr addObjectsFromArray:temp];
    }
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    NSInteger column = 3;
    
    float tempfloat = (UI_SCREEN_WIDTH - AUTO_SIZE(165/2))/column;
    layout.itemSize = CGSizeMake(tempfloat, AUTO_SIZE((195+66)/2));
    layout.minimumInteritemSpacing = 0;
//    layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    layout.minimumLineSpacing = 0;
    float height = self.navigationController.navigationBar.height + AUTO_SIZE(88/2+20);
    CGRect rect = CGRectMake(AUTO_SIZE(165/2), height, UI_SCREEN_WIDTH-AUTO_SIZE(165/2), UI_SCREEN_HEIGHT - height);
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView setAlwaysBounceVertical:YES];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[SItemCell class] forCellWithReuseIdentifier:SItemCellIdentifier];
}


#pragma mark 分类左边栏数据网络请求方法
-(void)categoryListRequest
{
    if (!_categoryArray) {
        _categoryArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [_categoryArray removeAllObjects];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    //注意把接口改下
    [HttpRequest productGetRequestPath:@"Product" methodName:@"ProductCategorySubItemFilter" params:dict success:^(NSDictionary *dict) {
        [Toast hideToastActivity];
//        if (_categoryTable.isHidden) {
//            [_categoryTable setHidden:NO];
//        }
        NSString *message = nil;
        
        NSArray *result = [dict objectForKey:@"results"];
        if (result.count <= 0) {
            message = @"没有更多信息";
        }else{
            
            if (!listButtonTitleArr) {
                listButtonTitleArr =[[NSMutableArray alloc]init];
            }
            
            for(NSDictionary *dict in result){
                BrandModel *model = [[BrandModel alloc] initWithBrandDict:dict];
                [_categoryArray addObject:model];
                [listButtonTitleArr addObject:model.name];
                
            }
//
//            if(_categoryTable)
//            {
//                [_categoryTable reloadData];
//            }
//            [_categoryTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
        [self setupCollectionView];
        [self updateUI];
    } failed:^(NSError *error) {
        
        [Toast hideToastActivity];
    }];
    
    
}
#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [collectionDataArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 创建可重用的cell
    SItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SItemCellIdentifier forIndexPath:indexPath];
    //判断是否是重用
    if (_categoryArray.count>indexPath.row) {
        BrandSubItem *model = collectionDataArr[indexPath.row];
        [cell updateSItemModel:model];
    }
    
    

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MBBrandViewController * detailVC = [[MBBrandViewController alloc]init];
    BrandSubItem *model = collectionDataArr[indexPath.row];
    detailVC.categaryID = model.idValue;
// TODO:暂时用他们的品牌vc
    detailVC.brandName = model.name;

    [self.navigationController pushViewController:detailVC animated:YES];

}



#pragma mark - UIScrollViewdelegate methods
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //    [self.blrView blurWithColor:[BLRColorComponents darkEffect]];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.view endEditing:YES];
    CGPoint offset = scrollView.contentOffset;
    
    CGRect bounds = scrollView.bounds;
    
    CGSize size = scrollView.contentSize;
    
    UIEdgeInsets inset = scrollView.contentInset;
    
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    
    CGFloat maximumOffset = size.height;
    //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。也可以根据这两个值的差来让他做点其他的什么事情
    if((maximumOffset-currentOffset) <= 0 && (maximumOffset-currentOffset)>-1)
    {
        
    }
}

#pragma mark - long press
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    
    
}

#pragma mark search bar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

}
-(void)searchBarTextSearch:(NSString *)text
{
    SSearchResultViewController * sSearchVC = [[SSearchResultViewController alloc]init];
    sSearchVC.searchText =text;
    sSearchVC.selectedIndex = 1;
    [self.navigationController pushViewController:sSearchVC animated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    SSearchResultViewController * sSearchVC = [[SSearchResultViewController alloc]init];
    sSearchVC.searchText = searchBar.text;
    sSearchVC.selectedIndex = 1;
    [self.navigationController pushViewController:sSearchVC animated:YES];
}

@end
