//
//  SDiscoveryShowConfigPicAndTextView.m
//  Wefafa
//
//  Created by metesbonweios on 15/7/30.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SDiscoveryShowConfigPicAndTextView.h"
#import "SDiscoveryShowTitleView.h"
#import "ShowAdvertisementView.h"
#import "SDiscoveryFlexibleModel.h"
#import "Utils.h"
#import "SUtilityTool.h"
#import "SHomeAgilityModel.h"
#import "SBrandPavilionViewController.h"
#import "DailyNewViewController.h"
#import "SBrandShowListControllerViewController.h"
#import "SClothingCategoryViewController.h"
#import "SDiscoverBrandListViewController.h"
#import "SNewBrandPavilionViewController.h"

@interface SDiscoveryShowConfigPicAndTextView()<SDiscoveryShowTitleViewDelegate>
{
     SDiscoveryShowTitleView *titleView;
    UIImageView *bannerImgView;
}
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *brannerScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *showPictureImageArray;
@property (nonatomic, strong) ShowAdvertisementView *advertView;
@end

@implementation SDiscoveryShowConfigPicAndTextView
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews
{
    titleView = [[SDiscoveryShowTitleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40) title:@"时尚女装"];
    titleView.delegate = self;
    [self addSubview:titleView];
    _advertView = [[ShowAdvertisementView alloc]initWithFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, 115)];
    _advertView.hidden = YES;
    [self addSubview:_advertView];
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, 235.0)];
    [self addSubview:_contentView];
    [self initContentView];
    
    self.layer.masksToBounds = YES;
}

