//
//  FittingRoomViewController.m
//  Wefafa
//
//  Created by yintengxiang on 15/3/19.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//
//废弃不用 以前的试衣间 
#import "FittingRoomViewController.h"
#import "FittingRoomFirstCell.h"
#import "FittingRoomSecondCell.h"
#import "NavigationTitleView.h"
#import "OrderSuccessViewController.h"

#import "MyShoppingTrollyGoodsTableViewCell.h"
#import "MBCreateGoodsOrderViewController.h"
#import "MBShoppingGuideInterface.h"
#import "MyShoppingTrollyViewController.h"
#import "Toast.h"
#import "HttpRequest.h"

#import "WeFaFaGet.h"
#import "NetManager.h"
#import "Utils.h"
#import "CreatQR.h"

#import "CommonZBarViewController.h"

@interface FittingRoomViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabbleView;
@property (weak, nonatomic) IBOutlet UIView *NodataMessageView;
@property (weak, nonatomic) IBOutlet UIView *butBgView1;//展示预约单view
@property (weak, nonatomic) IBOutlet UIView *butBgView2;// 未展示view

@property (nonatomic, assign) NSInteger ceshi;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSMutableArray *selectArrData;
@property (nonatomic, strong) NSMutableArray *selectArrNum;

@property (nonatomic, copy) NSString *appointmentNo;
@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, strong) NSMutableDictionary *headInfo;

@property (nonatomic, assign) BOOL isExpire;

@end

