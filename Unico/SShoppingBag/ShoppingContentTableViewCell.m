//
//  ShoppingContentTableViewCell.m
//  Wefafa
//
//  Created by Jiang on 5/23/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "ShoppingContentTableViewCell.h"
#import "SUtilityTool.h"
#import "ShoppingBagContentModel.h"
#import "UIImageView+AFNetworking.h"
#import "Utils.h"

@interface ShoppingContentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showShoppingImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *seletedStateButton;
- (IBAction)selectedButtonAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *showPirceLabel;
@property (weak, nonatomic) IBOutlet UILabel *showGoodsCountLabel;

@property (weak, nonatomic) IBOutlet UIView *oprationContentView;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
- (IBAction)minusButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
- (IBAction)plusButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *showNumberLabel;

//-------------------------
@property (nonatomic, assign) int showNumber;

@end

@implementation ShoppingContentTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.oprationContentView.layer.borderColor = COLOR_C9.CGColor;
    self.oprationContentView.layer.borderWidth = 1.0;
    
    self.showNumberLabel.layer.borderColor = COLOR_C9.CGColor;
    self.showNumberLabel.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentModel:(ShoppingBagListModel *)contentModel{
    _contentModel = contentModel;
    self.titleLabel.text = contentModel.productInfo.proD_NAME;
    [self.showShoppingImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.productInfo.coloR_FILE_PATH]];
    self.showPirceLabel.text = [Utils getSNSMoney:[NSString stringWithFormat:@"%@", contentModel.productInfo.salE_PRICE]];
    self.showGoodsCountLabel.text = [NSString stringWithFormat:@"x%@", contentModel.cartInfo.qty];
    self.seletedStateButton.selected = contentModel.isSelected;
}

- (IBAction)minusButtonAction:(UIButton *)sender {
    _showNumber --;
    [self settingShowNumber];
}
- (IBAction)plusButtonAction:(UIButton *)sender {
    _showNumber ++;
    [self settingShowNumber];
}

- (void)settingShowNumber{
    if (_showNumber <= 0) {
        _showNumber = 0;
        _seletedStateButton.enabled = NO;
    }else{
        _seletedStateButton.enabled = YES;
    }
    self.showNumberLabel.text = [NSString stringWithFormat:@"%d", _showNumber];
}

- (IBAction)selectedButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _contentModel.isSelected = sender.selected;
}
@end
