//
//  STopicListTableViewCell.h
//  Wefafa
//
//  Created by unico_0 on 6/1/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STopicViewController.h"
@class StopicListModel, StopicListContentModel;
@protocol STopicListTableViewCellDelegate <NSObject>

- (void)topicTouchNextAction:(UIButton *)button contentModel:(StopicListModel*)model;

@end

@interface STopicListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *showTagImageView;
@property (strong,nonatomic) UIViewController *parentVC;
@property (nonatomic, assign) id<STopicListTableViewCellDelegate> delegate;
@property (nonatomic, strong) StopicListModel *contentModel;

@end

@interface STopicListShowImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) StopicListContentModel *contentModel;

@end