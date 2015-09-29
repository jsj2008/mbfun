//
//  MBAddShoppingContentTableViewCell.h
//  Wefafa
//
//  Created by unico_0 on 15/5/24.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBAddShoppingProductNumberView.h"
#import "MBAddShoppingProductInfoModel.h"

#import "MBAddShoppingColorView.h"
#import "MBAddShoppingSizeView.h"
@class MBGoodsDetailsModel;

@protocol MBAddShoppingContentTableViewCellDelegate <NSObject>

- (void)shoppingContentTableCellSelectedModul:(MBAddShoppingProductInfoModel *)modul Button:(UIButton *)sender;

@end

@interface MBAddShoppingContentTableViewCell : UITableViewCell

@property (nonatomic, assign) id <MBAddShoppingContentTableViewCellDelegate> delegate;
@property (nonatomic, strong) MBGoodsDetailsModel *contentModel;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSArray *showProductArray;    //显示商品数据用数组

@property (weak, nonatomic) IBOutlet MBAddShoppingProductNumberView *buyCountActionView; //增减商品用view
@property (weak, nonatomic) IBOutlet MBAddShoppingColorView *showColorCollectionView;
@property (weak, nonatomic) IBOutlet MBAddShoppingSizeView *showSizeCollectionView;
- (void)updateData;

@end
