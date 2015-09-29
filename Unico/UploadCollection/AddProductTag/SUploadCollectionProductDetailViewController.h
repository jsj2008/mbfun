//
//  SUploadCollectionProductDetailViewController.h
//  Wefafa
//
//  Created by chencheng on 15/8/27.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"


#import "SProductTagEditeInfo.h"



/**
 *   标签风格选项
 */
typedef NS_ENUM(NSInteger, SProductType)
{
    SProductTypeUsedProduct = 0,//使用过的单品
    SProductTypeMatchingProduct,//对应的单品
    ///使用过的对应单品
    SProductTypeUsedMatchingProduct,
};

/**
 *   上传搭配时的单品详情
 */
@interface SUploadCollectionProductDetailViewController : SBaseViewController

///单品code
@property(copy, readwrite, nonatomic)NSString *productCode;

@property(assign, readwrite, nonatomic)SProductType productType;

@property(strong, readwrite, nonatomic) void(^back)(void);

@property(strong, readwrite, nonatomic) void(^didFinish)(void);

@property(strong,nonatomic)void(^didFinishWithInfo)(SProductTagEditeInfo* info);

@property(strong,nonatomic) SProductTagEditeInfo *sproductInfo;

@end
