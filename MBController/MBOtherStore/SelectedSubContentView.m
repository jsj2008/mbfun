//
//  SelectedSubContentView.m
//  Wefafa
//
//  Created by Jiang on 4/3/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SelectedSubContentView.h"
#import "Utils.h"
#import "SUtilityTool.h"
#import "SmineSelectedButton.h"

@interface SelectedSubContentView ()
{
    CGFloat _firstPoint_X;
    CGFloat _lastPoint_X;
}
@property (nonatomic, strong) UIView *decorateView;

//@property (nonatomic, strong) CAGradientLayer *backLayer;

@end

@implementation SelectedSubContentView

- (instancetype)initWithFrame:(CGRect)frame AndNameArray:(NSArray*)nameArray buttonType:(SelectedButtonType)buttonType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedButtonType = buttonType;
        self.buttonArray = [NSMutableArray array];
        if (nameArray != nil || nameArray.count != 0) {
            self.contentArray = nameArray;
            
        }
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame AndNameArray:(NSArray *)nameArray{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedButtonType = normalType;
        self.buttonArray = [NSMutableArray array];
        if (nameArray != nil || nameArray.count != 0) {
            self.contentArray = nameArray;
        }
    }
    return self;
}

- (void)setContentArray:(NSArray *)contentArray{
    
    if (contentArray == nil || contentArray.count == 0) {
        return;
    }else if (self.contentArray == contentArray){
        return;
    }else{
        _contentArray = contentArray;
        if (self.buttonArray.count > 0) {
            for (UIButton *button in self.buttonArray) {
                [button removeFromSuperview];
            }
            [self.buttonArray removeAllObjects];
        }
        
        [self addSelectedButtonWithNameArray];
        [self addDecorateState];
    }
    
}

//- (void)setBackgroundColor:(UIColor *)backgroundColor{
//    self.backLayer.frame = self.bounds;
//    self.backLayer.colors = @[(id)[backgroundColor colorWithAlphaComponent:1].CGColor,
//                              (id)[backgroundColor colorWithAlphaComponent:1].CGColor,
//                              (id)[backgroundColor colorWithAlphaComponent:0].CGColor];
//}

//- (CAGradientLayer *)backLayer{
//    if (!_backLayer) {
//        CAGradientLayer *layer = [CAGradientLayer layer];
//        layer.startPoint = CGPointMake(0.5, 0);
//        layer.endPoint = CGPointMake(0.5, 1);
//        layer.locations = @[@0, @0.9, @1];
//        [self.layer insertSublayer:layer atIndex:0];
//        _backLayer = layer;
//    }
//    return _backLayer;
//}

- (void)addDecorateState{
    CGFloat max_Width;
    if (!self.decorateView) {
        max_Width = 32;
        
        CGRect rect = CGRectMake(0, self.frame.size.height - 3, max_Width, 3);
        switch (_selectedButtonType) {
            case mineButtonImageType:
                rect = CGRectMake(0, self.frame.size.height - 3, max_Width, 3);
                break;
            default:{
                UIButton *btn=self.buttonArray[0];
                CGSize size =[btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}];
                rect = CGRectMake(0, self.frame.size.height - 3, size.width+10, 3);
            }
                break;
        }
        self.decorateView = [[UIView alloc]initWithFrame:rect];
        self.decorateView.layer.zPosition = 10;
        self.decorateView.backgroundColor = COLOR_C1;
        [self addSubview:self.decorateView];
       
    }
    
    CGRect frame = self.decorateView.frame;
    CGFloat button_Width = self.frame.size.width/ self.contentArray.count;
    _firstPoint_X = button_Width/ 2 - frame.size.width/ 2;
    _lastPoint_X =  (self.frame.size.width - button_Width/ 2) - frame.size.width/ 2;
    frame.origin.x = _firstPoint_X;
    self.decorateView.frame = frame;
}

- (void)addSelectedButtonWithNameArray{
    
    CGFloat button_Width = self.frame.size.width/ self.contentArray.count;
    for (int i = 0; i < self.contentArray.count; i++) {
        CGRect rect = CGRectMake(i * button_Width, 0, button_Width, self.frame.size.height);
        UIButton *button = nil;
        switch (_selectedButtonType) {
            case normalType:
                button = [[UIButton alloc]initWithFrame:rect];
                break;
            case mineButtonType:
                button = [[SmineSelectedButton alloc]initWithFrame:rect];
                break;
            default:
                button = [[UIButton alloc]initWithFrame:rect];
                break;
        }
        [button addTarget:self action:@selector(selectedButtonAcion:) forControlEvents:UIControlEventTouchDown];
        if (_selectedButtonType == mineButtonImageType) {
            UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
            
            [button addSubview:imageBtn];
//            userInteractionEnabled
            [imageBtn setUserInteractionEnabled:NO];
            imageBtn.center= CGPointMake(button.bounds.size.width/2,button.bounds.size.height/2);
            NSArray *imgAry=[self.contentArray[i] componentsSeparatedByString:@"|"];
            [imageBtn setImage:[UIImage imageNamed:imgAry[0]] forState:UIControlStateNormal];
            [imageBtn setImage:[UIImage imageNamed:imgAry[1]] forState:UIControlStateSelected];
        }else{
            button.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [button setTitleColor:COLOR_C2 forState:UIControlStateSelected];
            [button setTitleColor:COLOR_C6 forState:UIControlStateNormal];
            [button setTitle:self.contentArray[i] forState:UIControlStateNormal];
        }
        button.tag = 20 + i;
        [self addSubview:button];
        [self.buttonArray addObject:button];
    }
}

- (void)setLineLocationPercentage:(CGFloat)percentage{
    if (0 <= percentage && percentage <= 1) {
        CGRect decorationLayerFrame = self.decorateView.frame;
        decorationLayerFrame.origin.x = (_lastPoint_X - _firstPoint_X) * percentage + _firstPoint_X;
        self.decorateView.frame = decorationLayerFrame;
    }
    
}

- (void)scrollViewEndAction:(NSInteger)page{
    for (int i = 0; i < self.buttonArray.count; i ++) {
        UIButton *button = self.buttonArray[i];
        if (page == i) {
            self.decorateView.centerX = button.centerX;
            [button setSelected:YES];
        }else{
            [button setSelected:NO];
        }
        [self selectedImageBtn:button];
    }
    if ([self.delegate respondsToSelector:@selector(selectedSubContentViewSelectedIndex:)]) {
        [self.delegate selectedSubContentViewSelectedIndex:page];
    }
}

- (void)selectedButtonAcion:(UIButton*)sender{
    if ([sender isSelected]) return;
    for (UIButton *button in self.buttonArray) {
        [button setSelected:button.tag == sender.tag? YES: NO];
        [self selectedImageBtn:button];
        if (_isShowAnimation) {
            if (button.tag == sender.tag) {
                [UIView animateWithDuration:0.15 animations:^{
                    CGPoint point = self.decorateView.center;
                    point.x = button.centerX;
                    self.decorateView.center = point;
                }];
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(selectedSubContentViewSelectedIndex:)]) {
        [self.delegate selectedSubContentViewSelectedIndex:sender.tag - 20];
    }
}

-(void)selectedImageBtn:(UIButton*)btn{
    for (UIView *subView in btn.subviews)
    {
        if([subView isMemberOfClass:[UIButton class]])
        {
            UIButton *subBtn=(UIButton*)subView;
            [subBtn setSelected:btn.selected];
        }
    }
}
@end
