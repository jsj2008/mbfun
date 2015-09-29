//
//  MBAddShoppingColorCell.m
//  Wefafa
//
//  Created by Jiang on 5/13/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBAddShoppingColorCell.h"
#import "MBGoodsDetailsColorModel.h"
#import "CommMBBusiness.h"
#import "SUtilityTool.h"
#import "Utils.h"

@interface MBAddShoppingColorCell ()


@end

@implementation MBAddShoppingColorCell

- (void)awakeFromNib {
    self.showColorImageView.layer.borderColor = COLOR_C9.CGColor;
    self.showColorImageView.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected{
    [self setSelectedStatus:selected];
    
//    __unsafe_unretained typeof(self) p = self;
//    if (selected) {
//        [UIView animateWithDuration:0.15 animations:^{
//            p.transform = CGAffineTransformScale(p.transform, 0.95, 0.95);
//        } completion:^(BOOL finished) {
//            self.transform = CGAffineTransformIdentity;
//        }];
//    }
}

- (void)setSelectedStatus:(BOOL)selected{
    if (selected) {
        self.showColorImageView.layer.borderWidth = 2.0;
        self.showColorImageView.layer.borderColor = COLOR_C1.CGColor;
    }else{
        self.showColorImageView.layer.borderWidth = 0.5;
        self.showColorImageView.layer.borderColor = COLOR_C9.CGColor;
    }
}

/*
- (void)setContentDic:(NSDictionary *)contentDic{
    _contentDic = contentDic;
    
    NSString *imageURL = [CommMBBusiness changeStringWithurlString:contentDic[@"coloR_FILE_PATH"]width:100 height:100];
    [self.showColorImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE] options:SDWebImageHighPriority];
    
//    if (contentModel.isUnStock) {
//        self.alpha = 0.2;
//    }else{
//        self.alpha = 1;
//    }
}
*/
@end
