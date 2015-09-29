//
//  GoodSecondCategoryObj.h
//  newdesigner
//
//  Created by Miaoz on 14-9-30.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
/*{
    "flag" : 1,
    "id" : 4,
    "code" : "帽子",
    "parentId" : 2,
    "name" : "帽子",
    "url" : "23"
}
*/
@interface GoodSecondCategoryObj : NSObject
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *parentId;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *flag;

@end
