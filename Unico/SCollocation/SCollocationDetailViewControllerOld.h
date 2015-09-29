//
//  SCollocationDetailViewController.h
//  Wefafa
//
//  Created by unico on 15/5/14.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBaseDetailViewController.h"
@class SActivityPromPlatModel;

@interface SCollocationDetailViewControllerOld : SBaseDetailViewController

@property (nonatomic, strong) NSString* collocationId;
@property(nonatomic,strong)NSDictionary *collocationInfo;
@property (nonatomic, strong) NSString *mb_collocationId;
@property (nonatomic, strong) NSArray *promPlatModelArray;
@property (nonatomic, strong) NSString * promotion_ID;

@end
