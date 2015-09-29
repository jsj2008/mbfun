//
//  SActivityDiscountTableViewCell.m
//  Wefafa
//
//  Created by unico_0 on 6/8/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SActivityDiscountTableViewCell.h"
#import "SActivityListModel.h"
#import "MBCollocationInfoModel.h"
#import "UIImageView+WebCache.h"
#import "SUtilityTool.h"
#import "MBGoodsDetailsModel.h"
#import "SActivityPromPlatModel.h"
#import "SActivityReceiveModel.h"

@interface SActivityDiscountTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentDesciptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *pirceLabel;
@property (weak, nonatomic) IBOutlet UILabel *privilegePirceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyNowButton;
- (IBAction)buyNowButtonAction:(UIButton *)sender;

@end

@implementation SActivityDiscountTableViewCell

- (void)awakeFromNib {
    
    _buyNowButton.layer.cornerRadius = 3.0;
    _buyNowButton.layer.masksToBounds = YES;
    
    _discountLabel.layer.cornerRadius = 2.0;
    _discountLabel.layer.masksToBounds = YES;
    
    _showImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchContentImageAction:)];
    [_showImageView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

}

- (void)setCollocationModel:(MBCollocationInfoModel *)collocationModel{
    _collocationModel = collocationModel;
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:collocationModel.thrumbnailUrl]];
    _contentDesciptionLabel.text = collocationModel.aDescription;
//    _pirceLabel.text = [NSString stringWithFormat:@"￥%@", collocationModel.amount];
    _pirceLabel.text =  [Utils getSNSRMBMoney:[NSString stringWithFormat:@"%@",  collocationModel.amount]];
    _privilegePirceLabel.hidden = YES;
}
-(void)setProductListModel:(SActivityProductListModel *)productListModel
{
    _productListModel = productListModel;
    NSString *status=[NSString stringWithFormat:@"%@",_productListModel.status];
     NSString *stock_num = [NSString stringWithFormat:@"%@",_productListModel.stock_num];
    if ([status intValue] != 2 || [stock_num intValue] <= 0) {
        _buyNowButton.selected = NO;
        _buyNowButton.enabled = NO;
        _buyNowButton.backgroundColor = COLOR_C11;
    }else if (_isActivityEnd) {
        _buyNowButton.enabled = YES;
        _buyNowButton.selected = YES;
        _buyNowButton.backgroundColor = COLOR_C11;
        _buyNowButton.userInteractionEnabled = NO;
    }else{
        _buyNowButton.enabled = YES;
        _buyNowButton.selected = NO;
        _buyNowButton.backgroundColor = COLOR_C1;
        _buyNowButton.userInteractionEnabled = YES;
    }
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:_productListModel.product_url] placeholderImage:[UIImage imageNamed:@"pic_loading"]];
    _contentDesciptionLabel.text = _productListModel.product_name;
    NSString *spec_price =[NSString stringWithFormat:@"%@", [_productListModel.spec_price_list  firstObject]];
    NSString *market_price = [NSString stringWithFormat:@"%@",_productListModel.market_price];
    
    _pirceLabel.text= [Utils getSNSRMBMoney:spec_price];// 实际价格
    [self addUnderline:[Utils getSNSRMBMoney:market_price]];//吊牌价
    if (spec_price.floatValue == market_price.floatValue) {
        _privilegePirceLabel.hidden = YES;
    }else{
        _privilegePirceLabel.hidden = NO;
    }
    
}
- (void)setGoodsModel:(MBGoodsDetailsModel *)goodsModel{
    _goodsModel = goodsModel;
    MBGoodsDetailsPictureModel *model = [goodsModel.clsPicUrl firstObject];
    if ([goodsModel.clsInfo.status intValue] != 2 || goodsModel.clsInfo.stockCount.intValue <= 0) {
        _buyNowButton.selected = NO;
        _buyNowButton.enabled = NO;
        _buyNowButton.backgroundColor = COLOR_C11;
    }else if (_isActivityEnd) {
        _buyNowButton.enabled = YES;
        _buyNowButton.selected = YES;
        _buyNowButton.backgroundColor = COLOR_C11;
        _buyNowButton.userInteractionEnabled = NO;
    }else{
        _buyNowButton.enabled = YES;
        _buyNowButton.selected = NO;
        _buyNowButton.backgroundColor = COLOR_C1;
        _buyNowButton.userInteractionEnabled = YES;
    }
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:model.filE_PATH] placeholderImage:[UIImage imageNamed:@"pic_loading"]];
    _contentDesciptionLabel.text = goodsModel.clsInfo.name;
    _pirceLabel.text= [Utils getSNSRMBMoney:[NSString stringWithFormat:@"%@", goodsModel.clsInfo.sale_price]];
    [self addUnderline:[Utils getSNSRMBMoney:[NSString stringWithFormat:@"%@",goodsModel.clsInfo.price]]];
    if (goodsModel.clsInfo.sale_price.floatValue == goodsModel.clsInfo.price.floatValue) {
        _privilegePirceLabel.hidden = YES;
    }else{
        _privilegePirceLabel.hidden = NO;
    }
}

- (void)setPromPlatModel:(SActivityPromPlatModel *)promPlatModel{
    if (_promPlatModel == promPlatModel) return;
    self.discountLabel.hidden = YES;
    _promPlatModel = promPlatModel;
    if(!promPlatModel.name || promPlatModel.name.length <= 0){
        self.discountLabel.hidden = YES;
    }else{
        self.discountLabel.hidden = NO;
        self.discountLabel.text = [NSString stringWithFormat:@" %@   ", promPlatModel.name];
    }
}

- (void)addUnderline:(NSString*)string{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributeString addAttributes:@{NSStrikethroughColorAttributeName: [Utils HexColor:0x919191 Alpha:1],
                                     NSForegroundColorAttributeName: [Utils HexColor:0x919191 Alpha:1],
                                     NSStrikethroughStyleAttributeName: @(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
                                     NSFontAttributeName: [UIFont systemFontOfSize:12]
                                     }range:NSMakeRange(0, string.length)];
    _privilegePirceLabel.attributedText = attributeString;
}

- (void)touchContentImageAction:(UITapGestureRecognizer*)tap{
    if ([self.delegate respondsToSelector:@selector(activityGoodsTouchContentImage:model:)]) {
        [self.delegate activityGoodsTouchContentImage:_showImageView model:_productListModel];
    }
    return;
    //只有商品和饭票其它没有
//    if (_collocationModel) {
//        if ([self.delegate respondsToSelector:@selector(activityCollocationTouchContentImage:model:)]) {
//            [self.delegate activityCollocationTouchContentImage:_showImageView model:_collocationModel];
//        }
//    }else if(_goodsModel){
//        if ([self.delegate respondsToSelector:@selector(activityGoodsTouchContentImage:model:)]) {
//            [self.delegate activityGoodsTouchContentImage:_showImageView model:_goodsModel];
//        }
//    }
}

- (IBAction)buyNowButtonAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(activityGoodsTouchContentImage:model:)]) {
        [self.delegate activityGoodsBuyNow:_buyNowButton model:_productListModel];
    }
    return;
    
//    if (_collocationModel) {
//        if ([self.delegate respondsToSelector:@selector(activityCollocationBuyNow:model:)]) {
//            [self.delegate activityCollocationBuyNow:_buyNowButton model:_collocationModel];
//        }
//    }else if(_goodsModel){
//        if ([self.delegate respondsToSelector:@selector(activityGoodsBuyNow:model:)]) {
//            [self.delegate activityGoodsBuyNow:_buyNowButton model:_goodsModel];
//        }
//    }
}
@end
