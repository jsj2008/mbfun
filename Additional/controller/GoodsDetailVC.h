//
//  GoodsDetailVC.h
//  Wefafa
//
//  Created by Miaoz on 15/3/26.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class GoodObj;
@interface GoodsDetailVC : BaseViewController
@property(nonatomic,strong)GoodObj *goodObj;
- (IBAction)addDataSourceClick:(id)sender;

@end
