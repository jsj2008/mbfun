//
//  CommunityAttentionTableView.h
//  Wefafa
//
//  Created by wave on 15/8/17.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  评价框刷新数据block
 *
 *  @param indexPath cell‘s NSIndexPath
 */
typedef void (^reloadDataBlock)(NSInteger integer);
/**
 *  个人详情页面对达人关注状态修改，社区页面推荐达人状态同步block
 */
typedef void (^CommunityAttentionTableViewMasterViewCellDidChangeStateBlock)(BOOL isConcerned);

@interface CommunityAttentionTableView : UITableView
@property (nonatomic) UIViewController *parentVC;

@property (nonatomic, strong) reloadDataBlock reloadDataBlock;
@property (nonatomic, strong) CommunityAttentionTableViewMasterViewCellDidChangeStateBlock masterCellReloadBlock;
@end
