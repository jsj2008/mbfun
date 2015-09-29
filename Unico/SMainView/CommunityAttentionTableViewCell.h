//
//  CommunityAttentionTableViewCell.h
//  Wefafa
//
//  Created by wave on 15/8/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *communityAttentionTableViewCellID = @"communityAttentionTableViewCellID";
@class CommunityAttentionMasterModel;

typedef void(^CommunityAttentionTableViewCellModelDidChanged)(BOOL isConcerned);

@interface CommunityAttentionTableViewCell : UITableViewCell
@property (nonatomic, strong) CommunityAttentionMasterModel *model;
@property (nonatomic, strong) CommunityAttentionTableViewCellModelDidChanged modelDidChangedBlock;
@end
