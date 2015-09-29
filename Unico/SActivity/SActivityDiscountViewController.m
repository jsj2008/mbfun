//
//  SActivityDiscountViewController.m
//  Wefafa
//
//  Created by unico_0 on 6/8/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SActivityDiscountViewController.h"
#import "SActivityDiscountHeaderView.h"
#import "MBAddShoppingViewController.h"
#import "SActivityDiscountTableViewCell.h"
#import "MBCollocationInfoModel.h"
#import "SActivityListModel.h"
#import "HttpRequest.h"
#import "SUtilityTool.h"
#import "Toast.h"
#import "WeFaFaGet.h"
#import "ShoppIngBagShowButton.h"
#import "SActivityReceiveViewController.h"
#import "SCollocationDetailViewController.h"
#import "MBGoodsDetailsModel.h"
#import "FilterBrandCategoryModel.h"
#import "SProductDetailViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "MyShoppingTrollyViewController.h"
//#import "SActivityPromPlatModel.h"

#import "SCollocationDetailNoneShopController.h"
#import "SMBNewActivityListModel.h"
#import "SActivityReceiveModel.h"


@interface SActivityDiscountViewController () <UITableViewDelegate, UITableViewDataSource, SActivityDiscountTableViewCellDelegate, SActivityDiscountHeaderViewDelegate>
{
    NSInteger _pageIndex;
    BOOL _isActivityEnd;
    SActivityDiscountHeaderView *discountHeadview;
}

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

//---------
@property (nonatomic, strong) NSMutableArray *contentModelArray;
@property (nonatomic, strong) NSArray *promPlatModelArray;
@property (nonatomic, assign) ActivityDetailType activityDetailType;
@property (nonatomic, strong) SActivityPromPlatModel *promPlatModel;
@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagButton;

@end

