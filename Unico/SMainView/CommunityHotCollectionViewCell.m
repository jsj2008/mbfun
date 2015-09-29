//
//  CommunityHotCollectionViewCell.m
//  Wefafa
//
//  Created by wave on 15/8/20.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CommunityHotCollectionViewCell.h"

@interface CommunityHotCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img;

@end

@implementation CommunityHotCollectionViewCell

-(void)setUrlStr:(NSString *)urlStr {
    [self.img sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
}

- (void)awakeFromNib {
    // Initialization code
}

@end
