
//
//  MyOrderViewController.m
//  Wefafa
//
//  Created by mac on 14-8-2.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MyOrderViewController.h"
#import "Utils.h"
#import "Base.h"
#import "MBShoppingGuideInterface.h"
#import "OrderViewTableViewCell.h"
#import "DetailOrderViewController.h"
#import "Toast.h"
#import "PullDragTableView.h"
#import "PullingRefreshTableView.h"
#import "UIImageView+WebCache.h"
#import "JSON.h"
#import "MyOrderTableView.h"
#import "NavigationTitleView.h"
#import "MBTabsView.h"
#import "SQLiteOper.h"
#import "AttendCustomButton.h"
#import "MBCustomClassifyModelView.h"
#import "PayOrderViewController.h"
#import "AppDelegate.h"
#import "AppSetting.h"
#import "InetAddress.h"
#import "CommMBBusiness.h"
#import "RefundApplyViewController.h"
#import "LogisticsViewController.h"
#import "AppraiseViewController.h"
#import "OrderModel.h"
#import "CustomAlertView.h"
#import "MJRefresh.h"
#import "PayResultViewController.h"
#import "SUtilityTool.h"
#import "SMineViewController.h"
#import "LogisticsViewControlle2.h"
#import "MyReturnViewController.h"

#import "TalkingData.h"
#import "OrderModel.h"
#import "JSWebViewController.h"
#import "HttpRequest.h"
#import "SDataCache.h"
#import "MyShoppingTrollyViewController.h"

@interface MyOrderViewController ()
{
    NSMutableArray *requestList;

//    NSMutableArray *stateSListArray;
    UIScrollView *backScrollView;
    MBCustomClassifyModelView *customClassifyModelV;
    NSInteger touchTag;//点中的时顶部的状态
    AttendCustomButton *otherBtn;
    UIImageView *noDataImgView;
    MyOrderTableView *listTableView;
    MyOrderTableView *unOrderListTableView;
    MyOrderTableView *unSendFoodLisTableView;
    MyOrderTableView *unreceiveFoodListTableView;
    MyOrderTableView *unReturnListTableView;
    NSString *cancleTitleString;
    NSDictionary *showMessageCancle;
    NSMutableArray *unOrderList;
    NSMutableArray *unSendList;
    NSMutableArray *unReceiveList;
    NSMutableArray *unReturnList;
    NSMutableArray *showOneClick;
    BOOL canRefresh;
    NSLock *refreshLock;
    
    NSInteger _pageIndex;
    
    UIView *placeholdView;
    UIAlertView *_alertview;
    
    OrderModel *showMessageCancleOrderModel;
}
@property(nonatomic,strong)NSDictionary *transDic;
@end

@implementation MyOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [Toast hideToastActivity];
}

