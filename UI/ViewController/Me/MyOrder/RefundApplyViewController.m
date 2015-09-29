//
//  RefundApplyViewController.m
//  Wefafa
//
//  Created by fafatime on 14-12-5.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "RefundApplyViewController.h"
#import "Toast.h"
#import "NavigationTitleView.h"
#import "Utils.h"
#import "ModelBase.h"
#import "OrderOtherTableViewCell.h"
#import "MBShoppingGuideInterface.h"
#import "SQLiteOper.h"
#import "DetailReasonViewController.h"
#import "SUtilityTool.h"
#import "OrderModel.h"
#import "HttpRequest.h"
#import "SDataCache.h"

@interface RefundApplyViewController ()
{
    NSArray *sectionArray;
    NSArray *remarkArray;
    NSArray *cellArray;
    NSString *reasonStr;
    NSString *numStr;
    NSString *descriptionStr;
    int moreNum;
    NSIndexPath * indexPathTwo;
    NSString *price;
    int goodSection;
    NSMutableArray *expressArray;
    NSString *chooseReason;
    NSString *returnDes;
    
    
    
}
@end

@implementation RefundApplyViewController
@synthesize goodDic;
@synthesize collocationDic;
@synthesize titleStr;
@synthesize isReturn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
//    numStr = [NSString stringWithFormat:@"1"];
}
-(void)viewWillDisappear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChanged:) name:@"postValue" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"postValue" object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _headView.backgroundColor =[UIColor blackColor];
    CGRect headrect=CGRectMake(0,0,_headView.frame.size.width,_headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=self.titleStr;

     numStr = [NSString stringWithFormat:@"1"];
    [self setupNavbar];
    
    returnDes = [[NSString alloc]init];
    
    NSString *goodName ;
    NSString *nums;
    float allPrice;
    if ([self.isReturn isEqualToString:@"退款"])
    {
//        OrderModelRefundProdDtlListInfo *refundProdDtlListInfo =self.collocationDicOrderModel.refundProdDtlList[0];
//        nums=[NSString stringWithFormat:@"%@",refundProdDtlListInfo.refunD_QTY];
//        goodName  = [NSString stringWithFormat:@"%@",refundProdDtlListInfo.prodName];
//        price=[NSString stringWithFormat:@"%@",refundProdDtlListInfo.price];
//        退货退款 不需要model
        nums=[NSString stringWithFormat:@"%@",self.collocationDic[@"refundProdDtlList"][0][@"refunD_QTY"]];
        goodName  = [NSString stringWithFormat:@"%@",self.collocationDic[@"refundProdDtlList"][0][@"prodName"]];
        price=[NSString stringWithFormat:@"%@",self.collocationDic[@"refundProdDtlList"][0][@"price"]];
        //        allPrice = 0;
        
    }else if ([self.isReturn isEqualToString:@"退货"])
    {
//        OrderModelProdListInfo*prodListInfo =self.collocationDicOrderModel.prodList[0];
//        nums=[NSString stringWithFormat:@"%@",prodListInfo.qty];
//        goodName  = [NSString stringWithFormat:@"%@",prodListInfo.prodName];
//        price=[NSString stringWithFormat:@"%@",prodListInfo.price];
        nums=[NSString stringWithFormat:@"%@",self.collocationDic[@"prodList"][0][@"qty"]];
        goodName  = [NSString stringWithFormat:@"%@",self.collocationDic[@"prodList"][0][@"prodName"]];
        price=[NSString stringWithFormat:@"%@",self.collocationDic[@"prodList"][0][@"price"]];
        //        allPrice=0;
    }
    else
    {
        OrderModelDetailInfo *detailInfo = self.goodDicOrderModel.detailInfo;
        nums=[NSString stringWithFormat:@"%@",detailInfo.qty];
        goodName  = [NSString stringWithFormat:@"%@",self.goodDicOrderModel.proudctList.productInfo.proD_NAME];
        price=[NSString stringWithFormat:@"%@",detailInfo.acT_PRICE];
        NSString *disamount = [NSString stringWithFormat:@"%@",detailInfo.diS_AMOUNT];
        allPrice =  [price floatValue]-[disamount floatValue];

    }

    moreNum=[nums intValue];
    numStr = [NSString stringWithFormat:@"1"];
    NSString *moreStrNum=[NSString stringWithFormat:@"最多%@件",nums];
    _goodOrMoneyLabel.font=FONT_t5;
    _goodOrMoneyLabel.textColor= [Utils HexColor:0x3b3b3b Alpha:1];
    if ([self.titleStr isEqualToString:@"申请退款"]) {
        sectionArray = @[@"退款原因",@"商品数量",@"退款说明"];
        remarkArray=@[@" ",moreStrNum,@"可不填"];
        _goodOrMoneyLabel.text=@"退款商品名称:";
        _priceLabel.text=@"退款商品单价:";
        goodSection=1;
       
    }
    else {
        goodSection=3;
        sectionArray = @[@"退货原因",@"退货数量",@"退货说明"];
        remarkArray=@[@" ",moreStrNum,@"可不填"];
        _goodOrMoneyLabel.text=@"退货商品名称:";
        _priceLabel.text=@"退货商品单价:";
        goodSection=1;
    }
     _listTableView.tableHeaderView=_tableViewHeadView;
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_HEIGHT, 50)];
    footView.backgroundColor=[UIColor clearColor];
    UILabel *showLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, UI_SCREEN_WIDTH, 15)];
    showLabel.backgroundColor=[UIColor clearColor];
