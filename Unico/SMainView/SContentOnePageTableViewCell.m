//
//  SContentOnePageTableViewCell.m
//  Wefafa
//
//  Created by wave on 15/9/6.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SContentOnePageTableViewCell.h"
#import "SUtilityTool.h"

@interface SContentOnePageTableViewCell ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGRect rect;
@end

@implementation SContentOnePageTableViewCell

- (void)setStr:(NSMutableAttributedString *)str {
    _label.attributedText = str;
    [_label sizeToFit];
    CGSize size = _label.size;
    NSRange range = [str.string rangeOfString:@"查看全部"];
    //18 25
    if (range.location == NSNotFound) {
        //消息
        _label.numberOfLines = 1;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        [_label setPreferredMaxLayoutWidth:width - 30];
        size = [_label intrinsicContentSize];
        size.width = width - 30;    //手动设置宽度，numberOfLines == 1不支持这个方法
        _rect.size = size;
        _rect.origin = CGPointMake(15, 3);
        NSLog(@" size2 ==-== %@", NSStringFromCGSize(size));
    }else {
        //查看更多
        _rect = CGRectMake(15, (30 - size.height) / 2, size.width, size.height);
    }
    _label.frame = _rect;
}

- (void)layoutSubviews {
    _label.frame = _rect;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _rect = CGRectZero;
        _label = [UILabel new];
        [_label setFont:FONT_t6];
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
