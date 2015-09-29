//
//  DetailReturnMoneyViewController.m
//  Wefafa
//
//  Created by fafatime on 14-12-10.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "DetailReturnMoneyViewController.h"
#import "Toast.h"
#import "NavigationTitleView.h"
#import "Utils.h"
#import "ModelBase.h"
#import "MBShoppingGuideInterface.h"
#import "SQLiteOper.h"
#import "ReturnTableViewCell.h"
#import "CommMBBusiness.h"
#import "ExpressageViewController.H"
#import "SUtilityTool.h"
#import "HttpRequest.h"

@interface DetailReturnMoneyViewController ()
{
    NSArray *cellNameArray;
  
    NSDictionary *showRefundDic;
    
    NSDictionary *requestDataDic;
    BOOL isReturnGoods;
    NSString *allMoney;
    UIButton *doneBtn;//填写完成后 要隐藏填写快递信息按钮
    
}
@end

@implementation DetailReturnMoneyViewController
@synthesize detailGoodDic;
@synthesize colloctionDic;
@synthesize titleStr;
@synthesize isReturn;
@synthesize colloctionDicOrderModel;
@synthesize detaiGoodDicOrderModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)setupNavbar {
    [super setupNavbar];

    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;

    self.title = self.titleStr;
    
    
}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _headView.backgroundColor =[UIColor whiteColor];
//    self.view.backgroundColor=TABLEVIEW_BACKGROUND_COLOR;
    showRefundDic = [NSDictionary new];
    CGRect headrect=CGRectMake(0,0,_headView.frame.size.width,_headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=self.titleStr;
//    [_headView addSubview:view];
    
    [self setupNavbar];
    self.view.backgroundColor = TITLE_BG;
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50)];
    footView.backgroundColor=[Utils HexColor:0xf2f2f2 Alpha:1];
    UILabel *showLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, UI_SCREEN_WIDTH, 15)];
    showLabel.backgroundColor=[UIColor clearColor];
    showLabel.textColor=[Utils HexColor:0x999999 Alpha:1];
    showLabel.font=FONT_t4;
    showLabel.textAlignment=NSTextAlignmentCenter;
    showLabel.text=@"客服电话: 400-821-9988";
    [footView addSubview:showLabel];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenBtn) name:@"hiddenbtn" object:nil];
    _statesLabel.textColor=[Utils HexColor:0X3B3B3B Alpha:1];
    _statesLabel.font=FONT_T4;
    
    _showDetailTableView.tableFooterView=footView;
    _showDetailTableView.backgroundColor=[Utils HexColor:0xf2f2f2 Alpha:1];
    
    NSString *goodReapP_ID;
    /*
    if ([self.isReturn isEqualToString:@"退货"])
    {
       goodReapP_ID=[NSString stringWithFormat:@"%@",self.colloctionDic[@"orderReturnInfo"][@"id"]];
    }
    else if ([self.isReturn isEqualToString:@"退款"])
    {
        goodReapP_ID=[NSString stringWithFormat:@"%@",self.colloctionDic[@"id"]];
    }
    else
    {
     goodReapP_ID=[NSString stringWithFormat:@"%@",self.detailGoodDic[@"detailInfo"][@"reapP_ID"]];
    }
    */
    if ([self.isReturn isEqualToString:@"退货"]||[self.isReturn isEqualToString:@"退款"])
    {
        goodReapP_ID=[NSString stringWithFormat:@"%@",self.colloctionDic[@"orderReturnInfo"][@"id"]];
    }
