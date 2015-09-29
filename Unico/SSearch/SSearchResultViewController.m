//
//  SSearchResultViewController.m
//  Wefafa
//
//  Created by unico_0 on 5/31/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SSearchResultViewController.h"
#import "SelectedSubContentView.h"
#import "SSearchBrandTableView.h"
#import "SSearchProductCollectionView.h"
#import "SSearchDesignerTableView.h"
#import "SSearchTopicTableView.h"
#import "SSearchCollocationCollectionView.h"
#import "HttpRequest.h"
#import "SUtilityTool.h"
#import "WeFaFaGet.h"
#import "SDataCache.h"
#import "AFNetworking.h"
#import "LNGood.h"
#import "SSearchProductModel.h"
#import "StopicListModel.h"
#import "UIScrollView+MJRefresh.h"
#import "Toast.h"
#import "MBOtherUserInfoModel.h"

#import "SCollocationDetailViewController.h"
#import "SBrandSotryViewController.h"
#import "STopicDetailViewController.h"
#import "SMineViewController.h"
#import "SProductDetailViewController.h"
#import "AppSetting.h"
#import "SCollocationDetailNoneShopController.h"
#import "BrandDetailViewController.h"
#import "DailyNewViewController.h"

#import "STokenSearchView.h"

#import "SSearchSimilarViewController.h"
@interface SSearchResultViewController ()<SelectedSubContentViewDelegate, UISearchBarDelegate, UIScrollViewDelegate,SMineTableViewDelegate,SSearchTopicTableViewDelegate,SProductCollectionDelegate,SSearchCollocationCollectionViewDelegate,STokenSearchViewDataSource,STokenSearchViewDelegate,UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _pageIndex;
    NSInteger _pageSize;
    BOOL _isSelfCreate;
    
    
    
}
//点击单品页面
@property (nonatomic, weak) UITableView *showSearchContentTableView;
//数组
@property (nonatomic, strong) NSArray *searchContentArray;


@property (nonatomic, strong) SelectedSubContentView *selectedView;
@property (weak, nonatomic) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
//------
@property (nonatomic, strong) STokenSearchView *tokenSearchView;
@end

@implementation SSearchResultViewController

#pragma mark - UIViewController Plifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _pageIndex = 0;
    _pageSize = 10;
    
    [self initSaveData];
    [self setupNavbar];
    [self initSubViews];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)dealloc{
    if (_isSelfCreate) {
        NSString *centerFilePath= [AppSetting getPersonalFilePath];
        NSString *filePath=[centerFilePath stringByAppendingPathComponent:@"searchCacheData"];
        [_searchSaveDictionary writeToFile:filePath atomically:YES];//写入
    }
}

#pragma mark - Init View
#pragma mark - 初始化存储数据
- (void)initSaveData{
    if (_searchSaveDictionary) return;
    _isSelfCreate = YES;
    NSString *centerFilePath= [AppSetting getPersonalFilePath];
    NSString *filePath=[centerFilePath stringByAppendingPathComponent:@"searchCacheData"];
    _searchSaveDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    if (!_searchSaveDictionary) {
        _searchSaveDictionary = [NSMutableDictionary dictionary];
    }
}

