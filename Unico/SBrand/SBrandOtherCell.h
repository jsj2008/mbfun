//
//  SBrandOtherCell.h
//  Wefafa
//
//  Created by metesbonweios on 15/8/5.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseTableViewCell.h"
#import "SBrandViewController.h"

@interface SBrandOtherCell : SBaseTableViewCell
@property (strong,nonatomic) NSMutableDictionary *cellData;
@property (strong,nonatomic) SBrandViewController *parentVc;
@property (assign,nonatomic) BOOL isComeFromTopic;//判断是否来自话题进入
-(void)updateCellView;
@end
