//
//  MyShoppingTrollyGoodsTableViewCell.h
//  Wefafa
//
//  Created by mac on 14-9-2.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "JASwipeCell.h"
#import "UIStepperNumberField.h"
#import "LPLabel.h"
#import "UIUrlImageView.h"
#import "PromotionGoodsInfo.h"
#import "ProdInfo.h"
#import "PlatFormBasicInfo.h"
#import "OrderActivityProductListModel.h"

//{
//    cartInfo =     {
//        "collocatioN_ID" = "";
//        "coloR_ID" = 0;
//        designerId = "";
//        designerName = "";
//        id = 78;
//        price = 0;
//        "proD_ID" = 26309;
//        qty = 1;
//        "sharE_SELLER_ID" = "";
//        "speC_ID" = 0;
//        userId = "b1866313-b3b0-41f6-abf8-22c8c0cd8105";
//    };
//    proudctList =     {
//        productInfo =         {
//            "coloR_CODE" = 50;
//            "coloR_FILE_PATH" = "http://img.51mb.com:5659/sources/BoutiqueProd/ProdColor/e048dee-9d0d-48de-a1dd-beddb7e606f10.jpg";
//            "coloR_ID" = 3249;
//            "coloR_NAME" = "\U6d45\U6c34\U7eff";
//            id = 26309;
//            "inneR_CODE" = 6910896524624;
//            "iteM_TYPE" = "PROD_CLS";
//            "lM_PROD_CLS_ID" = 793;
//            "lisT_QTY" = 3;
//            price = 299;
//            "proD_CLS_NUM" = 548084;
//            "proD_NAME" = "\U7537\U5546\U52a1\U7cbe\U81f4\U68ad\U7ec7\U957f\U88e4";
//            "proD_NUM" = 54808450132;
//            "salE_PRICE" = 100;
//            "salE_QTY" = 0;
//            "speC_CODE" = 132;
//            "speC_ID" = 5006;
//            "speC_NAME" = "175/80A";
//            status = 2;
//        };
//    };
//},


@interface PlatFormInfo : NSObject
@property(nonatomic,strong)NSString * collocation_Id;
@property(nonatomic,strong)NSString * diS_Price;
@property(nonatomic,strong)NSString * promName;
@property(nonatomic,strong)NSString * proD_ID;
@property(nonatomic,strong)NSString * platPromId;//活动ID
@property (nonatomic,strong)NSString * promGroupName;
@property(nonatomic,strong)NSString * qty;
@property(nonatomic,strong)NSString * sale_Price;
@property(nonatomic,strong)NSString * usE_COUPON_FLAG;
@property (nonatomic,strong)NSString *promotionId;//活动id
@property (nonatomic, strong)NSString *web_url;

//"collocation_Id" = 0;
//"dis_Price" = 10;
//platPromId = 4402;
//"proD_ID" = 100288;
//promGroupName = "\U5355\U54c1\U6d3b\U52a8--\U6ee12\U4ef6\U51cf20";
//promName = "\U5355\U54c1\U6d3b\U52a8";
//qty = 2;
//"sale_Price" = 249;

@end

@interface MyShoppingTrollyGoodsData : NSObject
{
    NSDictionary *_value;
    BOOL isTrolly;
}
@property (strong, nonatomic) NSDictionary *value;
@property (assign, nonatomic) BOOL selected;

@property (copy, nonatomic) NSString *lM_PROD_CLS_ID;
@property (strong, nonatomic) NSString *shoppingcartid;
@property (strong, nonatomic) NSString *colorid;
@property (strong, nonatomic) NSString *colorname;

@property (strong, nonatomic) NSString *sizeid;
@property (strong, nonatomic) NSString *sizename;

@property (strong, nonatomic) NSString *imageurl;

@property (strong, nonatomic) NSString *prodid;
@property (strong, nonatomic) NSString *prodname;
@property (strong, nonatomic) NSString *prodNum;//11位码

@property (assign, nonatomic) double price; //吊牌价
@property (assign, nonatomic) int number;//单个商品数量
@property (assign, nonatomic) double saleprice;
@property (assign, nonatomic) int listqty; //推广数量
@property (strong, nonatomic) NSString * productcode; //mb的字段类型由int 改为nsstring
//添加门店优惠后的价格
@property(strong,nonatomic) NSString * shopProdprice;
@property(strong,nonatomic) NSString * promotion_id;

