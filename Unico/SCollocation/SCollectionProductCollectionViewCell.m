//
//  SCollectionProductCollectionViewCell.m
//  Wefafa
//
//  Created by Mr_J on 15/9/8.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SCollectionProductCollectionViewCell.h"
#import "Utils.h"

@implementation SCollectionProductCollectionViewCell

- (void)awakeFromNib {
    self.contentImageView.layer.borderWidth = 0.5;
    self.contentImageView.layer.borderColor = UIColorFromRGB(0xd9d9d9).CGColor;
    self.showSoldOutView.layer.masksToBounds = YES;
    self.showSoldOutView.layer.cornerRadius = self.showSoldOutView.width/ 2;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.showSoldOutView.height = self.showSoldOutView.width;
    self.showSoldOutView.layer.cornerRadius = self.showSoldOutView.width/ 2;
}

- (void)setContentModel:(SCollocationSubProductModel *)contentModel{
    _contentModel = contentModel;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.product_img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@%@", contentModel.brand_value, contentModel.cate_value];
    _selectedButton.selected = contentModel.isSelected;
    
    if (contentModel.product_code.length > 0 && contentModel.product) {
        if (contentModel.product.stock_num.intValue <= 0 || contentModel.product.status.intValue != 2) {
            _showSoldOutView.hidden = NO;
            _selectedButton.hidden = YES;
        }else{
            _showSoldOutView.hidden = YES;
            _selectedButton.hidden = !contentModel.isShowSelected;
        }
        self.priceLabel.text = [Utils getSNSRMBMoney:contentModel.product.price];
        _priceLabel.hidden = NO;
    }else{
        _priceLabel.hidden = YES;
        _selectedButton.hidden = YES;
        _showSoldOutView.hidden = YES;
    }
}

- (IBAction)touchSelectedButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    _contentModel.isSelected = sender.selected;
    if ([self.delegate respondsToSelector:@selector(touchSelectedButtonAction:)]) {
        [self.delegate touchSelectedButtonAction:sender];
    }
}


@end
