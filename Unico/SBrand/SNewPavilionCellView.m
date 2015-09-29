//
//  SNewPavilionCellView.m
//  Wefafa
//
//  Created by metesbonweios on 15/8/19.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SNewPavilionCellView.h"
#import "SDiscoveryShowImageCell.h"
#import "SBrandStoryDetailModel.h"
#import "SBrandSotryViewController.h"
#import "SBrandShowListControllerViewController.h"
#import "ShowAdvertisementView.h"
#import "SDiscoveryFlexibleModel.h"
#import "DailyNewViewController.h"
#import "SBrandPavilionModel.h"
#import "Utils.h"
#import "SBrandPavilionModel.h"
#import "SBrandPavilionAdView.h"
#import "SBrandPavilionViewController.h"
@interface SNewPavilionCellView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *contentCollectionView;
//@property (nonatomic, strong) ShowAdvertisementView *advertView;
@property (nonatomic, strong) SBrandPavilionAdView *advertView;

@end

@implementation SNewPavilionCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
     CGRect frame = self.bounds;
//    frame.size.height *= UI_SCREEN_WIDTH/ 375.0;
    _advertView = [[SBrandPavilionAdView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, (125+15)*UI_SCREEN_WIDTH/ 375.0) withShowPageHeight:15.0];
    _advertView.hidden=NO;
    _advertView.backgroundColor=[Utils HexColor:0xf2f2f2 Alpha:1];
    _advertView.pageControl.hidden=NO;
  
    [self addSubview:_advertView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;

    _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 150 * UI_SCREEN_WIDTH/ 375.0) collectionViewLayout:layout];
    [_contentCollectionView setFrame:CGRectMake(0,  _advertView.height, frame.size.width, 150 * UI_SCREEN_WIDTH/ 375.0)];
    
    _contentCollectionView.scrollEnabled = NO;
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.backgroundColor = [UIColor whiteColor];
    _contentCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SDiscoveryShowImageCell" bundle:nil] forCellWithReuseIdentifier:showImageCellIdentifier];
    [self addSubview:_contentCollectionView];
}

- (void)setTarget:(UIViewController *)target{
    _target = target;
    _advertView.target = _target;
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    [_contentCollectionView reloadData];
}

- (void)setContentModel:(SBrandPavilionModel *)contentModel{
    _contentModel = contentModel;
    
    CGRect frame = _contentCollectionView.frame;
    if (contentModel.banner.count!=0) {
        _advertView.hidden = NO;
        _advertView.contentModelArray = contentModel.banner;
        frame.origin.y =  _advertView.height;
    }else{
        _advertView.hidden = YES;
        frame.origin.y = 0;
    }
    
    _contentCollectionView.frame = frame;
    
    NSString*type = [NSString stringWithFormat:@"%@",_contentModel.type];
    if([type isEqualToString:@"1"])//风格馆
    {
        frame.size.height = (175)*((UI_SCREEN_WIDTH-20)/UI_SCREEN_WIDTH)* UI_SCREEN_WIDTH/ 375.0 *[_contentModel.fixed_list count];//125+10
         _contentCollectionView.frame = frame;
       self.contentArray = contentModel.fixed_list;
        
    }else//其它的
    {
        NSInteger a=[_contentModel.brand_list count];
        int k = 0;
        int m = 0;
        k= a%3;//取余数
        m=(int )a/3;
        if (k!=0) {
            m=m+1;
        }
        frame.size.height = (70*((UI_SCREEN_WIDTH-20)/UI_SCREEN_WIDTH)*m) * UI_SCREEN_WIDTH/ 375.0;
        _contentCollectionView.frame = frame;
        self.contentArray = contentModel.brand_list;
    }

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString*type = [NSString stringWithFormat:@"%@",_contentModel.type];
    if([type isEqualToString:@"1"])//风格馆
    {
        NSLog(@"。。。。。。。。。。。%f-----%f",self.frame.size.width,125*(UI_SCREEN_WIDTH/375.0));     //750  344
        
          return CGSizeMake(self.frame.size.width, (175)*((UI_SCREEN_WIDTH-20)/UI_SCREEN_WIDTH)*(UI_SCREEN_WIDTH/375.0));
  
    }
    else
    {
          return CGSizeMake((self.frame.size.width)/ 3.0, 70*((UI_SCREEN_WIDTH-20)/UI_SCREEN_WIDTH)*(UI_SCREEN_WIDTH/375.0));
    }

}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryShowImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:showImageCellIdentifier forIndexPath:indexPath];
    cell.contentImageView.transform = CGAffineTransformIdentity;
    cell.contentImageView.frame = cell.bounds;
    cell.contentImageView.layer.masksToBounds = YES;
    BrandListModel *model = _contentArray[indexPath.row];
    NSString*type = [NSString stringWithFormat:@"%@",_contentModel.type];
    if([type isEqualToString:@"1"])//风格馆
    {
        NSLog(@"img－－－－－－－－%@",model.img);
        cell.contentImageView.contentMode =UIViewContentModeScaleToFill;
        [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"pic_loading"]];
    }
    else
    {
         cell.contentImageView.contentMode =UIViewContentModeScaleAspectFit;
        [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.logo_img] placeholderImage:[UIImage imageNamed:@"pic_loading"]];
    }
    
    cell.contentImageView.contentMode =UIViewContentModeScaleAspectFit;

//    cell.contentImageView.contentMode =UIViewContentModeScaleAspectFit;// UIViewContentModeScaleAspectFill;UIViewContentModeScaleAspectFit
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    BrandListModel *model = _contentArray[indexPath.row];
    NSString*type = [NSString stringWithFormat:@"%@",_contentModel.type];
    NSString *brandID=nil;
    if([type isEqualToString:@"1"])//风格馆
    {
        brandID=[NSString stringWithFormat:@"%@",model.idStr];
        SBrandPavilionViewController *pavilionVC=[[SBrandPavilionViewController alloc]init];
        pavilionVC.brandId =brandID;
        pavilionVC.titleStr =[NSString stringWithFormat:@"%@",model.name];
        [_target.navigationController pushViewController:pavilionVC animated:YES];
    }
    else
    {
      brandID=[NSString stringWithFormat:@"%@",model.brand_code];
        DailyNewViewController *dailyNewVC=[[DailyNewViewController alloc]init];
        //    dailyNewVC.brandId = [NSString stringWithFormat:@"%@",model.aID];
        dailyNewVC.brandId = brandID;
        //    dailyNewVC.brandStoryDeatilModel=model;
        dailyNewVC.isCanSocial = NO;//不是社交
        [_target.navigationController pushViewController:dailyNewVC animated:YES];
    }

}
@end