-(void)initTableView
{
    _pageIndex = 0;
    listTableView=[[MyOrderTableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH,backScrollView.frame.size.height) style:UITableViewStyleGrouped];
    listTableView.dataArray=requestList;
    listTableView.cellDefaultHeight=84;
    listTableView.isUnReceived=NO;
    listTableView.tag=0;
    [listTableView.onLoadNewMessage addListener:self selector:@selector(tableview_OnLoadNewMessage:eventData:)];
//    [listTableView.onLoadMoreMessage addListener:self selector:@selector(tableview_OnLoadMoreMessage:eventData:)];
    [listTableView addFooterWithTarget:self action:@selector(tableview_OnLoadMoreMessage:)];
    [listTableView.onDidSelectedRow  addListener:self selector:@selector(tv_OnDidSelected:RowMessage:)];
    [listTableView.onDidCancleRow addListener:self selector:@selector(tv_OnDidCancled:RowMessage:)];
    [listTableView.onDidOrderRow addListener:self selector:@selector(tv_OnDidOrder:RowMessage:)];
    [listTableView.onDicTransRow addListener:self selector:@selector(tv_OnDidTrans:RowMessage:)];
    
    [backScrollView addSubview:listTableView];
    
    
    //                            NSMutableArray *unOrder=[NSMutableArray arrayWithArray:[self getStatesArrayWithTouchTag:1]];
    unOrderListTableView=[[MyOrderTableView alloc]initWithFrame:CGRectMake( UI_SCREEN_WIDTH,0, UI_SCREEN_WIDTH,backScrollView.frame.size.height) style:UITableViewStyleGrouped];
    unOrderListTableView.tag=1;
    unOrderListTableView.dataArray=unOrderList;
    unOrderListTableView.cellDefaultHeight=84;
    unOrderListTableView.isUnReceived=NO;
    [unOrderListTableView.onLoadNewMessage addListener:self selector:@selector(tableview_OnLoadNewMessage:eventData:)];
//    [unOrderListTableView.onLoadMoreMessage addListener:self selector:@selector(tableview_OnLoadMoreMessage:eventData:)];
    [unOrderListTableView addFooterWithTarget:self action:@selector(tableview_OnLoadMoreMessage:)];
    [unOrderListTableView.onDidSelectedRow  addListener:self selector:@selector(tv_OnDidSelected:RowMessage:)];
    [unOrderListTableView.onDidCancleRow addListener:self selector:@selector(tv_OnDidCancled:RowMessage:)];
    [unOrderListTableView.onDidOrderRow addListener:self selector:@selector(tv_OnDidOrder:RowMessage:)];
    [unOrderListTableView.onDicTransRow addListener:self selector:@selector(tv_OnDidTrans:RowMessage:)];
    [backScrollView addSubview:unOrderListTableView];
    
    // 代发货
    
    //                            NSMutableArray *unSend=[NSMutableArray arrayWithArray:[self getStatesArrayWithTouchTag:2]];
    
    unSendFoodLisTableView=[[MyOrderTableView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH*2,0, UI_SCREEN_WIDTH,backScrollView.frame.size.height) style:UITableViewStyleGrouped];
    unSendFoodLisTableView.dataArray=unSendList;
    unSendFoodLisTableView.cellDefaultHeight=84;
    unSendFoodLisTableView.isUnReceived=YES;
    unSendFoodLisTableView.tag=2;
    [unSendFoodLisTableView.onLoadNewMessage addListener:self selector:@selector(tableview_OnLoadNewMessage:eventData:)];
//    [unSendFoodLisTableView.onLoadMoreMessage addListener:self selector:@selector(tableview_OnLoadMoreMessage:eventData:)];
    [unSendFoodLisTableView addFooterWithTarget:self action:@selector(tableview_OnLoadMoreMessage:)];
    [unSendFoodLisTableView.onDidSelectedRow  addListener:self selector:@selector(tv_OnDidSelected:RowMessage:)];
    [unSendFoodLisTableView.onDidCancleRow addListener:self selector:@selector(tv_OnDidCancled:RowMessage:)];
    [unSendFoodLisTableView.onDidOrderRow addListener:self selector:@selector(tv_OnDidOrder:RowMessage:)];
    [unSendFoodLisTableView.onDicTransRow addListener:self selector:@selector(tv_OnDidTrans:RowMessage:)];
    [backScrollView addSubview:unSendFoodLisTableView];
    //待收货
    
    //                            NSMutableArray *unReceiveArray=[NSMutableArray arrayWithArray:[self getStatesArrayWithTouchTag:3]];
    
    unreceiveFoodListTableView=[[MyOrderTableView alloc]initWithFrame:CGRectMake( UI_SCREEN_WIDTH*3, 0,UI_SCREEN_WIDTH,backScrollView.frame.size.height) style:UITableViewStyleGrouped];
    unreceiveFoodListTableView.dataArray=unReceiveList;
    unreceiveFoodListTableView.cellDefaultHeight=84;
    unreceiveFoodListTableView.tag=3;
    unreceiveFoodListTableView.isUnReceived=NO;
    [unreceiveFoodListTableView.onLoadNewMessage addListener:self selector:@selector(tableview_OnLoadNewMessage:eventData:)];
//    [unreceiveFoodListTableView.onLoadMoreMessage addListener:self selector:@selector(tableview_OnLoadMoreMessage:eventData:)];
    [unreceiveFoodListTableView addFooterWithTarget:self action:@selector(tableview_OnLoadMoreMessage:)];
    [unreceiveFoodListTableView.onDidSelectedRow  addListener:self selector:@selector(tv_OnDidSelected:RowMessage:)];
    [unreceiveFoodListTableView.onDidCancleRow addListener:self selector:@selector(tv_OnDidCancled:RowMessage:)];
    [unreceiveFoodListTableView.onDidOrderRow addListener:self selector:@selector(tv_OnDidOrder:RowMessage:)];
    [unreceiveFoodListTableView.onDicTransRow addListener:self selector:@selector(tv_OnDidTrans:RowMessage:)];
    [backScrollView addSubview:unreceiveFoodListTableView];
    //待评价
    //                            [self getStatesArrayWithTouchTag:4];
    //                            NSMutableArray *unReturn=[NSMutableArray arrayWithArray:[self getStatesArrayWithTouchTag:4]];
    unReturnListTableView=[[MyOrderTableView alloc]initWithFrame:CGRectMake( UI_SCREEN_WIDTH*4,0, UI_SCREEN_WIDTH,backScrollView.frame.size.height) style:UITableViewStyleGrouped];
    unReturnListTableView.dataArray= unReturnList;
    unReturnListTableView.cellDefaultHeight=84;
    unReturnListTableView.tag=4;
    unReturnListTableView.isUnReceived=NO;
    [unReturnListTableView.onLoadNewMessage addListener:self selector:@selector(tableview_OnLoadNewMessage:eventData:)];
//    [unReturnListTableView.onLoadMoreMessage addListener:self selector:@selector(tableview_OnLoadMoreMessage:eventData:)];
    [unReturnListTableView addFooterWithTarget:self action:@selector(tableview_OnLoadMoreMessage:)];
    [unReturnListTableView.onDidSelectedRow  addListener:self selector:@selector(tv_OnDidSelected:RowMessage:)];
    [unReturnListTableView.onDidCancleRow addListener:self selector:@selector(tv_OnDidCancled:RowMessage:)];
    [unReturnListTableView.onDidOrderRow addListener:self selector:@selector(tv_OnDidOrder:RowMessage:)];
    [unReturnListTableView.onDicTransRow addListener:self selector:@selector(tv_OnDidTrans:RowMessage:)];
    [backScrollView addSubview:unReturnListTableView];
}

- (void)configPlaceholdView
{
//    if (!placeholdView) {
        CGFloat originY = backScrollView.frame.origin.y;
               CGRect  noneDataRect = CGRectMake(UI_SCREEN_WIDTH*touchTag, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-originY);
//        CGRect  noneDataRect = CGRectMake(UI_SCREEN_WIDTH*touchTag, originY, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-originY);
        placeholdView = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:noneDataRect WithImage:NONE_DATA_ORDER andImgSize:CGSizeMake(60, 60) andTipString:@"您的订单为空" font:FONT_t5 textColor:COLOR_C6 andInterval:20.0];
        [backScrollView addSubview:placeholdView];
        
//        [self.view addSubview:placeholdView];
//    }
}

- (void)removePlaceholdView
{
    if (placeholdView) {
        [placeholdView removeFromSuperview];
        placeholdView = nil;
    }
}

