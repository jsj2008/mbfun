//
//  MBAddShoppingProductNumberView.m
//  Wefafa
//
//  Created by su on 15/5/16.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "MBAddShoppingProductNumberView.h"
#import "Utils.h"
#import "SUtilityTool.h"

@interface MBAddShoppingProductNumberView ()

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *stockLabel;
@end

@implementation MBAddShoppingProductNumberView

- (void)awakeFromNib{
    [self initSubViews];
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = COLOR_C9.CGColor;
    self.layer.borderWidth = 0.5;
}

- (void)initSubViews{
    self.number = 1;
    CGRect frame = CGRectMake(0, 0, 30, 30);
    
    _leftButton = [[UIButton alloc]initWithFrame:frame];
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:21];
    [_leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _leftButton.contentEdgeInsets = UIEdgeInsetsMake(14, 11, 14, 11);
    [_leftButton setImage:[UIImage imageNamed:@"Unico/btn_minus_black"] forState:UIControlStateNormal];
    _leftButton.enabled = NO;
//    [_leftButton setTitleColor:[Utils HexColor:0x3b3b3b Alpha:1] forState:UIControlStateNormal];
//    [_leftButton setTitleColor:[Utils HexColor:0xe2e2e2 Alpha:1] forState:UIControlStateDisabled];
    [self addSubview:_leftButton];
    
    frame.origin.x = CGRectGetMaxX(frame);
    frame.size.width = self.frame.size.width - 60;
    _centerField = [[UITextField alloc]initWithFrame:frame];
    _centerField.text = @"1";
    _centerField.layer.borderColor = [Utils HexColor:0xe2e2e2 Alpha:1].CGColor;
    _centerField.layer.borderWidth = 0.5;
    _centerField.font = [UIFont systemFontOfSize:12];
    _centerField.textColor = [Utils HexColor:0x3b3b3b Alpha:1];
    _centerField.textAlignment = NSTextAlignmentCenter;
    _centerField.keyboardType = UIKeyboardTypeNumberPad;
    _centerField.clearsOnBeginEditing = YES;
    _centerField.userInteractionEnabled = NO;
    [self addSubview:_centerField];
    
    frame.origin.x = CGRectGetMaxX(frame);
    frame.size.width = 30;
    _rightButton = [[UIButton alloc]initWithFrame:frame];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:22];
    [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.contentEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11);
    [_rightButton setImage:[UIImage imageNamed:@"Unico/btn_plus"] forState:UIControlStateNormal];
//    [_rightButton setTitleColor:[Utils HexColor:0x3b3b3b Alpha:1] forState:UIControlStateNormal];
//    [_rightButton setTitleColor:[Utils HexColor:0xe2e2e2 Alpha:1] forState:UIControlStateDisabled];
    [self addSubview:_rightButton];
    
//    _leftButton.enabled = NO;
//    _rightButton.enabled = NO;
}

- (void)leftButtonAction:(UIButton*)button{
    [UIView animateWithDuration:0.15 animations:^{
        button.transform = CGAffineTransformScale(button.transform, 1.5, 1.5);
    } completion:^(BOOL finished) {
        button.transform = CGAffineTransformIdentity;
    }];
    self.number = _number -= 1;
    [self checkState];
}

- (void)rightButtonAction:(UIButton*)button{
    [UIView animateWithDuration:0.15 animations:^{
        button.transform = CGAffineTransformScale(button.transform, 1.5, 1.5);
    } completion:^(BOOL finished) {
        button.transform = CGAffineTransformIdentity;
    }];
    self.number = _number += 1;
    [self checkState];
}

- (void)checkState{
    if(_stockCount <= 1) {
        self.isEdit = NO;
        return;
    }
    if (_number <= 1) {
        self.number = 1;
        _centerField.text = @"1";
        _leftButton.enabled = NO;
    }else{
        _leftButton.enabled = YES;
    }
    if(_number >= MIN(_stockCount, 20)){
        self.number = MIN(_stockCount, 20);
        _centerField.text = [NSString stringWithFormat:@"%d", MIN(_stockCount, 20)];
        _rightButton.enabled = NO;
    }else{
        _rightButton.enabled = YES;
        _centerField.text = [NSString stringWithFormat:@"%d", self.number];
    }
}

- (void)setNumber:(int)number{
    _number = number;
    if (number > 1) {
        _leftButton.enabled = YES;
    }
    if (number < MIN(_stockCount, 20)) {
        _rightButton.enabled = YES;
    }
    _centerField.text = [NSString stringWithFormat:@"%d", number];
    if ([self.delegate respondsToSelector:@selector(shoppingProductNumberChange:)]) {
        [self.delegate shoppingProductNumberChange:self.number];
    }
}

- (void)setStockCount:(int)stockCount{
    _stockCount = stockCount;
    _stockLabel.text = [NSString stringWithFormat:@"库存：%d件", stockCount];
    if (stockCount <= 1){
        self.isEdit = NO;
    }
}

- (void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    if (isEdit) {
        _rightButton.enabled = YES;
//        _centerField.userInteractionEnabled = YES;
    }else{
        _leftButton.enabled = NO;
        _rightButton.enabled = NO;
//        _centerField.userInteractionEnabled = NO;
        _centerField.text = @"1";
        self.number = 1;
    }
    
}

@end
