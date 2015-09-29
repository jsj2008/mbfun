//
//  SDesignerViewController.m
//  Wefafa
//
//  Created by lizhaoxiang on 15/5/27.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SDesignerViewController.h"
#import "SUtilityTool.h"
#import "HttpRequest.h"
#import "DesignerModel.h"
#import "MJRefresh.h"
#import "SDataCache.h"
#import "SDesignerCell.h"
#import "Toast.h"
#import "WeFaFaGet.h"
#import "SBannerViewCell.h"
#import "MyShoppingTrollyViewController.h"
@interface SDesignerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger  currentPage;
    NSMutableArray * dataArray;
    UIView * _unResultView;
    
    UILabel *cartLabel;

}
@property (nonatomic) UIView *selectView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)CGFloat cellNowHeight;
@end

@implementation SDesignerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // TODO: 判断登陆状态，如果没有登录，显示登录界面。
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64)];
    _tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addFooterWithCallback:^{
        [weakSelf getDataIsPull:NO];
    }];
    
    [self.tableView addHeaderWithCallback:^{
        [weakSelf getDataIsPull:YES];
    }];
//    self.cellNowHeight = 100;
    [self getDataIsPull:YES];
    
    [self.tableView setBackgroundColor:COLOR_C4];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupNavbar];
    
    [self requestCarCount];
}

- (void)requestCarCount{
    if (!sns.ldap_uid)return;
    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
        
        NSInteger total = [dict[@"total"] integerValue];
        if (total==0) {
            return ;
        }
        int count = [dict[@"results"][0][@"count"] intValue];
        if (count!=0) {
            cartLabel.hidden=NO;
             [cartLabel setText:[NSString stringWithFormat:@"%@",dict[@"results"][0][@"count"]]];
        }
        else
        {
              cartLabel.hidden=YES;
        }
     

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
    
    self.title = @"设计师列表";
}

-(void)onBack:(id)sender{
    [self popAnimated:YES];
}

-(void)searchContent:(id)sender{
    NSLog(@"搜索");
}
-(void)onTitleTap:(id)sender{
    
}

-(void)onList:(id)sender{
    NSLog(@"列表");
    
}

-(void)onCart:(id)sender{
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    MyShoppingTrollyViewController *vc1=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
    [self.navigationController pushViewController:vc1 animated:YES];
}
-(void) getDataIsPull:(BOOL)isPull{
    if (!dataArray) {
        dataArray = [[NSMutableArray alloc]init];
    }
    
    if (isPull) {
        currentPage = 0;
    }
    __weak typeof(self) weakSelf = self;
    [SDATACACHE_INSTANCE getAllDesignerList:currentPage complete:^(NSArray *data, NSError *error) {
        
        if (error) {
            [weakSelf updateTableViewSuccess:NO];
            return ;
        }
        if (data.count > 0) {
            currentPage ++;
            if (isPull) {
                [dataArray removeAllObjects];
            }
            [dataArray addObjectsFromArray:data];
        }
        [weakSelf updateTableViewSuccess:YES];
    }];
}

- (void)updateTableViewSuccess:(BOOL)isSuccess
{
    [self.tableView footerEndRefreshing];
    [self.tableView headerEndRefreshing];
    if (isSuccess) {
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDatasourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SDesignerCell";
    static NSString *bannerIdentifier = @"bannerIdentifier";
    NSDictionary *dict;
    if (indexPath.row < dataArray.count) {
        dict = [dataArray objectAtIndex:indexPath.row];
    }
    if ([[dict objectForKey:@"show_type"] integerValue] == 1) {
        SBannerViewCell *cell = (SBannerViewCell *)[tableView dequeueReusableCellWithIdentifier:bannerIdentifier];
        if (!cell) {
            cell = [[SBannerViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:bannerIdentifier];
        }
        if (dict) {
            cell.cellData = dict;
            [cell updateCellUI];
        }
        //高度
        self.cellNowHeight = cell.cellHeight;
        return  cell;
    }else{
        SDesignerCell *cell = (SDesignerCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[SDesignerCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
        }
        cell.parentVC = self;
        if (dict) {
           [cell updateCellWithDict:dict];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    NSDictionary *tempDic = [dataArray objectAtIndex:indexPath.row];
    NSInteger showType = [tempDic[@"show_type"] integerValue];
    if (showType == 1) {
        SBannerViewCell *cell =  (SBannerViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        height = cell.cellHeight;
    }else{
        height = 185;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *value = [dataArray objectAtIndex:indexPath.row];
    if ([[value objectForKey:@"show_type"] integerValue] == 1) {
        [[SUtilityTool shared] jumpControllerWithContent:value target:self];
    }else{
        SMineViewController * designerInforPage = [[SMineViewController alloc]init];
        NSString * temId = [value objectForKey:@"user_id"];
        if (temId) {
            designerInforPage.person_id = temId;
            [self.navigationController pushViewController:designerInforPage animated:YES];
            
        }
    }
    
}

@end
