//
//  STpoicDetailHeaderViewCollectionReusableView.h
//  Wefafa
//
//  Created by Mr_J on 15/9/15.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StopicDetailModel;

@protocol STopicDetailHeaderViewCollectionReusableViewDelegate <NSObject>

- (void)selectedButton:(UIButton *)sender selectedIndex:(int)index;

@end

@interface STopicDetailHeaderViewCollectionReusableView : UICollectionReusableView

@property (nonatomic, assign) id<STopicDetailHeaderViewCollectionReusableViewDelegate> delegate;
@property (nonatomic, strong) StopicDetailModel *contentModel;
@property (nonatomic, assign) UIViewController *target;

@end
