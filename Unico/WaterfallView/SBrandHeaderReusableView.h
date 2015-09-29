//
//  SBrandHeaderReusableView.h
//  Wefafa
//
//  Created by unico_0 on 6/13/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SBrandHeaderReusableView,SBrandStoryDetailModel, SBrandStoryUserModel;

@protocol SBrandHeaderReusableViewDelegate <NSObject>

- (void)brandHeader:(SBrandHeaderReusableView *)headerView likeButton:(UIButton*)button;
-(void)brandHeader:(SBrandHeaderReusableView *)headerView moreButton:(UIButton *)button;

@end

@interface SBrandHeaderReusableView : UICollectionReusableView

@property (nonatomic, assign) id<SBrandHeaderReusableViewDelegate> delegate;
@property (nonatomic, assign) UIViewController *jumpController;
@property (nonatomic, strong) SBrandStoryDetailModel *contentModel;
@property (weak, nonatomic) IBOutlet UIView *selectedButtonContentView;

@end

@interface SBrandHeaderCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) SBrandStoryUserModel *contentModel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *head_V_View;

@end
