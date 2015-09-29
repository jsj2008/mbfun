//
//  MyShoppingTrollyGoodsTableViewCell.m
//  Wefafa
//
//  Created by mac on 14-9-2.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MyShoppingTrollyGoodsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Utils.h"
#import "MBShoppingGuideInterface.h"
#import "AppSetting.h"
#import "CommMBBusiness.h"
#import "Toast.h"
#import "Globle.h"
#import "LPLabel.h"
#import "UIStepperNumberField.h"
#import "UIUrlImageView.h"
#import "SUtilityTool.h"
#import "PlatFormBasicInfo.h"
@implementation MyShoppingTrollyGoodsData

-(void)setValue:(NSDictionary *)value1
{
    _value=value1;
    if (_value!=nil && _value[@"cartInfo"])
        isTrolly=YES; //数据来源：购物车
    else
        isTrolly=NO; //数据来源：直接购买
    if (value1[@"proudctList"][@"productInfo"][@"lM_PROD_CLS_ID"]) {
        self.lM_PROD_CLS_ID = value1[@"proudctList"][@"productInfo"][@"lM_PROD_CLS_ID"];
    }
    
    self.shoppingcartid=[self genshoppingcartid];
    self.colorid=[self gencolorid];
    self.colorname=[self gencolorname];
    self.sizeid=[self gensizeid];
    self.sizename=[self gensizename];
    self.imageurl=[self genimageurl];
    self.prodid=[self genprodid];
    self.prodname=[self genprodname];
    self.price=[self genprice];
    self.number=[self gennumber];
    self.saleprice=[self gensaleprice];
    self.listqty=[self genlistqty];
    self.productcode=[self genProductCode];
    self.designerid=[self genDesignerId];
    self.designername=[self genDesignerName];
    self.collocationid=[self genCollocationId];
    self.status=[self genStatus];
    self.shareUserId=[self genShareUserId];
    self.prodNum = [self genprodNum];
    
    self.platFormInfo = [JsonToModel objectFromDictionary:value1[@"platFormInfo"] className:@"PlatFormInfo"];
//    self.platFormInfo= value1;
    
    
    
}

-(NSString *)gencolorid
{
    NSString *val=@"";
    if (isTrolly)
    {
//        if (_value!=nil && _value[@"cartInfo"] && _value[@"cartInfo"][@"coloR_ID"])
//        {
//            val=[NSString stringWithFormat:@"%d",[_value[@"cartInfo"][@"coloR_ID"] intValue]];
//        }
        if (_value!=nil && _value[@"proudctList"] && _value[@"proudctList"][@"productInfo"] && _value[@"proudctList"][@"productInfo"][@"coloR_ID"])
        {
            val=_value[@"proudctList"][@"productInfo"][@"coloR_ID"];
        }
    }
    else
    {
        if (_value!=nil && _value[@"productInfo"] && _value[@"productInfo"][@"coloR_ID"])
        {
            val=[NSString stringWithFormat:@"%d",[_value[@"productInfo"][@"coloR_ID"] intValue]];
        }
    }
    return val;
}

-(NSString *)gencolorname
{
    NSString *val=@"";
    if (isTrolly)
    {
        if (_value!=nil && _value[@"proudctList"] && _value[@"proudctList"][@"productInfo"] && _value[@"proudctList"][@"productInfo"][@"coloR_NAME"])
        {
            val=_value[@"proudctList"][@"productInfo"][@"coloR_NAME"];
        }
    }
    else
    {
        if (_value!=nil && _value[@"productInfo"] && _value[@"productInfo"][@"coloR_NAME"])
        {
            val=_value[@"productInfo"][@"coloR_NAME"];
        }
    }
    return val;
}

-(NSString *)genshoppingcartid
{
    NSString *val=@"";
    if (isTrolly)
    {
        if (_value!=nil && _value[@"cartInfo"] && _value[@"cartInfo"][@"id"])
        {
            val=[NSString stringWithFormat:@"%d",[_value[@"cartInfo"][@"id"] intValue]];
        }
    }
    else
    {
    }
    return val;
}

-(NSString *)gensizeid
{
    NSString *val=@"";
    if (isTrolly)
    {
//        if (_value!=nil && _value[@"cartInfo"] && _value[@"cartInfo"][@"speC_ID"])
//        {
//            val=[NSString stringWithFormat:@"%d",[_value[@"cartInfo"][@"speC_ID"] intValue]];
//        }
        if (_value!=nil && _value[@"proudctList"] && _value[@"proudctList"][@"productInfo"] && _value[@"proudctList"][@"productInfo"][@"speC_ID"])
        {
            val=_value[@"proudctList"][@"productInfo"][@"speC_ID"];
        }
    }
    else
    {
        if (_value!=nil && _value[@"productInfo"] && _value[@"productInfo"][@"speC_ID"])
        {
            val=[NSString stringWithFormat:@"%d",[_value[@"productInfo"][@"speC_ID"] intValue]];
        }
    }
    return val;
}

