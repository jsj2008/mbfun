//
//  SCollocationShowTagView.h
//  Wefafa
//
//  Created by unico_0 on 7/24/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCollocationDetailModel;

@interface SCollocationShowTagView : UIView

@property (nonatomic, strong) SCollocationDetailModel *contentModel;
@property (nonatomic, assign) UIViewController *target;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, copy) NSString *titleName;

@end
