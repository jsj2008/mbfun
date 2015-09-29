//
//  PayOrderViewController.m
//  Wefafa
//
//  Created by mac on 14-10-31.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "PayOrderViewController.h"
#import "NavigationTitleView.h"
#import "WXPayClient.h"
#import "Utils.h"
#import "MBShoppingGuideInterface.h"
#import "Toast.h"
#import "Globle.h"
#import "PayResultViewController.h"
#import "MyOrderViewController.h"
#import "OrderModel.h"

@interface PayOrderViewController ()
@property(nonatomic,strong)CommonEventHandler *payCompleteEvent;
@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
@end

@implementation PayOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)payOrderVCSourceVoBlock:(PayOrderVCSourceVoBlock) block{
    _myblock = block;

}
-(void)payOrderVCPayCompleteBlock:(PayOrderVCPayCompleteBlock)block{
    _paycompleteBlock = block;
}
/*
paymentList =     (
                   {
                       "makE_AMOUNT" = 1503;
                       "paY_STATE" = 0;
                       "paY_STATE_NAME" = "\U672a\U4ed8\U6b3e";
                       "paY_TIME" = "/Date(1425373076703-0000)/";
                       "paY_TYPE" = ZFB;
                       payment = "ON_LINE";
                       status = 0;
                       statusName = "\U672a\U6210\U529f";
                   }
                   );
 */
-(void)setPaymentList:(NSArray *)paymentList{
    _paymentList = paymentList;
    //wwpchange model
    
    /*
    NSDictionary *dic = _paymentList[0];

    NSString *payType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"paY_TYPE"]];
     */
    if([_paymentList count]==0)
    {
        return;
    }
    OrderModelPaymentListInfo *paymentListInfo = _paymentList[0];
    NSString *payType = [NSString stringWithFormat:@"%@",paymentListInfo.pay_type];
    
    if ([payType isEqualToString:@"ZFB"]) {
         _selectedPayType = @"支付宝支付";
    }else{
        _selectedPayType = @"微信支付";
    
    }
   
    [self btnPayClick:@"直接跳转"];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect headrect=CGRectMake(0,0,self.viewHead.frame.size.width,self.viewHead.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"选择支付方式";
    [self.viewHead addSubview:view];
    
    _tvPayMethod.tableFooterView=[[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,60)];
    dataArray=@[@{@"image":@"ico_paypal.png",@"text":@"支付宝"},
                @{@"image":@"ico_chatpay.png",@"text":@"微信支付"}];
    if (_selectedPayType == nil) {
        _selectedPayType=@"";
    }
    
    
   //12.13 add by miao
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payAliCompleteCallback:) name:NOTICE_PAYALICOMPLETE object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payAliFailureCallback:) name:NOTICE_PAYFAILURE object:nil];
     _result = @selector(payAlimentResult:);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view datasource & delegate methods

-(void)setCellBackground:(UITableViewCell *)cell
{
    //    UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
    //    backgrdView.backgroundColor=[self getcolor:[[[rootDict objectForKey:@"template"]objectForKey:@"nav"] objectForKey:@"_bgcolor" ]];
    //    backgrdView.backgroundColor = TABLEVIEW_BACKCOLOR;
    //    cell.backgroundView = backgrdView;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置selectionStyle = UITableViewCellSelectionStyleNone; 选中的背景无效
    //    UIView *selectedView = [[UIView alloc] initWithFrame:cell.contentView.frame];
    //    selectedView.backgroundColor = [UIColor orangeColor];
    //    cell.selectedBackgroundView = selectedView;   //设置选中后cell的背景颜色
    //    [selectedView release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *headername = orderInfoArray[section][@"title"];
//    if ([headername characterAtIndex:0] == '_') return nil;
//    return headername;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    NSString *headername = orderInfoArray[section][@"title"];
//    if ([headername characterAtIndex:0] == '_') return 0;
//    return 28;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return _viewBottom.frame.size.height;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return _viewBottom;
}

