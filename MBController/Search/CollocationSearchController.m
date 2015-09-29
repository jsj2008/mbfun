//
//  CollocationSearchController.m
//  Wefafa
//
//  Created by su on 15/1/27.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "CollocationSearchController.h"
#import "NavigationTitleView.h"
#import "Utils.h"
#import "MBShoppingGuideInterface.h"
#import "SearchTableViewCell.h"
#import "CustomSegmentView.h"
#import "Toast.h"
#import "MJRefresh.h"
#import "SearchCollocationInfo.h"
#import "AppDelegate.h"
#import "BaseViewController.h"

#import "SearchProduct.h"

#import "HttpRequest.h"
#import "SUtilityTool.h"


@interface CollocationSearchController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,kSearchCollocationTableCellDelegate>{
    UITableView *_collocationTable;
    NSMutableArray *_dataArray;
    NSInteger currentPage;
    NSInteger sortType;
    NSInteger totalCount;
    
    UIButton *_cancelBtn;
    UISearchBar *_searchBar;
    
    UIView *searchBg;
    
    CGFloat preOffSet;
    
    CGFloat headerViewHeight;
    
    UIView * _unResultView;
}
@property (strong, nonatomic)UIView *headView;

@end

@implementation CollocationSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self configSubViews];
}

- (void)configSubViews
{
    CGRect rect = [UIApplication sharedApplication].keyWindow.bounds;
    
    CGFloat yPoint = 44;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        yPoint = 64;
    }
    
    headerViewHeight = yPoint + 80;
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, headerViewHeight)];
    [self.view addSubview:_headView];
    
    _headView.backgroundColor=TITLE_BG;
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"搜搭配";
    [self.headView addSubview:view];
    
    if ([self.naviTitle length] > 0) {
        view.lbTitle.text=self.naviTitle;
    }

    
    searchBg = [[UIView alloc] initWithFrame:CGRectMake(0, yPoint, rect.size.width, 80)];
    [searchBg setBackgroundColor:[UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1.0]];
    [searchBg setClipsToBounds:YES];
    [_headView addSubview:searchBg];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_cancelBtn setFrame:CGRectMake(searchBg.frame.size.width, 5, 50, 30)];
    [_cancelBtn addTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchUpInside];
    [searchBg addSubview:_cancelBtn];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 5, searchBg.frame.size.width-20, 30)];
//    [_searchBar setBarStyle:UIBarStyleBlackOpaque];
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
    
    yPoint += 40;
    
    __weak CollocationSearchController *weakSelf = self;
    
    CustomSegmentView *segment = [[CustomSegmentView alloc] initWithFrame:CGRectMake(0, 40, rect.size.width, 40)];
    [segment setBackgroundColor:[UIColor whiteColor]];
    [segment setItemsArr:[NSArray arrayWithObjects:@"最新",@"点赞数", nil]];
    [segment setSelectIndex:0];
    sortType = 0;
    [segment setActionBlock:^(UIButton *btn,NSInteger index){
        [weakSelf segmentDidClick:index];
    }];
    if (self.isCollocation) {
        [searchBg addSubview:segment];
        yPoint += segment.frame.size.height;

    }
    
    
    [Toast makeToastActivity:@"正在获取数据" hasMusk:YES];
    
    [weakSelf networkRequestSortWith:YES];
    
    _collocationTable = [[UITableView alloc] initWithFrame:CGRectMake(0, yPoint, UI_SCREEN_WIDTH, self.view.frame.size.height - yPoint)];
    [_collocationTable setDataSource:self];
    [_collocationTable setDelegate:self];
    [_collocationTable setSeparatorColor:[UIColor clearColor]];
    [_collocationTable setBackgroundView:nil];
    [_collocationTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_collocationTable];
    
    [self addHeader];
    [self addFooter];
    
}


