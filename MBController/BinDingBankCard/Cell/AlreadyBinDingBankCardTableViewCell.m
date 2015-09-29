//
//  AlreadyBinDingBankCardTableViewCell.m
//  Wefafa
//
//  Created by Jiang on 2/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "AlreadyBinDingBankCardTableViewCell.h"
#import "MyBankCardModel.h"
#import "UIImageView+AFNetworking.h"
#import "SUtilityTool.h"

@interface AlreadyBinDingBankCardTableViewCell ()
{
    CGPoint locationPoint;
}

@property (weak, nonatomic) IBOutlet UIView *decorateView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *bankInfoContentView;

@end

@implementation AlreadyBinDingBankCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bankInfoContentView.layer.masksToBounds = YES;
    
    CALayer *layer = [CALayer layer];
    layer.zPosition = 5;
    layer.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5);
    layer.backgroundColor = COLOR_C9.CGColor;
    [_decorateView.layer addSublayer:layer];
    
    layer = [CALayer layer];
    layer.zPosition = 5;
    layer.frame = CGRectMake(0, 0.5, UI_SCREEN_WIDTH, 1);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [_decorateView.layer addSublayer:layer];
    
    _shadowView.layer.zPosition = -1;
    _shadowView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
    CGRect rect = _shadowView.bounds;
    rect.size.width *= UI_SCREEN_WIDTH/ 320;
    _shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRect:rect].CGPath;
    _shadowView.layer.shadowOffset = CGSizeMake(0, -2);
    _shadowView.layer.shadowOpacity = 1;
    
    CGRect frame = _typeLabel.frame;
    frame.origin.x *= UI_SCREEN_WIDTH/ 320;
    _typeLabel.frame = frame;
}

- (void)setMyBankCardModel:(MyBankCardModel *)myBankCardModel{
    _myBankCardModel = myBankCardModel;
    self.typeLabel.text = myBankCardModel.carD_TYPE;
    if (!myBankCardModel.carD_NO) {
        return;
    }
    NSMutableString *cardNumber = [NSMutableString string];
    for (int i = 0; i < myBankCardModel.carD_NO.length - 4; i++) {
        if ((i - myBankCardModel.carD_NO.length % 4) % 4 == 0) {
            [cardNumber appendString:@" "];
        }
        [cardNumber appendString:@"✻"];
    }
    [cardNumber appendString:@" "];
    NSRange range = NSMakeRange(myBankCardModel.carD_NO.length - 4, 4);
    [cardNumber appendString:[myBankCardModel.carD_NO substringWithRange:range]];
    self.lastNumberLabel.text = cardNumber;
    // 图片要与银行相匹配
//    _cardImgView setImage:[UIImage imageNamed:]
}

- (void)showBankImageOpen{
    CGRect frame = _bankInfoContentView.frame;
    self.layer.zPosition = 5;
    frame.origin.y = frame.size.height - self.cardImgView.frame.size.height - self.decorateView.frame.size.height;
    frame.size.height = _cardImgView.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bankInfoContentView.frame = frame;
    }completion:^(BOOL finished) {
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
