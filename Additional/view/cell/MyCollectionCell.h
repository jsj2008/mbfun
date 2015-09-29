//
//  MyCollectionCell.h
//  newdesigner
//
//  Created by Miaoz on 14-9-28.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globle.h"
#import "CollocationInfo.h"

@protocol MyCollectionCellDelegate <NSObject>

@optional
-(void)callBackMyCollectionCellWithCollocationInfo:(id)sender;

@end


@interface MyCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIImageView *aboveImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *topLineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightLineImageView;
@property (weak, nonatomic) id <MyCollectionCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *leftLineImageView;
@property (strong, nonatomic)CollocationInfo *collocationInfo;
@end
