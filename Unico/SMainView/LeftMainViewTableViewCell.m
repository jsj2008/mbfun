//
//  LeftMainViewTableViewCell.m
//  Wefafa
//
//  Created by wave on 15/8/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "LeftMainViewTableViewCell.h"
#import "SLeftMainViewModel.h"
#import "SUtilityTool.h"
#import "Utils.h"

@interface LeftMainViewTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *leftIMG;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightIMG;

@end

@implementation LeftMainViewTableViewCell

- (void)setModel:(SLeftMainViewModel *)model {
    _model = model;
    [_leftIMG sd_setImageWithURL:[NSURL URLWithString:model.pic_img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    [_titleLabel setText:model.name];
    [_rightIMG sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    
    [_titleLabel sizeToFit];
}
- (void)awakeFromNib {
    // Initialization code
    [_titleLabel setFont:FONT_t4];
    [_titleLabel setTextColor:COLOR_C2];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [_rightIMG setUserInteractionEnabled:YES];
    [_rightIMG addGestureRecognizer:tap];
    
    _rightIMG.contentMode = UIViewContentModeScaleAspectFit;
    _leftIMG.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)click {
    if (_jumpBlock) {
        self.jumpBlock(_model);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
