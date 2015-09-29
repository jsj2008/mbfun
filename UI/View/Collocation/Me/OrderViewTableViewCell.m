//
//  OrderViewTableViewCell.m
//  Wefafa
//
//  Created by fafatime on 14-8-22.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "OrderViewTableViewCell.h"
#import "Utils.h"
#import "UIImageView+WebCache.h"
#import "CommMBBusiness.h"
#import "AppSetting.h"
#import "Utils.h"
#import "SUtilityTool.h"

@implementation OrderViewTableViewCell
//@synthesize timeLabel;
@synthesize orderLabel;
@synthesize goodNameLabel;
@synthesize goodImgView;
@synthesize  colcorLabel;
@synthesize sizeLabel;
@synthesize  brandLabel;
@synthesize  priceLabel;
@synthesize numberLabel;
@synthesize transPriceLabel;
@synthesize allPriceLabel;
@synthesize orderNoLabel;
@synthesize cancleBtn;
@synthesize goOrder;
@synthesize statesLabel;
@synthesize showNumberLabel;
@synthesize transBtn;
@synthesize khLabel;
@synthesize showSalePriceLabel;

//@synthesize param;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        if (goodImgView==nil)
        {
            UIView *goodView=[[UIView alloc]initWithFrame:CGRectMake(0,0, UI_SCREEN_WIDTH, 85)];
            [self.contentView addSubview:goodView];
            goodImgView=[[UIUrlImageView alloc]initWithFrame:CGRectMake(17, 15, 55, 55)];
            [goodImgView setImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
            [goodImgView setContentMode:UIViewContentModeScaleAspectFit];
            
            [goodView addSubview:goodImgView];
            //单价
            priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-10-60,goodImgView.frame.origin.y, 60,15)];
            priceLabel.text=@"￥80.50";
            priceLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
            priceLabel.font=FONT_t5;
            priceLabel.textAlignment=NSTextAlignmentRight;
            priceLabel.backgroundColor=[UIColor clearColor];
            [goodView addSubview:priceLabel];
            showSalePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-10-60,priceLabel.frame.origin.y+priceLabel.frame.size.height+3, 60,priceLabel.frame.size.height)];
            showSalePriceLabel.text=@"";
            showSalePriceLabel.textColor=[Utils HexColor:0x999999 Alpha:1];
            showSalePriceLabel.font=FONT_t7;
            showSalePriceLabel.textAlignment=NSTextAlignmentRight;
            showSalePriceLabel.backgroundColor=[UIColor clearColor];
            NSMutableAttributedString *attrbutdestring = [[NSMutableAttributedString alloc]initWithString:showSalePriceLabel.text];
            
            [attrbutdestring addAttributes:@{NSStrikethroughColorAttributeName: [Utils HexColor:0x999999 Alpha:1],
                                             NSForegroundColorAttributeName: [Utils HexColor:0x999999 Alpha:1],
                                             NSStrikethroughStyleAttributeName: @(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
                                             NSFontAttributeName:FONT_t7
                                             }range:NSMakeRange(0,showSalePriceLabel.text.length)];
            
            showSalePriceLabel.attributedText =attrbutdestring;
            [goodView addSubview:showSalePriceLabel];
            //数量
            numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-10-60,showSalePriceLabel.frame.origin.y+priceLabel.frame.size.height+3, 60,priceLabel.frame.size.height)];
            numberLabel.textColor=[Utils HexColor:0x999999 Alpha:1];
            numberLabel.font=[UIFont systemFontOfSize:11.0f];
            numberLabel.text=@"x1";
            numberLabel.textAlignment=NSTextAlignmentRight;
            numberLabel.backgroundColor=[UIColor clearColor];
            [goodView addSubview:numberLabel];
            
            //名称
            goodNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodImgView.frame.size.width+goodImgView.frame.origin.x+10,goodImgView.frame.origin.y,priceLabel.frame.origin.x-goodImgView.frame.size.width-goodImgView.frame.origin.x-15, 15)];
