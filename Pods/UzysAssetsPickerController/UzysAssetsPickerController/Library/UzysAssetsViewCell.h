//
//  UzysAssetsViewCell.h
//  UzysAssetsPickerController
//
//  Created by Uzysjung on 2014. 2. 12..
//  Copyright (c) 2014년 Uzys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UzysAssetsPickerController_Configuration.h"

@class UzysAssetsViewCell;

@protocol UzysAssetsViewCellDelegate <NSObject>

- (void)uzysAssetsViewCellClick:(UzysAssetsViewCell *)cell;

@end


@interface UzysAssetsViewCell : UICollectionViewCell

@property (nonatomic, strong) ALAsset *asset;

@property(weak, readwrite, nonatomic)id<UzysAssetsViewCellDelegate>delegate;

- (void)applyData:(ALAsset *)asset;

@end
