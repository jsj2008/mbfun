//
//  SSearchProductCollectionViewCell.m
//  Wefafa
//
//  Created by unico_0 on 5/31/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SSearchProductCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "SSearchProductModel.h"
#import "SActivityBrandListModel.h"
#import "SCollocationSubProductModel.h"
#import "Utils.h"

@interface SSearchProductCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *pirceLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIImageView *showUserHeaderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *showBrandImageView;

//_----------
@property (nonatomic, strong) NSMutableArray *showTagImageArray;

@end



@implementation SSearchProductCollectionViewCell

- (UIImage *)productImage
{
    return self.showImageView.image;
}

- (void)awakeFromNib {
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = YES;
    _showImageView.layer.masksToBounds = YES;
    
    _showTagImageArray = [NSMutableArray array];
}

- (void)setIsShowPrice:(BOOL)isShowPrice{
    _isShowPrice = isShowPrice;
    self.showUserHeaderImageView.hidden = isShowPrice;
    self.pirceLabel.hidden = !isShowPrice;
    self.salePriceLabel.hidden = !isShowPrice;
}

- (void)setContentModel:(SSearchProductModel *)contentModel{
    _contentModel = contentModel;
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.mainImage] placeholderImage:[UIImage imageNamed:@"pic_loading"]];
    [self.showBrandImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.brandUrl]];
    
    [self setShowPirce:_contentModel.price.stringValue salePrice:_contentModel.sale_price.stringValue];
    self.descriptionLabel.text = contentModel.name;
    self.likeButton.selected = contentModel.isFavorite.boolValue;
    [self.likeButton setTitle:contentModel.favoriteCount.stringValue forState:UIControlStateNormal];
    [self.showUserHeaderImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
    
    [self showTagWithModelArray:contentModel.prodClsTag];
}

- (void)setBrandContentModel:(SActivityBrandListModel *)brandContentModel{
    _brandContentModel = brandContentModel;
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:brandContentModel.clsPicUrl]];
    [self setShowPirce:_brandContentModel.price.stringValue salePrice:_brandContentModel.markeT_PRICE.stringValue];
    self.descriptionLabel.text = brandContentModel.name;
    self.likeButton.selected = NO;
    [self.likeButton setTitle:brandContentModel.favoritE_COUNT.stringValue forState:UIControlStateNormal];
    [self.showUserHeaderImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
}

- (void)setProductInfoModel:(SCollocationSubProductInfoModel *)productInfoModel{
    _productInfoModel = productInfoModel;
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:productInfoModel.product_url] placeholderImage:[UIImage imageNamed:@"pic_loading"]];
    [self.showBrandImageView sd_setImageWithURL:[NSURL URLWithString:productInfoModel.brandUrl]];
    
    [self setShowPirce:productInfoModel.market_price salePrice:productInfoModel.price];
    self.descriptionLabel.text = productInfoModel.product_name;
    [self.showUserHeaderImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
    
    [self showTagWithModelArray:productInfoModel.prodClsTag];
}

- (void)showTagWithModelArray:(NSArray*)modelArray{
    if (modelArray.count > _showTagImageArray.count) {
        NSInteger count = modelArray.count - _showTagImageArray.count;
        for (int i = 0; i < count; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            [_showTagImageArray addObject:imageView];
            [self addSubview:imageView];
        }
    }
    for (UIImageView *imageView in _showTagImageArray) {
        imageView.hidden = YES;
    }
    [_showTagImageArray makeObjectsPerformSelector:@selector(setHidden:) withObject:@YES];
    for (int i = 0; i < modelArray.count; i++) {
        SSearchProductShowTagModel *model = modelArray[i];
        UIImageView *imageView = _showTagImageArray[i];
        imageView.hidden = NO;
        imageView.frame = CGRectMake(i * 25, 0, 25, 12);
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.tagUrl] placeholderImage:nil options:SDWebImageHighPriority];
    }
}

- (void)setShowPirce:(NSString *)price salePrice:(NSString *)salePrice{
    if (!salePrice) salePrice = price;
    NSString *priceString = [Utils getSNSRMBMoney:price];
    NSString *salePriceString = [Utils getSNSRMBMoney:salePrice];
    if ([salePrice isEqualToString:price]) {
        self.pirceLabel.text = @"";
    }else{
        self.pirceLabel.text = priceString;
    }
    
    self.salePriceLabel.text = salePriceString;
    return;
    
    if ([salePrice isEqualToString:price]) {
        self.pirceLabel.text = salePriceString;
    }else{
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", salePriceString, priceString]];
        [attributeString addAttributes:@{NSStrikethroughColorAttributeName: [Utils HexColor:0x919191 Alpha:1],
                                         NSForegroundColorAttributeName: [Utils HexColor:0x919191 Alpha:1],
                                         NSStrikethroughStyleAttributeName: @(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
                                         NSFontAttributeName: [UIFont systemFontOfSize:12]
                                         }range:NSMakeRange(salePriceString.length + 1, priceString.length)];
        self.pirceLabel.attributedText = attributeString;
    }
}

@end
