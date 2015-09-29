//
//  MBMyGoodsContentTableViewCell.h
//  Wefafa
//
//  Created by Jiang on 4/7/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBOtherUserInfoModel;

@protocol MBOtherUserInfoModelDelegate <NSObject>

- (void)attentionButtonAction:(UIButton*)button model:(MBOtherUserInfoModel*)model ;

@end

@interface MBMyGoodsContentTableViewCell : UICollectionViewCell

@property (nonatomic, assign) id<MBOtherUserInfoModelDelegate> delegate;

@property (nonatomic, strong) MBOtherUserInfoModel *model;

@end
