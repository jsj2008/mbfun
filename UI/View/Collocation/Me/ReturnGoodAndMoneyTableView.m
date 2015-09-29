//
//  ReturnGoodAndMoneyTableView.m
//  Wefafa
//
//  Created by fafatime on 14-12-19.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "ReturnGoodAndMoneyTableView.h"
#import "OrderViewTableViewCell.h"
#import "Utils.h"
#import "UIImageView+WebCache.h"
#import "CommMBBusiness.h"
#import "AppSetting.h"
#import "SUtilityTool.h"

@implementation ReturnGoodAndMoneyTableView
{
    int  SHOWALL;
    int tapSection;
    NSMutableArray *tapSectionArray;
    NSMutableArray *goodSectionArray;
    
    
}
@synthesize dataArray;
@synthesize cellDefaultHeight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self innerInit];
        
    }
    return self;
}
- (void)innerInit
{
    [super innerInit];
    [self setBackgroundColor:[Utils HexColor:0XF2F2F2 Alpha:1.0]];
    [self setSeparatorColor:[UIColor whiteColor]];
    tapSectionArray =[[NSMutableArray alloc]init];
    goodSectionArray= [[NSMutableArray alloc]init];
    
    tapSection = -1;
    self.dataSource = self;
    self.delegate = self;
    SHOWALL = 2;
    _onDidSelectedRow = [[CommonEventHandler alloc] init];
    _onDidCancleRow = [[CommonEventHandler alloc] init];
    _onDidOrderRow = [[CommonEventHandler alloc] init];
    _onDicTransRow = [[CommonEventHandler alloc]init];

    
}
-(void)setCellBackground:(UITableViewCell *)cell
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *AIdentifier =  @"MyOrderTableViewCell";
    OrderViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AIdentifier];
    if (cell == nil) {
        
        cell=[[OrderViewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AIdentifier];
        [self setCellBackground:cell];
    }
//    cell.colcorLabel.hidden=YES;
    cell.orderNoLabel.hidden=YES;
//    cell.khLabel.hidden=YES;
    NSString *price;
    NSString *danNum;
    NSString *imgUrlstr;
    NSString *productName;
    NSDictionary *refundProdDic;
    NSArray *refundProdDtlList;
    NSString *colorStr=nil;
    NSString *khStr=nil;
    NSString *sizeStr = nil;
//    NSLog(@"self.dataarray ---%@",self.dataArray);
    NSString *return_type= nil;
    if ([self.dataArray count]==0||self.dataArray==nil)
    {
    }
    else
    {
        //退款  // 退货退款 根据 orderrreturninfo 里的  return——type 进行判断1是退款 2 是退货
        return_type = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.section][@"orderReturnInfo"][@"returN_TYPE"]];
        
