//
//  SDesignerShowCollectionView.m
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDesignerShowCollectionView.h"
#import "SDiscoveryShowTitleView.h"
#import "SDiscoveryHeaderCollectionCell.h"
#import "SDiscoveryUserModel.h"
#import "SUtilityTool.h"
#import "SMineViewController.h"
#import "SDesignerViewController.h"
#import "SDiscoveryFlexibleModel.h"

@interface SDesignerShowCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, SDiscoveryShowTitleViewDelegate>

@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) SDiscoveryShowTitleView *titleView;

@end

@implementation SDesignerShowCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    _titleView = [[SDiscoveryShowTitleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40) title:@"推荐设计师"];
    _titleView.delegate = self;
    [self addSubview:_titleView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 15;
    
    CGRect frame = self.bounds;
    _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, frame.size.width, frame.size.height - 40) collectionViewLayout:layout];
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.backgroundColor = [UIColor whiteColor];
    _contentCollectionView.contentInset = UIEdgeInsetsMake(10, 10, 0, 10);
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SDiscoveryHeaderCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [self addSubview:_contentCollectionView];
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    [self.contentCollectionView reloadData];
}

- (void)setContentModel:(SDiscoveryFlexibleModel *)contentModel{
    _contentModel = contentModel;
    _titleView.titleString = contentModel.name;
    self.contentArray = contentModel.config;
}

- (void)showTitleTouchMoreButton:(UIButton *)sender{
    if(![BaseViewController pushLoginViewController])
    {
        return;
    }
    SDesignerViewController *Vc = [SDesignerViewController new];
    [_target.navigationController pushViewController:Vc animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(45, _contentCollectionView.height - 20);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryHeaderCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.contentImageView.layer.cornerRadius = 45.0/ 2.0;
    cell.contentImageView.layer.masksToBounds = YES;
    cell.titleLabel.font = FONT_T8;
    SDiscoveryUserModel *model = _contentArray[indexPath.row];
    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.head_img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    cell.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.titleLabel.text = model.nick_name;
    switch ([model.head_v_type integerValue]) {
        case 0:
        {
            cell.headerTypeImageView.hidden=YES;
        }
            break;
        case 1:
        {
            cell.headerTypeImageView.hidden=NO;
            [cell.headerTypeImageView setImage:[UIImage imageNamed:@"brandvip@2x"]];
        }
            break;
        case 2:
        {
            [cell.headerTypeImageView setImage:[UIImage imageNamed:@"peoplevip@2x"]];
            cell.headerTypeImageView.hidden=NO;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SMineViewController *controller = [[SMineViewController alloc]init];
    SDiscoveryUserModel *model = _contentArray[indexPath.row];
    controller.person_id = model.user_id;
    [_target.navigationController pushViewController:controller animated:YES];
}

@end
