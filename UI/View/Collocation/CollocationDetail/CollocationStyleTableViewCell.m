//
//  CollocationStyleTableViewCell.m
//  Wefafa
//
//  Created by zhangjiwen on 15/1/23.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#define CollocationStyleButtonFont [UIFont fontWithName:@"Helvetica-Bold" size:12]//[UIFont systemFontOfSize:12]
#define StyleSizeHeight 24

#import "CollocationStyleTableViewCell.h"
#import "Utils.h"


static const int CollocationStyleTableViewCellHeight=30+15;
static const int Margin=8;


@implementation CollocationStyleButton: UIButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.titleEdgeInsets = UIEdgeInsetsMake(0, Margin/2, 0, Margin/2);
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
//        [self setBackgroundColor:[UIColor colorWithRed:0.286 green:0.498 blue:0.631 alpha:1.0]];
        [self setBackgroundColor:[Utils HexColor:0x919191 Alpha:1]];
//        [self setBackgroundColor:[UIColor colorWithRed:84/255.0 green:105/255.0 blue:122/255.0 alpha:1.0]];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.titleLabel.font = CollocationStyleButtonFont;
        self.adjustsImageWhenHighlighted = NO;
        self.highlighted = NO;
    }
    return self;
}
@end


@implementation CollocationStyleTableViewCell
{
//    UIImageView *topSeparatorLine;      //顶部的分割线
    UIImageView *styleImageV;           //风格栏左边的标签图标
    UIScrollView *styleScrollView;      //展示风格的scrollView
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [self innerInit];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)innerInit
{
//    顶部分割线
//    if (topSeparatorLine == nil) {
//        topSeparatorLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WINDOWW, 0.5)];
//        topSeparatorLine.backgroundColor = COLLOCATION_TABLE_LINE;
//        [self.contentView addSubview:topSeparatorLine];
//    }
//   展示风格的scrollView
    if (styleScrollView == nil) {
        styleScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WINDOWW,CollocationStyleTableViewCellHeight)];
        styleScrollView.backgroundColor = COLLOCATION_TABLE_BG;
        styleScrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:styleScrollView];
    }
//    左边的标签图片
    if (styleImageV == nil) {
        styleImageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 8+7, 12, 13.5)];
//        [styleImageV setFrame:CGRectZero];
//        随便找了一张图片做测试
        styleImageV.image = [UIImage imageNamed:@"圆角矩形-3@2x"];
        [styleScrollView addSubview:styleImageV];
    }
}
/**
 *  设置scrollView上的内容
 *  @param data 标签数组
 */
-(void)setData:(NSArray *)data{
    _data = data;
    if (!_data || _data.count == 0) {
        self.frame = CGRectMake(0, 0, 0, 0);
        return;
    }
    NSArray * systemArray = _data[0];
    NSArray *customArray = _data[1];
    //    scrollView在X轴方向内容的长度
    float styleLabelOffsetX = CGRectGetMaxX(styleImageV.frame) + 10;
    for (int i = 0; i <  systemArray.count; i++) {
        CollocationStyleButton *style = [CollocationStyleButton buttonWithType:UIButtonTypeCustom];
        style.sourceDict =  systemArray[i];
        [style.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        //        计算标签标题的长度
        CGSize styleSize = [self sizeWithString:style.sourceDict[@"showTagName"] withFont:CollocationStyleButtonFont];
        style.frame = CGRectMake(styleLabelOffsetX, (CollocationStyleTableViewCellHeight - StyleSizeHeight)/2, styleSize.width, StyleSizeHeight);
        styleLabelOffsetX += styleSize.width + Margin;
        [style setTitle:style.sourceDict[@"showTagName"] forState:UIControlStateNormal];
 
        [style setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        style.tag=10000;
        [style addTarget:self action:@selector(styleAction:) forControlEvents:UIControlEventTouchUpInside];
        [styleScrollView addSubview:style];
    }
    for (int i = 0; i <  customArray.count; i++) {
        
        CollocationStyleButton *style = [CollocationStyleButton buttonWithType:UIButtonTypeCustom];
        style.sourceDict =  customArray[i];
        [style.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        //        计算标签标题的长度
        CGSize styleSize = [self sizeWithString:style.sourceDict[@"showTagName"] withFont:CollocationStyleButtonFont];
        style.frame = CGRectMake(styleLabelOffsetX, (CollocationStyleTableViewCellHeight - StyleSizeHeight)/2, styleSize.width, StyleSizeHeight);
        styleLabelOffsetX += styleSize.width + Margin;
        [style setTitle:style.sourceDict[@"showTagName"] forState:UIControlStateNormal];
        [style setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        style.tag=20000;
        [style addTarget:self action:@selector(styleAction:) forControlEvents:UIControlEventTouchUpInside];
        [styleScrollView addSubview:style];
    }
    styleScrollView.contentSize = CGSizeMake(styleLabelOffsetX, CollocationStyleTableViewCellHeight);
}
/**
 *  返回字符串的宽度
 *  @param string 字符串
 *  @param font   字符串的字体
 *  @return 字符串的宽度
 */
-(float )widthWithString:(NSString *)string withFont:(UIFont *)font{
    if (!string || string.length == 0) return 0.0;
    CGSize size;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            size = [string sizeWithAttributes:@{NSFontAttributeName:font}];
        } else {
            size = [string sizeWithFont:font];
        }
    if (size.width >= 80.0) {
        return 80.0 + Margin;           //补充按钮title两边的距离
    }
    return size.width + Margin;         //补充按钮title两边的距离
}
/**
 *  返回字符串的size
 *  @param string 字符串
 *  @param font   字符串的字体
 *  @return 字符串的size
 */
-(CGSize )sizeWithString:(NSString *)string withFont:(UIFont *)font{
    if (!string || string.length == 0) return CGSizeMake(0.0, 0.0);
    CGSize size;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        size = [string sizeWithAttributes:@{NSFontAttributeName:font}];
    } else {
        size = [string sizeWithFont:font];
    }
    if (size.width >= 80.0) {
        size.width = 80.0 + Margin;             //补充按钮title两边的距离
    } else {
        size.width = size.width + Margin;       //补充按钮title两边的距离
    }
    return size;
}

+(int)getCellHeight:(id)data1
{
    return CollocationStyleTableViewCellHeight;
}
//标签的点击事件
-(void)styleAction:(CollocationStyleButton *)sender{
    int tag = (int)sender.tag;
    NSString * showType=@"";
    if(tag==10000)
    {
        showType = [NSString stringWithFormat:@"1"]; // 系统
    }else
    {
        showType = [NSString stringWithFormat:@"0"]; // 自定义
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notif_tvCollectionDetailStyle_OnDidSelected"
                                                       object:self
                                                     userInfo:@{@"showTagId":sender.sourceDict[@"showTagId"],@"showTagName":sender.sourceDict[@"showTagName"],@"tagType":showType}];
}
@end
