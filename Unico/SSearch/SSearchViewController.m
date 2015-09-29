//
//  SSearchViewController.m
//  Wefafa
//
//  Created by unico_0 on 5/31/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SSearchViewController.h"
#import "SSearchTagCollectionView.h"
#import "SelectedSubContentView.h"
#import "SSearchResultViewController.h"
#import "SSearchSimilarViewController.h"
#import "SUtilityTool.h"
#import "AppSetting.h"
#import "SDataCache.h"
#import "STokenSearchView.h"

@interface SSearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, SelectedSubContentViewDelegate, UIAlertViewDelegate,STokenSearchViewDataSource,STokenSearchViewDelegate>
{
    NSInteger _selectedIndex;
}

@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, strong) SelectedSubContentView *selectedView;
@property (nonatomic, weak) SSearchTagCollectionView *showTagCollectionView;
@property (nonatomic, weak) UITableView *showSearchContentTableView;
@property (nonatomic, strong) NSArray *searchContentArray;
@property (nonatomic, strong) NSMutableDictionary *searchSaveDictionary;

@property (nonatomic, strong) STokenSearchView *tokenSearchView;
@end

@implementation SSearchViewController

#pragma mark - UIViewController Plifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *centerFilePath= [AppSetting getPersonalFilePath];
    NSString *filePath=[centerFilePath stringByAppendingPathComponent:@"searchCacheData"];
    _searchSaveDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    [self setupNavbar];
    [self initSubViews];
    [self requestSearchHotList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_isSetSearchText) {
        _searchText = _searchSaveDictionary[@"searchContent"];
        [self.tokenSearchView reloadData];
        //_searchBar.text = _searchSaveDictionary[@"searchContent"];
        [self.showTagCollectionView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[_searchBar resignFirstResponder];
}

- (void)dealloc{
    [self saveUserSearchData];
}
#pragma mark - Init View
#pragma mark - 初始化navigationBar
- (void)setupNavbar{
    [super setupNavbar];
    self.navigationItem.hidesBackButton = YES;
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [rightButton addTarget:self action:@selector(cancelPopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONT_t3;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH - 80, 30)];
    titleView.backgroundColor = [UIColor clearColor];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH - 80, 30)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 6.0;
    
    CGRect rect = backView.bounds;
    if ([[[UIDevice currentDevice]systemVersion] intValue] < 8.0) {
        rect = CGRectInset(rect, -10, 0);
    }
    
    /*
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:rect];
    _searchBar = searchBar;
    searchBar.delegate = self;
    [searchBar becomeFirstResponder];
    searchBar.tintColor = UIColorFromRGB(0xfedc32);
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.delegate = self;
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.placeholder = @"搜索:用户、品牌、话题、标签";
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
    [backView addSubview:searchBar];
    [titleView addSubview:backView];
    self.navigationItem.titleView = titleView;
    */
    
    //设置自定义搜索栏
    _tokenSearchView = [[STokenSearchView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH  - 80, 26)];
    _tokenSearchView.delegate = self;
    _tokenSearchView.dataSource = self;
    self.navigationItem.titleView = _tokenSearchView;
}

//初始化页面
- (void)initSubViews{
    //UIView *tfView = self.searchBar.subviews.lastObject;
    //tfView.backgroundColor = [UIColor clearColor];
    CGRect frame = CGRectMake(0, 64, UI_SCREEN_WIDTH, 44);
    self.selectedView = [[SelectedSubContentView alloc]initWithFrame:frame AndNameArray:@[@"单品", @"搭配", @"用户", @"品牌", @"标签"]];
    self.selectedView.isShowAnimation = YES;
    self.selectedView.delegate = self;
    [self.selectedView scrollViewEndAction:0];
    _selectedIndex = 0;
    self.selectedView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_selectedView];
    
    //添加下阴影
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = COLOR_C9.CGColor;
    lineLayer.frame = CGRectMake(0, frame.size.height-1, frame.size.width, 0.5);
    [self.selectedView.layer addSublayer:lineLayer];
    
    //添加 显示标签集合的view
    [self addTagCollectionView];
    //添加 显示搜索结果集合的view
    [self addShowSearchContentTableView];
    _showSearchContentTableView.hidden = YES;
}

#pragma mark 添加 显示标签集合的view
- (void)addTagCollectionView{
    SSearchTagCollectionView *collectionView = [[SSearchTagCollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_selectedView.frame), UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - CGRectGetMaxY(_selectedView.frame))];
    collectionView.tagCollectionDelegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    
    _showTagCollectionView = collectionView;
    [self selectedSubContentViewSelectedIndex:0];
}

#pragma mark 添加 显示搜索结果集合的view
- (void)addShowSearchContentTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_selectedView.frame), UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - CGRectGetMaxY(_selectedView.frame))];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    _showSearchContentTableView = tableView;
}
#pragma mark - Get Data
#pragma mark - 获取热门搜索列表
- (void)requestSearchHotList{
    NSInteger keyItem = 0;
    switch (_selectedIndex) {
        case 0:
            keyItem = 2;
            break;
        case 1:
            keyItem = 1;
            break;
        case 2:
            keyItem = 3;
            break;
        case 3:
            keyItem = 4;
            break;
        case 4:
            keyItem = 5;
            break;
        default:
            break;
    }
    
    NSDictionary *data = @{
                           @"m": @"Search",
                           @"a": @"getKeyWord",
                           @"type": @(keyItem)
                           };
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        _showTagCollectionView.hotContentArray = responseObject[@"data"];
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
    }];
}


