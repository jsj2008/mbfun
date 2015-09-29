//
//  SCollocationShowBrandTagView.h
//  Wefafa
//
//  Created by Mr_J on 15/9/8.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCollocationShowBrandTagView : UIView

@property (nonatomic, strong) SCollocationDetailModel *contentModel;
@property (nonatomic, assign) UIViewController *target;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, copy) NSString *titleName;

@end