//    showLabel.textColor=[Utils HexColor:0x6b6b6b Alpha:1];
//    showLabel.font=[UIFont systemFontOfSize:11.0f];
    showLabel.textColor=[Utils HexColor:0x999999 Alpha:1];
    showLabel.font=FONT_t5;
    showLabel.textAlignment=NSTextAlignmentCenter;
    showLabel.text=@"客服电话: 400-821-9988";
    [footView addSubview:showLabel];
    _listTableView.tableFooterView=footView;
    UITapGestureRecognizer *tapS=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editShow)];
    _listTableView.userInteractionEnabled=YES;
    [_listTableView addGestureRecognizer:tapS];
    self.view.backgroundColor=[Utils HexColor:0xf2f2f2 Alpha:1];
    UIButton *doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setFrame:CGRectMake(15, UI_SCREEN_HEIGHT-60, UI_SCREEN_WIDTH-30, 40)];
    [doneBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    doneBtn.layer.cornerRadius=3;
    doneBtn.layer.masksToBounds=YES;
    doneBtn.titleLabel.font=FONT_T1;
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(upApplication) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.backgroundColor=[UIColor blackColor];
    [self.view addSubview:doneBtn];

    _allMoneyLabel.text=[Utils getSNSString:price];

    _nameLabel.text=[Utils getSNSString:goodName];
    _nameLabel.textColor=[Utils HexColor:0x999999 Alpha:1];
    _nameLabel.font=FONT_t5;
    _priceLabel.text=[Utils getSNSString:price];
   
    chooseReason =@"";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableView:) name:@"selectReason" object:nil];
    
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
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    self.title=self.titleStr;
    

    
}
-(void)refreshTableView:(NSNotification *)sender
{
    NSDictionary *dic = [sender userInfo];
    chooseReason = [NSString stringWithFormat:@"%@",dic[@"reason"]];
    reasonStr =[NSString stringWithFormat:@"%@",dic[@"reason"]];
    
    [_listTableView reloadData];
    
}
-(void)upApplication
{
    if (reasonStr.length==0||reasonStr==nil||[reasonStr isEqualToString:@"请选择退款原因"]||[reasonStr isEqualToString:@"请选择退货原因"]) {
       
        if([self.titleStr isEqualToString:@"申请退款"]){
            [Toast makeToast:@"退款原因不能为空,请填写退款原因" duration:1.0 position:@"center"];
        }else
        {
            [Toast makeToast:@"退货原因不能为空,请填写退货原因" duration:1.0 position:@"center"];
        }
        return;
    }
    [Toast makeToastActivity:@"正在加载..." hasMusk:YES];

//    NSMutableDictionary *responseAllDic=[NSMutableDictionary new];
//    NSMutableString *returnMsg=nil;
//    NSString *nick_name=[NSString stringWithFormat:@"%@",sns.myStaffCard.nick_name];
    NSString *prod_id;
    NSString *orderNumber;
    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
    if([Utils getSNSString:userToken].length==0)
    {
        sns.isLogin=NO;
        
        if (![BaseViewController pushLoginViewController]) {
            return;
        }
    }

    if ([self.isReturn isEqualToString:@"退货"]) {
        
    }else if ([self.isReturn isEqualToString:@"退款"])
    {
       
        prod_id=[NSString stringWithFormat:@"%@",self.collocationDic[@"refundProdDtlList"][0][@"proD_ID"]];
        orderNumber = [NSString stringWithFormat:@"%@",self.collocationDic[@"orderno"]];

    }
    else
    {
        prod_id=[NSString stringWithFormat:@"%@",self.goodDicOrderModel.proudctList.productInfo.proD_NUM];//11位码
        orderNumber = [NSString stringWithFormat:@"%@",self.collocationDicOrderModel.orderno];
    }
    NSString *REFUND_QTY = [NSString stringWithFormat:@"%@",numStr];

    NSString *desStr=[NSString stringWithFormat:@"%@",descriptionStr];
    NSString *uuserCRStatus;//1、已收货 2、 未收货
    NSString *type = nil;
    if ([self.titleStr isEqualToString:@"申请退款"]) {
        type=@"1";
    }
    else
    {
        type=@"2";
    }
        NSArray *RefundProdDtlList =@[@{@"barcode":prod_id,
                                        @"num":REFUND_QTY}];
        uuserCRStatus = @"2";
        NSDictionary *paramDic=@{@"reason":reasonStr,@"remark":[Utils getSNSString:desStr],@"type":type,@"token":userToken,@"orderno":orderNumber,@"cartList":RefundProdDtlList};//,@"UuserConfirmReceiptStatus":uuserCRStatus
        
        [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"OrderReturnCreate" params:paramDic success:^(NSDictionary *dict) {
            [Toast hideToastActivity];
            
            if ([dict[@"isSuccess"] integerValue] ==1) {
                [Toast hideToastActivity];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"requestData" object:nil];
                NSDictionary *postDic =[@{}mutableCopy];
                
                if ([self.titleStr isEqualToString:@"申请退款"]) {
                  
                    postDic=@{@"tag":@[@"0",@"2",@"3",@"4"]};
                }
                else
                {
                    postDic=@{@"tag":@[@"0",@"3",@"4"]};
                }

                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refeshData" object:nil userInfo:postDic];
                [self backHome:nil];
            }
            else
            {
                [Toast hideToastActivity];
                NSString *errorMessage;
                
                if ([[dict allKeys] containsObject:@"message"])
                {
                    
                    errorMessage= [NSString stringWithFormat:@"%@",dict[@"message"]];
                    if([Utils getSNSString:errorMessage].length==0)
                    {
                       [Utils alertMessage:@"提交失败"];
                    }
                    else
                    {
                       [Utils alertMessage:errorMessage];
                    }
                }
                else
                {
                    [Utils alertMessage:@"提交失败"];
                }

            }
            
        } failed:^(NSError *error) {
            
            [Utils alertMessage:@"提交失败"];
            
        }];

    /*
    }

    else{
        NSArray *ProdList =@[@{@"barcode":prod_id,
                                   @"num":REFUND_QTY}];
          uuserCRStatus = @"1";
        NSDictionary *paramDic=@{@"reason":reasonStr,@"remark":desStr,@"token":userToken,@"orderno":orderNumber,@"cartList":ProdList};//@"UuserConfirmReceiptStatus":uuserCRStatus

        [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"OrderReturnCreate" params:paramDic success:^(NSDictionary *dict) {
            [Toast hideToastActivity];
            
            if ([dict[@"isSuccess"] integerValue] ==1) {
                [Toast hideToastActivity];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"requestData" object:nil];
                NSDictionary *postDic=@{@"tag":@[@"0",@"3",@"4"]};
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refeshData" object:nil userInfo:postDic];
                [self backHome:nil];
            }
            else
            {
                [Toast hideToastActivity];
                NSString *message=[NSString stringWithFormat:@"%@",[Utils getSNSString:dict[@"message"]]];
                
                if(message.length==0)
                {
                    [Utils alertMessage:@"提交失败"];
                }
                else
                {
                    [Utils alertMessage:message];
                }
            }
            
        } failed:^(NSError *error) {
            
            [Utils alertMessage:@"提交失败"];
            
        }];
    }
    */
   
}

