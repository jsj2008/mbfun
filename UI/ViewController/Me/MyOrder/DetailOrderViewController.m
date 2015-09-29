//
//  DetailOrderViewController.m
//  Wefafa
//
//  Created by fafatime on 14-8-22.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "DetailOrderViewController.h"
#import "Utils.h"
#import "MBShoppingGuideInterface.h"
#import "MyOrderViewTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Toast.h"
#import "NavigationTitleView.h"
#import "OrderViewTableViewCell.h"
#import "SQLiteOper.h"
#import "MyAdderssViewController.h"
#import "PayOrderViewController.h"
#import "AppDelegate.h"
#import "AppSetting.h"
#import "InetAddress.h"
#import "CommMBBusiness.h"
#import "RefundApplyViewController.h"
#import "DetailReturnMoneyViewController.h"
#import "ExpressageViewController.h"
#import "LogisticsViewController.h"
#import "AppraiseViewController.h"
#import "CustomAlertView.h"
#import "ShowPreferentialViewController.h"
#import "PayResultViewController.h"
#import "Globle.h"
#import "LogisticsViewControlle2.h"
#import "OrderModel.h"
#import "SProductDetailViewController.h"
#import "SUtilityTool.h"
#import "JSWebViewController.h"
#import "SDataCache.h"

@interface DetailOrderViewController ()<MyOrderViewTableViewCellDelegate>
{
    NSMutableArray *requestList;
    UITableView *listTableView;
    NSString *returnGoodStateCode;//退货状态
    NSString *one_reapP_ID;
    BOOL isReturnGoods;
    NSMutableArray *createListArray;//根据造型师名称来区分section组(或designerId)
    UIButton *goOrder;//去支付
    UIButton *cancleBtn;//取消订单
    int tapTag;
    int tapSection;
    UIView *bottomView;
    
}

@end

@implementation DetailOrderViewController
@synthesize transDic;
@synthesize transDicOrderModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initView
{

    requestList=[[NSMutableArray alloc]initWithArray:self.transDicOrderModel.detailList];
    goOrder=[UIButton buttonWithType:UIButtonTypeCustom];
    [goOrder setTitle:@"去支付" forState:UIControlStateNormal];
    [goOrder setFrame:CGRectMake(UI_SCREEN_WIDTH/2+10,12.5, 90, 30)];
    goOrder.titleLabel.font=FONT_T4;
    [goOrder setTitleColor:[Utils HexColor:0x3b3b3b Alpha:1] forState:UIControlStateNormal];
//    goOrder.titleLabel.font=[UIFont systemFontOfSize:13.0f];
    [goOrder addTarget:self action:@selector(ordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    goOrder.backgroundColor=[Utils HexColor:0xffde00 Alpha:1];
    goOrder.layer.masksToBounds=YES;
    goOrder.layer.cornerRadius=3;
    [bottomView addSubview:goOrder];
    
    cancleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [cancleBtn setFrame:CGRectMake(UI_SCREEN_WIDTH/2-10-90 ,12.5, 90, 30)];
    [cancleBtn addTarget:self action:@selector(cancleOrderClick:) forControlEvents:UIControlEventTouchUpInside];
    cancleBtn.layer.masksToBounds=YES;
    cancleBtn.layer.cornerRadius=3;
    cancleBtn.titleLabel.font=FONT_T4;
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    cancleBtn.titleLabel.font=[UIFont systemFontOfSize:13.0f];
    cancleBtn.backgroundColor=[UIColor blackColor];
    [bottomView addSubview:cancleBtn];

    UIButton *returnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setTitle:@"申请退货" forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(UI_SCREEN_WIDTH-70*3-15-15-15 ,8.5, 70, 26)];
    returnBtn.layer.borderColor =[[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1]CGColor];
    returnBtn.layer.borderWidth = 1.0;
    returnBtn.hidden=YES;
    [returnBtn addTarget:self action:@selector(returnOrderClick:) forControlEvents:UIControlEventTouchUpInside];
    [returnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    returnBtn.titleLabel.font=[UIFont systemFontOfSize:13.0f];
    returnBtn.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
//    [bottomView addSubview:returnBtn];
    headShowView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH,65+20+63)];//+43*2106+43+43*3+15
    //收货地址
    UIView *detailShowView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 65)];
    [detailShowView setBackgroundColor:[UIColor whiteColor]];
    [headShowView addSubview:detailShowView];
    [headShowView setBackgroundColor:[Utils HexColor:0xf2f2f2 Alpha:1]];
    UILabel *nameLabe=[[UILabel alloc]initWithFrame:CGRectMake(17, 8,UI_SCREEN_WIDTH-17*2, 20)];
    const char *c = [[Utils getSNSString:[NSString stringWithFormat:@"%@",self.transDicOrderModel.receiver]]cStringUsingEncoding:NSUTF8StringEncoding];
    NSString *strName = [[NSString alloc] initWithCString:c encoding:NSUTF8StringEncoding];
    nameLabe.text=[NSString stringWithFormat:@"%@  %@",strName,[Utils getSNSString:[NSString stringWithFormat:@"%@",self.transDicOrderModel.teL_PHONE]]];
    nameLabe.backgroundColor=[UIColor clearColor];
    nameLabe.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
    nameLabe.font=FONT_t4;
    [detailShowView addSubview:nameLabe];
    /*
    UILabel *telLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabe.frame.origin.x, nameLabe.frame.origin.y+nameLabe.frame.size.height, 200, nameLabe.frame.size.height-5)];
    telLabel.textAlignment=NSTextAlignmentLeft;
    telLabel.text=[NSString stringWithFormat:@"手机号码: %@",[Utils getSNSString:self.transDicOrderModel.teL_PHONE]];
    telLabel.backgroundColor=[UIColor clearColor];
    telLabel.textColor=[Utils HexColor:0x353535 Alpha:1];
    telLabel.font=[UIFont systemFontOfSize:13.0f];
    [detailShowView addSubview:telLabel];
*/
//    UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabe.frame.origin.x, telLabel.frame.origin.y+telLabel.frame.size.height+2, UI_SCREEN_WIDTH-nameLabe.frame.origin.x, nameLabe.frame.size.height)];
    UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabe.frame.origin.x, nameLabe.frame.origin.y+nameLabe.frame.size.height+5, UI_SCREEN_WIDTH-2*nameLabe.frame.origin.x, nameLabe.frame.size.height)];
    addressLabel.textAlignment=NSTextAlignmentLeft;
    addressLabel.text=[NSString stringWithFormat:@"%@%@%@%@%@",[Utils getSNSString:self.transDicOrderModel.country],[Utils getSNSString:self.transDicOrderModel.province],[Utils getSNSString:self.transDicOrderModel.city],[Utils getSNSString:self.transDicOrderModel.county],[Utils getSNSString:self.transDicOrderModel.address]];
    addressLabel.backgroundColor=[UIColor clearColor];
    addressLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
    addressLabel.font=FONT_t4;
    if ([addressLabel.text length]>12)
    {
        addressLabel.lineBreakMode = NSLineBreakByCharWrapping;
        addressLabel.numberOfLines = 0;
        [addressLabel sizeToFit];
    }
    else
    {
        addressLabel.numberOfLines = 1;
    }
    addressLabel.textAlignment=NSTextAlignmentLeft;
    [detailShowView addSubview:addressLabel];
 
    /*
    //优惠
    UILabel *showInDisamountLb=[[UILabel alloc]initWithFrame:CGRectMake(15,43*2, UI_SCREEN_WIDTH-50, 43)];
    showInDisamountLb.backgroundColor=[UIColor clearColor];
    showInDisamountLb.textColor=[Utils HexColor:0x353535 Alpha:1];
    showInDisamountLb.font=[UIFont systemFontOfSize:13.0f];
    showInDisamountLb.textAlignment=NSTextAlignmentLeft;
    showInDisamountLb.text=[NSString stringWithFormat:@"商品优惠:%@",promotionName];
    showInDisamountLb.userInteractionEnabled=YES;
    [showInvoiceView addSubview:showInDisamountLb];
    UITapGestureRecognizer *gestGo=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoDetailInDis)];
    [showInDisamountLb addGestureRecognizer:gestGo];
    UIImageView *showImgV=[[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-50+30,43*2+15, 10, 15)];
    [showImgV setImage:[UIImage imageNamed:@"back--icon"]];
    [showInvoiceView addSubview:showImgV];
    UIImageView *invoiceLineL=[[UIImageView alloc]initWithFrame:CGRectMake(0,43*3, UI_SCREEN_WIDTH, 1)];
    [invoiceLineL setBackgroundColor:[UIColor colorWithRed:208/255.0 green:209.0/255.0 blue:204.0/255.0 alpha:1]];
    [showInvoiceView addSubview:invoiceLineL];
    */
    
    //订单编号 states 日期
    UIView *secondShow=[[UIView alloc]initWithFrame:CGRectMake(0, detailShowView.frame.size.height+detailShowView.frame.origin.y+20, UI_SCREEN_WIDTH, 63)];//detailShowView
    secondShow.backgroundColor=[UIColor whiteColor];
    [headShowView addSubview:secondShow];
    
    UILabel *statesLabel=[[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-150-15, 0, 150, 63)];
    statesLabel.backgroundColor=[UIColor clearColor];
    statesLabel.textAlignment=NSTextAlignmentRight;
    statesLabel.text=[NSString stringWithFormat:@"%@",self.transDicOrderModel.statusName];
    statesLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
    statesLabel.font=FONT_T4;
    [secondShow addSubview:statesLabel];

    UILabel *orderNum=[[UILabel alloc]initWithFrame:CGRectMake(15,8, UI_SCREEN_WIDTH-100, 20)];
    orderNum.backgroundColor=[UIColor clearColor];
    orderNum.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
    orderNum.font=FONT_t5;
    orderNum.textAlignment=NSTextAlignmentLeft;
    orderNum.text=[NSString stringWithFormat:@"订单编号: %@",self.transDicOrderModel.orderno];
    [secondShow addSubview:orderNum];
