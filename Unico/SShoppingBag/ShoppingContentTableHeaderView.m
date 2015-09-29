//
//  ShoppingContentTableHeaderView.m
//  Wefafa
//
//  Created by Jiang on 5/23/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "ShoppingContentTableHeaderView.h"
#import "ShoppingBagContentModel.h"
#import "SUtilityTool.h"

@interface ShoppingContentTableHeaderView ()

@end

@implementation ShoppingContentTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    self.backgroundColor = [UIColor whiteColor];
    _selectedStateButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 0, 30, 30)];
    _selectedStateButton.centerY = self.size.height/ 2;
    [_selectedStateButton setImage:[UIImage imageNamed:@"Unico/brand_quan.png"] forState:UIControlStateNormal];
    [_selectedStateButton setImage:[UIImage imageNamed:@"Unico/unico_seleted_btn.png"] forState:UIControlStateSelected];
    _selectedStateButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [_selectedStateButton addTarget:self action:@selector(selectedStateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectedStateButton];
    
    CGRect frame = CGRectMake(CGRectGetMaxX(_selectedStateButton.frame) + 10, 0, 250, 20);
    _titleLabel = [[UILabel alloc]initWithFrame:frame];
    _titleLabel.centerY = self.size.height/ 2;
    _titleLabel.text = @"dasdasdasdasd";
    _titleLabel.font = FONT_T3;
    _titleLabel.textColor = COLOR_C2;
    [self addSubview:_titleLabel];
}

- (void)setContentMdoel:(ShoppingBagContentModel *)contentMdoel{
    _contentMdoel = contentMdoel;
    self.titleLabel.text = contentMdoel.designerName;
    self.selectedStateButton.selected = contentMdoel.isSelected;
}

- (void)selectedStateButtonAction:(UIButton*)sender{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(shoppingHeaderSelectedButton:model:)]) {
        [self.delegate shoppingHeaderSelectedButton:sender model:_contentMdoel];
    }
}

@end
