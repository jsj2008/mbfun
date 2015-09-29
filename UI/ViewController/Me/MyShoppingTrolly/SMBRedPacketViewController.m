//
//  SMBRedPacketViewController.m
//  Wefafa
//
//  Created by metesbonweios on 15/6/4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SMBRedPacketViewController.h"
#import "MyRedPackTableViewCell.h"
#import "HttpRequest.h"
#import "MJRefresh.h"
#import "Toast.h"
#import "WeFaFaGet.h"
#import "MyRedPacketModel.h"
#import "Utils.h"
#import "MyShoppingTrollyGoodsTableViewCell.h"
#import "OrderRedPacketModel.h"
#import "SUtilityTool.h"
#import "SBrandShowListControllerViewController.h"
#import "SItemViewController.h"
#import "SDataCache.h"

@interface SMBRedPacketViewController ()<RedPacketCellDelete>
{
    NSMutableArray *redPacketArray;
    int refreshPageIndex;
    NSMutableArray *cartlist;
    
    UIView * noneDataView;
    
}
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *redPacketTableView;

@end

@implementation SMBRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    redPacketArray = [[NSMutableArray alloc]init];
    _redPacketTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    refreshPageIndex=0;
    cartlist = [[NSMutableArray alloc]init];
    
    [self showRequestToast];
    [noneDataView removeFromSuperview];
    
    [self setupNavbar];
    [self networkRequestIsPull:YES];
    [self addHeader];
    [self addFooter];
   
}

