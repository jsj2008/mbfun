//
//  SDiscoveryActivityShowPlayerView.m
//  Wefafa
//
//  Created by unico_0 on 7/23/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryActivityShowPlayerView.h"
#import "SProductDetailViewController.h"
#import "SActivityReceiveModel.h"
#import "SUtilityTool.h"

@interface SDiscoveryActivityShowPlayerView ()
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *pirceLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePirceLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyNowButton;
@property (weak, nonatomic) IBOutlet UILabel *surplusTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountCountLabel;
@property (weak, nonatomic) IBOutlet UIView *deleteLine;

@end

@implementation SDiscoveryActivityShowPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"SDiscoveryActivityShowPlayerView" owner:nil options:nil][0];
        self.frame = frame;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    _discountCountLabel.layer.cornerRadius = 3.0;
    _discountCountLabel.layer.masksToBounds = YES;
    
    _buyNowButton.layer.cornerRadius = 3.0;
    _buyNowButton.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentImageViewAction:)];
    [_contentImageView addGestureRecognizer:tap];
}

- (void)setContentModel:(SActivityProductListModel *)contentModel{
    _contentModel = contentModel;
    if (_activityEnd) {
        [_buyNowButton setTitle:@"活动结束" forState:UIControlStateDisabled];
        _buyNowButton.enabled = NO;
        _buyNowButton.backgroundColor = COLOR_C11;
        self.surplusTimeLabel.text = @"已结束";
    }else if ([contentModel.status intValue] != 2 || contentModel.stock_num.intValue <= 0) {
        [_buyNowButton setTitle:@"已售罄" forState:UIControlStateDisabled];
        _buyNowButton.enabled = NO;
        _buyNowButton.backgroundColor = COLOR_C11;
        self.surplusTimeLabel.text = @"已结束";
    }else{
        _buyNowButton.enabled = YES;
        _buyNowButton.backgroundColor = COLOR_C10;
        self.surplusTimeString = _surplusTimeString;
    }
    [_contentImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.product_url] placeholderImage:[UIImage imageNamed:@"pic_loading"]];
    _descriptionLabel.text = contentModel.product_name;
    _salePirceLabel.text= [Utils getSNSRMBMoney:[NSString stringWithFormat:@"%@", contentModel.price]];
    _pirceLabel.text = [Utils getSNSRMBMoney:contentModel.market_price];
    if (contentModel.market_price.floatValue == 0 || contentModel.price.floatValue == contentModel.market_price.floatValue) {
        _discountCountLabel.hidden = YES;
        _deleteLine.hidden = YES;
        _pirceLabel.hidden = YES;
    }else{
        _discountCountLabel.hidden = NO;
        _deleteLine.hidden = NO;
        _pirceLabel.hidden = NO;
        int discount = contentModel.price.floatValue/ contentModel.market_price.floatValue * 100;
        NSString *discountString;
        if(discount % 10 == 0){
            discountString = [NSString stringWithFormat:@" %d折  ", (int)discount/ 10];
        }else {
            discountString = [NSString stringWithFormat:@" %0.1f折  ", discount/ 10.0];
        }
        _discountCountLabel.text = discountString;
    }
}

- (void)setSurplusTimeString:(NSString *)surplusTimeString{
    _surplusTimeString = [surplusTimeString copy];
    if (_buyNowButton.enabled == NO) {
        self.surplusTimeLabel.text = @"已结束";
        return;
    }
    if ([surplusTimeString isEqualToString:@""]){
        self.surplusTimeLabel.text = @"";
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"剩余%@", surplusTimeString]];
    NSInteger firstCount = surplusTimeString.length - 10;
    if (firstCount > 0) {
        [attributeString addAttributes:@{NSForegroundColorAttributeName: COLOR_C10} range:NSMakeRange(2, firstCount)];
    }else{
        firstCount = 0;
    }
    for (int i = 0; i < (surplusTimeString.length - firstCount) / 3; i ++) {
        [attributeString addAttributes:@{NSForegroundColorAttributeName: COLOR_C10} range:NSMakeRange(3 + firstCount + i * 3, 2)];
    }
    self.surplusTimeLabel.attributedText = attributeString;
}

- (IBAction)buyNowButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(activityGoodsBuyNow:model:)]){
        [self.delegate activityGoodsBuyNow:sender model:_contentModel];
    }
}

- (void)contentImageViewAction:(UITapGestureRecognizer*)tap{
    if ([self.delegate respondsToSelector:@selector(activityGoodsTouchContentImage:model:)]){
        [self.delegate activityGoodsTouchContentImage:_contentImageView model:_contentModel];
    }
}

@end
