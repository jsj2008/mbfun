//
//  SItemListCell.m
//  Wefafa
//
//  Created by unico on 15/5/19.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SItemListCell.h"
#import "SUtilityTool.h"
#import "LNGood.h"
#import "UIImageView+WebCache.h"
#import "MBGoodsDetailsModel.h"

@interface SItemListCell ()

@property (nonatomic, weak) UIImageView *showImageView;
@property (nonatomic, weak) UILabel *pirceLabel;

@end


@implementation SItemListCell

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    UILabel *tempLabel;
    UIImageView *imageView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/item_pic" rect:CGRectMake(0, 0, frame.size.width,frame.size.height -AUTO_SIZE((70)/2))];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    self.showImageView = imageView;
    UIView *tempView = [SUTILITY_TOOL_INSTANCE createUIViewByHeightAndWidth:70/2 width:frame.size.width coordY:imageView.height];
    [self addSubview:tempView];
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"¥1234" fontStyle:FONT_SIZE(16) color:nil rect:CGRectMake(25/2, 0,0, tempView.height) isFitWidth:YES isAlignLeft:YES];
    [tempView addSubview:tempLabel];
    self.pirceLabel = tempLabel;
    
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"8652" fontStyle:FONT_SIZE(14) color:UIColorFromRGB(0xc4c4c4) rect:CGRectMake(frame.size.width - 16/2, 0,0, tempView.height) isFitWidth:YES isAlignLeft:NO];
    [tempView addSubview:tempLabel];
    
    imageView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/like_big2" rect:CGRectMake(frame.size.width - 16/2-tempLabel.width-6/2-51/2,tempView.height/2-45/2/2, 51/2, 45/2)];
    [tempView addSubview:imageView];
    

    
    
    self.backgroundColor = COLOR_WHITE;
    return self;
}

- (void)setContentModel:(MBGoodsDetailsModel *)contentModel{
    _contentModel = contentModel;
    [self.showImageView setImageWithURL:[NSURL URLWithString:contentModel.clsInfo.mainImage]];
    self.pirceLabel.text = [NSString stringWithFormat:@"￥%@", contentModel.clsInfo.sale_price];
}

@end