-(void)initContentView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentShowViewTap:)];
    CGFloat scale = UI_SCREEN_WIDTH/ 375.0;
    //左侧大图
    SDiscoveryPicAndTextViewContentView *firstView = [[SDiscoveryPicAndTextViewContentView alloc]initWithFrame:CGRectMake(0, 0, 141 * scale, _contentView.frame.size.height)];
    firstView.contentImageView.frame = CGRectMake(12*scale,50, 141 * scale-12*2*scale, 174 * scale);//141*scale
    firstView.titleLabel.frame = CGRectMake(12*scale,10*scale-6*scale, 141 * scale - 24*scale, 25*scale);
    firstView.descripLabel.frame = CGRectMake(12*scale,25*scale-6*scale, 141 * scale - 24*scale, 25*scale);
    firstView.tag = 140;
    [firstView addGestureRecognizer:tap];
    [_contentView addSubview:firstView];
    int columnCount = 2;
    //右侧小图
    for (int i = 0; i < 4; i ++) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentShowViewTap:)];
        SDiscoveryPicAndTextViewContentView *view = [[SDiscoveryPicAndTextViewContentView alloc]initWithFrame:CGRectMake((i % columnCount) * (117 * scale) + CGRectGetMaxX(firstView.frame), (i / columnCount) * (_contentView.frame.size.height/ 2.0), 117 * scale, _contentView.frame.size.height/ 2.0)];
        view.tag = 141 + i;
        [view addGestureRecognizer:tap];
        [_contentView addSubview:view];
    }
}
- (void)setContentModel:(SDiscoveryFlexibleModel *)contentModel{
    _contentModel = contentModel;
    titleView.titleString=_contentModel.name;
    SDiscoveryPicTConfigerModel *activityModel = [contentModel.config firstObject];
    float heightK;
    if ( [_contentModel.banner_list count]>0) {
        SDiscoveryBannerModel *bannerModel=[_contentModel.banner_list firstObject];
        float heightImg = [bannerModel.img_height floatValue];
        float widthImg= [bannerModel.img_width floatValue];
        heightK = heightImg *UI_SCREEN_WIDTH/widthImg;
    }
    else
    {
        heightK=0;
    }
    if (contentModel.banner_list.count > 0) {
        _advertView.hidden = NO;
        [_advertView setFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, heightK)];
        _advertView.contentModelArray = _contentModel.banner_list;
    }else{
        _advertView.hidden = YES;
    }
   [ _contentView setFrame:CGRectMake(0, heightK + 40, UI_SCREEN_WIDTH, 235.0)];
    self.contentModelArray = activityModel.config;
}
- (void)setTarget:(UIViewController *)target{
    _target = target;
    _advertView.target = _target;
}
- (void)setContentModelArray:(NSArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    for (int i = 0; i < MIN(_contentView.subviews.count, contentModelArray.count); i++) {
        SDiscoveryPicAndTextViewContentView *view = _contentView.subviews[i];
        SDiscoveryPicAndTextConfigModel *model = contentModelArray[i];
        NSString *imgSt =[model.big_img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if(imgSt.length==0)
        {
            imgSt = [model.small_img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        [view.contentImageView sd_setImageWithURL:[NSURL URLWithString:imgSt] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
        view.titleLabel.text = [Utils getSNSString:model.name];
        view.descripLabel.text=[Utils getSNSString:model.info];
    }
}
#pragma mark - title delegate
- (void)showTitleTouchMoreButton:(UIButton*)sender{
    SDiscoveryPicTConfigerModel *activityModel = [_contentModel.config firstObject];
    if([activityModel.type isEqualToString:@"1"])//1的话 运动
    {
        
        SNewBrandPavilionViewController *pavilionVC=[[SNewBrandPavilionViewController alloc]init];
        pavilionVC.brandId =[NSString stringWithFormat:@"%@",activityModel.aID];
        pavilionVC.brandType = _contentModel.selectedID;
        [_target.navigationController pushViewController:pavilionVC animated:YES];
        return;
        SBrandShowListControllerViewController *brandVc = [[SBrandShowListControllerViewController alloc]initWithNibName:@"SBrandShowListControllerViewController" bundle:nil];
        [_target.navigationController pushViewController:brandVc animated:YES];
    }
    else if ([activityModel.type isEqualToString:@"2"])//淑女 品类
    {
        SDiscoverBrandListViewController *discoverList=[[SDiscoverBrandListViewController alloc]init];
        discoverList.brandId =[NSString stringWithFormat:@"%@",activityModel.aID];
        discoverList.titleStr = [NSString stringWithFormat:@"%@",activityModel.name];
        
        [_target.navigationController pushViewController:discoverList animated:YES];
        return;
    }
}
- (void)contentShowViewTap:(UITapGestureRecognizer*)tap{
    NSInteger index = tap.view.tag - 140;
    if (index >= _contentModelArray.count) return;
    
    SDiscoveryPicTConfigerModel *activityModel = [_contentModel.config firstObject];
    
    if([activityModel.type isEqualToString:@"1"])//1的话 运动 品牌
    {
        SDiscoveryPicAndTextConfigModel *model = _contentModelArray[index];
        DailyNewViewController *dailyNewVC=[[DailyNewViewController alloc]init];
        dailyNewVC.brandId=model.temp_id;
        dailyNewVC.ptConfigMode = model;
        dailyNewVC.isCanSocial=NO;
        [_target.navigationController pushViewController:dailyNewVC animated:YES];
    }
    else if ([activityModel.type isEqualToString:@"2"])//淑女 品类
    {
        SClothingCategoryViewController *sclothingVC=[[SClothingCategoryViewController alloc]init];
        SDiscoveryPicAndTextConfigModel *model = _contentModelArray[index];
        sclothingVC.defaultTitle = model.name;
//        sclothingVC.type=[[NSString stringWithFormat:@"%@",model.fixed_id] intValue];
        sclothingVC.clothingCategoryId =[NSString stringWithFormat:@"%@",activityModel.aID];
        sclothingVC.defaultId =[NSString stringWithFormat:@"%@",model.temp_id];
        [_target.navigationController pushViewController:sclothingVC animated:YES];
    }

}
@end


@implementation SDiscoveryPicAndTextViewContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat scale = UI_SCREEN_WIDTH/ 375.0;
        self.backgroundColor = [UIColor whiteColor];
        _contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-60)/2, 50*scale, 60, 60)];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        _contentImageView.image =[UIImage imageNamed:DEFAULT_LOADING_IMAGE];
        [self addSubview:_contentImageView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,10*scale-6*scale, frame.size.width, 25*scale)];
        _titleLabel.textColor = COLOR_C2;
        _titleLabel.font = FONT_T8;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        _descripLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,25*scale-6*scale, frame.size.width, 25*scale)];
        _descripLabel.textColor = COLOR_C5;
        _descripLabel.font = [UIFont systemFontOfSize:8.0];
        _descripLabel.text=@"不走寻常路";
        _descripLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_descripLabel];
        
        CALayer *rightLayer = [CALayer layer];
        rightLayer.backgroundColor = COLOR_C9.CGColor;
        rightLayer.zPosition = 5;
        rightLayer.frame = CGRectMake(self.width - 0.5, 0, 0.5, self.height);
        [self.layer addSublayer:rightLayer];
        
        CALayer *bottomLayer = [CALayer layer];
        bottomLayer.backgroundColor = COLOR_C9.CGColor;
        bottomLayer.zPosition = 5;
        bottomLayer.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
        [self.layer addSublayer:bottomLayer];
    }
    return self;
}

@end

