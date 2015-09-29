//
//  SCollocationDetailNoShoppingViewController.h
//  Wefafa
//
//  Created by chencheng on 15/7/14.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseDetailViewController.h"

@class SActivityPromPlatModel;

//无购物功能的搭配详情
@interface SCollocationDetailNoShoppingViewController : SBaseDetailViewController

@property (nonatomic, strong) NSString *collocationId;
@property(nonatomic,strong)NSDictionary *collocationInfo;
@property (nonatomic, assign) NSString *mb_collocationId;
@property (nonatomic, strong) NSArray *promPlatModelArray;
@property (nonatomic, strong) NSString * promotion_ID;


@end
