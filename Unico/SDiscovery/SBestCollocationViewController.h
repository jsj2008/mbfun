//
//  SBestCollocationViewController.h
//  Wefafa
//
//  Created by 凯 张 on 15/5/31.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBaseDetailViewController.h"
@interface SBestCollocationViewController : SBaseDetailViewController<UIScrollViewDelegate>
@property (nonatomic) NSDictionary *listDict;
@property (nonatomic) NSArray *collocationData;

@end