-(void)refreshData:(NSNotification*)sender
{
    NSDictionary *senderDic = [sender userInfo];

    NSArray *tagArray=[NSArray arrayWithArray:senderDic[@"tag"]];
    for (int a=0; a<[tagArray count]; a++)
    {
        NSString *tagStr = [NSString stringWithFormat:@"%@",tagArray[a]];
//        touchTag=[tagStr intValue];
        
        switch ([tagStr intValue]) {
           
            case 0:
            {
                [self tableview_OnLoadNewMessage:listTableView eventData:nil];
            }
                break;
                case 1:
            {
                [self tableview_OnLoadNewMessage:unOrderListTableView eventData:nil];
            }
                break;
                case 2:
            {
                 [self tableview_OnLoadNewMessage:unSendFoodLisTableView eventData:nil];
            }break;
                case 3:
            {
                [self tableview_OnLoadNewMessage:unreceiveFoodListTableView eventData:nil];
            }break;
                case 4:
            {
            
                [self tableview_OnLoadNewMessage:unReturnListTableView eventData:nil];
            }
                
            default:
                break;
        }
    }
//    canRefresh=YES;
//    if (canRefresh)
//    {
//        canRefresh=NO;
//    }

    /*
    NSString *userId=[NSString stringWithFormat:@"%@",sns.ldap_uid];
    NSMutableString *returnMessage=[[NSMutableString alloc]init];
    NSString *commonStatus=nil;
    NSMutableArray *getArray=[[NSMutableArray alloc]init];
    int refreshTag=0;
    switch (refreshTag) {
        case 0:
        {
            commonStatus=@"ALL";
        }break;
        case 1:
        {
            commonStatus=@"WaitingPay";
        }break;
        case 2:
        {
            commonStatus=@"WaitingSend";
        }break;
        case 3:
        {
            commonStatus=@"WaitingConfirm";
            
        }break;
        case 4:
        {
            commonStatus=@"WaitingJudge";
        }break;
        default:
            break;
    }
    NSDictionary *paramDic=@{@"userId":userId,@"CommonStatus":commonStatus};
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([SHOPPING_GUIDE_ITF requestGetUrlName:@"OrderCommonFilter" param:paramDic responseList:getArray responseMsg:returnMessage])
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (refreshTag) {
                    case 0:
                    {
                        [requestList removeAllObjects];
                        requestList = getArray;
                        
                    }break;
                    case 1:
                    {
                        [unOrderList removeAllObjects];
                        unOrderList = getArray;
                    }break;
                    case 2:
                    {
                        [unSendList removeAllObjects];
                        unSendList=getArray;
                    }break;
                    case 3:
                    {
                        [unReceiveList removeAllObjects];
                        unReceiveList=getArray;
                        
                    }break;
                    case 4:
                    {
                        [unReturnList removeAllObjects];
                        unReturnList=getArray;
                    }break;
                    default:
                        break;
                }
                
                [Toast hideToastActivity];
                [self getTableViewWithTag:touchTag];
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{

            });
        }
    });
     */

}
- (void)requestOrderData
{
    //self.status 要跟着scrollview滑动改变  点击的标题改变
    
    switch (self.status) {
        case 0:
        {
            touchTag =0;
                [self tableview_OnLoadNewMessage:listTableView eventData:nil];
        }
            break;
            case 1:
        {
             touchTag =1;
                [self tableview_OnLoadNewMessage:unOrderListTableView eventData:nil];
        }break;
            case 2:
        {
              touchTag =2;
                [self tableview_OnLoadNewMessage:unSendFoodLisTableView eventData:nil];
        }
            break;
            case 3:
        {
              touchTag =3;
                  [self tableview_OnLoadNewMessage:unreceiveFoodListTableView eventData:nil];
        }
            break;
            case 4:
        {
              touchTag =4;
                  [self tableview_OnLoadNewMessage:unReturnListTableView eventData:nil];
        }
    
        default:
            break;
    }
    [customClassifyModelV buttonClickedOfIndex:touchTag];
    NSString *st = [NSString stringWithFormat:@"%@",showOneClick[touchTag]];
    if ([st isEqualToString:@"1"])
    {
        
    }
    else
    {
        [showOneClick replaceObjectAtIndex:touchTag withObject:@"1"];
    }
    backScrollView.contentOffset=CGPointMake(backScrollView.frame.size.width*touchTag, 0);
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
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backHome:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;

    
//    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"售后" style:UIBarButtonItemStylePlain target:self action:@selector(returnOrder)];
//    self.navigationItem.rightBarButtonItems = @[right];
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 44)];
    right.backgroundColor=[UIColor clearColor];
    [right setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    right.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, -1);
    right.titleLabel.font = FONT_T3;
    [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [right setTitle:@"售后" forState:UIControlStateNormal];
    [right addTarget:self action:@selector(returnOrder)
    forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    
    self.title=@"我的订单";
}
-(void)returnOrder
{
    MyReturnViewController *myReturn=[[MyReturnViewController alloc]initWithNibName:@"MyReturnViewController" bundle:nil];
    
    [self.navigationController pushViewController:myReturn animated:YES];
}
//- (void)onBack:(UIButton*)sender {
//    [self popAnimated:YES];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.headView.backgroundColor =[UIColor blackColor];
//    stateSListArray = [[NSMutableArray alloc]init];
    requestList=[[NSMutableArray alloc]init];
    unOrderList= [[NSMutableArray alloc]init];
    unSendList= [[NSMutableArray alloc]init];
    unReceiveList= [[NSMutableArray alloc]init];
    unReturnList= [[NSMutableArray alloc]init];
//    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);

    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
//    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
//    
//    view.lbTitle.text=@"我的订单";
//    [self.headView addSubview:view];
    [self setupNavbar];
//    self.view.backgroundColor = TITLE_BG;

    refreshLock =[[NSLock alloc]init];
    touchTag =0;
    showOneClick = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0"]];//判别是否加载过
//    NSMutableDictionary *showOneDic=[NSMutableDictionary dictionaryWithDictionary:@{@"0":@"1",@"1":@"0",@"2":@"0",@"3":@"0",@"4":@"0"}];//前面 tag数 后面是否点击
    
    NSArray *titleArray=@[@"全部",@"待付款",@"待发货",@"待收货",@"待评价"];
//    NSArray *picArray = @[@"btn_allorder_normal.png",@"btn_waitpay_normal.png",@"btn_waitconsignment_normal.png",@"btn_waitreceipt_normal.png",@"btn_waitappraise_normal.png"];
//    NSArray *selectArray=@[@"btn_allorder_pressed.png",@"btn_waitpay_pressed.png",@"btn_waitconsignment_pressed.png",@"btn_waitreceipt_pressed.png",@"btn_waitappraise_pressed.png"];
    
    customClassifyModelV=[[MBCustomClassifyModelView alloc]initWithFrame:CGRectMake(0, view.frame.size.height, UI_SCREEN_WIDTH, 40) WithTitleArray:titleArray useScroll:NO WithPicAndText:NO WithPicArray:nil WithSelectPicArray:nil WithShowRightBtnLine:YES WithShowBottomBtnLine:YES];
    customClassifyModelV.backgroundColor=[UIColor whiteColor];
    customClassifyModelV.delegate=self;
        [customClassifyModelV setFont: FONT_T4];
//    [customClassifyModelV setTextColor:[Utils HexColor:0x6d6d6d Alpha:1.0]];
    [customClassifyModelV setTextColor:[Utils HexColor:0x999999 Alpha:1.0]];
     [customClassifyModelV setSelectedTextColor:[Utils HexColor:0x3b3b3b Alpha:1.0]];
//    [customClassifyModelV setSelectedTextColor:[Utils HexColor:0xe74708 Alpha:1.0]];
//    [customClassifyModelV setSelectedTextColor:[Utils HexColor:0xE52027 Alpha:1]];
//    [customClassifyModelV setFont:[UIFont systemFontOfSize:11.0]];

    
    
    [self.view addSubview:customClassifyModelV];

    backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,customClassifyModelV.frame.size.height+customClassifyModelV.frame.origin.y, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-customClassifyModelV.frame.size.height-customClassifyModelV.frame.origin.y)];
    [self.view addSubview:backScrollView];
    backScrollView.showsHorizontalScrollIndicator = YES;
    backScrollView.showsVerticalScrollIndicator = YES;
    backScrollView.pagingEnabled=YES;
    backScrollView.bounces=NO;
    backScrollView.delegate=self;
    [backScrollView setBackgroundColor:[Utils HexColor:0xf2f2f2 Alpha:1]];
    
    backScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH*5,0);
    [self.view addSubview:backScrollView];
    noDataImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, customClassifyModelV.frame.origin.y+customClassifyModelV.frame.size.height,UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-customClassifyModelV.frame.origin.y-customClassifyModelV.frame.size.height)];
    noDataImgView.hidden=YES;
    [noDataImgView setImage:[UIImage imageNamed:@"shoppingNil.png"]];
