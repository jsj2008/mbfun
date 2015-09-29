//
//  CollocationSearchModel.h
//  Wefafa
//
//  Created by su on 15/1/27.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollocationSearchModel : NSObject
@property(nonatomic)NSInteger idNum;
@property(nonatomic)NSInteger collocationId;//搭配主表ID
@property(nonatomic)NSInteger productClsId;//商品款ID
@property(nonatomic,strong)NSString *productName;//商品名称
@property(nonatomic,strong)NSString *productCode;//商品款码
@property(nonatomic,strong)NSString *colorCode;//颜色码
@property(nonatomic,strong)NSString *colorName;//颜色名称
@property(nonatomic)CGFloat productPrice;//商品款价格
@property(nonatomic,strong)NSString *productPictureUrl;//商品图片地址
@property(nonatomic)NSInteger sourceType;//来源类型（1、商品 2、 素材）

- (id)initWithDictionary:(NSDictionary *)dict;
@end
/*
 "id": 0,
 "collocationId": 0,
 "productClsId": 0,
 "productName": "String",
 "productCode": "String",
 "colorCode": "String",
 "colorName": "String",
 "productPrice": 0,
 "productPictureUrl": "String",
 "sourceType": 0
 */