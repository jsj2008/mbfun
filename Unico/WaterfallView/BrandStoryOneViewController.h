//
//  BrandStoryOneViewController.h
//  Wefafa
//
//  Created by 凯 张 on 15/5/22.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBaseDetailViewController.h"
@interface BrandStoryOneViewController : SBaseDetailViewController

@property (nonatomic) NSMutableDictionary *listDict;
@property (nonatomic) NSArray *collocationAry;
@property (nonatomic) NSArray *itemAry;
@property (nonatomic,strong) NSString * brandId;

@end
