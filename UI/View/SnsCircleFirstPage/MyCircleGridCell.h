//
//  MyCircleGridCell.h
//  Wefafa
//
//  Created by mac on 13-10-9.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "PSTCollectionView.h"

#define MYCIRCLE_GRID_LEFT_MARGIN 6
#define MYCIRCLE_GRID_WIDTH 150//(SCREEN_WIDTH-MYCIRCLE_GRID_LEFT_MARGIN*4)/2
#define MYCIRCLE_GRID_HEIGHT 62
#define MYCIRCLE_GRID_SPACE SCREEN_WIDTH-MYCIRCLE_GRID_WIDTH-2*MYCIRCLE_GRID_LEFT_MARGIN

@interface MyCircleGridCell : PSUICollectionViewCell
{
    UIImageView *imgHeadBackground;
}
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIImageView *backgroundImage;
@property (strong, nonatomic) UIImageView *userNumImage;
@property (strong, nonatomic) UIImageView *headImage;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UILabel *labelNum;
@property (strong, nonatomic) NSObject *recv_id;
@property (assign, nonatomic) BOOL isHideLabelNum;

@end