//    [self.view addSubview:noDataImgView];
    
//    [Toast makeToast:@"正在加载,请稍后..."];
    [self initTableView];
    
    [self requestOrderData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData:) name:@"refeshData" object:nil];
//    [self configPlaceholdView];
}
-(void)showRightMenu
{
    
}
-(void)tv_OnDidTrans:(UIButton*)sender RowMessage:(id)message
{
    NSLog(@"trans");
}
-(void)tv_OnDidCancled:(UIButton*)sender RowMessage:(id)message
{
    showMessageCancleOrderModel= message;
    /*
    showMessageCancle=[NSDictionary dictionaryWithDictionary:message];
     */
    cancleTitleString=[NSString stringWithFormat:@"%@",sender.titleLabel.text];
    if ([cancleTitleString isEqualToString:@"订单跟踪"]) {
        
//        LogisticsViewController *logistic=[[LogisticsViewController alloc]initWithNibName:@"LogisticsViewController" bundle:nil];
//        logistic.messageDic = showMessageCancle;
//        [self.navigationController pushViewController:logistic animated:YES];
        
        LogisticsViewControlle2 *logist=[LogisticsViewControlle2 new];
        /*
        logist.messageDic=showMessageCancle;
         */
        logist.messageDicOrderModel = showMessageCancleOrderModel;
        
        [self.navigationController pushViewController:logist animated:YES];
  
    }
    else if([cancleTitleString isEqualToString:@"取消订单"])
    {
        UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"确定要取消该订单吗?"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:@"取消", nil];
        [showAlert show];
    }
    else
    {
        
    }

 }