//    else if ([self.isReturn isEqualToString:@"退款"])
//    {
//        goodReapP_ID=[NSString stringWithFormat:@"%@",self.colloctionDic[@"id"]];
//    }
    else
    {
        goodReapP_ID=[NSString stringWithFormat:@"%@",self.detaiGoodDicOrderModel.detailInfo.reapP_ID];
    }
    //订单编号
    NSDictionary *paramDic=@{@"id":goodReapP_ID,@"userId":sns.ldap_uid};
    //退款单号
  __block  NSMutableArray *returnListArray=[NSMutableArray new];
    [Toast makeToastActivity:@"正在加载,请稍后..." hasMusk:YES];
    requestDataDic = [NSDictionary new];
   
    if ([self.titleStr isEqualToString:@"退货详情"]) {
        
        _showDetailTableView.tableHeaderView=_returnGoodHeadView;
        _hasReplyImgView.layer.masksToBounds=YES;
        _hasReplyImgView.layer.cornerRadius =_hasReplyImgView.frame.size.width/2;
        _hasReplyImgView.layer.borderColor = [UIColor clearColor].CGColor;
        _hasReplyImgView.layer.borderWidth =1.0;
//        _hasReplyImgView.backgroundColor=[UIColor greenColor];
        _processingImgView.layer.masksToBounds=YES;
        _processingImgView.layer.cornerRadius =_processingImgView.frame.size.width/2;
        _processingImgView.layer.borderColor = [UIColor clearColor].CGColor;
        _processingImgView.layer.borderWidth =1.0;
//        _processingImgView.backgroundColor=[UIColor greenColor];
        _finishImgView.layer.masksToBounds=YES;
        _finishImgView.layer.cornerRadius =_finishImgView.frame.size.width/2;
        _finishImgView.layer.borderColor = [UIColor clearColor].CGColor;
        _finishImgView.layer.borderWidth =1.0;
//        _finishImgView.backgroundColor=[UIColor greenColor];
        cellNameArray=@[@"退货状态",@"退款金额",@"退货原因",@"退货说明",@"退货编号",@"申请时间"];
        isReturnGoods=YES;
        
        
        [HttpRequest orderGetRequestPath:nil methodName:@"OrderReturnFilter" params:paramDic success:^(NSDictionary *dict) {
            NSString *isSuccess = [NSString stringWithFormat:@"%@",dict[@"isSuccess"]];
            if ([isSuccess boolValue]) {
                returnListArray = dict[@"results"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                    if([returnListArray count]==0 )
                    {
                        return ;
                    }
#ifdef DEBUG
                    NSLog(@"退货-----%@",returnListArray);
                    
#endif
                    requestDataDic = returnListArray[0];
                    //                    _statesLabel.text =[NSString stringWithFormat:@"%@",[Utils getSNSString:requestDataDic[@"orderReturnInfo"][@"stateName"]]];
                    //                    _moneyLabel.text=[NSString stringWithFormat:@"%@",requestDataDic[@"orderReturnInfo"][@"returN_AMOUNT"]];//加魂飞
                    
                    NSString *dateString=[NSString stringWithFormat:@"%@",requestDataDic[@"orderReturnInfo"][@"lasT_MODIFIED_DATE"]];
                    NSString *state=[NSString stringWithFormat:@"%@",requestDataDic[@"orderReturnInfo"][@"state"]];
                    NSString *stateName = [NSString stringWithFormat:@"%@",requestDataDic[@"orderReturnInfo"][@"stateName"]];
                    NSString *showTime=[CommMBBusiness getdate:dateString];
                    _timeLabel.text=showTime;
                    //只有在state==1 已审批的状态下 才有快递信息按钮
                    if ([state isEqualToString:@"1"]) {
                        
                        cellNameArray=@[@"退货状态",@"退款金额",@"退货原因",@"退货说明",@"退货编号",@"申请时间"];
                        //                        _hasReplyImgView.backgroundColor=[UIColor redColor];
                        [_hasReplyImgView setImage:[UIImage imageNamed:@"yellowpoint@2x"]];
                        _hasReplyLabel.textColor=[Utils HexColor:0x3b3b3b3 Alpha:1];
                        _hasReplyLabel.font=FONT_T6;
                        [_processingImgView setImage:[UIImage imageNamed:@"graypoint@2x"]];//ico_results
                        //                        _processingImgView.backgroundColor=[UIColor grayColor];
                        _processLabel.font=FONT_t6;
                        _processLabel.textColor=[Utils HexColor:0x999999 Alpha:1];
                        _finishLabel.textColor=[Utils HexColor:0x999999 Alpha:1];
                        _finishLabel.font=FONT_t6;
                        //                        _finishImgView.backgroundColor=[UIColor grayColor];
                        [_finishImgView setImage:[UIImage imageNamed:@"graypoint@2x"]];
                        doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                        [doneBtn setFrame:CGRectMake(15, UI_SCREEN_HEIGHT-55, UI_SCREEN_WIDTH-30, 40)];
                        [doneBtn setTitle:@"填写快递信息" forState:UIControlStateNormal];
                        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [doneBtn addTarget:self action:@selector(writeExpress) forControlEvents:UIControlEventTouchUpInside];
                        doneBtn.backgroundColor=[UIColor blackColor];
//                        [self.view addSubview:doneBtn];
//                        [_showDetailTableView setFrame:CGRectMake(_showDetailTableView.frame.origin.x, _showDetailTableView.frame.origin.y, _showDetailTableView.frame.size.width, _showDetailTableView.frame.size.height-55-15)];
                    }
                    else if([state isEqualToString:@"6"]||[state isEqualToString:@"9"])//退款完成
                    {
                        //                        _finishImgView.backgroundColor=[UIColor redColor];
                        _processLabel.textColor=[UIColor colorWithRed:102.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
                        _hasReplyLabel.textColor=[UIColor colorWithRed:102.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
                        _processLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
                        _hasReplyLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
                        _hasReplyLabel.font=FONT_t6;
                        _processLabel.font=FONT_t6;
                        _finishLabel.textColor=[Utils HexColor:0x3b3b3b3 Alpha:1];
                        _finishLabel.font=FONT_T6;
                        [_finishImgView setImage:[UIImage imageNamed:@"yellowpoint@2x"]];
                    }
                    else if( [state isEqualToString:@"-1"])
                    {
                        _processLabel.textColor=[UIColor colorWithRed:102.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
                        _hasReplyLabel.textColor=[UIColor colorWithRed:102.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
                        _processLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
                        _hasReplyLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
                        _hasReplyLabel.font=FONT_t6;
                        _processLabel.font=FONT_t6;
                        _finishLabel.textColor=[Utils HexColor:0x3b3b3b3 Alpha:1];
                        _finishLabel.text=[Utils getSNSString:stateName];
                        
                        _finishLabel.font=FONT_T6;
                        [_finishImgView setImage:[UIImage imageNamed:@"yellowpoint@2x"]];
                    }
                    else
                    {
                        //                        _processingImgView.backgroundColor=[UIColor redColor]
                        _hasReplyLabel.textColor=[UIColor colorWithRed:102.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
                        [_processingImgView setImage:[UIImage imageNamed:@"yellowpoint@2x"]];
                        _hasReplyLabel.font=FONT_t6;
                        _processLabel.font=FONT_T6;
                        _processLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
                        _hasReplyLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
                        _processLabel.textColor=[UIColor redColor];
                        //                        _finishImgView.backgroundColor=[UIColor grayColor];
                        _finishLabel.textColor=[Utils HexColor:0x999999 Alpha:1];
                        _finishLabel.font=FONT_t6;
                        [_finishImgView setImage:[UIImage imageNamed:@"graypoint@2x"]];
                    }
                    
                    [_showDetailTableView reloadData];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                });
            }
        } failed:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast hideToastActivity];
            });
        }];
    }
    else{
        
        _showDetailTableView.tableHeaderView=_tableViewHeadView;
        cellNameArray=@[@"退款状态",@"退款金额",@"退款原因",@"退款说明",@"退款编号",@"申请时间"];
        isReturnGoods=NO;
        [HttpRequest orderGetRequestPath:nil methodName:@"OrderReturnFilter" params:paramDic success:^(NSDictionary *dict) {
            NSString *isSuccess=[NSString stringWithFormat:@"%@",dict[@"isSuccess"]];
            if([isSuccess boolValue])
            {
                returnListArray = dict[@"results"];
                
#ifdef DEBUG
                NSLog(@"respon退款----%@",returnListArray);
#endif
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [Toast hideToastActivity];
                    if ([returnListArray count]==0) {
                        return;
                        
                    }
                    requestDataDic = returnListArray[0];
                    _statesLabel.text =[NSString stringWithFormat:@"%@",[Utils getSNSString:requestDataDic[@"orderReturnInfo"][@"stateName"]]];
                    //                    _moneyLabel.text=[NSString stringWithFormat:@"%@",requestDataDic[@"refundProdDtlList"][0][@"refunD_AMOUNT"]];
                    
                    
                    //退款金额，运费 new
                    NSString *refunD_Amount=[NSString stringWithFormat:@"%@",requestDataDic[@"orderReturnInfo"][@"returN_AMOUNT"]];
                    NSString *freight =[NSString stringWithFormat:@"%@",requestDataDic[@"orderReturnInfo"][@"freight"]];//运费
                    //                    NSString *dis_Amount = @"";
                    //                    if([[requestDataDic allKeys] containsObject:@"refundProdDtList"])
                    //                    {
                    //                        dis_Amount= [NSString stringWithFormat:@"%@",requestDataDic[@"refundProdDtList"][0][@"diS_AMOUNT"]];
                    //                    }-[dis_Amount floatValue]
                    float all;
                    all = [refunD_Amount floatValue]+[freight floatValue];
                    
                    allMoney = [NSString stringWithFormat:@"%0.2f",all];
                    _moneyLabel.text = [NSString stringWithFormat:@"%@",allMoney];
                    /*
                     NSArray *refundPro=requestDataDic[@"refundProdDtlList"];
                     
                     if ([refundPro count]>0&&refundPro!=nil)
                     {
                     NSString *refunD_Amount=[NSString stringWithFormat:@"%@",requestDataDic[@"refundProdDtlList"][0][@"refunD_AMOUNT"]];
                     
                     NSString *feeMoney = [NSString stringWithFormat:@"%@",requestDataDic[@"refundProdDtlList"][0][@"fee"]];
                     float all;
                     all = [refunD_Amount floatValue]+[feeMoney floatValue];
                     
                     allMoney = [NSString stringWithFormat:@"%0.2f",all];
                     _moneyLabel.text = [NSString stringWithFormat:@"%@",allMoney];
                     }else
                     {
                     NSString *refunD_Amount=[NSString stringWithFormat:@"%@",requestDataDic[@"refunD_AMOUNT"]];
                     
                     NSString *feeMoney = [NSString stringWithFormat:@"%@",requestDataDic[@"fee"]];
                     float all;
                     all = [refunD_Amount floatValue]+[feeMoney floatValue];
                     
                     allMoney = [NSString stringWithFormat:@"%0.2f",all];
                     _moneyLabel.text = [NSString stringWithFormat:@"%@",allMoney];
                     }
                     */
                    
                    NSString *dateString=[NSString stringWithFormat:@"%@",requestDataDic[@"orderReturnInfo"][@"lasT_MODIFIED_DATE"]];
//                    NSString *showTime=[CommMBBusiness getdate:dateString];
                    _timeLabel.text=dateString;
                    [_showDetailTableView reloadData];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                });
            }
        } failed:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast hideToastActivity];
            });
            
        }];



    }
    

}
-(void)hiddenBtn
{
    doneBtn.hidden=YES;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 43;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cellNameArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ReturnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ReturnTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.nameLabel.text=cellNameArray[indexPath.row];
    cell.nameLabel.textColor=[Utils HexColor:0X999999 Alpha:1];
    cell.nameLabel.font=FONT_t4;
    cell.showDetailLabel.textColor=[Utils HexColor:0X3B3B3B Alpha:1];
    cell.showDetailLabel.font=FONT_t4;
    switch (indexPath.row) {
        case 0:
        {
         
            if ([self.isReturn isEqualToString:@"退货"])
            {
//                cell.showDetailLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:requestDataDic[@"orderReturnInfo"][@"stateName"]]];
                NSString *stateName =[NSString stringWithFormat:@"%@",[Utils getSNSString:requestDataDic[@"orderReturnInfo"][@"stateName"]]];
                if ([Utils getSNSString:stateName].length==0) {
                    stateName=@"退货";
                }
                   cell.showDetailLabel.text=stateName;
            }
            else if ([self.isReturn isEqualToString:@"退款"])
            {
                NSString *stateName =[NSString stringWithFormat:@"%@",[Utils getSNSString:requestDataDic[@"orderReturnInfo"][@"stateName"]]];
                if ([Utils getSNSString:stateName].length==0) {
                    stateName=@"退款";
                }
                  cell.showDetailLabel.text=stateName;
            }
            else
            {
                if ([self.titleStr isEqualToString:@"退货详情"]) {
                    NSString *stateName =[NSString stringWithFormat:@"%@",[Utils getSNSString:requestDataDic[@"orderReturnInfo"][@"stateName"]]];
                    if ([Utils getSNSString:stateName].length==0) {
                        stateName=@"退货";
                    }
                    cell.showDetailLabel.text=stateName;
                    
                }
                else
                {
                    NSString *stateName =[NSString stringWithFormat:@"%@",[Utils getSNSString:requestDataDic[@"orderReturnInfo"][@"stateName"]]];
                if ([Utils getSNSString:stateName].length==0) {
                        stateName=@"退款";
                    }
                    cell.showDetailLabel.text = stateName;
                }
 
            }

  
        }
            break;
        case 1:
        {

            if (isReturnGoods) {
                NSString *returnAmount =[NSString stringWithFormat:@"%@",requestDataDic[@"orderReturnInfo"][@"returN_AMOUNT"]];
                NSString *feeStr;
//                NSString *disamount;
                NSArray *refundPro=requestDataDic[@"returnRetailList"];
//                NSArray *prodList= requestDataDic[@"prodList"];
                if([refundPro count]>0&&refundPro!=nil)
                {
                    feeStr=[NSString stringWithFormat:@"%@",requestDataDic[@"returnRetailList"][0][@"fee"]];
                }
                feeStr =0;//4.23 wwp  退货退款 页面中退款金额不加运费。

                float all;
                all = [returnAmount floatValue]+[feeStr floatValue];
                NSString *detailAll= [NSString stringWithFormat:@"%0.2f",all];
                cell.showDetailLabel.text= [Utils getSNSString:detailAll];
                
                
            }
            else{
                cell.showDetailLabel.text=allMoney;
            }
        }
            break;
        case 2:
        {
//            if (isReturnGoods) {
                cell.showDetailLabel.text=[Utils getSNSString:requestDataDic[@"orderReturnInfo"][@"reason"]];
//            }
//            else
//            {
//               cell.showDetailLabel.text=[Utils getSNSString:requestDataDic[@"reason"]];
//            }
        }
            break;
        case 3:
        {
//            if (isReturnGoods) {
                NSString *des=[NSString stringWithFormat:@"%@",requestDataDic[@"orderReturnInfo"][@"remark"]];
                cell.showDetailLabel.text=[Utils getSNSString:des];
//            }
//            else
//            {
//                NSString *des=[NSString stringWithFormat:@"%@",requestDataDic[@"description"]];
//                cell.showDetailLabel.text=[Utils getSNSString:des];
//            }
        }
            break;
        case 4:
        {
//            if (isReturnGoods) {
                NSString *codeSt=[NSString stringWithFormat:@"%@",requestDataDic[@"orderReturnInfo"][@"code"]];
                cell.showDetailLabel.text=[Utils getSNSString:codeSt];
//            }
//            else{
//                NSString *codeSt=[NSString stringWithFormat:@"%@",requestDataDic[@"code"]];
//                cell.showDetailLabel.text=[Utils getSNSString:codeSt];
//            }
        }
            break;
        case 5:
        {
//            if (isReturnGoods) {
                NSString *dateString=[NSString stringWithFormat:@"%@",requestDataDic[@"orderReturnInfo"][@"creatE_DATE"]];
//                NSString *showTime=[CommMBBusiness getdate:dateString];
                cell.showDetailLabel.text=[Utils getSNSString:dateString];
//            }
//            else {
//                NSString *dateString=[NSString stringWithFormat:@"%@",requestDataDic[@"creatE_DATE"]];
//                NSString *showTime=[CommMBBusiness getdate:dateString];
//                cell.showDetailLabel.text=showTime;
//            }

        }
            break;
            case 6:
        {
            NSArray *expressArray =requestDataDic[@"returnRetailList"];
            if ([expressArray count]>0&&expressArray!=nil) {
                NSString *expressName=[NSString stringWithFormat:@"%@", requestDataDic[@"returnRetailList"][0][@"expressname"]];
                NSString *expressNo=[NSString stringWithFormat:@"%@",requestDataDic[@"returnRetailList"][0][@"expresS_NO"]];
                cell.showDetailLabel.text=[NSString stringWithFormat:@"%@  %@",[Utils getSNSString:expressName],[Utils getSNSString:expressNo]];
            }
            else
            {
                
            } 
        }
            
        default:
            break;
    }
    return cell;
    
}
-(void)writeExpress
{
    ExpressageViewController *express= [[ExpressageViewController alloc]initWithNibName:@"ExpressageViewController" bundle:nil];
   
    express.returnDataDic = requestDataDic;
    if ([self.isReturn isEqualToString:@"退货"])
    {
        express.isReturn=YES;
         express.goodsDic = self.colloctionDic;
    }
    else if ([self.isReturn isEqualToString:@"退款"])
    {
         express.isReturn=YES;
         express.goodsDic = self.colloctionDic;
    }
    else
    {
        express.isReturn=NO;
         express.goodsDicOrderModel =self.detaiGoodDicOrderModel;
        
    }
    [self.navigationController pushViewController:express animated:YES];
}
-(void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    
//    if ([SHOPPING_GUIDE_ITF requestGetUrlName:@"RefundAppFilter" param:paramDic responseList:returnListArray responseMsg:returnMsg]) {
//#ifdef DEBUG
//        NSLog(@"respon退款----%@",returnListArray);
//#endif
//        
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [Toast hideToastActivity];
//            if ([returnListArray count]==0) {
//                return;
//                
//            }
//            requestDataDic = returnListArray[0];
//            _statesLabel.text =[NSString stringWithFormat:@"%@",[Utils getSNSString:requestDataDic[@"statusName"]]];
//            //                    _moneyLabel.text=[NSString stringWithFormat:@"%@",requestDataDic[@"refundProdDtlList"][0][@"refunD_AMOUNT"]];
//            
//            
//            //退款金额，运费 new
//            NSString *refunD_Amount=[NSString stringWithFormat:@"%@",requestDataDic[@"refunD_AMOUNT"]];
//            NSString *freight =[NSString stringWithFormat:@"%@",requestDataDic[@"freight"]];//运费
//            //                    NSString *dis_Amount = @"";
//            //                    if([[requestDataDic allKeys] containsObject:@"refundProdDtList"])
//            //                    {
//            //                        dis_Amount= [NSString stringWithFormat:@"%@",requestDataDic[@"refundProdDtList"][0][@"diS_AMOUNT"]];
//            //                    }-[dis_Amount floatValue]
//            float all;
//            all = [refunD_Amount floatValue]+[freight floatValue];
//            
//            allMoney = [NSString stringWithFormat:@"%0.2f",all];
//            _moneyLabel.text = [NSString stringWithFormat:@"%@",allMoney];
//            /*
//             NSArray *refundPro=requestDataDic[@"refundProdDtlList"];
//             
//             if ([refundPro count]>0&&refundPro!=nil)
//             {
//             NSString *refunD_Amount=[NSString stringWithFormat:@"%@",requestDataDic[@"refundProdDtlList"][0][@"refunD_AMOUNT"]];
//             
//             NSString *feeMoney = [NSString stringWithFormat:@"%@",requestDataDic[@"refundProdDtlList"][0][@"fee"]];
//             float all;
//             all = [refunD_Amount floatValue]+[feeMoney floatValue];
//             
//             allMoney = [NSString stringWithFormat:@"%0.2f",all];
//             _moneyLabel.text = [NSString stringWithFormat:@"%@",allMoney];
//             }else
//             {
//             NSString *refunD_Amount=[NSString stringWithFormat:@"%@",requestDataDic[@"refunD_AMOUNT"]];
//             
//             NSString *feeMoney = [NSString stringWithFormat:@"%@",requestDataDic[@"fee"]];
//             float all;
//             all = [refunD_Amount floatValue]+[feeMoney floatValue];
//             
//             allMoney = [NSString stringWithFormat:@"%0.2f",all];
//             _moneyLabel.text = [NSString stringWithFormat:@"%@",allMoney];
//             }
//             */
//            
//            NSString *dateString=[NSString stringWithFormat:@"%@",requestDataDic[@"lasT_MODIFIED_DATE"]];
//            NSString *showTime=[CommMBBusiness getdate:dateString];
//            _timeLabel.text=showTime;
//            [_showDetailTableView reloadData];
//        });
//        
//    }else{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [Toast hideToastActivity];
//        });
//    }
//    
//});
@end
