//
//  SDiscoveryBrandZoneCollectionView.m
//  Wefafa
//
//  Created by metesbonweios on 15/7/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SDiscoveryBrandZoneCollectionView.h"
#import "SDiscoveryShowTitleView.h"
#import "SDiscoveryFlexibleModel.h"
#import "SBrandShowListControllerViewController.h"
#import "SBrandViewController.h"
#import "SDiscoveryBrZoneCollectionViewCell.h"
#import "BrandDetailViewController.h"

@interface SDiscoveryBrandZoneCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,SDiscoveryShowTitleViewDelegate>
{
    
}
@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) SDiscoveryShowTitleView *titleView;

@end
@implementation SDiscoveryBrandZoneCollectionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}
-(void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
    _titleView = [[SDiscoveryShowTitleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40) title:@""];
    _titleView.delegate = self;
    [self addSubview:_titleView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    CGRect frame = self.bounds;
    frame.size.width = UI_SCREEN_WIDTH;
    frame.size.height *= UI_SCREEN_WIDTH/ 375.0;
    _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, frame.size.width, 140) collectionViewLayout:layout];
    _contentCollectionView.scrollEnabled = NO;
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.backgroundColor = [UIColor whiteColor];
    _contentCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
     [_contentCollectionView registerNib:[UINib nibWithNibName:@"SDiscoveryBrZoneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:brandZoneVCellIdentifier];
    [self addSubview:_contentCollectionView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    [_contentCollectionView reloadData];
}
-(void)setContentModel:(SDiscoveryFlexibleModel *)contentModel
{
    _contentModel=contentModel;
    _titleView.titleString = contentModel.name;
    self.contentArray = contentModel.config;
    [_contentCollectionView reloadData];
}
- (void)showTitleTouchMoreButton:(UIButton *)sender{
     SBrandViewController *Vc = [SBrandViewController new];
    Vc.isComeFromTopic=YES;
    [_target.navigationController pushViewController:Vc animated:YES];
    return;
    SBrandShowListControllerViewController *brandVc = [[SBrandShowListControllerViewController alloc]initWithNibName:@"SBrandShowListControllerViewController" bundle:nil];
    [_target.navigationController pushViewController:brandVc animated:YES];
}
- (void)setTarget:(UIViewController *)target{
    _target = target;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((UI_SCREEN_WIDTH)/ 3.0, _contentCollectionView.frame.size.height);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryBrZoneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:brandZoneVCellIdentifier forIndexPath:indexPath];
    SBrandStoryDetailModel *model = _contentArray[indexPath.row];

    cell.brandLogo.contentMode = UIViewContentModeScaleAspectFill;
    cell.contentDataModel=model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BrandDetailViewController *controller = [[BrandDetailViewController alloc]init];
    SBrandStoryDetailModel *model = _contentArray[indexPath.row];
    controller.brandId=[NSString stringWithFormat:@"%@",model.brand_code];
    [_target.navigationController pushViewController:controller animated:YES];
}
@end
