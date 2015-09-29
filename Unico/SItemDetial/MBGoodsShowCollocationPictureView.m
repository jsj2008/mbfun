//
//  MBGoodsShowCollocationPictureView.m
//  Wefafa
//
//  Created by Jiang on 5/6/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBGoodsShowCollocationPictureView.h"
#import "UIImageView+AFNetworking.h"
#import "MBCollocationInfoModel.h"
#import "Utils.h"

@interface MBGoodsShowCollocationPictureView ()

//-----搭配图片
@property (strong, nonatomic) NSMutableArray *collocationPictureImageViewArray;

@end

@implementation MBGoodsShowCollocationPictureView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchSelectedIndex:)];
    [self addGestureRecognizer:tap];
    
    self.backgroundColor = [UIColor clearColor];
    CGFloat origin_X = (UI_SCREEN_WIDTH - 2) / 3;
    CGRect rect = CGRectMake(0, 0, origin_X, self.size.height);
    for (int i = 0; i < 3; i++) {
        rect.origin.x = (origin_X + 1) * i;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        [self.collocationPictureImageViewArray addObject:imageView];
    }
}

- (void)setContentModelArray:(NSArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    if (!contentModelArray || contentModelArray.count == 0) {
        UILabel *label = [[UILabel alloc]initWithFrame:self.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [Utils HexColor:0x919191 Alpha:1];
        label.text = @"暂无相关搭配!";
        label.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:label];
        return;
    }
    UIImage *image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
    for (int i = 0; i < MIN(contentModelArray.count, 3); i++) {
        UIImageView *imageView = self.collocationPictureImageViewArray[i];
        MBCollocationInfoModel *model = contentModelArray[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.pictureUrl] placeholderImage:image];
    }
    [self setNeedsDisplay];
}

- (NSMutableArray *)collocationPictureImageViewArray{
    if (!_collocationPictureImageViewArray) {
        _collocationPictureImageViewArray = [NSMutableArray array];
    }
    return _collocationPictureImageViewArray;
}

- (void)touchSelectedIndex:(UITapGestureRecognizer*)tap{
    CGPoint location = [tap locationInView:self];
    int index = location.x / (self.frame.size.width/ 3);
    if (index >= _contentModelArray.count) return;
    if ([self.delegate respondsToSelector:@selector(showCollocationViewSelectedIndex:)]) {
        [self.delegate showCollocationViewSelectedIndex:index];
    }
}

- (void)drawRect:(CGRect)rect{
    CGFloat origin_X = (UI_SCREEN_WIDTH - 2) / 3;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [Utils HexColor:0xe2e2e2 Alpha:1].CGColor);
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextSetLineWidth(context, 0.5);
    
    CGContextBeginPath(context);
    
    for (int i = 1; i < self.contentModelArray.count; i++) {
        CGContextMoveToPoint(context, (origin_X + 0.5) * i, 0);
        CGContextAddLineToPoint(context, (origin_X + 0.5) * i, self.size.height - 1);
    }
    
    CGContextMoveToPoint(context, 0, self.size.height - 1);
    CGContextAddLineToPoint(context, self.size.width, self.size.height - 1);
    
    CGContextDrawPath(context, kCGPathStroke);
}

@end
