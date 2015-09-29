//
//  SNoneProductDetailViewController.m
//  Wefafa
//
//  Created by Jiang on 15/9/7.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SNoneProductDetailViewController.h"
#import "MBGoodsDetailsShowPictureView.h"

#import "SUtilityTool.h"
#import "HttpRequest.h"
#import "Toast.h"
#import "SDataCache.h"
#import "WeFaFaGet.h"
#import "SSearchCollocationViewController.h"
#import "SSearchSimilarViewController.h"
#import "BrandDetailViewController.h"
#import "ShoppIngBagShowButton.h"
#import "MyShoppingTrollyViewController.h"

/**
    SNoneProductDetail
 */
@interface SNoneProductDetail : NSObject
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *product_img;
@property (nonatomic, strong) NSString *product_code;
@property (nonatomic, strong) NSString *cate_id;
@property (nonatomic, strong) NSString *cate_value;
@property (nonatomic, strong) NSString *color_code;
@property (nonatomic, strong) NSString *color_value;
@property (nonatomic, strong) NSString *brand_code;
@property (nonatomic, strong) NSString *brand_value;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *is_delete;
@property (nonatomic, strong) NSString *product_total;
@property (nonatomic, strong) NSString *collocation_total;

+ (instancetype)noneProductDetailWithDict:(NSDictionary *)dict;
@end

@implementation SNoneProductDetail

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)noneProductDetailWithDict:(NSDictionary *)dict
{
    return [[SNoneProductDetail alloc] initWithDict:dict];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"]) {
        self.idStr=value;
    }
}

@end


/**
    SNoneProductDetailCell
 */
/*
@interface SNoneProductDetailCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *numLb;
@end

@implementation SNoneProductDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    
}
@end
*/


/** 
    SNoneProductDetailViewController
 */
@interface SNoneProductDetailViewController ()
        <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
//@property (strong, nonatomic) MBGoodsDetailsShowPictureView *showPlayerView;
@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UILabel *nameLb;

@property (strong, nonatomic) SNoneProductDetail *model;

@property (nonatomic, strong) NSMutableDictionary *searchSaveDictionary;
@end
// MBGoodsDetailsColorModel
@implementation SNoneProductDetailViewController