-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSString *AIdentifier =  @"CollocationTableViewCell";
    //    CollocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AIdentifier];
    //    if (cell == nil) {
    //        cell = [[[NSBundle mainBundle] loadNibNamed:@"CollocationTableViewCell" owner:self options:nil] objectAtIndex:0];
    //        [self setCellBackground:cell];
    //    }
    //    cell.data=self.dataArray[indexPath.row];
    //    return cell;
    
    NSDictionary *rowData=dataArray[indexPath.row];
    NSString *classId=@"payordercell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:classId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:classId];
        [self setCellBackground:cell];
        
        CGRect r=CGRectMake(15,(cell.frame.size.height-25)/2,25,25);
        UIImageView *img=[[UIImageView alloc] initWithFrame:r];
        img.tag=1002;
        [cell.contentView addSubview:img];
        
        CGRect lr=CGRectMake(r.origin.x+r.size.width+10,(cell.frame.size.height-25)/2,200,25);
        UILabel *lb=[[UILabel alloc] initWithFrame:lr];
        lb.textColor=[Utils HexColor:0x353535 Alpha:1.0];
        lb.font=[UIFont systemFontOfSize:14];
        lb.tag=1001;
        [cell.contentView addSubview:lb];
    }
    
    UILabel *lb=(UILabel *)[cell.contentView viewWithTag:1001];
    lb.text=rowData[@"text"];
    UIImageView *img=(UIImageView *)[cell.contentView viewWithTag:1002];
    img.image=[UIImage imageNamed:rowData[@"image"]];
    NSLog(@"_selectedPayType%@",_selectedPayType);
    if ([_selectedPayType isEqualToString:@"微信支付"] && indexPath.row == 1 ) {
      
             cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    if ([_selectedPayType isEqualToString:@"支付宝支付"] && indexPath.row == 0) {
      
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_paymentList != nil) {
        return;
    }
    for (int i=0;i<dataArray.count;i++)
    {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    
    NSDictionary *rowData=dataArray[indexPath.row];
    _selectedPayType=rowData[@"text"];

    if ([rowData[@"text"] isEqualToString:@"支付宝"])
    {
       
    }
    else if ([rowData[@"text"] isEqualToString:@"微信支付"])
    {
       
    }
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 100:
            if (buttonIndex==0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
            }
            break;
    }
}

+ (PayOrderViewController *)sharedPayOrderViewController
{
    static PayOrderViewController *sharedPayorderInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedPayorderInstance = [[self alloc] init];
    });
    return sharedPayorderInstance;
}

//static BOOL isonly =NO ;
#pragma mark-----微信支付and支付宝支付
-(void)payreatedMethod{
//    if (isonly) {
//     
//        return;
//    }
    
    NSLog(@"ssssssssssssssssssssssssssssssss");
    [TalkingData trackEvent:@"我的订单" label:@"微信支付"];
    if ([_selectedPayType isEqualToString:@"微信支付"])
    {
        if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]))
        {
            [TalkingData trackEvent:@"提交订单" label:@"支付中断(未安装微信)"];
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"安装微信" message:@"请安装新版微信后，再支付订单！" delegate:self cancelButtonTitle:@"安装" otherButtonTitles:@"取消", nil];
            alertView.tag = 100;
            [alertView show];
            return;
        }
