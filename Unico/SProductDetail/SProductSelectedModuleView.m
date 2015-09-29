//
//  SProductSelectedModuleView.m
//  Wefafa
//
//  Created by unico_0 on 7/21/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SProductSelectedModuleView.h"
#import "SUtilityTool.h"

@interface SProductSelectedModuleView ()

@property (nonatomic, strong) NSMutableArray *selectedButton;
@property (nonatomic, weak) CALayer *selectedLineLayer;
@property (nonatomic, weak) CALayer *lineLayer;

@end

@implementation SProductSelectedModuleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    [self initSubViews];
}

- (void)initSubViews{
    self.backgroundColor = [UIColor whiteColor];
    _selectedButton = [NSMutableArray array];
    CGFloat width = UI_SCREEN_WIDTH/ 3;
    NSArray *selectedButtonTitleArray = @[@"商品详情", @"相似单品(0)", @"相关搭配(0)"];
    for (int i = 0; i < 3; i ++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * width, 0, width, self.bounds.size.height)];
        button.tag = 160 + i;
        [button setTitle:selectedButtonTitleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:COLOR_C2 forState:UIControlStateSelected];
        [button setTitleColor:COLOR_C6 forState:UIControlStateNormal];
        button.titleLabel.font = FONT_T4;
        [_selectedButton addObject:button];
        [self addSubview:button];
    }
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.zPosition = 5;
    lineLayer.backgroundColor = COLOR_C9.CGColor;
    lineLayer.frame = CGRectMake(0, self.height-0.5, self.width, 0.5f);
    [self.layer addSublayer:lineLayer];
    
    CALayer *selectedLineLayer = [CALayer layer];
    selectedLineLayer.frame = CGRectMake(0, self.height - 3, width, 3);
    selectedLineLayer.zPosition = 5;
    selectedLineLayer.backgroundColor = COLOR_C1.CGColor;
    [self.layer addSublayer:selectedLineLayer];
    _selectedLineLayer = selectedLineLayer;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = UI_SCREEN_WIDTH/ 3;
    for (int i = 0; i < 3; i ++) {
        UIButton *button = _selectedButton[i];
        button.frame = CGRectMake(i * width, 0, width, self.bounds.size.height);
    }
    _lineLayer.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
}

/*
- (void)setCommentCount:(int)commentCount{
    _commentCount = commentCount;
    UIButton *button = [_selectedButton lastObject];
    [button setTitle:[NSString stringWithFormat:@"相关搭配(%d)", commentCount] forState:UIControlStateNormal];
}
*/
- (void)setSimilarityProductCount:(int)similarityProductCount
{
    _similarityProductCount = similarityProductCount;
    UIButton *button = _selectedButton[1];
    [button setTitle:[NSString stringWithFormat:@"相似单品(%d)", similarityProductCount]
            forState:UIControlStateNormal];
}

- (void)setCollocationProductCount:(int)collocationProductCount
{
    _collocationProductCount = collocationProductCount;
    UIButton *tempBtn = [_selectedButton lastObject];
    [tempBtn setTitle:[NSString stringWithFormat:@"相关搭配(%d)", collocationProductCount]
            forState:UIControlStateNormal];
}

#pragma mark - action
- (void)selectedButtonAction:(UIButton *)sender{
    int index = (int)sender.tag - 160;
    for (UIButton *button in _selectedButton) {
        button.selected = (sender == button);
    }
    CGPoint location = _selectedLineLayer.position;
    location.x = sender.centerX;
    _selectedLineLayer.position = location;
    if ([self.delegate respondsToSelector:@selector(productSelectedIndex:)]) {
        [self.delegate productSelectedIndex:index];
    }
}

- (void)setSelectedIndex:(int)selectedIndex{
    _selectedIndex = selectedIndex;
    [self selectedButtonAction:_selectedButton[selectedIndex]];
}

@end
