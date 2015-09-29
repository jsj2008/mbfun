//
//  MyOrderViewTableViewCell.m
//  Wefafa
//
//  Created by fafatime on 14-8-16.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MyOrderViewTableViewCell.h"
#import "MBShoppingGuideInterface.h"
#import "Utils.h"
#import "SUtilityTool.h"

@implementation MyOrderViewTableViewCell
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
@synthesize returnBtn;
@synthesize cancleReply;
@synthesize appriseView;
@synthesize writeTextfield;
@synthesize oneStarBtn,twoStarBtn,threeStarBtn,fiveStarBtn,fourStarBtn;//,lineImgV
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *goodView=[[UIView alloc]initWithFrame:CGRectMake(0,0, UI_SCREEN_WIDTH, 85)];
        [self.contentView addSubview:goodView];
        goodImgView=[[UIUrlImageView alloc]initWithFrame:CGRectMake(17, 15, 55, 55)];
        [goodImgView setImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
        [goodImgView setContentMode:UIViewContentModeScaleAspectFit];
        
        [goodView addSubview:goodImgView];
        //单价
        priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-15-70,goodImgView.frame.origin.y, 70,13)];
        priceLabel.text=@"";
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
        priceLabel.font=FONT_t5;
        priceLabel.backgroundColor=[UIColor clearColor];
        [goodView addSubview:priceLabel];
        //数量
        numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-15-50,priceLabel.frame.origin.y+priceLabel.frame.size.height, 50,15)];
        numberLabel.textColor=[Utils HexColor:0x999999 Alpha:1];
        numberLabel.font=FONT_t7;
        numberLabel.text=@"";
        numberLabel.textAlignment=NSTextAlignmentRight;
        numberLabel.backgroundColor=[UIColor clearColor];
        [goodView addSubview:numberLabel];
        //名称
        goodNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodImgView.frame.size.width+goodImgView.frame.origin.x+10,goodImgView.frame.origin.y-3,priceLabel.frame.origin.x-goodImgView.frame.size.width-goodImgView.frame.origin.x-15, 21)];
        goodNameLabel.font=FONT_t5;
        goodNameLabel.textColor=[Utils HexColor:0x3b3b3b Alpha:1];
        goodNameLabel.text=@"";
        goodNameLabel.backgroundColor=[UIColor clearColor];
        [goodView addSubview:goodNameLabel];
        
        UILabel *khLabel=[[UILabel alloc]initWithFrame:CGRectMake(goodImgView.frame.origin.x+goodImgView.frame.size.width+10, goodNameLabel.frame.size.height+goodNameLabel.frame.origin.y+5, 35, 15)];
        khLabel.textColor=[Utils HexColor:0x353535 Alpha:1];
        khLabel.text=@"款号:";
        khLabel.backgroundColor=[UIColor clearColor];
        khLabel.font=[UIFont systemFontOfSize:11.0f];
//        [goodView addSubview:khLabel];
        //款号
//        orderNoLabel = [[UILabel alloc]initWithFrame:CGRectMake(khLabel.frame.origin.x+khLabel.frame.size.width+3,khLabel.frame.origin.y,goodView.frame.size.width-120, 15)];
        orderNoLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodNameLabel.frame.origin.x,khLabel.frame.origin.y,goodView.frame.size.width-100, 15)];
        orderNoLabel.font=FONT_t7;
        orderNoLabel.textColor=[Utils HexColor:0x999999 Alpha:1];
        orderNoLabel.text=@"商品编号:";
        orderNoLabel.backgroundColor=[UIColor clearColor];
        [goodView addSubview:orderNoLabel];
        //颜色 size
        colcorLabel=[[UILabel alloc]initWithFrame:CGRectMake(goodNameLabel.frame.origin.x, khLabel.frame.origin.y+khLabel.frame.size.height+3,goodView.frame.size.width-115,khLabel.frame.size.height)];
