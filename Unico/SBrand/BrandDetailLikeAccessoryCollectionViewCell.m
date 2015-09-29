//
//  BrandDetailLikeAccessoryCollectionViewCell.m
//  Wefafa
//
//  Created by wave on 15/8/11.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "BrandDetailLikeAccessoryCollectionViewCell.h"
#import "SUtilityTool.h"
#import "BrandDetailCell.h"

@interface BrandDetailLikeAccessoryCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *btn;
- (IBAction)click:(id)sender;

@end

@implementation BrandDetailLikeAccessoryCollectionViewCell

- (void)setNumStr:(NSString *)numStr {
    /*
    NSString *num = numStr.length >= 3 ? numStr = [NSString stringWithFormat:@"%@.%@k", [numStr substringToIndex:1], [numStr substringWithRange:NSMakeRange(1, 1)]] : numStr;
    [_btn setTitle:num forState:UIControlStateNormal];
     */
    [_btn setTitle:numStr forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    // Initialization code
    [_btn setTitleColor:COLOR_C7 forState:UIControlStateNormal];
    _btn.titleLabel.font = FONT_t6;
}

- (IBAction)click:(id)sender {
//    NSInteger favCount = 0;
//    NSString *collId = @"";
//    if (dataModel) {
//        favCount = [dataModel.like_count integerValue];
//        collId = dataModel.idValue;
//    }else{
//        favCount = [self.cellData[@"like_count"] integerValue];
//        collId = self.cellData[@"id"];
//    }
//    
//    if (favCount > 0 && [collId length] > 0) {
//        SCollocationLoversController *loverController = [[SCollocationLoversController alloc] init];
//        loverController.collocationId = collId;
//        [self.parentVc.navigationController pushViewController:loverController animated:YES];
//    }
    ((BrandDetailCell*)_parentView).likeBlock();
}

@end
