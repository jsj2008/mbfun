//
//  GoodsCollectionCell.h
//  newdesigner
//
//  Created by Miaoz on 14-9-28.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GoodObj.h"
@protocol GoodsCollectionCellDelegate <NSObject>

@optional
-(void)callBackGoodsCollectionCellWithjudgeType:(id)sender withGoodobj:(id) senderobj;

@end


@interface GoodsCollectionCell : UICollectionViewCell
@property(nonatomic,weak) id <GoodsCollectionCellDelegate> delegate;

@property(nonatomic,strong)GoodObj *goodObj;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIImageView *bolltomLineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *topLineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightLineImageVIew;
@property (weak, nonatomic) IBOutlet UIImageView *leftLineImageView;

@end
