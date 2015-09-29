//
//  OrderGoodsListViewController.h
//  Wefafa
//
//  Created by Miaoz on 15/2/6.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderGoodsListViewController : SBaseViewController /*UIViewController*/
//以下必须调用者Controller传入
@property (strong, nonatomic) NSMutableArray *goodsArray; //订单商品
@property (strong, nonatomic) NSDictionary *sumInfo; //订单合计信息
@end
