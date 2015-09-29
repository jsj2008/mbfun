//
//  GoodsInvoiceViewController.h
//  Wefafa
//
//  Created by Miaoz on 14/12/12.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^GoodsInvoiceVCSourceVoBlock) (id sender);

@interface GoodsInvoiceViewController :SBaseViewController /*UIViewController*/
@property(strong,nonatomic)GoodsInvoiceVCSourceVoBlock myblock;
@property(strong,nonatomic)NSString *selectStr;//选择的
-(void)goodsInvoiceVCSourceVoBlock:(GoodsInvoiceVCSourceVoBlock) block;

@end
