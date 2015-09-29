//
//  GoodCategoryElement.h
//  newdesigner
//
//  Created by Miaoz on 14/10/29.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodCategoryObj.h"
@interface GoodCategoryElement : NSObject
@property(nonatomic,strong)GoodCategoryObj *firstCategoryObj;//一级分类
@property(nonatomic,strong)NSMutableArray *subCategoryarray;//二级分类

@end
