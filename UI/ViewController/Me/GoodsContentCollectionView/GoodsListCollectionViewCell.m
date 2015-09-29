//
//  GoodsListCollectionViewCell.m
//  Wefafa
//
//  Created by Jiang on 3/20/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "GoodsListCollectionViewCell.h"
//#import "UIUrlImageView.h"
#import "UIImageView+AFNetworking.h"
#import "ImageInfo.h"
#import "Utils.h"
#import "AppSetting.h"
#import "UIUrlImageView.h"

@implementation GoodsListCollectionViewCell

- (void)awakeFromNib {
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=3.0;
//    self.contentView.backgroundColor = [UIColor yellowColor];
}

- (void)setContentModel:(ImageInfo *)contentModel{
    _contentModel = contentModel;
    
    if (self.cellType == goodsType) {
        self.goodsTitle.text = contentModel.product_name;
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",contentModel.price];
        
        
        NSString *priceString = [Utils getSNSRMBMoney:contentModel.market_price];
        NSString *salePriceString = [Utils getSNSRMBMoney:contentModel.price];
        if ([salePriceString isEqualToString:priceString]) {
            self.priceLabel.text = salePriceString;
        }else{
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", salePriceString, priceString]];
            [attributeString addAttributes:@{NSStrikethroughColorAttributeName: [Utils HexColor:0x919191 Alpha:1],
                                             NSForegroundColorAttributeName: [Utils HexColor:0x919191 Alpha:1],
                                             NSStrikethroughStyleAttributeName: @(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
                                             NSFontAttributeName: [UIFont systemFontOfSize:14]
                                             }range:NSMakeRange(salePriceString.length + 1, priceString.length)];
            self.priceLabel.attributedText = attributeString;
        }
    }else if(self.cellType == brandType)
    {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",contentModel.price];
        self.priceLabel.textColor=[Utils HexColor:0x333333 Alpha:1];
    }
    else
    {
        NSString *shardCount = [Utils getSNSInteger:contentModel.sharedCount];
        [self.goodsTitle setText:contentModel.descriptionStr];
        [self.shareCountButton setTitle:shardCount forState:UIControlStateNormal];
        [self.commentButton setTitle:contentModel.stockCount forState:UIControlStateNormal];
    }
    [self.likeButton setTitle:contentModel.favriteCount forState:UIControlStateNormal];
    [self.showOnlyLikeBtn  setTitle:contentModel.favriteCount forState:UIControlStateNormal];
    
    [self.brandImageView sd_setImageWithURL:[NSURL URLWithString:[Utils getSNSString:contentModel.brandUrl]] isLoadThumbnail:YES];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:[Utils getSNSString:contentModel.product_url]] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_MEDIUM]];
    self.likeButton.selected = contentModel.isFavorite.boolValue;
    self.showOnlyLikeBtn.selected = contentModel.isFavorite.boolValue;

//    [self.goodsImage downloadImageUrl:[Utils getSNSString:contentModel.thumbURL]
//                                        cachePath:[AppSetting getMBCacheFilePath]
//                                 defaultImageName:DEFAULT_LOADING_MEDIUM];
}

- (void)setCellType:(GoodsCellType)cellType{
    _cellType = cellType;
    CGRect frame = self.likeButton.frame;
    if (cellType == goodsType) {
        if (frame.origin.x == self.commentButton.frame.origin.x) {
            frame.origin.x = self.shareCountButton.frame.origin.x;
            frame.size.width = 65;
            self.likeButton.frame = frame;
        }
        self.shareCountButton.hidden = YES;
        self.priceLabel.hidden = NO;
        self.commentButton.hidden = YES;
        self.goodsTitle.hidden = NO;
        self.likeButton.hidden=YES;
    }else if(cellType == brandType)
    {
        if (frame.origin.x == self.commentButton.frame.origin.x) {
            frame.origin.x = self.shareCountButton.frame.origin.x;
            frame.size.width = 65;
            self.likeButton.frame = frame;
        }
        self.shareCountButton.hidden = YES;
        self.priceLabel.hidden = NO;
        self.commentButton.hidden = YES;
        self.goodsTitle.hidden = YES;
        self.likeButton.hidden=NO;
    }
    else if (cellType == mylikeType)
    {
        if (frame.origin.x == self.commentButton.frame.origin.x) {
            frame.origin.x = self.shareCountButton.frame.origin.x;
            frame.size.width = 65;
            self.likeButton.frame = frame;
        }
//喜欢的单品需要分享按钮时打开
//        self.shareCountButton.hidden = NO;
        self.priceLabel.hidden = YES;
//        self.commentButton.hidden = NO;
        self.commentButton.hidden = YES;
        self.goodsTitle.hidden = YES;
        self.likeButton.hidden=YES;
        self.showOnlyLikeBtn.hidden=NO;
    }else{
        if (frame.origin.x != 15) {
            frame.origin.x = 15;
            frame.size.width = 40;
            [self.likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
            self.likeButton.frame = frame;
        }
        self.shareCountButton.hidden = NO;
        self.priceLabel.hidden = YES;
        //        self.commentButton.hidden = NO;
        self.commentButton.hidden = YES;
        self.goodsTitle.hidden = NO;
        self.likeButton.hidden=NO;
        self.showOnlyLikeBtn.hidden=YES;
    }
}
/*
-(void)drawRect:(CGRect)rect
{
    
    
    CGContextRef
    context = UIGraphicsGetCurrentContext();
    
    
    //指定直线样式
    
    
    CGContextSetLineCap(context,
                        kCGLineCapSquare);
    
    
    //直线宽度
    
    
    CGContextSetLineWidth(context,
                          0.5f);
    
    
    //设置颜色
    
    NSArray * arr = [Utils rgbFromHexColor:0xE2E2E2 Alpha:1];
    float red = [(NSString*)arr[0] integerValue]/255.0f;
    float green = [(NSString*)arr[1] integerValue]/255.0f;
    float blue = [(NSString*)arr[2] integerValue]/255.0f;
    
    CGContextSetRGBStrokeColor(context,
                               red, green, blue, 1.0);
    //    cgcontextset
    
    //开始绘制
    
    
    CGContextBeginPath(context);
    
    
    //画笔移动到点(31,170)
    
    
    CGContextMoveToPoint(context,
                         self.bounds.size.width, 0);
    
    
    //下一点
    
    
    CGContextAddLineToPoint(context,
                            self.bounds.size.width, self.bounds.size.height);
    
    
    //下一点
    
    
    CGContextAddLineToPoint(context,
                            0, self.bounds.size.height);
    
    
    //绘制完成
    
    
    CGContextStrokePath(context);
    
    
}
*/
@end
