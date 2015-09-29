//
//  SCollocationProductCell.m
//  Wefafa
//
//  Created by unico_0 on 7/28/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SCollocationProductCell.h"
#import "MBGoodsDetailsModel.h"
#import "Utils.h"

@interface SCollocationProductCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation SCollocationProductCell

- (void)awakeFromNib {
    self.showImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentModel:(MBGoodsDetailsModel *)contentModel{
    _contentModel = contentModel;
    self.nameLabel.text = contentModel.clsInfo.name;
    self.priceLabel.text = [Utils getSNSRMBMoney:contentModel.clsInfo.price.stringValue];
    self.salePriceLabel.text = [Utils getSNSRMBMoney:contentModel.clsInfo.sale_price.stringValue];
    if (contentModel.clsInfo.sale_price.floatValue == contentModel.clsInfo.price.floatValue) {
        self.priceLabel.hidden = YES;
        self.lineView.hidden = YES;
    }else{
        self.priceLabel.hidden = NO;
        self.lineView.hidden = NO;
    }
    MBGoodsDetailsPictureModel *urlModel = contentModel.clsPicUrl[0];
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:urlModel.filE_PATH] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
}

@end
