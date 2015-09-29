//
//  SCollectionProductCollectionViewCell.h
//  Wefafa
//
//  Created by Mr_J on 15/9/8.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCollocationSubProductModel;

@protocol SCollectionProductCollectionViewCellDelegate <NSObject>

- (void)touchSelectedButtonAction:(UIButton *)sender;

@end

@interface SCollectionProductCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) id<SCollectionProductCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) SCollocationSubProductModel *contentModel;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UILabel *showSoldOutView;

@end
