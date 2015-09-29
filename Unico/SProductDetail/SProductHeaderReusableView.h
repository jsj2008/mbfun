//
//  SProductHeaderReusableView.h
//  Wefafa
//
//  Created by unico_0 on 7/21/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SProductDetailModel, SProductHeaderReusableView;

typedef void(^SimilarDataBlock)(NSArray *dataArr);
typedef void(^CollocationDataBlock)(NSArray *dataArr);

@protocol SProductHeaderReusableViewDelegate <NSObject>

- (void)productHeaderOprationActivityList;

- (void)productHeaderPushToSizeViewWithParameter:(id)parameter;
- (void)productHeaderPUshToCommmentViewWithParamete:(id)parameter;

- (void)similarFootRefreshWithDataBlock:(SimilarDataBlock)similarData;
- (void)collocationFootRefreshWithDataBlock:(CollocationDataBlock)collocationData;

@end

@interface SProductHeaderReusableView : UICollectionReusableView

@property (nonatomic, assign) id<SProductHeaderReusableViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *selectedContentView;       // select view header view
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;   // scroll view
@property (weak, nonatomic) IBOutlet UIView *funwearCommitmentView;     // 服务承诺
@property (weak, nonatomic) IBOutlet UIView *activityContentView;       // 优惠劵，包邮活动
@property (weak, nonatomic) IBOutlet UIView *brandContentView;          // 品牌馆

//--------------------
@property (nonatomic, strong) SProductDetailModel *contentModel;
@property (nonatomic, assign) UIViewController *target;

@property (nonatomic, strong) NSArray *smiilartyArr;
@property (nonatomic, strong) NSArray *collocationArr;

@end