//        if ([return_type isEqualToString:@"1"]) {
//            
//            refundProdDtlList=self.dataArray[indexPath.section][@"refundProdDtlList"];
//          
//            if ([refundProdDtlList count]>0&&refundProdDtlList!=nil) {
//                
//                refundProdDic = [NSDictionary dictionaryWithDictionary:refundProdDtlList[indexPath.row]];
//                imgUrlstr = [[Utils getSNSString:refundProdDic[@"proD_URL"]]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                NSString *priceStr=[NSString stringWithFormat:@"%@",refundProdDic[@"price"]];
//                float pricef=[priceStr floatValue];
//        
//                price = [NSString stringWithFormat:@"%.2f",pricef];
//                danNum=[NSString stringWithFormat:@"%@",refundProdDic[@"refunD_QTY"]];
//                productName = [NSString stringWithFormat:@"%@",refundProdDic[@"prodName"]];
//            }
//            else
//            {
//            }
//            
//        }
//        else{//退货
        
            refundProdDtlList=self.dataArray[indexPath.section][@"prodList"];
            
            if ([refundProdDtlList count]>0&&refundProdDtlList!=nil) {
                refundProdDic = [NSDictionary dictionaryWithDictionary:refundProdDtlList[indexPath.row]];
                refundProdDic = [NSDictionary dictionaryWithDictionary:refundProdDtlList[indexPath.row]];
                imgUrlstr = [[Utils getSNSString:refundProdDic[@"proD_URL"]]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                price = [NSString stringWithFormat:@"%@",refundProdDic[@"price"]];
                NSString *priceStr=[NSString stringWithFormat:@"%@",refundProdDic[@"salE_PRICE"]];
                float pricef=[priceStr floatValue];
                
                price = [NSString stringWithFormat:@"%.2f",pricef];
                danNum=[NSString stringWithFormat:@"%@",refundProdDic[@"qty"]];
                productName = [NSString stringWithFormat:@"%@",refundProdDic[@"prodName"]];
                khStr = [NSString stringWithFormat:@"%@",refundProdDic[@"proD_CLS_NUM"]];
                colorStr=[NSString stringWithFormat:@"%@",refundProdDic[@"coloR_NAME"]];
                sizeStr =[NSString stringWithFormat:@"%@",refundProdDic[@"speC_NAME"]];
            }
            else
            {
            }
//        }
        cell.khLabel.text=[NSString stringWithFormat:@"款号:%@",khStr];
        
        cell.colcorLabel.text=[NSString stringWithFormat:@"颜色:%@ 尺码:%@",colorStr,sizeStr];
        
        cell.goodNameLabel.text=[Utils getSNSString:productName];
        if (imgUrlstr.length==0) {

            [cell.goodImgView setImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
            
        }
        else{
                   [cell.goodImgView downloadImageUrl:[CommMBBusiness changeStringWithurlString:imgUrlstr size:SNS_IMAGE_ORIGINAL] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:DEFAULT_LOADING_IMAGE];
        }

        //        //    数量
        cell.numberLabel.text=[NSString stringWithFormat:@"x%@",[Utils getSNSString:danNum]];
        //        //单价  参数有问题
        cell.priceLabel.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSString:price]];
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [_onDidSelectedRow fire:self eventData:self.dataArray[indexPath.section]];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellDefaultHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSString *secSS=[NSString stringWithFormat:@"%ld",(long)section];
    UIView *botomView=[[UIView alloc]init];
    [botomView setBackgroundColor:[UIColor whiteColor]];
    UIView *transView=[[UIView alloc]initWithFrame:CGRectMake(0,50, UI_SCREEN_WIDTH, 50*2)];
    UIView *moreView=[[UIView alloc]initWithFrame:CGRectMake(0,0, UI_SCREEN_WIDTH, 50)];
    if (self.dataArray==nil||[self.dataArray count]==0)
    {
    }
    else
    {
        NSDictionary *refundProdDic;
        NSArray *refundProd;
        NSDictionary *orderReturnInfo;
        NSString *amount;
        NSString *status;
        NSString *orderBtnName;
        NSString *cancleBtnName;
        
        moreView.tag=section;
        UITapGestureRecognizer *tapShowAll=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShowAll:)];
        [moreView addGestureRecognizer:tapShowAll];
        
        UIImageView *linTwoView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5)];
        [linTwoView  setBackgroundColor:[Utils HexColor:0XE2E2E2 Alpha:1.0]];
        [transView addSubview:linTwoView];
        
        UIImageView *linThreeView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 50, UI_SCREEN_WIDTH, 1)];
        [linThreeView  setBackgroundColor:[Utils HexColor:0XE2E2E2 Alpha:1.0]];
        [transView addSubview:linThreeView];
        
