//
//  SActivityListHeaderView.m
//  Wefafa
//
//  Created by unico_0 on 6/8/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SActivityListHeaderView.h"
#import "UIImageView+WebCache.h"

@interface SActivityListHeaderView ()<UIScrollViewDelegate>
{
    int _index;
}

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UILabel *pageLabel;

@property (nonatomic, strong) NSMutableArray *showPictureImageArray;
@property (nonatomic, strong) UIImage *placeholderImage;

@end

@implementation SActivityListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    self.backgroundColor = [UIColor clearColor];
    [self initSubViews];
}

- (void)initSubViews{
    _contentScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _contentScrollView.delegate = self;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.bounces = NO;
    [self addSubview:_contentScrollView];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH * 3, 0);
    [self scrollViewAddContentView];
}
- (void)scrollViewAddContentView{
    self.showPictureImageArray = [NSMutableArray array];
    CGRect rect = self.bounds;
    for (int i = 0; i < 3; i++) {
        rect.origin.x = i * UI_SCREEN_WIDTH;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = self.placeholderImage;
        [self.contentScrollView addSubview:imageView];
        [self.showPictureImageArray addObject:imageView];
    }
    self.contentScrollView.contentOffset = CGPointMake(UI_SCREEN_WIDTH, 0);
}
#pragma mark 重置ImageView位置
- (void)resetScrollViewContentLocation{
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%ld", _index + 1, (long)self.contentModelArray.count];
    for (int i = 0; i < self.showPictureImageArray.count; i++) {
        NSInteger index = _index - 1 + i;
        if (index < 0) {
            index = self.contentModelArray.count + index;
        }else if(index >= self.contentModelArray.count){
            index = index - self.contentModelArray.count;
        }
//        UIImageView *imageView = self.showPictureImageArray[i];
//        MBGoodsDetailsPictureModel *currentModel = self.contentModelArray[index];
//        NSURL *currentURL = [NSURL URLWithString:currentModel.filE_PATH];
//        [imageView sd_setImageWithURL:[UIImage imageNamed:currentURL];
    }
    self.contentScrollView.contentOffset = CGPointMake(UI_SCREEN_WIDTH, 0);
}

#pragma mark - 代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x / UI_SCREEN_WIDTH;
    CGFloat c = fmodf(scrollView.contentOffset.x, UI_SCREEN_WIDTH);
    if (index == 1 || c != 0 || !self.contentModelArray) return;
    if (index == 0) {
        _index = _index - 1 < 0? (int)self.contentModelArray.count - 1: _index - 1;
    }else if(index == 2){
        _index = _index + 1 > self.contentModelArray.count - 1? 0: _index + 1;;
    }
    [self resetScrollViewContentLocation];
}

#pragma mark - get   set

- (void)setContentModelArray:(NSArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    if (contentModelArray == nil || contentModelArray.count == 0) {
        self.contentScrollView.userInteractionEnabled = NO;
        return;
    }
    _index = 0;
    [self resetScrollViewContentLocation];
    if (contentModelArray.count <= 1) {
        self.contentScrollView.userInteractionEnabled = NO;
    }else{
        self.contentScrollView.userInteractionEnabled = YES;
    }
    
}

- (UIImage *)placeholderImage{
    if (!_placeholderImage) {
        _placeholderImage = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
    }
    return _placeholderImage;
}

@end