//        isonly =YES;

        
        [Toast makeToastActivity:@"微信支付..." hasMusk:YES];

        
        CommonEventHandler *payCompleteEvent=[CommonEventHandler instance:self selector:@selector(payCompleteCallback:eventData:)];
        //微信total_fee参数为分。
        wxPayClient.orderInfo=[[NSMutableDictionary alloc] initWithDictionary:self.param copyItems:YES ];
        
        float fsum =  [wxPayClient.orderInfo[@"total_fee"] floatValue] *100;
        //                        int sum=[wxPayClient.orderInfo[@"total_fee"] floatValue]*100;
        wxPayClient.orderInfo[@"total_fee"]=[[NSNumber alloc] initWithFloat:fsum];
        //                        wxPayClient.orderInfo[@"total_fee"]=[[NSNumber alloc] initWithFloat:1.0f];
        
        //                        [Toast makeToast:@"正在去微信支付..." duration:6 position:@"center"];
        [Toast makeToastSuccess:@"正在去微信支付..."];
        [TalkingData trackEvent:@"提交订单" label:@"前往微信"];
        
        
        [wxPayClient payProduct:payCompleteEvent payAccountInfo:nil];
        /*
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            [Toast makeToastActivity:@"微信支付..." hasMusk:YES];
            
            
            CommonEventHandler *payCompleteEvent=[CommonEventHandler instance:self selector:@selector(payCompleteCallback:eventData:)];
            //微信total_fee参数为分。
            wxPayClient.orderInfo=[[NSMutableDictionary alloc] initWithDictionary:self.param copyItems:YES ];
            
            float fsum =  [wxPayClient.orderInfo[@"total_fee"] floatValue] *100;
            //                        int sum=[wxPayClient.orderInfo[@"total_fee"] floatValue]*100;
            wxPayClient.orderInfo[@"total_fee"]=[[NSNumber alloc] initWithFloat:fsum];
            //                        wxPayClient.orderInfo[@"total_fee"]=[[NSNumber alloc] initWithFloat:1.0f];
            
            //                        [Toast makeToast:@"正在去微信支付..." duration:6 position:@"center"];
            [Toast makeToastSuccess:@"正在去微信支付..."];
            [TalkingData trackEvent:@"提交订单" label:@"前往微信"];
    
            
            [wxPayClient payProduct:payCompleteEvent payAccountInfo:nil];
            
            
//            BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:@"PaymentAccountFilter" param:@{@"APP_ID":[NSString stringWithFormat:@"%@",kWXAPP_ID]} responseList:list responseMsg:msg];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (success)
//                {
//                   
//                    if (list.count>0)
//                    {
//                        rst=YES;
//                        CommonEventHandler *payCompleteEvent=[CommonEventHandler instance:self selector:@selector(payCompleteCallback:eventData:)];
//                        //微信total_fee参数为分。
//                        wxPayClient.orderInfo=[[NSMutableDictionary alloc] initWithDictionary:self.param copyItems:YES ];
//                        
//                        float fsum =  [wxPayClient.orderInfo[@"total_fee"] floatValue] *100;
//                        wxPayClient.orderInfo[@"total_fee"]=[[NSNumber alloc] initWithFloat:fsum];
////                        wxPayClient.orderInfo[@"total_fee"]=[[NSNumber alloc] initWithFloat:1.0f];
//                        [TalkingData trackEvent:@"我的订单" label:@"前往微信"];
////                        [Toast makeToast:@"正在去微信支付..." duration:6 position:@"center"];
//                        [wxPayClient payProduct:payCompleteEvent payAccountInfo:list[0]];
//                    }
//                    
//                    
//                }
//                 isonly = NO;
//                if (!rst)
//                {
//                    [Toast hideToastActivity];
//                    [TalkingData trackEvent:@"我的订单" label:@"微信支付(生成支付信息失败)" parameters:@{@"生成错误信息": msg? msg: @""}];
//                    [Utils alertMessage:@"生成支付信息失败！"];
//                }
//            });
        });
         */
    }
    else
    {//支付宝支付
        [TalkingData trackEvent:@"我的订单" label:@"支付宝支付"];
        __block BOOL rst=NO;
        [Toast makeToastActivity:@"支付宝支付..." hasMusk:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //            NSMutableArray *list=[[NSMutableArray alloc] initWithCapacity:10];
            //            NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
            //微信支付返回微信的一些秘钥
            //            BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:@"PaymentAccountFilter" param:@{@"APP_ID":[NSString stringWithFormat:@"%@",PartnerID]} responseList:list responseMsg:msg];
            BOOL success = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success)
                {
                   
                    //                    if (list.count>0)
                    //                    {
                    rst=YES;
                    
                    [self payAlipayWithpayDic:self.param];
                    //                    }
                }
                if (!rst)
                {
                    [Toast hideToastActivity];
                    [Utils alertMessage:@"生成支付信息失败！"];
                }
            });
        });
        
        
        
        
        
        //        [Utils alertMessage:@"暂未提供该支付功能！"];
    }
    
    
    
    
}
//3 .7	支付(实际支付后调用)
//订单状态在未支付状态下完成支付
//服务器地址	http://10.100.20.28/
//端口	8018
//路径	/OrderPaid
//Http 协议方式	POST
//参数	类型	说明	备注
//ORDERNO	String	订单编号
//LAST_MODIFIED_USER	String	修改人名
//PayFee	Decimal	支付金额
//返回值	说明	备注
//IsSuccess	是否成功
//Message	返回信息


