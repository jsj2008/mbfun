//
//  MyOrderTableView.m
//  Wefafa
//
//  Created by fafatime on 14-9-23.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MyOrderTableView.h"
#import "OrderViewTableViewCell.h"
#import "Utils.h"
#import "UIImageView+WebCache.h"
#import "CommMBBusiness.h"
#import "AppSetting.h"
#import "OrderModel.h"
#import "SUtilityTool.h"

@implementation MyOrderTableView
{
    int  SHOWALL;
    int tapSection;
    NSMutableArray *tapSectionArray;
    
    
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
- (void)awakeFromNib
{
    [self innerInit];
}

- (void)innerInit
{
    [super innerInit];
    tapSectionArray =[[NSMutableArray alloc]init];
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
    NSString *AIdentifier = @"MyOrderTableViewCell";
     OrderViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AIdentifier];
    if (cell == nil) {
        
        cell=[[OrderViewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AIdentifier];
        [self setCellBackground:cell];
    }
    if ([self.dataArray count]==0||self.dataArray==nil)
    {
        
    }
    else
    {
    OrderModel *orderModelData= self.dataArray[indexPath.section];
    NSArray *detailList=[NSArray arrayWithArray:orderModelData.detailList];
    OrderModelDetailListInfo *detailListInfoData = detailList[indexPath.row];
   
    cell.colcorLabel.text=[NSString stringWithFormat:@"颜色: %@  尺码: %@",[Utils getSNSString: detailListInfoData.proudctList.productInfo.coloR_NAME],[Utils getSNSString:  detailListInfoData.proudctList.productInfo.speC_NAME]];
    cell.goodNameLabel.text=[Utils getSNSString:detailListInfoData.proudctList.productInfo.proD_NAME];
     
//    cell.orderNoLabel.text=[NSString stringWithFormat:@"%@", [Utils getSNSString:detailListInfoData.proudctList.productInfo.proD_CLS_NUM]];
    cell.khLabel.text=[NSString stringWithFormat:@"商品编号: %@", [Utils getSNSString:detailListInfoData.proudctList.productInfo.proD_CLS_NUM]];
        
    NSString *imgUrlstr = [[Utils getSNSString:detailListInfoData.proudctList.productInfo.coloR_FILE_PATH
                                ]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.goodImgView downloadImageUrl:[CommMBBusiness changeStringWithurlString:imgUrlstr size:SNS_IMAGE_Size] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:DEFAULT_LOADING_IMAGE];
    NSString *price = [NSString stringWithFormat:@"%@",detailListInfoData.detailInfo.acT_PRICE];
    NSString *unitPrice = [NSString stringWithFormat:@"%@",detailListInfoData.detailInfo.uniT_PRICE];
        
    NSString *danNum=[NSString stringWithFormat:@"%@",detailListInfoData.detailInfo.qty];
        //    数量
    cell.numberLabel.text=[NSString stringWithFormat:@"x%@",[Utils getSNSString:danNum]];
       //单价  参数有问题
    cell.priceLabel.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSRMBMoneyWithoutMark:price]];
    cell.showSalePriceLabel.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSRMBMoneyWithoutMark:unitPrice]];
      
    NSMutableAttributedString *attrbutdestring = [[NSMutableAttributedString alloc]initWithString:cell.showSalePriceLabel.text];

    [attrbutdestring addAttributes:@{NSStrikethroughColorAttributeName: [Utils HexColor:0x999999 Alpha:1],
                                         NSForegroundColorAttributeName: [Utils HexColor:0x999999 Alpha:1],
                                         NSStrikethroughStyleAttributeName: @(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
                                         NSFontAttributeName:FONT_t7
                                         }range:NSMakeRange(0,cell.showSalePriceLabel.text.length)];

    cell.showSalePriceLabel.attributedText =attrbutdestring;
        
        if ([cell.priceLabel.text isEqualToString:cell.showSalePriceLabel.text]) {
            cell.showSalePriceLabel.hidden=YES;
        }else
        {
            cell.showSalePriceLabel.hidden=NO;
        }
    }
    return cell;
}
-(void)cancleBtn:(UIButton *)sender
{
   
      [_onDidCancleRow fire:sender eventData:self.dataArray[sender.tag]];
}
-(void)orderBtn:(UIButton *)sender
{
      [_onDidOrderRow fire:sender eventData:self.dataArray[sender.tag]];
}
-(void)findeTransBtn:(UIButton*)sender
{
    [_onDicTransRow fire:sender eventData:self.dataArray[sender.tag]];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_onDidSelectedRow fire:self eventData:self.dataArray[indexPath.section]];
    
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
        OrderModel *orderModelData= self.dataArray[section];
        NSArray *detailList=[NSArray arrayWithArray:orderModelData.detailList];
