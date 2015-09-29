//
//  SSearchSimilarViewController.m
//  Wefafa
//
//  Created by Jiang on 15/9/8.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SSearchSimilarViewController.h"
#import "SelectedSubContentView.h"
#import "SUtilityTool.h"
#import "SDataCache.h"
#import "Toast.h"
#import "UIScrollView+MJRefresh.h"
#import "SProductDetailViewController.h"
#import "SSearchProductCollectionView.h"
#import "SSearchProductModel.h"

#import "STokenSearchView.h"
#import "SFilterCollectionViewController.h"
@interface SSearchSimilarViewController ()
<UISearchBarDelegate, UIScrollViewDelegate,
SelectedSubContentViewDelegate, SProductCollectionDelegate,STokenSearchViewDataSource,STokenSearchViewDelegate>
{
    NSInteger _pageIndex;
    CALayer *_selectBtnLayer;
    int _sortType; //升序降序类型 1升序 -1降序
    int _sortField; //排序字段，取值如下，1：价格price，2：总销量saleCount，3：上市日期marketDate，4：周销量weekSaleCount，5：满意度saticsfaction
}
@property (nonatomic, strong) SelectedSubContentView *selectedView;
@property (weak, nonatomic) UIView *selectedContentView;
@property (nonatomic, strong) NSMutableArray *btnArrM;

@property (weak, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) SSearchProductCollectionView *contentCollectionView;

@property (nonatomic, strong) STokenSearchView *tokenSearchView;
@property (nonatomic, strong) NSMutableArray *tokens;               //保存搜索标签
@end

@implementation SSearchSimilarViewController

- (NSMutableArray *)btnArrM
{
    if (!_btnArrM) {
        _btnArrM = [NSMutableArray array];
    }
    return _btnArrM;
}

#pragma mark - UIViewController Plifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _sortType = -1;
    _sortField = 3;
    [self setupNavbar];
    [self initSubViews];
    
    [self requestData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tokenSearchView.textField resignFirstResponder];
}

#pragma mark - 初始化界面
- (void)setupNavbar{
    [super setupNavbar];
    
    self.navigationItem.hidesBackButton = YES;
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH - 120, 30)];
    
    //设置自定义搜索栏
    _tokenSearchView = [[STokenSearchView alloc] initWithFrame:CGRectMake(-10, 2, UI_SCREEN_WIDTH - 100, 26)];
    _tokenSearchView.delegate = self;
    _tokenSearchView.dataSource = self;
    [_tokenSearchView reloadData];
    [titleView addSubview:_tokenSearchView];
    self.navigationItem.titleView = titleView;

    //add navigation right Button
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
//    negativeSpacer.width = -10;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_filter"] style:UIBarButtonItemStylePlain target:self action:@selector(jumpSfilterViewController:)];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
    
    ////add navigation left Button
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController:)];
    self.navigationItem.leftBarButtonItems = @[left1] ;
}

- (void)initSubViews{
    [self initContentView];
    self.searchBar.delegate = self;
    self.searchBar.text = _searchText;
    [self createSelectView];
}


- (void)initContentView
{
    CGRect frame = CGRectMake(0, 104, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 104);
    
    __unsafe_unretained typeof(self) p = self;
    //单品列表
    frame.origin.x = UI_SCREEN_WIDTH *0;
    _contentCollectionView = [[SSearchProductCollectionView alloc]initWithFrame:frame];
    [_contentCollectionView addFooterWithTarget:self action:@selector(requestAddData)];
    [_contentCollectionView setProductDelegate:self];
    _contentCollectionView.opration = ^(NSIndexPath *indexPath, NSArray *array){
        SSearchProductModel *model = array[indexPath.row];
        SProductDetailViewController *controller = [[SProductDetailViewController alloc]init];
        controller.productID = [NSString stringWithFormat:@"%@",model.aID];
        
        controller.productID = [NSString stringWithFormat:@"%@",model.code];
        [p.navigationController pushViewController:controller animated:YES];
    };
    _contentCollectionView.isShowPrice = YES;
    [self.view addSubview:_contentCollectionView];
}