//    NSString *dateStr= [CommMBBusiness getdate:self.transDicOrderModel.creatE_DATE];
    NSString *dateStr = [NSString stringWithFormat:@"%@",self.transDicOrderModel.creatE_DATE];
    
    
    UILabel *orderDate=[[UILabel alloc]initWithFrame:CGRectMake(15, orderNum.frame.origin.y+orderNum.frame.size.height+5, UI_SCREEN_WIDTH-100, 20)];
    orderDate.backgroundColor=[UIColor clearColor];
    orderDate.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
    orderDate.font=FONT_t5;
    orderDate.textAlignment=NSTextAlignmentLeft;
    orderDate.text=[NSString stringWithFormat:@"订单日期: %@",dateStr];
    [secondShow addSubview:orderDate];
 
    UIImageView *lineImgVTs=[[UIImageView alloc]initWithFrame:CGRectMake(0,63, UI_SCREEN_WIDTH, 0.5)];
    [lineImgVTs setBackgroundColor:[Utils HexColor:0xd9d9d9 Alpha:1]];
    [secondShow addSubview:lineImgVTs];
    
      //底部view
    bottVw=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 100+25+100+43)];//43//100+20
    [bottVw setBackgroundColor:[Utils HexColor:0xf2f2f2 Alpha:1]];
                       
    NSString *all=[NSString stringWithFormat:@"%@",self.transDicOrderModel.amount];//[self.transDic objectForKey:@"orderTotalPrice"]
    NSString *transmo = [NSString stringWithFormat:@"%@",self.transDicOrderModel.fee];
    NSString *disMoney = [NSString stringWithFormat:@"%@",self.transDicOrderModel.diS_AMOUNT];
    NSString *payMoney = [NSString stringWithFormat:@"%@",self.transDicOrderModel.orderTotalPrice];
    NSArray *detailList = self.transDicOrderModel.detailList;
    float bonusMoney=0.00;
    NSString *funMoney = [NSString stringWithFormat:@"%@",self.transDicOrderModel.bonus];
    bonusMoney = [funMoney floatValue];
                       
    if ([detailList count]==0) {
            return;
        }
    
    NSString *invoiceTitleStr=[NSString stringWithFormat:@"%@",self.transDicOrderModel.invoicE_TITLE];
    NSString *senD_REQUIRE = [NSString stringWithFormat:@"%@",self.transDicOrderModel.senD_REQUIRE];
    // promList //y优惠详情
    NSArray *promList=[[NSArray alloc]init];
    promList = self.transDicOrderModel.promList;
    NSString *promotionName=@"";
    if([promList count]>0)
    {
        OrderModelPromListInfo *promListInfo =promList[0];
        NSString *promListInfoSt = [NSString stringWithFormat:@"%@",promListInfo.promotioN_NAME];
        promotionName = [NSString stringWithFormat:@"%@",[Utils getSNSString:promListInfoSt]];
    }

    
    //发票
    UIView *showInvoiceView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, 50*2)];
    [showInvoiceView setBackgroundColor:[UIColor whiteColor]];
    [bottVw addSubview:showInvoiceView];
    //
    UILabel *showInTimeLb=[[UILabel alloc]initWithFrame:CGRectMake(17,0, UI_SCREEN_WIDTH-30, 50)];
    showInTimeLb.backgroundColor=[UIColor clearColor];
    showInTimeLb.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
    showInTimeLb.font=FONT_t3;
    showInTimeLb.textAlignment=NSTextAlignmentLeft;
    showInTimeLb.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:senD_REQUIRE]];
    if(showInTimeLb.text.length==0)
    {
        showInTimeLb.text=@"任何时间";
    }
    [showInvoiceView addSubview:showInTimeLb];
    UIImageView *invoiceLine=[[UIImageView alloc]initWithFrame:CGRectMake(17,50, UI_SCREEN_WIDTH, 0.5)];
    [invoiceLine setBackgroundColor:[Utils HexColor:0xd9d9d9 Alpha:1]];
    [showInvoiceView addSubview:invoiceLine];
    //发票详情
    UILabel *showInDetailLb=[[UILabel alloc]initWithFrame:CGRectMake(15,50, UI_SCREEN_WIDTH-30, 50)];
    showInDetailLb.backgroundColor=[UIColor clearColor];
    showInDetailLb.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
    showInDetailLb.font=FONT_t3;
    showInDetailLb.textAlignment=NSTextAlignmentLeft;
    showInDetailLb.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:invoiceTitleStr]];
    if (showInDetailLb.text.length==0) {
        showInDetailLb.text=@"暂无发票";
    }
    [showInvoiceView addSubview:showInDetailLb];
//    UIImageView *invoiceLineT=[[UIImageView alloc]initWithFrame:CGRectMake(0,43*2, UI_SCREEN_WIDTH, 1)];
//    [invoiceLineT setBackgroundColor:[UIColor colorWithRed:208/255.0 green:209.0/255.0 blue:204.0/255.0 alpha:1]];
//    [showInvoiceView addSubview:invoiceLineT];
    
    //优惠view
    UIView *showCouponView=[[UIView alloc]initWithFrame:CGRectMake(0, 20+100+20, UI_SCREEN_WIDTH, 125+5)];
    [showCouponView setBackgroundColor:[UIColor whiteColor]];
    [bottVw addSubview:showCouponView];
    UILabel *allMoneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(17,5,100, 25)];//15,0, 60, 25)
    allMoneyLabel.text=@"商品总价:";
    allMoneyLabel.textAlignment=NSTextAlignmentLeft;
    allMoneyLabel.font=FONT_t3;
    allMoneyLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];;
    allMoneyLabel.backgroundColor=[UIColor clearColor];
    [showCouponView addSubview:allMoneyLabel];
    
    UILabel*allMoney=[[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-10-100, allMoneyLabel.frame.origin.y, 100, 25)];
    allMoney.font=FONT_t3;
    allMoney.textAlignment=NSTextAlignmentRight;
    allMoney.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSRMBMoneyWithoutMark:all]];
    allMoney.textColor=[Utils HexColor:0x3b3b3b Alpha:1];;
    allMoney.backgroundColor=[UIColor clearColor];
    [showCouponView addSubview:allMoney];
    
    UILabel *transMoneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(allMoneyLabel.frame.origin.x,allMoneyLabel.frame.origin.y+allMoneyLabel.frame.size.height, allMoneyLabel.frame.size.width, allMoneyLabel.frame.size.height)];
    transMoneyLabel.text=@"运费:";
    transMoneyLabel.textAlignment=NSTextAlignmentLeft;
    transMoneyLabel.font=FONT_t3;
    transMoneyLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];;
    transMoneyLabel.backgroundColor=[UIColor clearColor];
    [showCouponView   addSubview:transMoneyLabel];
    
    UILabel*trans=[[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-10-100, transMoneyLabel.frame.origin.y, 100, 25)];
    trans.font=FONT_t3;
    trans.textAlignment=NSTextAlignmentRight;
    trans.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSRMBMoneyWithoutMark:transmo]];
    trans.textColor=[Utils HexColor:0x3b3b3b Alpha:1];;
    trans.backgroundColor=[UIColor clearColor];
    [showCouponView  addSubview:trans];
    
    UILabel *dismountLabel=[[UILabel alloc]initWithFrame:CGRectMake(allMoneyLabel.frame.origin.x,transMoneyLabel.frame.origin.y+transMoneyLabel.frame.size.height, allMoneyLabel.frame.size.width, allMoneyLabel.frame.size.height)];
    dismountLabel.text=@"活动优惠金额:";
    dismountLabel.textAlignment=NSTextAlignmentLeft;
    dismountLabel.font=FONT_t3;
    dismountLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];;
    dismountLabel.backgroundColor=[UIColor clearColor];
    [showCouponView addSubview:dismountLabel];
    
    UILabel *funLabel =[[UILabel alloc]initWithFrame:CGRectMake(allMoneyLabel.frame.origin.x,dismountLabel.frame.origin.y+dismountLabel.frame.size.height, allMoneyLabel.frame.size.width, allMoneyLabel.frame.size.height)];
    funLabel.text=@"范票抵用金额:";
    funLabel.textAlignment=NSTextAlignmentLeft;
    funLabel.font=FONT_t3;
    funLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];;
    funLabel.backgroundColor=[UIColor clearColor];
    [showCouponView addSubview:funLabel];
    
    
    UILabel *payAmountLabel =[[UILabel alloc]initWithFrame:
    CGRectMake(allMoneyLabel.frame.origin.x,funLabel.frame.origin.y+funLabel.frame.size.height, allMoneyLabel.frame.size.width, allMoneyLabel.frame.size.height)];
    payAmountLabel.text=@"支付金额:";
    payAmountLabel.textAlignment=NSTextAlignmentLeft;
    payAmountLabel.font=FONT_t3;
    payAmountLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];;
    payAmountLabel.backgroundColor=[UIColor clearColor];
    [showCouponView addSubview:payAmountLabel];
    
    UILabel *disamountMoneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-10-100, dismountLabel.frame.origin.y, 100, 25)];
    disamountMoneyLabel.font=FONT_t3;
    disamountMoneyLabel.textAlignment=NSTextAlignmentRight;
    disamountMoneyLabel.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSRMBMoneyWithoutMark:disMoney]];
    disamountMoneyLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];;
    disamountMoneyLabel.backgroundColor=[UIColor clearColor];
    [showCouponView addSubview:disamountMoneyLabel];
    
    
    UILabel *funMoneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-100-10, funLabel.frame.origin.y, 100, 25)];
    funMoneyLabel.font=FONT_t3;
    funMoneyLabel.textAlignment=NSTextAlignmentRight;
    funMoneyLabel.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSRMBMoneyWithoutMark:funMoney]];
    funMoneyLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];;
    funMoneyLabel.backgroundColor=[UIColor clearColor];
    [showCouponView addSubview:funMoneyLabel];
    
    
    UILabel *payMoneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-10-100, payAmountLabel.frame.origin.y, 100, 25)];
    payMoneyLabel.font=FONT_t3;
    payMoneyLabel.textAlignment=NSTextAlignmentRight;
    payMoneyLabel.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSRMBMoneyWithoutMark:payMoney]];
    payMoneyLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];;
    payMoneyLabel.backgroundColor=[UIColor clearColor];
    [showCouponView addSubview:payMoneyLabel];
