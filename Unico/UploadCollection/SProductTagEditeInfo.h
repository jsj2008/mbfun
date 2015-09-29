//
//  SProductTagEditeInfo.h
//  Wefafa
//
//  Created by chencheng on 15/8/28.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SProductTagEditeInfo : NSObject

@property(assign, readwrite, nonatomic)int tagIndex;//标签索引 -1为新增标签 现有标签 >= 0

@property(assign, readwrite, nonatomic)CGPoint tagViewToPoint;//标签视图的指向的点(归一化的中心点)
@property(assign, readwrite, nonatomic)BOOL tagViewFlip;//标签视图是否反转
///单品价格
@property(nonatomic,copy)NSString *price;
///单品id由服务器返回
@property(copy, readwrite, nonatomic)NSString *productId;
///单品code
@property(copy, readwrite, nonatomic)NSString *productCode;
@property(copy, readwrite, nonatomic)NSString *productName;//单品名称
@property(strong, readwrite, nonatomic)UIImage *productImage;//单品快照
///单品快照URL
@property(strong, readwrite, nonatomic)NSString *productImageUrl;
@property(strong, readwrite, nonatomic)UIImage *productOriginImage;//单品快照的原图
@property(strong, readwrite, nonatomic)NSURL *productOriginVideoURL;//单品快照的原视频
@property(strong, readwrite, nonatomic)UIImage *productOriginImageBei;//单品快照的原图

@property(copy, readwrite, nonatomic)NSString *productCategoryId;//单品类别id
@property(copy, readwrite, nonatomic)NSString *productCategoryName;//单品类别名称

@property(copy, readwrite, nonatomic)NSString *productSubCategoryId;//单品子类别id
@property(copy, readwrite, nonatomic)NSString *productSubCategoryCode;//单品子类别Code
@property(copy, readwrite, nonatomic)NSString *productSubCategoryName;//单品子类别名称

@property(copy, readwrite, nonatomic)NSString *productBrandId;//单品品牌id
@property(copy, readwrite, nonatomic)NSString *productBrandCode;//单品品牌Code
@property(copy, readwrite, nonatomic)NSString *productBrandName;//单品品牌名称

@property(copy, readwrite, nonatomic)NSString *productColorId;//单品颜色id
@property(copy, readwrite, nonatomic)NSString *productColorCode;//单品颜色code
@property(copy, readwrite, nonatomic)NSString *productColorName;//单品颜色名称


@property(copy, readwrite, nonatomic)NSString *productSizeCode;//单品尺码code
@property(copy, readwrite, nonatomic)NSString *productSizeName;//单品尺码名称

/**
 *  我的商品 上传商品用到的属性
 */
@property (nonatomic, readwrite, strong) NSString *subCategoryId_;
@property (nonatomic, readwrite, strong) NSString *catageID_;
@property (nonatomic, readwrite, strong) NSString *productBrandId_;
@property (nonatomic, readwrite, strong) NSString *colorID_;


-(instancetype)initWithDictionary:(NSDictionary*)dic;

@end
