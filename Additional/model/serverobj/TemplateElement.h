//
//  TemplateElement.h
//  newdesigner
//
//  Created by Miaoz on 14/10/21.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TemplateInfo.h"
#import "DetailMapping.h"
#import "LayoutMapping.h"
//模板返回数据
@interface TemplateElement : NSObject
@property(nonatomic,strong)TemplateInfo *templateInfo;
@property(nonatomic,strong)NSMutableArray *detailMappingList;
@property(nonatomic,strong)NSMutableArray *layoutMappingList;
@end
