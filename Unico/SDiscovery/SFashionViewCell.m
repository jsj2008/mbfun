//
//  SFashionViewCell.m
//  Wefafa
//
//  Created by 凯 张 on 15/5/31.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SFashionViewCell.h"
#import "SUtilityTool.h"

@interface SFashionViewCell(){
    UIImageView *p_bannerView;
    
    UIView *_backView;
    UILabel *_label;
}
@end

@implementation SFashionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setType:(FashionCellType)type {
    switch (type) {
        case fashionCellTypeShowTransparentView:
        {
            _backView.hidden = NO;
        }
            break;
        case fashionCellTypeHideTransparentView:
        {
            _backView.hidden = YES;
        }
            break;
            
        default:{
            _backView.hidden = NO;
        }
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    p_bannerView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"" rect:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0)];
    [self addSubview:p_bannerView];
    self.cellHeight = 0;
    self.cellAdditionalHeight = 0;
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(10, self.cellHeight - 60, UI_SCREEN_WIDTH - 20, 60)];
    _backView.backgroundColor = [Utils HexColor:0xffffff Alpha:.9];
    [self addSubview:_backView];
    _label = [[UILabel alloc]initWithFrame:CGRectZero];//CGRectMake(15, 17, _backView.width - 30, _backView.height - 15 -17)];
    _label.backgroundColor = [UIColor clearColor];
    _label.numberOfLines = 0;
    [_backView addSubview:_label];

    return self;
}

-(void)updateCellUI{
    if (self.cellData) {
        NSString *tempStr = self.cellData[@"img"];
        float tempHeight = [self.cellData[@"img_height"]floatValue];
        float tempWidth = [self.cellData[@"img_width"]floatValue];
        float floatPercent = UI_SCREEN_WIDTH/(tempWidth/2);
        tempHeight = floatPercent*tempHeight/2;
        [p_bannerView sd_setImageWithURL:[NSURL URLWithString:tempStr] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
        [p_bannerView setSize:CGSizeMake(UI_SCREEN_WIDTH, tempHeight)];

        
        _backView.frame = CGRectMake(10, p_bannerView.height - 60, UI_SCREEN_WIDTH - 20, 60);
        _label.frame = CGRectMake(AUTO(15), AUTO(17), _backView.width - AUTO(15), _backView.height- AUTO(25));

        NSString *nameStr = self.cellData[@"name"];
        NSString *timeStr = self.cellData[@"info"];//[@"name"];
        NSString *str = [NSString stringWithFormat:@"%@\r%@", nameStr, timeStr];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
        [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_C5 range:NSMakeRange(0, nameStr.length)];
        [attStr addAttribute:NSFontAttributeName value:FONT_T4 range:NSMakeRange(0, nameStr.length)];
        [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_C5 range:NSMakeRange(nameStr.length, str.length - nameStr.length)];
        [attStr addAttribute:NSFontAttributeName value:FONT_t6 range:NSMakeRange(nameStr.length, str.length - nameStr.length)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:AUTO(10)];//调整行间距
        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, nameStr.length)];
        
        _label.attributedText = attStr;
        [_label sizeToFit];
    }
    self.cellHeight = p_bannerView.height + 20/2;
}

@end