-(void)payCompleteCallback:(id)sender eventData:(id)eventData
{
    BOOL rst=[eventData[@"returncode"] boolValue];

    if (rst)
    {
        [Toast hideToastActivity];
        
//        [Toast makeToastActivity:@"微信支付..." hasMusk:YES];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
//            BOOL success=NO;
//            NSMutableDictionary *resultDict=[[NSMutableDictionary alloc] init];
//            NSDictionary *payParam=@{@"ORDERNO":[NSString stringWithFormat:@"%@",self.param[@"out_trade_no"]],@"LAST_MODIFIED_USER":[NSString stringWithFormat:@"%@",self.param[@"CREATE_USER"]],@"PayFee":[NSString stringWithFormat:@"%@",self.param[@"total_fee"]]};
//            for (int i=0;i<5;i++)
//            {
//                success=[SHOPPING_GUIDE_ITF requestPostUrlName:@"OrderPaid" param:payParam responseAll:resultDict responseMsg:msg];
//                if (success)
//                {
//                    break;
//                }
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [Toast hideToastActivity];
//                if (success)
//                {
                    //[Utils alertMessage:@"支付成功，我们很快为您发货！"];
        
            if (_paycompleteBlock) {
            _paycompleteBlock([NSString stringWithFormat:@"%@",self.param[@"out_trade_no"]]);
            }
//                    PayResultViewController *payResultVC=[[PayResultViewController alloc] initWithNibName:@"PayResultViewController" bundle:nil];
//                    payResultVC.orderCode=[NSString stringWithFormat:@"%@",self.param[@"out_trade_no"]];
        
//                    [self.navigationController pushViewController:payResultVC animated:YES];
//                }
//                else
//                {
//                    //账务不平。比较麻烦
//                    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"支付保存失败！请检查您的付款情况并联系管理员！"];
//                    if (resultDict[@"message"]!=nil)
//                    {
//                        [str appendString:[[NSString alloc] initWithFormat:@"\n【%@】", msg]];
//                    }
//                    [Utils alertMessage:str];
//                }
//            });
//        });
    }
    else
    {
        NSString *msg=eventData[@"msg"];
        [Utils alertMessage:msg];
        [Toast hideToastActivity];
        
    }
}

