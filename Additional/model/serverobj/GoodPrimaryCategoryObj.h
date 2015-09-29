//
//  PrimaryCategoryObj.h
//  newdesigner
//
//  Created by Miaoz on 14-9-30.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
/*{
    "parentId" : 0,
    "id" : 2,
    "code" : "12",
    "flag" : 1,
    "child" : [
               {
                   "flag" : 1,
                   "id" : 4,
                   "code" : "帽子",
                   "parentId" : 2,
                   "name" : "帽子",
                   "url" : "23"
               }
               ],
    "name" : "配饰",
    "url" : "23"
}*/
@interface GoodPrimaryCategoryObj : NSObject
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *parentId;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *flag;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSArray *child;

@property(nonatomic,strong)NSMutableArray *secondcategoryArray;
@end
