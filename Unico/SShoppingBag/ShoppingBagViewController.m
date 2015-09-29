//
//  ShoppingBagViewController.m
//  Wefafa
//
//  Created by Jiang on 5/23/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "ShoppingBagViewController.h"
#import "ShoppingBagContentModel.h"
#import "ShoppingContentTableViewCell.h"
#import "ShoppingContentTableHeaderView.h"
#import "HttpRequest.h"
#import "SUtilityTool.h"
#import "Utils.h"
#import "LoginViewController.h"
@interface ShoppingBagViewController () <UITableViewDataSource, UITableViewDelegate, ShoppingContentTableHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet UIButton *allSelectedButton;
@property (weak, nonatomic) IBOutlet UILabel *totalShowLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *isContainFreightLabel;
@property (weak, nonatomic) IBOutlet UIView *tabBarContentView;

@property (weak, nonatomic) IBOutlet UIButton *buyNowButton;
- (IBAction)buyNowButtonAction:(UIButton *)sender;

//---------------
@property (nonatomic, strong) ShoppingBagContentModel *contentModel;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, strong) NSMutableArray *titleNameArray;

@end

static NSString *cellIndetifier = @"ShoppingBagTableViewCellIndentifier";
static NSString *headerIndetifier = @"ShoppingBagTableViewHeaderIndentifier";
@implementation ShoppingBagViewController
{
    UIView * noneDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self initNavigationBar];
    [self setupNavbar];
    [self initSubViews];
    [self requestData];
}

- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIView *tempView;
    CGRect navRect = self.navigationController.navigationBar.frame;

    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    
    
    UIButton *tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    [tempBtn setTitle:@"购物袋" forState:UIControlStateNormal];
    tempBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
    tempBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [tempBtn addTarget:self action:@selector(bestSelect:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:tempBtn];
    // default40@2x.9
    
    
    self.navigationItem.titleView = tempView;
//    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTitleTap:)];
//    [self.navigationItem.titleView setUserInteractionEnabled:YES];
//    [self.navigationItem.titleView addGestureRecognizer:recognizer];
}


- (void)initNavigationBar{
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationController.title = @"购物袋";
}

- (void)initSubViews{
    self.buyNowButton.layer.masksToBounds = YES;
    self.buyNowButton.layer.cornerRadius = 3.0;
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    [self.contentTableView registerNib:[UINib nibWithNibName:@"ShoppingContentTableViewCell" bundle:nil] forCellReuseIdentifier:cellIndetifier];
    UIView *footerView = [[UIView alloc]init];
    self.contentTableView.tableFooterView = footerView;
    
    self.tabBarContentView.layer.masksToBounds = NO;
    self.tabBarContentView.layer.shadowOffset = CGSizeMake(0, -3);
    self.tabBarContentView.layer.shadowOpacity = 0.5;
    CGRect frame = self.tabBarContentView.bounds;
    frame.size.width = UI_SCREEN_WIDTH;
    self.tabBarContentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:frame].CGPath;
    self.tabBarContentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
}


- (void)requestData{
    if (!IS_STRING(sns.ldap_uid)) {
        LoginViewController *VC = [LoginViewController new];
        [self pushController:VC animated:YES];
        return;
    }
    
    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartFilter" params:@{@"userId": sns.ldap_uid} success:^(NSDictionary *dict) {
        self.contentArray = [ShoppingBagContentModel modelArrayWithDataArray:dict[@"results"]];
        if ([self.contentArray count]==0) {
            [self layoutNoneDataView];

        }
    } failed:^(NSError *error) {
        [self layoutNoneDataView];

        
    }];
}
//显示无数据界面
-(void)layoutNoneDataView
{
    CGFloat originY = self.navigationController.navigationBar.size.height;
    CGRect  noneDataRect = CGRectMake(0, originY, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-originY);
    if (!noneDataView) {
        noneDataView = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:noneDataRect WithImage:NONE_DATA_SHOPPING_BAG andImgSize:CGSizeMake(52, 52) andTipString:@"购物袋还是空的 去逛逛吧" font:FONT_SIZE(18) textColor:[Utils HexColor:0x999999 Alpha:1.0] andInterval:10.0];
    }
    
    [self.view insertSubview:noneDataView belowSubview:self.tabBarContentView];


}
- (IBAction)buyNowButtonAction:(UIButton *)sender {
    
}

#pragma mark - set get
- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    [self.contentTableView reloadData];
}


#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ShoppingBagContentModel *model = self.contentArray[section];
    return model.contentModelArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _contentArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShoppingContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier forIndexPath:indexPath];
    ShoppingBagContentModel *model = self.contentArray[indexPath.section];
    ShoppingBagListModel *listModel = model.contentModelArray[indexPath.row];
    cell.contentModel = listModel;
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ShoppingContentTableHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIndetifier];
    if (header == nil) {
        header = [[ShoppingContentTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50)];
        header.delegate = self;
    }
    ShoppingBagContentModel *model = self.contentArray[section];
    header.contentMdoel = model;;
    return header;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85.0;
}

#pragma mark - hader delegate

- (void)shoppingHeaderSelectedButton:(UIButton *)button model:(ShoppingBagContentModel *)model{
    model.isSelected = button.selected;
    [self.contentTableView reloadData];
}

@end