//        NSString *nums=[NSString stringWithFormat:@"%@",orderModelData.qty];
        NSString * nums = [NSString stringWithFormat:@"%lu",(unsigned long)[orderModelData.detailList count]];
        NSString *fee = [NSString stringWithFormat:@"%@",orderModelData.fee];
        NSString *amountstr = [NSString stringWithFormat:@"%@",orderModelData.amount];
        //优惠金额
        NSString *disamount =[NSString stringWithFormat:@"%@",orderModelData.diS_AMOUNT];
        float payAmount; //应付的
        payAmount = [fee floatValue] +[amountstr floatValue]-[disamount floatValue];
        // 新的总价 取orderTotalPrice 字段
        NSString *orderTotalPrice=[NSString stringWithFormat:@"%@",orderModelData.orderTotalPrice];
        payAmount = [orderTotalPrice floatValue];
        
        NSString *st = [NSString stringWithFormat:@"%@",orderModelData.status];
        NSString *judge_status = [NSString stringWithFormat:@"%@",orderModelData.judgeStatus];
        moreView.tag=section;
        UITapGestureRecognizer *tapShowAll=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShowAll:)];
        [moreView addGestureRecognizer:tapShowAll];
        
        UIImageView *linTwoView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5)];
        [linTwoView  setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:209.0/255.0 blue:204.0/255.0 alpha:1]];
        [transView addSubview:linTwoView];
        
        UIImageView *linThreeView=[[UIImageView alloc]initWithFrame:CGRectMake(0,50, UI_SCREEN_WIDTH, 0.5)];
        [linThreeView  setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:209.0/255.0 blue:204.0/255.0 alpha:1]];
        [transView addSubview:linThreeView];
        
        if (self.isUnReceived) {
            if ([tapSectionArray containsObject:secSS])
            {
                linTwoView.hidden=YES;
                moreView.hidden=YES;
                linThreeView.hidden=YES;
                [botomView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50*1)];
                [transView setFrame:CGRectMake(0,0, UI_SCREEN_WIDTH, 50*1)];
            }
            else if ([detailList count]>2)
            {
                [botomView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50*1)];
                moreView.hidden=NO;
                linTwoView.hidden=NO;
                linThreeView.hidden=YES;
            }
            else
            {
                linTwoView.hidden=YES;
                moreView.hidden=YES;
                linThreeView.hidden=YES;
                [botomView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50*1)];
                [transView setFrame:CGRectMake(0,0, UI_SCREEN_WIDTH, 50*1)];
                
            }
        }
        else
        {
            if ([tapSectionArray containsObject:secSS])
            {
                linTwoView.hidden=YES;
                moreView.hidden=YES;
                [botomView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50*2)];
                [transView setFrame:CGRectMake(0,0, UI_SCREEN_WIDTH, 50*2)];
            }
            else if ([detailList count]>2)
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
        }
        
//        UILabel *moreLabel=[[UILabel alloc]initWithFrame:CGRectMake((UI_SCREEN_WIDTH-50)/2, 0, 100,50)];
           UILabel *moreLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH,50)];
        int moreNum ;
        moreNum= [nums intValue]-2;
        moreLabel.text=[NSString stringWithFormat:@"显示其余%d件",moreNum];
        moreLabel.textColor=[Utils HexColor:0x333333 Alpha:1];
        moreLabel.font=[UIFont systemFontOfSize:13.0f];
        moreLabel.textAlignment=NSTextAlignmentCenter;
        [moreView addSubview:moreLabel];
        
        UIImageView *down=[[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2+50, 15, 15, 15)];
        [down setImage:[UIImage imageNamed:@"Home_Middle_Open.png"]];