@implementation FittingRoomViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    CGRect rect = [UIApplication sharedApplication].keyWindow.bounds;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationController.navigationBarHidden = NO;
    self.title = @"试衣间";
    
    for (id sender in [self.butBgView1 subviews]) {
        if ([sender isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)sender;
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 5.0;
        }
    }
    for (id sender in [self.butBgView2 subviews]) {
        if ([sender isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)sender;
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 5.0;
        }
    }
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    
//    self.tabbleView.top = theHeight;
//    self.tabbleView.height = self.tabbleView.height-61;
//    self.butBgView1.top = self.tabbleView.bottom;
//    self.butBgView2.top = self.tabbleView.bottom;
    if (self.appointmentID) {
        self.bookId = self.appointmentID;
        
    }else {
        NSString *str = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"BOOKID"];
        self.bookId = str;
    }
    
    if (self.bookId) {
        self.butBgView1.hidden = YES;
        self.butBgView2.hidden = NO;
    }else {
        self.butBgView1.hidden = NO;
        self.butBgView2.hidden = YES;
    }
    
    self.arrData = [NSMutableArray array];
    self.selectArrData = [NSMutableArray array];
    self.selectArrNum = [NSMutableArray array];
    self.headInfo = [NSMutableDictionary dictionary];
    self.tabbleView.hidden = YES;
    [self loadViewWithData];
}
- (void)loadViewWithData
{
    if (self.bookId) { //如果有预约单号 从服务器获取
        
        [HttpRequest productPostRequestPath:nil methodName:@"GetBillAppointment" params:@{@"AppointmentID":self.bookId} success:^(NSDictionary *dict) {
            NSLog(@"%@",dict);
            if (![dict[@"headInfo"][@"status"] isEqualToString:@"UF"]) {
                self.isExpire = YES;
                NSString *str = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"BOOKID"];
                if ([str integerValue] == [self.bookId integerValue]) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"BOOKID"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FITTINGROOMGOODS"];
                }
            }else {
                self.isExpire = NO;
                [self setRightButton:@"添加" action:@selector(clickRightBut:)];
            }
            NSMutableArray *x_mutableArr = [@[] mutableCopy];
            [x_mutableArr addObjectsFromArray:dict[@"detailInfos"]];
            
            NSMutableArray *y_mutableArr = [@[] mutableCopy];
            [y_mutableArr addObjectsFromArray:dict[@"detailInfos"]];
            
            NSMutableArray *z_mutableArr = [@[] mutableCopy];
            [z_mutableArr addObjectsFromArray:dict[@"detailInfos"]];
            
            
            for (int i = 0; i < [x_mutableArr count] ; i ++) {
                NSInteger qty = [[x_mutableArr objectAt:i][@"qty"] integerValue];
                if ([z_mutableArr containsObject:[x_mutableArr objectAt:i]]) {
                    for (int j = i+1; j < [y_mutableArr count]; j ++) {
                        if ([z_mutableArr containsObject:[y_mutableArr objectAt:j]]) {
                            
                            NSString *str = [x_mutableArr objectAt:i][@"prodID"];
                            NSString *str1 = [y_mutableArr objectAt:j][@"prodID"];
                            if ([str isEqualToString:str1]) {
//                                qty ++;
                                qty = [[y_mutableArr objectAt:j][@"qty"] integerValue] + qty;
//                                NSInteger qty =  [[x_mutableArr objectAt:i][@"qty"] integerValue] + 1;
                                NSMutableDictionary *mutableDic = [@{} mutableCopy];
                                [mutableDic addEntriesFromDictionary:[x_mutableArr objectAt:i]];
                                [mutableDic setObject:[NSString stringWithFormat:@"%zd",qty] forKey:@"qty"];
                                [z_mutableArr replaceObjectAtIndex:i withObject:mutableDic];
                                [z_mutableArr replaceObjectAtIndex:j withObject:@""];

                            }
                        }
                        
                    }
                }

                
            }
            NSMutableArray *d_mutableArr = [@[] mutableCopy];
            for (int j = 0; j < [z_mutableArr count]; j ++){
                if (![[z_mutableArr objectAt:j] isKindOfClass:[NSString class]]) {
                    [d_mutableArr addObject:[z_mutableArr objectAt:j]];
                }
            }
                [self.arrData addObjectsFromArray:d_mutableArr];
                [self.headInfo setDictionary:dict[@"headInfo"]];

                [self.tabbleView reloadData];
                self.tabbleView.hidden = NO;
            if (self.arrData.count == 0) {
                self.NodataMessageView.hidden = NO;
            }else {
                self.NodataMessageView.hidden = YES;
            }
//            }
        } failed:^(NSError *error) {
            if (self.arrData.count == 0) {
                self.NodataMessageView.hidden = NO;
            }else {
                self.NodataMessageView.hidden = YES;
            }
        }];
        


    }else { //没有预约单号 从本地储存的获取
        NSMutableArray *arr = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"FITTINGROOMGOODS"];
        
        NSMutableArray *x_mutableArr = [@[] mutableCopy];
        [x_mutableArr addObjectsFromArray:arr];
        
        NSMutableArray *y_mutableArr = [@[] mutableCopy];
        [y_mutableArr addObjectsFromArray:arr];
        
        NSMutableArray *z_mutableArr = [@[] mutableCopy];
        [z_mutableArr addObjectsFromArray:arr];
        
        for (int i = 0; i < [x_mutableArr count] ; i ++) {
            NSInteger qty = [[x_mutableArr objectAt:i][@"qty"] integerValue];
            if ([z_mutableArr containsObject:[x_mutableArr objectAt:i]]) {
                for (int j = i+1; j < [y_mutableArr count]; j ++) {
                    if ([z_mutableArr containsObject:[y_mutableArr objectAt:j]]) {
                        
                        NSString *str = [x_mutableArr objectAt:i][@"goodsinfo"][@"productInfo"][@"proD_NUM"];
                        NSString *str1 = [y_mutableArr objectAt:j][@"goodsinfo"][@"productInfo"][@"proD_NUM"];
                        if ([str isEqualToString:str1]) {
//                            qty ++;
                            qty = [[y_mutableArr objectAt:j][@"qty"] integerValue] + qty;
                            //                                NSInteger qty =  [[x_mutableArr objectAt:i][@"qty"] integerValue] + 1;
//                            NSMutableDictionary *mutableDic = [@{} mutableCopy];
//                            [mutableDic addEntriesFromDictionary:[x_mutableArr objectAt:i]];
//                            [mutableDic setObject:[NSString stringWithFormat:@"%zd",qty] forKey:@"qty"];
                            
                            
                            NSMutableDictionary *mutableDic = [@{} mutableCopy];
                            [mutableDic addEntriesFromDictionary:[x_mutableArr objectAt:i]];
                            [mutableDic setObject:[NSString stringWithFormat:@"%zd",qty] forKey:@"qty"];
                            
                            NSMutableDictionary *mutableDic1 = [@{} mutableCopy];
                            [mutableDic1 addEntriesFromDictionary:mutableDic[@"goodsinfo"][@"productInfo"]];
                            
                            [mutableDic1 setObject:[NSString stringWithFormat:@"%zd",qty] forKey:@"salE_QTY"];
                            [mutableDic setObject:@{@"productInfo":mutableDic1} forKey:@"goodsinfo"];

                            
                            
                            [z_mutableArr replaceObjectAtIndex:i withObject:mutableDic];
                            
                            [z_mutableArr replaceObjectAtIndex:j withObject:@""];
                            
                        }
                    }
                    
                    
                }
            }
            
            
        }
        NSMutableArray *d_mutableArr = [@[] mutableCopy];
        for (int j = 0; j < [z_mutableArr count]; j ++){
            if (![[z_mutableArr objectAt:j] isKindOfClass:[NSString class]]) {
                [d_mutableArr addObject:[z_mutableArr objectAt:j]];
            }
        }
        [self.arrData addObjectsFromArray:d_mutableArr];

        [self.tabbleView reloadData];
        self.tabbleView.hidden = NO;
        
        if (self.arrData.count == 0) {
            self.NodataMessageView.hidden = NO;
        }else {
            self.NodataMessageView.hidden = YES;
        }
    }
    
}
#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickRightBut:(id)sender
{
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[CommonZBarViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickAdd:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --立即购买
- (IBAction)clickBuyGoods:(id)sender {
    if (self.selectArrData.count == 0) {
        [Utils alertMessage:@"请选择购买商品"];
        return;
    }
        NSMutableArray *payList=[[NSMutableArray alloc] init];

        for (NSDictionary *dic in self.selectArrData) {
            NSMutableDictionary *infoDic = [@{} mutableCopy];
            if (dic[@"goodsinfo"][@"productInfo"] && [dic[@"goodsinfo"][@"productInfo"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *subDic = dic[@"goodsinfo"][@"productInfo"];
                [infoDic setObject:[NSString stringWithFormat:@"%@",dic[@"proD_ID"]] forKey:@"proD_ID"];
                [infoDic setObject:subDic[@"proD_CLS_NUM"] forKey:@"proD_CLS_NUM"];
                [infoDic setObject:subDic[@"coloR_FILE_PATH"] forKey:@"coloR_FILE_PATH"];
                [infoDic setObject:subDic[@"proD_NAME"] forKey:@"proD_NAME"];
                [infoDic setObject:subDic[@"coloR_ID"] forKey:@"coloR_ID"];
                [infoDic setObject:subDic[@"coloR_NAME"] forKey:@"coloR_NAME"];
                [infoDic setObject:subDic[@"speC_ID"] forKey:@"speC_ID"];
                [infoDic setObject:subDic[@"speC_NAME"] forKey:@"speC_NAME"];
                [infoDic setObject:[NSString stringWithFormat:@"%@",dic[@"qty"]] forKey:@"qty"];
                [infoDic setObject:subDic[@"price"] forKey:@"price"];
                [infoDic setObject:subDic[@"salE_PRICE"] forKey:@"salE_PRICE"];

                [infoDic setObject:[NSString stringWithFormat:@"%@",dic[@"proD_ID"]] forKey:@"platProdID"];//11位
//                ////订单确认需要
//                [infoDic setObject:[NSString stringWithFormat:@"%@",dic[@"proD_ID"]] forKey:@"prodid"];
                
                [infoDic setObject:[NSString stringWithFormat:@"%@",dic[@"productid"]] forKey:@"PROD_ID"];
                
            }else {
                [infoDic setObject:[NSString stringWithFormat:@"%@",dic[@"prodID"]] forKey:@"platProdID"];
                
//                //订单确认需要
//                [infoDic setObject:[NSString stringWithFormat:@"%@",dic[@"prodID"]] forKey:@"prodid"];
                
                [infoDic setObject:[NSString stringWithFormat:@"%@",dic[@"platProdID"]] forKey:@"PROD_ID"];
                [infoDic setObject:dic[@"productCode"] forKey:@"proD_CLS_NUM"];
                [infoDic setObject:dic[@"imageUrl"] forKey:@"coloR_FILE_PATH"];
                [infoDic setObject:dic[@"description"] forKey:@"proD_NAME"];
                [infoDic setObject:dic[@"colorID"] forKey:@"coloR_ID"];
                [infoDic setObject:dic[@"prodColor"] forKey:@"coloR_NAME"];
                [infoDic setObject:dic[@"specID"] forKey:@"speC_ID"];
                [infoDic setObject:dic[@"prodSpec"] forKey:@"speC_NAME"];
                [infoDic setObject:[NSString stringWithFormat:@"%@",dic[@"qty"]] forKey:@"qty"];
                [infoDic setObject:dic[@"totalMoney"] forKey:@"salE_PRICE"];
                [infoDic setObject:dic[@"totalMoney"] forKey:@"salE_PRICE"];
                [infoDic setObject:dic[@"platProdClsID"] forKey:@"productItemID"];
            }
            

            
//            [infoDic setObject:@"WP" forKey:@"Status"];
//            [infoDic setObject:stroeInfoDic[@"result"][@"ORG_CODE"] forKey:@"OrgCode"];
//            [infoDic setObject:sns.ldap_uid forKey:@"Creator"];
//            [AppointmentDetailInfos addObject:infoDic];
            
            MyShoppingTrollyGoodsData *data=[[MyShoppingTrollyGoodsData alloc] init];
            data.value=@{@"productInfo":infoDic};
           
//            data.collocationid=[Utils getSNSInteger:_data[@"detailInfo"][@"collocationId"]];
//            data.designerid=[[NSString alloc] initWithFormat:@"%@",_designerid];
//            data.designername=[[NSString alloc] initWithFormat:@"%@",_designername];
//            data.shareUserId=[[NSString alloc] initWithFormat:@"%@",_shareUserId];
//            data.number=[vc.numberStepper.text intValue];
            [payList addObject:data];
            
        }
        
        
        
        
        
        MBCreateGoodsOrderViewController *orderVC=[[MBCreateGoodsOrderViewController alloc] initWithNibName:@"MBCreateGoodsOrderViewController" bundle:nil];
        orderVC.goodsArray=payList;
        orderVC.sumInfo=nil;
        [self.navigationController pushViewController:orderVC animated:YES];

}
#pragma mark --添加购物车
- (IBAction)addShopCar:(id)sender {
    
    
    if (self.selectArrData.count == 0) {
        [Utils alertMessage:@"请选择商品"];
        return;
    }
    
    {
        //批量加入购物车
        NSMutableArray *goodsarr=[[NSMutableArray alloc] init];
        
        
        for (NSDictionary *dic in self.selectArrData) {
            NSString *str_qty = @"";
            NSString *prodID = @"";
            if (dic[@"goodsinfo"][@"productInfo"] && [dic[@"goodsinfo"][@"productInfo"] isKindOfClass:[NSDictionary class]]) {
                str_qty = dic[@"qty"];
                prodID = dic[@"productid"];
            }else {
                str_qty = dic[@"qty"];
                prodID = dic[@"platProdID"];
            }
            
            NSDictionary *goodsdict =  @{@"proD_ID":prodID,
                                         @"source":@"2",
                                         @"qty":str_qty,
                                         @"userId":sns.ldap_uid,
                                         @"sharE_SELLER_ID":@"",
                                         @"collocatioN_ID":@"",//[Utils getSNSInteger:_data[@"collocationId"]],
                                         @"designerId":@"",
                                         @"designerName":@""
                                         };
            [goodsarr addObject:goodsdict];
            
        }
        
        

        NSMutableDictionary *urlparam=[[NSMutableDictionary alloc] init];
        [urlparam setObject:goodsarr forKey:@"lstCreateDto"];

        NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
        [Toast makeToastActivity:@"加入购物车..." hasMusk:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL success=[SHOPPING_GUIDE_ITF requestPostUrlName:@"ShoppingCartCreateList" param:urlparam responseAll:nil responseMsg:msg];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success)
                {
                    MyShoppingTrollyViewController *vc1=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
                    [self.navigationController pushViewController:vc1 animated:YES];
                
                }
                else
                {
                    NSString *productid=nil;
                    NSString *messagestr=nil;
                    NSArray *paraArr=[msg componentsSeparatedByString:@";"];
                    if (paraArr.count==2)
                    {
                        productid=paraArr[0];
                        messagestr=paraArr[1];
                        [Utils alertMessage:[NSString stringWithFormat:@"加入购物车失败！(%@)",messagestr]];
                    }
                    else
                        [Utils alertMessage:@"加入购物车失败！"];
                }
                [Toast hideToastActivity];
            });
        });
        
    }
    
 
}
- (void)clickSelectBut:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    button.selected = !button.selected;
    if (button.selected) {
        [self.selectArrData addObject:[self.arrData objectAt:button.tag]];
        [self.selectArrNum addObject:@(button.tag)];
    }else {
        if ([self.selectArrData containsObject:[self.arrData objectAt:button.tag]]) {
            [self.selectArrData removeObject:[self.arrData objectAt:button.tag]];
            [self.selectArrNum removeObject:@(button.tag)];
        }
    }
}
#pragma mark -- 提交预约单
- (IBAction)clickSumit:(id)sender {
    [Toast makeToastActivity:@"正在请求" hasMusk:YES];
    UIButton *button = (UIButton *)sender;
    button.enabled = NO;
//    AppointmentID	 int	 	 预约单ID号
//    AppointmentNo	 int	 	 预约单编号
//    Description	  String	 	 描述
//    Status	  String	 必填	 状态 UF-未完成 F-完成  C-取消
//    FittingRoomID	 int	 	 试衣间ID
//    ContainerID	  String	 	 货位ID
//    OrgCode	  String	 必填	 门店号
//    ClothesCount	 int	 必填	 商品数量
//    Creator	  String	 必填	 用户ID
//    Operator	  String	 	 操作者
//    AppointmentSource	  String	 必填	预约单来源
//    默认SHOP-门店  APP-有范APP
    NSDictionary *stroeInfoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"STOREINFO"];
    
    NSMutableDictionary *AppointmentInfo = [@{} mutableCopy];
    [AppointmentInfo setObject:@"UF" forKey:@"status"];
    [AppointmentInfo setObject:stroeInfoDic[@"result"][@"ORG_CODE"] forKey:@"orgCode"];
    [AppointmentInfo setObject:@(self.arrData.count) forKey:@"clothesCount"];
    [AppointmentInfo setObject:sns.ldap_uid forKey:@"creator"];
    [AppointmentInfo setObject:@"APP" forKey:@"appointmentSource"];
    
    
    
