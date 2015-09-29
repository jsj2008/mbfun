//
//  StickerCollectionViewCell.m
//  StickerManager
//
//  Created by sdx on 15/4/21.
//  Copyright (c) 2015年 Unico. All rights reserved.
//

#import "StickerCollectionViewCell.h"

@implementation StickerCollectionViewCell

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    CGRect imgFrame = self.bounds;
    _imageView = [[UIImageView alloc] initWithFrame:imgFrame];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
    return self;
}

@end
