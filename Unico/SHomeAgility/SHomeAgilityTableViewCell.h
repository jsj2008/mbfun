//
//  SHomeAgilityTableViewCell.h
//  Wefafa
//
//  Created by unico_0 on 7/9/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHomeAgilityModel;

@interface SHomeAgilityTableViewCell : UITableViewCell

@property (nonatomic, strong) SHomeAgilityModel *contentModel;
@property (nonatomic, assign) UIViewController *target;

@end
