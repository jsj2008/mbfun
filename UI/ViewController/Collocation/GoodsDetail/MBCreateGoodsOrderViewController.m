//
//  MBCreateGoodsOrderViewController.m
//  Wefafa
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MBCreateGoodsOrderViewController.h"
#import "NavigationTitleView.h"
#import "MBShoppingGuideInterface.h"
#import "AppDelegate.h"
#import "AppSetting.h"
//商品数据类MyShoppingTrollyGoodsData
#import "MyShoppingTrollyGoodsTableViewCell.h"

//
#import "GoodsOrderBaseTableViewCell.h"
#import "GoodsOrderAddressTableViewCell.h"
#import "GoodsOrderAmountTableViewCell.h"
#import "GoodsOrderGoodsTableViewCell.h"
#import "GoodsOrderMemoTableViewCell.h"
#import "GoodsOrderPayFeeTableViewCell.h"
#import "GoodsOrderSendRequestTableViewCell.h"
#import "GoodsOrderDesignerTableViewCell.h"

#import "MyAdderssViewController.h"
#import "PayOrderViewController.h"
#import "InetAddress.h"

//
#import "Toast.h"
#import "Utils.h"
#import "JSONKit.h"
#import "NetUtils.h"
#import "GoodsOrderSimpleTableViewCell.h"

#import "WXPayClient.h"

#import "MBShoppingGuideInterface.h"
#import "Globle.h"
#import "GoodsInvoiceViewController.h"
#import "PayResultViewController.h"
#import "MyOrderViewController.h"

#import "MLKMenuPopover.h"
#import "GoodsDispatchMethodsVC.h"
#import "OrderGoodsListViewController.h"
#import "CommonZBarViewController.h"
#import "ScanCodeInfo.h"
#import "PromotionCalcInfo.h"
#import <AVFoundation/AVFoundation.h>
#import "SMBRedPacketViewController.h"
#import "MyRedPacketModel.h"
#import "OrderRedPacketModel.h"
#import "JSWebViewController.h"
#import "TalkingData.h"
#import "SUtilityTool.h"

@interface MBCreateGoodsOrderViewController ()<UIActionSheetDelegate,MLKMenuPopoverDelegate,CommonZBarViewControllerDelegate,UIAlertViewDelegate>
{
    BOOL isChooseMyRedPacket;
    NSString *dec_price;//优惠金额
    NSString *trans_price;
    NSString *fanPiaoPrice;
    
    
    double  allFee;//判断 发票是否展示
    __block BOOL isShowFaPiao; //是否已经展示发票
    
}
@property (weak, nonatomic) IBOutlet UIButton *senderOrderButton;
@property(nonatomic,strong)GoodsOrderSimpleTableViewCell *dispatchSimpleCell;
@property(nonatomic,strong)NSString *selectedPayType;
@property(nonatomic,strong)NSString *invoiceStr;
@property(nonatomic,strong)NSString *disptchStr;
@property(nonatomic,strong) NSArray *disptchDatearay;
@property (nonatomic,strong)NSMutableDictionary *param;


@property(nonatomic,strong)MLKMenuPopover *payTypePopover;
@property(nonatomic,strong)CommonZBarViewController *reader;
@property(nonatomic,strong)ScanCodeInfo *scanCodeInfo;
@property(nonatomic,strong)NSString *uniquesessionid;
//运费优惠使用
@property(nonatomic,strong)PromotionCalcInfo *promotionFeeCalcInfo;
//价格优惠使用
@property(nonatomic,strong)PromotionCalcInfo *promotionPriceCalcInfo;
//范票
@property(nonatomic,strong)OrderRedPacketModel *currentOrderPacketModel;

@property(nonatomic,assign)float fanpiaoMount;
@property(nonatomic,assign)float huodongMount;

@end


@implementation MBCreateGoodsOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    titlearray = @[@"周一至周日",@"周一至周五",@"周六至周日"];
    invo_index=0;
    _disptchDatearay = @[@"工作日,双休日均可送货",
                                 @"只有工作日送货",
                                 @"只有双休日送货"];;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)payAlimentResult:(id)resultd
{
    
}

-(void)setGoodsArray:(NSMutableArray *)goodsArray{
    if (_goodsArray != nil) {
        [_goodsArray removeAllObjects];
    }
    _goodsArray = goodsArray;
  
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
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1];
    
    self.title=@"确认订单";

}

- (void)onBack:(UIButton*)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notif_refreshShoppingCartTableView" object:nil];
    [self popAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    //new headview
    _huodongMount = 0.0f;
    _fanpiaoMount = 0.0f;
    
    allFee=1.1;
    
    _selectedPayType=@"支付宝";//微信支付
    _invoiceStr=@"不开发票";
    _disptchStr = _disptchDatearay[0];
    _tvOrder.separatorColor = [UIColor clearColor];
    
//    _senderOrderButton.layer.cornerRadius = 3;
//    _senderOrderButton.layer.masksToBounds = YES;
    _senderOrderButton.titleLabel.font=FONT_T1;
    
    [self setupNavbar];
    [self requestDEFAULT_FEE];
//    CGRect headrect=CGRectMake(0,0,self.viewHead.frame.size.width,self.viewHead.frame.size.height);
//    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
//    
//    [view createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:nil selectorMenu:nil];
//    view.lbTitle.text=@"确认订单";
//    [self.viewHead addSubview:view];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    _tvOrder.backgroundColor=[UIColor colorWithHexString:@"#ffffff"];
    
    orderInfoArray=[[NSMutableArray alloc] initWithCapacity:10];
    [self createOrderInfoArray];
    
  
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payAliCompleteCallback:) name:NOTICE_PAYALICOMPLETE object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payAliFailureCallback:) name:NOTICE_PAYFAILURE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createOrderInfoArray) name:@"refreshAddRess" object:nil];
    
}

-(void)requestDEFAULT_FEE{
//    NSMutableString *msg;
//    NSMutableArray *listurl3=[[NSMutableArray alloc] initWithCapacity:10];
//    if ([SHOPPING_GUIDE_ITF requestGetUrlName:@"BSParamFilter" param:@{@"code":@"DEFAULT_FEE"} responseList:listurl3 responseMsg:msg])
//    {
//        if (listurl3.count>0)
//            DEFAULT_FEE=[listurl3[0][@"paraM_VALUE"] doubleValue];
//    }
    
    [HttpRequest getRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"BSParamFilter" params:@{@"code":@"DEFAULT_FEE"} success:^(NSDictionary *dict) {
        if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
        {
            id data = [dict objectForKey:@"results"];
            
            if ([data isKindOfClass:[NSArray class]])
            {
                NSDictionary *dic2 = data[0];
                NSString *param_value=[[NSString alloc] initWithFormat:@"%@",dic2[@"paraM_VALUE"] ];
                DEFAULT_FEE = [param_value doubleValue];
                
            }
        }
    } failed:^(NSError *error) {
        
    }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupForDismissKeyboard];
   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self unsetupForDismissKeyboard];
}

#pragma mark setupForDismissKeyboard

id obKeyboardShow, obKeyboardHide;
- (void)setupForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    obKeyboardShow = [nc addObserverForName:UIKeyboardWillShowNotification
                                     object:nil
                                      queue:mainQuene
                                 usingBlock:^(NSNotification *note){
                                     [self.view addGestureRecognizer:singleTapGR];
                                 }];
    obKeyboardHide = [nc addObserverForName:UIKeyboardWillHideNotification
                                     object:nil
                                      queue:mainQuene
                                 usingBlock:^(NSNotification *note){
                                     [self.view removeGestureRecognizer:singleTapGR];
                                 }];
}

- (void)unsetupForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:obKeyboardShow];
    [nc removeObserver:obKeyboardHide];
    obKeyboardShow = nil;
    obKeyboardHide = nil;
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self autoMovekeyBoard:keyboardRect.size.height];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self autoMovekeyBoard: 0];
}

-(void) autoMovekeyBoard: (float) h
{
    float screenheight;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        CGRect screenRect=[[UIScreen mainScreen] bounds ];
        screenheight=screenRect.size.height;
    }
    else
    {
        CGRect screenRect=[[UIScreen mainScreen] applicationFrame ];
        screenheight=screenRect.size.height;
    }
    const float movementDuration = 0.3f;
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    
	_tvOrder.frame = CGRectMake(_tvOrder.frame.origin.x, _tvOrder.frame.origin.y, _tvOrder.frame.size.width, (float)(screenheight-h-_tvOrder.frame.origin.y));
    
//    [_tvOrder scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:orderInfoArray.count-1 inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:YES];

    [UIView commitAnimations];
}



