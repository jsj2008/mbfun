//
//  SDiscoveryTodayCollectionViewCell.m
//  Wefafa
//
//  Created by unico_0 on 6/20/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryTodayCollectionViewCell.h"
#import "LNGood.h"

@interface SDiscoveryTodayCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@end

@implementation SDiscoveryTodayCollectionViewCell

- (void)awakeFromNib {
    self.headerImageView.layer.cornerRadius = self.headerImageView.bounds.size.width / 2;
    self.headerImageView.layer.masksToBounds = YES;
    self.contentImageView.layer.masksToBounds = YES;
}

- (void)setContentModel:(LNGood *)contentModel{
    _contentModel = contentModel;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.img] placeholderImage:[UIImage imageNamed:@"pic_loading"]];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.head_img] placeholderImage:[UIImage imageNamed:@"default_header_image"]];
}

@end
