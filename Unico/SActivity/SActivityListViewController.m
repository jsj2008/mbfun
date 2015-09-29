
//  SActivityListViewController.m
//  Wefafa
//
//  Created by unico_0 on 6/8/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SActivityListViewController.h"
#import "SActivityListTableViewCell.h"
#import "SActivityDiscountViewController.h"
#import "SActivityDiscountBrandViewController.h"
#import "HttpRequest.h"
#import "Toast.h"
#import "Utils.h"
#import "WeFaFaGet.h"
#import "SUtilityTool.h"
#import "SActivityListModel.h"
#import "SActivityReceiveViewController.h"
#import "MyShoppingTrollyViewController.h"
#import "ShoppIngBagShowButton.h"
#import "UIScrollView+MJRefresh.h"
#import "SMBNewActivityListModel.h"
#import "JSWebViewController.h"

@interface SActivityListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _pageIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (nonatomic, strong) NSMutableArray *contentModelArray;

@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagButton;

@end

static NSString *cellIdentifier = @"SActivityListTableViewCellIdentifier";
@implementation SActivityListViewController
-(void)viewWillDisappear:(BOOL)animated
{
    [Toast hideToastActivity];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavbar];
    
    _pageIndex = 0;
    [self initSubViews];
    [self requestData];
  
}
-(void)viewDidAppear:(BOOL)animated
{
      [self requestCarCount];
}
- (void)setupNavbar{
    [super setupNavbar];
    self.navigationItem.title = @"活动列表";
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;

    
    _shoppingBagButton = [[ShoppIngBagShowButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    [_shoppingBagButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_shoppingBagButton setImage:[UIImage imageNamed:@"Unico/cart"] forState:UIControlStateNormal];
    [_shoppingBagButton addTarget:self action:@selector(onCart) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_shoppingBagButton];
    self.navigationItem.rightBarButtonItems = @[rightItem];
}
-(void)onBack:(id)sender
{
    [self popAnimated:YES];
}

- (void)initSubViews{
    self.contentTableView.backgroundColor = COLOR_C4;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentTableView registerNib:[UINib nibWithNibName:@"SActivityListTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    self.contentTableView.tableFooterView = [UIView new];
    
    [self.contentTableView addFooterWithTarget:self action:@selector(requestAddData)];
    [self.contentTableView addHeaderWithTarget:self action:@selector(requestReloadData)];
}

- (void)requestData{
    [Toast makeToastActivity];
//    @"Use_Type": @"FAST_BUY"
//    NSDictionary *params = @{@"Use_Type": @"FAST_BUY",
//                             @"pageIndex": @(_pageIndex + 1),
//                             @"pageSize": @(10)};
//    [HttpRequest promotionPostRequestPath:nil methodName:@"PlatFormBasicInfoFilter" params:params success:^(NSDictionary *dict) {
//        [self.contentTableView headerEndRefreshing];
//        [self.contentTableView footerEndRefreshing];
//        [Toast hideToastActivity];
//        self.contentModelArray = [SActivityListModel modelArrayForDataArray:dict[@"results"]];
//    } failed:^(NSError *error) {
//        [self.contentTableView headerEndRefreshing];
//        [self.contentTableView footerEndRefreshing];
//        [Toast hideToastActivity];
//        [Toast makeToast:kNoneInternetTitle duration:2.0 position:@"center"];
//    }];
    NSDictionary *params = @{@"pageIndex": @(_pageIndex + 1),
                             @"pageSize": @(10)};
    [HttpRequest promotionGetRequestPath:nil methodName:@"getNormalActivtyList" params:params success:^(NSDictionary*dict)
    {
        [self.contentTableView headerEndRefreshing];
        [self.contentTableView footerEndRefreshing];
        [Toast hideToastActivity];
        self.contentModelArray = [SMBNewActivityListModel modelArrayForDataArray:dict[@"results"]];
    } failed:^(NSError *error) {
        [self.contentTableView headerEndRefreshing];
        [self.contentTableView footerEndRefreshing];
        [Toast hideToastActivity];
        [Toast makeToast:kNoneInternetTitle duration:2.0 position:@"center"];

    }];
    
    
    
    
    
}

- (void)requestCarCount{
    if(!sns.ldap_uid){
        return;
    }
    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
//        [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]] forState:UIControlStateNormal];
        NSInteger total = [dict[@"total"] integerValue];
        if (total==0) {
            return ;
        }
        int count = [dict[@"results"][0][@"count"] intValue];
        if (count!=0) {
              self.shoppingBagButton.titleLabel.hidden=NO;
            [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]] forState:UIControlStateNormal];
        }else
        {
            self.shoppingBagButton.titleLabel.hidden=YES;
                [self.shoppingBagButton setTitle:@"" forState:UIControlStateNormal];
        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)setContentModelArray:(NSMutableArray *)contentModelArray{
    if (_pageIndex == 0){
        if (contentModelArray.count <= 0) {
            [Toast makeToast:@"暂无活动开放！" duration:2.0 position:@"center"];
        }else{
            _pageIndex ++;
        }
        _contentModelArray = contentModelArray;
    }else{
        if (contentModelArray.count <= 0) {
            [Toast makeToast:@"没有更多活动！" duration:2.0 position:@"center"];
        }else{
            _pageIndex ++;
        }
        [_contentModelArray addObjectsFromArray:contentModelArray];
    }
    
    [self.contentTableView reloadData];
}

- (void)requestReloadData{
    _pageIndex = 0;
    [self requestData];
}

- (void)requestAddData{
    _pageIndex = (_contentModelArray.count + 9)/ 10;
    [self requestData];
}

- (void)onCart {
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *vc1=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}

#pragma mark - tableView delegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SActivityListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentModel = _contentModelArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 185 * (UI_SCREEN_WIDTH/ 320);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *controller = nil;

    SMBNewActivityListModel *model = _contentModelArray[indexPath.row];
    
    if (model.web_url.length!=0) {
        JSWebViewController *jswebvc=[[JSWebViewController alloc]initWithUrl:model.web_url];
        jswebvc.naviTitle=[NSString stringWithFormat:@"%@",model.name];
        
        [self.navigationController pushViewController:jswebvc animated:YES];
    }
    else
    {
        if ([model.type isEqualToString:@"1"]) {
            //      controller = [SActivityDiscountBrandViewController new];
            //折扣活动
            controller = [SActivityDiscountViewController new];
        }
        else
        {
            if (![BaseViewController pushLoginViewController]) {
                return;
            }//领取饭票
            SActivityReceiveViewController *controller = [[SActivityReceiveViewController alloc]init];
            controller.contentModel = model;
            [self.navigationController pushViewController:controller animated:YES];
        }
        [controller setValue:model forKey:@"contentModel"];
        [self.navigationController pushViewController:controller animated:YES];
  
    }

}

@end
