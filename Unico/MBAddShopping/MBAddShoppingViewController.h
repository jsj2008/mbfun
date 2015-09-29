//
//  MBAddShoppingViewController.h
//  Wefafa
//
//  Created by Jiang on 5/13/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SBaseViewController.h"
@class MBGoodsDetailsModel, MBCollocationDetailModel;

typedef enum : NSUInteger {
    typeBuyNow = 0,     //立即购买
    typeAddShopping
} SHowType;

@interface MBAddShoppingViewController : SBaseViewController

@property (nonatomic, assign) SHowType showType;

@property (nonatomic, strong) MBGoodsDetailsModel *contentModel;
@property (nonatomic, strong) MBCollocationDetailModel *collocationModel;
@property (nonatomic, strong) NSString *collocationID;      //路广 搭配id
@property (nonatomic, strong) NSString *mbCollocationID;    //黄波 soa搭配id
@property (nonatomic, strong) NSString * promotion_ID;      //促销活动 id
@property (nonatomic, copy) NSString *productID;            //
@property (nonatomic,strong)  NSDictionary *collocationInfoDic;
//@property (nonatomic, strong) NSArray *productIdsArray;//来自jsweb单品选择
@property (nonatomic, copy) NSString *shareUser_ID;
@property (nonatomic, copy) NSString *fromControllerName;

@property (nonatomic, assign) BOOL isBuyNow;
//放NSNumber类型的数组
@property (nonatomic, strong) NSArray *itemAry;

@end
