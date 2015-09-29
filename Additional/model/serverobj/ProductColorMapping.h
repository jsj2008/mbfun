//
//  ProductColorMapping.h
//  newdesigner
//
//  Created by Miaoz on 14/10/27.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
{"id":3466,"lM_PROD_CLS_ID":875,"code":"0","name":"无色","value":"#"}
 */
@interface ProductColorMapping : NSObject
@property(nonatomic,strong)NSString * id;
@property(nonatomic,strong)NSString * lM_PROD_CLS_ID;
@property(nonatomic,strong)NSString * code;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * value;
@end