#pragma mark - Event Processing
#pragma mark - 跳转到其他页面
//跳入查询结果页
- (void)jumpController{
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
        _showTagCollectionView.userContentArray = array;
        [_searchSaveDictionary setValue:array forKey:string];
    }
    _searchSaveDictionary[@"searchContent"] = _searchText;
    [self jumpAction];
}

#pragma mark 两种搜索结果页
- (void)jumpAction{
    //选择为单品 则跳转到单品页面
    if (_selectedIndex == 0) {
        SSearchSimilarViewController *controller = [[SSearchSimilarViewController alloc]init];
        controller.returnblock = ^(NSString *token){
            [_searchSaveDictionary setObject:token forKey:@"searchContent"];
        };
        _isSetSearchText = YES;
        controller.searchText =[_searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    //其他公用页面
    SSearchResultViewController *controller = [[SSearchResultViewController alloc]initWithNibName:@"SSearchResultViewController" bundle:nil];
    _isSetSearchText = YES;
    controller.searchSaveDictionary = _searchSaveDictionary;
    controller.selectedIndex = _selectedIndex;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark 取消 跳回原view
- (IBAction)cancelPopButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 保存数据
- (void)saveUserSearchData{
    NSString *centerFilePath= [AppSetting getPersonalFilePath];
    NSString *filePath=[centerFilePath stringByAppendingPathComponent:@"searchCacheData"];
    [_searchSaveDictionary writeToFile:filePath atomically:YES];//写入
}

#pragma mark - Delegate and DataSource
#pragma mark - PDSearchViewDataSource
-(NSString *)accessTokenText{
    return _searchText;
}

#pragma mark PDSearchViewDelegate
- (void)tokenSearchView:(STokenSearchView *)searchView didReturnWithText:(NSString *)text{
    _searchText = text;
    [searchView.textField resignFirstResponder];
    [self jumpController];
    
}

- (void)tokenSearchView:(STokenSearchView *)searchView didRemoveTokenSting:(NSString *)text;
{
    _searchText = text;
}
#pragma mark SSearchTagCollectionViewDelegate
- (void)searchCollectionHeaderDeleteAction:(UIButton *)sender{
    NSString *valueString = [NSString stringWithFormat:@"search%d", (int)_selectedIndex];
    NSMutableArray *array = [_searchSaveDictionary valueForKey:valueString];
    if (!array || array.count == 0) {
        return;
    }
    NSString *string = @"";
    switch (_selectedIndex) {
        case 0:
            string = @"清楚所有单品搜索记录";
            break;
        case 1:
            string = @"清楚所有搭配搜索记录";
            break;
        case 2:
            string = @"清楚所有用户搜索记录";
            break;
        case 3:
            string = @"清楚所有品牌搜索记录";
            break;
        case 4:
            string = @"清楚所有话题搜索记录";
            break;
        default:
            break;
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认抹除搜索记录！" message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}

- (void)searchCollectionView:(UICollectionView *)collectionView didSelectedIndexPath:(NSIndexPath *)indexPath{
    NSString *string = @"";
    if (indexPath.section == 0) {
        if (_showTagCollectionView.userContentArray.count>0) {
            string = _showTagCollectionView.userContentArray[indexPath.row];
        }else{
            return;
        }
    }else{
        NSDictionary *dict = _showTagCollectionView.hotContentArray[indexPath.row];
        string = dict[@"keyword"];
    }
    //_searchBar.text = string;
    //最近搜索及热门搜索 关键词查询
    _searchText = string;
    [_tokenSearchView reloadData];
    [self jumpController];
}

#pragma mark SelectedSubContentViewDelegate
- (void)selectedSubContentViewSelectedIndex:(NSInteger)index{
    _selectedIndex = index;
    NSString *string = [NSString stringWithFormat:@"search%d", (int)_selectedIndex];
    NSArray *array = [_searchSaveDictionary valueForKey:string];
    _showTagCollectionView.userContentArray = array;
    [self requestSearchHotList];
}


#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *string = [NSString stringWithFormat:@"search%d", (int)_selectedIndex];
        NSMutableArray *array = [_searchSaveDictionary valueForKey:string];
        if (!array || array.count == 0) {
            return;
        }
        [array removeAllObjects];
        _showTagCollectionView.userContentArray = array;
        [_searchSaveDictionary setValue:array forKey:string];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_selectedIndex == 0) {
        return _searchContentArray.count;
    }else{
        return 1;
    }
    //    return _searchContentArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"SearchContentTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.textLabel.attributedText = _searchContentArray[indexPath.row];
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSAttributedString *attributeString = _searchContentArray[indexPath.row];
    //self.searchBar.text = attributeString.string;
    [self jumpController];
}

#pragma mark - ***备用方法 暂时弃用***
#pragma mark - UISearchBarDelegate
- (NSMutableAttributedString*)attrubuteStringForString:(NSString*)string index:(int)index{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributeString setAttributes:@{NSForegroundColorAttributeName: COLOR_C7} range:NSMakeRange(0, index)];
    return attributeString;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length > 0) {
        _showTagCollectionView.hidden = YES;
        _showSearchContentTableView.hidden = NO;
        _searchContentArray = @[[[NSAttributedString alloc]initWithString:searchText],
                                [self attrubuteStringForString:[NSString stringWithFormat:@"男 %@", searchText] index:1],
                                [self attrubuteStringForString:[NSString stringWithFormat:@"女 %@", searchText] index:1],
                                [self attrubuteStringForString:[NSString stringWithFormat:@"童装 %@", searchText] index:1]];
    }else{
        _showTagCollectionView.hidden = NO;
        _showSearchContentTableView.hidden = YES;
    }
    [_showSearchContentTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self jumpController];
}


@end
