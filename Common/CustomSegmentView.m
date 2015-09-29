//
//  CustomSegmentView.m
//  Wefafa
//
//  Created by su on 15/1/28.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "CustomSegmentView.h"
#import "Utils.h"
#define kButtonTagBasic 100

@implementation CustomSegmentView{
    UIView *_selectView;
    NSNumber *selectNum;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5)];
        [line setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:line];
    }
    return self;
}

- (void)setItemsArr:(NSArray *)itemsArr
{
    if (itemsArr.count == 0) {
        return;
    }
    _itemsArr = itemsArr;
    NSInteger numCount = itemsArr.count;
    CGFloat strWidth = 0.0;
    for (int i = 0; i < numCount; i ++) {
        id value = [itemsArr objectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(self.frame.size.width/numCount * i, 0, self.frame.size.width/numCount,self.frame.size.height)];
        if ([value isKindOfClass:[UIImage class]]) {
            [btn setImage:value forState:UIControlStateNormal];
        } else {
            CGSize foundSize = [value sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 20)];
            [btn setTitle:value forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [btn setTitleColor:[Utils HexColor:0x919191 Alpha:1.0] forState:UIControlStateNormal];
            [btn setTitleColor:[Utils HexColor:0x333333 Alpha:1.0] forState:UIControlStateDisabled];
            if (selectNum && [selectNum integerValue] == i) {
                [btn setEnabled:NO];
            }
            
            if (foundSize.width > strWidth) {
                strWidth = foundSize.width;
            }
        }
        btn.tag = kButtonTagBasic + i;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    CGFloat selectWidth = (self.frame.size.width / numCount) /2;
    if (strWidth > selectWidth) {
        selectWidth = strWidth;
    }
    if (!_selectView) {
        _selectView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width / numCount - selectWidth)/2, self.frame.size.height - 4, selectWidth, 2)];
        [_selectView setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1.0]];
        [self addSubview:_selectView];
    }else {
        [_selectView setFrame:CGRectMake((self.frame.size.width / numCount - selectWidth)/2, self.frame.size.height - 4, selectWidth, 2)];
    }
    if (_selectBgColor) {
        [_selectView setBackgroundColor:_selectBgColor];
    }
    [self bringSubviewToFront:_selectView];
   
}

- (void)createSelectView
{
    _selectView = [[UIView alloc] initWithFrame:CGRectZero];
    [_selectView setBackgroundColor:[UIColor orangeColor]];
    [self addSubview:_selectView];
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    selectNum = [NSNumber numberWithInt:(int)selectIndex];
    if (_itemsArr.count <= 0) {
        return;
    }
    if (selectNum.integerValue >= _itemsArr.count) {
        return;
    }
    UIButton *btn = (UIButton *)[self viewWithTag:kButtonTagBasic + selectNum.integerValue];
    if (btn) {
        [btn setEnabled:NO];
    }
}

- (void)setSelectBgColor:(UIColor *)selectBgColor
{
    if (_selectView) {
        [self createSelectView];
    }
    [_selectView setBackgroundColor:selectBgColor];
}

- (void)buttonClick:(UIButton *)btn
{
    NSInteger arrayCount = _itemsArr.count;
    NSInteger index = btn.tag - kButtonTagBasic;
    CGFloat xPoint =  index * self.frame.size.width / arrayCount;
    [UIView animateWithDuration:0.2 animations:^{
        [_selectView setTransform:CGAffineTransformMakeTranslation(xPoint, 0)];
    }];
    
    [btn setEnabled:NO];
    for (int i = 0; i < arrayCount; i ++) {
        if (i != index) {
            UIButton *aBtn = (UIButton *)[self viewWithTag:kButtonTagBasic + i];
            [aBtn setEnabled:YES];
        }
    }
    if (_actionBlock) {
        _actionBlock(btn,index);
    }
}

@end
