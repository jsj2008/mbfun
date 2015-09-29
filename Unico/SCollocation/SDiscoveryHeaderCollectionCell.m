//
//  SDiscoveryHeaderCollectionCell.m
//  Wefafa
//
//  Created by unico_0 on 7/9/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryHeaderCollectionCell.h"

@implementation SDiscoveryHeaderCollectionCell

- (void)awakeFromNib {
    _contentImageView.layer.masksToBounds = YES;
    _headerTypeImageView.layer.masksToBounds = YES;
    _headerTypeImageView.layer.cornerRadius = _headerTypeImageView.height/ 2;
    _headerTypeImageView.layer.borderWidth = 1;
    _headerTypeImageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end