//    ProdID	  String	 必填	 商品ID号
//    ProductCode	  String	 有就填	 商品款号
//    ImageUrl	  String	 有就填	 图片ＵＲＬ
//    Description	  String	 有就填	 商品名称
//    ColorID	  String	 有就填	 商品颜色ID
//    ProdColor	  String	 有就填	 商品颜色
//    SpecID	  String	 有就填	 商品尺码ID
//    ProdSpec	  String	 有就填	 商品尺码
//    Qty	 int	 必填	 商品数量
//    TotalMoney	 decimal	 必填	 商品总价格
//    Status	 string	 必填	状态 WP-待配货　IP-配货中
//    BD-投递中 CD-完成投递
//    OrgCode	  String	 必填	 门店号
//    OwnerOrgCode	  String	 	 门店上级组织
//    Creator	  String	 必填	 用户ID
    
    
    NSMutableArray *AppointmentDetailInfos = [@[] mutableCopy];
    
    for (NSDictionary *dic in self.arrData) {
        NSMutableDictionary *infoDic = [@{} mutableCopy];
        [infoDic setObject:[NSString stringWithFormat:@"%@",dic[@"proD_ID"]] forKey:@"prodID"];
        [infoDic setObject:dic[@"goodsinfo"][@"productInfo"][@"proD_CLS_NUM"] forKey:@"productCode"];
        [infoDic setObject:dic[@"goodsinfo"][@"productInfo"][@"coloR_FILE_PATH"] forKey:@"imageUrl"];
        [infoDic setObject:dic[@"goodsinfo"][@"productInfo"][@"proD_NAME"] forKey:@"description"];
        [infoDic setObject:dic[@"goodsinfo"][@"productInfo"][@"coloR_ID"] forKey:@"colorID"];
        [infoDic setObject:dic[@"goodsinfo"][@"productInfo"][@"coloR_NAME"] forKey:@"prodColor"];
        [infoDic setObject:dic[@"goodsinfo"][@"productInfo"][@"speC_ID"] forKey:@"specID"];
        [infoDic setObject:dic[@"goodsinfo"][@"productInfo"][@"speC_NAME"] forKey:@"prodSpec"];
        [infoDic setObject:[NSString stringWithFormat:@"%@",dic[@"qty"]] forKey:@"qty"];
        [infoDic setObject:dic[@"goodsinfo"][@"productInfo"][@"salE_PRICE"] forKey:@"totalMoney"];
        [infoDic setObject:@"WP" forKey:@"status"];
        [infoDic setObject:stroeInfoDic[@"result"][@"ORG_CODE"] forKey:@"orgCode"];
        [infoDic setObject:sns.ldap_uid forKey:@"creator"];
        [AppointmentDetailInfos addObject:infoDic];
    }
    
