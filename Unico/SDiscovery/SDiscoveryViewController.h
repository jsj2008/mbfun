//
//  SDiscoveryViewController.h
//  Wefafa
//
//  Created by unico on 15/5/17.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBaseDetailViewController.h"

@interface SDiscoveryViewController : SBaseDetailViewController

@property (nonatomic) NSDictionary *listDict;
@property (nonatomic) NSArray *collocationData;

@property (nonatomic, assign) int messCount;

- (void)scrollToTop;
- (void)initnotificationcenter;

@end