@property (strong, nonatomic) NSString *shareUserId;//分享人
@property (strong, nonatomic) NSString *collocationid; //暂时未用
@property (strong, nonatomic) NSString *designerid;
@property (strong, nonatomic) NSString *designername;
@property (assign, nonatomic) int stocknum;
@property (assign, nonatomic) int status;//1编辑，2上架，3下架

@property (nonatomic,strong)PlatFormInfo *platFormInfo;//活动优惠
//@property (nonatomic,strong)ProdInfo *prodInfo;//活动优惠后的商品信息
//wwp 9.1
@property (nonatomic,strong)PlatFormBasicInfo *allPlatFormInfo; //活动优惠
@property (nonatomic,strong) OrderActivityProductListModel *prodInfo;//活动优惠后的商品信息

@property (nonatomic,strong) NSString *brandCode; //品牌code
@property(nonatomic,strong)NSString *diS_Price;//红包优惠价格

@property(strong,nonatomic)PromotionGoodsInfo *promotionGoodsInfo;//单个商品优惠信息
-(BOOL)isUsed;

#pragma mark -- 范票（红包）优惠总price
+(double)totalFanPiaoPrice:(NSArray *)dataArr;
+(double)totalPricebyPlatFormInfo:(NSArray *)dataArr;
+(double)totalPrice:(NSArray *)dataArr;
+(double)totalPriceWithshopProdprice:(NSArray *)dataArr;
+(int)count:(NSArray *)dataArr;

@end

@protocol MyShoppingTrollyGoodsClickDelegate <NSObject>

@optional
-(void)goodsSelectButtonClick:(id)sender button:(UIButton *)button;
-(void)shoppingTrollyOrderDelBtnClick:(id)sender button:(UIButton*)delButton;
-(void)buyNumberChanged:(id)sender number:(int)number;
- (void)popDetailViewBtnClick:(id)sender btn:(UIButton *)btn WithIndexPath:(NSIndexPath *)indexPath;
- (void)productDeleteBtnClick:(id)sender WithIndexPath:(NSIndexPath *)indexPath;

@end

@interface MyShoppingTrollyGoodsTableViewCell : UITableViewCell
{
    MyShoppingTrollyGoodsData *data;
}
//@property (strong, nonatomic) IBOutlet UIView *lineView;
//@property (strong, nonatomic) IBOutlet UIButton *btnSelectGoods;
//@property (strong, nonatomic) IBOutlet UIUrlImageView *imageGoods;
//@property (strong, nonatomic) IBOutlet UILabel *lbName;
//@property (strong, nonatomic) IBOutlet UILabel *lbNumber;
//@property (strong, nonatomic) IBOutlet UILabel *lbPrice;
//@property (strong, nonatomic) IBOutlet UILabel *lbSum;
//@property (strong, nonatomic) IBOutlet UILabel *lbColor;
//@property (strong, nonatomic) IBOutlet UILabel *lbStockNone;
//@property (strong, nonatomic) IBOutlet UIStepperNumberField *goodsNum;
//@property (strong, nonatomic) IBOutlet LPLabel *priceLP;
//@property (strong, nonatomic) IBOutlet UILabel *lbNum;
@property (strong, nonatomic)  NSIndexPath *indexPath;
@property (strong, nonatomic)  UIView *lineView;
@property (strong, nonatomic)  UIButton *btnSelectGoods;
@property (strong, nonatomic)  UIUrlImageView *imageGoods;

@property (strong, nonatomic)  UILabel *lbName;
@property (strong, nonatomic)  UILabel *lbNumber;
@property (strong, nonatomic)  UILabel *lbPrice;
@property (strong, nonatomic)  UILabel *lbSum;
@property (strong, nonatomic)  UILabel *lbColor;
@property (strong, nonatomic)  UILabel *lbStockNone;
@property (strong, nonatomic)  UIStepperNumberField *goodsNum;
@property (strong, nonatomic)  LPLabel *priceLP;
@property (strong, nonatomic)  UILabel *lbNum;
@property (strong, nonatomic)  UIButton *popBtn;
@property (strong, nonatomic)  UIButton *deleteButton;

- (IBAction)btnSelectGoodsClick:(id)sender;
- (IBAction)stepperValueChanged:(id)sender;
- (IBAction)textEditingDidEnd:(id)sender;

-(void)setGoodsData:(MyShoppingTrollyGoodsData *)data1;
-(void)checkCellStatus;
/** 用于改变btn状态（处理的不好） */
- (void)changePopBtnStatusWithBtn:(UIButton *)btn;
- (void)lbclolrAddpopBtn:(BOOL)isAddbtn;
@property (assign, nonatomic) id<MyShoppingTrollyGoodsClickDelegate> delegate;


@end
