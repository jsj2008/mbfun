//
//  BrandDetailTemptCollectionViewCell.m
//  Wefafa
//
//  Created by wave on 15/8/19.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "BrandDetailTemptCollectionViewCell.h"
#import "SContentOnePageCell.h"
#import "SMDataModel.h"
#import "BrandDetailViewController.h"

extern NSString *brandproductCellIdentifier;

@interface BrandDetailTemptCollectionViewCell () <kMainViewCellDelegate>

@property (nonatomic)SContentOnePageCell *cellll;
@property (nonatomic, strong) SMDataModel *contentModel;
//@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation BrandDetailTemptCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _cellll = [[SContentOnePageCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:brandproductCellIdentifier];
        __weak BrandDetailTemptCollectionViewCell *weakSelf = self;
        _cellll.isLikeBlock = ^(BOOL isLike){
            if (weakSelf.isLikeBlock) {
                weakSelf.isLikeBlock(isLike);
            }
        };
        _cellll.tag = 4505;
        _cellll.contentView.userInteractionEnabled = YES;
        _cellll.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:_cellll.contentView];
//        _contentLabel = [[UILabel alloc]init];
//        _contentLabel.font = [UIFont systemFontOfSize:15];
//        _contentLabel.textColor = UIColorFromRGB(0x3b3b3b);
//        [_cellll.contentView addSubview:_contentLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!_contentModel) return;
    _cellll.contentView.frame = self.bounds;
//    CGSize labelSize = [_contentModel.content_info boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |
//                 NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
//    _contentLabel.frame = CGRectMake(10, _cellll.p_likePeopleView.top - labelSize.height - 10, UI_SCREEN_WIDTH - 20, labelSize.height);
}

- (void)setDelegate:(id<kMainViewCellDelegate>)delegate {
    _cellll.delegate = delegate;
}

- (void)setParentVc:(UIViewController *)parentVc {
    _cellll.parentVc = parentVc;
}

- (void)updateCellUIWithModel:(SMDataModel *)model atIndex:(NSIndexPath *)indexPath {
    _contentModel = model;
//    _contentLabel.text = model.content_info;
    [_cellll updateCellUIWithModel:model atIndex:indexPath.row];
}

@end