//
    [showCouponView setFrame:CGRectMake(0, showCouponView.frame.origin.y, UI_SCREEN_WIDTH, payAmountLabel.frame.size.height+payAmountLabel.frame.origin.y+20)];
    [bottVw setFrame:CGRectMake(bottVw.frame.origin.x, bottVw.frame.origin.y, UI_SCREEN_WIDTH, showCouponView.frame.size.height+showCouponView.frame.origin.y+20)];
    


    NSString *statesN= [NSString stringWithFormat:@"%@",self.transDicOrderModel.status];//订单状态
    NSString *judge_status = [NSString stringWithFormat:@"%@",self.transDicOrderModel.judgeStatus];//评价状态
    canModifyOrder=NO;
    int statusNum;
    statusNum = [statesN intValue];
    switch (statusNum) {
        case 0://未付款  这里才有取消订单
        {
            canModifyOrder=YES;
            cancleBtn.hidden=NO;
//            [cancleBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
            [cancleBtn setTitleColor:[Utils HexColor:0xffffff Alpha:1] forState:UIControlStateNormal];
            [goOrder setTitle:@"去支付" forState:UIControlStateNormal];
        }
            break;
        case 1://已付款
        {
            cancleBtn.hidden=YES;
            goOrder.hidden=YES;
            [goOrder setTitle:@"联系客服" forState:UIControlStateNormal];
            [cancleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            
        }
            break;
        case 2://已审核
        {
            cancleBtn.hidden=YES;
            goOrder.hidden=YES;
            [goOrder setTitle:@"联系客服" forState:UIControlStateNormal];
            [cancleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            
        }
            break;
        case 3://已分配 生成交货单
        {
            cancleBtn.hidden=YES;
            goOrder.hidden=YES;
            [goOrder setTitle:@"联系客服" forState:UIControlStateNormal];
            [cancleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            
        }
            break;
        case 4://拣货中
        {
            cancleBtn.hidden=YES;
            goOrder.hidden=YES;
            [goOrder setTitle:@"联系客服" forState:UIControlStateNormal];
            [cancleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        }
            break;
        case 5://已发货(配送中)
        {
            cancleBtn.hidden=NO;
            [cancleBtn setTitle:@"订单跟踪" forState:UIControlStateNormal];
            [goOrder setTitle:@"确认收货" forState:UIControlStateNormal];
            
        }
            break;
        case 6://已收货
        {
            cancleBtn.hidden=NO;
            [cancleBtn setTitle:@"订单跟踪" forState:UIControlStateNormal];
            [goOrder setTitle:@"评价" forState:UIControlStateNormal];
            returnBtn.hidden=NO;
            
//            goOrder.hidden=YES;
//            [cancleBtn setFrame:goOrder.frame];
            
            switch ([judge_status intValue]) {
                case 1:
                {
                    [goOrder setTitle:@"评价" forState:UIControlStateNormal];
                }
                    break;
                case 2:
                {
                    [goOrder setTitle:@"评价" forState:UIControlStateNormal];
                }
                    break;
                case 3:
                {
                    [goOrder setTitle:@"查看评价" forState:UIControlStateNormal];
                }
                    break;
                    
                default:
                    break;
            }

            
        }
            break;
        case 7://取消申请(订单取消中)
        {
            cancleBtn.hidden=YES;
            goOrder.hidden=YES;
            
        }
            break;
        case 8://已取消（）
        {
            cancleBtn.hidden=YES;
            goOrder.hidden=YES;
        }
            break;
        case 9://已关闭
        {
            cancleBtn.hidden=YES;
            goOrder.hidden=YES;
        }
            break;
        case 10://
        {
            goOrder.hidden=NO;
            cancleBtn.hidden=NO;
            [cancleBtn setTitle:@"订单跟踪" forState:UIControlStateNormal];
            [goOrder setTitle:@"评价" forState:UIControlStateNormal];
            returnBtn.hidden=YES;
//            goOrder.hidden=YES;
//            [cancleBtn setFrame:goOrder.frame];
            
            switch ([judge_status intValue]) {
                case 1:
                {
                    [goOrder setTitle:@"评价" forState:UIControlStateNormal];
                }
                    break;
                case 2:
                {
                    [goOrder setTitle:@"评价" forState:UIControlStateNormal];
                }
                    break;
                case 3:
                {
                    [goOrder setTitle:@"查看评价" forState:UIControlStateNormal];
                }
                    break;
                    
                default:
                    break;
            }

        }
            break;
        case 11://退货申请
        {
            cancleBtn.hidden=YES;
            goOrder.hidden=YES;
        }
            break;
        case 12://退货中
        {
            cancleBtn.hidden=YES;
            goOrder.hidden=YES;
        }
            break;
        case 13://退货完成
        {
            cancleBtn.hidden=YES;
            goOrder.hidden=YES;
        }
            break;
        case 14://退款申请中
        {
            cancleBtn.hidden=YES;
            goOrder.hidden=YES;
        }
            break;
            
        default:
            break;
    }
    
    NSArray *pamentListArray= self.transDicOrderModel.paymentList;
    if ([pamentListArray count]>0) {
        OrderModelPaymentListInfo *paymentListInfo=[pamentListArray firstObject];
        switch ([paymentListInfo.status integerValue]) {
            case 0:
            {
                payAmountLabel.text=@"应付金额:";
              
            }
                break;
            case 1:
            {
                payAmountLabel.text=@"支付金额:";
            }
                break;
            case 2:
            {
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    self.title=@"订单详情";
}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavbar];
    [_headView setBackgroundColor:[UIColor blackColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshGoodList) name:@"requestData" object:nil];
    NSMutableArray *detailListArray=[NSMutableArray arrayWithArray:self.transDicOrderModel.detailList];
    createListArray=[NSMutableArray new];

    //根据造型师来分组
    for (int k=0; k<[detailListArray count]; k++) {
        NSMutableArray *tempArry= [NSMutableArray new];
        [tempArry addObject:detailListArray[k]];
        OrderModelDetailListInfo *detailListInfoData = detailListArray[k];
        NSString *designerID =[Utils getSNSString:[NSString stringWithFormat:@"%@",detailListInfoData.detailInfo.designerId]];
        for (int j=k+1; j<[detailListArray count]; j++) {
            OrderModelDetailListInfo *detailListInfo = detailListArray[j];
            NSString *tempDesignerID=[Utils getSNSString:[NSString stringWithFormat:@"%@",detailListInfo.detailInfo.designerId]];
            if ([designerID isEqualToString:tempDesignerID]) {
                [tempArry addObject:detailListArray[j]];
                [detailListArray removeObjectAtIndex:j];
                j=j-1;
            }
        }
//        [createListArray addObject:tempArry];
    }
    NSString *dateStr= [CommMBBusiness getdate:self.transDicOrderModel.creatE_DATE];
    NSString *statesN= [NSString stringWithFormat:@"%@",self.transDicOrderModel.status];//订单状态
    BOOL isShowBtn = false;
    switch ([statesN integerValue]) {
        case 0://未付款  这里才有取消订单
        {
            isShowBtn = YES;
        }
            break;
        case 1://已付款
        {
            isShowBtn=NO;
        }
            break;
        case 2://已审核
        {
            isShowBtn=NO;
        }
            break;
        case 3://已分配 生成交货单
        {
            isShowBtn=NO;
            
        }
            break;
        case 4://拣货中
        {
            isShowBtn=NO;
        }
            break;
        case 5://已发货(配送中)
        {
            isShowBtn=YES;
            
        }
            break;
        case 6://已收货
        {
            isShowBtn=YES;
            
        }
            break;
        case 7://取消申请(订单取消中)
        {
            isShowBtn=NO;
        
        }
            break;
        case 8://已取消（）
        {
          isShowBtn=NO;
        }
            break;
        case 9://已关闭
        {
            isShowBtn=NO;
        }
            break;
        case 10://
        {
          isShowBtn=YES;
        }
            break;
        case 11://退货申请
        {
             isShowBtn=NO;
        }
            break;
        case 12://退货中
        {
          isShowBtn=NO;
        }
            break;
        case 13://退货完成
        {
            isShowBtn=NO;
        }
            break;
        case 14://退款申请中
        {
            isShowBtn=NO;
        }
            break;
            
        default:
        {
             isShowBtn=NO;
        }
            break;
    }
    bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-55, UI_SCREEN_WIDTH, 55)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    bottomView.userInteractionEnabled=YES;
    [self.view addSubview:bottomView];
    listTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64-55) style:UITableViewStyleGrouped];
    if (!isShowBtn) {
        [listTableView setFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64)];
        bottomView.hidden=YES;
    }
    listTableView.delegate=self;
    listTableView.dataSource=self;
    listTableView.backgroundColor = TITLE_BG;
    [self.view addSubview:listTableView];
    
    [self initView];
    //判断是否是退货退款需要用到
    tapTag=0;
    tapSection =0;

   
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_HEIGHT, 30+15)];
    footView.backgroundColor=TABLEVIEW_BACKGROUND_COLOR;
   
    UILabel *orderDate=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, UI_SCREEN_WIDTH, 15)];
    orderDate.backgroundColor=[UIColor clearColor];
    orderDate.textColor=[Utils HexColor:0x6b6b6b Alpha:1];
    orderDate.font=[UIFont systemFontOfSize:11.0f];
    orderDate.textAlignment=NSTextAlignmentLeft;
    orderDate.text=[NSString stringWithFormat:@"订单日期:%@",dateStr];
    [footView addSubview:orderDate];
    
    listTableView.tableFooterView = bottVw;// footView;
    listTableView.tableHeaderView = headShowView;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderSuccess) name:@"orderSuccess" object:nil];
    
    [self refreshGoodList];
    

}
-(void)viewWillDisappear:(BOOL)animated
{
    
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"orderSuccess" object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"requestData" object:nil];
    tapTag=0;
    tapSection =0;
}
-(void)orderSuccess
{
    goOrder.hidden=YES;
    cancleBtn.hidden=YES;
}
-(void)refreshGoodList
{

//    NSString *orderNumber = [NSString stringWithFormat:@"%@",self.transDicOrderModel.orderno];
    NSString *orderId = [NSString stringWithFormat:@"%@",  self.transDicOrderModel.idStr];
    NSMutableDictionary *resAllDic =[NSMutableDictionary new];
    NSMutableString *returnMsg=nil;
    //根据订单号refresh查询订单信息// get  15026959928 111111
//    [HttpRequest orderGetRequestPath:nil methodName:@"OrderFilter" params:@{@"orderId":orderId,@"userId":sns.ldap_uid} success:^(NSDictionary *dict){
//        NSLog(@"dic－－－－－－－－%@",dict);
//        
//    } failed:^(NSError *error) {
//        
//    }];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([SHOPPING_GUIDE_ITF requestGetUrlName:@"OrderFilter" param:@{@"orderId":orderId,@"userId":sns.ldap_uid} responseAll:resAllDic responseMsg:returnMsg]){
            NSLog(@"return------%@",resAllDic);
            
            [requestList removeAllObjects];
            [createListArray removeAllObjects];
            
            NSMutableArray *modelArray = [NSMutableArray arrayWithArray:[OrderModel modelArrayForDataArray:resAllDic[@"results"]]];
            self.transDicOrderModel = [modelArray firstObject];
            dispatch_async(dispatch_get_main_queue(),^{
                
                requestList=[[NSMutableArray alloc]initWithArray:self.transDicOrderModel.detailList];
                

                for (int k=0; k<[requestList count]; k++) {
                    NSMutableArray *tempArry= [NSMutableArray new];
                    [tempArry addObject:requestList[k]];
                    OrderModelDetailListInfo *detailListInfoData = requestList[k];
                    NSString *designerID =[Utils getSNSString:[NSString stringWithFormat:@"%@",detailListInfoData.detailInfo.designerId]];
                 
                    for (int j=k+1; j<[requestList count]; j++) {
                        OrderModelDetailListInfo *detailListInfo = requestList[j];
                        NSString *tempDesignerID=[Utils getSNSString:[NSString stringWithFormat:@"%@",detailListInfo.detailInfo.designerId]];
                        if ([designerID isEqualToString:tempDesignerID]) {
                            [tempArry addObject:requestList[j]];
                            [requestList removeObjectAtIndex:j];
                            j=j-1;
                        }
                    }
                    
                    [createListArray addObject:tempArry];
                }
                [listTableView reloadData];
                [Toast hideToastActivity];
            });
         
        }
    });
}
-(void)clickAddress:(id)sender
{
    if (canModifyOrder) {
        MyAdderssViewController *myAdd = [[MyAdderssViewController alloc]initWithNibName:@"MyAdderssViewController" bundle:nil];
        [self.navigationController pushViewController:myAdd animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    if (section==[requestList count]-1) {
//        return bottVw.frame.size.height+5;
        return 0.0000001;
        
    }
    else{
         return 0.0000001;
    }

}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 35)];
    UILabel *names =[[UILabel alloc]initWithFrame:CGRectMake(15,0, 50, 35)];
    names.text=@"造型师:";
    names.textColor=[Utils HexColor:0x999999 Alpha:1];
    names.font=FONT_t4;
    names.backgroundColor=[UIColor clearColor];
    [sectionView addSubview:names];
    
    UILabel *namessh =[[UILabel alloc]initWithFrame:CGRectMake(50+15,0, 150, 35)];
