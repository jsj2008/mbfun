//
//  BrandDetailCollectionViewCell.h
//  Wefafa
//
//  Created by wave on 15/8/4.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SBaseTableViewCell.h"
#import "SMainViewController.h"
#import "SMineViewController.h"
#import "Toast.h"
#import "SMDataModel.h"

#import "CoverStickerView.h"
@class SearchCollocationInfo;
@protocol BrandDetailCollectionViewCellDelegate <NSObject>
- (void)kMainViewCellDeleteCellAtIndex:(NSInteger)indexCell;
- (void)kMainViewCellUploadCellAtIndex:(NSInteger)indexCell cellData:(NSMutableDictionary *)dict;
@end


@interface BrandDetailCollectionViewCell : UICollectionViewCell
@property (nonatomic) BOOL noImage;
@property (nonatomic) NSMutableDictionary *cellData;
@property(nonatomic, weak)id<BrandDetailCollectionViewCellDelegate>delegate;
@property (nonatomic, weak) UIViewController *parentVc;

//标准的cell高度
@property  (nonatomic) float cellHeight;
//有变化的cell高度，图片，文字等变化
@property (nonatomic) float cellAdditionalHeight;
//选择的index
@property (nonatomic) NSInteger cellIndex;
-(void)updateCellUI:(NSInteger)index;
-(void)updateCellUIWithModel:(SMDataModel *)model atIndex:(NSInteger)index;
-(void)removeVideo;
@end
