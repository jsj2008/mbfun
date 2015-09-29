//
//  BrandDetailHeaderViewCollectionReusableView.h
//  Wefafa
//
//  Created by wave on 15/8/3.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BrandDetailHeaderViewCollectionReusableView, SBrandStoryDetailModel, SBrandStoryUserModel;

@protocol BrandHeaderReusableViewDelegate <NSObject>
- (void)brandHeader:(BrandDetailHeaderViewCollectionReusableView *)headerView likeButton:(UIButton*)button;
-(void)brandHeader:(BrandDetailHeaderViewCollectionReusableView *)headerView moreButton:(UIButton *)button;
-(void)brandHeaderGotoStoryDetailVC:(BrandDetailHeaderViewCollectionReusableView *)headerView;
-(void)brandHeaderGotoBrandDaily:(BrandDetailHeaderViewCollectionReusableView *)headerView;
@end

@interface BrandDetailHeaderViewCollectionReusableView : UICollectionReusableView
@property (nonatomic, assign) id<BrandHeaderReusableViewDelegate> delegate;
@property (nonatomic, assign) UIViewController *jumpController;
@property (nonatomic, strong) SBrandStoryDetailModel *contentModel;
@property (weak, nonatomic) IBOutlet UIView *selectedButtonContentView;
@end
