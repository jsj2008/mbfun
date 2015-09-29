//
//  SActivityOnSaleCell.m
//  Wefafa
//
//  Created by unico on 15/5/17.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SActivityOnSaleCell.h"
#import "SUtilityTool.h"

@interface SActivityOnSaleCell(){
    UIImageView *headRoundView;
    UIImageView *headImgView;
    
    UIView *buttomBar;
    
    
}


@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation SActivityOnSaleCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    CGRect cellRect = [UIScreen mainScreen].bounds;
    UIImageView *imageView;
    UIView *tempView;
    UILabel *tempLabel;
    UIButton *tempButton;
    CGRect tempRect;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellRect.size.width, AUTO_SIZE(330/2))];
    contentView.backgroundColor = COLOR_WHITE;
    [self addSubview:contentView];
    
    imageView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/discount" rect:CGRectMake(34/2, 22/2, 286/2, 286/2)];
    [contentView addSubview:imageView];
    tempRect = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 34/2, 60/2, 0, 0);
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"百搭圆点半身裙" fontStyle:FONT_SIZE(14) color:nil rect:tempRect isFitWidth:YES isAlignLeft:YES];
    [contentView addSubview:tempLabel];
    
    tempRect = CGRectMake(UI_SCREEN_WIDTH-67/2, 60/2, 92/2, 32/2);
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"4.2折" fontStyle:FONT_SIZE(12) color:[UIColor whiteColor] rect:tempRect isFitWidth:NO isAlignLeft:NO];
    tempLabel.backgroundColor = UIColorFromRGB(0xFE7C94);
    tempLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tempLabel];
    
    tempRect = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 34/2, tempLabel.frame.origin.y+tempLabel.frame.size.height + 22/2, 0, 0);
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"¥79.00" fontStyle:FONT_SIZE(16) color:nil rect:tempRect isFitWidth:YES isAlignLeft:YES];
    [contentView addSubview:tempLabel];
    
    tempRect = CGRectMake(tempLabel.frame.origin.x + tempLabel.frame.size.width + 16/2, tempLabel.frame.origin.y, 0, 0);
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelMiddleLine:@"¥179.00" fontStyle:FONT_SIZE(12) color:[UIColor blackColor] rect:tempRect isFitWidth:YES isAlignLeft:YES];
    [contentView addSubview:tempLabel];
    
//    tempButton = [[UIButton alloc]initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 44/2, contentView.height-22/2 - 76/2, 162/2, 76/2)];
//    [tempButton setTitle:@"立即购买" forState:UIControlStateNormal];
//    tempButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    [tempButton setBackgroundColor:UIColorFromRGB(0xfedc32)];
//    tempButton.titleLabel.textColor = [UIColor whiteColor];
    tempButton = [SUTILITY_TOOL_INSTANCE createTitleButton:@"立即购买" bgColor:UIColorFromRGB(0xfedc32) fontColor:nil fontStyle:FONT_SIZE(16) rect:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 44/2, contentView.height-22/2 - 76/2, 162/2, 76/2)];
    [contentView addSubview:tempButton];
    
    tempView = [[UIView alloc]initWithFrame:CGRectMake(tempButton.frame.origin.x + tempButton.frame.size.width +36/2, tempButton.frame.origin.y, 140/2, 76/2)];
    [contentView addSubview:tempView];
    
    imageView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/like_big2" rect:CGRectMake(0, tempView.frame.size.height/2-45/2/2, 51/2, 45/2)];
    [tempView addSubview:imageView];
    
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"3234" fontStyle:nil color:UIColorFromRGB(0xc4c4c4) rect:CGRectMake(imageView.frame.size.width +10/2, 0, 0, 0) isFitWidth:YES isAlignLeft:YES];
    [tempLabel setOrigin:CGPointMake(tempLabel.frame.origin.x, tempView.height/2-tempLabel.height/2)];
    [tempView addSubview:tempLabel];
   self.cellHeight = contentView.frame.size.height;
    //选择无模式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

// 初始化底部栏目
- (void)setupBottonBar {
}
-(void)showOtherProfile:(id)selecter{
}
-(void)commentMsg:(id)selecter
{
    self.commentMsg(self.data);
}

-(void)shareContent:(id)selecter
{
    self.shareContent(self.data);
}

-(void)likeContent:(id)selecter
{
    
}


@end
