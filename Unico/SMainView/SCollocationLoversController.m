//
//  SCollocationLoversController.m
//  Wefafa
//
//  Created by su on 15/6/5.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SCollocationLoversController.h"
#import "SMineViewController.h"
#import "SDataCache.h"
#import "SUtilityTool.h"
#import "MJRefresh.h"
#import "Toast.h"
#import "WeFaFaGet.h"
#import "SMineDesignerTableView.h"
#import "MBOtherUserInfoModel.h"
@interface SCollocationLoversController ()<SMineDesignerTableViewDelegate>{
    NSInteger currentPage;
}
@property (strong, nonatomic) SMineDesignerTableView *attentionTableView;
@end

@implementation SCollocationLoversController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentPage = 0;
    __unsafe_unretained typeof(self) p = self;
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(64,0, 0, 0);
    
    _attentionTableView = [[SMineDesignerTableView alloc]initWithFrame:self.view.frame];
    _attentionTableView.contentInset=edgeInset;
    [_attentionTableView addFooterWithTarget:self action:@selector(requestListAddData)];
    _attentionTableView.tableViewDelegate = self;
    _attentionTableView.backgroundColor=COLOR_NORMAL;
    _attentionTableView.opration = ^(NSIndexPath *indexPath, NSArray *array){
        MBOtherUserInfoModel *model = array[indexPath.row];
        SMineViewController *vc = [[SMineViewController alloc]init];
        vc.person_id = model.userId;
        [p.navigationController pushViewController:vc animated:YES];
        //46cfdc07-80ed-4a30-b0ef-c9d39d76bd8c(lldb) po sns.ldap_uid99c23812-4814-466e-b9ad-054b1c2262ef
    };
    
    [self.view addSubview:_attentionTableView];
    
    
    [Toast makeToastActivity:@""];
    if (self.collocationId.length!=0) {
        [self requestCollocationLoversIsPull:YES];
    }else if(self.brandId.length != 0){
        [self requestBrandLoversIsPull:YES];
    }else{
        [self requestTopicUserListIsPull:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavbar];
}

- (void)setupNavbar {
    [super setupNavbar];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIView *tempView;
    CGRect navRect = self.navigationController.navigationBar.frame;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    
    UIButton *tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    [tempBtn setTitle:@"喜欢" forState:UIControlStateNormal];
    tempBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
    tempBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [tempView addSubview:tempBtn];
    
    self.navigationItem.titleView = tempView;
    
}

- (void)onBack:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showActivity
{
    [Toast makeToastActivity:@""];
}

- (void)requestTopicUserListIsPull:(BOOL)isPull{
    if (isPull) {
        currentPage = 0;
    }else{
        currentPage = (_attentionTableView.contentArray.count + 9)/ 10;
    }
    NSDictionary *params = @{@"a": @"getPartTopicUserList",
                             @"m": @"Topic",
                             @"tid": _topicId,
                             @"page": @(currentPage)};
    __weak typeof(self) weakSelf = self;
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id object) {
        [weakSelf updateTableViewWithData:object[@"data"] isPull:isPull];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Toast makeToast:kNoneInternetTitle];
        [_attentionTableView footerEndRefreshing];
    }];
}
-(void)requestListAddData{
    if (self.collocationId.length!=0) {
        [self requestCollocationLoversIsPull:NO];
    }else if(self.brandId.length != 0){
        [self requestBrandLoversIsPull:NO];
    }else{
        [self requestTopicUserListIsPull:NO];
    }
}
-(void)requestBrandLoversIsPull:(BOOL)isPull
{
    __weak typeof(self) weakSelf = self;
    
    [self performSelectorOnMainThread:@selector(showActivity) withObject:nil waitUntilDone:NO];
    if (isPull) {
        currentPage = 0;
    }else{
        currentPage = (_attentionTableView.contentArray.count + 9)/ 10;
    }
    [[SDataCache sharedInstance] getBrandLikeUserListWithBrandId:self.brandId page:currentPage complete:^(NSArray *data, NSError *error) {
        
        [weakSelf updateTableViewWithData:data isPull:isPull];
    }];
}
- (void)requestCollocationLoversIsPull:(BOOL)isPull
{
    __weak typeof(self) weakSelf = self;
    
    [self performSelectorOnMainThread:@selector(showActivity) withObject:nil waitUntilDone:NO];
    if (isPull) {
        currentPage = 0;
    }else{
        currentPage = (_attentionTableView.contentArray.count + 9)/ 10;
    }
    
    // 品牌
    //    - (void)getBrandLikeUserListWithBrandId:(NSString *)brandId
    //page:(NSInteger)page
    //complete:(SDataResponseFunc)complete
    
    [[SDataCache sharedInstance] getCollocationLikeUserListWithCollocationId:self.collocationId page:currentPage complete:^(NSArray *data, NSError *error) {
        /*
         "head_img" = "http://wx.qlogo.cn/mmopen/LbAiaPDAO95TFGIMmyRibmOdvHkicvOLVGuTzZ0qwuxNks7ODlruBYfzg4amsut7brL62jpDrXFGQeXKf5412jYPicqRQdwccicEz/0";
         "nick_name" = sprinna;
         "user_id" = "ee398f3b-b3e3-44e6-9b1f-9ef7b57dfad9";
         */
        [weakSelf updateTableViewWithData:data isPull:isPull];
    }];
}

- (void)updateTableViewWithData:(NSArray *)array isPull:(BOOL)isPull
{
    [Toast hideToastActivity];
    [_attentionTableView footerEndRefreshing];
    if(array.count==0)return;
    if (isPull) {
        [_attentionTableView.contentArray removeAllObjects];
    }
    
    
    NSMutableArray *mutableAry = [MBOtherUserInfoModel modelArrayWithDataArray:array WithType:NO];
    
    if (currentPage == 0) {
        _attentionTableView.contentArray=mutableAry;
    }else{
        [_attentionTableView.contentArray addObjectsFromArray:mutableAry];
        _attentionTableView.contentArray = _attentionTableView.contentArray;
    }
    
    if (array.count > 0) {
        currentPage ++;
    }
}

#pragma mark - scroll delegate
- (void)listViewWillBeginDraggingScroll:(UIScrollView *)scrollView{
    
}
- (void)listViewDidScroll:(UIScrollView *)scrollView{
    
}

#pragma mark - need reload data delegate
- (void)needRequestLoadData:(UITableView *)tableView{

}
@end
