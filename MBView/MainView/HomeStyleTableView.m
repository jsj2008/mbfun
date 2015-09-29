//
//  HomeStyleTableView.m
//  Wefafa
//
//  Created by zhangjiwen on 15/1/23.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#define CollocationStyleButtonFont [UIFont systemFontOfSize:12]


#import "HomeStyleTableView.h"
#import "Utils.h"


//static const int CollocationStyleTableViewCellHeight=24;
//static const int Margin=15;
@interface TagButton: UIButton
@property (nonatomic,strong) NSString *tagType;
@property (nonatomic,strong) NSDictionary *tagDict;
@end

@implementation TagButton: UIButton

@end


@implementation HomeStyleTableView
{
//    UIImageView *styleImageV;           //风格栏左边的标签图标
//    UIImageView *topSeparatorLine;      //顶部的分割线
//    UIScrollView *styleScrollView;      //展示风格的scrollView
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self innerInit];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)setStyleArray:(NSArray *)styleArray
{
    for(UIView *subView in self.subviews){
        [subView removeFromSuperview];
    }
//    _styleArray = styleArray;
    CGSize maxSize = [@"最大长度" sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100, 20)];
    CGFloat beginPoint = 0;
    NSInteger index = 0;
    
    for(NSDictionary *dict in styleArray){
        NSString *title = [dict objectForKey:@"showTagName"];
        CGSize aSize = [title sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(100, 20)];
        CGFloat width = (aSize.width > maxSize.width) ? maxSize.width : aSize.width;
//        [self configLabelWithXPoint:beginPoint width:width + 5 title:title tag:(index + 100 * self.indexRow)];
        beginPoint += (width + 10);
        index ++;
    }
    
}

- (void)setTagDict:(NSDictionary *)tagDict
{
    for(UIView *subView in self.subviews){
        [subView removeFromSuperview];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 12, 13.5)];
    [imageView setImage:[UIImage imageNamed:@"圆角矩形-3@2x.png"]];
    [self addSubview:imageView];
    _tagDict = tagDict;
    CGSize maxSize = [@"最大长度" sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100, 20)];
    CGFloat beginPoint = 17;
    NSInteger index = 0;
    NSArray *tagArray = nil;
    if ([tagDict objectForKey:@"tagMapping"]) {
        tagArray = [tagDict objectForKey:@"tagMapping"];
        for(NSDictionary *dict in tagArray){
            NSString *title = [dict objectForKey:@"showTagName"];
            CGSize aSize = [title sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(100, 20)];
            CGFloat width = (aSize.width > maxSize.width) ? maxSize.width : aSize.width;
            [self configLabelWithXPoint:beginPoint width:width + 5 tagType:@"tagMapping" tag:(index + 100 * self.indexRow) dict:dict];
            beginPoint += (width + 20);
            index ++;
        }
    }
    if ([tagDict objectForKey:@"customTagColMapping"]) {
        tagArray = [tagDict objectForKey:@"customTagColMapping"];
        for(NSDictionary *dict in tagArray){
            NSString *title = [dict objectForKey:@"showTagName"];
            CGSize aSize = [title sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(100, 20)];
            CGFloat width = (aSize.width > maxSize.width) ? maxSize.width : aSize.width;
            [self configLabelWithXPoint:beginPoint width:width + 5 tagType:@"customTagColMapping" tag:(index + 100 * self.indexRow) dict:dict];
            beginPoint += (width + 20);
            index ++;
        }
    }
}
//101 125 139
- (void)configLabelWithXPoint:(CGFloat)xPoint width:(CGFloat)width tagType:(NSString *)tagType tag:(NSInteger)tag dict:(NSDictionary *)dict
{
    TagButton *btn = [TagButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(xPoint, 0, width+10, 18)];
    [btn setBackgroundColor:[UIColor colorWithRed:0.286 green:0.498 blue:0.631 alpha:1.0]];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [btn.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [btn.layer setCornerRadius:6.0];
    [btn setTag:tag];
//    [btn.layer setBorderColor:[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.0].CGColor];
    [btn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [btn.layer setBorderWidth:1.0];
    [btn.layer setMasksToBounds:YES];
    [btn setTitle:[dict objectForKey:@"showTagName"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didSelectIndexTag:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTagType:tagType];
    [btn setTagDict:dict];
    [self addSubview:btn];
}

- (void)didSelectIndexTag:(TagButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(kDidSelecttIndexHomeTag:indexRow:)]) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:button.tagDict];
        [dict setObject:button.tagType forKey:@"tagType"];
        [_delegate kDidSelecttIndexHomeTag:dict indexRow:0];
    }
}

