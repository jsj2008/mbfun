//
//  STagView.m
//  Wefafa
//
//  Created by chen cheng on 15/8/16.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "STagView.h"


@interface STagView()
{
    UIImageView *_bgImageView;
    
    UIImageView *_styleImageView;
    
    void (^_addTagBlock)(CGPoint point);
    
    UILabel *_titleLabel;
    NSString *_title;
    
    
    
    BOOL _flip;
    
    UIImageView *_smallDotAnimateImageView;//小圆点动画
    CGPoint _toPoint;
    
    CoverTagType _coverTagType;//单品，搭配师，话题，品牌等 兼容老版
    STagViewStyle _tagStyle;// 风格
}


@end

@implementation STagView


- (void)setTagStyle:(STagViewStyle)tagStyle
{
    _tagStyle = tagStyle;
    
    [self layoutSubviews];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = _title;
    
    [self layoutSubviews];
}

- (void)setFlip:(BOOL)flip
{
    [self setFlip:flip animated:NO];
}

- (void)setToPoint:(CGPoint)toPoint
{
    _toPoint = toPoint;
    [self layoutSubviews];
    
    NSLog(@"setToPoint toPoint.x = %f, toPoint.y = %f", toPoint.x, toPoint.y);
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    
    _toPoint = CGPointMake(_smallDotAnimateImageView.center.x + self.frame.origin.x, _smallDotAnimateImageView.center.y + self.frame.origin.y);
}


- (void)setFlip:(BOOL)flip animated:(BOOL)animated
{
    if (_flip == flip)
    {
        return;
    }
    
    _flip = flip;
    
    if (animated)
    {
        [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
        } completion:^(BOOL finished) {
        
        }];
    }
    
    [self layoutSubviews];
    _toPoint = CGPointMake(_smallDotAnimateImageView.center.x + self.frame.origin.x, _smallDotAnimateImageView.center.y + self.frame.origin.y);
}



