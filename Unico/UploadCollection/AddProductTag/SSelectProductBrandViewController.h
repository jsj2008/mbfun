//
//  SSelectProductBrandViewController.h
//  Wefafa
//
//  Created by chencheng on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"

//选择品牌
@interface SSelectProductBrandViewController : SBaseViewController


@property(strong, readwrite, nonatomic) void(^back)(void);

///如果是自定义品牌，回传的brandId,brandCode为@""
@property(strong, readwrite, nonatomic) void(^didFinishBrand)(NSString *brandId,NSString *brandCode,NSString *brandName);

//品牌数组
@property (nonatomic, strong) NSArray *brandAry;
@end