//        //退款
//        if ([[self.dataArray[section] allKeys]containsObject:@"statusName"])
//        {
//            refundProd=[NSArray arrayWithArray:self.dataArray[section][@"refundProdDtlList"]];
//            amount = [NSString stringWithFormat:@"%@",self.dataArray[section][@"refunD_AMOUNT"]];
//            status = [NSString stringWithFormat:@"%@",self.dataArray[section][@"status"]];
//            if ([status isEqualToString:@"2"]) {
////                isReject=YES;
//            }
//            else
//            {
//                
//            }
//            orderBtnName=[NSString stringWithFormat:@"%@",self.dataArray[section][@"statusName"]];
//            cancleBtnName =@"取消退款";
//            
//            if ([refundProd count]>0&&refundProd!=nil) {
//                
//                refundProdDic = [NSDictionary dictionaryWithDictionary:refundProd[0]];
//            }
//            else
//            {
//                
//            }
//            if ([tapSectionArray containsObject:secSS])
//            {
//                linTwoView.hidden=YES;
//                moreView.hidden=YES;
//                [botomView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50*2)];
//                [transView setFrame:CGRectMake(0,0, UI_SCREEN_WIDTH, 50*2)];
//            }
//            else if ([refundProd count]>2)
//            {
//                [botomView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50*3)];
//                moreView.hidden=NO;
//                linTwoView.hidden=NO;
//            }
//            else
//            {
//                linTwoView.hidden=YES;
//                moreView.hidden=YES;
//                [botomView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50*2)];
//                [transView setFrame:CGRectMake(0,0, UI_SCREEN_WIDTH, 50*2)];
//            }
//            
//        }
//        else//退货
//        {
            refundProd=[NSArray arrayWithArray:self.dataArray[section][@"prodList"]];
            orderReturnInfo =[NSDictionary dictionaryWithDictionary:self.dataArray[section][@"orderReturnInfo"]];
            amount =[NSString stringWithFormat:@"%@",orderReturnInfo[@"returN_AMOUNT"]];
            status = [NSString stringWithFormat:@"%@",orderReturnInfo[@"state"]];
            orderBtnName=[NSString stringWithFormat:@"%@",orderReturnInfo[@"stateName"]];
            cancleBtnName =@"取消退货";
            if ([status isEqualToString:@"9"]) {

            }
            if ([refundProd count]>0&&refundProd!=nil) {
                
                refundProdDic = [NSDictionary dictionaryWithDictionary:refundProd[0]];
            }
            else
            {
            }
            if ([goodSectionArray containsObject:secSS])
            {
                linTwoView.hidden=YES;
                moreView.hidden=YES;
                [botomView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50*2)];
                [transView setFrame:CGRectMake(0,0, UI_SCREEN_WIDTH, 50*2)];
            }
            else if ([refundProd count]>2)
            {
                [botomView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50*3)];
                moreView.hidden=NO;
                linTwoView.hidden=NO;
            }
            else
            {
                linTwoView.hidden=YES;
                moreView.hidden=YES;
                [botomView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50*2)];
                [transView setFrame:CGRectMake(0,0, UI_SCREEN_WIDTH, 50*2)];
            }
            
//        }

        UILabel *moreLabel=[[UILabel alloc]initWithFrame:CGRectMake((UI_SCREEN_WIDTH-50)/2, 0, 100, 50)];
        moreLabel.text=@"展开更多";
        moreLabel.textColor=[Utils HexColor:0x353535 Alpha:1];
        moreLabel.font=[UIFont systemFontOfSize:13.0f];
        [moreView addSubview:moreLabel];
        
        UIImageView *down=[[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2+30, 15, 15, 15)];
        [down setImage:[UIImage imageNamed:@"Home_Middle_Open.png"]];
        [moreView addSubview:down];

        UILabel *transFee=[[UILabel alloc]initWithFrame:CGRectMake(55+15, 0,50, 32)];
        transFee.text=@"交易金额:";
        transFee.textAlignment = NSTextAlignmentRight;
        transFee.font=[UIFont systemFontOfSize:11.0];
        transFee.textColor=[Utils HexColor:0x6b6b6b Alpha:1];
