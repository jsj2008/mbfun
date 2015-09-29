//
//  DetailMapping.h
//  newdesigner
//
//  Created by Miaoz on 14/10/20.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "collocationId" : 3,
 "productClsId" : 875,
 "id" : 4,
 "productCode" : "593779",
 "productName" : "MCK女童新基本轻薄羽绒服【冬装新品】",
 "colorCode" : "0",
 "productPictureUrl" : "http:\/\/10.100.20.22\/sources\/BoutiqueProd\/ProdCls\/33a9a66-08e4-44f7-a6d6-909e7cb5e7fd0.jpg",
 "sourceType" : 1,
 "productPrice" : 499,
 "colorName" : "无色"
 }
*/
@interface DetailMapping : NSObject
@property(nonatomic,strong)NSString * id;
@property(nonatomic,strong)NSString * collocationId;
@property(nonatomic,strong)NSString * productClsId;
@property(nonatomic,strong)NSString * productName;
@property(nonatomic,strong)NSString * productCode;
@property(nonatomic,strong)NSString * colorCode;
@property(nonatomic,strong)NSString * colorName;
@property(nonatomic,strong)NSString * productPrice;
@property(nonatomic,strong)NSString * productPictureUrl;
@property(nonatomic,strong)NSString *sourceType;//标示2是素材 1是商品
//自己定义
@property(nonatomic,strong)NSString *shearPicUrl;//裁剪过后url

//模板返回数据时
@property(nonatomic,strong)NSString *moduleId;
@end
