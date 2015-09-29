//
//  SDiscoveryActivityShowCollectionViewCell.m
//  Wefafa
//
//  Created by unico_0 on 7/22/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryActivityShowCollectionViewCell.h"
#import "SActivityReceiveModel.h"
#import "Utils.h"

@interface SDiscoveryActivityShowCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *showSellStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *showPirce;
@property (weak, nonatomic) IBOutlet UILabel *showSalePirce;

@end

@implementation SDiscoveryActivityShowCollectionViewCell

- (void)awakeFromNib {
    _showSellStateLabel.layer.cornerRadius = 30.0;
    _showSellStateLabel.layer.masksToBounds = YES;
}

- (void)setContentModel:(SActivityProductListModel *)contentModel{
    _contentModel = contentModel;
    
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.product_url] placeholderImage:[UIImage imageNamed:@"pic_loading"]];
    self.showPirce.text = [Utils getSNSRMBMoney:contentModel.market_price];
    self.showSalePirce.text = [Utils getSNSRMBMoney:contentModel.price];
    if ([contentModel.price isEqualToString:contentModel.market_price]) {
        self.showPirce.text = @"";
    }
    if (contentModel.status.intValue != 2 || contentModel.stock_num.intValue <= 0) {
        _showSellStateLabel.hidden = NO;
    }else{
        _showSellStateLabel.hidden = YES;
    }
}

@end
