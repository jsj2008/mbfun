//
//  LGIntroductionViewController.m
//  ladygo
//
//  Created by square on 15/1/21.
//  Copyright (c) 2015年 ju.taobao.com. All rights reserved.
//
//  这个类就是处理首次启动的，把平时启动的图片放在这里处理，逻辑是不对的。
//

#import "SIntroController.h"
#import "SVideoWelcomeController.h"
#import "GuideViewController.h"

@interface SIntroController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *backgroundViews;
@property (nonatomic, strong) NSArray *scrollViewPages;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger centerPageIndex;
@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *backimgView;
@property (nonatomic, strong) UIButton *playbtn;

@property (nonatomic, strong) GuideViewController *guidevc;
@end

@implementation SIntroController

- (id)initWithCoverImageNames:(NSArray *)coverNames backgroundImageNames:(NSArray *)bgNames
{
    if (self = [super init]) {
        [self initSelfWithCoverNames:coverNames backgroundImageNames:bgNames];
    }
    return self;
}

- (id)initWithCoverImageNames:(NSArray *)coverNames backgroundImageNames:(NSArray *)bgNames button:(UIButton *)button
{
    if (self = [super init]) {
        [self initSelfWithCoverNames:coverNames backgroundImageNames:bgNames];
        self.enterButton = button;
    }
    return self;
}

- (void)initSelfWithCoverNames:(NSArray *)coverNames backgroundImageNames:(NSArray *)bgNames
{
    self.coverImageNames = coverNames;
    self.backgroundImageNames = bgNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    
    
    NSLog(@"viewDidLoad");
    
    if (self.first) {
        //旧的引导页
        /*
        [self addBackgroundViews];
        [self addFirstVideo];
        
        self.pagingScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [self.pagingScrollView setBackgroundColor:[UIColor clearColor]];
        
        self.pagingScrollView.delegate = self;
        self.pagingScrollView.pagingEnabled = YES;
        self.pagingScrollView.showsHorizontalScrollIndicator = NO;
        
        [self.view addSubview:self.pagingScrollView];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:[self frameOfPageControl]];
        self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
        [self.view addSubview:self.pageControl];
        
//        if (!self.enterButton) {
        self.enterButton = [UIButton new];
//        [self.enterButton setTitle:NSLocalizedString(@"Enter", nil) forState:UIControlStateNormal];
        [self.enterButton setTitle:@"立即进入" forState:UIControlStateNormal];
        self.enterButton.layer.borderWidth = 0.5;
        self.enterButton.layer.borderColor = [UIColor whiteColor].CGColor;
//        }
        
        [self.enterButton addTarget:self action:@selector(enter:) forControlEvents:UIControlEventTouchUpInside];
        CGRect rect = [self frameOfEnterButton];
        rect.origin.y = UI_SCREEN_HEIGHT - 80;
        CGSize size = [self.enterButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.enterButton.titleLabel.font}];
        size.width += 30;
        rect.size = size;
        rect.origin.x = (UI_SCREEN_WIDTH - size.width)/2;
        self.enterButton.frame = rect;
        self.enterButton.alpha = 0.5;
        [self.view addSubview:self.enterButton];
        
        UITapGestureRecognizer *tapGest =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImgView:)];
        self.view.userInteractionEnabled=YES;
        [self.view addGestureRecognizer:tapGest];
        
        [self reloadPages];
        
        // 前一个
        [self addFrontVideo];
         */
        
        //新的引导页
        _guidevc = [[GuideViewController alloc] initWithNibName:@"GuideViewController" bundle:nil];
        _guidevc.view.frame = [UIScreen mainScreen].bounds;
        [self.view addSubview:_guidevc.view];
        __weak __typeof(self) ws = self;
        _guidevc.skipBlock = ^(){
            [ws enter:nil];
        };
    }else {
        [self startAnimation];
    }
    
}

- (void)startClicked {
    [self enter:nil];
    // 这个事件应该不加吧？？
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"WELCOME_VIDEO_PLAY" object:nil];
}

- (void)play {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WELCOME_VIDEO_PLAY" object:nil];
}

