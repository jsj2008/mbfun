//
//  SearchViewController.m
//  Wefafa
//
//  Created by su on 15/1/27.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SearchViewController.h"
#import "NavigationTitleView.h"
#import "Utils.h"
#import "CollocationSearchController.h"
#import "SearchDesignerViewController.h"
#import "FoundTableViewCell.h"
#import "Toast.h"
#import "MBShoppingGuideInterface.h"
#import "MJRefresh.h"
#import "OtherPeopleViewController.h"
#import "AppDelegate.h"

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_searchTable;
    UISearchBar *_searchBar;
    UIButton *_cancelBtn;
    NSString *_inputStr;
    NSArray *_dataArray;
    NSMutableArray *sourceArray;
    CGFloat yPoint;
    
    UITableView *_foundTable;
    
    NSInteger currentPage;
    NSInteger pageSize;
    NSInteger totalCount;
    
    UIView *searchBg;
    CGFloat preOffSet;
    
    CGFloat headerViewHeight;
    
}
@property(nonatomic,strong)UIView *headView;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGRect rect = [UIApplication sharedApplication].keyWindow.bounds;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    CGFloat theHeight = 44;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        theHeight = 64;
    }
    headerViewHeight = theHeight + 40;
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, headerViewHeight)];
    [self.view addSubview:_headView];
    
    _headView.backgroundColor=TITLE_BG;
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text = @"搜索";
    [self.headView addSubview:view];
    
    searchBg = [[UIView alloc] initWithFrame:CGRectMake(0, theHeight, rect.size.width, 40)];
    [searchBg setBackgroundColor:[UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1.0]];
    [searchBg setClipsToBounds:YES];
    [self.headView addSubview:searchBg];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_cancelBtn setFrame:CGRectMake(searchBg.frame.size.width, 5, 50, 30)];
    [_cancelBtn addTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchUpInside];
    [searchBg addSubview:_cancelBtn];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 5, searchBg.frame.size.width-20, 30)];
    [_searchBar.layer setCornerRadius:10.0];
    [_searchBar.layer setMasksToBounds:YES];
    [_searchBar.layer setBorderWidth:1.0];
    [_searchBar.layer setBorderColor:[UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1.0].CGColor];
    if ([_searchBar respondsToSelector:@selector(barTintColor)]) {
        [_searchBar setBarTintColor:[UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1.0]];
    }else{
        [_searchBar setTintColor:[UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1.0]];
    }
    [_searchBar setPlaceholder:@"请输入关键字"];
    [_searchBar setSearchBarStyle:UISearchBarStyleProminent];
    [_searchBar setDelegate:self];
    [searchBg addSubview:_searchBar];
    
    yPoint = searchBg.frame.origin.y + searchBg.frame.size.height;
    
    _dataArray = [[NSArray alloc] initWithObjects:@"搭配",@"单品",@"造型师", nil];
    
    currentPage = 1;
    pageSize = 10;
    
    [Toast makeToastActivity:@"正在获取数据" hasMusk:YES];
    __weak SearchViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf networkRequestIsPull:YES];
    });
    
    
}

-(void)backHome:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelSearch:(UIButton *)btn
{
    [self cancelSearch:btn withAnimation:YES];
}

- (void)cancelSearch:(UIButton *)btn withAnimation:(BOOL)needAnimation
{
    if (needAnimation) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect btnFrame = btn.frame;
            btnFrame.origin.x = self.view.frame.size.width;
            btn.frame = btnFrame;
            
            CGRect aFrame = _searchBar.frame;
            aFrame.size.width = self.view.frame.size.width-20;
            _searchBar.frame = aFrame;
        }];
    } else {
        CGRect btnFrame = btn.frame;
        btnFrame.origin.x = self.view.frame.size.width;
        btn.frame = btnFrame;
        
        CGRect aFrame = _searchBar.frame;
        aFrame.size.width = self.view.frame.size.width-20;
        _searchBar.frame = aFrame;
    }
    
    if (_searchBar.isFirstResponder) {
        [_searchBar resignFirstResponder];
    }
    
    [_searchTable removeFromSuperview];
    _searchTable = nil;
}

