//
//  SSortBrandByLetterCell.m
//  Wefafa
//
//  Created by lizhaoxiang on 15/6/9.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SSortBrandByLetterCell.h"
#import "SUtilityTool.h"
#import "Utils.h"
@implementation SSortBrandByLetterCell
{
    UIImageView * logoImg;
    UILabel     * brandNameLabel;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        logoImg = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:nil rect:CGRectMake(15, (self.contentView.size.height-30)/2, 30, 30)];
        logoImg.contentMode = UIViewContentModeScaleAspectFit;
        brandNameLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:nil fontStyle:[UIFont systemFontOfSize:14.0] color:UIColorFromRGB(0x999999) rect:CGRectMake(CGRectGetMaxX(logoImg.frame)+15, 0, 0, 0) isFitWidth:YES isAlignLeft:NO];
        [self.contentView addSubview:logoImg];
        [self.contentView addSubview:brandNameLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;

}
-(void)updateSSorderBrandByLetterModel:(SSortBrandByLetterSubModel*)model
{
    [logoImg sd_setImageWithURL:[NSURL URLWithString:model.logO_URL] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    NSString * brandStr = model.branD_NAME;
   CGSize brandSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:brandStr fontStyle:[UIFont systemFontOfSize:14.0]];
    brandNameLabel.size = brandSize;
    brandNameLabel.origin = CGPointMake(brandNameLabel.frame.origin.x, (self.contentView.size.height-brandSize.height)/2);
    brandNameLabel.text = brandStr;
}

@end