//    NSDictionary *postDic = @{@"Pars":@{@"AppointmentInfo":AppointmentInfo , @"AppointmentDetailInfos":AppointmentDetailInfos},@"ActionName":@"SaveBillAppointment"};
    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDic options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [HttpRequest productPostRequestPath:nil methodName:@"SaveBillAppointment" params:@{@"appointmentInfo":AppointmentInfo , @"appointmentDetailInfos":AppointmentDetailInfos} success:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        
        if ([dict[@"result"] integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults] setObject:dict[@"appointmentID"] forKey:@"BOOKID"];
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"BOOKIDINFO"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FITTINGROOMGOODS"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //            self.appointmentNo = responseDic[@"AppointmentNo"];
            //            [self loadViewWithData];
            //进预约成功的页面
            OrderSuccessViewController *controller = [[OrderSuccessViewController alloc] initWithNibName:@"OrderSuccessViewController" bundle:nil];
            controller.resultDic = dict;
            [self.navigationController pushViewController:controller animated:YES];
             button.enabled = YES;
            [Toast hideToastActivity];
        }else {
            [self showInfo:dict[@"errMessage"] autoHidden:YES];
             button.enabled = YES;
            [Toast hideToastActivity];
        }
    } failed:^(NSError *error) {
         button.enabled = YES;
        [Toast hideToastActivity];
    }];
    