-(void)createOrderInfoArray
{
    [Toast makeToastActivity:@"正在加载..." hasMusk:NO];
    [orderInfoArray removeAllObjects];
    
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *list=[[NSMutableArray alloc] initWithCapacity:10];
        NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
        BOOL rst=[SHOPPING_GUIDE_ITF requestGetUrlName:@"ReceiverFilter" param:
                  @{@"userId":sns.ldap_uid}
                responseList:list responseMsg:msg];
        dispatch_async(dispatch_get_main_queue(), ^{
            //所有数据使用NSMutableDictionary类型存储，cell中改变后存回。提交时使用。
            //收货地址信息
            if (rst && list.count>0)
            {
                for (int i=0;i<list.count;i++)
                {
                    NSDictionary *dict=list[i];
                    if ([dict[@"isdefault"] isEqualToString:@"1"])
                    {
                        NSMutableDictionary *data=[self createCellForName:@"GoodsOrderAddressTableViewCell" cellData:list[i]];
//                        [data setObject:@"1" forKey:@"isDefault"];
                        
                        [orderInfoArray addObject:data];
                        break;
                    }
                    if ([dict[@"is_default"] isEqualToString:@"1"])
                    {
                        NSMutableDictionary *data=[self createCellForName:@"GoodsOrderAddressTableViewCell" cellData:list[i]];
//                        [data setObject:@"1" forKey:@"isDefault"];
                        
                        [orderInfoArray addObject:data];
                        break;
                    }
                }
                //没有isdefault
                if (orderInfoArray.count==0)
                {
                    NSMutableDictionary *data=[self createCellForName:@"GoodsOrderAddressTableViewCell" cellData:list[0]];
//                    [data setObject:@"0" forKey:@"isDefault"];
                    
                    [orderInfoArray addObject:data];
                }
            }
            else
            {
                NSMutableDictionary *data=[self createCellForName:@"GoodsOrderAddressTableViewCell" cellData:@{@"noaddress":@"1",@"name":sns.myStaffCard.nick_name,@"address":@"您还没有收货地址，点击这里创建"}];
//                [data setObject:@"0" forKey:@"isDefault"];
                
                [orderInfoArray addObject:data];
            }
            
            //支付方式
            [orderInfoArray addObject:[self createCellForName:@"GoodsOrderSimpleTableViewCell" cellData:@""]];
            //配送方式
            [orderInfoArray addObject:[self createCellForName:@"GoodsOrderSimpleTableViewCell" cellData:@""]];
            //如果用户付费出去运费后0元点 选择发票隐藏  924 隐藏
       
            
            if (![_totalMoney isEqualToString:@"0"]) {
                //发票
                isShowFaPiao= YES;
                [orderInfoArray addObject:[self createCellForName:@"GoodsOrderSimpleTableViewCell" cellData:@""]];
            }
            
            if (allFee ==0) {
               
                if (isShowFaPiao) {
                    [orderInfoArray  removeLastObject];
                    isShowFaPiao=NO;
                }
            }
            else
            {
                if (isShowFaPiao) {
                }
                else
                {
                    //发票
                    [orderInfoArray addObject:[self createCellForName:@"GoodsOrderSimpleTableViewCell" cellData:@""]];
                    isShowFaPiao=YES;
                }

            }
      
            //共几件商品
            [orderInfoArray addObject:[self createCellForName:@"GoodsOrderSimpleTableViewCell" cellData:@""]];
           
            //wwp
            //红包
            [orderInfoArray addObject:[self createCellForName:@"GoodsOrderSimpleTableViewCell" cellData:@""]];
            
//            //关联门店
//            [orderInfoArray addObject:[self createCellForName:@"GoodsOrderSimpleTableViewCell" cellData:@""]];
            //
            //运费优惠
            [orderInfoArray addObject:[self createCellForName:@"GoodsOrderSimpleTableViewCell" cellData:@""]];
            //价格优惠
            [orderInfoArray addObject:[self createCellForName:@"GoodsOrderSimpleTableViewCell" cellData:@""]];
            
//            [orderInfoArray addObject:[self createCellForName:@"GoodsOrderSimpleTableViewCell" cellData:@""]];
//            //支付方式
//            [orderInfoArray addObject:[self createCellForName:@"GoodsOrderMemoTableViewCell" cellData:@""]];
            
            //用户留言
//            [orderInfoArray addObject:[self createCellForName:@"GoodsOrderMemoTableViewCell" cellData:@""]];
            
            //配送要求
//            [orderInfoArray addObject:[self createCellForName:@"GoodsOrderSendRequestTableViewCell" cellData:@""]];
            
            //商品数据
//            for (int i=0;i<_goodsArray.count;i++)
//            {
//                [orderInfoArray addObject:[self createCellForName:@"GoodsOrderGoodsTableViewCell" cellData:_goodsArray[i]]];
//            }
            /* old  不要删除
            NSString *firstDesigner=@"";
            for (int i=0;i<_goodsArray.count;i++)
            {
                MyShoppingTrollyGoodsData *goods=_goodsArray[i];
                if (![firstDesigner isEqualToString:goods.designerid])
                {
                    firstDesigner=goods.designerid;
                    [orderInfoArray addObject:[self createCellForName:@"GoodsOrderDesignerTableViewCell" cellData:@{@"designername":goods.designername}]];
                }
                
                [orderInfoArray addObject:[self createCellForName:@"GoodsOrderGoodsTableViewCell" cellData:_goodsArray[i]]];
            }
            
             
                        */
            //商品总金额
            amount = [MyShoppingTrollyGoodsData totalPricebyPlatFormInfo:_goodsArray];//totalPrice
            count = [MyShoppingTrollyGoodsData count:_goodsArray];
            summery = amount+DEFAULT_FEE;
//            summery = amount;
            originalAmount = [MyShoppingTrollyGoodsData totalPrice:_goodsArray];
            _lbSumAndCount.text=[NSString stringWithFormat:@"订单合计: ￥%0.2f    共%d件",summery , count];
            [_tvOrder reloadData];
            
            [self requestGetFeeCheck];
//            [self addProdInfolistAnddecideShop:nil withtype:nil];  门店时候调用
//            @"HQ01S014"@"HQ01S014"

            [Toast hideToastActivity];
        });
    });
}
/*
#pragma mark --获得优惠接口需要的list及判断门店
//type 是@"1" 是去除门店优惠
-(void)addProdInfolistAnddecideShop:(NSString *)shopCode withtype:(NSString *)type{
    NSMutableArray *prodInfolist = [NSMutableArray new];
    for (int i=0;i<_goodsArray.count;i++)
    {
        NSMutableDictionary *prodInfodic = [NSMutableDictionary new];
        MyShoppingTrollyGoodsData *goods=_goodsArray[i];
        goods.shopProdprice = nil;
        
        [prodInfodic setObject:[NSNumber numberWithInt:goods.collocationid.intValue] forKey:@"COLLOCATION_ID"];
        [prodInfodic setObject:[NSNumber numberWithInt:goods.prodid.intValue] forKey:@"PROD_ID"];
        [prodInfodic setObject:[NSNumber numberWithInt:goods.number] forKey:@"QTY"];
        CGFloat price = goods.saleprice * goods.number;
        [prodInfodic setObject:[NSNumber numberWithFloat:price] forKey:@"AMOUNT"];
        [prodInfodic setObject:[NSNumber numberWithInt:goods.number] forKey:@"number"];
        [prodInfolist addObject:prodInfodic];
    }
    
    if ([type isEqualToString:@"1"]) {
        [self requestPostPromotionDisCalcWithDic:(NSMutableDictionary *)@{@"USER_ID":sns.ldap_uid,@"PROD_LIST":prodInfolist}];
      
    }else
    {
    
    //先判断门店
    if (shopCode.length == 0) {
        [self requestGetSCSIGNRECORDFilterWithprodInfolist:prodInfolist];
    }else
        {
        //
        NSMutableArray *proidarray = [NSMutableArray new];
        for (MyShoppingTrollyGoodsData * goodsData in _goodsArray) {
            [proidarray addObject:[NSNumber numberWithInt:goodsData.prodid.intValue]];
        }
        [self requestPostBatchProductPriceFilterWithDic:(NSMutableDictionary *)@{@"shopCODE":shopCode,@"prodIdList":proidarray} withProdInfolist:prodInfolist];
        }
    }
    
}
#pragma mark -- 获得判断门店接口
-(void)requestGetSCSIGNRECORDFilterWithprodInfolist:(NSMutableArray *)prodInfolist{
    //    SHOP_CODE 判断门店code
    [[HttpRequest shareRequst] httpRequestGetSCSIGNRECORDFilterWithDic:(NSMutableDictionary *)@{@"USER_ID":sns.ldap_uid} success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            id data = [obj objectForKey:@"results"];
            if ([data isKindOfClass:[NSArray class]])
            {
                
                NSDictionary *dic =(NSDictionary *)data[0];
                _scanCodeInfo = [JsonToModel objectFromDictionary:dic className:@"ScanCodeInfo"];
                if (_scanCodeInfo.isLose.intValue == 1) {//门店失效 直接计算价格
                    [self requestPostPromotionDisCalcWithDic:(NSMutableDictionary *)@{@"USER_ID":sns.ldap_uid,@"PROD_LIST":prodInfolist}];
                    
                }else
                {
                if (_scanCodeInfo.shoP_CODE!=nil&&_scanCodeInfo.shoP_CODE.length != 0) {
                    [[HttpRequest shareRequst] httpRequestGetOrgBasicInfoFilterWithDic:(NSMutableDictionary *)@{@"ORG_CODE":_scanCodeInfo.shoP_CODE} success:^(id obj)
                    {
                        
                        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
                        {
                            id data2 = [obj objectForKey:@"results"];
                            if ([data2 isKindOfClass:[NSArray class]])
                            {
                                NSDictionary *dic2 =(NSDictionary *)data2[0];
                                _scanCodeInfo.orG_NAME =[dic2 objectForKey:@"orG_NAME"];
                            
                                [self addProdInfolistAnddecideShop:_scanCodeInfo.shoP_CODE withtype:nil];
                              
                            }
                        }
                        
                        
                        [self.tvOrder reloadData];
                    } fail:^(NSString *errorMsg) {
                        
                    }];
                    
                }else{
                    
                }
                
                }
            }
        }else{
        
            
              [self requestPostPromotionDisCalcWithDic:(NSMutableDictionary *)@{@"USER_ID":sns.ldap_uid,@"PROD_LIST":prodInfolist}];
        
        }
    } fail:^(NSString *errorMsg) {
        
    }];


}
#pragma mark -- 门店优惠
-(void)requestPostBatchProductPriceFilterWithDic:(NSMutableDictionary *)dic withProdInfolist:(NSMutableArray *)prodInfolist{


    [[HttpRequest shareRequst] httpRequestPostBatchProductPriceFilterWithDic:dic success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            id data = [obj objectForKey:@"results"];
            
            if ([data isKindOfClass:[NSArray class]])
            {
                
                NSArray *dataarray = (NSArray *)data;
                
                for (NSMutableDictionary *prodic in prodInfolist)
                {
                    NSString *prod_id =[NSString stringWithFormat:@"%@",[prodic objectForKey:@"PROD_ID"]];
                   
                    
                    for (int i = 0; i< dataarray.count; i++) {
                        NSDictionary *dic2 = data[i];
                       NSString *batchProd_id = [NSString stringWithFormat:@"%@",[dic2 objectForKey:@"proD_ID"]];
                        if (prod_id.intValue == batchProd_id.intValue) {
//                            NSString *totalprice =[NSString stringWithFormat:@"%@",[prodic objectForKey:@"AMOUNT"]] ;
//                            NSString *uniT_PRICE = [NSString stringWithFormat:@"%@",[dic2 objectForKey:@"uniT_PRICE"]];
//                            int number = totalprice.intValue/uniT_PRICE.intValue;
                            
                            NSString *salE_PRICE = [NSString stringWithFormat:@"%@",[dic2 objectForKey:@"salE_PRICE"]];
                            NSString * numberString = [NSString stringWithFormat:@"%@",[prodic objectForKey:@"number"]];
                            int number = numberString.intValue;
                            //应为 floatValue
                           [prodic setObject:[NSNumber numberWithFloat:number*salE_PRICE.floatValue] forKey:@"AMOUNT"];
                            
                            //重新赋值门店优惠后的价钱
                            for (int i=0;i<_goodsArray.count;i++)
                            {
                                MyShoppingTrollyGoodsData *goods=_goodsArray[i];
                                if (prod_id.intValue == goods.prodid.intValue) {
                                    
                                    goods.shopProdprice = salE_PRICE;
                                   
                                }
                            }
                            
                        }
                        
                        
                    }
                    
                }
                
                //变换价钱
                amount = [MyShoppingTrollyGoodsData totalPriceWithshopProdprice:_goodsArray];
                

//                //价钱要重新赋值成门店优惠后价钱
//                for (NSMutableDictionary *prodInfodic in prodInfolist) {
//                    [prodInfodic setObject:[NSNumber numberWithFloat:amount] forKey:@"AMOUNT"];
//                }
                
                 [self requestPostPromotionDisCalcWithDic:(NSMutableDictionary *)@{@"USER_ID":sns.ldap_uid,@"PROD_LIST":prodInfolist}];
                
            }
            
        }
        
    } fail:^(NSString *errorMsg) {
        
    }];



}

#pragma mark --价格优惠
-(void)requestPostPromotionDisCalcWithDic:(NSMutableDictionary *)dic{
    [[HttpRequest shareRequst] httpRequestPostPromotionDisCalcWithDic:dic success:^(id obj) {
        
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1) {
            id data = [obj objectForKey:@"results"];
            if ([data isKindOfClass:[NSArray class]]) {
                if (data != nil) {
                    NSDictionary *dic2 = data[0];
                    
                    PromotionCalcInfo *promotionPriceCalcInfo = [JsonToModel objectFromDictionary:dic2 className:@"PromotionCalcInfo"];
                    promotionPriceCalcInfo.postdic = dic2;
                    NSArray *proDList = [dic2 objectForKey:@"proD_LIST"];
                    if (proDList != nil) {
                        NSMutableArray *promotionGoodsInfoArray = [NSMutableArray new];
                        for (NSDictionary *dic3 in proDList) {
                            
                            PromotionGoodsInfo *promotionGoodsInfo = [JsonToModel objectFromDictionary:dic3 className:@"PromotionGoodsInfo"];
                            [promotionGoodsInfoArray addObject:promotionGoodsInfo];
                        }
                        promotionPriceCalcInfo.promotionGoodsInfoList = promotionGoodsInfoArray;
                        
                    }
                    _promotionPriceCalcInfo = promotionPriceCalcInfo;
                    originalAmount = amount;
                    
                    amount = _promotionPriceCalcInfo.amount.floatValue;
                    
                    
                    
                    for (int i = 0; i<_goodsArray.count; i++) {
                        MyShoppingTrollyGoodsData *goods = _goodsArray[i];
                        NSLog(@"goodsid-----%@",goods.prodid);
                        for (PromotionGoodsInfo *promotiongoodsinfo in _promotionPriceCalcInfo.promotionGoodsInfoList)
                        {
                            NSLog(@"promotiongoodsinfo-----%@",promotiongoodsinfo.proD_ID);
                            if (goods.prodid.intValue == promotiongoodsinfo.proD_ID.intValue && goods.collocationid.intValue ==  promotiongoodsinfo.collocatioN_ID.intValue )
                            {
                                
                                goods.promotionGoodsInfo = promotiongoodsinfo;
                            }
                        }
                        
                    }
                    //运费优惠
                    [self requestPostPromotionFeeCalcWithDic:dic];
                    
                    
                    
                }
                
            }
        }
        
        
    } fail:^(NSString *errorMsg) {
        
        
        [Toast hideToastActivity];
    }];
    
    
}

#pragma mark --运费优惠 old
-(void)requestPostPromotionFeeCalcWithDic:(NSMutableDictionary *)dic{
    
    [[HttpRequest shareRequst] httpRequestPostPromotionFeeCalcWithDic:dic success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1) {
            id data = [obj objectForKey:@"results"];
            if ([data isKindOfClass:[NSArray class]]) {
                if (data != nil) {
                    NSDictionary *dic2 = data[0];
                    
                    PromotionCalcInfo *promotionFeeCalcInfo = [JsonToModel objectFromDictionary:dic2 className:@"PromotionCalcInfo"];
                    promotionFeeCalcInfo.postdic = dic2;
                    _promotionFeeCalcInfo = promotionFeeCalcInfo;
                    
                    DEFAULT_FEE = _promotionFeeCalcInfo.fee.doubleValue;
//                   //价格优惠信息
//                    [self requestPostPromotionDisCalcWithDic:(NSMutableDictionary *)dic];
                    
                    disamount=0;
                    summery=amount+DEFAULT_FEE-disamount;
                    [_tvOrder reloadData];
                    
                    _lbSumAndCount.text=[NSString stringWithFormat:@"订单合计: ￥%0.2f    共%d件", summery, count];
                    
                    [Toast hideToastActivity];
                }
            }
        }
        
        
    } fail:^(NSString *errorMsg) {
        [Toast hideToastActivity];
    }];


}
 */