-(NSString *)gensizename
{
    NSString *val=@"";
    if (isTrolly)
    {
        if (_value!=nil && _value[@"proudctList"] && _value[@"proudctList"][@"productInfo"] && _value[@"proudctList"][@"productInfo"][@"speC_NAME"])
        {
            val=_value[@"proudctList"][@"productInfo"][@"speC_NAME"];
        }
    }
    else
    {
        if (_value!=nil && _value[@"productInfo"] && _value[@"productInfo"][@"speC_NAME"])
        {
            val=_value[@"productInfo"][@"speC_NAME"];
        }
    }
    return val;
}

-(NSString *)genimageurl
{
    NSString *val=@"";
    if (isTrolly)
    {
        if (_value!=nil && _value[@"proudctList"] && _value[@"proudctList"][@"productInfo"] && _value[@"proudctList"][@"productInfo"][@"coloR_FILE_PATH"])
        {
            val=_value[@"proudctList"][@"productInfo"][@"coloR_FILE_PATH"];
        }
    }
    else
    {
        if (_value!=nil && _value[@"productInfo"] && _value[@"productInfo"][@"coloR_FILE_PATH"])
        {
            val=_value[@"productInfo"][@"coloR_FILE_PATH"];
        }
    }
    return val;
}

-(NSString *)genprodid
{
    NSString *val=@"";
    if (isTrolly)
    {
        if (_value!=nil && _value[@"proudctList"] && _value[@"proudctList"][@"productInfo"])
        {
            NSDictionary *clsarr=_value[@"proudctList"][@"productInfo"];
            if (clsarr.count>0)
                val=[NSString stringWithFormat:@"%d",[clsarr[@"id"] intValue]];
        }
    }
    else
    {
        if (_value!=nil && _value[@"productInfo"] && _value[@"productInfo"][@"id"])
        {
            val=[NSString stringWithFormat:@"%d",[_value[@"productInfo"][@"id"] intValue]];
        }else if (_value!=nil && _value[@"productInfo"] && _value[@"productInfo"][@"PROD_ID"]){
        
         val=[NSString stringWithFormat:@"%d",[_value[@"productInfo"][@"PROD_ID"] intValue]];
        }
    }
    return val;
}

-(NSString *)genprodNum
{
    
    NSString * val=@"";
    if (isTrolly)
    {
        if (_value!=nil && _value[@"proudctList"] && _value[@"proudctList"][@"productInfo"] && _value[@"proudctList"][@"productInfo"][@"proD_NUM"])
        {
            val=_value[@"proudctList"][@"productInfo"][@"proD_NUM"];
        }
    }
    else
    {
        if (_value!=nil && _value[@"productInfo"] && _value[@"productInfo"][@"proD_NUM"])
        {
            val=_value[@"productInfo"][@"proD_NUM"] ;
        }
    }
    return val;
}

-(NSString *)genprodname
{
    NSString *val=@"";
    if (isTrolly)
    {
        if (_value!=nil && _value[@"proudctList"] && _value[@"proudctList"][@"productInfo"] && _value[@"proudctList"][@"productInfo"][@"proD_NAME"])
        {
            val=_value[@"proudctList"][@"productInfo"][@"proD_NAME"];
        }
    }
    else
    {
        if (_value!=nil && _value[@"productInfo"] && _value[@"productInfo"][@"proD_NAME"])
        {
            val=_value[@"productInfo"][@"proD_NAME"];
        }
    }
    return val;
}

-(double)gensaleprice
{
    double val=0;
    if (isTrolly)
    {
        if (_value!=nil && _value[@"proudctList"] && _value[@"proudctList"][@"productInfo"] && _value[@"proudctList"][@"productInfo"][@"salE_PRICE"])
        {
            val=[_value[@"proudctList"][@"productInfo"][@"salE_PRICE"] doubleValue];
        }
    }
    else
    {
        if (_value!=nil && _value[@"productInfo"] && _value[@"productInfo"][@"salE_PRICE"])
        {
            val=[_value[@"productInfo"][@"salE_PRICE"] doubleValue];
        }
    }
    return val;
}