- (void)addHeader
{
    __weak typeof(self) weakSelf = self;
    // 添加下拉刷新头部控件
    [_redPacketTableView addHeaderWithCallback:^{
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
    [_redPacketTableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf networkRequestIsPull:NO];
        });
    }];
}
-(void)networkRequestIsPull:(BOOL)isPull
{

    __weak typeof(self) weakSelf = self;
    if (!redPacketArray) {
        redPacketArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (isPull) {
        refreshPageIndex = 1;
        [redPacketArray removeAllObjects];
        [_redPacketTableView reloadData];
        
    }
    if (sns.ldap_uid.length==0) {
        [Toast hideToastActivity];
        
        return;
    }
    NSDictionary *paramDic;
    NSString *mothodName=@"";
    
    // 注意userId不要写死。
    NSString *userId = @"0005b031-c73f-4633-9e00-bbf087e11a25";
    userId=sns.ldap_uid;
    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
    
    if(_isFromOrder)
    {
         mothodName=@"getUserCanUseVochersList";
        NSMutableArray *productList=[[NSMutableArray alloc]init];
        
        for (int k=0; k<[_prodList count]; k++) {
            MyShoppingTrollyGoodsData *data=[[MyShoppingTrollyGoodsData alloc]init];
            data = _prodList[k];
            
            NSMutableDictionary *prodic =  [NSMutableDictionary new];
            [prodic setObject:data.collocationid forKey:@"collocation_id"];
            [prodic setObject:data.prodNum forKey:@"barcode"];
            [prodic setObject:[Utils getSNSString:[NSString stringWithFormat:@"%@",data.prodInfo.aid]] forKey:@"aid"];
            
            /*
            //add by miao 6.8
            if (data.prodInfo == nil) {
                [prodic setObject:[NSNumber numberWithFloat:data.saleprice] forKey:@"sale_Price"];
            }else{
//                 add by miao  原来处理时商品原价小于范票价显示原价 先注释
//                if (data.saleprice > data.prodInfo.diS_Price.floatValue) {
                      [prodic setObject:[Utils getSNS02Float:[NSString stringWithFormat:@"%f",data.saleprice - data.prodInfo.diS_Price.floatValue]] forKey:@"sale_Price"];
//                }else{
//                    [prodic setObject:[Utils getSNS02Float:[NSString stringWithFormat:@"%f",data.saleprice]] forKey:@"sale_Price"];
//                }
            
            }
            */
            
            [prodic setObject:[NSNumber numberWithInt:data.number] forKey:@"num"];
            
            [productList addObject:prodic];
            
        }
        cartlist = productList;
        
        paramDic =@{@"token":userToken,@"cartList":productList,@"pageIndex":[NSNumber numberWithInt:refreshPageIndex],@"pageSize":@14};
//        NSLog(@"paramdic－－－%@",paramDic);sns.ldap_uid
        [HttpRequest vouchersPostRequestPath:nil methodName:mothodName params:paramDic success: ^(NSDictionary *dict){
            
            [weakSelf parseResponseDataWithDict:dict];
            
        }failed:^(NSError *error){
            NSLog(@"订单促销错误------%@", error);
            [Toast hideToastActivity];
            [_redPacketTableView footerEndRefreshing];
            [_redPacketTableView headerEndRefreshing];
            
        } ];
        
    }
    else
    {


//        paramDic =@{@"UserId":userId,@"pageIndex":[NSNumber numberWithInt:refreshPageIndex],@"pageSize":@14};
        paramDic=@{@"token":userToken,@"pageIndex":[NSNumber numberWithInt:refreshPageIndex],@"pageSize":@14};
        mothodName=@"MyselfCouponFilter";
//        [HttpRequest promotionGetRequestPath:nil methodName:mothodName params:paramDic success: ^(NSDictionary *dict){
//            //
//            [weakSelf parseResponseDataWithDict:dict];
//            
//        }failed:^(NSError *error){
//            NSLog(@"促销错误------%@", error);
//            [Toast hideToastActivity];
//            [_redPacketTableView footerEndRefreshing];
//            [_redPacketTableView headerEndRefreshing];
//            
//        } ];
        
        [HttpRequest vouchersGetRequestPath:nil methodName:mothodName params:paramDic success:^(NSDictionary *dict) {
               [weakSelf parseResponseDataWithDict:dict];
        } failed:^(NSError *error) {
            NSLog(@"促错误------%@", error);
            [Toast hideToastActivity];
            [_redPacketTableView footerEndRefreshing];
            [_redPacketTableView headerEndRefreshing];
            
        }];
        
    }
 
    
}
-(void)initNoDataView
{
    if(!noneDataView)
    {
        noneDataView = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64) WithImage:NONE_DATA_ORDER andImgSize:CGSizeMake(60, 60) andTipString:@"您还没有范票哦" font:FONT_t5 textColor:COLOR_C6 andInterval:20.0];
        [self.view addSubview:noneDataView];
    }
    
}
- (void)parseResponseDataWithDict:(NSDictionary *)dict
{
    NSString *message = nil;
    BOOL issuccess;
    
    if([[dict allKeys]containsObject:@"total"])
    {
        int totalCount = (int)[[dict objectForKey:@"total"] integerValue];
        if (totalCount==0) {
            [Toast hideToastActivity];
            [_redPacketTableView footerEndRefreshing];
            [_redPacketTableView headerEndRefreshing];
            [self initNoDataView];
            
            return;
        }
    }
    
    if ([[dict allKeys]containsObject:@"total"]&&[[dict allKeys]containsObject:@"results"]) {
     
        message = [NSString stringWithFormat:@"%@",dict[@"message"]];
        
        issuccess = (BOOL)dict[@"isSuccess"];
        
        NSArray *resultsAray = [[NSArray alloc]initWithArray:dict[@"results"]];
        int totalCount = (int)[[dict objectForKey:@"total"] integerValue];
        if (totalCount==0) {
            [Toast hideToastActivity];
            [_redPacketTableView footerEndRefreshing];
            [_redPacketTableView headerEndRefreshing];
            [self initNoDataView];
            
            return;
        }
        [noneDataView removeFromSuperview];
      if(_isFromOrder)
      {
          NSArray *modelArary = [NSArray arrayWithArray:[OrderRedPacketModel modelArrayForDataArray:resultsAray]];
          //排序 按照 canuse 在前 不可使用在后面  不需要排序返回的全是canuse
//          modelArary = [self refreshSortWithArray:modelArary];
          
          if (totalCount>[redPacketArray count]) {
              refreshPageIndex ++;
              [redPacketArray addObjectsFromArray:modelArary];
          }
      }

        else
        {
            NSArray *modelArary = [NSArray arrayWithArray:[MyRedPacketModel modelArrayForDataArray:resultsAray]];
            if (totalCount>[redPacketArray count]) {
                refreshPageIndex ++;
                [redPacketArray addObjectsFromArray:modelArary];
            }
        }
    }
    else
    {
        issuccess = (BOOL)dict[@"isSuccess"];
        if (!issuccess) {
             [self initNoDataView]; 
        }
        message = dict[@"message"];
      
    }
    

    [self updateViewWithRequestSuccess:issuccess message:message];
}
-(NSMutableArray *)refreshSortWithArray:(NSArray *)firstArray
{
    NSMutableArray *canUseArray=[[NSMutableArray alloc]init];
    NSMutableArray *canNotUserArray= [[NSMutableArray alloc]init];
    NSMutableArray * resultArray = [[NSMutableArray alloc]init];
    for (OrderRedPacketModel *orderRP in firstArray) {
        
        BOOL canUse =orderRP.canUse;
        if (canUse) {
            
            [canUseArray addObject:orderRP];
        }
        else
        {
            [canNotUserArray addObject:orderRP];
        }

    }
    [resultArray addObjectsFromArray:canUseArray];
    [resultArray addObjectsFromArray:canNotUserArray];
    
    return  resultArray;
}
- (void)setupNavbar {
    [super setupNavbar];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                    target:nil action:nil];
    negativeSpacer.width = 0;
    
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    self.title=@"我的范票";
    if(_isFromOrder){
        // 这里可以试试 UIBarButtonItem的customView来处理2个btn
        UIButton *rightbtn=[[UIButton alloc]init];
        rightbtn.backgroundColor=[UIColor clearColor];
        rightbtn.frame=CGRectMake(0, 0, 75, 44);
        [rightbtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        rightbtn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 10);
    
        [rightbtn setTitle:@"不使用" forState:UIControlStateNormal];
        rightbtn.titleLabel.font=BUTTONMEDIUMFONT;
        [rightbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightbtn addTarget:self action:@selector(btnEditClick:) forControlEvents:UIControlEventTouchUpInside];
    
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
    
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
    
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
    
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
    
                                               target:nil action:nil];
    
            negativeSpacer.width = 0;
            self.navigationItem.rightBarButtonItems = @[negativeSpacer, backItem];
        }
        else{
            
            self.navigationItem.rightBarButtonItem=backItem;
            
        }

    }
}
- (void)updateViewWithRequestSuccess:(BOOL)isSuccess message:(NSString *)message
{
    [Toast hideToastActivity];
    if (!isSuccess) {
        //....//
        //        _redPacketTableView.contentModelArray = activityDataArray;
        if ([Utils getSNSString:message].length==0) {
            message=@"数据错误";
        }
        [Utils alertMessage:message];
        
        
    }
    else if (message.length!=0)
    {
        [Utils alertMessage:message];
    }
    [_redPacketTableView footerEndRefreshing];
    [_redPacketTableView headerEndRefreshing];
    [_redPacketTableView reloadData];
    
}
-(void)mbCell_OnDidSelectedWithMessage:(id)message
{
    OrderRedPacketModel *orderRedPacketModel = message;
    if (_myblock) {

        _myblock(orderRedPacketModel,cartlist);
  
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)mbCell_OnDidSelectedGoDetailWithMessage:(id)message
{
    MyRedPacketModel *myredPacket = message;
    BOOL  canDetail = NO;
    switch ([myredPacket.status integerValue]) {
        case 1://初始化 已锁定 已使用 已过期
        {
            canDetail = YES;
        }
            break;
        case 2:// 已锁定
        {
            
        }
            break;
        case 3://已使用
        {
            
        }
            break;
        case 4://已过期
        {
            
        }
            break;
            
        default:
            break;
    }
    
    switch ([myredPacket.usE_RULE_STATUS integerValue]) {
        case 0://未知范票
        {
            
        }
            break;
        case 1://全场范票
        {
            
        }
            break;
        case 2://品牌范票
        {
            if( canDetail)
            {
                SBrandShowListControllerViewController *brandVc = [[SBrandShowListControllerViewController alloc]initWithNibName:@"SBrandShowListControllerViewController" bundle:nil];
                [self pushController:brandVc animated:YES];
            }
        }
            break;
        case 3://搭配范票
        {
            
        }
            break;
        case 4://单品范票
        {
            if (canDetail) {
                SItemViewController *Vc = [SItemViewController new];
                [self pushController:Vc animated:YES];
            }
            
        }
            break;
            
            
        default:
        {
            
        }
            break;
    }
    

}
- (void)showRequestToast
{
    [Toast makeToastActivity:@"正在获取数据" hasMusk:YES];
}
-(void)btnEditClick:(id)sender{
    
    if (_myblock) {
        _myblock(0,cartlist);
    }
    [self popAnimated:YES];
}
- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105 ;
}
//* UI_SCREEN_WIDTH/ 375
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
   
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [redPacketArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
//    return [redPacketArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRedPackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyRedPackTableViewCell" owner:self options:nil] objectAtIndex:0];

    }
    cell.redPacketDelete=self;
    cell.isComeFromOrder = _isFromOrder;
    cell.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0  blue:239.0/255.0  alpha:1];
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
 
    if ([redPacketArray count]>indexPath.section) {
        if (_isFromOrder) {
           
            cell.orderCellModel = redPacketArray[indexPath.section];
            
            cell.choosePacketId=_redPacketId;
        }
        else
        {
            cell.cellModel =redPacketArray[indexPath.section];
        }

    }

    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_isFromOrder) {
//    OrderRedPacketModel *orderRedPacketModel =  redPacketArray[indexPath.section];
//        BOOL canuse = orderRedPacketModel.canUse;
//        if (!canuse) {
//            [Utils alertMessage:@"该范票不可用,请选择其他范票!"];
//            return;
//        }
    }
    else
    {
        /*
        MyRedPacketModel *myredPacket = redPacketArray[indexPath.section];
        BOOL  canDetail = NO;
        switch ([myredPacket.status integerValue]) {
            case 1://初始化 已锁定 已使用 已过期
            {
                canDetail = YES;
            }
                break;
            case 2:// 已锁定
            {
                
            }
                break;
            case 3://已使用
            {
                
            }
                break;
            case 4://已过期
            {
                
            }
                break;
                
            default:
                break;
        }

        switch ([myredPacket.usE_RULE_STATUS integerValue]) {
            case 0://未知范票
            {
                
            }
                break;
            case 1://全场范票
            {
                
            }
                break;
            case 2://品牌范票
            {
                if( canDetail)
                {
                    SBrandShowListControllerViewController *brandVc = [[SBrandShowListControllerViewController alloc]initWithNibName:@"SBrandShowListControllerViewController" bundle:nil];
                    [self pushController:brandVc animated:YES];
                }
            }
                break;
            case 3://搭配范票
            {

            }
                break;
            case 4://单品范票
            {
                if (canDetail) {
                    SItemViewController *Vc = [SItemViewController new];
                    [self pushController:Vc animated:YES];
                }

            }
                break;
                
                
            default:
            {

            }
                break;
        }
        */
       
    }
    
    
    if (_myblock) {
        if([redPacketArray count]<indexPath.section)
        {
            _myblock(0,@[]);
            
        }
        else
        {
              _myblock(redPacketArray[indexPath.section],cartlist);
        }
        
        [self popAnimated:YES];
    }


}
-(void)RedPacketVCSourceVoBlock:(RedPacketVCSourceVoBlock)block
{
    _myblock = block;
    
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