//        [moreView addSubview:down];
      
        UILabel *showNumberLabel= [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70,50)];
//        showNumberLabel.font=[UIFont systemFontOfSize:11.0f];
        showNumberLabel.textAlignment=NSTextAlignmentCenter;
        showNumberLabel.text=[NSString stringWithFormat:@"共%@件商品",nums];
        showNumberLabel.backgroundColor=[UIColor clearColor];
        showNumberLabel.font=FONT_t4;
        showNumberLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
        [transView addSubview:showNumberLabel];
        UILabel *transFee=[[UILabel alloc]initWithFrame:CGRectMake(showNumberLabel.frame.origin.x+showNumberLabel.frame.size.width+20, 0, 30, 50)];
        transFee.text=@"运费:";
        transFee.font=[UIFont systemFontOfSize:11.0];
        transFee.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
//        [transView addSubview:transFee];
  
        UILabel *feeMoney=[[UILabel alloc]initWithFrame:CGRectMake(transFee.frame.size.width+transFee.frame.origin.x, 0, 50, 50)];
        feeMoney.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
        feeMoney.font=[UIFont systemFontOfSize:13.0f];
        feeMoney.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSRMBMoneyWithoutMark:fee]];
//        [transView addSubview:feeMoney];
        
        //总价
         UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-80-15,0, 80,50)];
        //以前的
        priceLabel.text=[NSString stringWithFormat:@"￥%0.2f",[orderTotalPrice floatValue]];
        priceLabel.textColor=[Utils HexColor:0x333333 Alpha:1];
        priceLabel.font=[UIFont systemFontOfSize:13.0f];
        priceLabel.textAlignment=NSTextAlignmentCenter;
        priceLabel.backgroundColor=[UIColor clearColor];
//        [transView addSubview:priceLabel];
        
        UILabel *reduc= [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.frame.origin.x-30, 0, 30, 50)];
        reduc.text=@"已付:";
        reduc.textColor=[Utils HexColor:0x333333 Alpha:1];
        reduc.font=[UIFont systemFontOfSize:11.0f];
        reduc.backgroundColor=[UIColor clearColor];
