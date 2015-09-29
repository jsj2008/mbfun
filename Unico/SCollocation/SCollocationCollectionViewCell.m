//
//  SCollocationCollectionViewCell.m
//  Wefafa
//
//  Created by unico on 15/5/14.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SCollocationCollectionViewCell.h"
#import "SUtilityTool.h"
#import "LNGood.h"
#import "UIImageView+WebCache.h"
#import "SCVideoPlayerView.h"
#import "AppDelegate.h"
#import "SMineViewController.h"
#import "MBSettingMainViewController.h"
#import "WeFaFaGet.h"
/*
@interface BannerView : UIView
@property (nonatomic, assign) CGRect dayLabel_Rect;
@end

@implementation BannerView

- (void)drawRect:(CGRect)rect {
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ref, CGRectGetMaxX(_dayLabel_Rect), 34);
    CGContextAddLineToPoint(ref, 0, 0);
}

@end
*/

@interface SCollocationCollectionViewCell (){
    SCVideoPlayerView *playerView;
}

@property (nonatomic) UIImageView *iconView;
@property (nonatomic)  UIView *bgView;

@property ( nonatomic)  UILabel *itemText;
@property ( nonatomic)  UILabel *likeNum;
@property ( nonatomic)  UILabel *nameLabel;
@property ( nonatomic)  UIImageView *likeView;
@property ( nonatomic)  UIImageView *headView;

@property (nonatomic, strong) UIView *bannerView;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *weekLabel;
@end


@implementation SCollocationCollectionViewCell

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    NSString *tempStr;
    CGSize labelSize = [SUTIL getStrLenByFontStyle:@"啊哈哈" fontStyle:FONT_t7];
    //self.iconView = [[UIImageView alloc]initWithFrame:self.frame];
    self.iconView = [UIImageView new];
//    [self addSubview:self.iconView];
    _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 136/2)];//CGRectMake(0, self.frame.size.height-100 , self.frame.size.width, 100)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    [_bgView setUserInteractionEnabled:YES];
    
    [self addSubview:self.iconView];
    
    _itemText = [SUTIL createUILabelByStyle:@"在iOS中默认" fontStyle:FONT_t7 color:COLOR_C5 rect:CGRectMake(20/2, 20/2, frame.size.width-20,0) isFitWidth:YES isAlignLeft:YES];
    [_itemText setWidth:frame.size.width-20];
    
    [_bgView addSubview:_itemText];
    
    _headView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"brand_pic"]];
    _headView.frame = CGRectMake(20/2, _bgView.frame.size.height - 10 - 60/2 , 60/2, 60/2);
    _headView.layer.cornerRadius = _headView.frame.size.height/2;
    _headView.clipsToBounds = YES;
    [_headView setUserInteractionEnabled:YES];
    
    [_bgView addSubview:_headView];
     [SUTIL addViewAction:_bgView target:self action:@selector(tapHeaderView)];
    
    tempStr = @"1111";
    labelSize = [SUTIL getStrLenByFontStyle:tempStr fontStyle:FONT_SIZE(8)];
    _likeNum = [SUTIL createUILabelByStyle:tempStr fontStyle:FONT_SIZE(8) color:COLOR_C6 rect:CGRectMake(frame.size.width - 20/2-labelSize.width  , _headView.frame.origin.y+_headView.height/2-labelSize.height/2, 0,0) isFitWidth:YES isAlignLeft:YES];
    [_bgView addSubview:_likeNum];
    
    _likeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"like_heart"]];
    _likeView.frame = CGRectMake(frame.size.width - 20/2 -6/2-_likeNum.width-30/2, _headView.frame.origin.y+_headView.height/2-26/2/2, 30/2, 26/2);
    [_bgView addSubview:_likeView];
    
    _bannerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 51)];
    _bannerView.backgroundColor = [UIColor whiteColor];//[Utils HexColor:0xf2f2f2 Alpha:1];
    _dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 0, 0)];
    _dayLabel.font = [UIFont boldSystemFontOfSize:30];
    _dayLabel.textColor = [Utils HexColor:0xfedc32 Alpha:1];
    
    _monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(_dayLabel.right + 10, 24, 0, 0)];
    _monthLabel.font = FONT_T3;
    _monthLabel.textColor = COLOR_C2;
    
    _weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(_dayLabel.right + 10, 8, 0, 0)];
    _weekLabel.font = FONT_t8;
    _weekLabel.textColor = COLOR_C2;
    

    UILabel *label = [UILabel new];
    label.text = @"LATEST";
    label.font = FONT_T8;
    label.textColor = COLOR_C2;
    CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName : label.font}];
    label.frame = CGRectMake(self.width - 11 - size.width, 34, size.width, size.height);

    
    [_bannerView addSubview:_dayLabel];
    [_bannerView addSubview:_monthLabel];
    [_bannerView addSubview:_weekLabel];
    [_bannerView addSubview:label];
    [self addSubview:_bannerView];
    
    return self;
}