-(void)editShow
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
     [_listTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([self.titleStr isEqualToString:@"申请退款"]) {
        if (indexPath.section>1) {
            return 120;
        }else{
            
            return 50;
        }
    }
    else{
        if (indexPath.section>1) {
            return 120;
        }else{
            
            return 50;
        }
    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  [sectionArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 35)];
    sectionHeadView.backgroundColor=[Utils HexColor:0xf2f2f2 Alpha:1];
//    sectionHeadView.backgroundColor=TABLEVIEW_BACKGROUND_COLOR;
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 35)];
    nameLabel.textColor=[UIColor blackColor];
    nameLabel.text=[NSString stringWithFormat:@"%@",[sectionArray objectAtIndex:section]];
    nameLabel.font=[UIFont systemFontOfSize:13.0f];
    nameLabel.font=FONT_t5;
    nameLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.textAlignment=NSTextAlignmentLeft;
    [sectionHeadView addSubview:nameLabel];
    CGSize max=CGSizeMake(300, nameLabel.frame.size.height);
    CGSize textSize=[nameLabel.text sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:max lineBreakMode:NSLineBreakByCharWrapping];
     nameLabel.frame = CGRectMake(15, 0, textSize.width, nameLabel.frame.size.height);
    if (section>goodSection){
    }
    else{
        UILabel *starLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.size.width+nameLabel.frame.origin.x+1, 10, 10, 10)];
        starLabel.text=@"*";
        starLabel.backgroundColor=[UIColor clearColor];
        starLabel.textAlignment=NSTextAlignmentLeft;
        starLabel.textColor=[Utils HexColor:0xfd5b5e Alpha:1];
        [sectionHeadView addSubview:starLabel];
    }

    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+10, 0, 100,nameLabel.frame.size.height)];
    moreLabel.text=[NSString stringWithFormat:@"%@",remarkArray[section]];
    moreLabel.font=[UIFont systemFontOfSize:11.0f];
    moreLabel.textColor= [Utils HexColor:0xacacac Alpha:1];
    moreLabel.backgroundColor=[UIColor clearColor];
    [sectionHeadView addSubview:moreLabel];

    return sectionHeadView;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    OrderOtherTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderOtherTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.writeTextView.textColor=[Utils HexColor:0X3B3B3B Alpha:1];
    
    if ([self.isReturn isEqualToString:@"退款"])
    {
        if (indexPath.section==1) {
            indexPathTwo = indexPath;
            cell.writeTextView.hidden=YES;
            cell.stepNumTextField.hidden=NO;
            cell.stepNumTextField.isComeFromOrder=YES;
            cell.stepNumTextField.minValue=1;
   
            cell.stepNumTextField.text=numStr;
            
            cell.stepNumTextField.delegate=self;
//             OrderModelRefundProdDtlListInfo *refundProdDtlListInfo =self.collocationDicOrderModel.refundProdDtlList[0];
           
            NSString *more= [NSString stringWithFormat:@"%@",self.collocationDic[@"refundProdDtlList"][0][@"refunD_QTY"]];
           
//            NSString *more= [NSString stringWithFormat:@"%@",refundProdDtlListInfo.refunD_QTY];
            numStr = cell.stepNumTextField.text;
            cell.stepNumTextField.maxValue=[more intValue];
            [cell.stepNumTextField sendActionsForControlEvents:UIControlEventValueChanged];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChanged:) name:@"postValue" object:nil];
        }
        else{
         
            if (indexPath.section==0) {
                
                cell.writeTextView.text=[NSString stringWithFormat:@"%@",self.collocationDic[@"reason"]];
                
//                cell.writeTextView.text=[NSString stringWithFormat:@"%@",self.collocationDicOrderModel.reason];
                 reasonStr = cell.writeTextView.text;
            }else if(indexPath.section==2)
            {
              
                NSString *desc=[NSString stringWithFormat:@"%@",self.collocationDic[@"description"]];
                
//                NSString *desc=[NSString stringWithFormat:@"%@",self.collocationDicOrderModel.descriptionStr];
                cell.writeTextView.text=[Utils getSNSString:desc];
                descriptionStr = cell.writeTextView.text;
                
            }
            UITextView *cellTextView=cell.writeTextView;
            cellTextView.tag=indexPath.section;
            cellTextView.delegate=self;
        }

    }
    else if ([self.isReturn isEqualToString:@"退货"])
    {
        if (indexPath.section==1) {
            indexPathTwo = indexPath;
            cell.writeTextView.hidden=YES;
            cell.stepNumTextField.hidden=NO;
            cell.stepNumTextField.minValue=1;
             cell.stepNumTextField.isComeFromOrder=YES;
            cell.stepNumTextField.text=numStr;
            
            numStr =[NSString stringWithFormat:@"%@",cell.stepNumTextField.text];
            
            cell.stepNumTextField.delegate=self;
          
            NSString *more= [NSString stringWithFormat:@"%@",self.goodDic[@"detailInfo"][@"qty"]];
          
//            NSString *more= [NSString stringWithFormat:@"%@",self.goodDicOrderModel.detailInfo.qty];
            cell.stepNumTextField.maxValue=[more intValue];
            [cell.stepNumTextField sendActionsForControlEvents:UIControlEventValueChanged];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChanged:) name:@"postValue" object:nil];
        }
