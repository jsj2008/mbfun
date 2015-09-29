//
//  GoodsListCollectionViewCell.h
//  Wefafa
//
//  Created by Jiang on 3/20/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageInfo, UIUrlImageView;

typedef enum : NSUInteger {
    goodsType = 0,
    collocationType,
    mylikeType,
    brandType //不展示名字 展示价格和喜欢数
} GoodsCellType;

@interface GoodsListCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) ImageInfo *contentModel;

@property (weak, nonatomic) IBOutlet UIUrlImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic, assign) GoodsCellType cellType;
@property (nonatomic, assign) BOOL showName;
@property (weak, nonatomic) IBOutlet UIButton *showOnlyLikeBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareCountButton;

@property (strong, nonatomic) IBOutlet UIImageView *brandImageView;

@end
