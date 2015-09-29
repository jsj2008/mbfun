//
//  SStarStoreTableViewCell.h
//  Wefafa
//
//  Created by lizhaoxiang on 15/5/27.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SBaseTableViewCell.h"
#import "SStarStoreCellModel.h"
#import "SStarStoreViewController.h"
@class SDiscoveryFlexibleModel;

@interface SStarStoreTableViewCell : UITableViewCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)updateStarCellModel:(SStarStoreCellModel*)model andIndex:(NSIndexPath*)RankIndex;
@property(nonatomic,assign) CGFloat cellHeight;
@property (nonatomic, assign) UIViewController *parentVc;
@property (nonatomic, strong) SDiscoveryFlexibleModel *contentModel;
@property (nonatomic, assign) UIViewController *target;

@end
