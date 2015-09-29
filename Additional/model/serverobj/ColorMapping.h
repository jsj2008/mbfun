//
//  ColorMapping.h
//  newdesigner
//
//  Created by Miaoz on 14/10/23.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
/*{
 "id" : 24,
 "coloR_NAME" : "黑色",
 "coloR_VALUE" : "000000",
 "coloR_CODE" : "24"
 }*/
@interface ColorMapping : NSObject
@property(nonatomic,strong)NSString * id;
@property(nonatomic,strong)NSString * coloR_NAME;
@property(nonatomic,strong)NSString * coloR_VALUE;
@property(nonatomic,strong)NSString * coloR_CODE;

@end