-(void)tv_OnDidOrder:(UIButton *)sender RowMessage:(id)message
{
    OrderModel *orderModelData= message;
    NSString *judge = @"评价";
    NSLog(@".。。。。。。%ld",(long)sender.tag);

    
    if ([sender.currentTitle isEqualToString:@"去付款"]) {
        /**
         *  未支付订单超过三天则自动取消
         */
        
        /*
        NSString *dateStr = [CommMBBusiness getdate:message[@"creatE_DATE"]];
         */
//        NSString *dateStr = [CommMBBusiness getdate:orderModelData.creatE_DATE];
        NSString *dateStr = [NSString stringWithFormat:@"%@",orderModelData.creatE_DATE];
        
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *createDate = [formatter dateFromString:dateStr];
        NSTimeInterval timeoffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
        createDate = [createDate dateByAddingTimeInterval:timeoffset];
        
        NSDate *nowdate = [NSDate date];
        nowdate = [nowdate dateByAddingTimeInterval:timeoffset];
        
        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit fromDate:createDate toDate:nowdate options:0];
        if (components.year >= 1 || components.month >= 1 || components.day >= 3) {
            _alertview = [[UIAlertView alloc]initWithTitle:nil message:@"您的订单中有失效商品" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            _alertview.tag = sender.tag;
            [_alertview show];
            return;
        }
    }
    
            @try {
                NSString *titleString=[NSString stringWithFormat:@"%@",sender.titleLabel.text];
                NSString *stringFile=nil;
                
                NSString *orderId = [NSString stringWithFormat:@"%@",orderModelData.idStr];
                NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";

                NSDictionary *param=@{@"orderId":orderId,
                                      @"token":userToken};
                self.transDic = param;
                if([titleString isEqualToString:@"去付款"])
                {
                    //根据paymentList第一条来判断  "paY_TYPE" = ZFB;
                 
                    [Toast hideToastActivity];
                    
//                    PayOrderViewController *payOrderVC=[[PayOrderViewController alloc]initWithNibName:@"PayOrderViewController" bundle:nil];
                    //add by miao 3.5 解决直接跳转支付
                    PayOrderViewController *payOrderVC= [PayOrderViewController sharedPayOrderViewController];
                    [payOrderVC payOrderVCPayCompleteBlock:^(id sender) {
//                        PayResultViewController *payResultVC=[[PayResultViewController alloc] initWithNibName:@"PayResultViewController" bundle:nil];
//                        payResultVC.orderCode= sender;
//                        [self.navigationController pushViewController:payResultVC animated:YES];
                        [self performSelector:@selector(canShowPraiseBox) withObject:nil afterDelay:3.0];
                        NSString *webUr=[NSString stringWithFormat:@"%@?orderId=%@",HTML_ORDER_SUCCESS,sender];
                    
                        JSWebViewController *webCV= [[JSWebViewController alloc] initWithUrl:webUr];
                          webCV.isPayResult=YES;
                        [self.navigationController pushViewController:webCV animated:YES];
                        
                    }];
/*
                    //支付金额
                   NSString *disamount=[NSString stringWithFormat:@"%@",showMessage[@"diS_AMOUNT"]];
                    disamount = [Utils getSNSString:disamount];
                   NSString * fee =[NSString stringWithFormat:@"%@",showMessage[@"fee"]];
                    fee = [Utils getSNSString:fee];
                    double summery=[[Utils getSNSDouble:showMessage[@"orderTotalPrice"]] doubleValue];
 // 更新 总价  接口
 // alltotalPrice
                    */
                    //支付金额
                    NSString *disamount=[NSString stringWithFormat:@"%@",orderModelData.diS_AMOUNT];
                    disamount = [Utils getSNSString:disamount];
                    NSString * fee =[NSString stringWithFormat:@"%@",orderModelData.fee];
                    fee = [Utils getSNSString:fee];
                    double summery=[[Utils getSNSDouble:orderModelData.orderTotalPrice] doubleValue];
                    // 更新 总价  接口
                    // alltotalPrice

                    /*
                    payOrderVC.param=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"有范订单%@",showMessage[@"orderno"]],@"body", showMessage[@"orderno"],@"out_trade_no",@(summery),@"total_fee",sns.ldap_uid,@"UserId",[InetAddress getLocalHost],@"spbill_create_ip",sns.myStaffCard.nick_name,@"CREATE_USER",nil];
                    //add by miao 3.3
                    payOrderVC.paymentList = [showMessage objectForKey:@"paymentList"];
                    */
                    payOrderVC.param=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"有范订单%@",orderModelData.orderno],@"body", orderModelData.orderno,@"out_trade_no",@(summery),@"total_fee",sns.ldap_uid,@"UserId",[InetAddress getLocalHost],@"spbill_create_ip",sns.myStaffCard.nick_name,@"CREATE_USER",nil];
                    //add by miao 3.3
                    payOrderVC.paymentList = orderModelData.paymentList;
                    
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
                    [Toast hideToastActivity];
                    return;
                    
                }else if ([titleString rangeOfString:judge].location !=NSNotFound)
                {
                    [Toast hideToastActivity];
                    AppraiseViewController *appraiseVC=[[AppraiseViewController alloc]initWithNibName:@"AppraiseViewController" bundle:nil];
                    NSArray *detailList=[NSArray arrayWithArray:orderModelData.detailList];
                    OrderModelDetailListInfo *detailListInfoData = detailList[0];
                    NSString *proD_ID =  [NSString stringWithFormat:@"%@",detailListInfoData.detailInfo.proD_ID];
                    appraiseVC.orderArray=orderModelData.detailList;
                    appraiseVC.messageOrderModel=orderModelData;
                    appraiseVC.prodectid=proD_ID;
                    [self.navigationController pushViewController:appraiseVC animated:YES];
                    return;
                    
                }
                [HttpRequest getRequestPath:kMBServerNameTypeNoWXSCOrder methodName:stringFile params:param success:^(NSDictionary *dict) {
                  
                    if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [Toast hideToastActivity];
                            [Utils alertMessage:@"操作成功"];
                            NSDictionary *postDic=@{@"tag":@[@"0",@"3",@"4"]};
                            [self performSelector:@selector(canShowPraiseBox) withObject:nil afterDelay:3.0];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"refeshData" object:nil userInfo:postDic];
                            
                        });
                    }

                    
                } failed:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [Utils alertMessage:[NSString stringWithFormat:@"操作失败"]];
                        [Toast hideToastActivity];
                    });
                }];

            }
            @catch(NSException *exception)
            {
                NSLog(@"%s Exception Name: %@, Reason: %@", __FUNCTION__, [ exception name ], [ exception reason ]);
            }
}
-(void)canShowPraiseBox
{
    [SUTILITY_TOOL_INSTANCE showPraiseBox];
}
- (void)tv_OnDidSelected:(MyOrderTableView*)sender RowMessage:(id)message
{
//    canRefresh=YES;
    NSLog(@"message0-－－－－%@",message);
    
    OrderModel *orderModelData= message;
    DetailOrderViewController *detailOrder=[[DetailOrderViewController alloc]init];
    /*
    detailOrder.transDic = message;
     */
    detailOrder.transDicOrderModel = orderModelData;
    [self.navigationController pushViewController:detailOrder animated:YES];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _alertview) {
        if(listTableView)
        {
              [self tv_OnDidSelected:nil RowMessage:listTableView.dataArray[_alertview.tag]];
        }
        else if (unOrderListTableView)
        {
              [self tv_OnDidSelected:nil RowMessage:unOrderListTableView.dataArray[_alertview.tag]];
        }
     
        return;
    }
    if (buttonIndex==0)
    {
        [Toast makeToastActivity:@"正在加载,请稍后..." hasMusk:NO];
      
        NSString *cancleFile=nil;
    
//        NSMutableString *returnMessage=[[NSMutableString alloc]init];
        /*
        NSString *orderNo=[NSString stringWithFormat:@"%@",[showMessageCancle objectForKey:@"orderno"]];
         */
//        NSString *orderNo=[NSString stringWithFormat:@"%@",showMessageCancleOrderModel.orderno];
        NSString *orderId = [NSString stringWithFormat:@"%@",showMessageCancleOrderModel.idStr];
        NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
//        NSDictionary *param=@{@"orderId":orderId,
//                              @"last_modified_user":sns.myStaffCard.nick_name};
        NSDictionary *param=@{@"orderId":orderId,
                              @"token":userToken};
        if([cancleTitleString isEqualToString:@"取消订单"])
        {
            cancleFile=@"OrderCancel";
            
        }else if([cancleTitleString isEqualToString:@"订单跟踪"])
        {
        }
        else
        {
        }
        [HttpRequest getRequestPath:kMBServerNameTypeNoWXSCOrder methodName:cancleFile params:param success:^(NSDictionary *dict) {
            
            if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
            {
                id data = [dict objectForKey:@"results"];
                if ([data isKindOfClass:[NSArray class]])
                {
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                    [requestList removeAllObjects];
                    [unOrderList removeAllObjects];
                    [self tableview_OnLoadNewMessage:unOrderListTableView eventData:nil];
                    [self tableview_OnLoadNewMessage:listTableView eventData:nil];
                });
            }

            
        } failed:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Utils alertMessage:[NSString stringWithFormat:@"操作失败"]];
                [Toast hideToastActivity];
            });
            
            
        }];
        