static NSString *cellIdentifier = @"SActivityDiscountTableViewCellIdentifier";
@implementation SActivityDiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavbar];
    
    _isActivityEnd = NO;
    _pageIndex = 1;
    [self initSubViews];
    [self requestData];

}
-(void)viewDidAppear:(BOOL)animated
{
        [self requestCarCount];
}
- (void)setupNavbar{
      [super setupNavbar];
    self.navigationItem.title = @"折扣活动";
    
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

-(void)onCart
{
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *vc1=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}

- (void)initSubViews{
    [self.contentTableView registerNib:[UINib nibWithNibName:@"SActivityDiscountTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    self.contentTableView.tableFooterView = [UIView new];
    self.contentTableView.backgroundColor = COLOR_C4;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.contentTableView addFooterWithTarget:self action:@selector(requestAddData)];
    [self.contentTableView addHeaderWithTarget:self action:@selector(requestReloadData)];
    
    if (_contentModel) {
        [self initHeaderView];
    }
}

- (void)initHeaderView{
    self.navigationItem.title = _contentModel.name;
    discountHeadview = [SActivityDiscountHeaderView new];
    discountHeadview.delegate = self;
    discountHeadview.contentModel = _contentModel;
    self.contentTableView.tableHeaderView = discountHeadview;
    [self.contentTableView reloadData];
}

- (void)requestData{
//    if (_contentModel) {
        [self requestDataForModel];
//    }else{
//        [self requestDataForActivityID];
//    }
}

- (void)requestDataForModel{
    //    NSArray *array = @[_contentModel.aID];
    
//    接口名称：a=getProductActivtyList m=Promotion
//    参数：aid  page＝1 num＝40
    NSDictionary *params=nil;
    if (!_contentModel) {
        if (!_activityID) return;
        params = @{@"aid":_activityID,
                   @"page":@(_pageIndex ),
                   @"num":@40};
    }
    else
    {
        params = @{@"aid":_contentModel.idStr,
                   @"page":@(_pageIndex),
                   @"num":@40};
    }
    
//    NSDictionary *params = @{@"aid":_contentModel.idStr,
//                             @"page":@(_pageIndex ),
//                             @"num":@40};
    
    [HttpRequest promotionPostRequestPath:nil methodName:@"getProductActivtyList" params:params success:^(NSDictionary *dict) {
        NSString * isSuccess=[NSString stringWithFormat:@"%@",dict[@"isSuccess"]];
        if([isSuccess isEqualToString:@"0"])
        {
            _contentModel =[[SMBNewActivityListModel alloc]initWithDictionary:dict];
            NSString *message=[NSString stringWithFormat:@"%@",dict[@"message"]];
            
            [Toast makeToast:message ];
            
        }
        else
        {
            if ([dict[@"results"] count]>0) {
                _contentModel = [[SMBNewActivityListModel alloc]initWithDictionary:dict[@"results"][0]];
                //折扣
                //
                _promPlatModel = [[SActivityPromPlatModel alloc]initWithDictionary:dict[@"results"][0]];
                NSArray *tag_imgArray = [_contentModel.tag_img componentsSeparatedByString:@"|"];
                
                _promPlatModel.name =[NSString stringWithFormat:@"%@",[tag_imgArray firstObject]];
                
                self.contentModelArray = dict[@"results"][0][@"productList"];
                
            }
//            NSString *total=[NSString stringWithFormat:@"%@",dict[@"total"]];
//             NSArray *results= dict[@"results"];
//            
//            if ([total  intValue] >[results count])
//            {
//                 _pageIndex++;
//            }
            
        }
        //不要判断total
//        NSString *total =[NSString stringWithFormat:@"%@",dict[@"total"]];
//        if([total intValue]>[dict[@"results"] count])
//        {
//        }
        [self.contentTableView headerEndRefreshing];
        [self.contentTableView footerEndRefreshing];
//        self.contentModelArray = dict[@"results"];
    } failed:^(NSError *error) {
        [self.contentTableView headerEndRefreshing];
        [self.contentTableView footerEndRefreshing];

        [Toast makeToast:kNoneInternetTitle duration:2.0 position:@"center"];
    }];
    /*
//    NSDictionary *params = @{@"id": _contentModel.idStr,
//                             @"pageSize": @10,
//                             @"pageIndex": @(_pageIndex + 1)};
    [HttpRequest promotionPostRequestPath:nil methodName:@"PlatFormRangeDetail" params:params success:^(NSDictionary *dict) {
        [self.contentTableView headerEndRefreshing];
        [self.contentTableView footerEndRefreshing];
        self.contentModelArray = dict[@"results"];
    } failed:^(NSError *error) {
        [self.contentTableView headerEndRefreshing];
        [self.contentTableView footerEndRefreshing];
        [Toast makeToast:kNoneInternetTitle duration:2.0 position:@"center"];
    }];
    */
}

- (void)requestDataForActivityID{
    NSDictionary *params = @{@"Use_Type": @"FAST_BUY",
                             @"ids": _activityID};
    [HttpRequest promotionPostRequestPath:nil methodName:@"PlatFormBasicInfoFilter" params:params success:^(NSDictionary *dict) {
        if ([[dict allKeys] count]<=0) {
            return ;
        }
        self.contentModelArray = dict[@"results"];
        
    } failed:^(NSError *error) {
        [Toast makeToast:kNoneInternetTitle duration:2.0 position:@"center"];
    }];
}

- (void)requestReloadData{
    _pageIndex = 1;
    [self requestData];
}

- (void)requestAddData{
//    _pageIndex = (_contentModelArray.count + 9)/ 10;
    if([self.contentModelArray count]>0)
    {
         _pageIndex ++;
    }

    [self requestData];
}

- (void)requestCarCount{
    if(!sns.ldap_uid){
        return;
    }
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
        
    } failed:^(NSError *error) {
        
    }];
}

- (void)setContentModelArray:(NSArray *)contentModelArray{
    //为啥还要请求一遍？
    if (self.activityID.length>0) {
        
        [self initHeaderView];
        
    }else
    {
       discountHeadview.contentModel = _contentModel;
    }
    if (contentModelArray.count <= 0) {
        if (_pageIndex ==1) {
            [Toast makeToast:@"暂无活动！" duration:1.5 position:@"center"];
        }else{
            [Toast makeToast:@"无更多活动信息！" duration:1.5 position:@"center"];
        }
        return;
    }
//    if (!_contentModel) {
//        _contentModel = [[SActivityListModel alloc]initWithDictionary:contentModelArray[0]];
//        [self initHeaderView];
//        [self requestDataForModel];
//        return;
//    }
    

  
    /*
    //这是干啥的
    NSDictionary *dict = contentModelArray[0];
    NSString *keyString = dict[@"promotioN_RANGE"];
    if (!_promPlatModel) {
        if ([dict[@"promPlatComDtlFilterList"] count] > 0) {
            _promPlatModelArray = [SActivityPromPlatModel modelArrayForDataArray:dict[@"promPlatComDtlFilterList"]];
            int maxStandards = 0;
            NSInteger maxCount = 0;
            for (SActivityPromPlatModel *model in _promPlatModelArray) {
                model.condition = dict[@"condition"];
                if (model.colL_FLAG.boolValue) {
                    _promPlatModel = model;
                    break;
                }else{
                    if (model.standards.intValue > maxStandards) {
                        maxStandards = model.standards.intValue;
                        maxCount = [_promPlatModelArray indexOfObject:model];
                    }
                }
            }
            if (!_promPlatModel) {
                _promPlatModel = _promPlatModelArray[maxCount];
            }
        }
    }
    NSMutableArray *array = nil;
    if ([keyString isEqualToString:@"PROD"]) {
        _activityDetailType = activityGoods;
        array = [MBGoodsDetailsModel modelArrayForDataArray:dict[@"prodClsLst"]];
    }else if ([keyString isEqualToString:@"COLLOATION"]) {
        _activityDetailType = activityCollocation;
        array = [MBCollocationInfoModel modelArrayForDataArray:dict[@"collLst"]];
    }else if ([keyString isEqualToString:@"BRAND"]) {
        _activityDetailType = activityBrand;
        array = [FilterBrandCategoryModel modelArrayForDataArray:dict[@"brandLst"]];
    }
    */
    NSMutableArray *array = nil;
    array = [NSMutableArray arrayWithArray:[SActivityProductListModel modelArrayForDataArray:contentModelArray]];

    if (_pageIndex == 1) {
        _contentModelArray = array;
    }else{
        [_contentModelArray addObjectsFromArray:array];
    }
    [self.contentTableView reloadData];
}