- (void)configTableView
{
    _searchTable = [[UITableView alloc] initWithFrame:CGRectMake(0, yPoint, 320, self.view.frame.size.height - yPoint - 216)];
    [_searchTable setDataSource:self];
    [_searchTable setDelegate:self];
    [self.view addSubview:_searchTable];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!_foundTable) {
        _foundTable = [[UITableView alloc] initWithFrame:CGRectMake(0, yPoint, self.view.frame.size.width, self.view.frame.size.height - yPoint)];
        [_foundTable setDataSource:self];
        [_foundTable setDelegate:self];
        [_foundTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_foundTable setSeparatorColor:[UIColor whiteColor]];
        [_foundTable setShowsVerticalScrollIndicator:NO];
        [self addHeader];
        [self addFooter];
        [self.view addSubview:_foundTable];
    }
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) weakSelf = self;
    // 添加下拉刷新头部控件
    currentPage = 1;
    [_foundTable addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf networkRequestIsPull:YES];
        });
    }];
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) weakSelf = self;
    // 添加上拉刷新尾部控件
    [_foundTable addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:YES];
        
        if ([weakSelf isNoMoreData]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf updateViewWithRequestSuccess:YES message:@"没有更多信息"];
            });
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [weakSelf networkRequestIsPull:NO];
            });
        }
    }];
}

- (BOOL)isNoMoreData
{
    if (totalCount == 0) {
        return NO;
    }
    if (totalCount > sourceArray.count) {
        return NO;
    }
    return YES;
}

- (void)showRequestToast
{
    [Toast makeToastActivity:@"正在获取数据" hasMusk:YES];
}

- (void)networkRequestIsPull:(BOOL)isPull
{
    if (!sourceArray) {
        sourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (isPull) {
        currentPage = 1;
        [sourceArray removeAllObjects];
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:[NSNumber numberWithInt:currentPage] forKey:@"pageIndex"];
    [dict setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableString *responseMessage = [[NSMutableString alloc] init];
    BOOL request = [[MBShoppingGuideInterface create] requestGetUrlName:@"CollocationFound" param:dict responseAll:responseDict responseMsg:responseMessage];
    if (request) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = nil;
            totalCount = [[responseDict objectForKey:@"total"] integerValue];
            NSArray *result = [responseDict objectForKey:@"results"];
            for(NSDictionary *dict in result){
                FoundCellModel *model = [[FoundCellModel alloc] initWithFoundInfo:dict];
                [sourceArray addObject:model];
            }
            if (result.count <= 0) {
                message = @"没有更多信息";
            }else{
                currentPage ++;
            }
            [self updateViewWithRequestSuccess:YES message:message];
            
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateViewWithRequestSuccess:NO message:@""];
        });
    }
}

- (void)updateViewWithRequestSuccess:(BOOL)isSuccess message:(NSString *)message
{
    if (isSuccess) {
        [_foundTable reloadData];
    }
    [_foundTable footerEndRefreshing];
    [_foundTable headerEndRefreshing];
    [Toast hideToastActivity];
    if (!message || [message isEqual:[NSNull null]] || [message isEqualToString:@""]) {
        return;
    }
    [Toast makeToast:message];
    
}