- (void)initSubviews
{
    _bgImageView = [[UIImageView alloc] init];
    
    
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    
    UIImage *bgImage = [UIImage imageNamed:@"Unico/tag_arrow_left"];
    UIEdgeInsets insets = UIEdgeInsetsMake(bgImage.size.height/2.0, bgImage.size.width-5, bgImage.size.height/2.0, 5);
    _bgImageView.image = [bgImage resizableImageWithCapInsets:insets];
    _bgImageView.alpha = 1;
    [self addSubview:_bgImageView];
    
    _styleImageView = [[UIImageView alloc] init];
    _styleImageView.userInteractionEnabled = YES;
    [self addSubview:_styleImageView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_styleImageView addGestureRecognizer:tapGestureRecognizer];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:10];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _smallDotAnimateImageView = [[UIImageView alloc] init];
    _smallDotAnimateImageView.animationImages = @[[UIImage imageNamed:@"Unico/u_tag_1"], [UIImage imageNamed:@"Unico/u_tag_2"], [UIImage imageNamed:@"Unico/u_tag_3"], [UIImage imageNamed:@"Unico/u_tag_4"], [UIImage imageNamed:@"Unico/u_tag_5"], [UIImage imageNamed:@"Unico/u_tag_6"], [UIImage imageNamed:@"Unico/u_tag_7"], [UIImage imageNamed:@"Unico/u_tag_8"], ];
    _smallDotAnimateImageView.animationDuration = 1.5;
    [self addSubview:_smallDotAnimateImageView];
    
    [_smallDotAnimateImageView startAnimating];
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        [self initSubviews];
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGSize titleSize = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName: _titleLabel.font}];
    titleSize.width = titleSize.width + 15;
    
    if (titleSize.width < 30)//不能太短
    {
        titleSize.width = 30;
    }
    
    if (titleSize.width > UI_SCREEN_WIDTH - 60)//不能太长
    {
        titleSize.width = UI_SCREEN_WIDTH - 60;
    }
    
    float offsetX = 0;
    
    if (!_flip)//向左边
    {
        if (_tagStyle == STagViewStyleNone)
        {
            UIImage *bgImage = [UIImage imageNamed:@"Unico/tag_round_arrow_left"];
            UIEdgeInsets insets = UIEdgeInsetsMake(bgImage.size.height/2.0, bgImage.size.width-5, bgImage.size.height/2.0, 5);
            _bgImageView.image = [bgImage resizableImageWithCapInsets:insets];
            
            _styleImageView.backgroundColor = nil;
            _styleImageView.contentMode = UIViewContentModeScaleToFill;
            _styleImageView.image = nil;
        }
        else if (_tagStyle == STagViewStyleAdd)
        {
            UIImage *bgImage = [UIImage imageNamed:@"Unico/tag_arrow_left"];
            UIEdgeInsets insets = UIEdgeInsetsMake(bgImage.size.height/2.0, bgImage.size.width-5, bgImage.size.height/2.0, 5);
            _bgImageView.image = [bgImage resizableImageWithCapInsets:insets];
            
            
            _styleImageView.backgroundColor = nil;
            _styleImageView.contentMode = UIViewContentModeScaleToFill;
            _styleImageView.image = [UIImage imageNamed:@"Unico/add_tag_arrow_left"];
        }
        else if (_tagStyle == STagViewStyleClose)
        {
            UIImage *bgImage = [UIImage imageNamed:@"Unico/tag_arrow_left"];
            UIEdgeInsets insets = UIEdgeInsetsMake(bgImage.size.height/2.0, bgImage.size.width-5, bgImage.size.height/2.0, 5);
            _bgImageView.image = [bgImage resizableImageWithCapInsets:insets];
            
            
            _styleImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
            _styleImageView.contentMode = UIViewContentModeCenter;
            _styleImageView.image = [UIImage imageNamed:@"Unico/btn_tagdelete"];
        }
        else if (_tagStyle == STagViewStyleCart)
        {
            UIImage *bgImage = [UIImage imageNamed:@"Unico/tag_arrow_left"];
            UIEdgeInsets insets = UIEdgeInsetsMake(bgImage.size.height/2.0, bgImage.size.width-5, bgImage.size.height/2.0, 5);
            _bgImageView.image = [bgImage resizableImageWithCapInsets:insets];
            
            _styleImageView.backgroundColor = nil;
            _styleImageView.contentMode = UIViewContentModeScaleToFill;
            _styleImageView.image = [UIImage imageNamed:@"Unico/btn_gotocart_left"];
        }
        
    }
    else
    {
        if (_tagStyle == STagViewStyleNone)
        {
            UIImage *bgImage = [UIImage imageNamed:@"Unico/tag_round_arrow_right"];
            UIEdgeInsets insets = UIEdgeInsetsMake(bgImage.size.height/2.0, 5, bgImage.size.height/2.0, bgImage.size.width-5);
            _bgImageView.image = [bgImage resizableImageWithCapInsets:insets];
            
            _styleImageView.backgroundColor = nil;
            _styleImageView.contentMode = UIViewContentModeScaleToFill;
            _styleImageView.image = nil;
        }
        else if (_tagStyle == STagViewStyleAdd)
        {
            UIImage *bgImage = [UIImage imageNamed:@"Unico/tag_arrow_right"];
            UIEdgeInsets insets = UIEdgeInsetsMake(bgImage.size.height/2.0, 5, bgImage.size.height/2.0, bgImage.size.width-5);
            _bgImageView.image = [bgImage resizableImageWithCapInsets:insets];
            
            _styleImageView.backgroundColor = nil;
            _styleImageView.contentMode = UIViewContentModeScaleToFill;
            _styleImageView.image = [UIImage imageNamed:@"Unico/add_tag_arrow_right"];;
        }
        else if (_tagStyle == STagViewStyleClose)
        {
            UIImage *bgImage = [UIImage imageNamed:@"Unico/tag_arrow_right"];
            UIEdgeInsets insets = UIEdgeInsetsMake(bgImage.size.height/2.0, 5, bgImage.size.height/2.0, bgImage.size.width-5);
            _bgImageView.image = [bgImage resizableImageWithCapInsets:insets];
            
            _styleImageView.backgroundColor = _styleImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
            _styleImageView.contentMode = UIViewContentModeCenter;
            _styleImageView.image = [UIImage imageNamed:@"Unico/btn_tagdelete"];
        }
        else if (_tagStyle == STagViewStyleCart)
        {
            UIImage *bgImage = [UIImage imageNamed:@"Unico/tag_arrow_right"];
            UIEdgeInsets insets = UIEdgeInsetsMake(bgImage.size.height/2.0, 5, bgImage.size.height/2.0, bgImage.size.width-5);
            _bgImageView.image = [bgImage resizableImageWithCapInsets:insets];
            
            _styleImageView.backgroundColor = nil;
            _styleImageView.contentMode = UIViewContentModeScaleToFill;
            _styleImageView.image = [UIImage imageNamed:@"Unico/btn_gotocart_right"];
        }
    }

    
    if (!_flip) //指向左边
    {
        _smallDotAnimateImageView.frame = CGRectMake(offsetX, 0, 25, 25);
        offsetX += _smallDotAnimateImageView.frame.size.width;
        
        _bgImageView.frame = CGRectMake(offsetX, 0, titleSize.width+12, 25);
        _titleLabel.frame = CGRectMake(offsetX+12, 0, titleSize.width, 25);
        offsetX += _bgImageView.frame.size.width;
        
        
        _styleImageView.frame = CGRectMake(offsetX, 0, 25, 25);
        offsetX += _styleImageView.frame.size.width;
        
    }
    else //指向右边
    {
        _styleImageView.frame = CGRectMake(offsetX, 0, 25, 25);
        offsetX += _styleImageView.frame.size.width;
        
        _bgImageView.frame = CGRectMake(offsetX, 0, titleSize.width+12, 25);
        _titleLabel.frame = CGRectMake(offsetX, 0, titleSize.width, 25);
        offsetX += _bgImageView.frame.size.width;
        
        
        _smallDotAnimateImageView.frame = CGRectMake(offsetX, 0, 25, 25);
        offsetX += _smallDotAnimateImageView.frame.size.width;
    }
    
    [super setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, offsetX, 25)];
    
    if (self.flip)
    {
        self.center = CGPointMake((_toPoint.x + 25/2.0) - self.bounds.size.width/2.0, _toPoint.y);
    }
    else
    {
        self.center = CGPointMake((_toPoint.x - 25/2.0) + self.bounds.size.width/2.0, _toPoint.y);
    }
}


- (void)tap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (_addTagBlock != nil && _tagStyle == STagViewStyleAdd)
    {
        CGPoint point = CGPointMake(_smallDotAnimateImageView.center.x + self.frame.origin.x, _smallDotAnimateImageView.center.y + self.frame.origin.y);
        _addTagBlock(point);
    }
    else if (_closeTagBlock != nil && _tagStyle == STagViewStyleClose)
    {
        _closeTagBlock();
    }
    else if (_cartTagBlock != nil && _tagStyle == STagViewStyleCart)
    {
        _cartTagBlock();
    }
}





@end
