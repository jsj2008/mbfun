//
//  MBMyGoodsContentCollectionViewCell.h
//  Wefafa
//
//  Created by Jiang on 4/1/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBMyGoodsPersonalModel;

@interface MBMyGoodsContentCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) MBMyGoodsPersonalModel *model;
@property (assign, nonatomic) BOOL showPrice;
@property (assign, nonatomic) BOOL showHiddenPic;


@end