#pragma mark uisearchbar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (!_searchTable) {
        [self configTableView];
    }
    [UIView animateWithDuration:0.5 animations:^{
        CGRect btnFrame = _cancelBtn.frame;
        btnFrame.origin.x = self.view.frame.size.width - 55;
        _cancelBtn.frame = btnFrame;
        
        CGRect aFrame = _searchBar.frame;
        aFrame.size.width = self.view.frame.size.width - 60;
        _searchBar.frame = aFrame;
    }];
    [_searchTable reloadData];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    _inputStr = [[searchBar.text stringByReplacingCharactersInRange:range withString:text] stringByReplacingOccurrencesOfString:@"\xE2\x80\x86" withString:@""];
    [_searchTable reloadData];
    return YES;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _inputStr = searchText;
    if ([searchText isEqualToString:@""]) {
        _inputStr = nil;
    }
    if (_searchTable) {
        [_searchTable reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    if (_searchTable) {
        CGRect aFrame = _searchTable.frame;
        if ((aFrame.origin.y + aFrame.size.height) < self.view.frame.size.height) {
            aFrame.size.height += 216;
        }
        _searchTable.frame = aFrame;
    }
}

#pragma mark uitableview datasource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_foundTable]) {
        return sourceArray.count;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_foundTable]) {
        return 350;
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_searchTable]) {
        static NSString *searchCell = @"searchCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCell];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCell];
        }
        NSString *cellStr = @"";
        if (indexPath.row <=2) {
            cellStr = [@"搜" stringByAppendingString:[_dataArray objectAtIndex:indexPath.row]];
        }
        _inputStr = [_inputStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if ([_inputStr length] > 0) {
            cellStr = [cellStr stringByAppendingString:[NSString stringWithFormat:@"\"%@\"",_inputStr]];
        }
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
        cell.textLabel.text = cellStr;
        return cell;
    }
    static NSString *foundCell = @"foundCell";
    FoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:foundCell];
    if (cell == nil) {
        cell = [[FoundTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:foundCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (sourceArray.count > indexPath.row) {
        [cell updateCellInfo:[sourceArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if ([tableView isEqual:_searchTable]) {
        [self cancelSearch:_cancelBtn withAnimation:NO];
        UIViewController *controller = nil;
        if (indexPath.row == 2) {
            SearchDesignerViewController *zxsController = [[SearchDesignerViewController alloc] init];
            zxsController.searchKey = _searchBar.text;
            controller = zxsController;
        } else {
            CollocationSearchController *collocation = [[CollocationSearchController alloc] init];
            if (indexPath.row == 1) {
                collocation.naviTitle = @"搜单品";
            } else {
                collocation.isCollocation = YES;
            }
            NSString *searchKey = _searchBar.text;
            collocation.searchKey = searchKey;
            controller = collocation;
        }
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        FoundCellModel *model = [sourceArray objectAtIndex:row];
        OtherPeopleViewController *otherPeop=[[OtherPeopleViewController alloc]initWithNibName:@"OtherPeopleViewController" bundle:nil];
            otherPeop.user_ID =model.userId;
        otherPeop.staffType=STAFF_TYPE_OPENID;
        [[AppDelegate rootViewController] pushViewController:otherPeop animated:YES];
    }
}

- (void)moveUpFrame
{
    CGRect tagFrame = _headView.frame;
    tagFrame.origin.y = -headerViewHeight;
    _headView.frame = tagFrame;
    
    CGRect aFrame = _foundTable.frame;
    aFrame.origin.y -= headerViewHeight;
    aFrame.size.height += headerViewHeight;
    _foundTable.frame = aFrame;
}

- (void)moveDownFrame
{
    CGRect tagFrame = _headView.frame;
    tagFrame.origin.y = 0;
    _headView.frame = tagFrame;
    
    CGRect aFrame = _foundTable.frame;
    aFrame.origin.y += headerViewHeight;
    aFrame.size.height -= headerViewHeight;
    _foundTable.frame = aFrame;
}

- (void)beginScrollAnimation:(BOOL)isHidden
{
    if (isHidden) {
        if (_headView.frame.origin.y < 0) {
            return;
        }
        __weak SearchViewController *weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf moveUpFrame];
        }];
        
    } else {
        if (_headView.frame.origin.y >= 0) {
            return;
        }
        __weak SearchViewController *weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf moveDownFrame];
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_searchTable]) {
        return;
    }
    CGFloat offSetY = scrollView.header.contentOffSetY;
    if (offSetY < 0) {
        [self beginScrollAnimation:NO];
    } else {
        if (_dataArray.count > 2) {
            int currentPostion = scrollView.contentOffset.y;
            if (currentPostion > 10) {
                
                if (currentPostion + 30 + _foundTable.frame.size.height > scrollView.contentSize.height) {
                    [self beginScrollAnimation:YES];
                } else {
                    if (currentPostion - preOffSet > 30) {
                        preOffSet = currentPostion;
                        [self beginScrollAnimation:YES];
                    }
                    else if (preOffSet - currentPostion > 30)
                    {
                        preOffSet = currentPostion;
                        [self beginScrollAnimation:NO];
                    }
                }
            }
        }
    }
}

@end
