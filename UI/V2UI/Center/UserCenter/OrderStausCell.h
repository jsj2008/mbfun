//
//  OrderStausCell.h
//  Designer
//
//  Created by Juvid on 15/1/22.
//  Copyright (c) 2015年 banggo. All rights reserved.
//
typedef NS_ENUM(NSUInteger, OrderStatus) {
    OrderStatusAll,
    OrderStatus1,
    OrderStatus2,
    OrderStatus3,
    OrderStatus4,
    OrderStatus5,
};
#import <UIKit/UIKit.h>
#import "BasicCell.h"
@protocol OrderStausCellDelete <NSObject>
@optional
-(void)checkOrderOfOrderStatus:(OrderStatus)status;
- (IBAction)PressOrder:(id)sender;
@end


@interface OrderStausCell : BasicCell
@property(nonatomic,weak)id <OrderStausCellDelete> mDelegate;
- (IBAction)checkOrder:(UIButton *)sender ;
@end