//        [transView addSubview:transFee];
  
        UILabel *amountMoney=[[UILabel alloc]initWithFrame:CGRectMake(transFee.frame.size.width+transFee.frame.origin.x, 0, 80, 32)];
        amountMoney.textColor=[UIColor blackColor];
        amountMoney.font=[UIFont systemFontOfSize:11.0f];
        amountMoney.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSRMBMoneyWithoutMark:amount]];
//        [transView addSubview:amountMoney];

//        NSString *feeSt=[NSString stringWithFormat:@"%@",refundProdDic[@"fee"]];
        
//         总价 需要  amount +fee、、[Utils getSNSString:amountstr]]; [feeSt floatValue] +退款金额不需要加运费
        NSString *feeSt=[NSString stringWithFormat:@"%@",self.dataArray[section][@"freight"]];
        float payAmount; //需要加运费
        payAmount = [amount floatValue] + [feeSt floatValue] ;
        
        //总价
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-180-15,0, 180,50)];
        NSString *priceStr=[NSString stringWithFormat:@"退款金额:%@",[Utils getSNSRMBMoney:[NSString stringWithFormat:@"%f",payAmount]]];//
    
        priceLabel.textColor=COLOR_C2;
        priceLabel.font=FONT_T5;
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:priceStr];
//        [str addAttribute:NSForegroundColorAttributeName value:[Utils HexColor:0x6b6b6b Alpha:1] range:NSMakeRange(0,5)];
//        priceLabel.attributedText=str;
        priceLabel.text=priceStr;
        priceLabel.textAlignment=NSTextAlignmentRight;
        priceLabel.backgroundColor=[UIColor clearColor];
        [transView addSubview:priceLabel];
        UILabel *reduc= [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-180+5, 0, 110, 50)];
        reduc.text=@"退款金额:";//(含运费)
        reduc.textAlignment = NSTextAlignmentRight;
        reduc.textColor=COLOR_C2;
        reduc.font=FONT_T5;
        reduc.backgroundColor=[UIColor clearColor];
//        [transView addSubview:reduc];
        
        UIButton *goOrder=[UIButton buttonWithType:UIButtonTypeCustom];
        [goOrder setTitle:orderBtnName forState:UIControlStateNormal];
        [goOrder.layer setBorderColor:[[Utils HexColor:0X333333 Alpha:1.0]CGColor]];
//        [goOrder.layer setBorderWidth:1.0];
        [goOrder.layer setCornerRadius:5.0];
        [goOrder setBackgroundColor:COLOR_C2];
        [goOrder setFrame:CGRectMake(UI_SCREEN_WIDTH-75-10,10+50, 75, 30)];
        [goOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        goOrder.titleLabel.font=FONT_T4;
        goOrder.tag=section;
        [goOrder addTarget:self action:@selector(orderBtn:) forControlEvents:UIControlEventTouchUpInside];
        [transView addSubview:goOrder];
        
        UIButton *cancleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [cancleBtn setTitle:cancleBtnName forState:UIControlStateNormal];
        [cancleBtn setFrame:CGRectMake(UI_SCREEN_WIDTH-75*2-10-10 ,10+50,75, 30)];
//        cancleBtn.layer.borderColor =[[Utils HexColor:0XE2E2E2 Alpha:1.0]CGColor];
//        cancleBtn.layer.borderWidth = 1.0;
        [cancleBtn.layer setCornerRadius:5.0];
        [cancleBtn setTitleColor:COLOR_C3 forState:UIControlStateNormal];
        cancleBtn.titleLabel.font=FONT_T4;
        cancleBtn.backgroundColor=COLOR_C11;
        cancleBtn.tag=section;
        [transView addSubview:cancleBtn];
        [botomView addSubview:moreView];
        [botomView addSubview:transView];
        [cancleBtn addTarget:self action:@selector(cancleBtn:) forControlEvents:UIControlEventTouchUpInside];

    
        if ([status isEqualToString:@"0"]) {
            cancleBtn.hidden=NO;
        }
        else
        {
            cancleBtn.hidden=YES;
        }
        //取消退货退款 禁掉
        
        cancleBtn.hidden=YES;
        
//        if (isReject) {
//            cancleBtn.hidden=YES;
//            if ([cancleBtnName isEqualToString:@"取消退款"]) {
//                
//                [goOrder setTitle:@"申请退款" forState:UIControlStateNormal];
//            }
//            else
//            {
//                [goOrder setTitle:@"申请退货" forState:UIControlStateNormal]; 
//            }
//    
//        }
        
        

    }
    return botomView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 70)];
    [bgView setBackgroundColor:[Utils HexColor:0XF2F2F2 Alpha:1.0]];

    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH,50)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:headView];
    UIImageView *linTwoView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5)];
    [linTwoView  setBackgroundColor:COLOR_C9];
