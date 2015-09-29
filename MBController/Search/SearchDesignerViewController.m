//
//  SearchZXSViewController.m
//  Wefafa
//
//  Created by su on 15/1/28.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SearchDesignerViewController.h"
#import "NavigationTitleView.h"
#import "Utils.h"
#import "MBShoppingGuideInterface.h"
#import "SearchDesignerCell.h"
#import "CustomSegmentView.h"
#import "Toast.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "DesignerModel.h"
#import "AppSetting.h"
#import "HttpRequest.h"

#import "MBMyStoreInfoModel.h"
#import "SUtilityTool.h"
@interface SearchDesignerViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    UITableView *_sourceTable;
    UIButton *_cancelBtn;
    UISearchBar *_searchBar;
    NSInteger sortType;
    
    NSInteger currentPage;
    NSInteger pageSize;
    
    NSMutableArray *dataArray;
    NSInteger totalCount;
    
    NSInteger attentionIndex;
    
    DesignerModel *currentModel;
    
    UIView *searchBg;
    CGFloat preOffSet;
    CGFloat headerViewHeight;
    UIView * _unResultView;
}
@property (strong, nonatomic)UIView *headView;
@end

@implementation SearchDesignerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.view setBackgroundColor:[UIColor orangeColor]];
    
//    CGRect rect = [UIApplication sharedApplication].keyWindow.bounds;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        //self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    CGFloat yPoint = 44;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        yPoint = 64;
    }
//    headerViewHeight = yPoint + 80;
//    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, headerViewHeight)];
//    //[self.view addSubview:_headView];
//    
//    _headView.backgroundColor=TITLE_BG;
//    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
//    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
//    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
//    view.lbTitle.text=@"搜造型师";
//    [self.headView addSubview:view];
    
    sortType = 0;
    currentPage = 1;
    pageSize = 10;
    
   
    
//    searchBg = [[UIView alloc] initWithFrame:CGRectMake(0, yPoint, rect.size.width, 80)];
//    [searchBg setBackgroundColor:[UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1.0]];
//    [searchBg setClipsToBounds:YES];
//    [self.headView addSubview:searchBg];
//    
//    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
//    [_cancelBtn setFrame:CGRectMake(searchBg.frame.size.width, 5, 50, 30)];
//    [_cancelBtn addTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchUpInside];
//    [searchBg addSubview:_cancelBtn];
//    
//    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 5, searchBg.frame.size.width-20, 30)];
////    [_searchBar setBarStyle:UIBarStyleBlackOpaque];
//    [_searchBar.layer setCornerRadius:10.0];
//    [_searchBar.layer setMasksToBounds:YES];
//    [_searchBar.layer setBorderWidth:0.5];
//    [_searchBar.layer setBorderColor:[UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1.0].CGColor];
//    if ([_searchBar respondsToSelector:@selector(barTintColor)]) {
//        [_searchBar setBarTintColor:[UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1.0]];
//    }else{
//        [_searchBar setTintColor:[UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1.0]];
//    }
//    [_searchBar setPlaceholder:@"请输入关键字"];
//    [_searchBar setSearchBarStyle:UISearchBarStyleProminent];
//    [_searchBar setDelegate:self];
//    [searchBg addSubview:_searchBar];
//    
//    yPoint += 40;
//    
    __weak SearchDesignerViewController *weakSelf = self;
//    CustomSegmentView *segment = [[CustomSegmentView alloc] initWithFrame:CGRectMake(0, 40, rect.size.width, 40)];
//    [segment setItemsArr:[NSArray arrayWithObjects:@"等级",@"粉丝", nil]];
//    [segment setSelectIndex:0];
//    [segment setBackgroundColor:[UIColor whiteColor]];
//    [segment setActionBlock:^(UIButton *btn,NSInteger index){
//        [weakSelf segmentDidClick:index];
//    }];
//    [searchBg addSubview:segment];
//    
//    yPoint += segment.frame.size.height;
    
    _sourceTable = [[UITableView alloc] initWithFrame:CGRectMake(0, yPoint, UI_SCREEN_WIDTH, self.view.frame.size.height - yPoint) style:UITableViewStylePlain];
