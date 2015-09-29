//
//  SMyTopicCollectionViewCell.h
//  Wefafa
//
//  Created by wave on 15/7/22.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMyTopicModel.h"

@class StopicListModel, StopicListContentModel;

@interface SMyTopicCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView        *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel            *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel            *descriptionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView   *contentCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView        *showTagImageView;

@property (strong,nonatomic) UIViewController *parentVC;

@property (nonatomic, strong) StopicListModel *contentModel;
- (IBAction)topicBtnClicked:(id)sender;

@end

@interface SMyTopicListCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) StopicListContentModel *contentModel;
@end
