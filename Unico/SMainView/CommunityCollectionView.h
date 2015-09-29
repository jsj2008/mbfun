//
//  CommunityCollectionView.h
//  Wefafa
//
//  Created by wave on 15/8/17.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCollocationDetailModel;
typedef void(^LoadDataWithType)(NSInteger userType);
/**
 *  详情页面点赞回调
 *
 *  @param model  搭配详情model
 *  @param islike 是否喜欢
 */
typedef void (^ReloadCommunityCollectionViewBlock)(SCollocationDetailModel*model, BOOL islike);

@interface CommunityCollectionView : UICollectionView
@property (nonatomic, strong) LoadDataWithType block;
@property (nonatomic) UIViewController *parentVC;

@property (nonatomic, strong) NSString *userID; //默认为nil,我的页面传参

@property (nonatomic, strong) ReloadCommunityCollectionViewBlock reloadBlock;

@end