/*
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavbar];
//    self.navigationController.navigationBarHidden = YES;
    [self initSubViews];
    [self requestData];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
    _shoppingBagButton = [[ShoppIngBagShowButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    [_shoppingBagButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_shoppingBagButton setImage:[UIImage imageNamed:@"Unico/cart"] forState:UIControlStateNormal];
    [_shoppingBagButton addTarget:self action:@selector(onCart) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:_shoppingBagButton];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem1];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self requestCarCount];
}

- (void)onCart{
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *vc1=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}

- (void)requestCarCount{
    if(!sns.ldap_uid){
        return;
    }
    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
        NSInteger total = [dict[@"total"] integerValue];
        if (total==0) {
            return;
        }
        int count = [dict[@"results"][0][@"count"] intValue];
        if (count!=0) {
            self.shoppingBagButton.titleLabel.hidden=NO;
            [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]]
                                    forState:UIControlStateNormal];
        }
        else
        {
            self.shoppingBagButton.titleLabel.hidden=YES;
            [self.shoppingBagButton setTitle:@"" forState:UIControlStateNormal];
        }
        
    } failed:^(NSError *error) {
        
    }];
}

- (void)setModel:(SNoneProductDetail *)model
{
    _model = model;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.product_img]
                  placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    _nameLb.text = [NSString stringWithFormat:@"%@%@", model.brand_value, model.cate_value];
    
    [_myTableView reloadData];
}

- (void)setupNavbar{
    [super setupNavbar];
    self.navigationItem.titleView = nil;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc]
                              initWithImage:[UIImage imageNamed:@"Unico/icon_back"]
                              style:UIBarButtonItemStylePlain target:self
                              action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1];//Unico/icon_back
}

- (void)onBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage imageNamed:@"Unico/common_navi_transparentblack.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    if (_isHide) {
        self.navigationController.navigationBarHidden = YES;
    } else {
        self.navigationController.navigationBarHidden = NO;
    }
}

- (void)initSubViews
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)
                                                          style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 50.f;
    tableView.tableHeaderView = [self headView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (_isHide) {
        tableView.frame=CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44-160*(UI_SCREEN_WIDTH/750.0));
        tableView.tableFooterView = [UIView new];
    } else {
        tableView.tableFooterView = [self footView];
    }
    [self.view addSubview:tableView];
    self.myTableView = tableView;
}

- (UIView *)headView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH+50.f)];
    headView.backgroundColor = COLOR_C3;
    //
    UIImageView *showPlatyerView =
    [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH)];
    [headView addSubview:showPlatyerView];
    showPlatyerView.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
    showPlatyerView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView = showPlatyerView;
    //
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH, 50)];
    [headView addSubview:titleView];
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(10, 18, 3, 50-18*2);
    lineLayer.backgroundColor = COLOR_C1.CGColor;
    [titleView.layer addSublayer:lineLayer];

//    CALayer *bottomLine = [CALayer layer];
//    bottomLine.frame = CGRectMake(0, 50.f-0.5f, UI_SCREEN_WIDTH, 0.5f);
//    bottomLine.backgroundColor = COLOR_C9.CGColor;
//    [headView.layer addSublayer:bottomLine];
    
    UILabel *titLb = [[UILabel alloc] initWithFrame:CGRectMake(20+3, 0, 200, 50)];
    titLb.text = @"";
    titLb.font = FONT_t5;
    titLb.textColor = COLOR_C2;
    [titleView addSubview:titLb];
    [titleView.layer addSublayer:[self addBottomLine]];
    self.nameLb = titLb;
    
    return headView;
}

- (UIView *)footView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 100)];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, UI_SCREEN_WIDTH-20, 44.f)];
    closeBtn.backgroundColor = COLOR_C2;
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = FONT_T1;
    closeBtn.layer.cornerRadius = 3.f;
    [closeBtn addTarget:self action:@selector(closeBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:closeBtn];
    
    return footView;
}

#pragma mark - close btn action methods
- (void)closeBtnClicked:(UIButton *)sender
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData
{
//    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
    

    NSDictionary *params = @{
                             @"m":@"Product",
                             @"a":@"getUserProductDetailsById",
                             @"pid":[Utils getSNSString:self.productID],
//                             @"token":userToken
                             };
    [[SDataCache sharedInstance] quickPost:nil
                                parameters:params
                                   success:^(AFHTTPRequestOperation *operation, id object)
     {
         if ([object isKindOfClass:[NSDictionary class]]) {
             if ([object[@"status"] integerValue] == 1) {
                 self.model = [SNoneProductDetail noneProductDetailWithDict:object[@"data"]];
             } else {
                 // TODO
                 [Toast makeToast:@"获取数据错误"];
             }
         }
     }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [Toast makeToast:error.userInfo[@"info"]];
     }];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:cellId];
    cell.textLabel.font = FONT_t4;
    cell.textLabel.textColor = COLOR_C2;
    [cell.contentView.layer addSublayer:[self addBottomLine]];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"查看相似单品";
        NSString *tempStr = [NSString stringWithFormat:@"%@", self.model.product_total];
        [cell.contentView addSubview:[self addLbWithText:tempStr]];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"查看相关搭配";
        NSString *tempStr = [NSString stringWithFormat:@"%@", self.model.collocation_total];
        [cell.contentView addSubview:[self addLbWithText:tempStr]];
    }
    
    cell.textLabel.font = FONT_t4;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CALayer *)addBottomLine
{
    CALayer *bottomLine = [CALayer layer];
    bottomLine.frame = CGRectMake(0, 50.f-0.5f, UI_SCREEN_WIDTH, 0.5f);
    bottomLine.backgroundColor = COLOR_C9.CGColor;
    return bottomLine;
}

- (UILabel *)addLbWithText:(NSString *)text
{
    if ([text isEqualToString:@"(null)"]) {
        text = @"0";
    }
    
    CGFloat lbX = UI_SCREEN_WIDTH - 90;
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(lbX, 0, 60, 50)];
    lb.text = text;
    lb.textAlignment = NSTextAlignmentRight;
    lb.font = FONT_t5;
    lb.textColor = COLOR_C7;
    
    return lb;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        // 跳转到查询相似单品界面
        SSearchSimilarViewController *controller = [[SSearchSimilarViewController alloc]init];
        controller.returnblock = ^(NSString *token){
            [_searchSaveDictionary setObject:token forKey:@"searchContent"];
        };
        NSDictionary *tempDict = @{
                                   @"color":self.model.color_code,
                                   @"colorName":self.model.color_value,
                                   @"cid":self.model.cate_id,
                                   @"categoryName":self.model.cate_value,
                                   @"brand":self.model.brand_code,
                                   @"brandName":self.model.brand_value
                                   };
        controller.chooseDic = [NSMutableDictionary dictionaryWithDictionary:tempDict];
        [self.navigationController pushViewController:controller animated:YES];
        
    } else if (indexPath.section == 1) {
        
        /*NSString *info = [NSString stringWithFormat:@"您的账号登陆信息已失效，请重新登陆"];
        [RKDropdownAlert title:info];
        return ;*/
        
        // 跳转到查询相关搭配界面 pid
        SSearchCollocationViewController *searchCollVc = [[SSearchCollocationViewController alloc] init];
        searchCollVc.productId = self.productID;
        [self.navigationController pushViewController:searchCollVc animated:YES];
        
        return ;
        BrandDetailViewController *controller = [BrandDetailViewController new];
        controller.brandId = [NSString stringWithFormat:@"%@",self.model.brand_code];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 01.f;
}


#pragma mark -
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