-(int)genlistqty
{
    int val=0;
    if (isTrolly)
    {
        if (_value!=nil && _value[@"proudctList"] && _value[@"proudctList"][@"productInfo"] && _value[@"proudctList"][@"productInfo"][@"lisT_QTY"])
        {
            val=[_value[@"proudctList"][@"productInfo"][@"lisT_QTY"] intValue];
        }
    }
    else
    {
        if (_value!=nil && _value[@"productInfo"] && _value[@"productInfo"][@"lisT_QTY"])
        {
            val=[_value[@"productInfo"][@"lisT_QTY"] intValue];
        }
    }
    return val;
}

-(NSString *)genProductCode
{

   NSString * val=@"";
    if (isTrolly)
    {
        if (_value!=nil && _value[@"proudctList"] && _value[@"proudctList"][@"productInfo"] && _value[@"proudctList"][@"productInfo"][@"proD_CLS_NUM"])
        {
            val=_value[@"proudctList"][@"productInfo"][@"proD_CLS_NUM"];
        }
    }
    else
    {
        if (_value!=nil && _value[@"productInfo"] && _value[@"productInfo"][@"proD_CLS_NUM"])
        {
            val=_value[@"productInfo"][@"proD_CLS_NUM"] ;
        }
    }
    return val;
}

-(float)genprice
{
    float val=0;
    if (isTrolly)
    {
//        if (_value!=nil && _value[@"cartInfo"] && _value[@"cartInfo"][@"price"])
//        {
//            val=[_value[@"cartInfo"][@"price"] floatValue];
//        }
        if (_value!=nil && _value[@"proudctList"] && _value[@"proudctList"][@"productInfo"] && _value[@"proudctList"][@"productInfo"][@"price"])
        {
            val=[_value[@"proudctList"][@"productInfo"][@"price"] floatValue];
        }
    }
    else
    {
        if (_value!=nil && _value[@"productInfo"] && _value[@"productInfo"][@"price"])
        {
            val=[_value[@"productInfo"][@"price"] floatValue];
        }
    }
    return val;
}

-(int)gennumber
{
    int val=0;
    if (isTrolly)
    {
        if (_value!=nil && _value[@"cartInfo"] && _value[@"cartInfo"][@"qty"])
        {
            val=[_value[@"cartInfo"][@"qty"] intValue];
        }
    }
    else
    {
        if (_value!=nil && _value[@"productInfo"] && _value[@"productInfo"][@"qty"])
        {
            val=[_value[@"productInfo"][@"qty"] intValue];
        }
    }
    return val;
}

-(NSString *)genDesignerId
{
    NSString *val=@"";
    if (isTrolly)
    {
        if (_value!=nil && _value[@"cartInfo"] && _value[@"cartInfo"][@"designerId"])
        {
            val=[Utils getSNSString:_value[@"cartInfo"][@"designerId"]];
        }
    }
    else
    {
    }
    return val;
}
-(NSString *)genDesignerName
{
    NSString *val=@"";
    if (isTrolly)
    {
        if (_value!=nil && _value[@"cartInfo"] && _value[@"cartInfo"][@"designerName"])
        {
            val=[Utils getSNSString:_value[@"cartInfo"][@"designerName"]];
        }
    }
    else
    {
    }
    return val;
}
-(NSString *)genShareUserId
{
    NSString *val=@"";
    if (isTrolly)
    {
        if (_value!=nil && _value[@"cartInfo"] && _value[@"cartInfo"][@"sharE_SELLER_ID"])
        {
            val=[Utils getSNSString:[NSString stringWithFormat:@"%@",_value[@"cartInfo"][@"sharE_SELLER_ID"]]];
        }
    }
    else
    {
    }
    return val;
}

-(NSString *)genCollocationId
{
    NSString *val=@"";
    if (isTrolly)
    {
        if (_value!=nil && _value[@"cartInfo"] && _value[@"cartInfo"][@"collocatioN_ID"])
        {
            val=[Utils getSNSInteger:_value[@"cartInfo"][@"collocatioN_ID"]];
        }
    }
    else
    {
    }
    return val;
}
-(int)genStatus
{
    int val=0;
    if (isTrolly)
    {
        if (_value!=nil && _value[@"proudctList"] && _value[@"proudctList"][@"productInfo"] && _value[@"proudctList"][@"productInfo"][@"status"])
        {
            val=[_value[@"proudctList"][@"productInfo"][@"status"] intValue];
        }
    }
    else
    {
        if (_value!=nil && _value[@"productInfo"] && _value[@"productInfo"][@"status"])
        {
            val=[_value[@"productInfo"][@"status"] intValue];
        }
    }
    return val;
}