//            goodNameLabel.font=[UIFont systemFontOfSize:13.0f];
            goodNameLabel.font=FONT_t5;
            goodNameLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
            goodNameLabel.text=@"";
            goodNameLabel.backgroundColor=[UIColor clearColor];
            [goodView addSubview:goodNameLabel];
            
            khLabel=[[UILabel alloc]initWithFrame:CGRectMake(goodImgView.frame.origin.x+goodImgView.frame.size.width+15, goodNameLabel.frame.size.height+goodNameLabel.frame.origin.y+3, 135, 15)];
            khLabel.textColor=[Utils HexColor:0x919191 Alpha:1];
            khLabel.text=@"款号:";
            khLabel.backgroundColor=[UIColor clearColor];
            khLabel.font=FONT_t7;
            [goodView addSubview:khLabel];
            //款号
            orderNoLabel = [[UILabel alloc]initWithFrame:CGRectMake(khLabel.frame.origin.x+khLabel.frame.size.width+3,khLabel.frame.origin.y,goodView.frame.size.width-120, 15)];
            orderNoLabel.font=FONT_t7;
            orderNoLabel.textColor=[Utils HexColor:0x999999 Alpha:1];
            orderNoLabel.text=@"223/145";
            orderNoLabel.backgroundColor=[UIColor clearColor];
//            [goodView addSubview:orderNoLabel];
            //颜色 size
            colcorLabel=[[UILabel alloc]initWithFrame:CGRectMake(khLabel.frame.origin.x, khLabel.frame.origin.y+khLabel.frame.size.height+3,goodView.frame.size.width-115,khLabel.frame.size.height)];
//            [colcorLabel setTextColor:[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1]];
            colcorLabel.font=FONT_t7;
            colcorLabel.textColor=[Utils HexColor:0x999999 Alpha:1];
            colcorLabel.text=@"红玫瑰; 155/52A(24)";
            colcorLabel.backgroundColor=[UIColor clearColor];
            [goodView addSubview:colcorLabel];
