//
//  SearchTableViewCell.m
//  Wefafa
//
//  Created by su on 15/1/27.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "Utils.h"

@protocol kSearchCollocationSubViewDelegate <NSObject>

- (void)nkSearchCollocationHeaderImage:(id)model;
- (void)nkSearchCollocationCollocationImage:(id)model;

@end

#define kImageWidth 116
#define kImageHeight 120
#define kContentHeight 140
@interface SearchCellSubView : UIView
@property (nonatomic,strong)UIUrlImageView *imageView;
@property (nonatomic,strong)UIImageView *heartImg;//心型图片
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UILabel *nowPriceLabel;
@property (nonatomic,strong)UIImageView *headImage;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *countLabel;
@property (nonatomic,weak) id<kSearchCollocationSubViewDelegate> delegate;
@property (nonatomic,strong)SearchCollocationInfo *collocationModel;
@property (nonatomic,strong)SearchProduct *productModel;
@property (nonatomic)BOOL isCollocation;
@end

@implementation SearchCellSubView
- (id)initWithFrame:(CGRect)frame isCollocation:(BOOL)isCollocation
{
    self = [super initWithFrame:frame];
    [self setBackgroundColor:[UIColor whiteColor]];
    if (self) {
        _isCollocation = isCollocation;
        _imageView = [[UIUrlImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-40)];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCollocationImage)];
        [_imageView addGestureRecognizer:tapG];
        [self addSubview:_imageView];
        
        _heartImg = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 53, _imageView.frame.size.height + 14.5, 18, 15)];
        [_heartImg setImage:[UIImage imageNamed:@"btn_like_normal.png"]];
        [self addSubview:_heartImg];
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(_heartImg.frame.origin.x + 15 + 5, _imageView.frame.size.height + 10, 30, 20)];
        [_countLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_countLabel setTextAlignment:NSTextAlignmentCenter];
        [_countLabel setTextColor:[UIColor blackColor]];
        [self addSubview:_countLabel];
        
        if (isCollocation) {
            _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, _imageView.frame.size.height + 7, 27, 27)];
            [_headImage.layer setCornerRadius:27/2];
            [_headImage.layer setBorderColor:[UIColor whiteColor].CGColor];
            [_headImage.layer setBorderWidth:1.0];
            [_headImage.layer setMasksToBounds:YES];
            [_headImage setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderImage)];
            [_headImage addGestureRecognizer:tap];
            [self addSubview:_headImage];
            
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, _imageView.frame.size.height + 10, 60, 20)];
            [_nameLabel setTextColor:[UIColor blackColor]];
            [_nameLabel setTextAlignment:NSTextAlignmentLeft];
            [_nameLabel setFont:[UIFont systemFontOfSize:12]];
            [self addSubview:_nameLabel];
        } else {
            _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.frame.size.height+10, 80, 20)];
            [_priceLabel setTextAlignment:NSTextAlignmentCenter];
            [_priceLabel setTextColor:[UIColor grayColor]];
            [_priceLabel setAdjustsFontSizeToFitWidth:YES];
            [_priceLabel setAdjustsFontSizeToFitWidth:YES];
            [_priceLabel setFont:[UIFont systemFontOfSize:14]];
            [self addSubview:_priceLabel];
            
//            _nowPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, _imageView.frame.size.height+10, 50, 20)];
//            [_nowPriceLabel setTextAlignment:NSTextAlignmentCenter];
//            [_nowPriceLabel setTextColor:[UIColor redColor]];
//            [_nowPriceLabel setAdjustsFontSizeToFitWidth:YES];
//            [_nowPriceLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
//            [_nowPriceLabel setFont:[UIFont systemFontOfSize:13]];
//            [self addSubview:_nowPriceLabel];
        }
    }
    return self;
}

- (void)clearAllMessage
{
    [_imageView setImage:nil];
    [_heartImg setImage:nil];
    [_priceLabel setText:@""];
    [_headImage setImage:nil];
    [_nameLabel setText:@""];
//    [_nowPriceLabel setText:@""];
    [_countLabel setText:@""];
}

- (void)updateSingleProductWithInfo:(SearchProduct*)model
{
    if (!model) {
        [self clearAllMessage];
        return;
    }
    _productModel = model;

    if (!_heartImg.image) {
        [_heartImg setImage:[UIImage imageNamed:@"btn_like_normal"]];
    }
    NSString *urlStr = [Utils convertImageUrl:model.mainImageUrl WithFixedWidth:_imageView.size.width*2 height:_imageView.size.height*2];
    [self downloadImage:_imageView url:urlStr];
    [_priceLabel setText:[NSString stringWithFormat:@"¥ %0.2f",model.price]];
//    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥ %0.2f",model.price]];
//    NSRange contentRange = {0,[content length]};
//    [content addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
//    [content addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:contentRange];
//    [_nowPriceLabel setAttributedText:content];
    if (model.favortieCount>99) {
        [_countLabel setText:@"99+"];
        return;
    }
    [_countLabel setText:[NSString stringWithFormat:@"%ld",(long)model.favortieCount]];
}

