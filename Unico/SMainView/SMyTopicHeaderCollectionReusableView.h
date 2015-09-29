//
//  SMyTopicHeaderCollectionReusableView.h
//  Wefafa
//
//  Created by wave on 15/7/22.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMyTopicHeadModel;

@interface SMyTopicHeaderCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) UIViewController *targer;
@property (weak, nonatomic) IBOutlet UIView *selectedButtonContentView;

@property (nonatomic, strong) SMyTopicHeadModel *model;

@end
