//
//  TopicMapping.h
//  newdesigner
//
//  Created by Miaoz on 14-10-11.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "id": 11,
 "code": "100011",
 "name": "男"
 },
 */
@interface TopicMapping : NSObject
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *code;
@end