#pragma mark -- 运费门槛
-(void)requestGetFeeCheck{
    
        NSString *msg;
        NSMutableArray *listurl3=[[NSMutableArray alloc] initWithCapacity:10];
    
    [HttpRequest getRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"BSParamFilter" params:@{@"code":@"Default_fee"} success:^(NSDictionary *dict) {
        if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
        {
            id data = [dict objectForKey:@"results"];
            
            if ([data isKindOfClass:[NSArray class]])
            {
                NSDictionary *dic2 = data[0];
                NSString *param_value=[[NSString alloc] initWithFormat:@"%@",dic2[@"paraM_VALUE"] ];
                DEFAULT_FEE = [param_value doubleValue];
                
                [HttpRequest orderGetRequestPath:nil methodName:@"FeeCheck" params:nil success:^(NSDictionary *dict) {
                    
                    
                    if ([dict[@"isSuccess"] integerValue] == 1) {
                        id results = dict[@"results"];
                        NSString *checkFee = [NSString stringWithFormat:@"%@",[[results firstObject] objectForKey:@"value"]];
                        
                        //商品总金额
                        disamount=0;
                        
                        if (amount>=checkFee.floatValue) {
                            DEFAULT_FEE = 0.0f;
                        }
                        summery=amount+DEFAULT_FEE-disamount;
                        
                        summery = [MyShoppingTrollyGoodsData totalFanPiaoPrice:_goodsArray] + DEFAULT_FEE ;
                        summery = originalAmount +DEFAULT_FEE - _fanpiaoMount -_huodongMount;
                        _lbSumAndCount.text=[NSString stringWithFormat:@"订单合计: ￥%0.2f    共%d件", summery, count];
                        [_tvOrder reloadData];
                        [Toast hideToastActivity];
                        
                    }
                    
                } failed:^(NSError *error) {
                    
                }];

                
            }
        }
    } failed:^(NSError *error) {
        
    }];

}

-(NSMutableDictionary *)createCellForName:(NSString*)cellName cellData:(id)data
{
    NSMutableDictionary *returndata=[[NSMutableDictionary alloc] initWithCapacity:2];
    [returndata setObject:cellName forKey:@"type"];
    [returndata setObject:data forKey:@"data"];
    return returndata;
}

-(id)getCellData:(NSString *)cellname
{
    for (int i=0;i<orderInfoArray.count;i++)
    {
        if ([orderInfoArray[i][@"type"] isEqualToString:cellname])
        {
            return orderInfoArray[i][@"data"];
        }
    }
    return nil;
}

-(int)getCellIndex:(NSString *)cellname
{
    for (int i=0;i<orderInfoArray.count;i++)
    {
        if ([orderInfoArray[i][@"type"] isEqualToString:cellname])
        {
            return i;
        }
    }
    return -1;
}

#pragma mark table view datasource & delegate methods

-(void)setCellBackground:(UITableViewCell *)cell
{
    //    UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
    //    backgrdView.backgroundColor=[self getcolor:[[[rootDict objectForKey:@"template"]objectForKey:@"nav"] objectForKey:@"_bgcolor" ]];
    //    backgrdView.backgroundColor = TABLEVIEW_BACKCOLOR;
    //    cell.backgroundView = backgrdView;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (![cell isKindOfClass:[GoodsOrderAddressTableViewCell class]]) {
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-0.5, WINDOWW, 0.5)];
        lineview.tag = 999;
        lineview.alpha = 0.7f;
        lineview.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        [cell.contentView addSubview:lineview];
    }else{
        cell.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    }
    
    //设置selectionStyle = UITableViewCellSelectionStyleNone; 选中的背景无效
    //    UIView *selectedView = [[UIView alloc] initWithFrame:cell.contentView.frame];
    //    selectedView.backgroundColor = [UIColor orangeColor];
    //    cell.selectedBackgroundView = selectedView;   //设置选中后cell的背景颜色
    //    [selectedView release];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return [orderInfoArray count];
//}
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
//    if(section==0)
//    {
//        return 0;
//    }
//    else if(section==1)
//    {
//        return 15;
//    }
//    else if(section==2)
//    {
//        return 0;
//    }
//    else if(section==3)
//    {
//        return 0;
//    }
//    else if(section==4)
//    {
//        return 15;
//    }
//    
//    NSString *cellname=orderInfoArray[section][@"type"];
//    return [cellname isEqualToString:@"GoodsOrderDesignerTableViewCell"]?15:0;
    if (section == 1) {
        return 10.f;
    }
    if (isShowFaPiao) {
        
        if (section == 6) {
            return 30;
        }
    }
    else
    {
        if (section == 5) {
            return 30;
        }
    }

    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    int h=0;
