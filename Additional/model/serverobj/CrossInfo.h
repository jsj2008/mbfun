//
//  CrossInfo.h
//  Wefafa
//
//  Created by Miaoz on 15/4/20.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
"crossInfo" : {
    "y" : 100,
    "p" : "$blank_{"w":200,"h":200}.png",
    "w" : 200,
    "x" : 82,
    "iw" : 162
}
 */
@interface CrossInfo : NSObject
@property(nonatomic,strong)NSString * x;
@property(nonatomic,strong)NSString * y;
@property(nonatomic,strong)NSString * w;
@property(nonatomic,strong)NSString * iw;
@property(nonatomic,strong)NSString * p;
@end