#pragma mark 初始化主界面
- (void)initSubViews{
    [self initContentScrollView];
    
    self.searchBar.delegate = self;
    if (_searchText) {
        //self.searchBar.text = _searchText;
        //_searchBar.text = _searchSaveDictionary[@"searchContent"];
    }else{
        // self.searchBar.text = _searchSaveDictionary[@"searchContent"];
        
        _searchText = _searchSaveDictionary[@"searchContent"];
        [self.tokenSearchView reloadData];
    }
    
    CGRect frame = CGRectMake(0, 64, UI_SCREEN_WIDTH, 44);
    self.selectedView = [[SelectedSubContentView alloc]initWithFrame:frame AndNameArray:@[@"单品", @"搭配", @"用户", @"品牌", @"标签"]];
    self.selectedView.isShowAnimation = NO;
    self.selectedView.delegate = self;
    [self.selectedView scrollViewEndAction:_selectedIndex];
    self.selectedView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_selectedView];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, _selectedView.frame.size.height - 0.5, _selectedView.frame.size.width, 0.5);
    layer.backgroundColor = COLOR_C9.CGColor;
    layer.zPosition = 5;
    [_selectedView.layer addSublayer:layer];
    
    // 在贴tag时候隐藏。
    if (_completeFunc) {
        self.contentScrollView.scrollEnabled = NO;
        self.selectedView.userInteractionEnabled = NO;
        self.selectedView.hidden = YES;
        for (int i = 0; i < 5; i++) {
            UIScrollView *scrollView = _contentScrollView.subviews[i];
            scrollView.contentInset = UIEdgeInsetsZero;
            CGRect frame = scrollView.frame;
            frame.size.height = UI_SCREEN_HEIGHT - 64;
            frame.origin.y = 0;
            scrollView.frame = frame;
        }
    }
    //添加 显示搜索结果集合的view
    [self addShowSearchContentTableView];
}

#pragma mark 添加 显示搜索结果集合的view
- (void)addShowSearchContentTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - CGRectGetMaxY(_selectedView.frame))];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = COLOR_C9;
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.contentScrollView addSubview:tableView];
    _showSearchContentTableView = tableView;
}

#pragma mark 初始化NavigationBar
- (void)setupNavbar{
    [super setupNavbar];
    
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
    
    //设置自定义搜索栏
    _tokenSearchView = [[STokenSearchView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH-80, 26)];
    _tokenSearchView.delegate = self;
    _tokenSearchView.dataSource = self;
    self.navigationItem.titleView = _tokenSearchView;
    
    //navigation添加返回
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
}