//    [headView addSubview:linTwoView];
    UILabel *danLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 1 ,70,headView.frame.size.height)];
    danLabel.textColor=[UIColor blackColor];
    danLabel.font=FONT_t4;
    danLabel.textColor=COLOR_C2;
    danLabel.backgroundColor=[UIColor clearColor];
    danLabel.text=@"订单编号:";
    [headView addSubview:danLabel];
    
    UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(danLabel.frame.origin.x+danLabel.frame.size.width, danLabel.frame.origin.y, UI_SCREEN_WIDTH-70-60,headView.frame.size.height)];
    orderLabel.lineBreakMode=-1;
    orderLabel.text=@"";
    orderLabel.font=FONT_t4;
    orderLabel.textColor=COLOR_C2;
    orderLabel.backgroundColor=[UIColor clearColor];
    [headView addSubview:orderLabel];
    NSString *st;
    NSString *nums;
    NSString *oredrNum;

    if(self.dataArray.count==0)
    {
        
    }
    else
    {
//        //退款
//        if ([[self.dataArray[section] allKeys]containsObject:@"statusName"]) {
//            
//            st = [NSString stringWithFormat:@"%@",self.dataArray[section][@"statusName"]];
//            nums=[NSString stringWithFormat:@"%@",self.dataArray[section][@"qty"]];
//            oredrNum=[NSString stringWithFormat:@"%@",self.dataArray[section][@"orderno"]];
//
//        }
//        else {//退货
            st = [NSString stringWithFormat:@"%@",self.dataArray[section][@"orderReturnInfo"][@"stateName"]];
            NSArray *prodListArray=self.dataArray[section][@"prodList"];
            if ([prodListArray count]>0&&prodListArray!=nil) {
                
                nums=[NSString stringWithFormat:@"%@",prodListArray[0][@"qty"]];
            }

            oredrNum=[NSString stringWithFormat:@"%@",self.dataArray[section][@"orderReturnInfo"][@"orderno"]];
    
//        }

    }
    orderLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:oredrNum]];
    
    UILabel *statesLabel=[[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-70-10, danLabel.frame.origin.y, 70, headView.frame.size.height)];
    statesLabel.font=FONT_T4;
    statesLabel.textAlignment=NSTextAlignmentRight;
    statesLabel.backgroundColor=[UIColor clearColor];
    statesLabel.textColor=COLOR_C2;
    statesLabel.text=st;
    [headView addSubview:statesLabel];
    UIImageView *bottomView=[[UIImageView alloc]initWithFrame:CGRectMake(0,headView.frame.size.height, UI_SCREEN_WIDTH, 0.5)];
    [bottomView  setBackgroundColor:COLOR_C9];
    [headView addSubview:bottomView];
    UILabel *showNumberLabel= [[UILabel alloc]initWithFrame:CGRectMake(statesLabel.frame.origin.x-40, 0, 50, headView.frame.size.height)];
    showNumberLabel.font=[UIFont systemFontOfSize:12.0f];
    showNumberLabel.textAlignment=NSTextAlignmentCenter;
    showNumberLabel.text=[NSString stringWithFormat:@"共%@件",nums];
    showNumberLabel.backgroundColor=[UIColor clearColor];
    showNumberLabel.textColor=[Utils HexColor:0x333333 Alpha:1];
    
    return bgView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
  
    NSString *secSS = [NSString stringWithFormat:@"%ld",(long)section];
    //退款
    if ([[self.dataArray[section] allKeys]containsObject:@"statusName"]) {
        NSArray *detailList=[NSArray arrayWithArray:self.dataArray[section][@"refundProdDtlList"]];
        if ([tapSectionArray containsObject:secSS])
        {
            return 50*2;
        }
        if ([detailList count]>2)
        {
            return 50*3;
        }
        else
        {
            return 50*2;
        }
    }
    else
    {
        //退货
      NSArray * detailList =self.dataArray[section][@"prodList"];
        if ([goodSectionArray containsObject:secSS])
        {
            return 50*2;
        }
        if ([detailList count]>2)
        {
            return 50*3;
        }
        else
        {
            return 50*2;
        }
    }

    
