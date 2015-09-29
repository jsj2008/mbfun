//
//  BrandMapping.h
//  newdesigner
//
//  Created by Miaoz on 14/10/24.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
/* {
 "id" : 4,
 "branD_CODE" : "AMPM",
 "branD_NAME" : "AMPM"
 }*/
@interface BrandMapping : NSObject
@property(nonatomic,strong)NSString * id;
@property(nonatomic,strong)NSString * branD_CODE;
@property(nonatomic,strong)NSString * branD_NAME;

@end