- (void)addHeader
{
    __weak typeof(self) weakSelf = self;
    // 添加下拉刷新头部控件
    currentPage = 1;
    [_collocationTable addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:YES];
        [weakSelf networkRequestSortWith:YES];
        
//        // 模拟延迟加载数据，因此1秒后才调用）
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakSelf tableviewUpload];
//        });
    }];
}

- (void)addFooter
{
    __weak typeof(self) weakSelf = self;
    // 添加上拉刷新尾部控件
    [_collocationTable addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:YES];
        
        
        if ([weakSelf isNoMoreData]) {
                [weakSelf updateViewWithRequestSuccess:YES message:@"没有更多信息"];
        } else {
                [weakSelf networkRequestSortWith:NO];
        }
        
//        // 模拟延迟加载数据，因此1秒后才调用）
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakSelf tableviewUpload];
//        });
    }];
}

- (BOOL)isNoMoreData
{
    if (totalCount > _dataArray.count) {
        return NO;
    }
    return YES;
}

- (void)showRequestToast
{
    [Toast makeToastActivity:@"正在获取数据" hasMusk:YES];
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
//显示无数据界面
-(void)layoutNoneDataView
{
    CGFloat originY = self.navigationController.navigationBar.size.height;
    CGRect  noneDataRect = CGRectMake(0, originY, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-originY);
    if (self.isCollocation) {
        _unResultView  = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:noneDataRect WithImage:NONE_DATA_ITEM andImgSize:CGSizeMake(58, 50) andTipString:@"没找到您要的搭配" font:FONT_SIZE(18) textColor:[Utils HexColor:0x999999 Alpha:1.0] andInterval:10.0];
    }
   else
   {
       _unResultView  = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:noneDataRect WithImage:NONE_DATA_MAN andImgSize:CGSizeMake(38, 50) andTipString:@"没找到您要的单品" font:FONT_SIZE(18) textColor:[Utils HexColor:0x999999 Alpha:1.0] andInterval:10.0];
   
   }
    [self.view insertSubview:_unResultView belowSubview:self.navigationController.navigationBar];
    
    
}

-(void)backHome:(UIButton*)sender
{
    if (self.parentViewController.childViewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)segmentDidClick:(NSInteger)segmentIndex
{
    [Toast makeToastActivity:@"正在获取数据" hasMusk:YES];
    sortType = segmentIndex;
    [_dataArray removeAllObjects];
    [_collocationTable reloadData];
    currentPage = 1;
    __weak CollocationSearchController *weakSelf = self;
    switch (segmentIndex) {
        case 0:{
                [weakSelf networkRequestSortWith:YES];
        }
            break;
        case 1:{
                [weakSelf networkRequestSortWith:YES];
        }
            break;
            
        default:
            break;
    }
}

-(void)downloadImage:(UIUrlImageView* )imageView url:(NSString *)url
{
    if (imageView==nil) return;
    NSString *defaultImg=DEFAULT_LOADING_MEDIUM;
    if (!url || [url isEqual:[NSNull null]]) {
        [imageView setImage:[UIImage imageNamed:defaultImg]];
    }else {
        [imageView downloadImageUrl:[CommMBBusiness changeStringWithurlString:url size:SNS_IMAGE_ORIGINAL] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:defaultImg];
    }
    
}
- (void)networkRequestSortWith:(BOOL)isPull
{
    
    __weak CollocationSearchController *weakSelf = self;
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    if (_dataArray.count == 0 || isPull) {
        currentPage = 1;
        [_dataArray removeAllObjects];
    }else{
        if (_dataArray.count >= totalCount) {
            return;
        }
    }
    NSString* methodName;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];

    if (!_isCollocation) {
        methodName = @" ProductClsCommonSearchFilter";
    }
    else{
        
    NSDictionary *subDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:(int)sortType + 1] forKey:@"sortField"];
    [dict setObject:subDict forKey:@"sortInfo"];
        
    methodName = @"CollocationSearchFilter";
    }
    
    if (self.searchKey && ![self.searchKey isEqualToString:@""]) {
        [dict setObject:self.searchKey forKey:@"keyWord"];
    }
    
    [dict setObject:[NSNumber numberWithInt:(int)currentPage] forKey:@"pageIndex"];
    [dict setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    //单品请求
    if (!_isCollocation) {
        [HttpRequest productPostRequestPath:nil methodName:methodName params:dict success:^(NSDictionary *dict) {
            [self updateDataSuccessAfterRequest:dict];
            
        } failed:^(NSError *error) {
            NSLog(@"单品请求出错：%@",error);
            [weakSelf updateViewWithRequestSuccess:NO message:@""];

        }];
    }
    //搭配请求
    else
    {
        [HttpRequest collocationPostRequestPath:nil methodName:methodName params:dict success:^(NSDictionary *dict) {
            [weakSelf updateDataSuccessAfterRequest:dict];
  
        } failed:^(NSError *error) {
            NSLog(@"单品请求出错：%@",error);
            [weakSelf updateViewWithRequestSuccess:NO message:@""];

        }];
    
    }
    
    

}