//    _sourceTable.backgroundColor = [UIColor yellowColor];
    [_sourceTable setDelegate:self];
    [_sourceTable setDataSource:self];
    [_sourceTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_sourceTable setBackgroundView:nil];
    [self.view addSubview:_sourceTable];
    [self addFooter];
    [self addHeader];
    
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [Toast makeToastActivity:@"正在获取数据" hasMusk:YES];
        [weakSelf networkRequestIsPull:YES];
    
}

- (void)networkRequestIsPull:(BOOL)isPull
{
    if (isPull) {
        currentPage = 1;
        [dataArray removeAllObjects];
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:(sortType == 0) ? @"Gradle" : @"" forKey:@"sortField"];
    if (self.searchKey && ![self.searchKey isEqualToString:@""]) {
        [dict setObject:self.searchKey forKey:@"keyWord"];
    }
    [dict setObject:[NSNumber numberWithInteger:currentPage] forKey:@"pageIndex"];
    [dict setObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    if ([sns.ldap_uid length] > 0) {
        [dict setObject:sns.ldap_uid forKey:@"userId"];
    }
    
    
    [HttpRequest accountPostRequestPath:nil methodName:@"DesignerSearchFilter" params:dict success:^(NSDictionary *dict) {
        
        NSString *responseMess = nil;
        totalCount = [[dict objectForKey:@"total"] integerValue];
        NSArray *array = [dict objectForKey:@"results"];
        if (array.count > 0) {
            for(NSDictionary *tempDict in array){
                DesignerModel *model = [[DesignerModel alloc] initWithDesignerInfo:tempDict];
                [dataArray addObject:model];
            }
            currentPage ++;
        } else {
            responseMess = @"没有更多信息";
        }
        [self updateViewWithRequestSuccess:YES message:responseMess];

    } failed:^(NSError *error) {
        [self updateViewWithRequestSuccess:NO message:@""];

    }];
    


}

- (void)updateViewWithRequestSuccess:(BOOL)isSuccess message:(NSString *)message
{
    if (isSuccess) {
        [_sourceTable reloadData];
    }
    [_sourceTable footerEndRefreshing];
    [_sourceTable headerEndRefreshing];
    [Toast hideToastActivity];
    if (dataArray.count == 0||!isSuccess) {
        [self layoutNoneDataView];
    }
    if (!message || [message isEqual:[NSNull null]] || [message isEqualToString:@""]) {
        return;
    }
    [Toast makeToast:message];
    
}

//- (void)layOutNoDataView
//{
//    if (!_unResultView) {
//        _unResultView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.view.frame.size.height)];
//        [_unResultView setBackgroundColor:[UIColor whiteColor]];
//        
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 58)/2, 100, 58, 50)];
//        [imgView setImage:[UIImage imageNamed:@"btn-man"]];
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

//显示无数据界面
-(void)layoutNoneDataView
{
    CGFloat originY = self.navigationController.navigationBar.size.height;
    CGRect  noneDataRect = CGRectMake(0, originY, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-originY);
    if (!_unResultView) {
        _unResultView = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:noneDataRect WithImage:NONE_DATA_MAN andImgSize:CGSizeMake(38, 50) andTipString:@"没找到您要的造型师" font:FONT_SIZE(18) textColor:[Utils HexColor:0x999999 Alpha:1.0] andInterval:10.0];

    }
    [self.view insertSubview:_unResultView belowSubview:self.navigationController.navigationBar];
    
    
}
- (void)addHeader
{
    __weak typeof(self) weakSelf = self;
    // 添加下拉刷新头部控件
    [_sourceTable addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:YES];
        [weakSelf networkRequestIsPull:YES];
    }];
}

- (void)addFooter
{
    __weak typeof(self) weakSelf = self;
    // 添加上拉刷新尾部控件
    [_sourceTable addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:YES];

        if ([weakSelf isNoMoreData]) {
            [weakSelf updateViewWithRequestSuccess:YES message:@"没有更多信息"];
        } else {
            [weakSelf networkRequestIsPull:NO];
        }
        
    }];
}

- (BOOL)isNoMoreData
{
    if (totalCount > dataArray.count) {
        return NO;
    }
    return YES;
}