//        [HttpRequest postRequestPath:kMBServerNameTypeOrder methodName:cancleFile params:param success:^(NSDictionary *dict) {
//            if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
//            {
//                id data = [dict objectForKey:@"results"];
//                if ([data isKindOfClass:[NSArray class]])
//                {
//                    
//                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [Toast hideToastActivity];
//                    [requestList removeAllObjects];
//                    [unOrderList removeAllObjects];
//                    [self tableview_OnLoadNewMessage:unOrderListTableView eventData:nil];
//                    [self tableview_OnLoadNewMessage:listTableView eventData:nil];
//                });
//            }
//        } failed:^(NSError *error) {
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [Utils alertMessage:[NSString stringWithFormat:@"操作失败"]];
//                [Toast hideToastActivity];
//            });
//            
//        }];

    }
    else
    {
        
    }
   
}
#pragma mark tvCollectionDetail tableViewDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSMutableArray *)getStatesArrayWithTouchTag:(int)tag
{
    NSMutableArray *oneArray=[[NSMutableArray alloc]init];
    
        switch (tag)
        {
            case 0:
            {
                [oneArray addObjectsFromArray:requestList];
            }
                break;
            case 1:
            {
                
                for (int k=0; k<[requestList count]; k++) {
                    NSString *statusStr=[NSString stringWithFormat:@"%@",requestList[k][@"status"]];
                    if ([statusStr isEqualToString:@"0"])
                    {
                        [oneArray addObject:requestList[k]];
                        
                    }
                    
                }
                
            }
                break;
            case 2:
            {
                
                for (int k=0; k<[requestList count]; k++) {
                       NSString *statusStr=[NSString stringWithFormat:@"%@",requestList[k][@"status"]];
                    if ([statusStr isEqualToString:@"2"]||[statusStr isEqualToString:@"1"]||[statusStr isEqualToString:@"3"]||[statusStr isEqualToString:@"4"])
                    {
                        [oneArray addObject:requestList[k]];
                        
                    }
                    
                }

                
                
            }
                break;
            case 3:
            {
                for (int k=0; k<[requestList count]; k++) {
                        NSString *statusStr=[NSString stringWithFormat:@"%@",requestList[k][@"status"]];
                    if ([statusStr isEqualToString:@"5"])
                    {
                        [oneArray addObject:requestList[k]];
                    }
                }
                
            }
                break;
            case 4:
            {
                
                for (int k=0; k<[requestList count]; k++) {
                        NSString *statusStr=[NSString stringWithFormat:@"%@",requestList[k][@"status"]];
                    if ([statusStr isEqualToString:@"6"]||[statusStr isEqualToString:@"10"]||[statusStr isEqualToString:@"9"])
                    {
                        [oneArray addObject:requestList[k]];
                        
                    }
                }
                
            }
                break;
                
            default:
                break;
        }
    return oneArray;
    
}
-(void)getTableViewWithTag:(int)tag
{

    NSString *st = [NSString stringWithFormat:@"%@",showOneClick[tag]];
    touchTag=tag;
    self.status=tag;
    
    if ([st isEqualToString:@"1"])
    {
    }
    else
    {
        [showOneClick replaceObjectAtIndex:tag withObject:@"1"];
        switch (tag) {
            case 0:
            {
                [self tableview_OnLoadNewMessage:listTableView eventData:nil];
            }
                break;
            case 1:
            {
                [self tableview_OnLoadNewMessage:unOrderListTableView eventData:nil];
            }
                break;
            case 2:
            {
                [self tableview_OnLoadNewMessage:unSendFoodLisTableView eventData:nil];
            }
                break;
            case 3:
            {
                [self tableview_OnLoadNewMessage:unreceiveFoodListTableView eventData:nil];
            }
                break;
            case 4:
            {
                [self tableview_OnLoadNewMessage:unReturnListTableView eventData:nil];
            }
                break;
                
            default:
                break;
        }
        
    }
    
    
    
    
//    switch (tag)
//    {
//        case 0:
//        {
//            if ([requestList count]==0)
//            {
//                noDataImgView.hidden=NO;
//            }
//            else
//            {
//                noDataImgView.hidden=YES;
//                listTableView.dataArray=requestList;
//                [listTableView reloadData];
//            }
//        }
//            break;
//        case 1:
//        {
////            NSMutableArray *unOrder=[self getStatesArrayWithTouchTag:1];
//            if ([unOrderList count]==0)
//            {
//                noDataImgView.hidden=NO;
//            }
//            else
//            {
//                noDataImgView.hidden=YES;
//                unOrderListTableView.dataArray=unOrderList;
//                [unOrderListTableView reloadData];
//            }
//        }
//            break;
//        case 2:
//        {
////            NSMutableArray *unSend=[self getStatesArrayWithTouchTag:2];
//            if ([unSendList count]==0)
//            {
//                noDataImgView.hidden=NO;
//                
//            }
//            else
//            {
//                noDataImgView.hidden=YES;
//                unSendFoodLisTableView.dataArray=unSendList;
//                [unSendFoodLisTableView reloadData];
//            }
//        }
//            break;
//        case 3:
//        {
////            NSMutableArray *unReceive=[self getStatesArrayWithTouchTag:3];
//            if ([unReceiveList count]==0)
//            {
//                noDataImgView.hidden=NO;
//            }
//            else
//            {
//                noDataImgView.hidden=YES;
//                unreceiveFoodListTableView.dataArray=unReceiveList;
//                [unreceiveFoodListTableView reloadData];
//            }
//        }
//            break;
//        case 4:
//        {
////            NSMutableArray *unReturn=[self getStatesArrayWithTouchTag:4];
//            if ([unReturnList count]==0)
//            {
//                noDataImgView.hidden=NO;
//            }
//            else
//            {
//                noDataImgView.hidden=YES;
//                unReturnListTableView.dataArray=unReturnList;
//                [unReturnListTableView reloadData];
//            }
//            
//        }
//            break;
//            
//        default:
//            break;
//    }

//    switch (touchTag)
//    {
//        case 0:
//        {
//            NSMutableArray *listArray=[self getStatesArrayWithTouchTag:0];
////            NSMutableArray *listArray = requestList;
//            
//            if ([listArray count]==0)
//            {
//                noDataImgView.hidden=NO;
//            }
//            else
//            {
//                noDataImgView.hidden=YES;
//                listTableView.dataArray=listArray;
//                [listTableView reloadData];
//            }
//        }
//            break;
//        case 1:
//        {
//             NSMutableArray *unOrder=[self getStatesArrayWithTouchTag:1];
//            if ([unOrder count]==0)
//            {
//                noDataImgView.hidden=NO;
//            }
//            else
//            {
//                noDataImgView.hidden=YES;
//                unOrderListTableView.dataArray=unOrder;
//               [unOrderListTableView reloadData];
//            }
//        }
//            break;
//        case 2:
//        {
//            NSMutableArray *unSend=[self getStatesArrayWithTouchTag:2];
//            if ([unSend count]==0)
//            {
//                noDataImgView.hidden=NO;
//                
//            }
//            else
//            {
//                noDataImgView.hidden=YES;
//                unSendFoodLisTableView.dataArray=unSend;
//                [unSendFoodLisTableView reloadData];
//            }
//        }
//            break;
//        case 3:
//        {
//            NSMutableArray *unReceive=[self getStatesArrayWithTouchTag:3];
//            if ([unReceive count]==0)
//            {
//                noDataImgView.hidden=NO;
//            }
//            else
//            {
//                noDataImgView.hidden=YES;
//                unreceiveFoodListTableView.dataArray=unReceive;
//                [unreceiveFoodListTableView reloadData];
//            }
//        }
//            break;
//        case 4:
//        {
//            NSMutableArray *unReturn=[self getStatesArrayWithTouchTag:4];
//            if ([unReturn count]==0)
//            {
//                noDataImgView.hidden=NO;
//            }
//            else
//            {
//                noDataImgView.hidden=YES;
//                unReturnListTableView.dataArray=unReturn;
//                [unReturnListTableView reloadData];
//            }
//
//        }
//            break;
//            
//        default:
//            break;
//    }
}

