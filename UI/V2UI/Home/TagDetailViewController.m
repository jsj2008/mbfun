//
//  TagDetailViewController.m
//  Wefafa
//
//  Created by su on 15/3/2.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "TagDetailViewController.h"
#import "NavigationTitleView.h"
#import "Utils.h"
#import "SearchTableViewCell.h"
#import "Toast.h"
#import "MBShoppingGuideInterface.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "BaseViewController.h"
@interface TagDetailViewController ()<UITableViewDataSource,UITableViewDelegate,kSearchCollocationTableCellDelegate>{
    NSMutableArray *dataArray;
    NSInteger currentPage;
    NSInteger pageSize;
    NSInteger totalCount;
}
@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UITableView *tagTable;
@end

@implementation TagDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGRect rect = [UIApplication sharedApplication].keyWindow.bounds;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 64)];
    [self.view addSubview:_headView];
    
    _headView.backgroundColor=TITLE_BG;
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
    if ([self.naviTitle length] > 0) {
        view.lbTitle.text = self.naviTitle;
    } else {
        view.lbTitle.text = @"标签";
    }
    [self.headView addSubview:view];
    
    CGFloat theHeight = 44;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        theHeight = 64;
    }
    
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    pageSize = 20;
    
    _tagTable = [[UITableView alloc] initWithFrame:CGRectMake(0, theHeight, rect.size.width, rect.size.height - theHeight) style:UITableViewStylePlain];
    [_tagTable setDelegate:self];
    [_tagTable setDataSource:self];
    [_tagTable setSeparatorColor:[UIColor clearColor]];
    [_tagTable setBackgroundView:nil];
    [_tagTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tagTable];
    
    [self addHeader];
    [self addFooter];
    
    [Toast makeToastActivity:@"正在获取数据" hasMusk:YES];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf networkRequestIsPull:YES];
    });
    
    // Do any additional setup after loading the view.
}

-(void)backHome:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addHeader
{
    __weak typeof(self) weakSelf = self;
    // 添加下拉刷新头部控件
    currentPage = 1;
    [_tagTable addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf networkRequestIsPull:YES];
        });
    }];
}

- (void)addFooter
{
    __weak typeof(self) weakSelf = self;
    // 添加上拉刷新尾部控件
    [_tagTable addFooterWithCallback:^{
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
    if (totalCount > dataArray.count) {
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
    if (!self.tagId || [_tagId isEqualToString:@""]) {
        return;
    }
    if (isPull) {
        currentPage = 1;
        [dataArray removeAllObjects];
    }
    NSString *method = @"CollocationSimilarFilter";
    if (self.isCustom) {
        method = @"CollocationSimilarByCustomTagFilter";
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:[NSNumber numberWithInteger:currentPage] forKey:@"pageIndex"];
    [dict setObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    [dict setObject:[NSNumber numberWithInteger:[self.tagId integerValue]] forKey:@"tagId"];
    NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableString *responseMessage = [[NSMutableString alloc] init];
    BOOL request = [[MBShoppingGuideInterface create] requestGetUrlName:method param:dict responseAll:responseDict responseMsg:responseMessage];
    if (request) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = nil;
            totalCount = [[responseDict objectForKey:@"total"] integerValue];
            NSArray *result = [responseDict objectForKey:@"results"];
            for(NSDictionary *dict in result){
                if ([dict objectForKey:@"collocationInfo"]) {
                    SearchCollocationInfo *infoModel = [[SearchCollocationInfo alloc] initWithObject:[dict objectForKey:@"collocationInfo"]];
                    infoModel.resultDict =dict;
                    infoModel.headPortrait = [[dict objectForKey:@"userPublicEntity"] objectForKey:@"headPortrait"];
                    [dataArray addObject:infoModel];
                    
                }
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
            [self updateViewWithRequestSuccess:NO message:@"获取信息失败"];
        });
    }
}

- (void)updateViewWithRequestSuccess:(BOOL)isSuccess message:(NSString *)message
{
    if (isSuccess) {
        [_tagTable reloadData];
    }
    [_tagTable footerEndRefreshing];
    [_tagTable headerEndRefreshing];
    [Toast hideToastActivity];
    if (!message || [message isEqual:[NSNull null]] || [message isEqualToString:@""]) {
        return;
    }
    [Toast makeToast:message];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = dataArray.count / 2;
    num = (dataArray.count % 2 ==0) ? num : num +1;
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tagCell = @"tagCell";
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tagCell];
    if (cell == nil) {
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tagCell isCollocation:YES];
        [cell setDelegate:self];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    NSInteger index =  indexPath.row * 2;
    if ((index + 1) == dataArray.count) {
        [cell updateCellContentWithLeftModel:[dataArray objectAtIndex:index] rightModel:nil];
    }else{
        if (dataArray.count >= indexPath.row * 2) {
            [cell updateCellContentWithLeftModel:[dataArray objectAtIndex:index] rightModel:[dataArray objectAtIndex:index + 1]];
        }
    }
    return cell;
}

- (void)kSearchCollocationCellHeaderImageClick:(id)model
{

}

- (void)kSearchCollocationCellCollocationImageClick:(id)model
{

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
