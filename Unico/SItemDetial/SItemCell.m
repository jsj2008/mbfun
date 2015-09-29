//
//  SItemCell.m
//  Wefafa
//
//  Created by unico on 15/5/18.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//
#import "SUtilityTool.h"
#import "SItemCell.h"
#import "LNGood.h"
#import "UIImageView+WebCache.h"

@interface SItemCell ()
{
    UIImageView *imageView;
    UILabel *tempLabel;
}
@end


@implementation SItemCell

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    CGRect imgFrame = CGRectMake((frame.size.width - 50)/2, 15, 50, 50);
    imageView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:DEFAULT_LOADING_IMAGE rect:imgFrame];
    [self addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:nil fontStyle:FONT_t6 color:COLOR_C2 rect:CGRectMake(0, imageView.height + 20, frame.size.width,20) isFitWidth:NO isAlignLeft:YES];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:tempLabel];
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkDetail:)];
//    [imageView addGestureRecognizer:tap];
    
    
    return self;
}

-(void)updateSItemModel:(BrandSubItem*)model
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    tempLabel.text = [NSString stringWithFormat:@"%@",model.name];

}
//-(void)checkDetail:(UITapGestureRecognizer*)tap
//{
//
//}

@end