-(void)updateDataSuccessAfterRequest:(NSDictionary* )recievedDict
{
    __weak CollocationSearchController *weakSelf = self;
    NSString *requestMsg = nil;
    if ([recievedDict objectForKey:@"results"]) {
        totalCount = [[recievedDict objectForKey:@"total"] integerValue];
        NSArray *resultArr = [recievedDict objectForKey:@"results"];
        
        if (resultArr.count > 0) {
            currentPage ++;
            if (_isCollocation) {
                for(NSDictionary *dict in resultArr){
                    if ([dict objectForKey:@"collocationInfo"]) {
                        SearchCollocationInfo *infoModel = [[SearchCollocationInfo alloc] initWithObject:[dict objectForKey:@"collocationInfo"]];
                        infoModel.resultDict =dict;
                        infoModel.headPortrait = [[dict objectForKey:@"userPublicEntity"] objectForKey:@"headPortrait"];
                        [_dataArray addObject:infoModel];
                        
                    }
                }
            } else {
                for(NSDictionary *dict in resultArr){
                    if ([dict objectForKey:@"clsInfo"]) {
                        SearchProduct *infoModel = [[SearchProduct alloc] initWithProductInfo:[dict objectForKey:@"clsInfo"]];
                        infoModel.resultDict =dict;
                        [_dataArray addObject:infoModel];
                    }
                }
            }
            
        } else {
            requestMsg = @"没有更多数据";
        }
    }else{
        requestMsg = @"没有更多数据";
    }
    [weakSelf updateViewWithRequestSuccess:YES message:requestMsg];
}


- (void)updateViewWithRequestSuccess:(BOOL)isSuccess message:(NSString *)message
{
    if (isSuccess) {
        [_collocationTable reloadData];
    }
    [_collocationTable footerEndRefreshing];
    [_collocationTable headerEndRefreshing];
    if ([_dataArray count]==0||!isSuccess) {
        [self layoutNoneDataView];
    }
    if (!message || [message isEqual:[NSNull null]] || [message isEqualToString:@""]) {
        [Toast hideToastActivity];
        return;
    }
    [Toast makeToast:message];
    [Toast hideToastActivity];

}
//- (void)layOutNoDataView
//{
//    if (!_unResultView) {
//        _unResultView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.view.frame.size.height)];
//        [_unResultView setBackgroundColor:[UIColor whiteColor]];
//        
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 58)/2, 100, 58, 50)];
//        if (self.isCollocation) {
//            [imgView setImage:[UIImage imageNamed:@"btn-clothes"]];
//
//        }
//        else
//        [imgView setImage:[UIImage imageNamed:@"btn-hanger"]];
//        [_unResultView addSubview:imgView];
//        
//        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 155, SCREEN_WIDTH, 20)];
//        [messageLabel setFont:[UIFont systemFontOfSize:14.0f]];
//        [messageLabel setTextAlignment:NSTextAlignmentCenter];
//        [messageLabel setTextColor:nil];
//        [messageLabel setText:@"没有内容"];
//        [_unResultView addSubview:messageLabel];
//        
//        [self.view addSubview:_unResultView];
//    }
//}

