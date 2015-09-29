//
//  ZaoXingShiCell.m
//  Wefafa
//
//  Created by su on 15/1/28.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SearchDesignerCell.h"
#import "UIImageView+AFNetworking.h"
#import "DesignerModel.h"
#import "Utils.h"
@interface UserLevel : UIView
@property(nonatomic,assign)NSInteger levelNum;
@end

@implementation UserLevel{
    UILabel *_levelLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24.5, 11.5)];
        [imageView setImage:[UIImage imageNamed:@"levelBg@2x.png"]];
        [self addSubview:imageView];
        
        _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 0, 12.5, 11.5)];
        [_levelLabel setTextColor:[UIColor colorWithRed:0.424 green:0.282 blue:0.008 alpha:1.0]];
        [_levelLabel setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:11]];
        [_levelLabel setAdjustsFontSizeToFitWidth:YES];
        [_levelLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_levelLabel];
    }
    return self;
}

- (void)setLevelNum:(NSInteger)levelNum
{
    NSString *title = @"";
    if (levelNum < 10) {
        if (levelNum == 0) {
            levelNum = 1;
        }
        title = [NSString stringWithFormat:@"0%d",levelNum];
    } else {
        title = [NSString stringWithFormat:@"%d",levelNum];
    }
    [_levelLabel setText:title];
}

@end

@implementation SearchDesignerCell{
    UIImageView *_headerImg;
    UILabel *_nameLabel;
    UserLevel *_levelLabel;
    UILabel *_fansLabel;
    UILabel *_attentionLabel;
    UILabel *_collocationLabel;
    UILabel *_remarkLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        _headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 38, 38)];
        [self setCornerWith:_headerImg radius:38.0/2 borderColor:[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.0]];
        
        [self.contentView addSubview:_headerImg];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 13, 165, 15)];
        [_nameLabel setFont:[UIFont systemFontOfSize:13]];
        [_nameLabel setTextColor:[UIColor blackColor]];
//        [_nameLabel setBackgroundColor:[UIColor blueColor]];
        [self.contentView addSubview:_nameLabel];
        
//        CGFloat xPoint = self.frame.size.width / 3;
//        _fansLabel = [[UILabel alloc] init];
//        _attentionLabel = [[UILabel alloc] init];
//        _collocationLabel = [[UILabel alloc] init];
//        [self countViewWithTitle:@"粉丝" label:_fansLabel xPoint:0];
//        [self countViewWithTitle:@"关注" label:_attentionLabel xPoint:xPoint];
//        [self countViewWithTitle:@"搭配" label:_collocationLabel xPoint:xPoint * 2];
        
        //_levelLabel = [[UserLevel alloc] initWithFrame:CGRectMake(100, 15, 24.5, 11.5)];
//        [_levelLabel setFont:[UIFont systemFontOfSize:12]];
//        [_levelLabel setTextAlignment:NSTextAlignmentCenter];
//        [_levelLabel setBackgroundColor:[UIColor yellowColor]];
//        [self setCornerWith:_levelLabel radius:4 borderColor:[UIColor whiteColor]];
        //[self.contentView addSubview:_levelLabel];
        
        _fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, 0, 20)];
        [self lable:_fansLabel font:[UIFont systemFontOfSize:9] color:nil];
//        [_fansLabel setFont:[UIFont systemFontOfSize:10]];
//        [_fansLabel setTextColor:[UIColor colorWithRed:0.796 green:0.796 blue:0.796 alpha:1.0]];
////        NSString *fansStr = [NSString stringWithFormat:@"粉丝 400万"];
////        [_fansLabel setAttributedText:[self getAttributeStrWithStringWithString:fansStr]];
//        [self.contentView addSubview:_fansLabel];
        
        _attentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, 0, 20)];
        [self lable:_attentionLabel font:[UIFont systemFontOfSize:9] color:nil];
