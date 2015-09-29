//
//  SSelectProductSizeViewController.h
//  Wefafa
//
//  Created by Funwear on 15/9/8.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SSelectProductSizeViewController :SBaseViewController


@property(strong, readwrite, nonatomic) void(^back)(void);

@property(strong, readwrite, nonatomic) void(^didFinishColor)(NSString *sizeCode,NSString *sizeName);

//尺码数组
@property (nonatomic, strong) NSArray *sizeAry;
@end
