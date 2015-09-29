//
//  SItemListViewController.m
//  Wefafa
//
//  Created by unico on 15/5/19.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SItemListViewController.h"
#import "SItemFilterViewController.h"
#import "SFilterCollectionViewController.h"
#import "SProductDetailViewController.h"
#import "MBGoodsDetailsModel.h"
#import "HttpRequest.h"
#import "SItemListCell.h"
#import "SUtilityTool.h"
#import "FilterPirceRangeModel.h" 
#import "FilterColorCategoryModel.h"
#import "FilterBrandCategoryModel.h"

@interface SItemListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UISearchControllerDelegate>
{
    //滚动时加载
    BOOL scrollLoading;
}
//// 底部视图

//---
@property (nonatomic, strong) NSArray *contentModelArray;

@end

@implementation SItemListViewController
static NSString *SItemCellIdentifier = @"SItemCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // TODO: 判断登陆状态，如果没有登录，显示登录界面。
    //白色底色
    UIView *tempView = [SUTILITY_TOOL_INSTANCE createUIViewByHeight:UI_SCREEN_HEIGHT-20-self.navigationController.navigationBar.height coordY:20+self.navigationController.navigationBar.height];
    [self.view addSubview:tempView];
    tempView.backgroundColor = COLOR_WHITE;
    [self setupCollectionView];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupNavbar];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)requestData{
    [HttpRequest productPostRequestPath:nil methodName:@"ProductClsCommonSearchFilter"params:@{@"pageIndex": @1, @"pageSize" : @20} success:^(NSDictionary *dict) {
        self.contentModelArray = [MBGoodsDetailsModel modelArrayForDataArray:dict[@"results"]];
        [self.collectionView reloadData];
    } failed:^(NSError *error) {
        
    }];
}

- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//    UIView *tempView;
//    CGRect navRect = self.navigationController.navigationBar.frame;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
    
    // 这里可以试试 UIBarButtonItem的customView来处理2个btn
    
//    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    spacer.width = -10;// TODO 负数无效这里
    UIBarButtonItem *right1 =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_filter"] style:UIBarButtonItemStylePlain target:self action:@selector(onFilter:)];
//
    self.navigationItem.rightBarButtonItems = @[right1] ;
//    //白底
//    tempView = [SUTILITY_TOOL_INSTANCE createUIViewByHeightAndWidth:navRect.size.height - 22/2  width:UI_SCREEN_WIDTH-110 coordY:0];
//    tempView.backgroundColor = COLOR_WHITE;
//    
//    UILabel *tempLable = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"黑色" fontStyle:FONT_SIZE(18) color:[UIColor whiteColor] rect:CGRectMake(10/2, 0, 0, 48/2) isFitWidth:YES isAlignLeft:YES];
//    UIView *tempView2 = [SUTILITY_TOOL_INSTANCE createUIViewByHeightAndWidth:tempLable.height width:tempLable.width+30 coordY:tempView.height/2 -tempLable.height/2];
//    [tempView2 setOrigin:CGPointMake(10/2, tempView2.frame.origin.y)];
//    tempView2.backgroundColor = UIColorFromRGB(0xc4c4c4);
//    [tempView2 addSubview:tempLable];
//    [tempView addSubview:tempView2];

    CGRect navRect = self.navigationController.navigationBar.frame;
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    UILabel *tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"单品" fontStyle:FONT_SIZE(18) color:COLOR_WHITE rect:CGRectMake(0, 0, 0, self.navigationController.navigationBar.height) isFitWidth:YES isAlignLeft:YES];
    [tempView setSize:CGSizeMake(tempLabel.width, self.navigationController.navigationBar.height)];
    [tempView addSubview:tempLabel];
    self.navigationItem.titleView = tempView;
    self.navigationItem.titleView = tempView;
    
}

-(void)onBack:(id)sender{
    [self popAnimated:YES];
}

-(void)searchContent:(id)sender{
    NSLog(@"搜索");
}


-(void)onFilter:(id)sender{
    NSLog(@"过滤");
    SFilterCollectionViewController *vc = [[SFilterCollectionViewController alloc] initWithNibName:@"SFilterCollectionViewController" bundle:nil];
    vc.didSelectedEnter = ^(id sender)
    {
        NSDictionary *dic =(NSDictionary *)sender;
        FilterPirceRangeModel *priceRangeModel = dic[@"pirceRangeModel"];
        FilterColorCategoryModel *colorModel= dic[@"colorModel"];
        FilterBrandCategoryModel *brandModel=dic[@"brandModel"];
        NSLog(@"priceRangeModel.name .....-%@---%@----%@",priceRangeModel.name,colorModel.coloR_NAME,brandModel.branD_NAME);
        
    };
    
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)onCart:(id)sender{
    NSLog(@"购物车");
}







-(void) updateHeaderView:(UICollectionReusableView*) headerView{
    
}


- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    NSInteger column = 2;

    float tempfloat = (UI_SCREEN_WIDTH-34-22/2)/column;
    layout.itemSize = CGSizeMake(tempfloat, AUTO_SIZE((556+70)/2));
    layout.minimumInteritemSpacing = 22/2;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumLineSpacing = 10;
    float height = self.navigationController.navigationBar.height + AUTO_SIZE(20);
    CGRect rect = CGRectMake(34/2, height, UI_SCREEN_WIDTH-AUTO_SIZE(34), UI_SCREEN_HEIGHT - height);
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerClass:[SItemListCell class] forCellWithReuseIdentifier:SItemCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 创建可重用的cell
    SItemListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SItemCellIdentifier forIndexPath:indexPath];
    MBGoodsDetailsModel *model = _contentModelArray[indexPath.row];
    cell.contentModel = model;
    //判断是否是重用
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MBGoodsDetailsModel *model = _contentModelArray[indexPath.row];
    SProductDetailViewController *controller = [[SProductDetailViewController alloc]init];
    controller.productID = [NSString stringWithFormat:@"%@", model.clsInfo.code];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - UIScrollViewdelegate methods
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //    [self.blrView blurWithColor:[BLRColorComponents darkEffect]];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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

#pragma mark -
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

@end
