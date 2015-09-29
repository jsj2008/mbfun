//
//  SCollocationDetailNoneShopController.h
//  Wefafa
//
//  Created by Jiang on 8/2/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SCollocationDetailViewController.h"

@interface SCollocationDetailNoneShopController : SCollocationDetailViewController
@property (nonatomic, strong) void (^commentDidSuccessSend)(NSNumber *commentCount);
@end
