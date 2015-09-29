//
//  BrandListTableCell.m
//  Wefafa
//
//  Created by CesarBlade on 15-4-1.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "BrandListTableCell.h"
#import "ModelBase.h"
#import "Utils.h"
@implementation BrandListTableCell
{
    BrandListCellModel* cellModel;
}
@synthesize brandLabel,logoImgView;
- (void)awakeFromNib {
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, self.frame.size.width, 0.5)];
    [line setBackgroundColor:[UIColor colorWithRed:0.796 green:0.796 blue:0.796 alpha:1.0]];
    [self.contentView addSubview:line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellInfo:(BrandListCellModel *)model{
    cellModel = model;
    
    [logoImgView sd_setImageWithURL:[NSURL URLWithString:model.logoImg] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    logoImgView .contentMode = UIViewContentModeScaleAspectFit;
    
    
    
    NSString *brandStr = model.brand;
    [brandLabel setText:@""];
    if ([brandStr length]>0) {
        brandLabel.text = brandStr ;
    }
    
    NSString *brandName= [NSString stringWithFormat:@"%ld,%@",(long)model.brandID,model.brand];
    brandLabel.text = brandName;

//
//    NSString *nameStr = model.nickName;
//    if ([nameStr length] <= 0) {
//        nameStr = model.userName;
//    }
//    CGSize size = [nameStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 20)];
//    
//    CGFloat xPoint = (self.frame.size.width - (size.width + 35))/2;
//    CGRect nameFrame = _nameLabel.frame;
//    nameFrame.origin.x = xPoint;
//    nameFrame.size.width = size.width;
//    _nameLabel.frame = nameFrame;
//    
//    CGRect levelFrame = _levelImage.frame;
//    levelFrame.origin.x = nameFrame.origin.x + size.width + 5;
//    _levelImage.frame = levelFrame;
//    [_levelImage setLevelNum:model.userLevel];
//    
//    [_nameLabel setText:nameStr];
//    
//    //    [_levelLabel setText:[NSString stringWithFormat:@"V%d",model.userLevel]];
//    [_cellSubView configViewContentWithInfo:model.collocationList];
}

@end
