//
//  PersonalInformationCollectionViewCollectionViewCell.m
//  Designer
//
//  Created by Jiang on 1/19/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "PersonalInformationCollectionViewCell.h"

@interface PersonalInformationCollectionViewCell ()

//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
//发布时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//评论数
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
//喜欢人数
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@end

@implementation PersonalInformationCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

@end