- (void)createSelectView
{
    CGRect selectViewF = CGRectMake(0, 64, UI_SCREEN_WIDTH, 44);
    UIView *selectView = [[UIView alloc] initWithFrame:selectViewF];
    selectView.layer.masksToBounds = YES;
    selectView.backgroundColor = COLOR_C3;
    [self.view addSubview:selectView];
    _selectedContentView = selectView;
    
    NSArray *titleArr = @[@"上新", @"热销", @"价格"];
    NSArray *imgArr = @[@"", @"", @"Unico/btn_sort_nomal"];
    NSInteger count = MIN(titleArr.count, imgArr.count);
    
//    CGFloat originX = 0.f;
    CGFloat btnW = UI_SCREEN_WIDTH/titleArr.count;
    for (NSInteger i=0; i<count; i++) {
//        originX = (btnW+ (UI_SCREEN_WIDTH - 75 *count) / (count -1)) * i;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW*i, 0, btnW, 44)];

        btn.titleLabel.font = FONT_t4;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_C7 forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_C2 forState:UIControlStateSelected];
        NSString *imgName = imgArr[i];
        if (![imgName isEqualToString:@""]) {
            [btn setImage:[UIImage imageNamed:imgName]
                 forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, btnW/2+5, 0, 0);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, btnW/2-70, 0, 0);
        }
        btn.tag = 100 +i;
        [btn addTarget:self action:@selector(selectBtnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
        [selectView addSubview:btn];
        [self.btnArrM addObject:btn];
    }
    
    CALayer *selectBtnLayer = [CALayer layer];
    selectBtnLayer.backgroundColor = COLOR_C1.CGColor;
    selectBtnLayer.frame = CGRectMake(0, 41, 40, 3);
    selectBtnLayer.zPosition = 5.f;
    [selectView.layer addSublayer:selectBtnLayer];
    _selectBtnLayer = selectBtnLayer;
    
    [self selectBtnClicked:[_btnArrM firstObject]];
}