//        [colcorLabel setTextColor:[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1]];
        colcorLabel.font=FONT_t7;
        colcorLabel.textColor=[Utils HexColor:0x999999 Alpha:1];
        colcorLabel.text=@"";
        colcorLabel.backgroundColor=[UIColor clearColor];
        [goodView addSubview:colcorLabel];
        CGFloat scale = UI_SCREEN_WIDTH/ 375.0;
        returnBtn=[OrderBtn buttonWithType:UIButtonTypeCustom];
        [returnBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        [returnBtn setFrame:CGRectMake(UI_SCREEN_WIDTH-75*scale-10 ,numberLabel.frame.origin.y+numberLabel.frame.size.height+5, 75*scale,30)];
//        returnBtn.layer.borderColor =[[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1]CGColor];
//        returnBtn.layer.borderWidth = 1.0;
        returnBtn.layer.cornerRadius = 3.0;
        returnBtn.layer.masksToBounds=YES;
        [returnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        returnBtn.hidden=YES;
        returnBtn.titleLabel.font=FONT_T4;
        [returnBtn addTarget:self
                           action:@selector(returnOrderClick:)
                 forControlEvents:UIControlEventTouchUpInside];
//        returnBtn.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
        [returnBtn setBackgroundColor:[UIColor blackColor]];
        [goodView addSubview:returnBtn];
        
        cancleReply=[OrderBtn buttonWithType:UIButtonTypeCustom];
        [cancleReply setTitle:@"取消退货" forState:UIControlStateNormal];
        [cancleReply setFrame:CGRectMake(UI_SCREEN_WIDTH-75*scale-10-75*scale-10 ,numberLabel.frame.origin.y+numberLabel.frame.size.height+5, 75*scale, 30)];
//        cancleReply.layer.borderColor =[[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1]CGColor];
//        cancleReply.layer.borderWidth = 1.0;
        cancleReply.layer.cornerRadius = 3.0;
        cancleReply.layer.masksToBounds=YES;
        [cancleReply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancleReply.hidden=YES;
        cancleReply.titleLabel.font=FONT_T4;
//        cancleReply.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
        cancleReply.backgroundColor=[Utils HexColor:0xE2E2E2 Alpha:1];
        [goodView addSubview:cancleReply];
        
        appriseView=[[UIView alloc]initWithFrame:CGRectMake(0,72, UI_SCREEN_WIDTH, 70+11)];
        appriseView.userInteractionEnabled=YES;
        appriseView.backgroundColor=[UIColor clearColor];
        appriseView.hidden=YES;
        [self.contentView addSubview:appriseView];
        
        UILabel *appriseL=[[UILabel alloc]initWithFrame:CGRectMake(15,15,100, 15)];
        appriseL.backgroundColor=[UIColor clearColor];
        appriseL.textColor=[Utils HexColor:0x353535 Alpha:1];
        appriseL.font=[UIFont systemFontOfSize:11.0f];
        appriseL.textAlignment=NSTextAlignmentLeft;
        appriseL.text=[NSString stringWithFormat:@"宝贝评星"];
//        [appriseView addSubview:appriseL];
        int  pointX;
        int pointY;
        pointX=70;
        pointY=0;
  
        oneStarBtn=[OrderBtn buttonWithType:UIButtonTypeCustom];
        [oneStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
        [oneStarBtn setFrame:CGRectMake(pointX+(18+10)*0, pointY, 40, 40)];//(UI_SCREEN_WIDTH-127-15)
        oneStarBtn.tag=1;
        [appriseView addSubview:oneStarBtn];

        twoStarBtn=[OrderBtn buttonWithType:UIButtonTypeCustom];
        [twoStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
        [twoStarBtn setFrame:CGRectMake(pointX+(18+10)*1, pointY, 40, 40)];
        twoStarBtn.tag=2;
        [appriseView addSubview:twoStarBtn];

        threeStarBtn=[OrderBtn buttonWithType:UIButtonTypeCustom];//"ico_appraise_star_unfull@3x.png
        [threeStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
        [threeStarBtn setFrame:CGRectMake(pointX+(18+10)*2, pointY, 40, 40)];
        threeStarBtn.tag=3;
        [appriseView addSubview:threeStarBtn];

        fourStarBtn=[OrderBtn buttonWithType:UIButtonTypeCustom];
        [fourStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
        [fourStarBtn setFrame:CGRectMake(pointX+(18+10)*3, pointY, 40, 40)];
        fourStarBtn.tag=4;
        [appriseView addSubview:fourStarBtn];

        fiveStarBtn=[OrderBtn buttonWithType:UIButtonTypeCustom];
        [fiveStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
        [fiveStarBtn setFrame:CGRectMake(pointX+(18+10)*4, pointY, 40, 40)];
        fiveStarBtn.tag=5;
        [appriseView addSubview:fiveStarBtn];
        
        UIImageView *lineImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, pointY+40-1, UI_SCREEN_WIDTH-15, 0.5)];
        [lineImgView setBackgroundColor:[Utils HexColor:0XD9D9D9 Alpha:1]];
        [appriseView addSubview:lineImgView];
        
        writeTextfield=[[UITextField alloc]initWithFrame:CGRectMake(15,pointY+40, UI_SCREEN_WIDTH-15-15, 50)];//28
        writeTextfield.font=FONT_t4;
        writeTextfield.textColor=COLOR_C6;
//        writeTextfield.layer.borderColor = [[Utils HexColor:0xacacac Alpha:1]CGColor];
//        writeTextfield.layer.borderWidth = 0.5;
        writeTextfield.placeholder=@"写点评价吧，对其他朋友帮助很大呦！";
//        writeTextfield.textColor=[Utils HexColor:0xacacac Alpha:1];

        [appriseView addSubview:writeTextfield];
        
//        NSString *appraiseText=[NSString stringWithFormat:@"%@",[Utils getSNSString:textDic[@"评价宝贝"][section]]];
//        if (appraiseText.length==0) {
   
//        }
//        else
//        {
//            writeTextfield.text=appraiseText;
//            writeTextfield.textColor=[UIColor blackColor];
//            
//        }
//        lineImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15,appriseView.frame.size.height-1, UI_SCREEN_WIDTH-15, 0.5)];
//        [lineImgV setBackgroundColor:[Utils HexColor:0xacacac Alpha:1]];
//        [appriseView addSubview:lineImgV];
        
    }
    return self;
}
-(void)returnOrderClick:(OrderBtn *)btn
{
    if ([self.delegate respondsToSelector:@selector(MyOrderViewTableViewCellReturnButtonAction:)]) {
        [self.delegate MyOrderViewTableViewCellReturnButtonAction:btn];
    }
}
- (void)awakeFromNib
{
    // Initialization code
}
-(void)tapStarBtn:(OrderBtn *)clickBtn
{
//    [_onDidSelectedbBtn fire:clickBtn eventData:nil];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
