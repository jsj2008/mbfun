//
//  SMyTopicCollectionViewCell.m
//  Wefafa
//
//  Created by wave on 15/7/22.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMyTopicCollectionViewCell.h"
#import "LoginViewController.h"
#import "WeFaFaGet.h"
#import "StopicListModel.h"
#import "SUtilityTool.h"
#import "Utils.h"
#import "SCollocationDetailNoneShopController.h"
#import "SCollocationDetailViewController.h"
#import "STopicDetailViewController.h"

@interface SMyTopicCollectionViewCell ()  <UICollectionViewDelegate, UICollectionViewDataSource>

@end

static NSString *cellIdentifier = @"cellIdentifier";

@implementation SMyTopicCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    [_contentCollectionView registerClass:[SMyTopicListCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
}

- (void)setContentModel:(StopicListModel *)contentModel {
    _contentModel = contentModel;
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.img]];
//    [self.showTagImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.tag]];
    self.nameLabel.text = [NSString stringWithFormat:@"#%@", contentModel.name];
    self.descriptionLabel.text = contentModel.info;
    
    CGRect frame = _showTagImageView.frame;
    frame.origin.x = _nameLabel.frame.origin.x + [contentModel.name sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}].width + 10;
    _showTagImageView.frame = frame;
    [self.showTagImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.tag]];
    
    [_contentCollectionView reloadData];
}

- (IBAction)topicBtnClicked:(id)sender {
    STopicDetailViewController *vc = [STopicDetailViewController new];
    vc.titleName = _contentModel.name;
    vc.topicID = _contentModel.aID;
    [self.parentVC.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentModel.collocation_list.count;
}

//- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    STopicListShowImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    StopicListContentModel *model = _contentModel.collocation_list[indexPath.row];
//    cell.contentModel = model;
//    return cell;
//}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SMyTopicListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor=[UIColor clearColor];
    StopicListContentModel *model = _contentModel.collocation_list[indexPath.row];
    cell.contentModel = model;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!sns.isLogin) {
        LoginViewController * loginVC = [[LoginViewController alloc]init];
        [self.parentVC.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    extern BOOL g_socialStatus;
    if (g_socialStatus)//是否处于社交状态
    {
        SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
        
        StopicListContentModel *model = _contentModel.collocation_list[indexPath.row];
        
        detailNoShoppingViewController.collocationId =  model.aID ;
        [self.parentVC.navigationController pushViewController:detailNoShoppingViewController animated:YES];
    }
    else
    {
        SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
        
        StopicListContentModel *model = _contentModel.collocation_list[indexPath.row];
        
        collocationDetailVC.collocationId =  model.aID ;
        [self.parentVC.navigationController pushViewController:collocationDetailVC animated:YES];
    }
}

@end


@implementation SMyTopicListCollectionViewCell

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