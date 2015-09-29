//
//  SStarStoreViewController.m
//  Wefafa
//
//  Created by lizhaoxiang on 15/5/27.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SStarStoreViewController.h"
#import "SStarStoreTableViewCell.h"
#import "SCollocationDetailViewController.h"
#import "SUtilityTool.h"
#import "ShoppIngBagShowButton.h"
#import "HttpRequest.h"
#import "WeFaFaGet.h"
#import "SDataCache.h"
#import "MyShoppingTrollyViewController.h"

@interface SStarStoreViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _starStoreTable;
    CGFloat _cellNowHeight;
    NSMutableArray * _dataSource;
    NSMutableArray *bannerAry;
    UIView * noneDataView;
    
}

@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagButton;

@end
static NSString *cellIdentifier = @"SBrandShowListContentCellIdentifier";

@implementation SStarStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getData];
//    [self initTableViewSet];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavbar];
    [self requestCarCount];

}

//- (void)initTableViewSet{
//    _starStoreTable = [UITableView alloc]initWithFrame:CGRectMake(0, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>) style:<#(UITableViewStyle)#>
//}

- (void)setupNavbar {
    [super setupNavbar];
    
    _shoppingBagButton = [[ShoppIngBagShowButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    [_shoppingBagButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_shoppingBagButton setImage:[UIImage imageNamed:@"Unico/cart"] forState:UIControlStateNormal];
    [_shoppingBagButton addTarget:self action:@selector(onCart) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:_shoppingBagButton];
    self.navigationItem.rightBarButtonItems = @[rightItem1];
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
    CGRect navRect = self.navigationController.navigationBar.frame;
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    UILabel *tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"时尚达人" fontStyle:FONT_SIZE(18) color:COLOR_WHITE rect:CGRectMake(0, 0, 0, self.navigationController.navigationBar.height) isFitWidth:YES isAlignLeft:YES];
    [tempView setSize:CGSizeMake(tempLabel.width, self.navigationController.navigationBar.height)];
    [tempView addSubview:tempLabel];
    self.navigationItem.titleView = tempView;
}

-(void)onCart
{
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *vc1=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}

- (void)setupTableView {
    _starStoreTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.height+20, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.height-20)];
    _starStoreTable.backgroundColor = self.view.backgroundColor;
    _starStoreTable.delegate = self;
    _starStoreTable.dataSource = self;
    _starStoreTable.tableHeaderView = [self getHeaderView];
    _starStoreTable.tableFooterView = [[UIView alloc] init];
    _starStoreTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_starStoreTable];
    [_starStoreTable reloadData];
}

-(UIView*)getHeaderView{
    float heightFloat;
    float widthFloat;
    float tempFloat;
    UIView * tempUI;
    UIImageView *tempView;
    for (int i = 0; i<bannerAry.count; i++) {
       // heightFloat = (UI_SCREEN_WIDTH/375)*(258/2);
        heightFloat = [bannerAry[i][@"img_height"]floatValue];
        widthFloat = [bannerAry[i][@"img_width"]floatValue];
        tempFloat = UI_SCREEN_WIDTH/(widthFloat/2);
        heightFloat = tempFloat*(heightFloat/2);
        tempUI = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, heightFloat)];
        tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Unico/banner250"]];
        tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, tempUI.frame.size.height);
        [tempUI addSubview:tempView];
    }
    
    return  tempUI;
}
-(void) getData{
 
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    if (!bannerAry) {
        bannerAry = [[NSMutableArray alloc]init];
    }
    
    [SDATACACHE_INSTANCE getStarDesignerList:0 complete:^(NSArray *data) {
        NSMutableArray * tempArr = [data mutableCopy];
        if (tempArr.count == 0 || !tempArr ) {
            [self layoutNoneDataView];
        }
        else{
        for (NSDictionary * dict in tempArr) {
            if ([dict[@"show_type"] integerValue] == 0) {
                SStarStoreCellModel * model = [[SStarStoreCellModel alloc]initStarStoreModelWithDic:dict];
                [_dataSource addObject:model];
                NSLog(@"%@",model.collocationList);
            }else if([dict[@"show_type"] integerValue] == 6){
                [bannerAry addObject:dict];
            }
        }
            
            if ([_dataSource count]==0&&[bannerAry count]==0) {
                [self layoutNoneDataView];
            }
            else
                [self setupTableView];
        }
        
    }];
}

- (void)requestCarCount{
    if (!sns.isLogin) {
        return;
    }
    if(sns.ldap_uid.length==0)
        return;
    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
        
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
//        [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]] forState:UIControlStateNormal];
    } failed:^(NSError *error) {
        
    }];
}

//显示无数据界面
-(void)layoutNoneDataView
{
    CGFloat originY = self.navigationController.navigationBar.size.height+20;
    CGRect  noneDataRect = CGRectMake(0, originY, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-originY);
    if (!noneDataView) {
        noneDataView = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:noneDataRect WithImage:NONE_DATA_ORDER andImgSize:CGSizeMake(39, 50) andTipString:@"未发现明星店铺" font:FONT_SIZE(18) textColor:[Utils HexColor:0x999999 Alpha:1.0] andInterval:10.0];
        
    }
    [self.view insertSubview:noneDataView belowSubview:self.navigationController.navigationBar];
    
}


#pragma mark - UITableViewDatasourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _cellNowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SBrandCell";
    SStarStoreTableViewCell *cell = (SStarStoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SStarStoreTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
    }
    _cellNowHeight = cell.cellHeight;
    cell.parentVc = self;
    SStarStoreCellModel * model = (SStarStoreCellModel*)_dataSource[indexPath.row];
    [cell updateStarCellModel:model andIndex:(indexPath)];
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}


-(void)onBack:(id)sender{
    [self popAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
