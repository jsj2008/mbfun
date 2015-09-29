//
//  MBAddShoppingSizeCell.m
//  Wefafa
//
//  Created by Jiang on 5/13/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBAddShoppingSizeCell.h"
#import "MBGoodsDetailesSpecModel.h"
#import "Utils.h"
#import "SUtilityTool.h"

@interface MBAddShoppingSizeCell ()


@property (nonatomic, strong) CALayer *stockLayer;

@end

@implementation MBAddShoppingSizeCell

- (void)awakeFromNib {
    self.showSizeLabel.layer.borderColor = COLOR_C9.CGColor;
    self.showSizeLabel.layer.borderWidth = 0.5;
    self.showSizeLabel.textColor = COLOR_C6;
    self.showSizeLabel.font = FONT_t7;
    self.showSizeLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
}

- (void)setSelected:(BOOL)selected{
    
    [self setSelectedStatus:selected];
//    __unsafe_unretained typeof(self) p = self;
//    if (selected) {
//        [UIView animateWithDuration:0.15 animations:^{
//            p.showSizeLabel.transform = CGAffineTransformScale(p.transform, 0.95, 0.95);
//        } completion:^(BOOL finished) {
//            self.showSizeLabel.transform = CGAffineTransformIdentity;
//        }];
//    }
}

- (void)setSelectedStatus:(BOOL)selected{
    if (selected) {
        self.showSizeLabel.layer.borderWidth = 2.0;
        self.showSizeLabel.layer.borderColor = COLOR_C1.CGColor;
        self.showSizeLabel.font = FONT_T7;
    }else{
        self.showSizeLabel.layer.borderWidth = 0.5;
        self.showSizeLabel.layer.borderColor = COLOR_C9.CGColor;
        self.showSizeLabel.font = FONT_t7;
    }
    self.transform = CGAffineTransformIdentity;
}

/*
- (void)setContentSize:(NSString *)contentSize{
    _contentSize = contentSize;
    self.showSizeLabel.text = contentSize;
//    self.userInteractionEnabled = !contentModel.isUnStock;
//    if (contentModel.isUnStock) {
//        self.alpha = 0.2;
//    }else{
//        self.alpha = 1;
//    }
}
*/

@end