-(BOOL)isUsed
{
    BOOL rst=YES;
    if (self.status!=2)
    {
        rst=NO;
    }
    else if (self.stocknum<=0)
    {
        rst=NO;
    }
    else if (self.number>self.stocknum)
    {
        rst=NO;
    }
    return rst;
}
#pragma mark -- 范票（红包）、活动、优惠总price
+ (double)totalFanPiaoPrice:(NSArray *)dataArr
{
    double val=0;
    for (int i=0;i<dataArr.count;i++)
    {
        MyShoppingTrollyGoodsData *data=dataArr[i];
        if (data.diS_Price) {
            
            if (data.prodInfo == nil) {
                val+=(data.saleprice - data.diS_Price.doubleValue) * data.number;
            }else{
                 val+=(data.saleprice - data.diS_Price.doubleValue )*data.number- data.prodInfo.dec_price.doubleValue;
//                val+=(data.saleprice - data.diS_Price.doubleValue - data.prodInfo.dec_price.doubleValue) * data.number;
            }
        }else{
            val+=data.saleprice * data.number;
        }
    }
    return val;
}
#pragma mark -- 活动优惠总price
+(double)totalPricebyPlatFormInfo:(NSArray *)dataArr
{
    double val=0;
    
    for (int i=0;i<dataArr.count;i++)
    {
        MyShoppingTrollyGoodsData *data=dataArr[i];
        if (data.prodInfo == nil) {
            val+=data.saleprice * data.number;
        }else{
            if (data.saleprice >= data.prodInfo.spec_price.doubleValue) {
//                val+=(data.saleprice - data.prodInfo.dec_price.floatValue) * data.number;
                val+=[data.prodInfo.total_price doubleValue];
                
            }else{
                val+=data.saleprice * data.number;
            }
            
        }
    }
    return val;
}

+(double)totalPrice:(NSArray *)dataArr
{
    double val=0;
    for (int i=0;i<dataArr.count;i++)
    {
        MyShoppingTrollyGoodsData *data=dataArr[i];
        val+=data.saleprice * data.number;
    }
    return val;
}
+(double)totalPriceWithshopProdprice:(NSArray *)dataArr
{
    double val=0;
    for (int i=0;i<dataArr.count;i++)
    {
        MyShoppingTrollyGoodsData *data=dataArr[i];
        val+=data.shopProdprice.floatValue * data.number;
    }
    return val;
}
+(int)count:(NSArray *)dataArr
{
    int val=0;
    for (int i=0;i<dataArr.count;i++)
    {
        MyShoppingTrollyGoodsData *data=dataArr[i];
        val+=data.number;
    }
    return val;
}

@end


@implementation PlatFormInfo
-(id)init{
    self= [super init];
    
   
    return self;
}

@end

#pragma mark -
#pragma mark - MyShoppingTrollyGoodsTableViewCell
////

static const CGFloat kCellH = 85.f;
static const CGFloat kImgVH = 55.f;

@interface MyShoppingTrollyGoodsTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic) BOOL constraintsSetup;
@property (nonatomic, strong) UIButton *addPopBtn;
@end

@implementation MyShoppingTrollyGoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //    if (cell == nil) {
        //        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyShoppingTrollyGoodsTableViewCell" owner:self options:nil] objectAtIndex:0];
        //
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.delegate=self;
        //
        //    }
        //        self.topContentView = self.contentView;
        
        //[self initialize]; // 调用父类的方法

        // 初始化视图
        //self.lbSum,
        NSArray *viewArray = @[self.lineView,self.btnSelectGoods,self.imageGoods,
                               self.lbName,self.lbNumber,self.lbPrice,self.lbColor,
                               self.lbStockNone,self.goodsNum,self.priceLP,self.lbNum, self.popBtn, self.deleteButton];
        
        for (UIView *view in viewArray) {
            [self.contentView addSubview:view];
        }

    }
    return self;
}

-(void)awakeFromNib
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subview in self.subviews) {
        //iterate through subviews until you find the right one...
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
            //your color
            ((UIView*)[subview.subviews firstObject]).backgroundColor = COLOR_C12;
        }
    }
}