#pragma mark 添加列表
- (void)initContentScrollView{
    _contentScrollView.delegate = self;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH * 5, 0);
    _contentScrollView.contentOffset = CGPointMake(UI_SCREEN_WIDTH * _selectedIndex, 0);
    CGRect frame = CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - _contentScrollView.frame.origin.y - 44);
    
    __unsafe_unretained typeof(self) p = self;
    
    //单品列表
    frame.origin.x = UI_SCREEN_WIDTH * 0;
    SSearchProductCollectionView *productCollectionView = [[SSearchProductCollectionView alloc]initWithFrame:frame];
    [productCollectionView addFooterWithTarget:self action:@selector(requestAddData)];
    [productCollectionView setProductDelegate:self];
    productCollectionView.opration = ^(NSIndexPath *indexPath, NSArray *array){
        SSearchProductModel *model = array[indexPath.row];
        // 添加标签回调
        if (p.completeFunc) {
            p.completeFunc(model.aID.stringValue, model.name, model.brand);
            return;
        }
        //单品详情传入的应该是code
        SProductDetailViewController *controller = [[SProductDetailViewController alloc]init];
        controller.productID = [NSString stringWithFormat:@"%@",model.aID];
        
        controller.productID = [NSString stringWithFormat:@"%@",model.code];
        [p.navigationController pushViewController:controller animated:YES];
    };
    productCollectionView.isShowPrice = YES;
    [self.contentScrollView addSubview:productCollectionView];
    
    //搭配列表
    frame.origin.x = UI_SCREEN_WIDTH * 1;
    SSearchCollocationCollectionView *collocationCollectionView = [[SSearchCollocationCollectionView alloc]initWithFrame:frame];
    [collocationCollectionView setCollectionDelagate:self];
    [collocationCollectionView addFooterWithTarget:self action:@selector(requestAddData)];
    collocationCollectionView.opration = ^(NSIndexPath *indexPath, NSArray *array){
        LNGood *good = array[indexPath.row];
        NSString * collocationId  = good.product_ID ;
        if (collocationId<0) {
            return;
        }
        extern BOOL g_socialStatus;
        if (g_socialStatus)//是否处于社交状态
        {
            SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
            detailNoShoppingViewController.collocationId = collocationId;
            [p.navigationController pushViewController:detailNoShoppingViewController animated:YES];
        }
        else
        {
            SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
            collocationDetailVC.collocationId = collocationId;
            [p.navigationController pushViewController:collocationDetailVC animated:YES];
            
        }
    };
    [self.contentScrollView addSubview:collocationCollectionView];
    
    
    //造型师列表
    frame.origin.x = UI_SCREEN_WIDTH * 2;
    SSearchDesignerTableView *designerTableView = [[SSearchDesignerTableView alloc]initWithFrame:frame];
    [designerTableView addFooterWithTarget:self action:@selector(requestAddData)];
    [designerTableView setTableViewDelegate:self];
    
    designerTableView.opration = ^(NSIndexPath *indexPath, NSArray *array){
        MBOtherUserInfoModel *model = array[indexPath.row];
        // 添加标签回调
        if (p.completeFunc) {
            p.completeFunc(model.userId, model.nickName,@"");
            return;
        }
        SMineViewController *vc = [[SMineViewController alloc]init];
        vc.person_id = model.userId;
        [p.navigationController pushViewController:vc animated:YES];
    };
    [_contentScrollView addSubview:designerTableView];
    
    //品牌列表
    frame.origin.x = UI_SCREEN_WIDTH * 3;
    SSearchBrandTableView *brandTableView = [[SSearchBrandTableView alloc]initWithFrame:frame];
    [brandTableView addFooterWithTarget:self action:@selector(requestAddData)];
    
    brandTableView.opration = ^(NSIndexPath *indexPath, NSArray *array){
        NSDictionary *dict = array[indexPath.row];
        // 添加标签回调
        if (p.completeFunc) {
            p.completeFunc(dict[@"temp_id"],dict[@"english_name"],@"");
            return;
        }
        /*
         BrandDetailViewController *controller = [BrandDetailViewController new];
         controller.brandId = [NSString stringWithFormat:@"%@",dict[@"brand_code"]];
         [p.navigationController pushViewController:controller animated:YES];
         */
        DailyNewViewController *dailyNewVC = [DailyNewViewController new];
        dailyNewVC.brandId = [dict objectForKey:@"brand_code"];
        dailyNewVC.isCanSocial=NO;
        [self.navigationController pushViewController:dailyNewVC animated:YES];
    };
    [self.contentScrollView addSubview:brandTableView];
    
    //话题列表
    frame.origin.x = UI_SCREEN_WIDTH * 4;
    SSearchTopicTableView *topicTableView = [[SSearchTopicTableView alloc]initWithFrame:frame];
    topicTableView.targetController = self;
    topicTableView.topicDelegate = self;
    [topicTableView addFooterWithTarget:self action:@selector(requestAddData)];
    
    topicTableView.opration = ^(StopicListModel *model){
        // 添加标签回调
        if (p.completeFunc) {
            p.completeFunc([NSString stringWithFormat:@"%@",model.aID] ,model.name,@"");
            return;
        }
        STopicDetailViewController *controller = [[STopicDetailViewController alloc]init];
        controller.topicID = model.aID;
        controller.titleName = model.name;
        [p.navigationController pushViewController:controller animated:YES];
    };
    [self.contentScrollView addSubview:topicTableView];
}

#pragma mark - Get Data
#pragma mark - 根据类型获取数据
- (void)requestAddData{
    UIView *view = self.contentScrollView.subviews[_selectedIndex];
    [view setValue:@NO forKey:@"isAbandonRefresh"];
    NSArray *array = [view valueForKey:@"contentArray"];
    _pageIndex = (array.count + _pageSize - 1)/ _pageSize;
    [self requestData];
}

