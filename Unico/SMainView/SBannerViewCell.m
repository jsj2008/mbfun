//
//  SBannerViewCell.m
//  Wefafa
//
//  Created by 凯 张 on 15/5/27.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SBannerViewCell.h"
#import "SUtilityTool.h"
@interface SBannerViewCell(){
    UIImageView *p_bannerView;
}
@end

@implementation SBannerViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    p_bannerView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:DEFAULT_LOADING_IMAGE rect:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0)];
    [p_bannerView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:p_bannerView];
    self.cellHeight = 0;
    self.cellAdditionalHeight = 0;
    return self;
}

-(void)updateCellUI{
    if (self.cellData) {
        NSString *tempStr = self.cellData[@"img"];
        float tempHeight = [self.cellData[@"img_height"]floatValue];
        float tempWidth = [self.cellData[@"img_width"]floatValue];
        float floatPercent = UI_SCREEN_WIDTH/(tempWidth/2);
        tempHeight = floatPercent*tempHeight/2;
        if(!_noImage)[p_bannerView sd_setImageWithURL:[NSURL URLWithString:tempStr] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
        [p_bannerView setSize:CGSizeMake(UI_SCREEN_WIDTH, tempHeight)];
    }
    self.cellHeight = p_bannerView.height;
}
-(void)updateCellUIWithModel:(SMBannerModle *)model
{
    NSString *tempStr = model.img;
    float tempHeight = [model.img_height floatValue];
    float tempWidth = [model.img_width floatValue];
    float floatPercent = UI_SCREEN_WIDTH/(tempWidth/2);
    tempHeight = floatPercent*tempHeight/2;
    if(!_noImage)[p_bannerView sd_setImageWithURL:[NSURL URLWithString:tempStr] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    [p_bannerView setSize:CGSizeMake(UI_SCREEN_WIDTH, tempHeight)];
    
    self.cellHeight = p_bannerView.height;
}
@end
