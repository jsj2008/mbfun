//
//  ProdInfo.h
//  Wefafa
//
//  Created by Miaoz on 15/6/6.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "prodId" : 1065,
 "sale_Price" : 100,
 "collocation_Id" : 0,
 "prodClsCode" : "223191",
 "brandCode" : "MB",
 "diS_Price" : 0,
 "prodClsId" : 52,
 "qty" : 10
 }
 */
@interface ProdInfo : NSObject
@property(nonatomic,strong)NSString * prodId;
@property(nonatomic,strong)NSString * sale_Price;
@property(nonatomic,strong)NSString * collocation_Id;
@property(nonatomic,strong)NSString * prodClsCode;
@property(nonatomic,strong)NSString * brandCode;
@property(nonatomic,strong)NSString * diS_Price;
@property(nonatomic,strong)NSString * prodClsId;
@property(nonatomic,strong)NSString * qty;


@end