#pragma mark 获取数据
- (void)requestData{
    UIScrollView *view = self.contentScrollView.subviews[_selectedIndex];
    NSString *methodName = nil;
    NSString *tokenString;
    switch (_selectedIndex) {
        case 0://搜索单品
        {
//            methodName = @"getProductListByKey";
//            tokenString = [SDataCache sharedInstance].userInfo[@"token"];
//            _pageSize = 10
            _searchContentArray=[self ItemAry:_searchText Index:(int)_searchText.length];
            
            [_showSearchContentTableView reloadData];
            return;
        }
            break;
        case 1://搜索搭配
            methodName = @"getCollocationListByKey";
            _pageSize = 10;
            break;
            
        case 2://搜索造型师
            methodName = @"getDesignerListByKey";
            tokenString = [SDataCache sharedInstance].userInfo[@"token"];
            _pageSize = 20;
            break;
        case 3://搜索品牌
            methodName = @"getBrandListByKey";
            _pageSize = 20;
            break;
        case 4://搜索话题
            methodName = @"getTopicListByKey";
            _pageSize = 10;
            break;
        default:
            break;
    }
    NSNumber *isAbandonRefresh = [view valueForKey:@"isAbandonRefresh"];
    if (isAbandonRefresh.boolValue) {
        return;
    }else{
        [view setValue:@YES forKey:@"isAbandonRefresh"];
    }
    NSDictionary *data = @{
                           @"m": @"Search",
                           @"a": methodName,
                           @"keyword": _searchText,
                           @"page": @(_pageIndex),
                           @"pageSize": @(_pageSize)
                           };
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation *operation, id object) {
        [view footerEndRefreshing];
        if ([object[@"status"] intValue] != 1) {
            [Toast makeToast:@"网络错误，请重试！" duration:1.5 position:@"center"];
            return ;
        }
        NSNumber *isHotData = @NO;
        NSArray *array =[NSArray new];
        id objectArray = object[@"data"][@"list"];
        //wwp 容错 解决 list 不是数组bug
        if([objectArray isKindOfClass:[NSArray class]])
        {
            array = object[@"data"][@"list"];
        }
        
        if (array.count == 0) {
            array = object[@"data"][@"hotlist"];
            isHotData = @YES;
        }
        
        if (_pageIndex != 0 && [view valueForKey:@"isHotData"] && [[view valueForKey:@"isHotData"] boolValue]) {
            return;
        }
        if (array.count == 0) {
            [Toast makeToast:@"已经到底了！" duration:1.5 position:@"center"];
            return;
        }
        NSArray *oldArray = [view valueForKey:@"contentArray"];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:oldArray];
        [mutableArray addObjectsFromArray:array];
        
        [view performSelector:@selector(setIsHotData:) withObject:isHotData];
        [view performSelector:@selector(setContentArray:) withObject:mutableArray];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [view footerEndRefreshing];
        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
    }];
}

#pragma mark 根据关键词获取数据
- (void)requestDataOpration {
    for (int i = 0; i < 5; i++) {
        UIView *view = self.contentScrollView.subviews[i];
        [view setValue:nil forKey:@"contentArray"];
        [view performSelector:@selector(setIsHotData:) withObject:@NO];
        [view setValue:@NO forKey:@"isAbandonRefresh"];
    }
    [self saveDataForUserSearch];
    [self requestData];
}