- (void)updateConstraints
{
    [super updateConstraints];
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOWW, 0.5)];
        _lineView.backgroundColor = COLOR_C9;//[UIColor colorWithHexString:@"#ececec"];
    }
    return _lineView;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(WINDOWW - 50, 0.5, 50, self.contentView.height-0.5)];
        _deleteButton.backgroundColor = COLOR_C12;
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        _deleteButton.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleRightMargin;
        [_deleteButton addTarget:self action:@selector(productDeleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

//删除商品
-(void)productDeleteClick{
    if ([_delegate respondsToSelector:@selector(productDeleteBtnClick:WithIndexPath:)]) {
        [_delegate productDeleteBtnClick:nil WithIndexPath:_indexPath];
    }
}

#pragma mark  是否给尺寸颜色位置添加 修改商品事件
- (void)lbclolrAddpopBtn:(BOOL)isAddbtn{
    if (isAddbtn) {
        //隐藏价格信息
        _lbPrice.hidden = isAddbtn;
        _priceLP.hidden = isAddbtn;
        _lbNum.hidden = isAddbtn;
        _lbStockNone.hidden = isAddbtn;
        
        //向颜色尺寸的位置添加可点击btn
        if (_popBtn.enabled) {
            _addPopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_addPopBtn setBackgroundColor:[UIColor clearColor]];
            [_addPopBtn setFrame:self.lbColor.frame];
            [_addPopBtn addTarget:self action:@selector(popBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_addPopBtn];
        }

    }else{
        _lbPrice.hidden = isAddbtn;
        _priceLP.hidden = isAddbtn;
        _lbNum.hidden = isAddbtn;

        [_addPopBtn removeFromSuperview];
    }

    //折后价格>=打折前价格 隐藏打折前价格的lable
    NSString *astring = [_lbPrice.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    NSString *bstring = [_priceLP.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    if ([astring floatValue]>=[bstring floatValue]) {
        _priceLP.hidden=YES;
    }else{
        _priceLP.hidden=NO;
    }
}

#pragma mark - 商品名称
- (UILabel *)lbName
{
    //    self.lineView.frame = CGRectMake(0, 0.5, WINDOWW, 0.5f);
    if (!_lbName) {
        _lbName.hidden = YES;
        CGFloat x = CGRectGetMaxX(self.imageGoods.frame)+10.f;
        CGFloat y = 15.f;
        _lbName= [[UILabel alloc] initWithFrame:CGRectMake(x, y, 150, 12)];// 106 9
        _lbName.textColor = COLOR_C2 ;
        _lbName.textAlignment = NSTextAlignmentLeft;
        _lbName.font = FONT_T6;
    }
    
    return _lbName;
}

#pragma mark - 商品价格（现价）
- (UILabel *)lbPrice
{
    if (!_lbPrice) {
        _lbPrice.hidden = YES;
//        CGFloat x = self.bounds.size.width - 100.f - 10.f;
        CGFloat y = CGRectGetMinY(self.lbName.frame);
        _lbPrice= [[UILabel alloc] initWithFrame:CGRectMake(WINDOWW - 110, y, 100, 12)];// WINDOWW - 110 13
        [_lbPrice setTextAlignment:NSTextAlignmentRight];
        _lbPrice.font = FONT_T6;//[UIFont systemFontOfSize:12.0f];
        _lbPrice.textColor = COLOR_C2;
    }
    return _lbPrice;
}

#pragma mark - 商品编号
- (UILabel *)lbNumber
{
    if (!_lbNumber) {
        _lbNumber.hidden = YES;
        CGFloat x = CGRectGetMinX(self.lbName.frame);
        CGFloat y = CGRectGetMaxY(self.lbName.frame)+10.f;
        _lbNumber= [[UILabel alloc] initWithFrame:CGRectMake(x, y, 110, 10)];// 106  41
        _lbNumber.textAlignment = NSTextAlignmentLeft;
        _lbNumber.font = FONT_t7;//[UIFont systemFontOfSize:11.0f];
        _lbNumber.textColor = COLOR_C6;
    }
    return _lbNumber;
}

#pragma mark - 商品颜色,尺码
- (UILabel *)lbColor
{
    if (!_lbColor) {
        _lbColor.hidden = YES;
        CGFloat x = CGRectGetMinX(self.lbName.frame);
        CGFloat y = CGRectGetMaxY(self.lbNumber.frame)+10.f;
        _lbColor= [[UILabel alloc] initWithFrame:CGRectMake(x, y, 138, 10)]; // 106 59
        _lbColor.textAlignment = NSTextAlignmentLeft;
        _lbColor.font = FONT_t7;//[UIFont systemFontOfSize:10.0f];
        _lbColor.textColor = COLOR_C6;//[UIColor colorWithHexString:@"#acacac"];
    }
    
    return _lbColor;
}

#pragma mark - 商品价格（之前价格）
- (LPLabel *)priceLP
{
    if (!_priceLP) {
        _priceLP.hidden = YES;
//        CGFloat x = self.bounds.size.width - 100 - 10;
        CGFloat y = CGRectGetMaxY(self.lbPrice.frame)+10.f;
        _priceLP = [[LPLabel alloc] initWithFrame:CGRectMake(WINDOWW - 110, y, 100, 10)];// WINDOWW - 110, 30
        _priceLP.font = FONT_t7;//[UIFont systemFontOfSize:12.0f];
        [_priceLP setTextAlignment:NSTextAlignmentRight];
        _priceLP.textColor = COLOR_C6;//[UIColor colorWithHexString:@"#acacac"];
    }
    return _priceLP;
}

#pragma mark - 商品状态
- (UILabel *)lbStockNone
{
    if (!_lbStockNone) {
        _lbStockNone.hidden = YES;
        CGFloat y = CGRectGetMaxY(self.priceLP.frame)+10;
        _lbStockNone = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 62-5, y, 62, 21)];
        _lbStockNone.font = [UIFont systemFontOfSize:11.0f];
        _lbStockNone.textColor = [UIColor colorWithHexString:@"#ff4c3e"];
        _lbStockNone.textAlignment = NSTextAlignmentRight;
    }
    
    return _lbStockNone;
}

#pragma mark - 商品个数
- (UILabel *)lbNum
{
    if (!_lbNum) {
        _lbNum.hidden = YES;
//        CGFloat x = self.bounds.size.width - 62 - 10;
        CGFloat y = CGRectGetMaxY(self.priceLP.frame);
        _lbNum = [[UILabel alloc] initWithFrame:CGRectMake(WINDOWW - 72, y, 62, 10)];
        _lbNum.font = FONT_t7;//[UIFont systemFontOfSize:11.0f];
        _lbNum.textColor = COLOR_C6;
        [_lbNum setTextAlignment:NSTextAlignmentRight];
    }
   
    return _lbNum;
}

#pragma mark - 数量选择
- (UIStepperNumberField *)goodsNum
{
    if (!_goodsNum) {
        _goodsNum.hidden = YES;
//        CGFloat scale = UI_SCREEN_WIDTH/ 375.0;
        CGFloat x = CGRectGetMaxX(self.imageGoods.frame)+10.f;
        CGFloat y = 16.f;
        _goodsNum = [[UIStepperNumberField alloc] initWithFrame:CGRectMake(x, y, 150.f, 30)];//WINDOWW - 95 49        _goodsNum.font = [UIFont systemFontOfSize:14.0f];
        [_goodsNum addTarget:self action:@selector(stepperValueChangednew:)
            forControlEvents:UIControlEventValueChanged];
        [_goodsNum addTarget:self action:@selector(textEditingDidEndnew:)
            forControlEvents:UIControlEventEditingDidEnd];
    }
   
//        _goodsNum.hidden = NO;
    return _goodsNum;
}

#pragma mark - 图片
- (UIUrlImageView *)imageGoods
{
    if (!_imageGoods) {
        _imageGoods.hidden = YES;
        CGFloat x = CGRectGetMaxX(self.btnSelectGoods.frame)+10;
        CGFloat y = (kCellH-kImgVH)/2;
        _imageGoods = [[UIUrlImageView alloc] initWithFrame:CGRectMake(x, y, kImgVH, kImgVH)];// 38 17
        _imageGoods.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageGoods;
}

#pragma mark - 选择按钮
- (UIButton *)btnSelectGoods
{
    if (!_btnSelectGoods) {
        _btnSelectGoods.hidden = YES;
        _btnSelectGoods = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x = 10.f;
        CGFloat y = (kCellH - 30)/2;
        _btnSelectGoods.frame = CGRectMake(x, y, 30, 30);// 7, 32
//        [_btnSelectGoods setImage:[UIImage imageNamed:@"Unico/uncheck_zero@2x"] forState:UIControlStateNormal];
        _btnSelectGoods.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_btnSelectGoods addTarget:self action:@selector(btnSelectGoodsClicknew:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSelectGoods;
}

#pragma mark - 向下按钮
- (UIButton *)popBtn
{
    if (!_popBtn) {
        _popBtn.hidden = YES;
        _popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x = CGRectGetMaxX(self.goodsNum.frame)-18.f;
        CGFloat y = CGRectGetMaxY(self.lbNumber.frame)+8.f;
//        _popBtn.frame = CGRectMake(x, y, 14, 14);
          _popBtn.frame = CGRectMake(x, y,20,20);
        [_popBtn addTarget:self
                    action:@selector(popBtnClicked:)
          forControlEvents:UIControlEventTouchUpInside];
     
        
        [_popBtn setImage:[UIImage imageNamed:@"icon_arrowup"]
                 forState:UIControlStateSelected];
        [_popBtn setImage:[UIImage imageNamed:@"Unico/arrow_bottom"]
                 forState:UIControlStateNormal];
//        [_popBtn setImage:[UIImage imageNamed:@"icon_arrowup"]
//                forState:UIControlStateNormal];
    }
    
    return _popBtn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGoodsData:(MyShoppingTrollyGoodsData *)data1
{
    data=data1;
    _goodsNum.maxValue=20;
    _lbName.text=data1.prodname;
    NSString *salePrice=[NSString stringWithFormat:@"%0.2f",data1.saleprice];
    //    _lbPrice.text=[NSString stringWithFormat:@"￥%0.2f",data1.saleprice];
    _lbPrice.text=[Utils getSNSRMBMoney:salePrice];
    
    _lbColor.text=[NSString stringWithFormat:@"颜色:%@ 尺码:%@",data1.colorname,data1.sizename];//@"%@; %@"
    //    _lbSum.text=[NSString stringWithFormat:@"小计: ￥%0.2f",data1.saleprice*(float)data1.number];
    _priceLP.strikeThroughEnabled = YES;
    NSString *price= [NSString stringWithFormat:@"%0.2f",data1.price];
    
    _priceLP.text =[Utils getSNSRMBMoney:price];
//    if ([salePrice floatValue]>=[price floatValue]) {
//         _priceLP.hidden=YES;
//    }
//    else
//    {
//        _priceLP.hidden=NO;
//    }
//    _priceLP.hidden = NO;

    _lbNumber.text=[NSString stringWithFormat:@"商品编号: %@",data1.productcode];
    _goodsNum.text = [NSString stringWithFormat:@"%d",data1.number];
    _goodsNum.maxValue=data1.stocknum>20?20:data1.stocknum;
    _lbNum.text = [NSString stringWithFormat:@"x%d",data1.number];
    [self downloadImage:data1.imageurl];
    _btnSelectGoods.selected=data1.selected;
    if (_btnSelectGoods.selected) {
        [_btnSelectGoods setImage:[UIImage imageNamed:@"Unico/present_uncheck"]
                         forState:UIControlStateNormal];
        
    }else{
        [_btnSelectGoods setImage:[UIImage imageNamed:@"Unico/uncheck_zero"]
                         forState:UIControlStateNormal];
        
    }
    _lbStockNone.hidden=YES;
    [self checkCellStatus];
}

-(void)checkCellStatus
{
    if (data.status!=2)
    {
        _lbStockNone.hidden=NO;
        _lbStockNone.text=@"[已下架]";
        _btnSelectGoods.enabled=NO;
        _btnSelectGoods.hidden=YES;
        _goodsNum.enabled=NO;
        _goodsNum.hidden=YES;
        _lbNum.hidden=YES;
        
        _popBtn.enabled = NO;
        _popBtn.hidden = YES;
    }
    else if (data.stocknum<=0)
    {
        _lbStockNone.hidden=NO;
        _lbStockNone.text=@"[已售罄]";
        _btnSelectGoods.enabled=NO;
        _btnSelectGoods.hidden=YES;
        _goodsNum.enabled=NO;
        _goodsNum.hidden=YES;
        _lbNum.hidden=YES;
        
        _popBtn.enabled = NO;
        _popBtn.hidden = YES;
    }
    else if (data.number>data.stocknum)
    {
        _lbStockNone.hidden=NO;
        _lbStockNone.text=@"[库存不足]";
        _btnSelectGoods.enabled=NO;
        _btnSelectGoods.hidden=YES;
        _goodsNum.enabled=YES;
        _goodsNum.hidden=NO;
        _lbNum.hidden=YES;
        
        _popBtn.enabled = NO;
        _popBtn.hidden = YES;
    }
    else
    {
        _lbStockNone.hidden=YES;
        _btnSelectGoods.enabled=YES;
        _btnSelectGoods.hidden=NO;
        _goodsNum.enabled=YES;
        _goodsNum.hidden=NO;
        _lbNum.hidden=NO;
        
        _popBtn.enabled = YES;
        _popBtn.hidden = NO;
    }

//    _lbStockNone.hidden = NO;
//    _lbStockNone.text = @"[库存不足]";
}

-(void)downloadImage:(NSString *)url
{
    NSString *defaultImg=DEFAULT_LOADING_IMAGE;//@"defaultDownload.png"
    if (_imageGoods==nil)
    {
        _imageGoods.image=[UIImage imageNamed:defaultImg];
        return;
    }
    
     _imageGoods.contentMode=UIViewContentModeScaleAspectFit;
    
//    [_imageGoods downloadImageUrl:[CommMBBusiness changeStringWithurlString:url size:SNS_IMAGE_Size] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:defaultImg];
    NSString *urlStr =[CommMBBusiness changeStringWithurlString:url size:SNS_IMAGE_Size];
    [_imageGoods sd_setImageWithURL:[NSURL URLWithString:urlStr]
                   placeholderImage:[UIImage imageNamed:defaultImg]];
}

#pragma mark - btn actions method
- (void)popBtnClicked:(UIButton *)sender
{
    if(_lbStockNone.hidden==NO)
    {
        return;
        
    }
    sender.selected = !sender.selected;
   /* sender.selected = !sender.selected;
    if (sender.isSelected) {
        [sender setImage:[UIImage imageNamed:@"icon_arrowup"]
                forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"Unico/icon_arrowdown"]
                forState:UIControlStateNormal];
    }*/
    

    if (_delegate && [_delegate respondsToSelector:@selector(popDetailViewBtnClick:btn:WithIndexPath:)]) {
        [_delegate popDetailViewBtnClick:sender btn:sender WithIndexPath:_indexPath];
    }    
}

- (void)changePopBtnStatusWithBtn:(UIButton *)btn
{
    btn.selected = NO;
    [btn setImage:[UIImage imageNamed:@"Unico/icon_arrowdown"]
            forState:UIControlStateNormal];
}

- (void)btnSelectGoodsClicknew:(id)sender{
  UIButton *btn  = sender;//_btnSelectGoods
    btn.selected=!btn.selected;
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(goodsSelectButtonClick:button:)])
    {
        [_delegate goodsSelectButtonClick:self button:sender];
    }
}
- (IBAction)btnSelectGoodsClick:(id)sender{
    _btnSelectGoods.selected=!_btnSelectGoods.selected;
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(goodsSelectButtonClick:button:)])
    {
        [_delegate goodsSelectButtonClick:self button:sender];
    }
}

- (IBAction)stepperValueChanged:(id)sender {
    return;
    _lbNum.text = [NSString stringWithFormat:@"x%d",[((UITextField*)sender).text intValue]];
    
//    int stocknum=data.stocknum;
//    if (data.status!=2)
//    {
//        _lbStockNone.hidden=NO;
//    }
//    else
//    {
//        if (stocknum<1||[_goodsNum.text intValue]>stocknum)
//        {
//            _lbStockNone.hidden=NO;
//        }
//        else
//        {
//            _lbStockNone.hidden=YES;
//        }
//    }
    
    [self checkCellStatus];
    
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(buyNumberChanged:number:)])
    {
        [_delegate buyNumberChanged:self number:[((UITextField*)sender).text intValue]];
    }
}

