//
//  PriceMapping.h
//  newdesigner
//
//  Created by Miaoz on 14/10/27.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
/*{
 "code" : "05",
 "id" : 5,
 "name" : "1000元以上",
 "min_Price" : 0,
 "max_Price" : 0
 }*/
@interface PriceMapping : NSObject
@property(nonatomic,strong)NSString * id;
@property(nonatomic,strong)NSString * code;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * min_Price;
@property(nonatomic,strong)NSString * max_Price;
@end