-(void)innerInit
{
////    左边的标签图片
//    if (styleImageV == nil) {
//        styleImageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
//        styleImageV.backgroundColor = [UIColor yellowColor];
////        随便照了一张图片做测试
//        styleImageV.image = [UIImage imageNamed:@"deyi"];
//        [self.contentView addSubview:styleImageV];
//    }
//    顶部分割线
//    if (topSeparatorLine == nil) {
//        topSeparatorLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WINDOWW, 0.5)];
//        topSeparatorLine.backgroundColor = COLLOCATION_TABLE_LINE;
//        [self.contentView addSubview:topSeparatorLine];
//    }
//   展示风格的scrollView
//    if (styleScrollView == nil) {
////        styleScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(styleImageV.frame), Margin, WINDOWW -CGRectGetMaxX(styleImageV.frame) - Margin , WINDOWW -CGRectGetMaxX(styleImageV.frame) - Margin];
//        styleScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WINDOWW,CollocationStyleTableViewCellHeight)];
//        styleScrollView.backgroundColor = COLLOCATION_TABLE_BG;
//        styleScrollView.showsHorizontalScrollIndicator = NO;
//        [self addSubview:styleScrollView];
//    }
}

//-(void)setData:(NSArray *)data{
//    _data = data;
////    scrollView在X轴方向内容的长度
//    float styleLabelOffsetX = Margin;
//    for (int i = 0; i < _data.count; i++) {
//        CollocationStyleCellButton *style = [CollocationStyleCellButton buttonWithType:UIButtonTypeCustom];
//        style.sourceDict = _data[i];
////        计算标签标题的长度
//        float width = [self sizeWithString:style.sourceDict[@"showTagName"] withFont:CollocationStyleButtonFont];
//        style.frame = CGRectMake(styleLabelOffsetX, 5, width, CollocationStyleTableViewCellHeight - 10);
//        styleLabelOffsetX += width + Margin;
//        [style setTitle:style.sourceDict[@"showTagName"] forState:UIControlStateNormal];
//        [style addTarget:self action:@selector(styleAction:) forControlEvents:UIControlEventTouchUpInside];
//        [styleScrollView addSubview:style];
//    }
//    styleScrollView.contentSize = CGSizeMake(styleLabelOffsetX, CollocationStyleTableViewCellHeight);
//}
//
//-(float )sizeWithString:(NSString *)string withFont:(UIFont *)font{
//    CGSize size;
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
//            size = [string sizeWithAttributes:@{NSFontAttributeName:font}];
//        } else {
//            size = [string sizeWithFont:font];
//        }
//    if (size.width >= 80.0) {
//        return 80.0 + 2*Margin;
//    }
//    return size.width + 2*Margin;
//}
//
//+(int)getCellHeight:(id)data1
//{
//    return CollocationStyleTableViewCellHeight;
//}
////标签的点击事件
//-(void)styleAction:(CollocationStyleCellButton *)sender{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"notif_HomeViewControllerStyle_OnDidSelected"
//                                                       object:self
//                                                     userInfo:@{@"showTagId":sender.sourceDict[@"showTagId"],@"showTagName":sender.sourceDict[@"showTagName"]}];
//}
@end