//    if(section==0)
//    {
//        h = 0;
//    }
//    else if(section==1)
//    {
//        h = 15;
//    }
//    else if(section==2)
//    {
//        h = 0;
//    }
//    else if(section==3)
//    {
//        h = 0;
//    }
//    else if(section==4)
//    {
//        h = 15;
//    }
//    else
//    {
//        NSString *cellname=orderInfoArray[section][@"type"];
//        h = [cellname isEqualToString:@"GoodsOrderDesignerTableViewCell"]?15:0;
//    }
    /*
    if (section == 8) {
        h= 15;
    }
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h)];
    view.backgroundColor=[UIColor colorWithHexString:@"#f2f2f2"];
    UILabel *leftlab = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
    leftlab.text = @"优惠信息";
    leftlab.font = [UIFont boldSystemFontOfSize:14.0f];
    [view addSubview:leftlab];
     */
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h)];
    if (isShowFaPiao) {
        if (section == 6) {
            view.backgroundColor=[UIColor colorWithHexString:@"#f2f2f2"];
            UILabel *leftlab = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
            leftlab.text = @"优惠信息";
            leftlab.font = [UIFont boldSystemFontOfSize:14.0f];
            [view addSubview:leftlab];
        }
    }
    else
    {
        if (section == 5) {
            view.backgroundColor=[UIColor colorWithHexString:@"#f2f2f2"];
            UILabel *leftlab = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
            leftlab.text = @"优惠信息";
            leftlab.font = [UIFont boldSystemFontOfSize:14.0f];
            [view addSubview:leftlab];
        }
    }

    
    if (section == 1) {
        view.backgroundColor=[UIColor colorWithHexString:@"#f2f2f2"];
    }
    
    
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
//}
-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [orderInfoArray count];
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
    NSDictionary *rowData=orderInfoArray[indexPath.section];
    NSString *classId = rowData[@"type"];
    if ([classId isEqualToString:@"GoodsOrderSimpleTableViewCell"]) {
        GoodsOrderSimpleTableViewCell *cell = (GoodsOrderSimpleTableViewCell*)[tableView dequeueReusableCellWithIdentifier:classId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:classId owner:self options:nil] objectAtIndex:0];
            [self setCellBackground:cell];
            cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        }

        if (isShowFaPiao) {
            switch (indexPath.section) {
                case 1:
                    cell.leftLab.text = @"支付方式";
                    cell.rightLab.text = _selectedPayType;
                    break;
                    
                case 2:
                    cell.leftLab.text = @"配送方式";
                    
                    cell.rightLab.text = [NSString stringWithFormat:@"%@",_disptchStr];
                    break;
                case 3:
                {
                    cell.leftLab.text = @"发票";
                    cell.rightLab.text = _invoiceStr;
                    //                UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.origin.y, SCREEN_WIDTH, 1)];
                    //                img.backgroundColor=[UIColor lightGrayColor];
                    //                [cell.contentView addSubview:img];
                    break;
                }
                case 4:
                {
                    cell.leftLab.text = [NSString stringWithFormat:@"共%d件商品",[MyShoppingTrollyGoodsData count:_goodsArray]];
                    //未优惠原始的价钱
                    cell.rightLab.text = [NSString stringWithFormat:@"%0.2f",originalAmount];
                    
                    break;
                }
                    //            case 5:
                    //            {
                    //                 cell.rightButton.hidden = YES;
                    //                if (_scanCodeInfo == nil ) {
                    //                    cell.leftLab.text = @"关联门店:未关联门店";
                    //
                    //                }
                    //                else{
                    //                    if (_scanCodeInfo.isLose.boolValue == YES) {
                    //                        cell.leftLab.text = @"关联门店:未关联门店";
                    //                    }else{
                    //                        if (_scanCodeInfo.orG_NAME.length == 0) {
                    //                            _scanCodeInfo.orG_NAME = @"";
                    //                        }
                    //                        cell.leftLab.text = [NSString stringWithFormat:@"门店:%@",_scanCodeInfo.orG_NAME];
                    //                        cell.rightButton.hidden = NO;
                    //                        [cell.rightButton addTarget:self action:@selector(cellRightClick:) forControlEvents:UIControlEventTouchUpInside];
                    //                    }
                    //                }
                    //
                    //                cell.rightLab.text = @"";
                    //                cell.rightimage.hidden = NO;
                    //                cell.cuspImgView.hidden = YES;
                    //                [cell.rightimage setImage:[UIImage imageNamed:@"scan@2x"]];
                    //
                    //                break;
                    //                              }
                case 5:
                {
                    cell.leftLab.text = @"我的范票";
                    
                    if (_currentOrderPacketModel == nil) {
                        cell.rightLab.text = [NSString stringWithFormat:@""];
                        
                    }else{
                        
                        cell.rightLab.text = [NSString stringWithFormat:@"%@",[Utils getSNSString:_currentOrderPacketModel.info]];
                    }
                    //                NSString * amountReal =[NSString stringWithFormat:@"%@",[Utils getSNS02Float:_currentOrderPacketModel.couponuserFilterList.coupoN_AMOUNT_Real]];
                    //                _fanpiaoMount = [amountReal floatValue] >  0? [amountReal floatValue]: 0;
                }
                    break;
                    
                case 6:
                {
                    cell.cuspImgView.hidden = YES;
                    cell.rightLab.frame = CGRectMake(cell.rightLab.frame.origin.x+15, cell.rightLab.frame.origin.y, cell.rightLab.frame.size.width, cell.rightLab.frame.size.height);
                    //                if (_promotionFeeCalcInfo.promotioN_NAME != nil) {
                    //                    cell.leftLab.text = @"运费优惠";
                    //
                    //                    cell.rightLab.text = _promotionFeeCalcInfo.promotioN_NAME;
                    //                }else{
                    cell.leftLab.text = @"运费";
                    if(!isChooseMyRedPacket)
                    {
                        cell.rightLab.text = [NSString stringWithFormat:@"%0.2f",DEFAULT_FEE];
                    }
                    else
                    {
                        
                        cell.rightLab.text = [NSString stringWithFormat:@"%0.2f",[trans_price floatValue]];
                    }
                    
                    //                }
                    
                    
                    
                    break;
                }
                case 7:
                {
                    cell.cuspImgView.hidden = YES;
                    cell.rightLab.frame = CGRectMake(cell.rightLab.frame.origin.x+15, cell.rightLab.frame.origin.y, cell.rightLab.frame.size.width, cell.rightLab.frame.size.height);
                    if (_promotionPriceCalcInfo.promotioN_NAME != nil) {
                        cell.leftLab.text = @"价格优惠";
                        cell.rightLab.text = _promotionPriceCalcInfo.promotioN_NAME;
                        
                    }
                    else{
                        cell.leftLab.text = @"价格优惠";
                        //                    if (_currentOrderPacketModel !=nil) {
                        //                         cell.rightLab.text = [NSString stringWithFormat:@"%0.2f", originalAmount+DEFAULT_FEE -  summery-_currentOrderPacketModel.couponuserFilterList.coupoN_AMOUNT_Real.floatValue];
                        //                    }else{
                        //                     cell.rightLab.text = [NSString stringWithFormat:@"%0.2f", originalAmount+DEFAULT_FEE -  summery];
                        //                    }
                        
                        if(!isChooseMyRedPacket)
                        {
                            cell.rightLab.text = [NSString stringWithFormat:@"%0.2f", originalAmount -  [MyShoppingTrollyGoodsData totalPricebyPlatFormInfo:_goodsArray]];
                            _huodongMount = cell.rightLab.text.floatValue;
                        }
                        else
                        {
                            cell.rightLab.text = [NSString stringWithFormat:@"%0.2f", [dec_price floatValue]];
                            _huodongMount = cell.rightLab.text.floatValue;
                        }
                    }
                    
                    break;
                }
                    
                default:
                    break;
            }
        }
        else
        {
            switch (indexPath.section) {
                case 1:
                    cell.leftLab.text = @"支付方式";
                    cell.rightLab.text = _selectedPayType;
                    break;
                    
                case 2:
                    cell.leftLab.text = @"配送方式";
                    
                    cell.rightLab.text = [NSString stringWithFormat:@"%@",_disptchStr];
                    break;
                case 3:
                {
                    cell.leftLab.text = [NSString stringWithFormat:@"共%d件商品",[MyShoppingTrollyGoodsData count:_goodsArray]];
                    //未优惠原始的价钱
                    cell.rightLab.text = [NSString stringWithFormat:@"%0.2f",originalAmount];
                    
                    break;
                }
                    
                case 4:
                {
                    cell.leftLab.text = @"我的范票";
                    
                    if (_currentOrderPacketModel == nil) {
                        cell.rightLab.text = [NSString stringWithFormat:@""];
                        
                    }else{
                        
                        cell.rightLab.text = [NSString stringWithFormat:@"%@",[Utils getSNSString:_currentOrderPacketModel.info]];
                    }
                    //                NSString * amountReal =[NSString stringWithFormat:@"%@",[Utils getSNS02Float:_currentOrderPacketModel.couponuserFilterList.coupoN_AMOUNT_Real]];
                    //                _fanpiaoMount = [amountReal floatValue] >  0? [amountReal floatValue]: 0;
                }
                    break;
                    
                case 5:
                {
                    cell.cuspImgView.hidden = YES;
                    cell.rightLab.frame = CGRectMake(cell.rightLab.frame.origin.x+15, cell.rightLab.frame.origin.y, cell.rightLab.frame.size.width, cell.rightLab.frame.size.height);
                    //                if (_promotionFeeCalcInfo.promotioN_NAME != nil) {
                    //                    cell.leftLab.text = @"运费优惠";
                    //
                    //                    cell.rightLab.text = _promotionFeeCalcInfo.promotioN_NAME;
                    //                }else{
                    cell.leftLab.text = @"运费";
                    if(!isChooseMyRedPacket)
                    {
                        cell.rightLab.text = [NSString stringWithFormat:@"%0.2f",DEFAULT_FEE];
                    }
                    else
                    {
                        
                        cell.rightLab.text = [NSString stringWithFormat:@"%0.2f",[trans_price floatValue]];
                    }
                    
                    //                }
                    
                    
                    
                    break;
                }
                case 6:
                {
                    cell.cuspImgView.hidden = YES;
                    cell.rightLab.frame = CGRectMake(cell.rightLab.frame.origin.x+15, cell.rightLab.frame.origin.y, cell.rightLab.frame.size.width, cell.rightLab.frame.size.height);
                    if (_promotionPriceCalcInfo.promotioN_NAME != nil) {
                        cell.leftLab.text = @"价格优惠";
                        cell.rightLab.text = _promotionPriceCalcInfo.promotioN_NAME;
                        
                    }
                    else{
                        cell.leftLab.text = @"价格优惠";
                        //                    if (_currentOrderPacketModel !=nil) {
                        //                         cell.rightLab.text = [NSString stringWithFormat:@"%0.2f", originalAmount+DEFAULT_FEE -  summery-_currentOrderPacketModel.couponuserFilterList.coupoN_AMOUNT_Real.floatValue];
                        //                    }else{
                        //                     cell.rightLab.text = [NSString stringWithFormat:@"%0.2f", originalAmount+DEFAULT_FEE -  summery];
                        //                    }
                        
                        if(!isChooseMyRedPacket)
                        {
                            cell.rightLab.text = [NSString stringWithFormat:@"%0.2f", originalAmount -  [MyShoppingTrollyGoodsData totalPricebyPlatFormInfo:_goodsArray]];
                            _huodongMount = cell.rightLab.text.floatValue;
                        }
                        else
                        {
                            cell.rightLab.text = [NSString stringWithFormat:@"%0.2f", [dec_price floatValue]];
                            _huodongMount = cell.rightLab.text.floatValue;
                        }
                    }
                    
                    break;
                }
                    
                default:
                    break;
            }
        }
   
//        cell.rownum=indexPath.section;
//        cell.data=rowData[@"data"];
        return cell;
    }
    else{
        GoodsOrderBaseTableViewCell *cell = (GoodsOrderBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:classId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:classId owner:self options:nil] objectAtIndex:0];
            cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
            [self setCellBackground:cell];
            cell.onTextFieldScroll=[CommonEventHandler instance:self selector:@selector(scrollToRow:eventData:)];
            cell.onTextChanged=[CommonEventHandler instance:self selector:@selector(onTextChanged:eventData:)];
            
            cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.rownum=indexPath.section;
        cell.data=rowData[@"data"];
        return cell;
    }
}