//        [_attentionLabel setFont:[UIFont systemFontOfSize:9]];
//        [_attentionLabel setTextColor:[UIColor colorWithRed:0.796 green:0.796 blue:0.796 alpha:1.0]];
////        fansStr = [NSString stringWithFormat:@"关注 400"];
////        [_attentionLabel setAttributedText:[self getAttributeStrWithStringWithString:fansStr]];
//        [self.contentView addSubview:_attentionLabel];
        
        _collocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, 0, 20)];
        [self lable:_collocationLabel font:[UIFont systemFontOfSize:9] color:nil];
//        [_collocationLabel setFont:[UIFont systemFontOfSize:9]];
//        [_collocationLabel setTextColor:[UIColor colorWithRed:0.796 green:0.796 blue:0.796 alpha:1.0]];
////        fansStr = [NSString stringWithFormat:@"搭配 400"];
////        [_collocationLabel setAttributedText:[self getAttributeStrWithStringWithString:fansStr]];
//        [self.contentView addSubview:_collocationLabel];
        
        _favoriteBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
        [_favoriteBtn setFrame:CGRectMake(UI_SCREEN_WIDTH - 75, 22, 60, 24)];
        //[_favoriteBtn setImageEdgeInsets:UIEdgeInsetsMake(1, 10, 1, 10)];
        [self.contentView addSubview:_favoriteBtn];
        
        _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 28, _favoriteBtn.frame.origin.x - 55, 15)];
        [_remarkLabel setFont:[UIFont systemFontOfSize:11.0]];
        [_remarkLabel setLineBreakMode:NSLineBreakByTruncatingTail];
//        [_remarkLabel setTextColor:[UIColor colorWithRed:0.796 green:0.796 blue:0.796 alpha:1.0]];
        [_remarkLabel setTextColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:_remarkLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 67.5, UI_SCREEN_WIDTH, 0.5)];
        [line setBackgroundColor:[UIColor colorWithRed:0.796 green:0.796 blue:0.796 alpha:1.0]];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)lable:(UILabel *)label font:(UIFont *)font color:(UIColor *)color
{
    [label setFont:[UIFont systemFontOfSize:11]];
    [label setTextColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:label];
}

- (void)countViewWithTitle:(NSString *)title label:(UILabel *)label xPoint:(CGFloat)xPoint
{
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(xPoint, 50, self.frame.size.width/3, 30)];
    [subView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:subView];
    
    [label setFrame:CGRectMake(0, 0, subView.frame.size.width, 15)];
    [label setFont:[UIFont systemFontOfSize:12.0]];
    [label setTextColor:[UIColor blackColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [subView addSubview:label];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.frame.size.width/3.0, 15)];
    [titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [titleLabel setTextColor:[UIColor colorWithRed:0.796 green:0.796 blue:0.796 alpha:1.0]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:title];
    [subView addSubview:titleLabel];
}

- (NSAttributedString *)getAttributeStrWithStringWithString:(NSString *)string
{
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:string];
    //把this的字体颜色变为红色
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor grayColor]
                        range:NSMakeRange(0, 2)];
    //把is变为黄色
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor blackColor]
                        range:NSMakeRange(3, [string length] - 3)];
    //改变this的字体，value必须是一个CTFontRef
//    [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 4)];

    return attriString;
}

- (void)setCornerWith:(UIView *)view radius:(CGFloat)radius borderColor:(UIColor *)color
{
    [view.layer setCornerRadius:radius];
    [view.layer setBorderColor:color.CGColor];
    [view.layer setBorderWidth:0.5];
    [view.layer setMasksToBounds:YES];
}

- (void)favButtonClick:(UIButton *)btn
{
    
}

- (void)updateCellContentWithInfo:(id)info
{
    
}