#pragma mark uisearchbar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect btnFrame = _cancelBtn.frame;
        btnFrame.origin.x = self.view.frame.size.width - 55;
        _cancelBtn.frame = btnFrame;
        
        CGRect aFrame = _searchBar.frame;
        aFrame.size.width = self.view.frame.size.width - 60;
        _searchBar.frame = aFrame;
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchKey = searchBar.text;
    [self segmentDidClick:sortType];
    [self cancelSearch:_cancelBtn withAnimation:YES];
    
}


#pragma mark uitableview datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = _dataArray.count / 2;
    num = (_dataArray.count % 2 ==0) ? num : num +1;
    return num;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collocationCell = @"collocationCell";
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collocationCell];
    if (cell == nil) {
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:collocationCell isCollocation:self.isCollocation];
        [cell setDelegate:self];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
   NSInteger index =  indexPath.row * 2;
    if ((index + 1) == _dataArray.count) {
        if (_isCollocation) {
            [cell updateCellContentWithLeftModel:[_dataArray objectAtIndex:index] rightModel:nil];
        }else {
            [cell updateProducttWithLeftModel:[_dataArray objectAtIndex:index] rightModel:nil];
        }
        
    }else{
        if (_dataArray.count >= indexPath.row * 2) {
            if (_isCollocation) {
                [cell updateCellContentWithLeftModel:[_dataArray objectAtIndex:index] rightModel:[_dataArray objectAtIndex:index + 1]];
            }else{
                [cell updateProducttWithLeftModel:[_dataArray objectAtIndex:index] rightModel:[_dataArray objectAtIndex:index + 1]];
            }
        }
    }
    return cell;
}

- (void)kSearchCollocationCellHeaderImageClick:(id)model
{

}

- (void)kSearchCollocationCellCollocationImageClick:(id)model
{
    if ([BaseViewController pushLoginViewController]){
        if (_isCollocation) {
                  } else {
            
            
            
            SearchProduct *aModel = (SearchProduct *)model;
            
            // 注意这里在创建单品标签时候使用到了。
            // product select tag
            if (_completeFunc) {
                // Fix：idNum才是productClsId
//                NSString *idStr = [NSString stringWithFormat:@"%ld",(long)aModel.idNum];
//                _completeFunc(idStr,aModel.name);
                return;
            }

        }
    }
}

- (void)moveUpFrame
{
    CGRect tagFrame = _headView.frame;
    tagFrame.origin.y = -headerViewHeight;
    _headView.frame = tagFrame;
    
    CGRect aFrame = _collocationTable.frame;
    aFrame.origin.y -= headerViewHeight;
    aFrame.size.height += headerViewHeight;
    _collocationTable.frame = aFrame;
}

- (void)moveDownFrame
{
    CGRect tagFrame = _headView.frame;
    tagFrame.origin.y = 0;
    _headView.frame = tagFrame;
    
    CGRect aFrame = _collocationTable.frame;
    aFrame.origin.y += headerViewHeight;
    aFrame.size.height -= headerViewHeight;
    _collocationTable.frame = aFrame;
}

- (void)beginScrollAnimation:(BOOL)isHidden
{
    if (isHidden) {
        if (_headView.frame.origin.y < 0) {
            return;
        }
        __weak CollocationSearchController *weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf moveUpFrame];
        }];
        
    } else {
        if (_headView.frame.origin.y >= 0) {
            return;
        }
        __weak CollocationSearchController *weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf moveDownFrame];
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentPostion = scrollView.contentOffset.y;
    
    if (currentPostion < 0) {
        [self beginScrollAnimation:NO];
    } else {
        if (_dataArray.count > 6) {
            NSInteger currentPostion = scrollView.contentOffset.y;
            if (currentPostion > 10) {

                if (currentPostion + 30 + _collocationTable.frame.size.height > scrollView.contentSize.height) {
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