- (void)tableview_OnLoadMoreMessage:(MJRefreshFooterView*)sender
{
    
    PullDragTableView *tableView = (PullDragTableView*)sender.superview;
    if (!tableView) {
        switch (touchTag) {
            case 0:
                tableView = listTableView;
                break;
            case 1:
                tableView = unOrderListTableView;
                break;
            case 2:
                tableView = unSendFoodLisTableView;
                break;
            case 3:
                tableView = unreceiveFoodListTableView;
                break;
            case 4:
                tableView = unReturnListTableView;
                break;
            default:
                break;
        }
    }
    _pageIndex = (tableView.dataArray.count + 9)/ 10 + 1;
    [self requestData:tableView evenData:nil];
}

- (void)tableview_OnLoadNewMessage:(PullDragTableView*)sender eventData:(id)eventData
{
    _pageIndex = 0;
    [self requestData:sender evenData:eventData];
}

- (void)requestData:(PullDragTableView*)sender evenData:(id)evenData{
    NSString *userId=[NSString stringWithFormat:@"%@",sns.ldap_uid];
    NSMutableString *returnMessage=[[NSMutableString alloc]init];
    NSString *commonStatus=nil;
    
    NSMutableArray *getArray=[[NSMutableArray alloc]init];
    [Toast makeToastActivity:@"正在加载" hasMusk:YES];
    
    //CommonStatus 参数信息 为 ALL 代表所有、WaitingPay 代表待支付、WaitingSend 代表待发货、WaitingConfirm 代表待收货、WaitingJudge 代表待评价
    if(sender==listTableView)
    {
        
        touchTag=0;
    }
    else if(sender==unOrderListTableView)
    {
        touchTag=1;
    }
    else if(sender==unSendFoodLisTableView)
    {
        NSLog(@"sender 2 －进来了吧");
        touchTag=2;
    }
    else if(sender==unreceiveFoodListTableView)
    {
        touchTag=3;
    }
    else if(sender== unReturnListTableView)
    {
        touchTag=4;
    }
    NSInteger click;
    click = touchTag;

//     待付款0   待发货1234  待收货5  待评价6,10
    switch (touchTag) {
        case 0:
        {
            commonStatus=@"ALL";
        }break;
        case 1:
        {
            commonStatus=@"WaitingPay";
        }break;
        case 2:
        {
            commonStatus=@"WaitingSend";
        }break;
        case 3:
        {
            commonStatus=@"WaitingConfirm";
            
        }break;
        case 4:
        {
            commonStatus=@"WaitingJudge";
        }break;
        default:
            break;
    }
    
    
    
    NSDictionary *paramDic=@{@"userId":userId,
                             @"status":commonStatus,//CommonStatus
                             @"PageSize": @10,
                             @"PageIndex": @(_pageIndex)};
 
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [refreshLock lock];

    
        if ([SHOPPING_GUIDE_ITF newrequestGetUrlName:@"OrderCommonFilter" param:paramDic responseList:getArray responseMsg:returnMessage])
        {

            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableArray *modelArray = [NSMutableArray arrayWithArray:[OrderModel modelArrayForDataArray:getArray]];
//                NSLog(@"modelaray--%@",modelArray);
                if (_pageIndex == 0) {
                    sender.dataArray = modelArray;
                }else{
                    [sender footerEndRefreshing];
                    [sender.dataArray addObjectsFromArray:modelArray];
                }
                
//                [Toast hideToastActivity];
                /*
                if (_pageIndex == 1) {
                   sender.dataArray = getArray;
                }else{
                    [sender footerEndRefreshing];
                    [sender.dataArray addObjectsFromArray:getArray];
                }
                 */
                //                 [self getTableViewWithTag:touchTag];
                if (sender.dataArray.count == 0) {
                    [self configPlaceholdView];
                }else{
                    [self removePlaceholdView];
                }
                [sender reloadData];
                [Toast hideToastActivity];
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Toast hideToastActivity];
            });
        }
        
        [refreshLock unlock];
    });
}

