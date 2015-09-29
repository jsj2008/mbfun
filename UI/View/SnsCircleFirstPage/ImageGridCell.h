//
//  ImageGridCell.h
//  SelectionDelegateExample
//
//  Created by orta therox on 06/11/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//
#import "PSTCollectionView.h"

#define GRIDCELL_MARGIN 16

@interface ImageGridCell : PSUICollectionViewCell
{
    UIImageView *imgHeadBackground;
}
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIImageView *image;
@property (strong, nonatomic) UILabel *label;
@property (assign, nonatomic) int offsetY;
@property (strong, nonatomic) NSObject *recv_id;
@property (strong, nonatomic) UIImageView *imgIcon; //状态小图标

@end