//        [transView addSubview:reduc];
        
        UIButton *goOrder=[UIButton buttonWithType:UIButtonTypeCustom];
        [goOrder setTitle:@"去付款" forState:UIControlStateNormal];
        [goOrder setFrame:CGRectMake(UI_SCREEN_WIDTH-75-10,50+10, 75, 30)];//y 8.5+
        [goOrder setTitleColor:[Utils HexColor:0x3b3b3b Alpha:1] forState:UIControlStateNormal];
    
        goOrder.layer.masksToBounds=YES;
        goOrder.layer.cornerRadius=3;
        goOrder.titleLabel.font=FONT_T4;
        goOrder.tag=section;
        [goOrder addTarget:self action:@selector(orderBtn:) forControlEvents:UIControlEventTouchUpInside];
         goOrder.backgroundColor=[Utils HexColor:0xfedc32 Alpha:1];
        [transView addSubview:goOrder];
        
        UIButton *cancleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [cancleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [cancleBtn setFrame:CGRectMake(UI_SCREEN_WIDTH-75*2-10-10 ,50+10, 75, 30)];//8.5+
        cancleBtn.layer.masksToBounds=YES;
        cancleBtn.layer.cornerRadius=3;

        [cancleBtn setTitleColor:[Utils HexColor:0xffffff Alpha:1] forState:UIControlStateNormal];
        cancleBtn.titleLabel.font=FONT_T4;
        cancleBtn.backgroundColor=[UIColor blackColor];
        cancleBtn.tag=section;
        [transView addSubview:cancleBtn];
        [botomView addSubview:moreView];
        [botomView addSubview:transView];
        [cancleBtn addTarget:self action:@selector(cancleBtn:) forControlEvents:UIControlEventTouchUpInside];

        
        //5.6.10 才有订单跟踪
        switch ([st intValue]) {
            case 0://未付款  这里才有取消订单
            {
                cancleBtn.hidden=NO;
                goOrder.hidden=NO;
                 reduc.text=@"应付:";
//                 priceLabel.text=[NSString stringWithFormat:@"￥%0.2f",payAmount];
                priceLabel.text = [NSString stringWithFormat:@"¥%@", [Utils getSNSRMBMoneyWithoutMark:orderTotalPrice]];
                
           
            }
                break;
            case 1://已付款
            {
                cancleBtn.hidden=YES;
                goOrder.hidden=YES;
                //           transBtn.hidden=NO;
                [goOrder setTitle:@"联系客服" forState:UIControlStateNormal];
            }
                break;
            case 2://已审核
            {
                cancleBtn.hidden=YES;
                goOrder.hidden=YES;
                //            transBtn.hidden=NO;
                [goOrder setTitle:@"联系客服" forState:UIControlStateNormal];
            }
                break;
            case 3://已分配 生成交货单
            {
                cancleBtn.hidden=YES;
                goOrder.hidden=YES;
                //            transBtn.hidden=NO;
                [goOrder setTitle:@"联系客服" forState:UIControlStateNormal];
            }
                break;
            case 4://拣货中
            {
                cancleBtn.hidden=YES;
                goOrder.hidden=YES;
                //           transBtn.hidden=NO;
                [goOrder setTitle:@"联系客服" forState:UIControlStateNormal];
            }
                break;
            case 5://已发货(配送中)
            {
                cancleBtn.hidden=NO;
                goOrder.hidden=NO;
                //            transBtn.hidden=NO;
                [cancleBtn setTitle:@"订单跟踪" forState:UIControlStateNormal];
                [goOrder setTitle:@"确认收货" forState:UIControlStateNormal];
                
            }
                break;
            case 6://已收货
            {
                cancleBtn.hidden=NO;
                goOrder.hidden=NO;
                [cancleBtn setTitle:@"订单跟踪" forState:UIControlStateNormal];
  
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
//            case 7://取消申请(订单取消中)
//            {
//                cancleBtn.hidden=YES;
//                goOrder.hidden=YES;
//            }
//                break;
            case 8://已取消（）
            {
                cancleBtn.hidden=YES;
                goOrder.hidden=YES;
                //           transBtn.hidden=YES;
                //           [cell.transBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            }
                break;
            case 9://已关闭
            {
                cancleBtn.hidden=YES;
                goOrder.hidden=YES;
                //            transBtn.hidden=NO;
                //            [cell.transBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            }
                break;
            case 10://
            {
                cancleBtn.hidden=NO;
                goOrder.hidden=NO;
                [goOrder setTitle:@"评价" forState:UIControlStateNormal];
                
                [cancleBtn setTitle:@"订单跟踪" forState:UIControlStateNormal];
       

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
                //            transBtn.hidden=NO;
                //            [cell.transBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            }
                break;
            case 11://退货申请
            {
                cancleBtn.hidden=YES;
                goOrder.hidden=YES;
                //           transBtn.hidden=NO;
                //            [cell.cancleBtn setTitle:@"申请退货" forState:UIControlStateNormal];
            }
                break;
            case 12://退货中
            {
                cancleBtn.hidden=YES;
                goOrder.hidden=YES;
                //           transBtn.hidden=NO;
                //            [cell.transBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                //            [cell.cancleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            }
                break;
            case 13://退货完成
            {
                cancleBtn.hidden=YES;
                goOrder.hidden=YES;
                //            [cell.transBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                
            }
                break;
            case 14://退款申请中
            {
                cancleBtn.hidden=YES;
                goOrder.hidden=YES;
                //            transBtn.hidden=NO;
                //            [cell.transBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
        NSArray *pamentListArray=  orderModelData.paymentList;
        if ([pamentListArray count]>0) {
            OrderModelPaymentListInfo *paymentListInfo=[pamentListArray firstObject];
            switch ([paymentListInfo.status integerValue]) {
                case 0:
                {
                    reduc.text=@"应付:";
//                    priceLabel.text=[NSString stringWithFormat:@"￥%0.2f",payAmount];
                          priceLabel.text = [NSString stringWithFormat:@"¥%@", [Utils getSNSRMBMoneyWithoutMark:orderTotalPrice]];
                }
                    break;
                case 1:
                {
                    reduc.text=@"已付:";
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
        [showNumberLabel setFrame:CGRectMake(10, 0, UI_SCREEN_WIDTH-10, 50)];
        showNumberLabel.textAlignment=NSTextAlignmentLeft;
        showNumberLabel.text= [NSString stringWithFormat:@"%@    运费:%@    %@%@",showNumberLabel.text,feeMoney.text,reduc.text,priceLabel.text];
        
    }
    
    return botomView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    int a =20;//20
    UIView *titleHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50+a)];//43
    [titleHeadView setBackgroundColor:[Utils HexColor:0xf2f2f2 Alpha:1]];
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, a, UI_SCREEN_WIDTH,50)];
    [headView setBackgroundColor:[UIColor whiteColor]];
//    UIImageView *linTwoView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0+a, UI_SCREEN_WIDTH, 1)];
//    [linTwoView  setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:209.0/255.0 blue:204.0/255.0 alpha:1]];
//    [headView addSubview:linTwoView];
    UILabel *danLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0 ,60,50)];
    danLabel.textColor=[UIColor blackColor];
    danLabel.textColor=[Utils HexColor:0x333333 Alpha:1];
    danLabel.backgroundColor=[UIColor clearColor];
    danLabel.text=@"订单编号:";
    danLabel.font=[UIFont systemFontOfSize:12.0f];
    [headView addSubview:danLabel];
    
    UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(danLabel.frame.origin.x+danLabel.frame.size.width, danLabel.frame.origin.y, UI_SCREEN_WIDTH-70-60, 50)];
    orderLabel.lineBreakMode=-1;
    orderLabel.text=@"";
    orderLabel.font=FONT_t4;
    orderLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
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
        OrderModel *orderModelData= self.dataArray[section];
        st = [NSString stringWithFormat:@"%@",orderModelData.statusName];
//        nums=[NSString stringWithFormat:@"%@",orderModelData.qty];
        nums = [NSString stringWithFormat:@"%lu",(unsigned long)[orderModelData.detailList count]];
        oredrNum=[NSString stringWithFormat:@"%@",orderModelData.orderno];
        /*
       st = [NSString stringWithFormat:@"%@",self.dataArray[section][@"statusName"]];
       nums=[NSString stringWithFormat:@"%@",self.dataArray[section][@"qty"]];
       oredrNum=[NSString stringWithFormat:@"%@",self.dataArray[section][@"orderno"]];
         */
    }
    
    orderLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:oredrNum]];

    UILabel *statesLabel=[[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-80, danLabel.frame.origin.y, 70, 50)];
