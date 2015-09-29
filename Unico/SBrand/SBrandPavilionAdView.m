//
//  SBrandPavilionAdView.m
//  Wefafa
//
//  Created by metesbonweios on 15/8/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBrandPavilionAdView.h"
#import "SDiscoveryBannerModel.h"
#import "UIImageView+WebCache.h"
#import "SDiscoveryFlexibleModel.h"
#import "SUtilityTool.h"
#import "SBrandPavilionModel.h"


@interface SBrandPavilionAdView ()<UIScrollViewDelegate>

@end

@implementation SBrandPavilionAdView
@synthesize showPageHeight;

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    frame.size.height *= UI_SCREEN_WIDTH/ 375.0;
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self awakeFromNib];
//    }
//    return self;
//}
- (instancetype)initWithFrame:(CGRect)frame withShowPageHeight:(float)showpageHeight
{
    frame.size.height *= UI_SCREEN_WIDTH/ 375.0;
    self = [super initWithFrame:frame];
    if (self) {
        self.showPageHeight =showpageHeight;
        [self awakeFromNib];
        
    }
    return self;
}
- (void)awakeFromNib{
    self.backgroundColor = [UIColor clearColor];
    [self initSubViews];
    [self startTimer];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for (int i = 0; i < _showPictureImageArray.count; i++) {
        UIImageView *imageView = _showPictureImageArray[i];
        imageView.frame = CGRectMake(i * self.width, 0, self.width, self.height);
    }
}

- (void)initSubViews{
    CGRect frame = self.bounds;
    
    if (self.showPageHeight) {
        frame.size.height=frame.size.height-15;
    }
    _contentScrollView = [[UIScrollView alloc]initWithFrame:frame];
    _contentScrollView.delegate = self;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.bounces = NO;
    [self addSubview:_contentScrollView];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.contentSize = CGSizeMake(self.width * 3, 0);
    [self scrollViewAddContentView];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, frame.size.height - 15, self.bounds.size.width, 10)];
    if (self.showPageHeight) {
        [_pageControl setFrame:CGRectMake(0, frame.size.height, self.bounds.size.width, 15)];
        _pageControl.numberOfPages=3;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = COLOR_C1;
    }
    _pageControl.userInteractionEnabled = NO;
    
    
    [self addSubview:_pageControl];
}

- (void)scrollViewAddContentView{
    self.showPictureImageArray = [NSMutableArray array];
    CGRect rect = self.bounds;
    for (int i = 0; i < 3; i++) {
        rect.origin.x = i * self.width;
        if (self.showPageHeight) {
            rect.size.height = rect.size.height-self.showPageHeight;
        }
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = self.placeholderImage;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImageViewAction:)];
        [imageView addGestureRecognizer:tap];
        
        [self.contentScrollView addSubview:imageView];
        [self.showPictureImageArray addObject:imageView];
    }
    self.contentScrollView.contentOffset = CGPointMake(self.width, 0);
}

#pragma mark 重置ImageView位置
- (void)resetScrollViewContentLocation{
    _pageControl.currentPage = _index;
    for (int i = 0; i < self.showPictureImageArray.count; i++) {
        NSInteger index = _index - 1 + i;
        if (index < 0) {
            index = self.contentModelArray.count + index;
        }else if(index >= self.contentModelArray.count){
            index = index - self.contentModelArray.count;
        }
        UIImageView *imageView = self.showPictureImageArray[i];
        imageView.tag = index + 90;
        BrandListModel *currentModel = self.contentModelArray[index];
        NSURL *currentURL = [NSURL URLWithString:currentModel.img];
        [imageView sd_setImageWithURL:currentURL placeholderImage:self.placeholderImage];
    }
    self.contentScrollView.contentOffset = CGPointMake(self.width, 0);
}

#pragma mark - 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x / self.width;
    CGFloat c = fmodf(scrollView.contentOffset.x, self.width);
    if (index == 1 || c != 0 || !self.contentModelArray) return;
    if (index == 0) {
        _index = _index - 1 < 0? (int)self.contentModelArray.count - 1: _index - 1;
    }else if(index == 2){
        _index = _index + 1 > self.contentModelArray.count - 1? 0: _index + 1;;
    }
    [self resetScrollViewContentLocation];
}

#pragma mark 启动计时器
- (void)startTimer{
    _timer = [NSTimer timerWithTimeInterval:5.0 target:self
                                   selector:@selector(nextImageViewForScrollView) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)nextImageViewForScrollView{
    [self.contentScrollView setContentOffset:CGPointMake(self.width*2 , 0) animated:YES];
}

#pragma mark  用户拖动scrollview时使计时器失效
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer setFireDate:[NSDate distantFuture]];
}

#pragma mark  拖动scrollview结束时计时器开始
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSDate *date = [NSDate dateWithTimeInterval:5.0 sinceDate:[NSDate date]];
    [self.timer setFireDate:date];
}

#pragma mark - touch action
- (void)touchImageViewAction:(UITapGestureRecognizer*)tap{
    NSInteger index = tap.view.tag - 90;
    
    BrandListModel *currentModel = self.contentModelArray[index];

    /*
     NSDictionary *dictionary = @{ @"is_h5" : [Utils getSNSInteger:is_H5],
     @"url" : [Utils getSNSString:url],
     @"name" : [Utils getSNSString:name],
     @"show_type" : [Utils getSNSInteger:show_type],
     @"tid" : [Utils getSNSString:tid]
     };
     
     */
    NSDictionary * dic=@{@"is_h5":[NSString stringWithFormat:@"%d",currentModel.is_h5],
                         @"url":currentModel.url,
                         @"name":currentModel.name,
                         @"tid":currentModel.tid,
                         @"jump_type":currentModel.jump_type};
    [[SUtilityTool shared]jumpControllerWithContent:dic target:_target];
}

#pragma mark - get   set

- (void)setContentModelArray:(NSArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    
//    BrandListModel *bannerModel = contentModelArray[0];
//    self.height = bannerModel.img_height.floatValue * UI_SCREEN_WIDTH/ bannerModel.img_width.floatValue;
    if (contentModelArray == nil || contentModelArray.count == 0) {
        self.contentScrollView.userInteractionEnabled = NO;
        return;
    }else if(contentModelArray.count == 1){
        _pageControl.hidden = YES;
        if (_timer) {
            [_timer invalidate];
        }
    }else{
        if (!_timer) {
            [self startTimer];
        }
        _pageControl.hidden = NO;
    }
    _index = 0;
    _pageControl.numberOfPages = contentModelArray.count;
    [self resetScrollViewContentLocation];
    if (contentModelArray.count <= 1) {
        self.contentScrollView.scrollEnabled = NO;
    }else{
        self.contentScrollView.scrollEnabled = YES;
    }
    NSDate *date = [NSDate dateWithTimeInterval:5.0 sinceDate:[NSDate date]];
    [self.timer setFireDate:date];
}

- (void)setContentModel:(SBrandPavilionModel *)contentModel{
    _contentModel = contentModel;
    self.contentModelArray = contentModel.banner;
}

- (UIImage *)placeholderImage{
    if (!_placeholderImage) {
        //        _placeholderImage = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
        _placeholderImage = [UIImage imageNamed:@"Unico/smin_backimg"];
        
    }
    return _placeholderImage;
}


@end