//        else if (indexPath.section==0)
//        {
////            cell.writeTextView.userInteractionEnabled=NO;
//        }
//        else{
        
            UITextView *cellTextView=cell.writeTextView;
            cellTextView.tag=indexPath.section;
            cellTextView.delegate=self;
            
//        }
  
    }
    else
    {
        if ([self.titleStr isEqualToString:@"申请退款"]) {
            if (indexPath.section==1) {
                indexPathTwo = indexPath;
                cell.writeTextView.hidden=YES;
                cell.stepNumTextField.hidden=NO;
                cell.stepNumTextField.minValue=1;
                 cell.stepNumTextField.isComeFromOrder=YES;
                cell.stepNumTextField.text=numStr;
                cell.stepNumTextField.delegate=self;
                /*
                NSString *more= [NSString stringWithFormat:@"%@",self.goodDic[@"detailInfo"][@"qty"]];
                 */
                NSString *more= [NSString stringWithFormat:@"%@",self.goodDicOrderModel.detailInfo.qty];
                numStr =[NSString stringWithFormat:@"%@",cell.stepNumTextField.text];
                
                cell.stepNumTextField.maxValue=[more intValue];
                [cell.stepNumTextField sendActionsForControlEvents:UIControlEventValueChanged];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChanged:) name:@"postValue" object:nil];
            }
            else
            {
                UITextView *cellTextView=cell.writeTextView;
                if (indexPath.section==0) {
                    if (chooseReason.length==0) {
                        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-40, 5, 7, 14)];
                        [imgView setImage:[UIImage imageNamed:@"Unico/right_arrow"]];
                        [cell.writeTextView addSubview:imgView];
                        cell.writeTextView.text=@"请选择退款原因";
                    }
                    else
                    {
                         cell.writeTextView.text = chooseReason;
                    }
                }else if (indexPath.section==2)
                {
                   cell.writeTextView.text =[Utils getSNSString:descriptionStr];
                }
                cellTextView.tag=indexPath.section;
                cellTextView.delegate=self;
            }
            
        }
        else{
            if (indexPath.section==1) {
                indexPathTwo = indexPath;
                cell.writeTextView.hidden=YES;
                cell.stepNumTextField.hidden=NO;
                cell.stepNumTextField.minValue=1;
                cell.stepNumTextField.text=numStr;
                 cell.stepNumTextField.isComeFromOrder=YES;
                cell.stepNumTextField.delegate=self;
                numStr =[NSString stringWithFormat:@"%@",cell.stepNumTextField.text];
                /*
                 NSString *more= [NSString stringWithFormat:@"%@",self.goodDic[@"detailInfo"][@"qty"]];
                 */
                NSString *more= [NSString stringWithFormat:@"%@",self.goodDicOrderModel.detailInfo.qty];
                cell.stepNumTextField.maxValue=[more intValue];
                [cell.stepNumTextField sendActionsForControlEvents:UIControlEventValueChanged];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChanged:) name:@"postValue" object:nil];
            }
            else{

                UITextView *cellTextView=cell.writeTextView;
                if (indexPath.section==0) {
                    if (chooseReason.length==0) {
                        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-40, 5, 7, 14)];
                        [imgView setImage:[UIImage imageNamed:@"Unico/right_arrow"]];
                        [cell.writeTextView addSubview:imgView];
                        cell.writeTextView.text=@"请选择退货原因";
                    }
                    else
                    {
                        cell.writeTextView.text = chooseReason;
                    }
                }
                else if (indexPath.section==2)
                {
                    cell.writeTextView.text =[Utils getSNSString:descriptionStr];
                }

                cellTextView.tag=indexPath.section;
                cellTextView.delegate=self;
                
            }
            
        }
    }


    return cell ;
}
-(void)showTrans
{
    NSLog(@".....%@",expressArray);
    [self.view endEditing:YES];
    
}
-(void)textValueChanged:(id)sender
{
    OrderOtherTableViewCell*cell=(OrderOtherTableViewCell *)[_listTableView cellForRowAtIndexPath:indexPathTwo];
    numStr = cell.stepNumTextField.text;
    float allMoney =   [numStr intValue ]*[price floatValue];
    _allMoneyLabel.text=[NSString stringWithFormat:@"%0.2f",allMoney];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text intValue]>moreNum) {

        numStr =[NSString stringWithFormat:@"%d",moreNum];
    }else if ([textField.text intValue]<=0)
    {
        numStr = [NSString stringWithFormat:@"1"];
    }
    else{
        numStr = textField.text;
    }

  float allMoney =   [numStr intValue ]*[price floatValue];

    _allMoneyLabel.text=[NSString stringWithFormat:@"%f",allMoney];

}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
      UITextView *textV=textView;
    switch (textV.tag) {
        case 0:
        {
            [self.view endEditing:YES];
            
            DetailReasonViewController *detailReason=[[DetailReasonViewController alloc]initWithNibName:@"DetailReasonViewController" bundle:nil];
            detailReason.type=self.titleStr;
            [self.navigationController pushViewController:detailReason animated:YES];
            return;
        }
            break;
        case 1:
        {
        }
            break;
        case 2:
        {
            [_listTableView setContentOffset:CGPointMake(0, 64+27*2) animated:YES];
        }
            break;
            
        default:
            break;
    }


}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    UITextView *textV=textView;
    switch (textV.tag) {
        case 0:
        {
            reasonStr = textV.text;
        }
            break;
        case 1:
        {
            numStr = textV.text;
        }
            break;
        case 2:
        {
            descriptionStr = textV.text;
    
        }
            break;
            
        default:
            break;
    }
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *detailStr = [textView.text stringByAppendingString:text];
    
    descriptionStr=detailStr;
    
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
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

@end