//    statesLabel.font=[UIFont systemFontOfSize:12.0f];
    statesLabel.font=FONT_T4;
    statesLabel.textAlignment=NSTextAlignmentRight;
    statesLabel.backgroundColor=[UIColor clearColor];
    statesLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
    statesLabel.text=st;
    [headView addSubview:statesLabel];
    
//    UILabel *showNumberLabel= [[UILabel alloc]initWithFrame:CGRectMake(statesLabel.frame.origin.x-40, 0+a, 50, 43)];
//    showNumberLabel.font=[UIFont systemFontOfSize:12.0f];
//    showNumberLabel.textAlignment=NSTextAlignmentCenter;
//    showNumberLabel.text=[NSString stringWithFormat:@"共%@件",nums];
//    showNumberLabel.backgroundColor=[UIColor clearColor];
//    showNumberLabel.textColor=[Utils HexColor:0x333333 Alpha:1];
//    [headView addSubview:showNumberLabel];
    [titleHeadView addSubview:headView];
    return titleHeadView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50+20;
//    return 43+20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    OrderModel *orderModelData= self.dataArray[section];
    NSArray *detailList=[NSArray arrayWithArray:orderModelData.detailList];
    /*
    NSArray *detailList=[NSArray arrayWithArray:self.dataArray[section][@"detailList"]];
     */
    NSString *secSS = [NSString stringWithFormat:@"%ld",(long)section];
    NSString *st = [NSString stringWithFormat:@"%@",orderModelData.status];
    BOOL isshowLast;//展示最后的button栏
    switch ([st intValue]) {
        case 0://未付款  这里才有取消订单
        {
     
            isshowLast=YES;

        }
            break;
        case 1://已付款
        {

            
            isshowLast=NO;
    
        }
            break;
        case 2://已审核
        {
             isshowLast=NO;
    
        }
            break;
        case 3://已分配 生成交货单
        {
   isshowLast=NO;
        }
            break;
        case 4://拣货中
        {
       isshowLast=NO;
     
        }
            break;
        case 5://已发货(配送中)
        {
             isshowLast=YES;

        }
            break;
        case 6://已收货
        {

             isshowLast=YES;

            
        }
            break;
            //            case 7://取消申请(订单取消中)
            //            {
            //                cancleBtn.hidden=YES;
            //                goOrder.hidden=YES;
            //            }
            //                break;
        case 8://已取消（）
        {
          isshowLast=NO;
            //           transBtn.hidden=YES;
            //           [cell.transBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }
            break;
        case 9://已关闭
        {
          isshowLast=NO;
            //            transBtn.hidden=NO;
            //            [cell.transBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }
            break;
        case 10://
        {
          isshowLast=YES;
          
        }
            break;
        case 11://退货申请
        {
             isshowLast=NO;
                   }
            break;
        case 12://退货中
        {
           isshowLast=NO;
            
        }
            break;
        case 13://退货完成
        {
        isshowLast=NO;
                   }
            break;
        case 14://退款申请中
        {
            isshowLast=NO;
        }
            break;
            
        default:
            break;
    }
    if ([tapSectionArray containsObject:secSS])
    {
        if (self.isUnReceived) {
            return 50;
        }
        if ( isshowLast==NO) {
          return 50*1;
        }
        return 50*2;
    }
    if ([detailList count]>2)
    {
        if (self.isUnReceived) {
            return 50*2;
        }
        if ( isshowLast==NO) {
            return 50*2;
        }
        return 50*3;
        
    }
    else
    {
        if (self.isUnReceived) {
           return 50;
        }

        if ( isshowLast==NO) {
            return 50*1;
        }
        
          return 50*2;
    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  [self.dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    NSString *stSec=[NSString stringWithFormat:@"%d",(int)section];
    if ([tapSectionArray containsObject:stSec])
    {
        return [self.dataArray[section][@"detailList"] count];
    }
    else
        if ( [self.dataArray[section][@"detailList"] count]>2)
    {
        return 2;
    }
    else
    {
    return [self.dataArray[section][@"detailList"] count];
    }
     */
    OrderModel *orderModelData= self.dataArray[section];
    
    NSArray *detailList=[NSArray arrayWithArray:orderModelData.detailList];
    NSString *stSec=[NSString stringWithFormat:@"%d",(int)section];
    if ([tapSectionArray containsObject:stSec])
    {
        return [detailList count];
    }
    else if ( [detailList count]>2)
    {
        return 2;
    }
    else
    {
        return [detailList count];
    }
}
-(void)tapShowAll:(UIGestureRecognizer *)gest
{
    UIView *tapView=(UIView *) [gest view];
    /*
    NSArray *oneDetailList=[NSArray arrayWithArray:self.dataArray[tapView.tag][@"detailList"]];
     */
    
    OrderModel *orderModelData= self.dataArray[tapView.tag];
    NSArray *oneDetailList=[NSArray arrayWithArray:orderModelData.detailList];
    
    SHOWALL = (int)[oneDetailList count];
    tapSection = (int)tapView.tag;
    //删除订单的时候 要注意tapSectionArray中要删除。 把点击展开的cell Section数存进去
    [tapSectionArray addObject:[NSString stringWithFormat:@"%d",tapSection]];
    [self reloadData];
 
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
