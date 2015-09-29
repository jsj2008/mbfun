
//
//  STopicListTableViewCell.m
//  Wefafa
//
//  Created by unico_0 on 6/1/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "STopicListTableViewCell.h"
#import "StopicListModel.h"
#import "UIImageView+WebCache.h"
#import "StopicListModel.h"
#import "SCollocationDetailViewController.h"
#import "WeFaFaGet.h"
#import "LoginViewController.h"
#import "SCollocationDetailNoneShopController.h"

#import "SCollocationDetailNoShoppingScrollViewController.h"

@interface STopicListTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

static NSString *cellIdentifier = @"STopicListShowImageCollectionViewCellIdentifier";
@implementation STopicListTableViewCell

- (void)awakeFromNib {
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self; 
    [_contentCollectionView registerClass:[STopicListShowImageCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setContentModel:(StopicListModel *)contentModel{
    _contentModel = contentModel;
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.img]];
    [self.showTagImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.tag]];
    self.nameLabel.text = [NSString stringWithFormat:@"#%@", contentModel.name];
    
    CGRect frame = _showTagImageView.frame;
    frame.origin.x = _nameLabel.frame.origin.x + [contentModel.name sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}].width + 10;
    frame.origin.x = MIN(frame.origin.x, self.width - 75);
    _showTagImageView.frame = frame;
    
    self.descriptionLabel.text = contentModel.info;
    [self.contentCollectionView reloadData];
}

- (IBAction)nextButtonAction:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(topicTouchNextAction:contentModel:)]){
        [self.delegate topicTouchNextAction:sender contentModel:_contentModel];
    }
}

#pragma mark - collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentModel.collocation_list.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    STopicListShowImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    StopicListContentModel *model = _contentModel.collocation_list[indexPath.row];
    cell.contentModel = model;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    extern BOOL g_socialStatus;
    if (g_socialStatus)//是否处于社交状态
    {
        SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
        StopicListContentModel *model = _contentModel.collocation_list[indexPath.row];
        detailNoShoppingViewController.collocationId =  [NSString stringWithFormat:@"%@",model.aID];
        [self.parentVC.navigationController pushViewController:detailNoShoppingViewController animated:YES];
    }else {
        SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
        StopicListContentModel *model = _contentModel.collocation_list[indexPath.row];
        collocationDetailVC.collocationId =  [NSString stringWithFormat:@"%@",model.aID];
        [self.parentVC.navigationController pushViewController:collocationDetailVC animated:YES];
    }
}
@end

@implementation STopicListShowImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        _showImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _showImageView.layer.masksToBounds = YES;
        _showImageView.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        _showImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
        [self addSubview:_showImageView];
    }
    return self;
}

- (void)setContentModel:(StopicListContentModel *)contentModel{
    _contentModel = contentModel;
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
}

@end