//        UIImageView *linTwoView=[[UIImageView alloc]initWithFrame:CGRectMake(15, goodView.frame.origin.x+goodView.frame.size.height-1, UI_SCREEN_WIDTH, 1)];
//        [linTwoView  setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:209.0/255.0 blue:204.0/255.0 alpha:1]];
//        [goodView addSubview:linTwoView];

        }
        
    }
    return self;
}
- (void)updateCellContentWithDict:(NSDictionary *)dict
{
    /*
     "id":"672659",
     "product_sys_code":"212261",
     "barcode_sys_code":"21226130146",
     "sale_attr1_value_code":"30",
     "sale_attr1_value":"银灰",
     "sale_attr2_value_code":"111",
     "sale_attr2_value":"165/88A",
     "brand_id":"1",
     "channel_code":"HQ01S117",
     "market_price":"119.000000",
     "product_url":"http://img5.ibanggo.com/sources/images/goods/MB/212261/212261_30_09.jpg",
     "product_name":"男装印波点翻领短袖恤",
     "status":"1",
     "spec_price":"0.010000"
     "num":"1"
     */
    
    NSString *settingP=[NSString stringWithFormat:@"%@",[dict objectForKey:@"spec_price"]];
    float settlePrice= [settingP floatValue];
    
    [priceLabel setText:[NSString stringWithFormat:@"¥%.2f",settlePrice]];
    
    [goodNameLabel setText:[dict objectForKey:@"product_name"]];
    [khLabel setText:[NSString stringWithFormat:@"商品编号：%@",[dict objectForKey:@"product_sys_code"]]];
    [colcorLabel setText:[NSString stringWithFormat:@"颜色：%@  尺码：%@",[dict objectForKey:@"sale_attr1_value"],[dict objectForKey:@"sale_attr2_value"]]];
    
    [numberLabel setText:[NSString stringWithFormat:@"x%@",[dict objectForKey:@"num"]]];
    showSalePriceLabel.hidden=YES;
    [goodImgView downloadImageUrl:[CommMBBusiness changeStringWithurlString:[dict objectForKey:@"product_url"] size:SNS_IMAGE_Size] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:DEFAULT_LOADING_IMAGE];
    
    
}
- (void)awakeFromNib
{
    // Initialization code
}
-(void)deletOrder
{
    
}
/*
-(void)setParam:(NSDictionary *)param
{
    _param= param;
    NSArray *detailList=[NSArray arrayWithArray:_param[@"detailList"]];
    
    if (detailList==nil||detailList.count>0)
    {
        if ([detailList count]>2)
        {

        }
        else
        {
            for (int a =0; a<[detailList count]; a++)
            {
                

               
                //产品
                NSDictionary *proudctList = [detailList[a] objectForKey:@"proudctList"];
                NSDictionary *detailInfo  = [detailList[a] objectForKey:@"detailInfo"];
               self.colcorLabel.text=[Utils getSNSString:proudctList[@"productInfo"][@"coloR_NAME"]];
               self.sizeLabel.text=[Utils getSNSString:proudctList[@"productInfo"][@"speC_NAME"]];
               self.goodNameLabel.text=[Utils getSNSString:proudctList[@"productInfo"][@"proD_NAME"]];

                if ([self.goodNameLabel.text length]>12)
                {
                    self.goodNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
                    self.goodNameLabel.numberOfLines = 0;
                    [self.goodNameLabel sizeToFit];
                 }
                 else
                {
                    self.goodNameLabel.numberOfLines = 1;
                }

               self.orderNoLabel.text=[NSString stringWithFormat:@"%@", [Utils getSNSString:proudctList[@"productInfo"][@"inneR_CODE"]]];
        //
                NSString *imgUrlstr = [[Utils getSNSString:proudctList[@"productInfo"][@"coloR_FILE_PATH"]]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //
               NSURL *imgUrl=[NSURL URLWithString:imgUrlstr];
                [self.goodImgView setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"Icon-72.png"]];
        //
        //
               NSString *price = [NSString stringWithFormat:@"%@",detailInfo[@"acT_PRICE"]];
        //
                NSString *danNum=[NSString stringWithFormat:@"%@",detailInfo[@"qty"]];
        //
        //                //        //    数量
              self.numberLabel.text=[NSString stringWithFormat:@"x%@",[Utils getSNSString:danNum]];

        //                //        //单价  参数有问题
                self.priceLabel.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSString:price]];

           }
            transView=[[UIView alloc]initWithFrame:CGRectMake(0, goodView.frame.size.height+goodView.frame.origin.y, UI_SCREEN_WIDTH, 43)];
            [self.contentView addSubview:transView];
            UILabel *reduc= [[UILabel alloc]initWithFrame:CGRectMake(15, 3, 30, 43)];
            reduc.text=@"合计:";
            reduc.textColor=[Utils HexColor:0x353535 Alpha:1];
            reduc.font=[UIFont systemFontOfSize:11.0f];
            reduc.backgroundColor=[UIColor clearColor];
            [self.transView addSubview:reduc];
            self.goOrder=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.goOrder setTitle:@"去支付" forState:UIControlStateNormal];
            [self.goOrder setFrame:CGRectMake(UI_SCREEN_WIDTH-70-15,8.5, 70, 26)];
            [self.goOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            self.goOrder.titleLabel.font=[UIFont systemFontOfSize:13.0f];
            self.goOrder.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:106.0/255.0 blue:91.0/255.0 alpha:1];
            [self.transView addSubview:self.goOrder];
            self.cancleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.cancleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.cancleBtn setFrame:CGRectMake(UI_SCREEN_WIDTH-70*2-15-15 ,8.5, 70, 26)];
            self.cancleBtn.layer.borderColor =[[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1]CGColor];
            self.cancleBtn.layer.borderWidth = 1.0;
            [self.cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.cancleBtn.titleLabel.font=[UIFont systemFontOfSize:13.0f];
            self.cancleBtn.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
            [self.transView addSubview:self.cancleBtn];

        }
        
    }
    
    NSString *nums=[NSString stringWithFormat:@"%@",_param[@"qty"]];
    
    self.showNumberLabel.text=[NSString stringWithFormat:@"共%@件",nums];
    
    NSString *amountstr = [NSString stringWithFormat:@"%@",_param[@"amount"]];
    //总价
    self.allPriceLabel.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSString:amountstr]];
    
   self.orderLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:_param[@"orderno"]]];
    
    self.statesLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:_param[@"statusName"]]];
    //状态
    NSString *st = [NSString stringWithFormat:@"%@",_param[@"status"]];
    [self.cancleBtn setFrame:CGRectMake(UI_SCREEN_WIDTH-80*3, 25+8, 70,30)];
    [self.goOrder setFrame:CGRectMake(UI_SCREEN_WIDTH-80*1, 25+8, 70,30)];
    switch ([st intValue]) {
        case 0://未付款  这里才有取消订单
        {
            self.cancleBtn.hidden=NO;
            self.goOrder.hidden=NO;
            self.transBtn.hidden=YES;
            [self.cancleBtn setFrame:CGRectMake(UI_SCREEN_WIDTH-80*2, 25+8, 70,30)];
            [self.goOrder setFrame:CGRectMake(UI_SCREEN_WIDTH-80, 25+8, 70,30)];
            
        }
            break;
        case 1://已付款
        {
            self.cancleBtn.hidden=YES;
            self.goOrder.hidden=NO;
            self.transBtn.hidden=NO;
            [self.goOrder setTitle:@"申请退款" forState:UIControlStateNormal];
            
        }
            break;
        case 2://已审核
        {
            self.cancleBtn.hidden=YES;
            self.goOrder.hidden=NO;
            self.transBtn.hidden=NO;
            [self.goOrder setTitle:@"申请退款" forState:UIControlStateNormal];
        }
            break;
        case 3://已分配 生成交货单
        {
            self.cancleBtn.hidden=YES;
            self.goOrder.hidden=NO;
            self.transBtn.hidden=NO;
            [self.goOrder setTitle:@"申请退款" forState:UIControlStateNormal];
        }
            break;
        case 4://拣货中
        {
            self.cancleBtn.hidden=YES;
            self.goOrder.hidden=NO;
            self.transBtn.hidden=NO;
            [self.goOrder setTitle:@"申请退款" forState:UIControlStateNormal];
        }
            break;
        case 5://已发货(配送中)
        {
            self.cancleBtn.hidden=YES;
            self.goOrder.hidden=NO;
            self.transBtn.hidden=NO;
            
            [self.goOrder setTitle:@"确认收货" forState:UIControlStateNormal];
            
        }
            break;
        case 6://已收货
        {
            self.cancleBtn.hidden=NO;
            self.goOrder.hidden=NO;
            [self.goOrder setTitle:@"申请退货" forState:UIControlStateNormal];
            [self.cancleBtn setTitle:@"订单评价" forState:UIControlStateNormal];
            self.transBtn.hidden=NO;
            
        }
            break;
        case 7://取消申请(订单取消中)
        {
            self.cancleBtn.hidden=YES;
            self.goOrder.hidden=YES;
            self.transBtn.hidden=YES;
            
        }
            break;
        case 8://已取消（）
        {
            self.cancleBtn.hidden=YES;
            self.goOrder.hidden=YES;
            self.transBtn.hidden=YES;
            //           [cell.transBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }
            break;
        case 9://已关闭
        {
            self.cancleBtn.hidden=YES;
            self.goOrder.hidden=YES;
            self.transBtn.hidden=NO;
            //            [cell.transBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }
            break;
        case 10://已退款
        {
            self.cancleBtn.hidden=YES;
            self.goOrder.hidden=YES;
            self.transBtn.hidden=NO;
            //            [cell.transBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }
            break;
        case 11://退货申请
        {
            self.cancleBtn.hidden=YES;
            self.goOrder.hidden=YES;
            self.transBtn.hidden=NO;
            //            [cell.cancleBtn setTitle:@"申请退货" forState:UIControlStateNormal];
        }
            break;
        case 12://退货中
        {
            self.cancleBtn.hidden=YES;
            self.goOrder.hidden=YES;
            self.transBtn.hidden=NO;
            //            [cell.transBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            //            [cell.cancleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        }
            break;
        case 13://退货完成
        {
            self.cancleBtn.hidden=YES;
            self.goOrder.hidden=YES;
            //            [cell.transBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            
        }
            break;
        case 14://退款申请中
        {
            self.cancleBtn.hidden=YES;
            self.goOrder.hidden=YES;
            self.transBtn.hidden=NO;
            //            [cell.transBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
//    self.cancleBtn.tag=indexPath.section;
//    self.goOrder.tag=indexPath.section;
//    self.transBtn.tag=indexPath.section;
//    [self.transBtn addTarget:self action:@selector(findeTransBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.cancleBtn addTarget:self action:@selector(cancleBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.goOrder addTarget:self action:@selector(orderBtn:) forControlEvents:UIControlEventTouchUpInside];

    
    
}
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