#pragma mark - buy now action

- (void)activityCollocationBuyNow:(UIButton *)button model:(MBCollocationInfoModel *)model{
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    MBAddShoppingViewController *controller = [[MBAddShoppingViewController alloc]init];
    controller.fromControllerName = [NSString stringWithFormat:@"活动页面：%@", _contentModel.name];
    controller.promotion_ID = [NSString stringWithFormat:@"%@",_contentModel.idStr];
    controller.mbCollocationID = [NSString stringWithFormat:@"%@",model.aID];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)activityCollocationTouchContentImage:(UIImageView *)imageView model:(MBCollocationInfoModel *)model
{
    SCollocationDetailViewController *controller = [[SCollocationDetailViewController alloc]init];
    controller.fromControllerName = [NSString stringWithFormat:@"活动页面：%@", _contentModel.name];
    controller.mb_collocationId =[NSString stringWithFormat:@"%@", model.aID];
    controller.promotion_ID = [NSString stringWithFormat:@"%@",_contentModel.idStr];
    if (!_isActivityEnd){
        controller.promPlatModelArray = _promPlatModelArray;
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)activityGoodsBuyNow:(UIButton *)button model:(SActivityProductListModel *)model{
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    //跳转有问题
    MBAddShoppingViewController *controller = [[MBAddShoppingViewController alloc]initWithNibName:@"MBAddShoppingViewController" bundle:nil];
    controller.fromControllerName = [NSString stringWithFormat:@"活动页面：%@", _contentModel.name];
    controller.promotion_ID =[NSString stringWithFormat:@"%@", _contentModel.json];
    controller.showType = typeBuyNow;
//    controller.contentModel = model;
    controller.itemAry =@[model.product_sys_code];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)activityGoodsTouchContentImage:(UIImageView *)imageView model:(SActivityProductListModel *)model{
    
    SProductDetailViewController *controller = [SProductDetailViewController new];
//    controller.productID = model.clsInfo.aID;
    controller.productID =[NSString stringWithFormat:@"%@",model.product_sys_code];
    
    controller.promotion_ID = [NSString stringWithFormat:@"%@",_contentModel.json];
    controller.fromControllerName = [NSString stringWithFormat:@"活动页面：%@", _contentModel.name];
    controller.promPlatModel = _promPlatModel;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - header delegate
-(void)activityReceiveButton:(UIButton *)button{
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    SActivityReceiveViewController *controller = [[SActivityReceiveViewController alloc]init];
    controller.contentModel = _contentModel;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)activityReceiveEndNavigation{
    _isActivityEnd = YES;
    [self.contentTableView reloadData];
}

#pragma mark - tableView delegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SActivityDiscountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.isActivityEnd = _isActivityEnd;
    cell.promPlatModel = _promPlatModel;
    //新的
    cell.productListModel =_contentModelArray[indexPath.row];
    //老得
//    switch (_activityDetailType) {
//        case activityGoods:
//            cell.goodsModel = _contentModelArray[indexPath.row];
//            break;
//        case activityCollocation:
//            cell.collocationModel = _contentModelArray[indexPath.row];
//            break;
//        case activityBrand:
//            break;
//        default:
//            break;
//    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSInteger count = 0;
//    switch (_activityDetailType) {
//        case activityGoods:
//            count = _contentModelArray.count;
//            break;
//        case activityCollocation:
//            count = _contentModelArray.count;
//            break;
//        case activityBrand:
//            count = _contentModelArray.count;
//            break;
//        default:
//            break;
//    }
    return _contentModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170 * (UI_SCREEN_WIDTH/ 320);
}

@end
