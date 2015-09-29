//
//  SCategoryInfo.h
//  Wefafa
//
//  Created by chencheng on 15/8/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCategoryInfo : NSObject


@property(copy, readwrite, nonatomic)NSString *categoryId;
@property(copy, readwrite, nonatomic)NSString *categoryCode;
@property(copy, readwrite, nonatomic)NSString *categoryName;//比如男装

///子目录
@property(strong,nonatomic)NSMutableArray *subArray;


@end
