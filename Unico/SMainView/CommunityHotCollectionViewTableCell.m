//
//  CommunityHotCollectionViewTableCell.m
//  Wefafa
//
//  Created by wave on 15/8/17.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CommunityHotCollectionViewTableCell.h"
#import "SUtilityTool.h"
#import "Utils.h"
#import "CommunityHotCollectionViewCell.h"
#import "StopicListModel.h"

@interface CommunityHotCollectionViewTableCell () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *contentViewInfo;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImg;
@property (weak, nonatomic) IBOutlet UILabel *attendLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attendImg;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *grayView;

@property (nonatomic) NSArray *dataArray;
@property (nonatomic, weak) UIViewController *target;
@end

@implementation CommunityHotCollectionViewTableCell
- (void)setmodel:(StopicListModel*)model parentVC:(UIViewController*)target {
    self.target = target;
    self.model = model;
    self.dataArray = model.collocation_list;
    [self.collectionView reloadData];
    
    [_titleLabel setText:[NSString stringWithFormat:@"#%@", model.name]];
    [_titleImg sd_setImageWithURL:[NSURL URLWithString:model.tag]];
    [_attendLabel setText:[NSString stringWithFormat:@"%@人参与", model.collocation_count]];
    
    [_titleImg setCenterY:_maskView.centerY];
    [_titleLabel sizeToFit];
    CGRect frame = _titleImg.frame;
    frame.origin.x = _titleLabel.frame.origin.x + [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName: FONT_t6}].width + 5;
    frame.origin.x = MIN(frame.origin.x, self.width - 75);
    _titleImg.frame = frame;
    
    [_attendImg sizeToFit];
    [_attendLabel sizeToFit];
    [_attendImg setRight:UI_SCREEN_WIDTH - 10];
    [_attendLabel setRight:_attendImg.left - 5];
    
    [_titleLabel setCenterY:_titleImg.centerY];
    [_attendLabel setCenterY:_titleImg.centerY];
    [_attendImg setCenterY:_titleImg.centerY];
}
/*
- (void)setmodel:(CommunityHotCollectionModel*)model parentVC:(UIViewController*)target {
    self.target = target;
    self.model = model;
    self.dataArray = model.collocation_list;
    [self.collectionView reloadData];
    
//    [_titleLabel setText:[NSString stringWithFormat:@"#%@", model.name]];
//    [_titleImg sd_setImageWithURL:[NSURL URLWithString:model.tag]];
//    [_attendLabel setText:[NSString stringWithFormat:@"%@人参与", model.collocation_count]];
    
    [_titleLabel setText:[NSString stringWithFormat:@"#%@", model.nick_name]];
//    [_titleImg sd_setImageWithURL:[NSURL URLWithString:model.tag]];
    [_attendLabel setText:[NSString stringWithFormat:@"%@人参与", model.collocationCount]];
    
    [_titleImg setCenterY:_maskView.centerY];
    [_titleLabel sizeToFit];
    CGRect frame = _titleImg.frame;
    frame.origin.x = _titleLabel.frame.origin.x + [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName: FONT_t6}].width + 5;
    frame.origin.x = MIN(frame.origin.x, self.width - 75);
    _titleImg.frame = frame;
    
    [_attendImg sizeToFit];
    [_attendLabel sizeToFit];
    [_attendImg setRight:UI_SCREEN_WIDTH - 10];
    [_attendLabel setRight:_attendImg.left - 5];
    
    [_titleLabel setCenterY:_titleImg.centerY];
    [_attendLabel setCenterY:_titleImg.centerY];
    [_attendImg setCenterY:_titleImg.centerY];
}
*/
- (void)awakeFromNib {
    // Initialization code
    //maskView
    _maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [_maskView addGestureRecognizer:tap];
    //titleLabel
    [_titleLabel setFont:FONT_t6];
    [_titleLabel setTextColor:COLOR_C2];
    //_titleImg
    [_titleImg setContentMode:UIViewContentModeScaleAspectFit];
    //grayView
    [_grayView setBackgroundColor:[Utils HexColor:0xf2f2f2 Alpha:1]];
    //attendImg
    [_attendImg setImage:[UIImage imageNamed:@"Unico/arrow_address.png"]];
    //attendLabel
    [_attendLabel setFont:FONT_t7];
    [_attendLabel setTextColor:COLOR_C6];
    //collectionView
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"CommunityHotCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:communityHotCollectionViewCellID];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    //_collectionView
    CGRect rect = _collectionView.frame;
    rect.origin.y = 5;
    rect.size.height = 92 * SCALE_UI_SCREEN;
    _collectionView.frame = rect;
    //_contentViewInfo
    rect = _contentViewInfo.frame;
    rect.origin.y = _collectionView.bottom;
    _contentViewInfo.frame = rect;
    //titleImg
    rect = _titleImg.frame;
    rect.size.width = rect.size.width * SCALE_UI_SCREEN;
    rect.size.height = rect.size.height * SCALE_UI_SCREEN;
    _titleImg.frame = rect;
    //_grayView
    rect = _grayView.frame;
    rect.origin.y = _contentViewInfo.bottom;
    _grayView.frame = rect;
}

- (void)tap {
    if (self.jumpBlock) {
        self.jumpBlock(self.model);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CommunityHotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:communityHotCollectionViewCellID forIndexPath:indexPath];
    StopicListContentModel *model = self.dataArray[indexPath.row];
    cell.urlStr = model.img;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = 92 * SCALE_UI_SCREEN;
    CGFloat height = 92 * SCALE_UI_SCREEN;
    return CGSizeMake(width, height);
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5 * SCALE_UI_SCREEN;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    StopicListContentModel *model = self.dataArray[indexPath.row];
    if (self.jumpToCollBlock) {
        self.jumpToCollBlock(model);
    }
}

@end
