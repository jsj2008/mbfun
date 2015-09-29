//
//  SBrandCell.h
//  Wefafa
//
//  Created by unico on 15/5/17.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBaseTableViewCell.h"
#import "SBrandViewController.h"


@interface SBrandCell : SBaseTableViewCell
@property (strong,nonatomic) NSMutableDictionary *cellData;
@property (strong,nonatomic) SBrandViewController *parentVc;
@property (assign,nonatomic) BOOL isComeFromTopic;//判断是否来自话题进入
-(void)updateCellView;
@end