- (void)showRequestToast
{
    [Toast makeToastActivity:@"正在获取数据" hasMusk:YES];
}
//DesignerSearchFilter

-(void)backHome:(UIButton*)sender
{
    if (self.parentViewController.childViewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)cancelSearch:(UIButton *)btn
{
    [self cancelSearch:btn withAnimation:YES];
}

- (void)segmentDidClick:(NSInteger)segmentIndex
{
    [Toast makeToastActivity:@"正在获取数据" hasMusk:YES];
    sortType = segmentIndex;
    [dataArray removeAllObjects];
    [_sourceTable reloadData];
    currentPage = 1;
    self.searchKey = _searchBar.text;
    __weak SearchDesignerViewController *weakSelf = self;
    switch (segmentIndex) {
        case 0:{
                [weakSelf networkRequestIsPull:YES];
        }
            break;
        case 1:{
                [weakSelf networkRequestIsPull:YES];
        }
            break;
            
        default:
            break;
    }
}

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
    currentPage = 1;
    [self segmentDidClick:sortType];
    [self cancelSearch:_cancelBtn withAnimation:YES];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        self.searchKey = nil;
    }
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

#pragma mark uitableview datasource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *customCell = @"customCell";
    SearchDesignerCell *cell = [tableView dequeueReusableCellWithIdentifier:customCell];
    if (cell == nil) {
        cell = [[SearchDesignerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.favoriteBtn addTarget:self action:@selector(attentationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell.favoriteBtn setTag:100 + indexPath.row];
    if (dataArray.count > indexPath.row) {
        [cell updateDataWithDictionary:[dataArray objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self cancelSearch:_cancelBtn withAnimation:NO];
   
}

- (void)attentationBtnClick:(UIButton *)button
{
    attentionIndex = button.tag - 100;
    DesignerModel *model = [dataArray objectAtIndex:attentionIndex];
    currentModel = model;
    if (model.isConcerned) {
//        [self cancelAttentationDesigner];
    } else {
        [self attentionDesigner];
    }
}

- (void)attentionDesigner
{
    
    if ([sns.ldap_uid isEqualToString:currentModel.userId]) {
        return;
    }
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    if ([sns.ldap_uid length] > 0) {
        [paramDic setObject:sns.ldap_uid forKey:@"UserId"];
    }
    if ([currentModel.userId length] > 0) {
        [paramDic setObject:currentModel.userId forKey:@"ConcernId"];
    }
    [paramDic setObject:@"造型师" forKey:@"ConcernType"];
    
    
    
    [HttpRequest accountPostRequestPath:nil methodName:@"UserConcernCreate" params:paramDic success:^(NSDictionary *dict) {
        
        SearchDesignerCell *cell = (SearchDesignerCell *)[_sourceTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:attentionIndex inSection:0]];
        if (cell) {
            [cell.favoriteBtn setImage:[UIImage imageNamed:@"yiguanzhu"] forState:UIControlStateNormal];
        }
        currentModel.isConcerned = 1;
        
        NSString *centerFilePath= [AppSetting getPersonalFilePath];
        NSString *filePath=[centerFilePath stringByAppendingPathComponent:@"attendFriend"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshAttend" object:nil];
        NSMutableArray *listAttend=[NSMutableArray arrayWithContentsOfFile:filePath];
        
        NSString *useId=[NSString stringWithFormat:@"%@",currentModel.userId];
        
        [listAttend addObject:useId];
        
        
        NSArray *writeArray = [NSArray arrayWithArray:listAttend];
        [writeArray writeToFile:filePath atomically:YES];
        
//        [Toast makeToast:@"关注成功"];
        [Toast makeToastSuccess:@"关注成功!"];
    }
     
    failed:^(NSError *error) {
            
        [Toast makeToast:@"关注失败"];

    }];
    
    
    
    
}

- (void)cancelAttentationDesigner
{
   
    UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要取消关注吗?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertV.tag=1000;
    [alertV show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        if ([sns.ldap_uid length] > 0) {
            [paramDic setObject:sns.ldap_uid forKey:@"UserId"];
        }
        if ([currentModel.userId length] > 0) {
            [paramDic setObject:currentModel.userId forKey:@"ConcernIds"];
        }
        
        
        [HttpRequest accountPostRequestPath:nil methodName:@"UserConcernDelete" params:paramDic success:^(NSDictionary *dict) {
            
            if ([[dict allKeys]containsObject:@"isSuccess"]) {
                if ([dict[@"isSuccess"] integerValue] ==1)
                {
                    SearchDesignerCell *cell = (SearchDesignerCell *)[_sourceTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:attentionIndex inSection:0]];
                    if (cell) {
                        [cell.favoriteBtn setTitle:@"关注" forState:UIControlStateNormal];
                    }
                    currentModel.isConcerned = 0;
                    //                   [Toast makeToast:@"取消关注成功"];
                    [Toast makeToastSuccess:@"取消关注成功!"];
                }
            }
            else
            {
                [Toast hideToastActivity];
        
                NSString *messageStr=[NSString stringWithFormat:@"%@",dict[@"message"]];
                
                if (messageStr.length==0)
                {
                    [Utils alertMessage:@"失败"];
                }
                else
                {
                    [Utils alertMessage:dict[@"message"]];
                }
                
            }
            
        } failed:^(NSError *error) {
            [Toast hideToastActivity];
      
            [Toast makeToast:@"取消关注失败!" duration:1.5 position:@"center"];
        }];
        /*
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableString *returnMessage=[[NSMutableString alloc]init];
            
            BOOL sucess =
            [SHOPPING_GUIDE_ITF requestPostUrlName:@"UserConcernDelete" param:paramDic responseAll:nil responseMsg:returnMessage];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (sucess) {
                    SearchDesignerCell *cell = (SearchDesignerCell *)[_sourceTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:attentionIndex inSection:0]];
                    if (cell) {
                        [cell.favoriteBtn setTitle:@"关注" forState:UIControlStateNormal];
                    }
                    currentModel.isConcerned = 0;
//                   [Toast makeToast:@"取消关注成功"];
                    [Toast makeToastSuccess:@"取消关注成功!"];
                    
                } else {
                   [Toast makeToast:@"取消关注失败!"];
                }
            });
            
            
        });
        */
    }
}

- (void)moveUpFrame
{
    CGRect tagFrame = _headView.frame;
    tagFrame.origin.y = -headerViewHeight;
    _headView.frame = tagFrame;
    
    CGRect aFrame = _sourceTable.frame;
    aFrame.origin.y -= headerViewHeight;
    aFrame.size.height += headerViewHeight;
    _sourceTable.frame = aFrame;
}

- (void)moveDownFrame
{
    CGRect tagFrame = _headView.frame;
    tagFrame.origin.y = 0;
    _headView.frame = tagFrame;
    
    CGRect aFrame = _sourceTable.frame;
    aFrame.origin.y += headerViewHeight;
    aFrame.size.height -= headerViewHeight;
    _sourceTable.frame = aFrame;
}

- (void)beginScrollAnimation:(BOOL)isHidden
{
    if (isHidden) {
        if (_headView.frame.origin.y < 0) {
            return;
        }
        __weak SearchDesignerViewController *weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf moveUpFrame];
        }];
        
    } else {
        if (_headView.frame.origin.y >= 0) {
            return;
        }
        __weak SearchDesignerViewController *weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf moveDownFrame];
        }];
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSInteger currentPostion = scrollView.contentOffset.y;
//    if (currentPostion < 0) {
//        [self beginScrollAnimation:NO];
//    } else {
//        if (dataArray.count > 6) {
//            
//            if (currentPostion > 10) {
//                
//                if (currentPostion + 30 + _sourceTable.frame.size.height > scrollView.contentSize.height) {
//                    [self beginScrollAnimation:YES];
//                } else {
//                    if (currentPostion - preOffSet > 30) {
//                        preOffSet = currentPostion;
//                        [self beginScrollAnimation:YES];
//                    }
//                    else if (preOffSet - currentPostion > 30)
//                    {
//                        preOffSet = currentPostion;
//                        [self beginScrollAnimation:NO];
//                    }
//                }
//            }
//        }
//    }
//}

@end