#pragma mark --支付宝相关
-(void)payAlipayWithpayDic:(NSMutableDictionary *)paydic{
    /*
     *生成订单信息及签名
     *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
     */
    
    NSString *appScheme = @"Wefafa";
    NSString* orderInfo = [self getOrderInfoWithpayDic:paydic];
    NSString* signedString = [self doRsa:orderInfo];
    
    NSLog(@"%@",signedString);
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderInfo, signedString, @"RSA"];
         [Toast hideToastActivity];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if (resultDic)
            {
                //                AliSDKDemo[19493:1011959] reslut = {
                //                    memo = "";
                //                    result = "";
                //                    resultStatus = 6001;
                //                }
                
              
                NSString *resultStatusStr =[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]] ;
                switch ((resultStatusStr.intValue))
                {
                    case 9000:{
                        /*
                         *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
                         */
                        //交易成功
                        //            NSString* key = AlipayPubKey;//  @"签约帐户后获取到的支付宝公钥";
                        //                id<DataVerifier> verifier;
                        //                verifier = CreateRSADataVerifier(key);
                        //                if ([verifier verifyString:result.resultString withSign:result.signString])
                        //                {
                        //验证签名成功，交易结果无篡改
                        NSDictionary *postDic=@{@"tag":@[@"0",@"1",@"2"]};
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"refeshData" object:nil userInfo:postDic];
                        //订单详情需要
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"orderSuccess" object:nil userInfo:postDic];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"requestData" object:nil userInfo:postDic];
                        
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYALICOMPLETE object:nil userInfo:@{@"AlixPayResult":resultDic}];
                        //                }
                        [TalkingData trackEvent:@"我的订单" label:@"支付宝支付(验证签名成功，交易结果无篡改)"];
                    }
                        break;
                    case 8000:
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYFAILURE object:nil userInfo:@{@"AlixPayResult":resultDic}];
                        //支付宝返回原因 正在处理中
                        [Toast makeToast:[resultDic objectForKey:@"result"]];
                        [TalkingData trackEvent:@"我的订单" label:@"支付宝支付错误" parameters:@{@"错误原因": @"支付宝返回原因 正在处理中", @"支付宝返回信息": resultDic? resultDic: @""}];
                        
                        break;
                    case 4000:
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYFAILURE object:nil userInfo:@{@"AlixPayResult":resultDic}];
                        //支付宝返回原因 订单支付失败
                        [Toast makeToast:[resultDic objectForKey:@"result"]];
                        [TalkingData trackEvent:@"我的订单" label:@"支付宝支付错误" parameters:@{@"错误原因": @"支付宝返回原因 订单支付失败", @"支付宝返回信息": resultDic? resultDic: @""}];
                        
                        break;
                    case 6001:
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYFAILURE object:nil userInfo:@{@"AlixPayResult":resultDic}];
                        //支付宝返回原因 用户中途取消
                        [Toast makeToast:@"亲,中途取消"];
                        [TalkingData trackEvent:@"我的订单" label:@"支付宝支付错误" parameters:@{@"错误原因": @"支付宝返回原因 用户中途取消", @"支付宝返回信息": resultDic? resultDic: @""}];
                        
                        break;
                    case 6002:
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYFAILURE object:nil userInfo:@{@"AlixPayResult":resultDic}];
                        //支付宝返回原因 网络连接出错
                        [Toast makeToast:[resultDic objectForKey:@"result"]];
                        [TalkingData trackEvent:@"我的订单" label:@"支付宝支付错误" parameters:@{@"错误原因": @"支付宝返回原因 网络连接出错", @"支付宝返回信息": resultDic? resultDic: @""}];
                        
                        break;
                    default:
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYFAILURE object:nil userInfo:@{@"AlixPayResult":resultDic}];
                        //交易失败
                        [Toast makeToast:[resultDic objectForKey:@"result"]];
                        [TalkingData trackEvent:@"我的订单" label:@"支付宝支付错误" parameters:@{@"错误原因": @"交易失败", @"支付宝返回信息": resultDic? resultDic: @""}];
                        break;
                }
                
            }
            else
            {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYFAILURE object:nil userInfo:@{@"AlixPayResult":@"亲,交易未成功"}];
                [TalkingData trackEvent:@"我的订单" label:@"支付宝支付(未成功)"];
                //失败
                [Toast makeToast:@"亲,交易未成功"];
            }
            
            
            
        }];
    }
    else
    {
         [Toast hideToastActivity];
    }
    
}