//    NSString *desigen=[NSString stringWithFormat:@"%@",self.transDic[@"detailList"][section][@"detailInfo"][@"designerName"]];
    /*
    NSString *desigen = [NSString stringWithFormat:@"%@",createListArray[section][0][@"detailInfo"][@"designerName"]];
     */
    OrderModelDetailListInfo *detailListInfoData = createListArray[section][0];
    
    NSString *desigen = [NSString stringWithFormat:@"%@",detailListInfoData.detailInfo.designerName];
    namessh.text=[Utils getSNSString:desigen];
    namessh.font=FONT_t4;
    namessh.textColor=[Utils HexColor:0x999999 Alpha:1];
    namessh.backgroundColor=[UIColor clearColor];
    
    if(namessh.text.length==0)
    {
       names.text=@"单品:";
    }
    else
    {
       names.text=@"造型师:";  
    }
    
    
    [sectionView addSubview:namessh];
    
//    UILabel *accountNum=[[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-15-50, 43, 50, 43)];
//    accountNum.textAlignment=NSTextAlignmentRight;
//    accountNum.textColor=[Utils HexColor:0x353535 Alpha:1];
//    accountNum.font=[UIFont systemFontOfSize:13.0f];
//    accountNum.text=[NSString stringWithFormat:@"共%@件",self.transDic[@"qty"]];
//    [sectionView addSubview:accountNum];
    
//    UILabel *statesLabel=[[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-15-150, 0, 150, 43)];
//    statesLabel.backgroundColor=[UIColor clearColor];
//    statesLabel.text=[NSString stringWithFormat:@"%@",[self.transDic objectForKey:@"statusName"]];
// 
//    statesLabel.textColor=[UIColor colorWithRed:250.0/255.0 green:132.0/255.0 blue:139.0/255.0 alpha:1];
//    statesLabel.textAlignment=NSTextAlignmentRight;
//    statesLabel.font=[UIFont systemFontOfSize:13.0f];
//    [sectionView addSubview:statesLabel];

    return sectionView;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==[requestList count]-1) {
        return bottVw;
    }
    else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 85;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [createListArray count];
//    return [requestList count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [createListArray[section] count];
//    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyOrderViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[MyOrderViewTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.selected = NO;
     OrderModelDetailListInfo *detailListInfoData = createListArray[indexPath.section][indexPath.row];
     OrderModelDetailInfo *detailInfoDic =detailListInfoData.detailInfo;
     OrderModelProductListInfo *proudctList =detailListInfoData.proudctList;
    
    //退款操作信息.
    cell.goodNameLabel.text=[Utils getSNSString:proudctList.productInfo.proD_NAME];
//    if ([cell.goodNameLabel.text length]>12){
//        cell.goodNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
//        cell.goodNameLabel.numberOfLines = 1;//不分行
////        [cell.goodNameLabel sizeToFit];
//    }
//    else{
//        cell.goodNameLabel.numberOfLines = 1;
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.orderNoLabel.text= [NSString stringWithFormat:@"商品编号: %@",[Utils getSNSString:[NSString stringWithFormat:@"%@",proudctList.productInfo.proD_CLS_NUM]]];

    cell.colcorLabel.text=[NSString stringWithFormat:@"颜色：%@ 尺码：%@",[Utils getSNSString:proudctList.productInfo.coloR_NAME],[Utils getSNSString:proudctList.productInfo.speC_NAME]];
    
    NSString *imgUrlstr = [[Utils getSNSString:[NSString stringWithFormat:@"%@",proudctList.productInfo.coloR_FILE_PATH]]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.goodImgView downloadImageUrl:[CommMBBusiness changeStringWithurlString:imgUrlstr size:SNS_IMAGE_Size] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:DEFAULT_LOADING_IMAGE];
    
    NSString *price=[NSString stringWithFormat:@"%@", detailInfoDic.acT_PRICE];