#pragma mark - 跳入筛选界面
- (void)jumpSfilterViewController:(UIBarButtonItem*)barItem
{    NSLog(@"%s", __func__);
    [_chooseDic removeAllObjects];
    NSLog(@"%s", __func__);
    SFilterCollectionViewController *vc = [[SFilterCollectionViewController alloc] initWithNibName:@"SFilterCollectionViewController" bundle:nil];
    vc.isBack=YES;
    vc.isComeFromBrand=NO;
    
    
//    _searchText = @"";

    
    if(_tokenSearchView.textField.text.length>0){
        _searchText=[NSString stringWithFormat:@"%@ %@",_searchText,_tokenSearchView.textField.text];
    }
    vc.keyword=_searchText;
    vc.dailyNewModel=nil;
    
    vc.didSelectedEnter = ^(id sender)
    {
        _chooseDic =(NSMutableDictionary *)sender;
        _contentCollectionView.contentArray=nil;
        [self requestAddData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//返回上一级菜单
- (void)dismissViewController:(UIBarButtonItem*)barItem{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 实现功能方法
- (void)selectBtnClicked:(UIButton *)sender
{
    int index = (int)sender.tag - 100;
    _selectBtnLayer.position = CGPointMake(sender.centerX, _selectBtnLayer.position.y);
    _sortField = 3 - index;
    for (UIButton *button in _btnArrM) {
        button.selected = button == sender;
    }
    if (index == 2) {
        _sortType = _sortType == -1? 1: -1;
        if (_sortType == 1) {
            [sender setImage:[UIImage imageNamed:@"Unico/btn_sort_top"] forState:UIControlStateSelected];
        }else{
            [sender setImage:[UIImage imageNamed:@"Unico/btn_sort_bottom"] forState:UIControlStateSelected];
        }
    }else{
        _sortType = -1;
    }
    _pageIndex = 0;
    [self requestData];
}

#pragma mark - 获取查询数据
- (void)requestData
{
    NSMutableDictionary *params = [NSMutableDictionary
                                   dictionaryWithDictionary:@{@"m":@"Search",
                                                              @"a":@"getProductListByKey",
                                                              @"keyword": [Utils getSNSString:_searchText],
                                                              @"sortField":@(_sortField),
                                                              @"sortType":@(_sortType),
                                                              @"page": @(_pageIndex),
                                                              @"pageSize": @(10)
                                                              }];
    
    if ([[_chooseDic allKeys]count]>0) {
        
        if([[_chooseDic allKeys]containsObject:@"cid"])
        {
            [params setObject:_chooseDic[@"cid"] forKey:@"cid"];
        }
        if([[_chooseDic allKeys]containsObject:@"brand"])
        {
            [params setObject:_chooseDic[@"brand"] forKey:@"brand"];
        }
        if([[_chooseDic allKeys]containsObject:@"sizeCode"])
        {
            [params setObject:_chooseDic[@"sizeCode"] forKey:@"sizeCode"];
        }
        if([[_chooseDic allKeys]containsObject:@"color"])
        {
            [params setObject:_chooseDic[@"color"] forKey:@"color"];
            //            params[@"color"]=_chooseDic[@"color"];
        }
        if([[_chooseDic allKeys]containsObject:@"priceRange"])
        {
            [params setObject:_chooseDic[@"priceRange"] forKey:@"priceRange"];
            //            params[@"priceRange"]=_chooseDic[@"priceRange"];
        }
        if([[_chooseDic allKeys]containsObject:@"discountRange"])
        {
            [params setObject:_chooseDic[@"discountRange"] forKey:@"discountRange"];
            //            params[@"priceRange"]=_chooseDic[@"priceRange"];
        }
        if([[_chooseDic allKeys]containsObject:@"productId"])
        {
            [params setObject:_chooseDic[@"productId"] forKey:@"productId"];
        }
    }
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id object) {
        [_contentCollectionView footerEndRefreshing];
        if ([object[@"status"] intValue] != 1) {
            [Toast makeToast:@"网络错误，请重试！" duration:1.5 position:@"center"];
            return ;
        }
        
        NSNumber *isHotData = @NO;
        NSArray *array = object[@"data"][@"list"];
        if (array.count == 0&&_contentCollectionView.contentArray.count==0) {
            array = object[@"data"][@"hotlist"];
            isHotData = @YES;
        }
        
        if (_pageIndex != 0 && _contentCollectionView.isHotData && [_contentCollectionView.isHotData boolValue]) {
            return;
        }
        
        if (_pageIndex == 0) {
            _contentCollectionView.contentArray = array;
        }else{
            NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:_contentCollectionView.contentArray];
            [mutableArray addObjectsFromArray:array];
            _contentCollectionView.contentArray = mutableArray;
        }
        _contentCollectionView.isHotData = isHotData;
        if (array.count == 0) {
            [Toast makeToast:@"已经到底了！" duration:1.5 position:@"center"];
            return;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_contentCollectionView footerEndRefreshing];
        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
    }];
}

- (void)requestAddData{
    _pageIndex = (_contentCollectionView.contentArray.count + 9)/ 10;
    [self requestData];
}


#pragma mark - PDSearchViewDataSource
-(NSString *)accessTokenText{
    return _searchText;
}

#pragma mark - PDSearchViewDelegate
- (void)tokenSearchView:(STokenSearchView *)searchView didReturnWithText:(NSString *)text{
    _searchText = text;
    //向SSearchViewController 返回搜索关键词
    //_returnblock(_searchText);
    [self requestData];
}

- (void)tokenSearchView:(STokenSearchView *)searchView didRemoveTokenSting:(NSString *)text
{
    _searchText = text;
    [self requestData];

}

- (void)tokenSearchView:(STokenSearchView *)searchView textFieldShouldBeginEditing:(UITextField *)textField{
    
}

-(void)setChooseDic:(NSMutableDictionary *)chooseDic{
    _chooseDic=chooseDic;
}
@end
