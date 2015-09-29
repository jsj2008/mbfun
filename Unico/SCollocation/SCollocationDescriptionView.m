//
//  SCollocationDescriptionView.m
//  Wefafa
//
//  Created by unico_0 on 7/24/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SCollocationDescriptionView.h"
#import "SCollocationDetailModel.h"
#import "SUtilityTool.h"

@interface SCollocationDescriptionView ()

@property (nonatomic, strong) UIView *showLineView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation SCollocationDescriptionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    _showLineView = [[UIView alloc]initWithFrame:CGRectMake(10, 15, 3, 20)];
    _showLineView.backgroundColor = COLOR_C1;
    [self addSubview:_showLineView];
    
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 15, UI_SCREEN_WIDTH - 40, 20)];
    _contentLabel.font = FONT_t5;
    _contentLabel.textColor = COLOR_C2;
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
}

- (void)setContentModel:(SCollocationDetailModel *)contentModel{
    _contentModel = contentModel;
    self.contentString = contentModel.content_info;
}

- (void)setContentString:(NSString *)contentString{
    _contentString = [contentString copy];
    self.hidden = contentString.length <= 0;
    CGSize size = [contentString boundingRectWithSize:CGSizeMake(_contentLabel.frame.size.width, 0) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : FONT_t5} context:nil].size;
    _contentLabel.height = size.height;
    _showLineView.height = size.height;
    self.height = size.height;
    _contentLabel.text = contentString;
}

@end