-(void)cellRightClick:(id)sender{
    //不使用用门店优惠
    _scanCodeInfo = nil;
    amount = [MyShoppingTrollyGoodsData totalPrice:_goodsArray];
    
//    [self addProdInfolistAnddecideShop:nil withtype:@"1"]; 废弃9.8


}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


    if (isShowFaPiao) {
        switch (indexPath.section) {
            case 1:{
                [self.payTypePopover dismissMenuPopover];
                _dispatchSimpleCell=  (GoodsOrderSimpleTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                
                self.payTypePopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-150, UI_SCREEN_WIDTH, 150) menuItems:@[@"微信支付",@"支付宝",@"取消"] imageArray:(NSMutableArray *)@[@"wechat@2x",@"zhifubao@2x",@""]];
                self.payTypePopover.delectStr = _selectedPayType;
                self.payTypePopover.menuPopoverDelegate = self;
                [self.payTypePopover showInView:self.view];
                
                break;
            }
            case 2:{
                GoodsDispatchMethodsVC *goodsDispatchMethodsVC = [[GoodsDispatchMethodsVC alloc] init];
                goodsDispatchMethodsVC.selectStr = [NSString stringWithFormat:@"%lu",(unsigned long)[_disptchDatearay indexOfObject:_disptchStr]];
                [goodsDispatchMethodsVC goodsDispatchMethodsVCSourceVoBlock:^(id sender) {
                    GoodsOrderSimpleTableViewCell *cell =  (GoodsOrderSimpleTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                    NSString * select = [NSString stringWithFormat:@"%@",sender];
                    
                    //                [NSString stringWithFormat:@"%@",_disptchDatearay[select.intValue]];
                    _disptchStr = [NSString stringWithFormat:@"%@",_disptchDatearay[select.intValue]];
                    cell.rightLab.text = [NSString stringWithFormat:@"%@",_disptchStr];
                }];
                
                [self.navigationController pushViewController:goodsDispatchMethodsVC animated:YES];
                
                break;
            }
            case 3:{
                GoodsInvoiceViewController *goodsInvoiceVC=[[GoodsInvoiceViewController alloc] initWithNibName:nil bundle:nil];
                
                goodsInvoiceVC.selectStr = _invoiceStr;
                [goodsInvoiceVC goodsInvoiceVCSourceVoBlock:^(id sender) {
                    GoodsOrderSimpleTableViewCell *cell =  (GoodsOrderSimpleTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                    cell.rightLab.text = [NSString stringWithFormat:@"%@",sender];
                    _invoiceStr = [NSString stringWithFormat:@"%@",sender];
                }];
                [self.navigationController pushViewController:goodsInvoiceVC animated:YES];
                break;
            }
            case 4:{
                OrderGoodsListViewController *orderGoodsListVC = [[OrderGoodsListViewController alloc] init];
                
                orderGoodsListVC.goodsArray = self.goodsArray;
                orderGoodsListVC.sumInfo = self.sumInfo;
                [self.navigationController pushViewController:orderGoodsListVC animated:YES];
                break;
            }

            case 5:
            {
                //
                for (MyShoppingTrollyGoodsData *data in _goodsArray)
                {
                    if (data.platFormInfo != nil)
                    {
                        //                    if (data.platFormInfo.id.integerValue == 0) {
                        //                        [Toast makeToast:@"不参加范票优惠"];
                        //                        return;
                        //                    }
                        if (data.platFormInfo.usE_COUPON_FLAG != nil)
                        {
                            if ( data.platFormInfo.usE_COUPON_FLAG.integerValue == 0)
                            {
                                [Toast makeToast:@"不参加范票优惠"];
                                return;
                            }
                            
                        }
                    }
                    
                }
                
                
                //             跳转饭票
                SMBRedPacketViewController *redPacketViewC=[[SMBRedPacketViewController alloc]initWithNibName:@"SMBRedPacketViewController" bundle:nil];
                redPacketViewC.isFromOrder = YES;
                redPacketViewC.prodList = _goodsArray;
                if (_currentOrderPacketModel!=nil) {
                    
                    redPacketViewC.redPacketId= _currentOrderPacketModel.idStr;
                    
                }
                
                [redPacketViewC RedPacketVCSourceVoBlock:^(id sender,id object){
                    NSArray *cartList = (NSArray *)object;
                    if([cartList count]==0)
                    {
                        
                        
                    }
                    GoodsOrderSimpleTableViewCell *cell =  (GoodsOrderSimpleTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                    OrderRedPacketModel *model =(OrderRedPacketModel *)sender;
                    _currentOrderPacketModel = model;
                    NSString *voucherStr=[NSString stringWithFormat:@"%@",model.vouchers];
                    
                    NSDictionary *param=@{@"cartList":cartList,
                                          @"userId":sns.ldap_uid,
                                          @"voucher":[Utils getSNSString:voucherStr]
                                          };
                    NSLog(@"param--%@",param);
                    
                    [HttpRequest promotionPostRequestPath:nil methodName:@"PlatFormVoucherAmount" params:param success:^(NSDictionary *dict) {
                        NSLog(@"-DICT---%@",dict);
                        NSString *isSuccesss=[NSString stringWithFormat:@"%@",dict[@"isSuccess"]];
                        
                        if([isSuccesss isEqualToString:@"1"])
                        {
                            isChooseMyRedPacket= YES;
                            
                            NSArray *resultsArray =[NSArray arrayWithArray:dict[@"results"]];
                            if([resultsArray count]>0)
                            {
                                NSString *total_price=[NSString stringWithFormat:@"%@",resultsArray[0][@"price"]];
                                trans_price=[NSString stringWithFormat:@"%@",resultsArray[0][@"trans_price"]];
                                dec_price = [NSString stringWithFormat:@"%@",resultsArray[0][@"dec_price"]];//优惠价格
                                //                             fanPiaoPrice = [NSString stringWithFormat:@"%@",resultsArray[0][]]
                                amount = [MyShoppingTrollyGoodsData totalFanPiaoPrice:_goodsArray];
                                //商品总金额
                                //               if (model.couponuserFilterList.casH_COUPON_FLAG.integerValue  != 0) {//0是非现金券 1是现金券
                                //                   amount =  amount - model.couponuserFilterList.coupoN_AMOUNT_Real.doubleValue;
                                //               }
                                count = [MyShoppingTrollyGoodsData count:_goodsArray];
                                //                             summery = amount+DEFAULT_FEE;
                                summery = [total_price doubleValue];
                                allFee = summery-[trans_price doubleValue];
                                NSLog(@"allfee－ssss－－－－%f",allFee);
                                
                                _lbSumAndCount.text=[NSString stringWithFormat:@"订单合计: ￥%0.2f    共%d件",summery , count];
                                
                                if (allFee==0) {
                                    if (isShowFaPiao) {
                                        [orderInfoArray removeLastObject];
                                        isShowFaPiao=NO;
                                    }
                                }else
                                {
                                    if (!isShowFaPiao) {
                                        [orderInfoArray addObject:[self createCellForName:@"GoodsOrderSimpleTableViewCell" cellData:@""]];
                                        isShowFaPiao=YES;
                                    }
                                }
                                [_tvOrder reloadData];
                            }
                            
                        }
                        else
                        {
                            NSString *message=[NSString stringWithFormat:@"%@",dict[@"message"]];
                            
                            [Toast makeToast:message];
                            
                        }
                        
                        
                    } failed:^(NSError *error) {
                        
                    }];

                    NSString * infoStr = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",model.info]];//model.couponuserFilterList.//coupoN_AMOUNT_Real
                    
                    cell.rightLab.text = [NSString stringWithFormat:@"%@",[Utils getSNSString:infoStr]];

                }];
                
                
                [self.navigationController pushViewController:redPacketViewC animated:YES];
                
            }
                
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.section) {
            case 1:{
                
                [self.payTypePopover dismissMenuPopover];
                _dispatchSimpleCell=  (GoodsOrderSimpleTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                
                self.payTypePopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-150, UI_SCREEN_WIDTH, 150) menuItems:@[@"微信支付",@"支付宝",@"取消"] imageArray:(NSMutableArray *)@[@"wechat@2x",@"zhifubao@2x",@""]];
                self.payTypePopover.delectStr = _selectedPayType;
                self.payTypePopover.menuPopoverDelegate = self;
                [self.payTypePopover showInView:self.view];
                
                break;
            }
            case 2:{
                GoodsDispatchMethodsVC *goodsDispatchMethodsVC = [[GoodsDispatchMethodsVC alloc] init];
                goodsDispatchMethodsVC.selectStr = [NSString stringWithFormat:@"%lu",(unsigned long)[_disptchDatearay indexOfObject:_disptchStr]];
                [goodsDispatchMethodsVC goodsDispatchMethodsVCSourceVoBlock:^(id sender) {
                    GoodsOrderSimpleTableViewCell *cell =  (GoodsOrderSimpleTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                    NSString * select = [NSString stringWithFormat:@"%@",sender];
                    
                    //                [NSString stringWithFormat:@"%@",_disptchDatearay[select.intValue]];
                    _disptchStr = [NSString stringWithFormat:@"%@",_disptchDatearay[select.intValue]];
                    cell.rightLab.text = [NSString stringWithFormat:@"%@",_disptchStr];
                }];
                
                [self.navigationController pushViewController:goodsDispatchMethodsVC animated:YES];
                
                break;
            }
            case 3:{
                OrderGoodsListViewController *orderGoodsListVC = [[OrderGoodsListViewController alloc] init];
                
                orderGoodsListVC.goodsArray = self.goodsArray;
                orderGoodsListVC.sumInfo = self.sumInfo;
                [self.navigationController pushViewController:orderGoodsListVC animated:YES];
                break;
            }
            case 4:
            {
                //
                for (MyShoppingTrollyGoodsData *data in _goodsArray)
                {
                    if (data.platFormInfo != nil)
                    {
                        //                    if (data.platFormInfo.id.integerValue == 0) {
                        //                        [Toast makeToast:@"不参加范票优惠"];
                        //                        return;
                        //                    }
                        if (data.platFormInfo.usE_COUPON_FLAG != nil)
                        {
                            if ( data.platFormInfo.usE_COUPON_FLAG.integerValue == 0)
                            {
                                [Toast makeToast:@"不参加范票优惠"];
                                return;
                            }
                            
                        }
                    }
                    
                }
                
                
                //             跳转饭票
                SMBRedPacketViewController *redPacketViewC=[[SMBRedPacketViewController alloc]initWithNibName:@"SMBRedPacketViewController" bundle:nil];
                redPacketViewC.isFromOrder = YES;
                redPacketViewC.prodList = _goodsArray;
                if (_currentOrderPacketModel!=nil) {
                    
                    redPacketViewC.redPacketId= _currentOrderPacketModel.idStr;
                    
                }
                
                [redPacketViewC RedPacketVCSourceVoBlock:^(id sender,id object){
                    NSArray *cartList = (NSArray *)object;
                    if([cartList count]==0)
                    {
                        
                        
                    }
                    GoodsOrderSimpleTableViewCell *cell =  (GoodsOrderSimpleTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                    OrderRedPacketModel *model =(OrderRedPacketModel *)sender;
                    _currentOrderPacketModel = model;
                    NSString *voucherStr=[NSString stringWithFormat:@"%@",model.vouchers];
                    
                    NSDictionary *param=@{@"cartList":cartList,
                                          @"userId":sns.ldap_uid,
                                          @"voucher":[Utils getSNSString:voucherStr]
                                          };
                    NSLog(@"param--%@",param);
                    
                    [HttpRequest promotionPostRequestPath:nil methodName:@"PlatFormVoucherAmount" params:param success:^(NSDictionary *dict) {
                        NSLog(@"-DICT---%@",dict);
                        NSString *isSuccesss=[NSString stringWithFormat:@"%@",dict[@"isSuccess"]];
                        
                        if([isSuccesss isEqualToString:@"1"])
                        {
                            isChooseMyRedPacket= YES;
                            
                            NSArray *resultsArray =[NSArray arrayWithArray:dict[@"results"]];
                            if([resultsArray count]>0)
                            {
                                NSString *total_price=[NSString stringWithFormat:@"%@",resultsArray[0][@"price"]];
                                trans_price=[NSString stringWithFormat:@"%@",resultsArray[0][@"trans_price"]];
                                dec_price = [NSString stringWithFormat:@"%@",resultsArray[0][@"dec_price"]];//优惠价格
                                //                             fanPiaoPrice = [NSString stringWithFormat:@"%@",resultsArray[0][]]
                                amount = [MyShoppingTrollyGoodsData totalFanPiaoPrice:_goodsArray];
                                //商品总金额
                                //               if (model.couponuserFilterList.casH_COUPON_FLAG.integerValue  != 0) {//0是非现金券 1是现金券
                                //                   amount =  amount - model.couponuserFilterList.coupoN_AMOUNT_Real.doubleValue;
                                //               }
                                count = [MyShoppingTrollyGoodsData count:_goodsArray];
                                //                             summery = amount+DEFAULT_FEE;
                                summery = [total_price doubleValue];
                                allFee = summery-[trans_price doubleValue];
                                NSLog(@"allfee－－－－－%f",allFee);
                                if (allFee==0) {
                                    if (isShowFaPiao) {
                                        [orderInfoArray removeLastObject];
                                        isShowFaPiao=NO;
                                    }
                                }else
                                {
                                    if (!isShowFaPiao) {
                                         [orderInfoArray addObject:[self createCellForName:@"GoodsOrderSimpleTableViewCell" cellData:@""]];
                                        isShowFaPiao=YES;
                                    }
                                }
                                _lbSumAndCount.text=[NSString stringWithFormat:@"订单合计: ￥%0.2f    共%d件",summery , count];
                                
                                
                                [_tvOrder reloadData];
                            }
                            
                        }
                        else
                        {
                            NSString *message=[NSString stringWithFormat:@"%@",dict[@"message"]];
                            
                            [Toast makeToast:message];
                            
                        }
                        
                        
                    } failed:^(NSError *error) {
                        
                    }];
                    
                    
                    
                    NSString * infoStr = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",model.info]];//model.couponuserFilterList.//coupoN_AMOUNT_Real
                    
                    cell.rightLab.text = [NSString stringWithFormat:@"%@",[Utils getSNSString:infoStr]];
                    
                    
                    /*
                     if (model == nil) {//点击取消参与处理
                     for (MyShoppingTrollyGoodsData *good in _goodsArray) {
                     
                     good.diS_Price = [NSString stringWithFormat:@"0"];
                     good.brandCode = [NSString stringWithFormat:@"0"];
                     }
                     //                   _fanpiaoMount = 0.0f;
                     
                     }else
                     {
                     for (MyShoppingTrollyGoodsData *good in _goodsArray)
                     {
                     
                     for (NSDictionary *orderPacketDic in _currentOrderPacketModel.prodLst)
                     {
                     
                     if (good.prodid.integerValue == [orderPacketDic[@"prodId"] integerValue])
                     {
                     good.diS_Price = [NSString stringWithFormat:@"%@",orderPacketDic[@"diS_Price"]];
                     good.brandCode = [NSString stringWithFormat:@"%@",orderPacketDic[@"brandCode"]];
                     }else{
                     good.diS_Price = @"0";
                     good.brandCode = @"0";
                     
                     }
                     }
                     
                     }
                     
                     
                     }
                     */
                    
                    //              amount = [MyShoppingTrollyGoodsData totalFanPiaoPrice:_goodsArray];
                    //               //商品总金额
                    ////               if (model.couponuserFilterList.casH_COUPON_FLAG.integerValue  != 0) {//0是非现金券 1是现金券
                    ////                   amount =  amount - model.couponuserFilterList.coupoN_AMOUNT_Real.doubleValue;
                    ////               }
                    //               count = [MyShoppingTrollyGoodsData count:_goodsArray];
                    //               summery = amount+DEFAULT_FEE;
                    //               _lbSumAndCount.text=[NSString stringWithFormat:@"订单合计: ￥%0.2f    共%d件",summery , count];
                    //               [_tvOrder reloadData];
                    //价格 不需要走了
                    //               [self requestGetFeeCheck];
                    
                }];
                
                
                [self.navigationController pushViewController:redPacketViewC animated:YES];
                
            }
                
            default:
                break;
        }
 
    }
    
    
    NSDictionary *rowData=orderInfoArray[indexPath.section];
    NSString *classId = rowData[@"type"];
    if ([classId isEqualToString:@"GoodsOrderAddressTableViewCell"])
    {
        MyAdderssViewController *addressVC = [[MyAdderssViewController alloc] initWithNibName:@"MyAdderssViewController" bundle:nil];
        addressVC.onSelectedRow=[CommonEventHandler instance:self selector:@selector(MyAdderssViewController_onAddressSelected:eventData:)];
        [self.navigationController pushViewController:addressVC animated:YES];
    }
    else if ([classId isEqualToString:@""])
    {
        
    }
}

#pragma mark --MLKMenuPopoverDelegate


- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex{

    [self.payTypePopover dismissMenuPopover];
    if (selectedIndex != 2) {
        _dispatchSimpleCell.rightLab.text = [NSString stringWithFormat:@"%@",@[@"微信支付",@"支付宝",@"取消"][selectedIndex]];
        _selectedPayType = [NSString stringWithFormat:@"%@",@[@"微信支付",@"支付宝",@"取消"][selectedIndex]];
    }
   

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height=0;
    NSDictionary *rowData=orderInfoArray[indexPath.section];
    NSString *classId = rowData[@"type"];
    
    if ([classId isEqualToString:@"GoodsOrderAddressTableViewCell"])
    {
        height=[GoodsOrderAddressTableViewCell getCellHeight:rowData[@"data"]];

    }
    else if ([classId isEqualToString:@"GoodsOrderAmountTableViewCell"])
    {
        height=[GoodsOrderAmountTableViewCell getCellHeight:rowData[@"data"]];
    }
    else if ([classId isEqualToString:@"GoodsOrderPayFeeTableViewCell"])
    {
        height=[GoodsOrderPayFeeTableViewCell getCellHeight:rowData[@"data"]];
    }
    else if ([classId isEqualToString:@"GoodsOrderGoodsTableViewCell"])
    {
        height=[GoodsOrderGoodsTableViewCell getCellHeight:rowData[@"data"]];
    }
    else if ([classId isEqualToString:@"GoodsOrderDesignerTableViewCell"])
    {
        height=[GoodsOrderDesignerTableViewCell getCellHeight:rowData[@"data"]];
    }
    else if ([classId isEqualToString:@"GoodsOrderMemoTableViewCell"])
    {
        height=[GoodsOrderMemoTableViewCell getCellHeight:rowData[@"data"]];
    }
    else if ([classId isEqualToString:@"GoodsOrderSendRequestTableViewCell"])
    {
        height=[GoodsOrderSendRequestTableViewCell getCellHeight:rowData[@"data"]];
    }
    else if ([classId isEqualToString:@"GoodsOrderSimpleTableViewCell"])
    {
        height=[GoodsOrderSimpleTableViewCell getCellHeight:rowData[@"data"]];
    }
    
    return height;
}

-(void)scrollToRow:(id)sender eventData:(NSNumber*)rownum
{
    
//    [_tvOrder scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[rownum intValue] inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:YES];
}

-(void)onTextChanged:(id)sender eventData:(NSString*)text
{
    GoodsOrderBaseTableViewCell *view=(GoodsOrderBaseTableViewCell *)sender;
    NSMutableDictionary *dict=orderInfoArray[view.rownum];
    [dict setObject:text forKey:@"data"];
}

-(void)MyAdderssViewController_onAddressSelected:(id)sender eventData:(NSDictionary*)eventData
{
    int index=[self getCellIndex:@"GoodsOrderAddressTableViewCell"];
    if (index>=0)
    {
        NSMutableDictionary *dict=orderInfoArray[index];
        [dict setObject:eventData forKey:@"data"];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        NSArray *arr=[[NSArray alloc] initWithObjects:indexPath, nil];
        [_tvOrder reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)btnBackClick:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - zbar
- (void)QRPaymentSelect:(NSInteger)indexPathRow{
    //ZBar扫描
    AVAuthorizationStatus isAllow = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (isAllow == AVAuthorizationStatusDenied) {
        [Utils alertMessage:@"相机功能已经禁止，请去设置中打开"];
        return;
    }
    if (!self.reader) {
        self.reader = [CommonZBarViewController new];
        self.reader.isZbar = YES;
        self.reader.view.height = self.view.height + 64;
        self.reader.delegate = self;
        self.reader.whereComeFrom = ComeFromOrderConfirm ;
        //        [self.reader buidViewforZbar];
    }
    /* jonnywang
     if (indexPathRow == 1) {
     self.reader.codeType = DirectionsCode; //虽然留着 但是已经没用了
     }else {
     self.reader.codeType = NoCode;
     }
     [self.reader showVi];
     */
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.reader];
    nav.navigationBarHidden = YES;
    [self.reader buidViewforZbar];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - CommonZBarViewControllerDelegate
- (void)showHomeFromZBar
{
    
}
- (void)goToViewControllerWithGoodsSN:(NSString *)GoodsSN
{
    
    
}

- (void)dissmissZbar:(NSDictionary*)responseJSON{
    if (responseJSON != nil) {
        NSDictionary *resultDic =  [responseJSON objectForKey:@"result"];
        
        _scanCodeInfo = [ScanCodeInfo new];
        //    type ＝ 1  是门店 type ＝ 2 是导购
        //    NSString *typeStr = [responseJSON objectForKey:@"type"];
        //    if ([typeStr isEqualToString:@"2"]) {
        //
        //    }
        _scanCodeInfo.shoP_CODE = [resultDic objectForKey:@"ORG_CODE"];
        _scanCodeInfo.orG_NAME = [resultDic objectForKey:@"ORG_NAME"];
        _scanCodeInfo.seller_UserId = [resultDic objectForKey:@"USER_ID"];//导购id
        _scanCodeInfo.isLose = @"0";
        
        //门店优惠相关 3.11 add by miao
        [self performSelector:@selector(delayRequest:) withObject:self afterDelay:1.0f];
       
        
//        [self.tvOrder reloadData];

    }
}


-(void)delayRequest:(id)sender{
    //废弃  9.8
//  [self addProdInfolistAnddecideShop:_scanCodeInfo.shoP_CODE withtype:nil];

}
#pragma mark --
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"titlearray-----%d",buttonIndex);
    if (_dispatchSimpleCell != nil&& buttonIndex <3) {
            _dispatchSimpleCell.rightLab.text = titlearray[buttonIndex];
        invo_index=(int)buttonIndex;
    }
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{



}
-(void)canShowPraiseBox
{
    [SUTILITY_TOOL_INSTANCE showPraiseBox];
}
#pragma mark --  提交订单
- (IBAction)btnPayClick:(id)sender {
    
  

    if (_invoiceStr == nil) {
        _invoiceStr = @"不开发票";
    }
    [TalkingData trackEvent:@"提交订单" label:@"按下'提交订单'"];
    NSMutableDictionary *addressInfo=[self getCellData:@"GoodsOrderAddressTableViewCell"];
    if (addressInfo[@"noaddress"]!=nil)
    {
        
        [Utils alertMessage:@"请填写完整的收货地址！"];
        [TalkingData trackEvent:@"提交订单" label:@"提交订单失败(未填写收货地址)"];
        return;
    }
    if([_selectedPayType isEqualToString:@"微信支付"])
    {
        if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]))
        {
            [TalkingData trackEvent:@"提交订单" label:@"支付中断(未安装微信)"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"安装微信" message:@"请安装新版微信后，再支付订单！" delegate:self cancelButtonTitle:@"安装" otherButtonTitles:@"取消", nil];
            alertView.tag=1000;
            [alertView show];
            return;
        }
    }
    

    /**
    if ([_selectedPayType isEqualToString:@"微信支付"])
    {
        if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]))
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"安装微信" message:@"请安装新版微信后，再支付订单！" delegate:self cancelButtonTitle:@"安装" otherButtonTitles:@"取消", nil];
            [alertView show];
              btn.enabled=YES;
            return;
        }
    }
    *****/
    
    if(sns.ldap_uid.length==0)
    {
        sns.isLogin=NO;
        if (![BaseViewController pushLoginViewController]) {
            
            return;
            
        }
    }
    UIButton *btn=sender;
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    btn.enabled=NO;
    [Toast makeToastActivity:@"正在提交订单..." hasMusk:YES];
    //{"memo":"String","type":"String","source":"String","receiver":"String","teL_PHONE":"String","country":"String","province":"String","city":"String","county":"String","street":"String","address":"String","posT_CODE":"String","senD_REQUIRE":"String","remark":"String","fee":0,"invoicE_TITLE":"String","userId":"String","creatE_USER":"String","shopingCartList":[{"id":0,"proD_ID":0,"source":"String","qty":0,"userId":"String","sharE_SELLER_ID":"String","collocatioN_ID":"String","designerId":"String","designerName":"String"}],"paymentList":[{"ordeR_ID":0,"payment":"String","paY_STATE":"String","paY_TYPE":"String","makE_AMOUNT":0}]}
    //payment:
    //PAYMENT_ONLINE = "ON_LINE";付款方式-在线支付
    //PAYMENT_OFFLINE = "OFF_LINE"付款方式-货到付款
    //
    //paY_TYPE:
    //PAYTYPE_WX = "WX";支付方式-微信支付
    //PAYTYPE_ZFB = "ZFB";支付方式-支付宝支付
    //PAYTYPE_CASH = "CASH";支付方式-现金
    NSMutableArray *payment=[[NSMutableArray alloc] init];
    NSString *makeAmoutnString = [NSString stringWithFormat:@"%.2f", summery];
    if ([_selectedPayType isEqualToString:@"微信支付"]) {
        [payment addObject:@{@"payment":@"ON_LINE",@"paY_TYPE":@"WX",@"makE_AMOUNT": makeAmoutnString}];
    }else{
        [payment addObject:@{@"payment":@"ON_LINE",@"paY_TYPE":@"ZFB",@"makE_AMOUNT": makeAmoutnString}];
    }
    
    NSMutableArray *shopingcartlist=[[NSMutableArray alloc] init];
//    NSMutableArray *detaillist=[[NSMutableArray alloc] init];
    NSMutableArray *memoArr=[[NSMutableArray alloc] init];
    NSMutableArray *buyProductIDArray = [NSMutableArray array];
    for (int i=0;i<_goodsArray.count;i++)
    {
        MyShoppingTrollyGoodsData *goods=_goodsArray[i];
        
        NSString *sharE_SELLER_ID = @"";
        
        //add by miao 3.4  分享人问题
        if ( _scanCodeInfo.seller_UserId.length == 0) {
            sharE_SELLER_ID = goods.shareUserId;
         
        }else{
            sharE_SELLER_ID = _scanCodeInfo.seller_UserId;
        }
           sharE_SELLER_ID = [Utils getSNSString:sharE_SELLER_ID];
//        if ([sharE_SELLER_ID isEqualToString:sns.ldap_uid]) {
//            
//            sharE_SELLER_ID = @"";
//        }
        
        if (goods.prodid.length == 0) {//试衣间数据
            NSMutableDictionary *dic = [@{} mutableCopy];
            [dic addEntriesFromDictionary:[goods.value objectForKey:@"productInfo"]];
            [shopingcartlist addObject:dic];
        }else{
            NSString *promotion_id = @"0";
            if (goods.prodInfo != nil && goods.platFormInfo != nil) {
                promotion_id = goods.platFormInfo.platPromId;
            }
            NSDictionary *shopCartNew =@{@"cartId":goods.shoppingcartid,
                                         @"barcode":goods.prodNum,
                                         @"num":[NSString stringWithFormat:@"%d",goods.number],
                                         @"cid":goods.collocationid,
                                         @"aid":promotion_id};
            /*
            
            NSDictionary *dictshopcart1=@{
                                          @"ID":goods.shoppingcartid,
                                          @"PROD_ID":goods.prodid,
                                          @"SPEC_ID":goods.sizeid,
                                          @"COLOR_ID":goods.colorid,
                                          @"QTY": [NSString stringWithFormat:@"%d",goods.number],
                                          //                                      @"PRICE":[NSString stringWithFormat:@"%0.2f",goods.price],
                                          @"userId":sns.ldap_uid,
                                          //                                      @"CREATE_USER":user.displayName
                                          @"sharE_SELLER_ID": sharE_SELLER_ID,
                                          @"collocatioN_ID":goods.collocationid,
                                          @"designerId":goods.designerid,
                                          @"designerName":goods.designername,
                                          @"ACT_PRICE":goods.shopProdprice.length == 0?[NSString stringWithFormat:@"%0.2f",goods.saleprice]:goods.shopProdprice,
                                          @"PROMOTION_ID":[Utils getSNSInteger:promotion_id]
                                          };
            NSMutableDictionary  *dictshopcart2= [NSMutableDictionary dictionaryWithDictionary:dictshopcart1];
            //add by miao 610
            if (_currentOrderPacketModel != nil) {
                if (goods.prodInfo != nil) {
                     [dictshopcart2 setObject:[NSNumber numberWithFloat:goods.saleprice  -goods.prodInfo.diS_Price.floatValue- goods.diS_Price.floatValue]forKey:@"ACT_PRICE"];
                }else{
                [dictshopcart2 setObject:[NSNumber numberWithFloat:goods.saleprice - goods.prodInfo.diS_Price.floatValue]forKey:@"ACT_PRICE"];
                }
            }
             //add by miao 活动优惠  6.8
             [shopingcartlist addObject:dictshopcart2];
            */
            //add by 新接口
            [shopingcartlist addObject:shopCartNew];
        }
     
        
        
        
        [memoArr addObject:goods.prodname];
        NSString *messageString = goods.lM_PROD_CLS_ID? goods.lM_PROD_CLS_ID: @"异常数据";
        [buyProductIDArray addObject:messageString];
//        NSDictionary *dictdetail=@{@"QTY": [NSString stringWithFormat:@"%d",goods.number],
//                                   @"REMARK":@"",
//                                   @"AMOUNT":[NSString stringWithFormat:@"%0.2f",goods.price*(float)goods.number],
//                                   @"UNIT_PRICE":[NSString stringWithFormat:@"%0.2f",goods.saleprice],
//                                   @"ACT_PRICE":[NSString stringWithFormat:@"%0.2f",goods.price],
//                                   @"PROD_ID":goods.prodid,
//                                   @"DIS_AMOUNT":@"0"};
//        [detaillist addObject:dictdetail];
    }
   
    //addressInfo
    [TalkingData trackEvent:@"提交订单" label:@"提交订单包含商品ID" parameters:@{@"提交商品ID数组": buyProductIDArray}];
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:
                                  @{
                                    @"memo":@"",
                                    @"SHOP_CODE":_scanCodeInfo.shoP_CODE.length == 0 ?@"":_scanCodeInfo.shoP_CODE,
                                    @"type":@"RETAIL",
                                    @"source":@"5",//原来是3 add by miao 6.16
                                    @"receiver":addressInfo[@"name"],
                                    @"teL_PHONE":addressInfo[@"mobileno"],
                                    @"country":addressInfo[@"country"],
                                    @"province":addressInfo[@"province"],
                                    @"city":addressInfo[@"city"],
                                    @"county":addressInfo[@"county"],
                                    @"address":addressInfo[@"address"],
                                    @"posT_CODE":addressInfo[@"post_code"],
                                    @"senD_REQUIRE":_disptchStr,
                                    @"invoicE_TITLE":_invoiceStr,
                                    @"userId":sns.ldap_uid,
                                    @"cartList":shopingcartlist,
                                    @"paymentAry":payment
                                    }];
    //add by miao 6.8 范票
    NSMutableArray *couponInfolist = [NSMutableArray new];
    
