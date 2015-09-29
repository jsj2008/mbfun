//
//  MBMyGoodsContentCollectionViewCell.m
//  Wefafa
//
//  Created by Jiang on 4/1/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBMyGoodsContentCollectionViewCell.h"
#import "MBMyGoodsPersonalModel.h"
#import "UIImageView+AFNetworking.h"
#import "CommMBBusiness.h"
#import "Utils.h"

@interface MBMyGoodsContentCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabe;
@property (weak, nonatomic) IBOutlet UIButton *rightLikeButton;

@end

@implementation MBMyGoodsContentCollectionViewCell

- (void)awakeFromNib{
    self.titleLabel.textColor=[Utils HexColor:0x333333 Alpha:1];
}

- (void)setModel:(MBMyGoodsPersonalModel *)model{
    _model = model;
    UIImage *placeholderImage = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
    NSString *imageURL = nil;
    if (model.pictureUrl.length==0) {
        imageURL = [CommMBBusiness changeStringWithurlString:model.clsPicUrl width:300 height:300];
    }
    else
    {
        imageURL = [CommMBBusiness changeStringWithurlString:model.pictureUrl width:300 height:300];
    }
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:placeholderImage];
    self.titleLabel.text = model.aDescription;
    self.titleLabel.textColor=[Utils HexColor:0x919191 Alpha:1];
    if (model.aDescription.length == 0)
    {
      self.titleLabel.text = model.name;
    }
    NSString *likeString = [NSString stringWithFormat:@"%d", model.favoritCount.intValue];
    NSString *shareString = [NSString stringWithFormat:@"%d", model.sharedCount.intValue];
    [self.likeBtn setTitle:likeString forState:UIControlStateNormal];
    [self.rightLikeButton setTitle:likeString forState:UIControlStateNormal];
    
    [self.likeBtn setSelected:model.isFavorite.boolValue];
    [self.rightLikeButton setSelected:model.isFavorite.boolValue];
    
    [self.shareBtn setTitle:shareString forState:UIControlStateNormal];
    NSString *priceString = nil;
    priceString = [Utils getSNSMoney:model.sale_price];
    self.priceLabe.text = [NSString stringWithFormat:@"￥%@", priceString];
    [self setNeedsDisplay];
}

- (void)setShowPrice:(BOOL)showPrice{
    if (_showPrice == showPrice) {
        return;
    }
    _showPrice = showPrice;
    if (_showPrice) {
        self.priceLabe.hidden = NO;
        self.shareBtn.hidden = YES;
        self.likeBtn.hidden = YES;
        self.rightLikeButton.hidden = NO;
    }
    else
    {
        self.priceLabe.hidden = YES;
        self.shareBtn.hidden = NO;
        self.likeBtn.hidden = NO;
        self.rightLikeButton.hidden = YES;
    }
}

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

@end
