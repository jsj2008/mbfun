//
//  SMBCouponActivityVC.h
//  Wefafa
//
//  Created by Miaoz on 15/6/4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlatFormBasicInfo.h"
typedef void (^SMBCouponActivityVCSelected)(id sender);
@interface SMBCouponActivityVC : SBaseViewController
@property (nonatomic, copy) SMBCouponActivityVCSelected didSelectedEnter;
@property (nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)PlatFormBasicInfo *selectPlatFormBasicInfo;
@end