#pragma mark - Event Processing
#pragma mark - action
- (void)dismissViewController:(UIBarButtonItem*)barItem{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 存储搜索关键词数据
- (void)saveDataForUserSearch{
    _searchSaveDictionary[@"searchContent"] = _searchText;
    if (!_searchSaveDictionary) {
        _searchSaveDictionary = [NSMutableDictionary dictionary];
    }
    NSString *string = [NSString stringWithFormat:@"search%d", (int)_selectedIndex];
    NSMutableArray *array = [_searchSaveDictionary valueForKey:string];
    if (!array) {
        array = [NSMutableArray array];
    }else{
        array = [NSMutableArray arrayWithArray:array];
    }
    int count = 0;
    for (int i = 0; i < array.count; i++){
        NSString *userString = array[i];
        if ([userString isEqualToString:_searchText]) {
            count++;
            break;
        }
    }
    if (count == 0) {
        [array addObject:_searchText];
        if (array.count > 10) {
            for (int i = 10; i < array.count; i++) {
                [array removeObjectAtIndex:i];
            }
        }
        [_searchSaveDictionary setValue:array forKey:string];
    }
}

- (void)listViewDidScroll:(UIScrollView *)scrollView
{
    if (_searchBar.isFirstResponder) {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark - Delegate and DataSource
#pragma mark - PDSearchViewDataSource
-(NSString *)accessTokenText{
    
    return _searchText;
}

#pragma mark PDSearchViewDelegate
- (void)tokenSearchView:(STokenSearchView *)searchView textFieldShouldBeginEditing:(UITextField *)textField{
    
}

- (void)tokenSearchView:(STokenSearchView *)searchView didReturnWithText:(NSString *)text{
    _searchText = text;
    [self requestDataOpration];
}

- (void)tokenSearchView:(STokenSearchView *)searchView didRemoveTokenSting:(NSString *)text
{
    _searchText = text;
    [self requestDataOpration];
}

#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_searchBar.isFirstResponder) {
        [_searchBar resignFirstResponder];
    }
    CGFloat scrollViewContentWidth = scrollView.contentSize.width - SCREEN_WIDTH;
    CGFloat scrollViewLocation = scrollView.contentOffset.x;
    CGFloat percentage = scrollViewLocation / scrollViewContentWidth;
    [self.selectedView setLineLocationPercentage:percentage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _selectedIndex = scrollView.contentOffset.x/ UI_SCREEN_WIDTH;
    [self.selectedView scrollViewEndAction:_selectedIndex];
}


#pragma mark selectedDelegate
- (void)selectedSubContentViewSelectedIndex:(NSInteger)index{
    [_contentScrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH * index, 0) animated:YES];
    _pageIndex = 0;
    _selectedIndex = index;
    [self requestData];
}

#pragma mark - ***备用方法 暂时弃用***
#pragma mark - search delegate
- (NSMutableAttributedString*)attrubuteStringForString:(NSString*)string index:(int)index{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributeString setAttributes:@{NSForegroundColorAttributeName: COLOR_C7} range:NSMakeRange(0, string.length)];
    return attributeString;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _pageIndex = 0;
    _searchSaveDictionary[@"searchContent"] = _searchText;
    [self saveDataForUserSearch];
    [searchBar resignFirstResponder];
    [self requestDataOpration];
}

- (void)tokenSearchView:(STokenSearchView *)searchView didtTextDidChange:(NSString *)text{
    NSString *itemText=[NSString stringWithFormat:@"%@ %@",_searchText,text];
    if([itemText isEqualToString:@" "]){
        itemText=@"";
    }
    _searchContentArray=[self ItemAry:itemText Index:(int)_searchText.length+2];
    [_showSearchContentTableView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.tintColor = UIColorFromRGB(0xfedc32);
    return YES;
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (_selectedIndex == 0) {
//        return _searchContentArray.count;
//    }else{
//        return 1;
//    }
        return _searchContentArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"SearchContentTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.textLabel.attributedText = _searchContentArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SSearchSimilarViewController *controller = [[SSearchSimilarViewController alloc]init];
    controller.returnblock = ^(NSString *token){
        [_searchSaveDictionary setObject:token forKey:@"searchContent"];
    };
    NSAttributedString *searchStr=_searchContentArray[indexPath.row];
    controller.searchText =[searchStr.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.navigationController pushViewController:controller animated:YES];

}

//单品数组加载
-(NSArray*)ItemAry:(NSString *)text Index:(int)index{
    NSArray *itemAry;
    if (text.length > 0) {
        
       itemAry = @[[self attrubuteStringForString:text index:index],
                                [self attrubuteStringForString:[NSString stringWithFormat:@"男 %@", text] index:index],
                                [self attrubuteStringForString:[NSString stringWithFormat:@"女 %@", text] index:index],
                                [self attrubuteStringForString:[NSString stringWithFormat:@"童 %@", text] index:index]];
    }else{
        itemAry = @[[self attrubuteStringForString:@"男" index:index],
                                [self attrubuteStringForString:@"女" index:index],
                                [self attrubuteStringForString:@"童" index:index]];
    }
    return itemAry;
}
@end
