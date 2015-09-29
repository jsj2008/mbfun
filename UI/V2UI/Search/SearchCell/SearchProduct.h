//
//  SearchProduct.h
//  Wefafa
//
//  Created by su on 15/2/4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchProduct : NSObject
@property(nonatomic)NSInteger idNum;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *brand;
@property(nonatomic)CGFloat price;
@property(nonatomic,strong)NSString *saleAttribute;
@property(nonatomic,strong)NSString *descriptionStr;
@property(nonatomic,strong)NSString *remark;
@property(nonatomic,strong)NSString *marketTime;
@property(nonatomic)NSInteger productYear;
@property(nonatomic,strong)NSString *mainImageUrl;
@property(nonatomic,strong)NSDictionary *resultDict;
@property(nonatomic,assign)NSInteger favortieCount;

- (id)initWithProductInfo:(NSDictionary *)info;
@end

/*
 "productClsInfo": {
 "id": 0,
 "code": "String",
 "name": "String",
 "brand": "String",
 "price": 0,
 "saleAttribute": "String",
 "description": "String",
 "remark": "String",
 "marketTime": "/Date(-62135596800000-0000)/",
 "productYear": 0,
 "mainImageUrl": "String",
 "season": {
 "seasonCode": "String",
 "seasonName": "String"
 },
 "source": {
 "sourceCode": "String",
 "sourceName": "String"
 },
 "categories": [
 {
 "categoryId": 0,
 "categoryCode": "String",
 "categoryName": "String"
 }
 ],
 "colors": [
 {
 "colorId": 0,
 "colorCode": "String",
 "colorName": "String"
 }
 ],
 "specs": [
 {
 "specId": 0,
 "specCode": "String",
 "specName": "String"
 }
 ]
 }
 */