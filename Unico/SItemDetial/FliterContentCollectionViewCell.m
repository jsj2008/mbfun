//
//  FliterContentCollectionViewCell.m
//  Wefafa
//
//  Created by Jiang on 5/23/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "FliterContentCollectionViewCell.h"
#import "FilterPirceRangeModel.h"
#import "FilterBrandCategoryModel.h"
#import "FilterColorCategoryModel.h"
#import "FilterSizeCategoryModel.h"
#import "UIImageView+AFNetworking.h"
#import "SUtilityTool.h"

@interface FliterContentCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;


@end

@implementation FliterContentCollectionViewCell

- (void)awakeFromNib {
    
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderColor = COLOR_C9.CGColor;
    self.contentView.layer.borderWidth = 1.0;
//    self.contentView.layer.cornerRadius = 4.0;   
    [self.chooseImageView setImage:[UIImage imageNamed:@"Unico/product_selected_state"]];
}

- (void)setSelected:(BOOL)selected{
    if (selected) {
        self.contentView.layer.borderColor = COLOR_C2.CGColor;
        self.contentView.layer.borderWidth = 3.0;
        self.chooseImageView.hidden=NO;
    }else{
        self.chooseImageView.hidden=YES;
        self.contentView.layer.borderColor = COLOR_C9.CGColor;
        self.contentView.layer.borderWidth = 1.0;
    }
}

- (void)setPirceRangeModel:(FilterPirceRangeModel *)pirceRangeModel{
    _pirceRangeModel = pirceRangeModel;
    self.showLabel.hidden = NO;
    self.showImageView.hidden = YES;
    self.chooseImageView.hidden=YES;
    self.showLabel.text = pirceRangeModel.name;
}

- (void)setColorModel:(FilterColorCategoryModel *)colorModel{
    _colorModel = colorModel;
    self.showLabel.hidden = NO;
    self.showImageView.hidden = YES;
    self.chooseImageView.hidden=YES;
    self.showLabel.text = colorModel.coloR_NAME;
}

- (void)setBrandModel:(FilterBrandCategoryModel *)brandModel{
    _brandModel = brandModel;
    self.showLabel.hidden = YES;
    self.showImageView.hidden = NO;
    self.chooseImageView.hidden=YES;
    [self.showImageView setImageAFWithURL:[NSURL URLWithString:brandModel.logO_URL] placeholderImage: [UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
}

- (void)setSizeModel:(FilterSizeCategoryModel *)sizeModel{
    _sizeModel = sizeModel;
    self.showLabel.hidden = NO;
    self.showImageView.hidden = YES;
    self.chooseImageView.hidden=YES;
    self.showLabel.text = sizeModel.name;
}

@end
