//
//  AlreadyBinDingBankCardTableViewCell.m
//  Wefafa
//
//  Created by Jiang on 2/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SimpleBinDingBankCardTableViewCell.h"
#import "MyBankCardModel.h"
#import "UIImageView+AFNetworking.h"

@interface SimpleBinDingBankCardTableViewCell ()
{
    CGPoint locationPoint;
}

@property (weak, nonatomic) IBOutlet UIView *bankCardContentView;
- (IBAction)rightDeleteButton:(UIButton *)sender;
- (IBAction)rightDefaultButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *rightDefaultButtonOutlet;

@end

@implementation SimpleBinDingBankCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setMyBankCardModel:(MyBankCardModel *)myBankCardModel{
    _myBankCardModel = myBankCardModel;
    self.cardNumberLabel.text = myBankCardModel.banK_NAME;
    self.typeLabel.text = myBankCardModel.carD_NAME;
    
    NSString *urlString = [NSString stringWithFormat:@"http://10.100.5.12/Stylistoriginal/bank/logoicon/%@.png", myBankCardModel.shorT_CODE];
    NSURL *url = [NSURL URLWithString:urlString];
    [self.cardImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    NSString *cardNumber = myBankCardModel.carD_NO;
    NSRange range = NSMakeRange(cardNumber.length - 4, 4);
    self.lastNumberLabel.text = [myBankCardModel.carD_NO substringWithRange:range];
    BOOL isDefault = [myBankCardModel.iS_DEFAULT boolValue];
    self.isDefaultLabel.hidden = !isDefault;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    locationPoint = [touch locationInView:self];
    
}

- (void)restatrState{
    CGRect rect = self.bankCardContentView.frame;
    rect.origin.x = 0;
    self.bankCardContentView.frame = rect;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat move_X = point.x - locationPoint.x;
    CGFloat moveTo_X = self.bankCardContentView.frame.origin.x + move_X;
    
    CGRect rect = self.bankCardContentView.frame;
    if (moveTo_X >= 0) {
        rect.origin.x = 0;
    }else if(moveTo_X <= -2 * self.rightDefaultButtonOutlet.frame.size.width){
        rect.origin.x = -2 * self.rightDefaultButtonOutlet.frame.size.width;
    }else{
        rect.origin.x = moveTo_X;
    }
    if (move_X != 0.0) {
        [self.delegate alreadyStartDrag];
    }
    self.bankCardContentView.frame = rect;
    locationPoint = point;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGFloat content_X = self.bankCardContentView.frame.origin.x;
    CGRect rect = self.bankCardContentView.frame;
    if (content_X > -self.rightDefaultButtonOutlet.frame.size.width) {
        rect.origin.x = 0;
    }else{
        rect.origin.x = -2 * self.rightDefaultButtonOutlet.frame.size.width;
    }
    __weak typeof(self) p = self;
    [UIView animateWithDuration:0.25 animations:^{
        p.bankCardContentView.frame = rect;
    }completion:^(BOOL finished) {
        [self.delegate alreadyEndDrag];
    }];
}

- (IBAction)rightDeleteButton:(UIButton *)sender {
    [self.delegate alreadyDeleteCellWithMode:self.myBankCardModel];
    [self restatrState];
}

- (IBAction)rightDefaultButton:(UIButton *)sender{
    [self.delegate alreadySettingDefalutCell:self.myBankCardModel];
}

@end
