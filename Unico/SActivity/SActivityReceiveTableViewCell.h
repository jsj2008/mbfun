//
//  SActivityReceiveTableViewCell.h
//  Wefafa
//
//  Created by unico_0 on 6/9/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SActivityReceiveModel;
@class SActivityVouchersListModel;

@protocol SActivityReceiveTableViewCellDelegate <NSObject>

- (void)activityReceiveFanButton:(UIButton *)button model:(SActivityVouchersListModel*)model;

@end

@interface SActivityReceiveTableViewCell : UITableViewCell

@property (nonatomic, assign) id<SActivityReceiveTableViewCellDelegate> delegate;
//@property (nonatomic, strong) SActivityReceiveModel *contentModel;
@property (nonatomic, strong) SActivityVouchersListModel *contentModel;
@end