//    if ([tapSectionArray containsObject:secSS])
//    {
//        return 32*2;
//    }
//    if ([detailList count]>2)
//    {
//        return 32*3;
//    }
//    else
//    {
//        return 32*2;
//    }
    
//    return 32*2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  [self.dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *stSec=[NSString stringWithFormat:@"%ld",(long)section];
   
    if ([[self.dataArray[section] allKeys]containsObject:@"statusName"])
    {
        if ([tapSectionArray containsObject:stSec])
        {
            return [self.dataArray[section][@"refundProdDtlList"] count];
        }
        
        else if ( [self.dataArray[section][@"refundProdDtlList"] count]>2)
        {
            return 2;
        }
        else
        {
            return [self.dataArray[section][@"refundProdDtlList"] count];
        }
    }
    else
    {
        NSLog(@"退货");
//         prodList
        if ([goodSectionArray containsObject:stSec])
        {
            return [self.dataArray[section][@"prodList"] count];
        }
        
        else if ( [self.dataArray[section][@"prodList"] count]>2)
        {
            return 2;
        }
        else
        {
            return [self.dataArray[section][@"prodList"] count];
        }
    }

//    return 1;
    
}
-(void)tapShowAll:(UIGestureRecognizer *)gest
{
    UIView *tapView=(UIView *) [gest view];
   
    if ([[self.dataArray[tapView.tag] allKeys]containsObject:@"statusName"])
    {
         NSArray *oneDetailList=[NSArray arrayWithArray:self.dataArray[tapView.tag][@"refundProdDtlList"]];
        SHOWALL = (int)[oneDetailList count];
        tapSection = (int)tapView.tag;
        //删除订单的时候 要注意tapSectionArray中要删除。 把点击展开的cell Section数存进去
        [tapSectionArray addObject:[NSString stringWithFormat:@"%d",tapSection]];
    }
    else
    {
        NSArray *oneDetailList=[NSArray arrayWithArray:self.dataArray[tapView.tag][@"prodList"]];
        SHOWALL = (int)[oneDetailList count];
        tapSection = (int)tapView.tag;
        //删除订单的时候 要注意tapSectionArray中要删除。 把点击展开的cell Section数存进去
        [goodSectionArray addObject:[NSString stringWithFormat:@"%d",tapSection]];
    }
    

    [self reloadData];

}
-(void)cancleBtn:(UIButton *)sender
{
    [_onDidCancleRow fire:sender eventData:self.dataArray[sender.tag]];
}
-(void)orderBtn:(UIButton *)sender
{
    
    [_onDidOrderRow fire:sender eventData:self.dataArray[sender.tag]];

}
//-(void)findeTransBtn:(UIButton*)sender
//{
//    [_onDicTransRow fire:sender eventData:self.dataArray[sender.tag]];
//}
@end