- (void)setGood:(LNGood *)good {
    _good = good;
    float widthFloat = _good.w;
    float heightFloat = _good.h;
    float tempFloat = self.frame.size.width/(widthFloat/2);
    
    //重用时，根据cell大小设置iconview ,重新设置下面背景图片
    self.iconView.frame = CGRectMake(0, 0 , self.frame.size.width, tempFloat*(heightFloat/2));
    
    // 这里水印图片暂时无效，原因未知。
//    NSString *watermarkImg = [SUTIL getWatermarkImageURLWithGood:good];
//    NSURL *url = [NSURL URLWithString:watermarkImg];
    
    // TODO: 暂时加载了2个图片，有点浪费。并且尺寸没有优化
    NSURL *url = [NSURL URLWithString:good.img];
    [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    
    
    
    self.likeNum.text =  good.like_count;
    self.itemText.text = good.content_info;
    NSString *imgName = @"dislike_heart@2x.png";
    if ([good.is_love integerValue]) {
        imgName = @"like_heart@2x.png";
    }
    [_likeView setImage:[UIImage imageNamed:imgName]];
    [self.headView sd_setImageWithURL:[NSURL URLWithString:good.head_img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    
    CGSize size;
    if (good.show_type == nil || [good.show_type isEqualToNumber:@0] ) {//&& [good.show_type integerValue] <= 0 ) {
        [_bannerView removeFromSuperview];
        size = self.iconView.size;
        self.iconView.frame = CGRectMake(0, 0, size.width, size.height);
        //如果不是banner，则调整位置
        [_bgView setOrigin:CGPointMake(0, self.iconView.height)];
        _bgView.hidden = NO;
        
    }else if ([good.show_type isEqualToNumber:@1]) {  //banner顶部时间条
        _bgView.hidden = YES;
//        NSTimeInterval timeoffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
        
        NSDate *nowdate = [NSDate date];
//        nowdate = [nowdate dateByAddingTimeInterval:timeoffset];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];//alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit fromDate:nowdate];
        
        _dayLabel.text = [NSString stringWithFormat:@"%ld", (long)components.day];
        _monthLabel.text = [NSString stringWithFormat:@"/%ld", (long)components.month];
        //TODO:WEEKDAY AND WEEK ORIDINAL
        switch (components.weekday - 1) {
            case 1:
                _weekLabel.text = [NSString stringWithFormat:@"星期%@", @"一"];
                break;
            case 2:
                _weekLabel.text = [NSString stringWithFormat:@"星期%@", @"二"];
                break;
            case 3:
                _weekLabel.text = [NSString stringWithFormat:@"星期%@", @"三"];
                break;
            case 4:
                _weekLabel.text = [NSString stringWithFormat:@"星期%@", @"四"];
                break;
            case 5:
                _weekLabel.text = [NSString stringWithFormat:@"星期%@", @"五"];
                break;
            case 6:
                _weekLabel.text = [NSString stringWithFormat:@"星期%@", @"六"];
                break;
            case 0:
                _weekLabel.text = [NSString stringWithFormat:@"星期%@", @"日"];
                break;
                
            default:
                break;
        }
//        _weekLabel.text = [NSString stringWithFormat:@"星期%ld", (long)components.weekdayOrdinal + 1];
        
        size = [_dayLabel.text sizeWithAttributes:@{NSFontAttributeName : _dayLabel.font}];
        _dayLabel.frame = CGRectMake(10, 8, size.width, size.height);//.size = size;
        
        size = [_weekLabel.text sizeWithAttributes:@{NSFontAttributeName : _weekLabel.font}];
        _weekLabel.frame = CGRectMake(_dayLabel.right + 10, 8, size.width, size.height);//.size = size;
        
        size = [_monthLabel.text sizeWithAttributes:@{NSFontAttributeName : _monthLabel.font}];
        _monthLabel.frame = CGRectMake(_dayLabel.right + 10, _weekLabel.bottom + 7/*_bannerView.height - size.height - 5*/, size.width, size.height);//.size = size;
        
        size = self.iconView.size;
        self.iconView.frame = CGRectMake(0, _bannerView.bottom, size.width, size.height);
        [self addSubview:_bannerView];
    }
}

-(void) initWaterFallFlowCell{
    
    
}

- (void)tapHeaderView
{
    if ([_good.user_id isEqualToString:sns.ldap_uid]) {
        MBSettingMainViewController *controller = [MBSettingMainViewController new];
        [[AppDelegate rootViewController] pushViewController:controller animated:YES];
    }else{
        SMineViewController *vc = [[SMineViewController alloc]init];
        vc.person_id = _good.user_id;
        [[AppDelegate rootViewController] pushViewController:vc animated:YES];
    }
}

-(SCVideoPlayerView*)getPlayerView{
    if (!playerView) {
        SCPlayer *player = [SCPlayer player];
        player.loopEnabled = YES;
        player.muted = YES;
        playerView = [[SCVideoPlayerView alloc] initWithPlayer:player];
        playerView.userInteractionEnabled = NO;
    }
    return playerView;
}
@end
