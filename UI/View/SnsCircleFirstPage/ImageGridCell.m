//
//  ImageGridCell.m
//  SelectionDelegateExample
//
//  Created by orta therox on 06/11/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ImageGridCell.h"
//#import "RoundHeadImageView.h"

@implementation ImageGridCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        UIView *background = [[UIView alloc] init];
//        background.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1.000 alpha:1.000];
//        self.selectedBackgroundView = background;
//
//        imgHeadBackground = [[UIImageView alloc] init];
//        imgHeadBackground.image = [UIImage imageNamed:@"头像底图.png"];
//        [self.contentView addSubview:imgHeadBackground];
//        
//        _image = [[RoundHeadImageView alloc] init];
//        _image.contentMode = UIViewContentModeScaleAspectFit;
//        [self.contentView addSubview:_image];
//
//        _label = [[UILabel alloc] init];
//        _label.textColor = [UIColor darkGrayColor];
//        _label.textAlignment = UITextAlignmentCenter;
//        _label.font=[UIFont systemFontOfSize:12.0];
//        _label.backgroundColor = [UIColor clearColor];
//        _label.numberOfLines = 1;
////        _label.lineBreakMode = UILineBreakModeCharacterWrap;
//
//        [self.contentView addSubview:_label];
        
        _backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 36, 36)];
        _backView.backgroundColor=[UIColor clearColor];
        
        _image = [[UIImageView alloc] init];
        _image.contentMode = UIViewContentModeScaleAspectFit;
        _image.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _image.image = [UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];//@"default_head_image.png"];
        [_backView addSubview:_image];
        
        _imgIcon = [[UIImageView alloc] init];
        _imgIcon.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_backView addSubview:_imgIcon];
        
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor darkGrayColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font=[UIFont systemFontOfSize:12.0];
        _label.backgroundColor = [UIColor clearColor];
        _label.numberOfLines = 1;
        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //        _label.lineBreakMode = UILineBreakModeCharacterWrap;
        
        [_backView addSubview:_label];
        
        [self.contentView addSubview:_backView];
    }
    return self;
}

//- (void)layoutSubviews {
////    UIEdgeInsets ContentInsets = { .left = GRIDCELL_MARGIN, .right = 2, .top = 8, .bottom = 0 };
////    CGFloat imageWidth = CGRectGetWidth(self.bounds) - ContentInsets.left - ContentInsets.right;
////    
////    imgHeadBackground.frame=CGRectMake(22, ContentInsets.top, 40, 40);
////    _image.frame = CGRectMake(22+1, ContentInsets.top+1, 40-2, 40-2);
////    _label.frame = CGRectMake(ContentInsets.left-6, _image.frame.size.height+ContentInsets.top+titleLableOffsetY, imageWidth+12, SubTitleLabelHeight);
//    
//    int imgwidth=40,imgheight=40;
//    int fontsize=12;
//    int h=imgheight+6+fontsize;
//    int w=66;
//    _offsetY=(60-h)/2;
//    
//    int imgx=(w-imgwidth)/2;
//    imgHeadBackground.frame=CGRectMake(imgx, _offsetY, imgwidth, imgheight);
//    _image.frame = CGRectInset(imgHeadBackground.frame, 1, 1);
//    int y=imgHeadBackground.frame.origin.y+imgHeadBackground.frame.size.height+6;
//    _label.frame = CGRectMake(0, y, w, fontsize);
//    
//    _backView.frame = CGRectMake(5, 5, _backView.frame.size.width, _backView.frame.size.height);
//}

//- (void)setHighlighted:(BOOL)highlighted {
//    NSLog(@"Cell %@ highlight: %@", _label.text, highlighted ? @"ON" : @"OFF");
//    if (highlighted) {
//        _label.backgroundColor = [UIColor yellowColor];
//    }
//    else {
//        _label.backgroundColor = [UIColor underPageBackgroundColor];
//    }
//}

@end
