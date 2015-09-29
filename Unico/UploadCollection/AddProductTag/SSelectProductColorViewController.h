//
//  SSelectProductColorViewController.h
//  Wefafa
//
//  Created by chencheng on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"

@interface SSelectProductColorViewController : SBaseViewController


@property(strong, readwrite, nonatomic) void(^back)(void);

@property(strong, readwrite, nonatomic) void(^didFinishColor)(NSString *colorId, NSString *colorCode, NSString *colorName);

//颜色数组
@property (nonatomic, strong) NSArray *colorAry;
@end
