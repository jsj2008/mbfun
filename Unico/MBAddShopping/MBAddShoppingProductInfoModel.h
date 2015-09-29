//
//  MBAddShoppingProductInfoModel.h
//  Wefafa
//
//  Created by su on 15/5/15.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBAddShoppingProductInfoModel : NSObject

@property (nonatomic, strong) NSNumber *branD_ID;               //商标ID
@property (nonatomic, strong) NSNumber *coloR_CODE;
@property (nonatomic, strong) NSNumber *coloR_ID;               //颜色ID
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *inneR_CODE;
@property (nonatomic, strong) NSNumber *iteM_TYPE;
@property (nonatomic, strong) NSNumber *lM_PROD_CLS_ID;
@property (nonatomic, strong) NSNumber *lisT_QTY;               //库存数
@property (nonatomic, strong) NSNumber *price;                  //标价
@property (nonatomic, strong) NSNumber *proD_CLS_NUM;           //商品ID  商品唯一码
@property (nonatomic, strong) NSNumber *proD_NUM;
@property (nonatomic, strong) NSNumber *salE_PRICE;             //售价
@property (nonatomic, strong) NSNumber *salE_QTY;
@property (nonatomic, strong) NSNumber *speC_CODE;
@property (nonatomic, strong) NSNumber *speC_ID;                //尺寸ID
@property (nonatomic, strong) NSNumber *status;                 //状态吗   status ＝ 2 有效
            
@property (nonatomic, copy) NSString *coloR_FILE_PATH;
@property (nonatomic, copy) NSString *coloR_NAME;               //颜色名称
@property (nonatomic, copy) NSString *proD_NAME;                //商品名称
@property (nonatomic, copy) NSString *speC_NAME;                //尺寸信息
@property (nonatomic, copy) NSString *barcode_sys_code;
@property (nonatomic, copy) NSString *saveCustomSelectSpeC_NAME;  //保存用户选择的尺寸ID

@property (nonatomic, strong) NSNumber *isColorSelected;        //是否选择此产品颜色
@property (nonatomic, strong) NSNumber *isSizeSelected;         //是否选择次产品尺寸

@property (nonatomic, strong) NSNumber *goodnumber;               //购物数量
//@property (nonatomic, strong) NSNumber *isSelectedProduct;       //是否为已选择商品  cell重用还原数据用
@property (nonatomic, strong) NSNumber *isSelectedCurrent;        //是否为购买选中的商品 商品前面的黄色圆圈
@property (nonatomic, strong) NSNumber *isSelectProduct;          //是否为选中的商品 对应颜色和尺寸的商品
@property (nonatomic, strong) NSDictionary *dictionaryValue;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray *)modelArrayForDataArray:(NSArray*)dataArray;

@end
