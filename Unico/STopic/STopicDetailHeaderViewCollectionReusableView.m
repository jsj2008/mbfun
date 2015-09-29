//
//  STpoicDetailHeaderViewCollectionReusableView.m
//  Wefafa
//
//  Created by Mr_J on 15/9/15.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "STopicDetailHeaderViewCollectionReusableView.h"
#import "SCollocationLoversController.h"
#import "StopicSelectedButton.h"
#import "SUtilityTool.h"
#import "SBrandHeaderReusableView.h"
#import "StopicDetailModel.h"
#import "WeFaFaGet.h"
#import "MBSettingMainViewController.h"
#import "SMineViewController.h"

@interface STopicDetailHeaderViewCollectionReusableView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *showDetailImageView;
@property (weak, nonatomic) IBOutlet UILabel *topicNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicDescroptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageViewLabel;
@property (weak, nonatomic) IBOutlet UIView *selectedButtonContentView;
@property (weak, nonatomic) IBOutlet StopicSelectedButton *showAusleseButton;
@property (weak, nonatomic) IBOutlet StopicSelectedButton *showAllButton;
@property (weak, nonatomic) IBOutlet UICollectionView *showUserHeaderCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *arrowShowButton;

@property (nonatomic, strong) UIView *selectedView;

@end

static NSString *cellIndentifier = @"SBrandHeaderCollectionViewCellIdentifier";
@implementation STopicDetailHeaderViewCollectionReusableView

- (void)awakeFromNib {
    [self initSubViews];
}

- (void)initSubViews{
    CGRect frame = _selectedButtonContentView.bounds;
    frame.size.width = UI_SCREEN_WIDTH;
    frame.size.height = 0.5;
    CALayer *topLayer = [CALayer layer];
    topLayer.backgroundColor = COLOR_C9.CGColor;
    topLayer.frame = frame;
    [_selectedButtonContentView.layer addSublayer:topLayer];
    
    frame.origin.y = _selectedButtonContentView.frame.size.height - frame.size.height;
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.backgroundColor = COLOR_C9.CGColor;
    bottomLayer.frame = frame;
    [_selectedButtonContentView.layer addSublayer:bottomLayer];
    
    [self.showUserHeaderCollectionView registerClass:[SBrandHeaderCollectionViewCell class] forCellWithReuseIdentifier:cellIndentifier];
    self.showUserHeaderCollectionView.delegate = self;
    self.showUserHeaderCollectionView.dataSource = self;
    
    _selectedView = [[UIView alloc]init];
    _selectedView.layer.zPosition = 5;
    _selectedView.backgroundColor = COLOR_C1;
    _selectedView.frame = CGRectMake(0, _selectedButtonContentView.frame.size.height - 3, 40.0, 3);
    [_selectedButtonContentView addSubview:_selectedView];
}

- (void)setContentModel:(StopicDetailModel *)contentModel{
    _contentModel = contentModel;
    [_showDetailImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.big_img]];
    _topicNameLabel.text = contentModel.name;
    _topicDescroptionLabel.text = contentModel.info;
    _pageViewLabel.text = [NSString stringWithFormat:@"%@人浏览", contentModel.look_num];
    _showAusleseButton.subLabel.text = contentModel.selectNum.stringValue;
    _showAllButton.subLabel.text = contentModel.allNum.stringValue;
    
    [self.arrowShowButton setTitle:contentModel.partUserCount.stringValue forState:UIControlStateNormal];
    [self.showUserHeaderCollectionView reloadData];
    
    CGRect rect = self.frame;
    rect.size.height = [contentModel.info heightWithRestrictedWidth:UI_SCREEN_WIDTH - 34 font:[UIFont systemFontOfSize:12]] + 320;
    self.frame = rect;
    
    self.arrowShowButton.left = MIN(_contentModel.partUserList.count * 40 + 17, UI_SCREEN_WIDTH - 65);
    
    if (contentModel.selectedIndex == 0) {
        _selectedView.centerX = _showAusleseButton.centerX;
    }else{
       _selectedView.centerX = _showAllButton.centerX;
    }
}

#pragma mark - action
- (IBAction)ausleseButtonAction:(UIButton *)sender {
    _showAllButton.selected = NO;
    _showAusleseButton.selected = YES;
    [UIView animateWithDuration:0.15 animations:^{
        _selectedView.centerX = sender.centerX;
    }];
    if ([self.delegate respondsToSelector:@selector(selectedButton:selectedIndex:)]) {
        [self.delegate selectedButton:sender selectedIndex:0];
    }
}
- (IBAction)arrowMoreButtonAction:(UIButton *)sender {
    SCollocationLoversController *loverController = [[SCollocationLoversController alloc] init];
    loverController.topicId = [NSString stringWithFormat:@"%@", _contentModel.aID];
    [_target.navigationController pushViewController:loverController animated:YES];
}

- (IBAction)showAllButtonAction:(UIButton *)sender {
    _showAllButton.selected = YES;
    _showAusleseButton.selected = NO;
    [UIView animateWithDuration:0.15 animations:^{
        _selectedView.centerX = sender.centerX;
    }];
    if ([self.delegate respondsToSelector:@selector(selectedButton:selectedIndex:)]) {
        [self.delegate selectedButton:sender selectedIndex:1];
    }
}

#pragma mark - collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentModel.partUserList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(30, 30);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SBrandHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    cell.contentModel = _contentModel.partUserList[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SBrandStoryUserModel *model = _contentModel.partUserList[indexPath.row];
    if ([model.user_id isEqualToString:sns.ldap_uid]) {
        MBSettingMainViewController *controller = [MBSettingMainViewController new];
        [_target.navigationController pushViewController:controller animated:YES];
    }else{
        SMineViewController *vc = [[SMineViewController alloc]init];
        vc.person_id = model.user_id;
        [_target.navigationController pushViewController:vc animated:YES];
    }
}

@end