//    [[NetManager sharedManager] postRequestWithUrlString:DomainUrl postParamDic:@{@"InData" : json} success:^(id responseDic) {
//        NSLog(@"%@",responseDic);
//
//        if ([responseDic[@"Result"] integerValue] == 1) {
//            [[NSUserDefaults standardUserDefaults] setObject:responseDic[@"AppointmentID"] forKey:@"BOOKID"];
//            [[NSUserDefaults standardUserDefaults] setObject:responseDic forKey:@"BOOKIDINFO"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FITTINGROOMGOODS"];
//
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
////            self.appointmentNo = responseDic[@"AppointmentNo"];
////            [self loadViewWithData];
//            //进预约成功的页面
//            OrderSuccessViewController *controller = [[OrderSuccessViewController alloc] initWithNibName:@"OrderSuccessViewController" bundle:nil];
//            controller.resultDic = responseDic;
//            [self.navigationController pushViewController:controller animated:YES];
//            
//        }
//    } failure:^(id errorString) {
//        
//    }];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.bookId && !self.isExpire) {
        return 2;
    }else {
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.bookId && !self.isExpire) {
        if (section == 0) {
            return 1;
        }
        return self.arrData.count;
    }else {
        return self.arrData.count;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bookId) {
        if (self.isExpire) {
            NSString *cellString = @"FittingRoomSecondCell";
            FittingRoomSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
            if (!cell) {
                NSArray *arrayXib = [[NSBundle mainBundle] loadNibNamed:@"FittingRoomSecondCell" owner:[FittingRoomSecondCell class] options:nil];
                cell = [arrayXib objectAt:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.selsectButton addTarget:self action:@selector(clickSelectBut:) forControlEvents:UIControlEventTouchUpInside];
            }
            cell.selsectButton.selected = NO;
            cell.selsectButton.tag = indexPath.row;
            if ([self.selectArrNum containsObject:@(cell.selsectButton.tag)]) {
                cell.selsectButton.selected = YES;
            }
            [cell configWithData:[self.arrData objectAt:indexPath.row] isFromAPI:YES];
            
            return cell;
        }else {
            if (indexPath.section == 0) {
                NSString *cellString = @"FittingRoomFirstCell";
                FittingRoomFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
                if (!cell) {
                    NSArray *arrayXib = [[NSBundle mainBundle] loadNibNamed:@"FittingRoomFirstCell" owner:[FittingRoomFirstCell class] options:nil];
                    cell = [arrayXib objectAt:0];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                //            NSDictionary *responseDic = self.headInfo;//(NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:@"BOOKIDINFO"];
                
                if (self.headInfo) {
                    cell.codeImageView.image = [CreatQR creatOR:[NSString stringWithFormat:@"%@",self.headInfo[@"appointmentNo"]]];
                    cell.orderNumber.text = [NSString stringWithFormat:@"%@",self.headInfo[@"appointmentNo"]];
                }
                //            else {
                //                cell.codeImageView.image = [CreatQR creatOR:self.appointmentNo];
                //                cell.orderNumber.text = [NSString stringWithFormat:@"%@",self.appointmentNo];
                //            }
                
                
                return cell;
            }else {
                NSString *cellString = @"FittingRoomSecondCell";
                FittingRoomSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
                if (!cell) {
                    NSArray *arrayXib = [[NSBundle mainBundle] loadNibNamed:@"FittingRoomSecondCell" owner:[FittingRoomSecondCell class] options:nil];
                    cell = [arrayXib objectAt:0];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell.selsectButton addTarget:self action:@selector(clickSelectBut:) forControlEvents:UIControlEventTouchUpInside];
                }
                cell.selsectButton.selected = NO;
                cell.selsectButton.tag = indexPath.row;
                if ([self.selectArrNum containsObject:@(cell.selsectButton.tag)]) {
                    cell.selsectButton.selected = YES;
                }
                [cell configWithData:[self.arrData objectAt:indexPath.row] isFromAPI:YES];
                
                return cell;
            }
            return nil;
        }
        
    }else {
        NSString *cellString = @"FittingRoomSecondCell";
        FittingRoomSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
        if (!cell) {
            NSArray *arrayXib = [[NSBundle mainBundle] loadNibNamed:@"FittingRoomSecondCell" owner:[FittingRoomSecondCell class] options:nil];
            cell = [arrayXib objectAt:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.selsectButton addTarget:self action:@selector(clickSelectBut:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.selsectButton.selected = NO;
        cell.selsectButton.tag = indexPath.row;
        [cell configWithData:[self.arrData objectAt:indexPath.row] isFromAPI:NO];
        
        return cell;
    }
    
}
/***add miao 5.5  隐藏删除功能业务暂没有
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bookId && !self.isExpire) {
        if (indexPath.section == 0) {
            return NO;
        }else {
            return YES;
        }
    }else {
        return YES;
    }

}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.arrData removeObjectAtIndex:indexPath.row];
     [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
}
***/
#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bookId && !self.isExpire) {
        if (indexPath.section == 0) {
            return 273;
        }
        else if (indexPath.section == 1) {
            return 90;
        }

    }else {
        return 90;

        
    }
    
    
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.row == [self.ContentdataArrm count] - 2) {
    //        if ([self.fansData[@"pageInfo"][@"total"] integerValue] > [self.ContentdataArrm count]) {
    //            self.pageNumber ++;
    //            [self request:self.pageNumber];
    //        }
    //    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