- (void)startAnimation {

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startClicked)];
    _backImgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _backImgView.frame = self.view.bounds;
    [_backImgView sd_setImageWithURL:[NSURL URLWithString:LAUNCH_IMAGE]];
    _backImgView.userInteractionEnabled = YES;
    
    [_backImgView addGestureRecognizer:tap];
    
    [self.view addSubview:_backImgView];
    
    NSLog(@"LAUNCH_IMAGE = %@", LAUNCH_IMAGE);
    
    [NSTimer scheduledTimerWithTimeInterval:2.8 target:self selector:@selector(startClicked) userInfo:nil repeats:NO];
    
    [self reloadPages];
    
    // 前一个
    [self addFrontVideo];
    
    CABasicAnimation *shiziScaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    shiziScaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];//kCAMediaTimingFunctionEaseIn];
    shiziScaleAnimation.duration = 2;
    shiziScaleAnimation.repeatCount = 0;
    shiziScaleAnimation.fromValue = @1.0;
    shiziScaleAnimation.toValue = @1.01;
    shiziScaleAnimation.fillMode = kCAFillModeForwards;
    shiziScaleAnimation.removedOnCompletion = NO;
    [_backImgView.layer addAnimation:shiziScaleAnimation forKey:nil];

    [self performSelector:@selector(doAnimation) withObject:nil afterDelay:2];
}

-(void)doAnimation{
    
    CABasicAnimation *opacityToOneAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityToOneAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];//kCAMediaTimingFunctionEaseIn];
    opacityToOneAnimation.duration = 1.2;
    opacityToOneAnimation.repeatCount = 0;
    opacityToOneAnimation.fromValue = @1;
    opacityToOneAnimation.toValue = @0;
    opacityToOneAnimation.fillMode = kCAFillModeForwards;
    opacityToOneAnimation.removedOnCompletion = NO;
    
    //    十字缩小动画
    CABasicAnimation *shiziScaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    shiziScaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    shiziScaleAnimation.duration = 1.2;
    shiziScaleAnimation.repeatCount = 0;
    shiziScaleAnimation.fromValue = @1.01;
    shiziScaleAnimation.toValue = @1.2;
    shiziScaleAnimation.fillMode = kCAFillModeForwards;
    shiziScaleAnimation.removedOnCompletion = NO;
    
    opacityToOneAnimation.beginTime = CACurrentMediaTime();// + 1.0;
    //    opacityToOneAnimation.duration = 1.5;
    //    [_backImgView.layer addAnimation:keep1s forKey:nil];
    
    [_backImgView.layer addAnimation:opacityToOneAnimation forKey:nil];
    [_backImgView.layer addAnimation:shiziScaleAnimation forKey:nil];
}

-(void)tapImgView:(UITapGestureRecognizer *)sender{
    CGPoint touchLocation = [sender locationInView:self.view];
    // 先粗暴处理
    if (touchLocation.y < self.view.frame.size.height *0.6 &&  _pageControl.currentPage <= 0) {
        [self play];
    } else {
        [self enter:nil];
    }
    
//    [self enter:nil];
}
- (void)addBackgroundViews
{
    CGRect frame = self.view.bounds;
    NSMutableArray *tmpArray = [NSMutableArray new];
    [[[[self backgroundImageNames] reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:obj]];
        imageView.frame = frame;
        imageView.tag = idx + 1;
        [tmpArray addObject:imageView];
        
        [self.view addSubview:imageView];
    }];

    self.backgroundViews = [[tmpArray reverseObjectEnumerator] allObjects];
}

- (void)addFirstVideo{
    // new时候自动load了关联的xib
    SVideoWelcomeController *vc = [SVideoWelcomeController new];
    
    
    [self addChildViewController:vc];
    UIImageView *imageView = self.backgroundViews[0];
    [imageView addSubview:vc.view];
}

- (void)addFrontVideo
{
    CGSize size = self.view.frame.size;
    
    UIImageView *imageView = _scrollViewPages[2];
    
    NSURL *mp4Url = [[NSBundle mainBundle] URLForResource:@"intro_3" withExtension:@"mp4"];
    NSURL  *gifURL = [[NSBundle mainBundle] URLForResource:@"intro_3" withExtension:@"gif"];
    
    if (mp4Url != nil)
    {
        self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:mp4Url];
        
        self.moviePlayerController.view.bounds = CGRectMake(0, 0, 205, 140);
        
        self.moviePlayerController.view.center = CGPointMake(size.width*.5, size.height*.42);
        
        self.moviePlayerController.view.clipsToBounds = YES;
        
        [imageView addSubview:self.moviePlayerController.view];
        
        self.moviePlayerController.controlStyle = MPMovieControlStyleNone;
        
        self.moviePlayerController.repeatMode = MPMovieRepeatModeOne;
        
        [self.moviePlayerController prepareToPlay];
    }
    else if (gifURL != nil)
    {
        UIImageView *gif= [UIImageView new];
        
        [gif sd_setImageWithURL:gifURL];
        gif.bounds = CGRectMake(0, 0, 205, 140);
        gif.contentMode = UIViewContentModeScaleAspectFill;
        gif.center = CGPointMake(size.width*.5, size.height*.42);
        gif.clipsToBounds = YES;
        
        
        [imageView addSubview:gif];
    }
}

