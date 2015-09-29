//
//  SSelectBodyTypeViewController.h
//  Wefafa
//
//  Created by shenpu on 15/8/26.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"
///选择体型
@interface SSelectBodyTypeViewController : SBaseViewController

@property(strong, readwrite, nonatomic) void(^didFinishBrand)(NSInteger index);
@property(assign,nonatomic) NSInteger selectType;
@end
