//
//  SActivityReceiveViewController.m
//  Wefafa
//
//  Created by unico_0 on 6/9/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SActivityReceiveViewController.h"
#import "SActivityDiscountHeaderView.h"
#import "SActivityReceiveTableViewCell.h"
#import "MyShoppingTrollyViewController.h"
#import "ShoppIngBagShowButton.h"
#import "SActivityReceiveModel.h"
#import "SActivityListModel.h"
#import "HttpRequest.h"
#import "WeFaFaGet.h"
#import "Toast.h"
#import "Utils.h"
#import "SMBNewActivityListModel.h"
#import "SDataCache.h"

@interface SActivityReceiveViewController ()<UITableViewDataSource, UITableViewDelegate, SActivityReceiveTableViewCellDelegate, SActivityDiscountHeaderViewDelegate>
{
    BOOL _isEndActivity;
}

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (nonatomic, strong) NSArray *contentModelArray;
@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagButton;

@end

static NSString *cellIdentifier = @"SActivityReceiveTableViewCellIdentifier";
@implementation SActivityReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavbar];
    
    _isEndActivity = NO;
    [self initSubViews];

    [self requestData];

    
    [self requestCarCount];
}

- (void)setupNavbar{
    self.navigationItem.title = @"领取范票";
    
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
    
    [super setupNavbar];
}
-(void)onBack:(id)sender
{
    [self popAnimated:YES];
}

- (void)initSubViews{
    [self.contentTableView registerNib:[UINib nibWithNibName:@"SActivityReceiveTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    self.contentTableView.tableFooterView = [UIView new];
    self.contentTableView.tableHeaderView = [SActivityDiscountHeaderView new];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (_contentModel) {
        [self initHeaderView];
    }
}

- (void)initHeaderView{
    SActivityDiscountHeaderView *view = [SActivityDiscountHeaderView new];
    view.delegate = self;
    view.contentModel = _contentModel;
    view.receiveButton.hidden = YES;
    self.contentTableView.tableHeaderView = view;
    [self.contentTableView reloadData];
}

- (void)requestData{

    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";

    NSDictionary *params=nil;
    if (!_contentModel) {
        
        params = @{@"token":userToken,
                   @"aid":_activityId,
                   @"page":@1,
                   @"num":@20};
    }
    else
    {
        params = @{@"token":userToken,
                   @"aid":_contentModel.idStr,
                   @"page":@1,
                   @"num":@20};
    }
    
    [HttpRequest promotionPostRequestPath:nil methodName:@"getVouchersActivtyList" params:params success:^(NSDictionary *dict) {

        if ([dict[@"results"] count]>0) {
            _contentModel = [[SMBNewActivityListModel alloc]initWithDictionary:dict[@"results"][0]];
            self.contentModelArray = [SActivityVouchersListModel modelArrayForDataArray:dict[@"results"][0][@"vouchersList"]];
        }

    } failed:^(NSError *error) {
        [Toast makeToast:kNoneInternetTitle duration:2.0 position:@"center"];
    }];
}


- (void)requestCarCount{
    if(!sns.ldap_uid){
        return;
    }
    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId": sns.ldap_uid? sns.ldap_uid: @""} success:^(NSDictionary *dict) {
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

-(void)onCart
{
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *vc1=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}

- (void)setContentModelArray:(NSArray *)contentModelArray{

    if (self.activityId.length>0) {
        
        [self initHeaderView];
    }
    _contentModelArray = contentModelArray;
    
    // //这是干啥的 判断活动是否结束
    for (SActivityVouchersListModel *model in _contentModelArray) {
       
        model.isEndActivity = @(_isEndActivity);
    }
    
    [self.contentTableView reloadData];
}

#pragma mark - header delegate 活动结束
- (void)activityReceiveEndNavigation{
    for ( SActivityVouchersListModel *model in _contentModelArray) {
        model.isEndActivity=@YES;
        
    }
    _isEndActivity = YES;
    [self.contentTableView reloadData];
}

#pragma mark 领取饭票的接口
- (void)activityReceiveFanButton:(UIButton *)button model:(SActivityVouchersListModel *)model{
    if (![BaseViewController pushLoginViewController]) {
        return;
        
    }
    [Toast makeToastActivity:@"正在加载" hasMusk:YES];

    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
    NSDictionary *params=@{@"token":userToken,
                           @"aid":_contentModel.idStr,
                            @"vouchers":model.vouchers
                           };
    
    [HttpRequest vouchersPostRequestPath:nil methodName:@"receiveVouchersForCheck" params:params success:^(NSDictionary *dict) {
        [Toast hideToastActivity];
        NSString *isSuccess =[NSString stringWithFormat:@"%@",dict[@"isSuccess"]];
        
        if ([isSuccess isEqualToString:@"1"]||[isSuccess isEqualToString:@"true"]) {
            model.right_num = @(model.right_num.intValue + 1);
            model.part_num = @(model.part_num.intValue + 1);//用户领的张数
            model.isGet = @NO;
            [self.contentTableView reloadData];
            [RKDropdownAlert title:@"范票领取成功！"];
        }else{
            [Toast makeToast:dict[@"message"] mask:YES];
        }
    } failed:^(NSError *error) {
        [Toast hideToastActivity];
    }];
}



#pragma mark - tableView delegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SActivityReceiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentModel = _contentModelArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95 + ((UI_SCREEN_WIDTH - 320)/ 500);
}

@end