- (void)reloadPages
{
    self.pageControl.numberOfPages = [[self coverImageNames] count];
    self.pagingScrollView.contentSize = [self contentSizeOfScrollView];
    
    __block CGFloat x = 0;
    [[self scrollViewPages] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        
        
        obj.frame = CGRectOffset(obj.frame, x, 0);
        
        
        
        [self.pagingScrollView addSubview:obj];
        
        x += obj.frame.size.width;
    }];

    // fix enterButton can not presenting if ScrollView have only one page
    if (self.pageControl.numberOfPages == 1) {
        self.enterButton.alpha = 1;
        self.pageControl.alpha = 0;
    }
    
    // fix ScrollView can not scrolling if it have only one page
    if (self.pagingScrollView.contentSize.width == self.pagingScrollView.frame.size.width) {
        self.pagingScrollView.contentSize = CGSizeMake(self.pagingScrollView.contentSize.width + 1, self.pagingScrollView.contentSize.height);
    }
}

- (CGRect)frameOfPageControl
{
    return CGRectMake(0, self.view.bounds.size.height - 30, self.view.bounds.size.width, 30);
}

- (CGRect)frameOfEnterButton
{
    CGSize size = self.enterButton.bounds.size;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(self.view.frame.size.width * 0.6, 40);
    }
    return CGRectMake(self.view.frame.size.width / 2 - size.width / 2, self.pageControl.frame.origin.y - size.height, size.width, size.height);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.view.frame.size.width;
    CGFloat alpha = 1 - ((scrollView.contentOffset.x - index * self.view.frame.size.width) / self.view.frame.size.width);
    
    if ([self.backgroundViews count] > index) {
        UIView *v = [self.backgroundViews objectAtIndex:index];
        if (v) {
            [v setAlpha:alpha];
        }
    }
    
    self.pageControl.currentPage = scrollView.contentOffset.x / (scrollView.contentSize.width / [self numberOfPagesInPagingScrollView]);
    
    [self pagingScrollViewDidChangePages:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.view.frame.size.width;
    if (index == 2)
    {
        [self.moviePlayerController play];
    }
    else
    {
        [self.moviePlayerController pause];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0) {
        if (![self hasNext:self.pageControl]) {
            [self enter:nil];
        }
    }
}

#pragma mark - UIScrollView & UIPageControl DataSource

- (BOOL)hasNext:(UIPageControl*)pageControl
{
    return pageControl.numberOfPages > pageControl.currentPage + 1;
}

- (BOOL)isLast:(UIPageControl*)pageControl
{
    return pageControl.numberOfPages == pageControl.currentPage + 1;
}

- (NSInteger)numberOfPagesInPagingScrollView
{
    return [[self coverImageNames] count];
}

- (void)pagingScrollViewDidChangePages:(UIScrollView *)pagingScrollView
{
    if ([self isLast:self.pageControl]) {
        if (self.pageControl.alpha == 1) {
            self.enterButton.alpha = 0;
            
            [UIView animateWithDuration:0.4 animations:^{
                self.enterButton.alpha = 1;
                self.pageControl.alpha = 0;
            }];
        }
    } else {
        if (self.pageControl.alpha == 0) {
            [UIView animateWithDuration:0.4 animations:^{
                self.enterButton.alpha = 0;
                self.pageControl.alpha = 1;
            }];
        }
    }
}

- (BOOL)hasEnterButtonInView:(UIView*)page
{
    __block BOOL result = NO;
    [page.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj && obj == self.enterButton) {
            result = YES;
        }
    }];
    return result;
}

- (UIImageView*)scrollViewPage:(NSString*)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGSize size = {[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height};
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, size.width, size.height);
    return imageView;
}

- (NSArray*)scrollViewPages
{
    if ([self numberOfPagesInPagingScrollView] == 0) {
        return nil;
    }
    
    if (_scrollViewPages) {
        return _scrollViewPages;
    }
    
    NSMutableArray *tmpArray = [NSMutableArray new];
    [self.coverImageNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIImageView *v = [self scrollViewPage:obj];
        [tmpArray addObject:v];
        
    }];
    
    _scrollViewPages = tmpArray;
    
    return _scrollViewPages;
}

- (CGSize)contentSizeOfScrollView
{
    UIView *view = [[self scrollViewPages] firstObject];
    return CGSizeMake(view.frame.size.width * self.scrollViewPages.count, view.frame.size.height);
}

#pragma mark - Action

- (void)enter:(id)object
{
    self.didSelectedEnter();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end