#warning     修改饭票
//    if (_currentOrderPacketModel.couponuserFilterList.coupoN_CODE.length != 0) {
//        [couponInfolist addObject:@{@"UserCouponCode":_currentOrderPacketModel.couponuserFilterList.coupoN_CODE}];
//    }
    [param setObject:couponInfolist forKey:@"CouponInfoList"];
    
    if (_uniquesessionid == nil) {
        _uniquesessionid = [NSString stringWithFormat:@"%@%@%@",[[Globle shareInstance] getuuid],[[Globle shareInstance] getTimeNow],[[Globle shareInstance] getRandomWord]];
    }
    NSLog(@"_uniquesessionid------%@",_uniquesessionid);//时间戳
    [param setObject:_uniquesessionid forKey:@"uniquesessionid"];

//    if (_promotionFeeCalcInfo != nil ) {//运费优惠
//        [param setObject:_promotionFeeCalcInfo.postdic forKey:@"FeeInfo"];
//    }
//    if (_promotionPriceCalcInfo != nil) {//价格优惠
//        [param setObject:_promotionPriceCalcInfo.postdic forKey:@"DisInfo"];
//    }
    //  * vouchers  范票优惠信息  饭票id"
    NSString *vouchersIdStr=[NSString stringWithFormat:@"%@",_currentOrderPacketModel.idStr];
    NSString *vouchers = [NSString stringWithFormat:@"%@",_currentOrderPacketModel.vouchers];
    
    [param setObject:[Utils getSNSString:vouchersIdStr] forKey:@"vouchersId"];
    [param setObject:[Utils getSNSString:vouchers] forKey:@"vouchers"];
    
    NSLog(@"orderCreaterequestObj--param=%@",[param JSONString]);

    [HttpRequest orderPostRequestPath:nil methodName:@"OrderCreate" params:param success:^(NSDictionary *dict) {
        [Toast hideToastActivity];
        NSString *issuccess = [NSString stringWithFormat:@"%@",dict[@"isSuccess"]];
        
        if ([issuccess isEqualToString:@"1"])
        {
            [TalkingData trackEvent:@"提交订单" label:@"创建订单成功"];
//              [self performSelector:@selector(canShowPraiseBox) withObject:nil afterDelay:3.0];
            float newSummery=[dict[@"waitingPayAmount"] floatValue];
            //                float newSummery=newAmount+DEFAULT_FEE;
            self.param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"有范订单%@",dict[@"message"]],@"body", dict[@"message"],@"out_trade_no",[[NSNumber alloc] initWithFloat:newSummery],@"total_fee",sns.ldap_uid,@"UserId",[InetAddress getLocalHost],@"spbill_create_ip",sns.myStaffCard.nick_name ,@"CREATE_USER",memoArr,@"productNameArray",nil];
            if (summery != newSummery) {
                summery = newSummery;
            }
//            [self checkOrderGoodNum];
            [self payreatedMethod];
            btn.enabled=YES;
        }
        else
        {
            NSString *productid=nil;
            NSString *messagestr=nil;
            NSArray *paraArr=[dict[@"message"] componentsSeparatedByString:@";"];
            [TalkingData trackEvent:@"提交订单" label:@"创建订单失败(数据错误)" parameters:@{@"返回错误信息": dict[@"message"] ? dict[@"message"] : @"", @"返回错误数据": dict? dict: @""}];
            if (paraArr.count==2)
            {
                productid=paraArr[0];
                messagestr=[NSString stringWithFormat:@"%@",paraArr[1]];
                if ([Utils getSNSString:messagestr].length==0 ) {
                    messagestr=@"数据错误!";
                }
                [Utils alertMessage:[NSString stringWithFormat:@"订单提交失败！(%@)",messagestr]];
            }
            else{
                NSString *message = [NSString stringWithFormat:@"%@",dict[@"message"]];
                if([Utils getSNSString:message].length==0)
                {
                    message=@"数据错误!";
                }
                [Utils alertMessage:[NSString stringWithFormat:@"订单提交失败！%@",[Utils getSNSString:message]]];
            }
            btn.enabled=YES;
        }

    } failed:^(NSError *error) {
        [Utils alertMessage:[NSString stringWithFormat:@"订单提交失败!"]];
    }];
    return;
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 100:
            if (buttonIndex==0) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
            }
            break;
        case 200:
            if (buttonIndex==1) {
//                [self checkOrderGoodNum];
                [self payreatedMethod];
            }
            break;
            case 1000:
        {
            //安装 的话 跳转到 appstore 微信下载
            if (buttonIndex==0) {

             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
            }
        }
    }
}
//支付之前要进行一下库存对接处理
-(void)checkOrderGoodNum
{
       //支付之前要进行一下库存对接处理
//    Order支付前的库存检测
//    checkStockForPay($cartList){
    NSMutableArray *cartList=[@[] mutableCopy];
    
    
    for (int i=0;i<_goodsArray.count;i++)
    {
        MyShoppingTrollyGoodsData *goods=_goodsArray[i];
        
        NSDictionary *shopCartNew =@{
                                     @"barcode":goods.prodNum,
                                     @"num":[NSString stringWithFormat:@"%d",goods.number],
                                     };
        [cartList addObject:shopCartNew];
    }
    
    [HttpRequest orderGetRequestPath:nil methodName:@"checkStockForPay" params:@{@"cartList":cartList} success:^(NSDictionary *dict) {
        NSString *isSuccess=[NSString stringWithFormat:@"%@",dict[@"isSuccess"]];
        NSString *message = [NSString stringWithFormat:@"%@",dict[@"message"]];
        if ([isSuccess boolValue]) {
            [self payreatedMethod];
        }
        else
        {
            if ([Utils getSNSString:message].length==0) {
                message=@"库存不足!";
                
            }
            [Toast makeToast:message mask:NO];
            
        }
        
        
    } failed:^(NSError *error) {
        NSLog(@"faild－－－%@",error);
        NSString *domainStr = [NSString stringWithFormat:@"%@",error.domain];
        
            if ([Utils getSNSString:domainStr].length==0) {
                domainStr=@"数据错误!";
                
            }
            [Toast makeToast:domainStr mask:NO];
        
    }];
    
}