- (void)stepperValueChangednew:(id)sender {
    _lbNum.text = [NSString stringWithFormat:@"x%d",[((UITextField*)sender).text intValue]];
    
    //    int stocknum=data.stocknum;
    //    if (data.status!=2)
    //    {
    //        _lbStockNone.hidden=NO;
    //    }
    //    else
    //    {
    //        if (stocknum<1||[_goodsNum.text intValue]>stocknum)
    //        {
    //            _lbStockNone.hidden=NO;
    //        }
    //        else
    //        {
    //            _lbStockNone.hidden=YES;
    //        }
    //    }
    
    [self checkCellStatus];
    
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(buyNumberChanged:number:)])
    {
        [_delegate buyNumberChanged:self number:[((UITextField*)sender).text intValue]];
    }
}

- (IBAction)textEditingDidEnd:(id)sender {
    return;
    int stocknum=data.stocknum;
    
    if (stocknum<1||[_goodsNum.text intValue]>stocknum)
    {
        [Toast makeToast:@"商品的库存不足!" duration:2 position:@"center"];
        return;
    }

    
    //判断购买数量
    
    if ([_goodsNum.text intValue]>20)
    {
        [Toast makeToast:@"最多购买20件商品!" duration:2 position:@"center"];
        return;
    }
    
    if ([_goodsNum.text intValue]<=0) {
        [Toast makeToast:@"商品数量不能为修改为0!" duration:1 position:@"center"];
        return;
    }
//    [Toast makeToast:[NSString stringWithFormat:@"商品数量修改为%@!",_goodsNum.text] duration:2 position:@"center"];
    [Toast makeToastSuccess:[NSString stringWithFormat:@"商品数量修改为%@!",_goodsNum.text]];
}

- (void)textEditingDidEndnew:(id)sender {
    int stocknum=data.stocknum;
    
    if (stocknum<1||[_goodsNum.text intValue]>stocknum)
    {
        [Toast makeToast:@"商品的库存不足!" duration:2 position:@"center"];
        return;
    }
    
    //判断购买数量
    
    if ([_goodsNum.text intValue]>20)
    {
        [Toast makeToast:@"最多购买20件商品!" duration:2 position:@"center"];
        return;
    }
    
    if ([_goodsNum.text intValue]<=0) {
        [Toast makeToast:@"商品数量不能为修改为0!" duration:1 position:@"center"];
        return;
    }
    [Toast makeToastSuccess:[NSString stringWithFormat:@"商品数量修改为%@!",_goodsNum.text]];
}

@end
