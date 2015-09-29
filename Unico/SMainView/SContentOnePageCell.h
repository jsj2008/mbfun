//
//  SContentOnePageCell.h
//  Wefafa
//
//  Created by unico on 15/5/16.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SBaseTableViewCell.h"
#import "SMainViewController.h"
#import "SMineViewController.h"
#import "Toast.h"
#import "SMDataModel.h"

#import "CoverStickerView.h"
@class SContentOnePageCell;
typedef void (^contentOnePageCellLikeAnimation)(SContentOnePageCell*cell, BOOL islike);

@protocol kMainViewCellDelegate <NSObject>

@optional
- (void)kMainViewCellDeleteCellAtIndex:(NSInteger)indexCell;
- (void)kMainViewCellUploadCellAtIndex:(NSInteger)indexCell cellData:(NSMutableDictionary *)dict;

@end

@interface SContentOnePageCell : SBaseTableViewCell
@property (nonatomic) BOOL noImage;
@property (nonatomic) BOOL isMine;
@property (nonatomic) NSMutableDictionary *cellData;
@property(nonatomic, weak)id<kMainViewCellDelegate>delegate;
@property (nonatomic, weak) UIViewController *parentVc;
@property (nonatomic, strong) UIView *p_likePeopleView;

@property (nonatomic, strong) contentOnePageCellLikeAnimation likeAnimationBlock;
/**
 *  评论方法实现代码
 */
@property (nonatomic ,strong) void (^commentBTnClicked)(SMDataModel* dataModel, NSInteger index);

@property (nonatomic, strong) void (^isLikeBlock)(BOOL isLike);

-(void)updateCellUI:(NSInteger)index;
-(void)updateCellUIWithModel:(SMDataModel *)model atIndex:(NSInteger)index;
-(void)removeVideo;
@end