#pragma mark-----微信支付and支付宝支付
-(void)payreatedMethod{
    //支付之前要进行一下库存对接处理
   
    [TalkingData trackEvent:@"提交订单" label:@"支付订单"];
    if ([_selectedPayType isEqualToString:@"微信支付"])
    {
        [TalkingData trackEvent:@"提交订单" label:@"微信支付"];
        if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]))
        {
            [TalkingData trackEvent:@"提交订单" label:@"支付中断(未安装微信)"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"安装微信" message:@"请安装新版微信后，再支付订单！" delegate:self cancelButtonTitle:@"安装" otherButtonTitles:@"取消", nil];
            alertView.tag=100;
            
            [alertView show];
            return;
        }
        
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
        [[NSNotificationCenter defaultCenter ] postNotificationName:@"notification_refreshtableView" object:nil];
        
        [self popAnimated:YES];
        

//        NSArray *list=[[NSArray alloc]init];
        
        /*  此接口不用 微信的三参数 登陆时候获取配置文件已获取
        [HttpRequest orderGetRequestPath:nil methodName:@"PaymentAccountFilter" params:@{@"APP_ID":[NSString stringWithFormat:@"%@",kWXAPP_ID]} success:^(NSDictionary *dict) {
            if (dict[@"isSuccess"])
            {
                NSArray *list = dict[@"results"];
                [Toast hideToastActivity];
                if (list.count>0)
                {
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
                    [wxPayClient payProduct:payCompleteEvent payAccountInfo:list[0]];
                }
            }else{
                [Toast hideToastActivity];
                [TalkingData trackEvent:@"提交订单" label:@"微信支付(生成支付信息失败)" parameters:@{@"生成错误信息": dict[@"message"]? dict[@"message"]: @""}];
                [Utils alertMessage:@"生成支付信息失败！"];
            }
        } failed:^(NSError *error) {
            
        }];
        */
    }
    else
    {//支付宝支付
        [TalkingData trackEvent:@"提交订单" label:@"支付宝支付"];
        __block BOOL rst=NO;
        [Toast makeToastActivity:@"支付宝支付..." hasMusk:YES];
        
        [[NSNotificationCenter defaultCenter ] postNotificationName:@"notification_refreshtableView" object:nil];
        
//        [self popAnimated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //            NSMutableArray *list=[[NSMutableArray alloc] initWithCapacity:10];
            //            NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
            //微信支付返回微信的一些秘钥
            //            BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:@"PaymentAccountFilter" param:@{@"APP_ID":[NSString stringWithFormat:@"%@",PartnerID]} responseList:list responseMsg:msg];
            BOOL success = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success)
                {
                    [Toast hideToastActivity];
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
//
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
                    
//                    PayResultViewController *payResultVC=[[PayResultViewController alloc] initWithNibName:@"PayResultViewController" bundle:nil];
//                    payResultVC.orderCode=[NSString stringWithFormat:@"%@",self.param[@"out_trade_no"]];
//                    [self.navigationController pushViewController:payResultVC animated:YES];
//        [self performSelector:@selector(canShowPraiseBox) withObject:nil afterDelay:3.0];
        NSString *webUr=[NSString stringWithFormat:@"%@?orderId=%@",HTML_ORDER_SUCCESS,self.param[@"out_trade_no"]];
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
//                    //12.16 add by miao
//                     [self payAliFailureCallback:nil];
//                }
//            });
//        });
    }
    else
    {
        
        NSString *msg=eventData[@"msg"];
        [Utils alertMessage:msg];
        [Toast hideToastActivity];
        //12.16 add by miao
        [self payAliFailureCallback:nil];
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
                        
//                         [self performSelector:@selector(canShowPraiseBox) withObject:nil afterDelay:3.0];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYALICOMPLETE object:nil userInfo:@{@"AlixPayResult":resultDic}];
                        //                }
                        [TalkingData trackEvent:@"提交订单" label:@"支付宝支付(验证签名成功，交易结果无篡改)"];
                    }
                        break;
                    case 8000:
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYFAILURE object:nil userInfo:@{@"AlixPayResult":resultDic}];
                        //支付宝返回原因 正在处理中
                        [Toast makeToast:[resultDic objectForKey:@"result"]];
                        [TalkingData trackEvent:@"提交订单" label:@"支付宝支付错误" parameters:@{@"错误原因": @"支付宝返回原因 正在处理中", @"支付宝返回信息": resultDic? resultDic: @""}];
                        
                        break;
                    case 4000:
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYFAILURE object:nil userInfo:@{@"AlixPayResult":resultDic}];
                        //支付宝返回原因 订单支付失败
                        [Toast makeToast:[resultDic objectForKey:@"result"]];
                        [TalkingData trackEvent:@"提交订单" label:@"支付宝支付错误" parameters:@{@"错误原因": @"支付宝返回原因 订单支付失败", @"支付宝返回信息": resultDic? resultDic: @""}];
                        
                        break;
                    case 6001:
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYFAILURE object:nil userInfo:@{@"AlixPayResult":resultDic}];
                        //支付宝返回原因 用户中途取消
                        [Toast makeToast:@"亲,中途取消"];
                        [TalkingData trackEvent:@"提交订单" label:@"支付宝支付错误" parameters:@{@"错误原因": @"支付宝返回原因 用户中途取消", @"支付宝返回信息": resultDic? resultDic: @""}];
                        
                        break;
                    case 6002:
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYFAILURE object:nil userInfo:@{@"AlixPayResult":resultDic}];
                        //支付宝返回原因 网络连接出错
                        [Toast makeToast:[resultDic objectForKey:@"result"]];
                        [TalkingData trackEvent:@"提交订单" label:@"支付宝支付错误" parameters:@{@"错误原因": @"支付宝返回原因 网络连接出错", @"支付宝返回信息": resultDic? resultDic: @""}];
                        
                        break;
                    default:
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYFAILURE object:nil userInfo:@{@"AlixPayResult":resultDic}];
                        //交易失败
                        [Toast makeToast:[resultDic objectForKey:@"result"]];
                        [TalkingData trackEvent:@"提交订单" label:@"支付宝支付错误" parameters:@{@"错误原因": @"交易失败", @"支付宝返回信息": resultDic? resultDic: @""}];
                        break;
                }
                
            }
            else
            {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYFAILURE object:nil userInfo:@{@"AlixPayResult":@"亲,交易未成功"}];
                [TalkingData trackEvent:@"提交订单" label:@"支付宝支付(未成功)"];
                //失败
                [Toast makeToast:@"亲,交易未成功"];
            }
            

            
        }];
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
    
    // 只用一种配置，避免问题    修改要通知相关开发 要改全