//    float priceFloat=[price floatValue];
    NSString *numm=[NSString stringWithFormat:@"%@",detailInfoDic.qty];
    //单价
    cell.priceLabel.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSRMBMoneyWithoutMark:price]];
   
    //    数量
    cell.numberLabel.text=[NSString stringWithFormat:@"x%@",[Utils getSNSString:numm]];
    //整个订单的状态
    NSString *statesN= [NSString stringWithFormat:@"%@",self.transDicOrderModel.status];
    NSArray *refundAppInfoList=[NSArray new];
    
    //    新的判断方式
    NSString *stateDetailInfo=[NSString stringWithFormat:@"%@",detailInfoDic.state];
    BOOL  isMoney=NO;//订单明晰
    switch ([stateDetailInfo intValue]) {
        case -1://作废
        {
        }
            break;
        case 1://正常
        {
        }
            break;
        case 2://退款
        {
            
            refundAppInfoList =[NSArray arrayWithArray:self.transDicOrderModel.refundAppInfoList];
            isMoney=YES;
        }
            break;
        case 3://退货
        {
            refundAppInfoList =[NSArray arrayWithArray:self.transDicOrderModel.returnInfoList];
            isMoney=NO;
        }
            break;
            
        default:
            break;
    }
    OrderModelRefundAppInfoListInfo *showRefundDicOrderModel;
    OrderModelReturnInfoListInfo*showReturnDicOrderModel;
    NSString *returnStatusName=@"";
    NSString *returnStateName=@"";
    NSString *returnStatus=@"";
    NSString *returnState=@"";
   // 退货单的状态(已取消 -1 已提交 0 已审批 1 已退货 2 已收货 3 已入库4 退货已退回 5 已退款 6 已拒绝 9)
   // 退款单的状态(已取消 -1 申请 0, 已审批 1 已拒绝2 已退款3)
    //要根据reapP_ID 来查找退货款信息
    NSString *goodProd_id=[NSString stringWithFormat:@"%@",detailInfoDic.reapP_ID];
    NSString *returN_TYPE =nil;
    for (int a=0; a<[refundAppInfoList count]; a++) {
        
//        if (isMoney) {
            OrderModelRefundAppInfoListInfo *refundAppInfoListInfo = refundAppInfoList[a];
            
            NSString *reapId=[NSString stringWithFormat:@"%@",refundAppInfoListInfo.idStr];
            if ([reapId isEqualToString:goodProd_id]) {
          
                showRefundDicOrderModel = refundAppInfoList[a];
                returnStatusName =[NSString stringWithFormat:@"%@",showRefundDicOrderModel.statusName];
                returnStatus =[NSString stringWithFormat:@"%@",showRefundDicOrderModel.status];
                
                returnStateName = [NSString stringWithFormat:@"%@",showReturnDicOrderModel.stateName];
                returnState= [NSString stringWithFormat:@"%@",refundAppInfoListInfo.state];
                returN_TYPE = [NSString stringWithFormat:@"%@",refundAppInfoListInfo.returN_TYPE];
                break;
            }
//        }
//        else
//        {
//            OrderModelReturnInfoListInfo *refundAppInfoListInfo = refundAppInfoList[a];
//            NSString *reapId=[NSString stringWithFormat:@"%@",refundAppInfoListInfo.idStr];
//            if ([reapId isEqualToString:goodProd_id]) {
//  
//                showReturnDicOrderModel =refundAppInfoList[a];
//                returnStateName = [NSString stringWithFormat:@"%@",showReturnDicOrderModel.stateName];
//                returnState= [NSString stringWithFormat:@"%@",showReturnDicOrderModel.state];
//                break;
//            }
//            
//        }

    }
    NSString *returnStatesName;
    //1退款2 退货
    // 退货单的状态(已取消 -1 已提交 0 已审批 1 已退货 2 已收货 3 已入库4 退货已退回 5 已退款 6 已拒绝 9)
    // 退款单的状态(已取消 -1 已申请 0, 已审批 1 已拒绝2 已退款3)
    if ([returN_TYPE isEqualToString:@"1"]) {
        if ([returnStatus intValue]==-1) {
            //退款状态
            returnStatesName= [NSString stringWithFormat:@"已取消"];
            returnGoodStateCode = [NSString stringWithFormat:@"%@",returnStatus];
//            returnStatesName = [Utils getSNSString:returnStatesName];
        }
        else
        {
            returnStatesName= [NSString stringWithFormat:@"退款详情"];
            returnGoodStateCode = [NSString stringWithFormat:@"%@",returnStatus];
//            returnStatesName = [Utils getSNSString:returnStatesName];
        }
        [cell.cancleReply setTitle:@"取消退款" forState:UIControlStateNormal];
        /*
        switch ([returnStatus intValue]) {
            case -1:
            {
                //退款状态
                returnStatesName= [NSString stringWithFormat:@"已取消"];
                returnGoodStateCode = [NSString stringWithFormat:@"%@",returnStatus];
                returnStatesName = [Utils getSNSString:returnStatesName];
            }
                break;
            case 0:
            {
                //退款状态
                returnStatesName= [NSString stringWithFormat:@"退款详情"];
                returnGoodStateCode = [NSString stringWithFormat:@"%@",returnStatus];
                returnStatesName = [Utils getSNSString:returnStatesName];
            }
                break;
            case 1:
            {
                //退款状态
                returnStatesName= [NSString stringWithFormat:@"已审批"];
                returnGoodStateCode = [NSString stringWithFormat:@"%@",returnStatus];
                returnStatesName = [Utils getSNSString:returnStatesName];
            }
                break;
            case 2:
            {
                //退款状态
                returnStatesName= [NSString stringWithFormat:@"已拒绝"];
                returnGoodStateCode = [NSString stringWithFormat:@"%@",returnStatus];
                returnStatesName = [Utils getSNSString:returnStatesName];
            }
                break;
            case 3:
            {
                //退款状态
                returnStatesName= [NSString stringWithFormat:@"已退款"];
                returnGoodStateCode = [NSString stringWithFormat:@"%@",returnStatus];
                returnStatesName = [Utils getSNSString:returnStatesName];
            }
                break;
            default:
                break;
        }
        */
    }
    else if([returN_TYPE isEqualToString:@"2"])
    {
        if ([returnState intValue]==-1) {
            
            returnStatesName= [NSString stringWithFormat:@"已取消"];
            //取消退货后 reapid为0 ；找到不到对应的list
            returnGoodStateCode = [NSString stringWithFormat:@"%@",returnState];
            
//            returnStatesName = [Utils getSNSString:returnStatesName];
            
            [cell.cancleReply setTitle:@"取消退货" forState:UIControlStateNormal];
        }
        else
        {
            returnStatesName= [NSString stringWithFormat:@"退货详情"];
            //取消退货后 reapid为0 ；找到不到对应的list
            returnGoodStateCode = [NSString stringWithFormat:@"%@",returnState];
            
//            returnStatesName = [Utils getSNSString:returnStatesName];
            
            [cell.cancleReply setTitle:@"取消退货" forState:UIControlStateNormal];
        }
    }
    else
    {
      returnGoodStateCode = @"1000";//如果是没做处理的只展示申请退款或者申请退货
    }

   /*
    //退款
    if ([[Utils getSNSString:returnStatusName] length]>0) {
        //退款状态
        returnStatesName= [NSString stringWithFormat:@"%@",returnStatusName];
        returnGoodStateCode = [NSString stringWithFormat:@"%@",returnStatus];
        returnStatesName = [Utils getSNSString:returnStatesName];
   
        [cell.cancleReply setTitle:@"取消退款" forState:UIControlStateNormal];
    }
    else if ([[Utils getSNSString:returnStateName] length]>0)
    {

        returnStatesName= [NSString stringWithFormat:@"%@",returnStateName];
        //取消退货后 reapid为0 ；找到不到对应的list
        returnGoodStateCode = [NSString stringWithFormat:@"%@",returnState];
        
        returnStatesName = [Utils getSNSString:returnStatesName];

        [cell.cancleReply setTitle:@"取消退货" forState:UIControlStateNormal];
    }
    else
    {
        returnGoodStateCode = @"1000";//如果是没做处理的只展示申请退款或者申请退货
    }
    */

    int statusNum=[statesN intValue];//订单状态
    switch (statusNum) {
        case 0://未付款  这里才有取消订单
        {
        }
            break;
        case 1://已付款
        {
            cell.returnBtn.hidden=YES;
            cell.cancleReply.hidden=YES;
//            if ([Utils getSNSString:returnStatesName].length==0||[returnGoodStateCode isEqualToString:@"2"]){
//                
//                [cell.returnBtn setTitle:@"申请退款" forState:UIControlStateNormal];
//                cell.cancleReply.hidden=YES;
//            }
//            else{
//
//                [cell.returnBtn setTitle:returnStatesName forState:UIControlStateNormal];
//            }
  
        }
            break;
        case 2://已审核
        {
            cell.returnBtn.hidden=NO;
            if ([Utils getSNSString:returnStatesName].length==0||[returnGoodStateCode isEqualToString:@"2"]) {
                [cell.returnBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                cell.cancleReply.hidden=YES;
            }
            else{
                [cell.returnBtn setTitle:returnStatesName forState:UIControlStateNormal];
            }
            //已经审核状态下不可以取消退款退货
            cell.cancleReply.hidden=YES;
        }
            break;
        case 3://已分配 生成交货单
        {
            cell.returnBtn.hidden=NO;
            if ([Utils getSNSString:returnStatesName].length==0||[returnGoodStateCode isEqualToString:@"2"]) {
                [cell.returnBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                cell.cancleReply.hidden=YES;
            }
            else{
                [cell.returnBtn setTitle:returnStatesName forState:UIControlStateNormal];
            }
        }
            break;
        case 4://拣货中
        {
            cell.returnBtn.hidden=NO;
            if ([Utils getSNSString:returnStatesName].length==0||[returnGoodStateCode isEqualToString:@"2"]) {
                [cell.returnBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                cell.cancleReply.hidden=YES;
            }
            else{
                [cell.returnBtn setTitle:returnStatesName forState:UIControlStateNormal];
            }
        }
            break;
        case 5://已发货(配送中)
        {
//            cell.returnBtn.hidden=YES;
            cell.returnBtn.hidden=NO;
            //已拒绝改为申请退货状态
            if (returnStatesName.length==0||[returnStatesName isEqualToString:@""]||[returnGoodStateCode isEqualToString:@"9"]) {
                [cell.returnBtn setTitle:@"申请退货" forState:UIControlStateNormal];
                cell.cancleReply.hidden=YES;
            }
            else{
                [cell.returnBtn setTitle:returnStatesName forState:UIControlStateNormal];
            }
            //判断 收到货了---走退货 没收到货----走退款
        }
            break;
        case 6://已收货
        {
            cell.returnBtn.hidden=NO;
            //已拒绝改为申请退货状态
            if (returnStatesName.length==0||[returnStatesName isEqualToString:@""]||[returnGoodStateCode isEqualToString:@"9"]) {
                [cell.returnBtn setTitle:@"申请退货" forState:UIControlStateNormal];
                cell.cancleReply.hidden=YES;
            }
            else{
                [cell.returnBtn setTitle:returnStatesName forState:UIControlStateNormal];
            }
          
        }
            break;
        case 7://取消申请(订单取消中)
        {

        }
            break;
        case 8://已取消（）
        {

        }
            break;
        case 9://已关闭
        {

            
//            [cell.returnBtn setTitle:@"查看详情" forState:UIControlStateNormal];
//            if (returnStatesName.length==0||[returnStatesName isEqualToString:@""]||[returnGoodStateCode isEqualToString:@"9"]) {
//                [cell.returnBtn setTitle:@"申请退货" forState:UIControlStateNormal];
//                cell.cancleReply.hidden=YES;
//            }
//            else{
            if (returnStatesName.length==0)
            {
                cell.returnBtn.hidden=YES;
            }
            else
            {
                cell.returnBtn.hidden=NO;
                [cell.returnBtn setTitle:returnStatesName forState:UIControlStateNormal];
            }
//            }

        }
            break;
        case 10://
        {
            cell.returnBtn.hidden=NO;
            //已拒绝改为申请退货状态
            if (returnStatesName.length==0||[returnStatesName isEqualToString:@""]||[returnGoodStateCode isEqualToString:@"9"]) {
                [cell.returnBtn setTitle:@"申请退货" forState:UIControlStateNormal];
                cell.cancleReply.hidden=YES;
            }
            else{
                [cell.returnBtn setTitle:returnStatesName forState:UIControlStateNormal];
            }
 
        }
            break;
        case 11://退货申请
        {
            
        }
            break;
        case 12://退货中
        {
            
        }
            break;
        case 13://退货完成
        {
            
        }
            break;
        case 14://退款申请中
        {
            
        }
            break;
            
        default:
            break;
    }
 
    if ([returnGoodStateCode isEqualToString:@"0"]&&![cell.returnBtn.titleLabel.text isEqualToString:@"申请退款"]) {
        cell.cancleReply.hidden=NO;
        cell.cancleReply.tag=indexPath.row;
        cell.cancleReply.sectionTag=indexPath.section;
        [cell.cancleReply addTarget:self action:@selector(cancleReturnGood:) forControlEvents:UIControlEventTouchUpInside];
    }
    //已审批也可以取消退款
//    if ([returnGoodStateCode isEqualToString:@"1"]&&![cell.returnBtn.titleLabel.text isEqualToString:@"申请退款"]) {
//        cell.cancleReply.hidden=NO;
//        cell.cancleReply.tag=indexPath.row;
//        cell.cancleReply.sectionTag=indexPath.section;
//        [cell.cancleReply addTarget:self action:@selector(cancleReturnGood:) forControlEvents:UIControlEventTouchUpInside];
//    }
    cell.cancleReply.hidden=YES;
    
    cell.returnBtn.tag=indexPath.row;
    cell.returnBtn.sectionTag=indexPath.section;
    cell.delegate=self;
    //配置来控制 取消退货退款是否走
    if ([U_ORDER_RETURN_OPEN isEqualToString:@"0"]) {
        cell.cancleReply.hidden=YES;
    }
    else
    {
        
    }
//    [cell.returnBtn addTarget:self
//                       action:@selector(returnOrderClick:)
//             forControlEvents:UIControlEventTouchUpInside];

     return cell;
}
- (void)MyOrderViewTableViewCellReturnButtonAction:(OrderBtn*)sender;
{
    [self returnOrderClick:sender];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (createListArray.count <= 0 || [createListArray[indexPath.section] count] <= 0) {
        return;
    }
    OrderModelDetailListInfo *detailListInfoData = createListArray[indexPath.section][indexPath.row];
    OrderModelProductListInfo *proudctList =detailListInfoData.proudctList;
    SProductDetailViewController *itemVC = [[SProductDetailViewController alloc]init];
//    itemVC.productID = proudctList.productInfo.lM_PROD_CLS_ID;//传递的是商品款id
    itemVC.productID = [NSString stringWithFormat:@"%@",proudctList.productInfo.proD_CLS_NUM];
    
    [self.navigationController pushViewController:itemVC animated:YES];
}
-(void)cancleReturnGood:(UIButton *)sender
{
    OrderBtn *btn=(OrderBtn *)sender;
    /*
    NSString *statesN= [NSString stringWithFormat:@"%@",[self.transDic objectForKey:@"status"]];
    NSDictionary *dic =[NSDictionary dictionaryWithDictionary:createListArray[btn.sectionTag][btn.tag]];
    NSDictionary *detailInfoDic=[NSDictionary dictionaryWithDictionary:dic[@"detailInfo"]];
    one_reapP_ID = [NSString stringWithFormat:@"%@",detailInfoDic[@"reapP_ID"]];
     */
    NSString *statesN= [NSString stringWithFormat:@"%@",self.transDicOrderModel.status];
    OrderModelDetailListInfo *detailListInfoData = createListArray[btn.sectionTag][btn.tag];
    one_reapP_ID = [NSString stringWithFormat:@"%@",detailListInfoData.detailInfo.reapP_ID];
    NSString *message=nil;
    
    if ([statesN isEqualToString:@"1"]||[btn.titleLabel.text isEqualToString:@"取消退款"]) {
        isReturnGoods = NO;
        message=@"确定要取消退款吗?";
 
    }else{
        isReturnGoods = YES;
        message=@"确定要取消退货吗?";
    }
 
    UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:@"取消", nil];
    showAlert.tag=101;
    [showAlert show];
    
}
-(void)returnOrderClick:(UIButton *)sender
{
    OrderBtn *ordBtn=(OrderBtn *)sender;
    NSString *statesN= [NSString stringWithFormat:@"%@",self.transDicOrderModel.status];
    OrderModelDetailListInfo *detailListInfoData = createListArray[ordBtn.sectionTag][ordBtn.tag];
   
    OrderModelDetailInfo *detailInfoDic=detailListInfoData.detailInfo;
    
    if ([statesN isEqualToString:@"6"]||[statesN isEqualToString:@"10"]){

        DetailReturnMoneyViewController *detailReturn=[[DetailReturnMoneyViewController alloc]initWithNibName:@"DetailReturnMoneyViewController" bundle:nil];
        NSString *detailState=[NSString stringWithFormat:@"%@",detailListInfoData.detailInfo.state];
        switch ([detailState intValue]) {
            case 1://正常
            {
                RefundApplyViewController *returnOrder=[[RefundApplyViewController alloc]initWithNibName:@"RefundApplyViewController" bundle:nil];
                /*
                returnOrder.collocationDic =self.transDicOrderModel;
                returnOrder.goodDic=detailListInfoData;
                 */
                returnOrder.collocationDicOrderModel =self.transDicOrderModel;
                returnOrder.goodDicOrderModel=detailListInfoData;
                returnOrder.titleStr=@"申请退货";
//                [self pushViewController:returnOrder animated:YES];
                [self pushController:returnOrder animated:YES];
                return;
                
                
            }
                break;
            case 2://退款
            {
                detailReturn.titleStr=@"退款详情";
                detailReturn.colloctionDicOrderModel =self.transDicOrderModel;
                detailReturn.detaiGoodDicOrderModel=detailListInfoData;
//                [self.navigationController pushViewController:detailReturn animated:YES];
                  [self pushController:detailReturn animated:YES];
                
            }
                break;
            case 3://退货
            {
                detailReturn.titleStr=@"退货详情";
                detailReturn.colloctionDicOrderModel =self.transDicOrderModel;
                detailReturn.detaiGoodDicOrderModel=detailListInfoData;
//                [self.navigationController pushViewController:detailReturn animated:YES];
                    [self pushController:detailReturn animated:YES];
            }
                break;
                
            default:
            {
//                detailReturn.colloctionDicOrderModel =self.transDicOrderModel;
//                detailReturn.detaiGoodDicOrderModel=detailListInfoData;
//                [self pushController:detailReturn animated:YES];
                
                
                
                RefundApplyViewController *returnOrder=[[RefundApplyViewController alloc]initWithNibName:@"RefundApplyViewController" bundle:nil];
                /*
                 returnOrder.collocationDic =self.transDicOrderModel;
                 returnOrder.goodDic=detailListInfoData;
                 */
                returnOrder.collocationDicOrderModel =self.transDicOrderModel;
                returnOrder.goodDicOrderModel=detailListInfoData;
                returnOrder.titleStr=@"申请退货";
                //                [self pushViewController:returnOrder animated:YES];
                [self pushController:returnOrder animated:YES];
            }
                break;
        }
        /*
        detailReturn.colloctionDic =self.transDicOrderModel;
        detailReturn.detailGoodDic=detailListInfoData;
        */

        
    }
    else if ([statesN isEqualToString:@"5"]) {//
        //要加判断是或否是退货还是退款
        DetailReturnMoneyViewController *detailReturn=[[DetailReturnMoneyViewController alloc]initWithNibName:@"DetailReturnMoneyViewController" bundle:nil];
        NSString *detailState=[NSString stringWithFormat:@"%@",detailInfoDic.state];
        switch ([detailState intValue]) {
            case 1://正常
            {
                tapTag =(int)ordBtn.tag;
                tapSection =(int)ordBtn.sectionTag;
 
                //待收货直接进入申请退货页面中 需要在申请退货天蝎快递信息中加入货物单
                RefundApplyViewController *returnOrder=[[RefundApplyViewController alloc]initWithNibName:@"RefundApplyViewController" bundle:nil];
                /*
                returnOrder.collocationDic =self.transDicOrderModel;
                returnOrder.goodDic=detailListInfoData;
                 */
                returnOrder.collocationDicOrderModel =self.transDicOrderModel;
                returnOrder.goodDicOrderModel=detailListInfoData;
                returnOrder.titleStr=@"申请退货";
//                [self.navigationController pushViewController:returnOrder animated:YES];
                 [self pushController:returnOrder animated:YES];
                return;
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否收到货" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                alert.tag=999;
                [alert show];
                return;
                
            }
                break;
            case 2://退款
            {
                detailReturn.titleStr=@"退款详情";
                detailReturn.colloctionDicOrderModel =self.transDicOrderModel;
                detailReturn.detaiGoodDicOrderModel=detailListInfoData;
                 [self pushController:detailReturn animated:YES];
//                [self.navigationController pushViewController:detailReturn animated:YES];
            }
                break;
            case 3://退货
            {
                detailReturn.titleStr=@"退货详情";
                detailReturn.colloctionDicOrderModel =self.transDicOrderModel;
                detailReturn.detaiGoodDicOrderModel=detailListInfoData;
                  [self pushController:detailReturn animated:YES];
//                [self.navigationController pushViewController:detailReturn animated:YES];
            }
                break;
                
            default:
            {
                detailReturn.colloctionDicOrderModel =self.transDicOrderModel;
                detailReturn.detaiGoodDicOrderModel=detailListInfoData;
                  [self pushController:detailReturn animated:YES];
//                [self.navigationController pushViewController:detailReturn animated:YES];
            }
                break;
        }
        /*
        detailReturn.colloctionDic =self.transDicOrderModel;
        detailReturn.detailGoodDic=detailListInfoData;
        */

        //        }
    }
    else{
        if([sender.titleLabel.text isEqualToString:@"申请退款"])
        {
            RefundApplyViewController *returnOrder=[[RefundApplyViewController alloc]initWithNibName:@"RefundApplyViewController" bundle:nil];
            returnOrder.titleStr=@"申请退款";
            /*
             returnOrder.collocationDic =self.transDicOrderModel;
             returnOrder.goodDic=detailListInfoData;
             */
            returnOrder.collocationDicOrderModel =self.transDicOrderModel;
            returnOrder.goodDicOrderModel=detailListInfoData;
              [self pushController:returnOrder animated:YES];
//            [self.navigationController pushViewController:returnOrder animated:YES];
        }
        else{
            DetailReturnMoneyViewController *detailReturn=[[DetailReturnMoneyViewController alloc]initWithNibName:@"DetailReturnMoneyViewController" bundle:nil];
            detailReturn.titleStr=@"退款详情";
            /*
             detailReturn.colloctionDic =self.transDicOrderModel;
             detailReturn.detailGoodDic=detailListInfoData;
             */
            detailReturn.colloctionDicOrderModel =self.transDicOrderModel;
            detailReturn.detaiGoodDicOrderModel=detailListInfoData;
               [self pushController:detailReturn animated:YES];
//            [self.navigationController pushViewController:detailReturn animated:YES];
        }
    }
 }

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    [Toast makeToastActivity:@"正在取消,请稍后..." hasMusk:NO];
//    NSMutableString *returnMessage=[[NSMutableString alloc]init];
    if (alertView.tag==101) {
        [Toast hideToastActivity];
        if (buttonIndex==0)
        {
            //退货申请单id 退货申请人用户id
            NSDictionary *param=@{@"ID":one_reapP_ID,@"userid":sns.ldap_uid};
            
//            NSMutableDictionary *returnDic;
            NSString *returnGood;
            NSDictionary *postDic;
            if (isReturnGoods) {
                returnGood=@"OrderReturnCancel";
                postDic=@{@"tag":@[@"0",@"3",@"4"]};
                
            }else{
                returnGood=@"RefundAppCancel";
                postDic=@{@"tag":@[@"0",@"2",@"3"]};
            }
 
            [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCOrder methodName:returnGood params:param success:^(NSDictionary *dict) {
                if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
                {
                    id data = [dict objectForKey:@"results"];
                    if ([data isKindOfClass:[NSArray class]])
                    {
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [Toast hideToastActivity];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"refeshData" object:nil userInfo:postDic];
                        [self refreshGoodList];
                    });


                }
            } failed:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [Utils alertMessage:[NSString stringWithFormat:@"取消失败"]];
                    [Toast hideToastActivity];
                });
                
            }];
        }
        else
        {
            [Toast hideToastActivity];
        }
  
    }
    else if(alertView.tag==999)
    {
        [Toast hideToastActivity];
        OrderModelDetailListInfo *detailListInfoData = createListArray[tapSection][tapTag];
        if (buttonIndex==0)
        {
            //退款
            RefundApplyViewController *returnOrder=[[RefundApplyViewController alloc]initWithNibName:@"RefundApplyViewController" bundle:nil];
            returnOrder.collocationDicOrderModel =self.transDicOrderModel;
            returnOrder.goodDicOrderModel=detailListInfoData;
            
            returnOrder.titleStr=@"申请退款";
            [self.navigationController pushViewController:returnOrder animated:YES];
            
        }
        else
        {
            //退货
            RefundApplyViewController *returnOrder=[[RefundApplyViewController alloc]initWithNibName:@"RefundApplyViewController" bundle:nil];
            returnOrder.collocationDicOrderModel =self.transDicOrderModel;
            returnOrder.goodDicOrderModel=detailListInfoData;
            returnOrder.titleStr=@"申请退货";
            [self.navigationController pushViewController:returnOrder animated:YES];
        }
    }
    else
    {
        if (buttonIndex==0)
        {
//            NSString *orderNo=[NSString stringWithFormat:@"%@",self.transDicOrderModel.orderno];
//            
//            NSDictionary *param=@{@"orderno":orderNo,
//                                  @"last_modified_user":sns.myStaffCard.nick_name};
//            
//            [HttpRequest postRequestPath:kMBServerNameTypeOrder methodName:@"OrderCancel" params:param success:^(NSDictionary *dict) {
//                if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
//                {
//                    id data = [dict objectForKey:@"results"];
//                    if ([data isKindOfClass:[NSArray class]])
//                    {
//                        
//                    }
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [Toast hideToastActivity];
//                        NSDictionary *postDic=@{@"tag":@[@"0",@"1"]};
//                        
//                        [[NSNotificationCenter defaultCenter]postNotificationName:@"refeshData" object:nil userInfo:postDic];
//                        [self.navigationController popViewControllerAnimated:YES];
//                    });
//                }
//            } failed:^(NSError *error) {
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [Utils alertMessage:[NSString stringWithFormat:@"取消失败"]];
//                    [Toast hideToastActivity];
//                });
//                
//            }];
            NSString *orderId = [NSString stringWithFormat:@"%@",self.transDicOrderModel.idStr];
            NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
    
            NSDictionary *param=@{@"orderId":orderId,
                                  @"token":userToken};

            [HttpRequest getRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"OrderCancel" params:param success:^(NSDictionary *dict) {
            
                if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
                {
                    id data = [dict objectForKey:@"results"];
                    if ([data isKindOfClass:[NSArray class]])
                    {
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Toast hideToastActivity];
                        NSDictionary *postDic=@{@"tag":@[@"0",@"1"]};
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"refeshData" object:nil userInfo:postDic];
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
                
                
            } failed:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [Utils alertMessage:[NSString stringWithFormat:@"操作失败"]];
                    [Toast hideToastActivity];
                });
                
                
            }];
            
        }
        else
        {
            [Toast hideToastActivity];
        }
    }
  
}
-(void)cancleOrderClick:(UIButton*)click
{
    NSMutableString *returnMessage=[[NSMutableString alloc]init];

    NSString *orderNo=[NSString stringWithFormat:@"%@",self.transDicOrderModel.orderno];
    NSDictionary *param=@{@"orderno":orderNo,
                          @"last_modified_user":sns.myStaffCard.nick_name};
    NSString *cancleFile;
    if([click.titleLabel.text isEqualToString:@"取消订单"])
    {
          cancleFile=@"OrderCancel";
        UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"确定要取消该订单吗?"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:@"取消", nil];
        [showAlert show];

        return;
        
    }
    else if ([click.titleLabel.text isEqualToString:@"订单跟踪"])
    {
        cancleFile=@"OperationInfoFilter";
        param = @{@"orderno":orderNo,
                  @"UserId":sns.ldap_uid};
//        LogisticsViewController *logist=[[LogisticsViewController alloc]initWithNibName:@"LogisticsViewController" bundle:nil];
//        logist.messageDic=self.transDic;
//        [self.navigationController pushViewController:logist animated:YES];
        LogisticsViewControlle2 *logist=[LogisticsViewControlle2 new];

        logist.messageDicOrderModel =self.transDicOrderModel;
        
        [self.navigationController pushViewController:logist animated:YES];

        return;
    }
    
    [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCOrder methodName:cancleFile params:param success:^(NSDictionary *dict) {
        if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
        {
            id data = [dict objectForKey:@"results"];
            if ([data isKindOfClass:[NSArray class]])
            {
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast hideToastActivity];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failed:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Utils alertMessage:[NSString stringWithFormat:@"操作失败"]];
            [Toast hideToastActivity];
        });
        
    }];
    
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if ([SHOPPING_GUIDE_ITF requestPostUrlName:cancleFile param:param responseAll:nil responseMsg:returnMessage])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast hideToastActivity];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utils alertMessage:[NSString stringWithFormat:@"%@",returnMessage]];
                [Toast hideToastActivity];
            });
        }
        
    });
  */
}
-(void)gotoDetailInDis
{
    ShowPreferentialViewController *showPreVC=[[ShowPreferentialViewController alloc]initWithNibName:@"ShowPreferentialViewController" bundle:nil];
    /*
    showPreVC.detailPreferentArray = self.transDic[@"promList"];
     */
    showPreVC.detailPreferentArray = self.transDicOrderModel.promList;
    
    [self.navigationController pushViewController:showPreVC animated:YES];
    
}
-(void)ordBtnClick:(UIButton *)sender
{
   
    NSString *titleString = [NSString stringWithFormat:@"%@",sender.titleLabel.text];
    NSString *stringFile;
   /*
    NSString *orderNo=[NSString stringWithFormat:@"%@",[self.transDic objectForKey:@"orderno"]];
    */
    NSString *orderNo=[NSString stringWithFormat:@"%@",self.transDicOrderModel.orderno];
    if([titleString isEqualToString:@"去支付"])
    {
        
        NSDictionary *postDic=@{@"tag":@[@"0",@"1",@"2"]};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refeshData" object:nil userInfo:postDic];
//        PayOrderViewController *payOrderVC=[[PayOrderViewController alloc]initWithNibName:@"PayOrderViewController" bundle:nil];
        //add by miao 3.5 解决直接跳转支付
        PayOrderViewController *payOrderVC= [PayOrderViewController sharedPayOrderViewController];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payAliCompleteCallback:) name:NOTICE_PAYALICOMPLETE object:nil];
        
        [payOrderVC payOrderVCPayCompleteBlock:^(id sender) {
            
//            PayResultViewController *payResultVC=[[PayResultViewController alloc] initWithNibName:@"PayResultViewController" bundle:nil];
//            payResultVC.orderCode= sender;
//            [self.navigationController pushViewController:payResultVC animated:YES];
            [self performSelector:@selector(canShowPraiseBox) withObject:nil afterDelay:3.0];
            NSString *webUr=[NSString stringWithFormat:@"%@?orderId=%@",HTML_ORDER_SUCCESS,sender];
            JSWebViewController *webCV= [[JSWebViewController alloc] initWithUrl:webUr];
            webCV.isPayResult=YES;
            [self.navigationController pushViewController:webCV animated:YES];
        }];
        //支付金额
        NSString *disamount=[NSString stringWithFormat:@"%@",self.transDicOrderModel.diS_AMOUNT];
        disamount = [Utils getSNSString:disamount];
        NSString * fee =[NSString stringWithFormat:@"%@",self.transDicOrderModel.fee];
        fee = [Utils getSNSString:fee];
        float summery=[[Utils getSNSFloat:self.transDicOrderModel.amount] floatValue]+[fee floatValue]-[disamount floatValue];
        
        NSString *all=[NSString stringWithFormat:@"%@",self.transDicOrderModel.orderTotalPrice];
        summery = [all floatValue];
        
        payOrderVC.param=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"有范订单%@",self.transDicOrderModel.orderno],@"body", self.transDicOrderModel.orderno,@"out_trade_no",@(summery),@"total_fee",sns.ldap_uid,@"UserId",[InetAddress getLocalHost],@"spbill_create_ip",sns.myStaffCard.nick_name,@"CREATE_USER",nil];
        payOrderVC.paymentList = self.transDicOrderModel.paymentList;

        return;
        
    }else if ([titleString isEqualToString:@"申请退款"])
    {
        stringFile=@"OrderRefund";
        
    }else if ([titleString isEqualToString:@"确认收货"])
    {
 
        stringFile = @"OrderConfirm";
        
    }else if ([titleString isEqualToString:@"申请退货"])
    {
        stringFile = @"OrderReturn";
        
    }else if ([titleString isEqualToString:@"删除订单"])
    {
        
    }else if ([titleString isEqualToString:@"联系客服"])
    {
        
    }else if ([titleString rangeOfString:@"评价"].location !=NSNotFound)
    {
        AppraiseViewController *appraiseVC=[[AppraiseViewController alloc]initWithNibName:@"AppraiseViewController" bundle:nil];
        NSArray *detailList=[NSArray arrayWithArray:self.transDicOrderModel.detailList];
        OrderModelDetailListInfo *detailListInfoData = detailList[0];
        NSString *proD_ID =  [NSString stringWithFormat:@"%@",detailListInfoData.detailInfo.proD_ID];
        appraiseVC.orderArray=detailList;
        appraiseVC.messageOrderModel=self.transDicOrderModel;
        appraiseVC.prodectid=proD_ID;
        [self.navigationController pushViewController:appraiseVC animated:YES];
        return;
    }
    
    

    NSString *orderId = [NSString stringWithFormat:@"%@",self.transDicOrderModel.idStr];
    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
    
    NSDictionary *param=@{@"orderId":orderId,
                          @"token":userToken};
    
    [HttpRequest getRequestPath:kMBServerNameTypeNoWXSCOrder methodName:stringFile params:param success:^(NSDictionary *dict) {
        
        if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast hideToastActivity];
                       [self performSelector:@selector(canShowPraiseBox) withObject:nil afterDelay:3.0];
                NSDictionary *postDic=@{@"tag":@[@"0",@"3",@"4"]};
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refeshData" object:nil userInfo:postDic];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } failed:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Utils alertMessage:[NSString stringWithFormat:@"操作失败"]];
            [Toast hideToastActivity];
        });
    }];
}
-(void)backHome:(UIButton *)sender
{
      [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController  popToRootViewControllerAnimated:YES];
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
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                [Toast hideToastActivity];
        //                if (success)
        //                {
//        [Utils alertMessage:@"支付成功，我们很快为您发货！"];
        
//        PayResultViewController *payResultVC=[[PayResultViewController alloc] initWithNibName:@"PayResultViewController" bundle:nil];
//        payResultVC.orderCode = [NSString stringWithFormat:@"%@",self.transDicOrderModel.orderno];
//        [self.navigationController pushViewController:payResultVC animated:YES];
        
        
        NSString *webUr=[NSString stringWithFormat:@"%@?orderId=%@",HTML_ORDER_SUCCESS,self.transDicOrderModel.orderno];
        JSWebViewController *webCV= [[JSWebViewController alloc] initWithUrl:webUr];
        webCV.isPayResult=YES;
        [self.navigationController pushViewController:webCV animated:YES];
        
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
-(void)canShowPraiseBox
{
    [SUTILITY_TOOL_INSTANCE showPraiseBox];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
