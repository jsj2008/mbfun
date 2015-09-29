//
//  CommunityHotCollectionViewTableCell.h
//  Wefafa
//
//  Created by wave on 15/8/17.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StopicListModel;
@class StopicListContentModel;

static NSString *communityHotCollectionViewTableCellID = @"communityHotCollectionViewTableCellID";

typedef void (^ClickToTopicBlock)(StopicListModel*model);
typedef void (^ClickToCollectionBlock)(StopicListContentModel*model);

@interface CommunityHotCollectionViewTableCell : UITableViewCell
//@property (nonatomic, strong) CommunityHotCollectionModel *model;
@property (nonatomic, strong) StopicListModel *model;
@property (nonatomic, strong) ClickToTopicBlock jumpBlock;
@property (nonatomic, strong) ClickToCollectionBlock jumpToCollBlock;

- (void)setmodel:(StopicListModel*)model parentVC:(UIViewController*)target;
@end