-(NSString*)getOrderInfoWithpayDic:(NSMutableDictionary *)dic
{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    order.tradeNO = dic[@"out_trade_no"]; //订单ID（由商家自行制定）
    order.productName = dic[@"body"]; //商品标题
    order.productDescription = @"商品描述"; //商品描述
//    order.amount = [NSString stringWithFormat:@"%.2f",0.01];//total_fee
    order.amount = [NSString stringWithFormat:@"%0.2f",[dic[@"total_fee"] floatValue]];
    
     order.notifyURL = ALIPAYNOTIFYURL;
//    if ( [Globle shareInstance].alipayNotifyUrl != nil) {
//        order.notifyURL =  [Globle shareInstance].alipayNotifyUrl;
//    }
//    else{
//        order.notifyURL = ALIPAYNOTIFYURL;
//    }

    //    order.notifyURL = @"http://weixin.bonwe.com/stylist.web/payment/AlipayNotify.ashx" ; //回调URL
    //    order.notifyURL = @"http://www.mixme.cn/wap/Payment/AlipayNotify.ashx";
    //    微信通知接口，参数编码 TENPAY_NOTIFY_URL支付宝通知接口，参数编码 ALIPAY_NOTIFY_URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";

    
    return [order description];
}

- (NSString *)generateTradeNO
{
    const int N = 15;
    
    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [[NSMutableString alloc] init] ;
//    srand(time(0));
    for (int i = 0; i < N; i++)
    {
        unsigned index = rand() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    return result;
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

-(void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"paymentResultDelegate---%@",result);

}

-(void)payAliCompleteCallback:(id)sender
{
    BOOL rst= YES;
//    [eventData[@"returncode"] boolValue];
    if (rst)
    {
//        [Toast makeToastActivity:@"支付宝支付..." hasMusk:YES];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
//            BOOL success=NO;
//            NSMutableDictionary *resultDict=[[NSMutableDictionary alloc] init];
//            NSDictionary *payParam=@{@"ORDERNO":[NSString stringWithFormat:@"%@",self.param[@"out_trade_no"]],@"LAST_MODIFIED_USER":[NSString stringWithFormat:@"%@",self.param[@"CREATE_USER"]],@"PayFee":[NSString stringWithFormat:@"%@",self.param[@"total_fee"]]};
////            for (int i=0;i<5;i++)
////            {
//                success=[SHOPPING_GUIDE_ITF requestPostUrlName:@"OrderPaid" param:payParam responseAll:resultDict responseMsg:msg];
////                if (success)
////                {
////                    break;
////                }
////            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [Toast hideToastActivity];
//                if (success)
//                {
                    //[Utils alertMessage:@"支付成功，我们很快为您发货！"];
            if (_paycompleteBlock) {
                _paycompleteBlock([NSString stringWithFormat:@"%@",self.param[@"out_trade_no"]]);
            }
//                    PayResultViewController *payResultVC=[[PayResultViewController alloc] initWithNibName:@"PayResultViewController" bundle:nil];
//                    payResultVC.orderCode=[NSString stringWithFormat:@"%@",self.param[@"out_trade_no"]];
//                    [self.navigationController pushViewController:payResultVC animated:YES];
//                }
//                else
//                {
//                    //账务不平。比较麻烦
//                    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"支付保存失败！请检查您的付款情况并联系管理员！"];
//                    if (resultDict[@"message"]!=nil)
//                    {
//                        [str appendString:[[NSString alloc] initWithFormat:@"\n【%@】", msg]];
//                    }
//                    [Utils alertMessage:str];
//                }
//            });
//        });
    }
    else
    {
//        NSString *msg=eventData[@"msg"];
        [Utils alertMessage:@"支付失败"];
        [Toast hideToastActivity];
    }
}


-(void)payAliFailureCallback:(id)sender{
    
    MyOrderViewController *orderVC=[[MyOrderViewController alloc] initWithNibName:@"MyOrderViewController" bundle:nil];
    [self.navigationController pushViewController:orderVC animated:YES];
    
}

- (IBAction)btnPayClick:(id)sender {
    if (self.param != nil) {
        if (![sender isEqualToString:@"直接跳转"]) {
            UIButton *btn=sender;
            [btn setBackgroundColor:[UIColor lightGrayColor]];
            btn.enabled=NO;
        }
        

        [self payreatedMethod];
        
    }else{
        
        if ([_selectedPayType isEqualToString:@"微信支付"]){
            _myblock(@"微信支付");
            
            
        }else{
            _myblock(@"支付宝支付");
            
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

-(void)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