- (CGFloat)calcStrLengthWithLabel:(UILabel *)label title:(NSString *)title count:(NSInteger)count xPoint:(CGFloat)xPoint
{
    NSString *str = [NSString stringWithFormat:@"%@ %d",title,count];
    CGSize aSize;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0) {
       aSize = [str sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(100, 20)];
    }
     else
    {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};

        aSize.width = [str boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size.width;
        aSize.height = [str boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size.height;
    }
    CGRect aFrame = label.frame;
    aFrame.origin.x = xPoint;
    aFrame.size.width = aSize.width;
    label.frame = aFrame;
    [label setText:str];
    return aFrame.origin.x + aSize.width;
}

- (void)getNumWithInfo:(NSDictionary *)dict key:(NSString *)key
{
    
}

- (void)updateDataWithDictionary:(DesignerModel *)model
{
//    CGFloat xPoint = [self calcStrLengthWithLabel:_collocationLabel title:@"搭配" count:model.designCount xPoint:self.frame.size.width - 10];
    
   CGFloat xPoint = [self calcStrLengthWithLabel:_fansLabel title:@"粉丝" count:model.fansCount xPoint:_nameLabel.frame.origin.x];
    xPoint = [self calcStrLengthWithLabel:_attentionLabel title:@"关注" count:model.concernsCount  xPoint:xPoint + 10];
    xPoint = [self calcStrLengthWithLabel:_collocationLabel title:@"搭配" count:model.designCount xPoint:xPoint + 10];
    
    
    NSString *name = model.userName;
    
    CGSize aSize ;
    if ([[UIDevice currentDevice] systemVersion].floatValue<7.0) {
        aSize = [name sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(100, 20)];
    }
    else
    {
        NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        aSize.width = [name boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size.width;
         aSize.height = [name boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size.height;
    
    }
//    NSString *level = [NSString stringWithFormat:@"%@",model.grade];
//    CGSize bSize = [level sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(30, 20)];
    CGRect levelFrame = _levelLabel.frame;
    CGRect nameFrame =  _nameLabel.frame;
    if ((aSize.width + 24.5) > _remarkLabel.frame.size.width) {
//        levelFrame.size.width = bSize.width;
        levelFrame.origin.x = _favoriteBtn.frame.origin.x - 24.5 - 10;
        _levelLabel.frame = levelFrame;
        
        nameFrame.size.width = levelFrame.origin.x - nameFrame.origin.x - 5;
        _nameLabel.frame = nameFrame;
    } else {
        nameFrame.size.width = aSize.width;
        _nameLabel.frame = nameFrame;
        
        levelFrame.origin.x = nameFrame.origin.x + aSize.width + 5;
//        levelFrame.size.width = bSize.width;
        _levelLabel.frame = levelFrame;
    }
    
//    [_collocationLabel setText:[NSString stringWithFormat:@"%d",model.designCount]];
//    [_attentionLabel setText:[NSString stringWithFormat:@"%d",model.concernsCount]];
//    [_fansLabel setText:[NSString stringWithFormat:@"%d",model.fansCount]];
    
    [_headerImg setImageAFWithURL:[NSURL URLWithString:model.headPortrait] placeholderImage:[UIImage imageNamed:@"home_cell_default@2x.png"]];
//    [_headerImg setImage:[UIImage imageNamed:@"pic_loading@3x.png"]];
    [_nameLabel setText:name];
    
//    NSString *level = [[model.grade uppercaseString] stringByReplacingOccurrencesOfString:@"V" withString:@""];
//    [_levelLabel setLevelNum:[level integerValue]];
    NSString *markStr = model.userSignature;
    if (!markStr || [markStr length] == 0) {
        markStr = @"暂无个性签名!";
    }
    [_remarkLabel setText:markStr];

    if (!model.isConcerned) {
        [_favoriteBtn setImage:[UIImage imageNamed:@"jiaguanzhu"] forState:UIControlStateNormal];
    } else {
        [_favoriteBtn setImage:[UIImage imageNamed:@"yiguanzhu"] forState:UIControlStateNormal];
    }
    
}

@end