//    if ( [Globle shareInstance].alipayNotifyUrl != nil) {
//         order.notifyURL =  [Globle shareInstance].alipayNotifyUrl;
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
//    NSLog(@"paymentResultDelegate---%@",result);
    
    //
    //param   no 提示 返回 param-Dic
    //    param YES   往 mb 缴费信息 支付成功  获取token  预支付  = 支付 - -支付成功(写入mb)
    [[NSNotificationCenter defaultCenter] postNotificationName:HUDDismissNotification object:nil userInfo:nil];
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
                    
//                    PayResultViewController *payResultVC=[[PayResultViewController alloc] initWithNibName:@"PayResultViewController" bundle:nil];
//                    payResultVC.orderCode=[NSString stringWithFormat:@"%@",self.param[@"out_trade_no"]];
//                    [self.navigationController pushViewController:payResultVC animated:YES];
//          [self performSelector:@selector(canShowPraiseBox) withObject:nil afterDelay:3.0];
        NSString *webUr=[NSString stringWithFormat:@"%@?orderId=%@",HTML_ORDER_SUCCESS,self.param[@"out_trade_no"]];
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

-(void)payAliFailureCallback:(id)sender{
    
    MyOrderViewController *orderVC=[[MyOrderViewController alloc] initWithNibName:@"MyOrderViewController" bundle:nil];
    [self.navigationController pushViewController:orderVC animated:YES];

}



@end