//-(NSString *)getdate:(NSString *)datestr
//{
//    NSString *dateString=nil;
//    NSDate *date ;
//
//    if (datestr.length>1 && [[datestr substringToIndex:1] isEqualToString:@"/"])
//    {
//        NSArray *arr=[datestr componentsSeparatedByString:@"/Date("];
//        NSString *s=[arr lastObject];
//        arr=[s componentsSeparatedByString:@")/"];
//        
//        s=arr[0];
//        arr=[s componentsSeparatedByString:@"-"];
//        s=arr[0];
//        date =[NSDate dateWithTimeIntervalSince1970:[s longLongValue]/1000];
//        NSDateFormatter *format=[[NSDateFormatter alloc]init];
//        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        dateString=[NSString stringWithFormat:@"%@",[format stringFromDate:date]];
//        
//    }
//    return dateString;
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)TabItemClick:(id)sender button:(id)param
{
    NSInteger page=0;

    otherBtn = (AttendCustomButton *)param;
    page=otherBtn.tag;
//    [stateSListArray removeAllObjects];
    touchTag = otherBtn.tag;
    NSString *st = [NSString stringWithFormat:@"%@",showOneClick[touchTag]];
    if ([st isEqualToString:@"1"])
    {
        switch (touchTag) {
            case 0:
            {
                if (listTableView.dataArray.count == 0) {
                    [self configPlaceholdView];
                }else{
                    [self removePlaceholdView];
                }
            }
                break;
            case 1:
            {
                if (unOrderListTableView.dataArray.count == 0) {
                    [self configPlaceholdView];
                }else{
                    [self removePlaceholdView];
                }
            }
                break;
            case 2:
            {
                if (unSendFoodLisTableView.dataArray.count == 0) {
                    [self configPlaceholdView];
                }else{
                    [self removePlaceholdView];
                }
            }
                break;
            case 3:
            {
                if (unreceiveFoodListTableView.dataArray.count == 0) {
                    [self configPlaceholdView];
                }else{
                    [self removePlaceholdView];
                }
            }
                break;
            case 4:
            {
                if (unReturnListTableView.dataArray.count == 0) {
                    [self configPlaceholdView];
                }else{
                    [self removePlaceholdView];
                }
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        [showOneClick replaceObjectAtIndex:touchTag withObject:@"1"];
        switch (touchTag) {
            case 0:
            {
                  [self tableview_OnLoadNewMessage:listTableView eventData:nil];
            }
                break;
            case 1:
            {
                [self tableview_OnLoadNewMessage:unOrderListTableView eventData:nil];
            }
                break;
            case 2:
            {
                [self tableview_OnLoadNewMessage:unSendFoodLisTableView eventData:nil];
            }
                break;
            case 3:
            {
                [self tableview_OnLoadNewMessage:unreceiveFoodListTableView eventData:nil];
            }
                break;
            case 4:
            {
                [self tableview_OnLoadNewMessage:unReturnListTableView eventData:nil];
            }
                break;
                
            default:
                break;
        }
      
    }
    backScrollView.contentOffset=CGPointMake(backScrollView.frame.size.width*page, 0);
//    [self getStatesArrayWithTouchTag:touchTag];
//    [Toast hideToastActivity];
//    [self getTableViewWithTag:touchTag];
    //如果数组为空就请求数据？以这为判断？
    
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = backScrollView.frame.size.width;
    int page = floor((backScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    touchTag=page;
    [customClassifyModelV buttonClickedOfIndex:page];
    [self getTableViewWithTag:page];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}
-(void)backHome:(UIButton *)sender
{
    
    
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[SMineViewController class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
            break;
        }
        if([controller isKindOfClass:[MyShoppingTrollyViewController class]])
        {
            target = controller;
            break;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:YES]; //跳转
    }else{
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
//    [self.navigationController popViewControllerAnimated:YES];
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
        //[Utils alertMessage:@"支付成功，我们很快为您发货！"];
        
//        PayResultViewController *payResultVC=[[PayResultViewController alloc] initWithNibName:@"PayResultViewController" bundle:nil];
//        payResultVC.orderCode=[NSString stringWithFormat:@"%@",self.transDic[@"orderno"]];
//        [self.navigationController pushViewController:payResultVC animated:YES];
        NSString *webUr=[NSString stringWithFormat:@"%@?orderId=%@",HTML_ORDER_SUCCESS,self.transDic[@"orderno"]];
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


/*
 
 switch (btn.tag)
 {
 case 0:
 {
 [stateSListArray addObjectsFromArray:requestList];
 }
 break;
 case 1:
 {
 
 for (int k=0; k<[requestList count]; k++) {
 
 NSString *statusStr=[NSString stringWithFormat:@"%@",requestList[k][@"status"]];
 if ([statusStr isEqualToString:@"0"])
 {
 [stateSListArray addObject:requestList[k]];
 
 }
 
 }
 
 }
 break;
 case 2:
 {
 
 for (int k=0; k<[requestList count]; k++) {
 
 NSString *statusStr=[NSString stringWithFormat:@"%@",requestList[k][@"status"]];
 if ([statusStr isEqualToString:@"1"])
 {
 [stateSListArray addObject:requestList[k]];
 
 }
 
 }
 
 }
 break;
 case 3:
 {
 
 for (int k=0; k<[requestList count]; k++) {
 
 NSString *statusStr=[NSString stringWithFormat:@"%@",requestList[k][@"status"]];
 if ([statusStr isEqualToString:@"3"])
 {
 [stateSListArray addObject:requestList[k]];
 }
 
 }
 
 }
 break;
 case 4:
 {
 
 for (int k=0; k<[requestList count]; k++) {
 
 NSString *statusStr=[NSString stringWithFormat:@"%@",requestList[k][@"status"]];
 if ([statusStr isEqualToString:@"6"])
 {
 [stateSListArray addObject:requestList[k]];
 
 }
 
 
 }
 
 }
 
 break;
 
 
 default:
 break;
 }
 */
@end