- (void)updateSubViewWithInfo:(SearchCollocationInfo *)model
{
    _collocationModel = model;
    if (!model) {
        [self clearAllMessage];
        return;
    }
    if (!_heartImg.image) {
        [_heartImg setImage:[UIImage imageNamed:@"btn_like_normal@3x.png"]];
    }
    NSString *urlStr = [Utils convertImageUrl:model.pictureUrl WithFixedWidth:_imageView.size.width*2 height:_imageView.size.height*2];
    [self downloadImage:_imageView url:urlStr];
    NSDictionary *dict = [model.resultDict objectForKey:@"userPublicEntity"];
    [_headImage sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"headPortrait"]] placeholderImage:[UIImage imageNamed:@"default_header_image@2x.png"]];
    [_nameLabel setText:[dict objectForKey:@"nickName"]];
    if (model.favoriteCount>99) {
        [_countLabel setText:@"99+"];
        return;
    }
    [_countLabel setText:[NSString stringWithFormat:@"%ld",(long)model.favoriteCount]];

}

-(void)downloadImage:(UIUrlImageView* )imageView url:(NSString *)url
{
    NSString *defaultImg=@"home_cell_default@2x.png";
    if (imageView==nil) return;
    if (!url) {
        [imageView setImage:[UIImage imageNamed:defaultImg]];
        return;
    }

    if (!url || [url isEqual:[NSNull null]]) {
        [imageView setImage:[UIImage imageNamed:defaultImg]];
    } else{
        [imageView downloadImageUrl:[CommMBBusiness changeStringWithurlString:url size:SNS_IMAGE_ORIGINAL] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:defaultImg];
    }
}

- (void)tapHeaderImage
{
    if (_delegate && [_delegate respondsToSelector:@selector(nkSearchCollocationHeaderImage:)]) {
        if (_isCollocation) {
            if (_collocationModel)
                [_delegate nkSearchCollocationHeaderImage:_collocationModel];
        } else {
            if (_productModel)
                [_delegate nkSearchCollocationHeaderImage:_productModel];
        }
    }
}

- (void)tapCollocationImage
{
    if (_delegate && [_delegate respondsToSelector:@selector(nkSearchCollocationCollocationImage:)]) {
        if (_isCollocation) {
            if (_collocationModel) {
                [_delegate nkSearchCollocationCollocationImage:_collocationModel];
            }
        } else {
            if (_productModel) {
                [_delegate nkSearchCollocationCollocationImage:_productModel];
            }
        }
    }
}

@end

@interface SearchTableViewCell ()<kSearchCollocationSubViewDelegate>

@end

@implementation SearchTableViewCell{
    SearchCellSubView *leftView;
    SearchCellSubView *rightView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isCollocation:(BOOL)isCollocation
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor lightGrayColor]];
        leftView = [[SearchCellSubView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH/2-0.25, 169.5) isCollocation:isCollocation];
        [leftView setDelegate:self];
        [self.contentView addSubview:leftView];
        
        rightView = [[SearchCellSubView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2+0.25, 0, UI_SCREEN_WIDTH/2-0.25, 169.5) isCollocation:isCollocation];
        [rightView setDelegate:self];
        [self.contentView addSubview:rightView];
    }
    return self;
}

- (void)updateCellContentWithLeftModel:(SearchCollocationInfo *)leftModel rightModel:(SearchCollocationInfo *)rightModel
{
    
    [leftView updateSubViewWithInfo:leftModel];
    [rightView updateSubViewWithInfo:rightModel];
}
- (void)updateProducttWithLeftModel:(SearchProduct *)leftModel rightModel:(SearchProduct *)rightModel
{
    
    [leftView updateSingleProductWithInfo:leftModel];
    [rightView updateSingleProductWithInfo:rightModel];
}

- (void)nkSearchCollocationHeaderImage:(id)model
{
    if (_delegate && [_delegate respondsToSelector:@selector(kSearchCollocationCellHeaderImageClick:)])
    {
        [_delegate kSearchCollocationCellHeaderImageClick:model];
    }
}

- (void)nkSearchCollocationCollocationImage:(id)model
{
    if (_delegate && [_delegate respondsToSelector:@selector(kSearchCollocationCellCollocationImageClick:)])
    {
        [_delegate kSearchCollocationCellCollocationImageClick:model];
    }
}
@end
