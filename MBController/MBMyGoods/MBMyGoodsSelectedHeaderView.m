//
//  MBMyGoodsSelectedHeaderView.m
//  Wefafa
//
//  Created by Jiang on 4/1/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#define kButtonTag 30

#import "MBMyGoodsSelectedHeaderView.h"
#import "NoneHeightLightButton.h"
#import "Utils.h"

@interface MBMyGoodsSelectedHeaderView ()

@property (nonatomic, strong) NSMutableArray *selectedButtonArray;

@end

@implementation MBMyGoodsSelectedHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedButtonArray = [NSMutableArray array];
        [self addSubViewWithSelectedButtonCount:3];
//        self.backgroundColor = [Utils HexColor:0xE2E2E2 Alpha:1];
        
    }
    return self;
}

- (void)addSubViewWithSelectedButtonCount:(int)count{
    NSArray *array = @[@"原创", @"分享搭配", @"分享单品"];
    CGFloat button_Width = self.frame.size.width/ count;
    for (int i = 0; i < count; i++) {
        CGRect rect = CGRectMake(button_Width * i, 0, button_Width, 44-0.5);
//        NoneHeightLightButton *button = [[NoneHeightLightButton alloc]initWithFrame:rect];
        NoneHeightLightButton *button = [[NoneHeightLightButton alloc]initWithFrame:rect];
        
        [button addTarget:self action:@selector(selectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//        [button setTitle:array[i] forState:UIControlStateNormal];
        button.textLabel.text=array[i];
        button.rightLineImgView.hidden=NO;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.tag = i + kButtonTag;
        [self.selectedButtonArray addObject:button];
        [self addSubview:button];
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15.0, 40, self.frame.size.width - 30.0, self.frame.size.height - 40.0)];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.text = @"小贴士：您分享自己或者他人的搭配产生购买时，可以获得不同的分成";
    label.font = [UIFont systemFontOfSize:12.0];
//    [self addSubview:label];
    UIImageView *lineImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
    [lineImgV setBackgroundColor:[Utils HexColor:0xE2E2E2 Alpha:1]];
    [self addSubview:lineImgV];
    
}

- (void)selectedButtonAction:(UIButton*)button{
    if ([self.delegate respondsToSelector:@selector(goodsSelectedButtonIndex:)]) {
        [self.delegate goodsSelectedButtonIndex:(int)button.tag - kButtonTag];
    }
}

- (void)selectedButtonForIndex:(int)index{
    for (NoneHeightLightButton *button in self.selectedButtonArray) {
        if (button.tag == index + kButtonTag) {
            [button setSelected:YES];
        }else{
            [button setSelected:NO];
        }
    }
}

@end
