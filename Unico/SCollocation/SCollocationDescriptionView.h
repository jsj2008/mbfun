//
//  SCollocationDescriptionView.h
//  Wefafa
//
//  Created by unico_0 on 7/24/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCollocationDetailModel;

@interface SCollocationDescriptionView : UIView

@property (nonatomic, strong) SCollocationDetailModel *contentModel;
@property (nonatomic, assign) UIViewController *target;
@property (nonatomic, copy) NSString *contentString;

@end
