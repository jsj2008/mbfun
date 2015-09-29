//
//  SCollocationPlayerView.m
//  Wefafa
//
//  Created by Jiang on 8/2/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SCollocationPlayerView.h"
#import "SAVPlayerView.h"
#import "SProductDetailViewController.h"
#import "SNoneProductDetailViewController.h"
#import "MBAddShoppingViewController.h"
#import "SUtilityTool.h"
#import "STagView.h"

@interface SCollocationPlayerView ()
{
    UIImageView *_contentImageView;
    UIImageView *_maskImageView;
}

@property (nonatomic, strong) SAVPlayerView *contentPlayerView;
@property (nonatomic, strong) NSMutableArray *showTagViewArray;
@property (nonatomic, strong) UIButton *tagControlBtn;

@end

@implementation SCollocationPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        // 详情暂时关声音
        _contentPlayerView = [[SAVPlayerView alloc]initWithFrame:self.bounds];
        _contentPlayerView.autoSetVolumeWithSystemVolume = YES;
        [self addSubview:_contentPlayerView];
        _contentImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _contentImageView.hidden = YES;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_contentImageView];
        
        _maskImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _maskImageView.hidden = YES;
        _maskImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_maskImageView];
        
        _showTagViewArray = [NSMutableArray array];
        self.userInteractionEnabled = YES;
        
        _tagControlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tagControlBtn setFrame:CGRectMake(UI_SCREEN_WIDTH - 42, 70, 30, 30)];
        [_tagControlBtn setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
        _tagControlBtn.hidden = YES;
        _tagControlBtn.layer.zPosition = 10;
        _tagControlBtn.selected = YES;
        [_tagControlBtn addTarget:self action:@selector(controlTagState:) forControlEvents:UIControlEventTouchUpInside];
        [_tagControlBtn setImage:[UIImage imageNamed:@"Unico/icon_showtag"] forState:UIControlStateNormal];
        [_tagControlBtn setImage:[UIImage imageNamed:@"Unico/icon_hidetag"] forState:UIControlStateSelected];
        [self addSubview:_tagControlBtn];
    }
    return self;
}

- (void)dealloc
{
    [self playerViewPause];
}

#pragma mark 视频开始播放
- (void)playerViewPlay
{
    [_contentPlayerView play];
}

#pragma mark 视频暂停播放
- (void)playerViewPause
{
    [_contentPlayerView pause];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _contentImageView.frame = self.bounds;
    _maskImageView.frame = self.bounds;
    _contentPlayerView.frame = self.bounds;
}

#pragma mark -
- (void)setContentModel:(SCollocationDetailModel *)contentModel{
    _contentModel = contentModel;
    CGFloat height = UI_SCREEN_WIDTH/ [_contentModel.img_width floatValue] * [_contentModel.img_height floatValue];
    height = isnan(height)? 0: height;
    self.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, height);
    if (contentModel.video_url && contentModel.video_url.length > 0) {
        _contentImageView.hidden = YES;
        [_contentPlayerView setUrlForString:contentModel.video_url];
        [_contentPlayerView play];
    }else{
        _contentImageView.hidden = NO;
        [self bringSubviewToFront:_contentImageView];
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    }
    if (contentModel.stick_img_url.length > 0) {
        [self bringSubviewToFront:_maskImageView];
        _maskImageView.hidden = NO;
        [_maskImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.stick_img_url]];
    }else{
        _maskImageView.hidden = YES;
    }
    self.contentArray = contentModel.tag_list;
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    _tagControlBtn.hidden = NO;
    for (UIImageView *imageView in _showTagViewArray) {
        [imageView removeFromSuperview];
    }
    [_showTagViewArray removeAllObjects];
    for (int i = 0; i < contentArray.count; i++) {
        SCollocationGoodsTagModel *model = contentArray[i];
        STagView *tagView = [[STagView alloc]init];
        tagView.tag = 160 + i;
        tagView.tagType = CoverTagTypeItem;
        tagView.title = model.text;
        if (model.attributes.type.intValue == 100){
            tagView.tagStyle = STagViewStyleCart;
//购物袋点击事件
            
            tagView.cartTagBlock = ^{
                SProductDetailViewController *controller = [SProductDetailViewController new];
                controller.productID = model.attributes.code;
                [_target.navigationController pushViewController:controller animated:YES];
            };
        }
        tagView.toPoint = CGPointMake(model.x.floatValue * self.width, model.y.floatValue * self.height);
        tagView.flip = model.attributes.flip.boolValue;
        [self addSubview:tagView];
        [_showTagViewArray addObject:tagView];
        UITapGestureRecognizer *tagTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tagTouchAction:)];
        [tagView addGestureRecognizer:tagTap];
    }
}

- (void)tagTouchAction:(UITapGestureRecognizer*)tap{
    SCollocationGoodsTagModel *model = _contentArray[tap.view.tag - 160];
    if (model.attributes.type.intValue == 100) {
        SProductDetailViewController *controller = [SProductDetailViewController new];
        controller.productID = model.attributes.code;
        [_target.navigationController pushViewController:controller animated:YES];
    }else{
        SNoneProductDetailViewController *controller = [SNoneProductDetailViewController new];
        controller.productID = model.attributes.aID;
        [_target.navigationController pushViewController:controller animated:YES];
    }
}

- (void)controlTagState:(UIButton *)sender{
    if (_tagControlBtn.selected) {
        for (UIImageView *imageView in _showTagViewArray) {
            [UIView animateWithDuration:0.25 animations:^{
                imageView.alpha = 0;
            }];
        }
    }else{
        for (UIImageView *imageView in _showTagViewArray) {
            [UIView animateWithDuration:0.25 animations:^{
                imageView.alpha = 1;
            }];
        }
    }
    [UIView animateWithDuration:0.25 animations:^{
        _tagControlBtn.transform = CGAffineTransformMakeScale(0, 1);
    } completion:^(BOOL finished) {
        _tagControlBtn.selected = !_tagControlBtn.selected;
        [UIView animateWithDuration:0.25 animations:^{
            _tagControlBtn.transform = CGAffineTransformIdentity;
        }];
    }];
}

@end
