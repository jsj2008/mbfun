//
//  SMyTopicViewController.h
//  Wefafa
//
//  Created by wave on 15/7/20.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"

typedef void(^refreshHeadView)();

@interface SMyTopicViewController : SBaseViewController

@property (nonatomic, strong) refreshHeadView block;

@end
