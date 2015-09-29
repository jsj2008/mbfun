//
//  PromPlatComDtlInfo.h
//  Wefafa
//
//  Created by Miaoz on 15/6/6.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "remark" : "",
 "commissioN_VALUE" : 30,
 "id" : 404,
 "colL_FLAG" : "0",
 "commissioN_TYPE" : "FIX",
 "standards" : 4,
 "isUse" : false,
 "name" : "test",
 "promotioN_FLAT_ID" : 803
 }
 */
@interface PromPlatComDtlInfo : NSObject
@property(nonatomic,strong)NSString * remark;
@property(nonatomic,strong)NSNumber * commissioN_VALUE;
@property(nonatomic,strong)NSNumber * id;
@property(nonatomic,strong)NSNumber * colL_FLAG;
@property(nonatomic,strong)NSString * commissioN_TYPE;
@property(nonatomic,strong)NSNumber * standards;
@property(nonatomic,strong)NSNumber * isUse;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSNumber * promotioN_FLAT_ID;
@end
