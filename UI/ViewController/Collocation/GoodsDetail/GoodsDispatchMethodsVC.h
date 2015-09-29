//
//  GoodsDispatchMethodsVC.h
//  Wefafa
//
//  Created by Miaoz on 15/2/6.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GoodsDispatchMethodsVCSourceVoBlock) (id sender);

@interface GoodsDispatchMethodsVC :SBaseViewController /*UIViewController*/
@property(strong,nonatomic)NSString *selectStr;//选择的
@property(strong,nonatomic)GoodsDispatchMethodsVCSourceVoBlock myblock;

-(void)goodsDispatchMethodsVCSourceVoBlock:(GoodsDispatchMethodsVCSourceVoBlock) block;
@end
