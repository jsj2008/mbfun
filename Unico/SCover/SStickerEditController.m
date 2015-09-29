//
//  ViewController.m
//
//
//  TODO：把贴纸的类整合进来。
// 

#import "SStickerEditController.h"
#import "CoverStickerView.h"
#import "CLImageEditor.h"
#import "UIImage+Utility.h"
#import "VerticalAlignTextView.h"
#import "LLCameraViewController.h"
#import "CoverStickerEditView.h"
#import "DCPathButton.h"
#import "DoImagePickerController.h"
//#import "TopicEditViewController.h"
#import "StickerViewController.h"
//#import "STopicEditController.h"
#import "SDataCache.h"
#import "SCoverLayerController.h"
//#import "FontDownloadController.h"
#import "SCVideoPlayerViewController.h"
#import "SCImageDisplayerViewController.h"
#import "UIImage+SizeColor.h"
#import "SUtilityTool.h"
#import "SBlurGridMenu.h"

// 品牌标签选择
#import "BrandListViewController.h"
#import "AppDelegate.h"
// 单品标签选择
#import "CollocationSearchController.h"
// 设计师标签
#import "SearchDesignerViewController.h"
// publish preview
#import "SPublishedController.h"

#import "CoverEditViewController.h"

#import "STagEditController.h"
// TODO:添加标签

// 1 单品标签
// 2 品牌标签
// 3 设计师标签
// 4 话题标签

#import "CCTabBarControl.h"



@interface SStickerEditController ()
<
UIScrollViewDelegate,
CoverStickerViewDelegate
>
{
    NSMutableArray *buttomBtns;
    SCVideoPlayerViewController *playerVC; // 播放视频用的
    SCImageDisplayerViewController *photoVC; // 显示图片用
    
    UIScrollView *stickerScroll;
    
    UIScrollView *filterScroll;
    UIView       *_filterSelectedView;
    
    UIScrollView *_borderImageScrollView;
    UIView       *_borderImageSelectedView;
    
    
    
    UIButton *stickerTabBtn;
    UIButton *filterTabBtn;
    
    UILabel *_titleLabel;
    
    CCTabBarControl  *_tabBarControl;
    
    BOOL _getBorderImageComplete;
    BOOL _getStickerImageComplete;
    
    
    BOOL _borderModel;//在边框模式下，图片是可以移动和缩放的，否则不能移动和缩放。
    
}

@property (nonatomic) UIView* renderView;
@property (nonatomic) UIImage* originalImage;
@property (nonatomic) UIImageView* imageView;
@property (nonatomic) UIImageView* clipImageView;
@property (nonatomic) UIScrollView* scrollView;
@property (nonatomic) UIFont* font;

@property (nonatomic) UIButton* textConfirm, *textCancel;

@property (nonatomic) VerticalAlignTextView* editTextView;
@property (nonatomic) CoverStickerEditView* stikerEdit;


@property (assign, readwrite, nonatomic) BOOL borderModel;

@end

@implementation SStickerEditController


- (id)initWithImage:(UIImage*)image {
    self = [[SStickerEditController alloc] initWithNibName:nil bundle:nil];

    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"SCamera" bundle:nil];
    photoVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"SCImageDisplayerViewController"];
    photoVC.photo = image;
    
    return self;
}

- (id)initWithVideo:(SCRecordSession*)video {
    
    self = [[SStickerEditController alloc] initWithNibName:nil bundle:nil];
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"SCamera" bundle:nil];
    playerVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"SCVideoPlayerViewController"];
    playerVC.recordSession = video;

    return self;
}

- (void)dealloc{

    [playerVC.view removeFromSuperview];
    [playerVC removeFromParentViewController];
    playerVC = nil;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // TODO: fix 这个界面为啥是白色？没找到哪里问题
    self.view.backgroundColor = [UIColor blackColor];
    
    [self createRenderView];
    
    [self addGesture];

    
    if (photoVC != nil)
    {
        [self createPhotoView];
    }
    
    if (playerVC != nil)
    {
        [self createVideoPlayer];
    }
    
    
    
    
    UIView *navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    //navigationBarView.contentMode = UIViewContentModeScaleToFill;
    navigationBarView.backgroundColor = [UIColor blackColor];
    navigationBarView.alpha = 0.4;
    [self.view addSubview:navigationBarView];
    
    
    UIView *bottomNavigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-150, [UIScreen mainScreen].bounds.size.width, 150)];
    //navigationBarView.contentMode = UIViewContentModeScaleToFill;
    bottomNavigationBarView.backgroundColor = [UIColor blackColor];
    bottomNavigationBarView.alpha = 0.4;
    [self.view addSubview:bottomNavigationBarView];
    
    [self createButtons];
    
    filterScroll = [UIScrollView new];
    filterScroll.hidden = YES;//先隐藏 等待边框和贴纸是否有时再考虑显示
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self createFilterScroll];
    });
    
    // Load Stikcer From Server
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *topicId = @"";
   /* NSDictionary* info = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCAMERA_TAG"];
    if (info && info[@"text"] && info[@"type"] && info[@"id"]) {
        NSNumber *type = info[@"type"];
        if ([type intValue] == CoverTagTypeTopic) {
            topicId = info[@"id"];
        }
    } 注释掉这里 、以保证无论从哪里创建搭配 都拉出所有贴纸和边框 */
    
    
    
    if (photoVC != nil)//只有照片才加载边框
    {
        int borderHeight = 750;

        float k = photoVC.photo.size.height/photoVC.photo.size.width;
        
        if (fabs(k - 1.0) < 0.001)
        {
            borderHeight = 750;
        }
        else if (fabs(k - 4.0/3.0) < 0.001)
        {
            borderHeight = 1000;
        }
        else if (fabs(k - 16.0/9.0) < 0.001)
        {
            borderHeight = 1334;
        }
        
        [[SDataCache sharedInstance] getBorderImageList:topicId borderHeight:borderHeight complete:^(id object) {
            //[[SDataCache sharedInstance] getStickImgWithTabList:topicId complete:^(id object) {
            if (object) {
                NSLog(@"边框 OBJECT : %@", object);
                [self createBorderImageScroll:object];
                
                if (_getStickerImageComplete)//贴纸也加载完成
                {
                    [self updateTabBarView];
                }
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
    else
    {
        _getBorderImageComplete = YES;//视频没有边框，直接当边框加载完成处理
    }
    
    [[SDataCache sharedInstance] getStickImgWithTabList:topicId complete:^(id object) {
        if (object) {
            NSLog(@"OBJECT : %@",object);
            [self createStickerScroll:object];
            
            if (_getBorderImageComplete)//边框也加载完成
            {
                [self updateTabBarView];
            }
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)updateTabBarView
{
    NSLog(@"updateTabBarView");
    if (_borderImageScrollView == nil && stickerScroll == nil)//没有边框和贴纸
    {
        _titleLabel.text = @"选择滤镜";
        filterScroll.layer.transform = CATransform3DMakeTranslation(0, 50, 0);
        filterScroll.hidden = NO;
        _tabBarControl.hidden = YES;//不显示tabbar
    }
    else if (_borderImageScrollView == nil && stickerScroll != nil)
    {
        _titleLabel.text = @"选择贴纸";
        _tabBarControl.titles = @[@"贴纸", @"滤镜"];
        
        filterScroll.hidden = NO;
        
        filterScroll.frame = CGRectMake(filterScroll.frame.origin.x+filterScroll.frame.size.width, filterScroll.frame.origin.y, filterScroll.frame.size.width, filterScroll.frame.size.height);
        
        _tabBarControl.hidden = NO;//显示tabbar
    }
    else if (_borderImageScrollView != nil && stickerScroll == nil)
    {
        _titleLabel.text = @"选择边框";
        _tabBarControl.titles = @[@"边框", @"滤镜"];
        
        filterScroll.hidden = NO;
        
        filterScroll.frame = CGRectMake(filterScroll.frame.origin.x+filterScroll.frame.size.width, filterScroll.frame.origin.y, filterScroll.frame.size.width, filterScroll.frame.size.height);
        
        _tabBarControl.hidden = NO;//显示tabbar
    }
    else if (_borderImageScrollView != nil && stickerScroll != nil)
    {
        _titleLabel.text = @"选择贴纸";
        _tabBarControl.titles = @[@"贴纸", @"边框", @"滤镜"];
        
        filterScroll.hidden = NO;
        
        _borderImageScrollView.frame = CGRectMake(_borderImageScrollView.frame.origin.x+_borderImageScrollView.frame.size.width, _borderImageScrollView.frame.origin.y, _borderImageScrollView.frame.size.width, _borderImageScrollView.frame.size.height);
        
        filterScroll.frame = CGRectMake(filterScroll.frame.origin.x+filterScroll.frame.size.width*2, filterScroll.frame.origin.y, filterScroll.frame.size.width, filterScroll.frame.size.height);
        
        _tabBarControl.hidden = NO;//显示tabbar
    }
}

-(void)createPhotoView
{
    if (photoVC)
    {
        // 临时关闭scroll交互。
        _scrollView.userInteractionEnabled = NO;
        [self addChildViewController:photoVC];
        [self.view insertSubview:photoVC.view belowSubview:_renderView];
        
        
        //添加上下挡板、以支持添加边框时，图片可以移动与缩放
        float k = photoVC.photo.size.height/photoVC.photo.size.width;
        float photoViewHeight = UI_SCREEN_WIDTH * k;
        
        UIView *upMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, (UI_SCREEN_HEIGHT - photoViewHeight)/2.0)];
        upMaskView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:upMaskView];
        
        UIView *bottomMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - (UI_SCREEN_HEIGHT - photoViewHeight)/2.0, UI_SCREEN_WIDTH, (UI_SCREEN_HEIGHT - photoViewHeight)/2.0)];
        bottomMaskView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:bottomMaskView];
    }
}

- (void)photoVCViewPan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [panGestureRecognizer translationInView:photoVC.view];
        
        photoVC.view.layer.transform = CATransform3DTranslate(photoVC.view.layer.transform, point.x, point.y, 0);
        
        [panGestureRecognizer setTranslation:CGPointZero inView:photoVC.view];
    }
}

- (void)photoVCViewPin:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        photoVC.view.layer.transform = CATransform3DScale(photoVC.view.layer.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale, 1);
        
        pinchGestureRecognizer.scale = 1;
    }
}

-(void)createVideoPlayer
{
    // video
    if (playerVC)
    {
        // 临时关闭scroll交互。
        _scrollView.userInteractionEnabled = NO;
        [self addChildViewController:playerVC];
        [self.view insertSubview:playerVC.view belowSubview:_renderView];
    }
}

-(void)createRenderView
{
    CGRect rect = self.view.frame;
    self.renderView = [[UIView alloc] initWithFrame:rect];
    [self.renderView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.renderView];
}

-(void)addGesture
{
    // 不要加在view上，避免和其他组件事件冲突。
    [self.renderView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOutside:)]];
    
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressBackground:)];
    [longPress setMinimumPressDuration:0.6];
   // [self.scrollView addGestureRecognizer:longPress];
    
    // swipe change filter
    UISwipeGestureRecognizer* swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftHandler:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
   // [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightHandler:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
   // [self.view addGestureRecognizer:swipeRecognizer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if ([self.view.gestureRecognizers count] > 0)
    {
        for(UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers)
        {
            if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)gestureRecognizer;
            }
        }
    }
    if (screenEdgePanGestureRecognizer != nil)
    {
        [self.view removeGestureRecognizer:screenEdgePanGestureRecognizer];//此处禁止屏幕边界右滑时返回上一级界面的手势
    }

    
    [self.navigationController setNavigationBarHidden:YES];
}

// 这里实际生效，隐藏navbar
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)swipeLeftHandler:(UISwipeGestureRecognizer*)recognizer{
    [playerVC changeFilter:-1];
    [photoVC changeFilter:-1];
}

- (void)swipeRightHandler:(UISwipeGestureRecognizer*)recognizer{
    [playerVC changeFilter:1];
    [photoVC changeFilter:1];
}



// 显示图层编辑（TODO）
- (void)showLayer
{
    // TODO：可以向下滑动
    SCoverLayerController *vc = [SCoverLayerController new];
    vc.list = [self.renderView subviews];
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}

- (void)createButtons
{
    buttomBtns = [NSMutableArray array];
    
    float viewWidth = CGRectGetWidth(self.view.frame);
    float viewHeight = CGRectGetHeight(self.view.frame);
    
    CGSize size = self.view.frame.size;
    _titleLabel = [UILabel new];
    _titleLabel.font = FONT_T2;
    _titleLabel.text = @"编辑贴纸";
    _titleLabel.textColor = COLOR_C3;
    [_titleLabel sizeToFit];
    _titleLabel.center = CGPointMake(size.width/2, 42);
    [self.view addSubview:_titleLabel];


    // 返回按钮
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(7, 28, 30, 30);
    [btn setImage:[UIImage imageNamed:@"Unico/camera_navbar_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    btn.centerY = _titleLabel.centerY;
    [self.view addSubview:btn];
    [buttomBtns addObject:btn];

    // 右上，发布按钮，后面用图标。
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = FONT_t2;
    btn.frame = CGRectMake(viewWidth - 90, 10, 90, 50);
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_C3 forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    btn.centerY = _titleLabel.centerY;
    [self.view addSubview:btn];
    [buttomBtns addObject:btn];
    
    // 下方2个Tab
  /*  btn = [UIButton new];
    btn.frame = CGRectMake(0, viewHeight-50, viewWidth/2, 50);
    [btn setTitle:@"贴纸" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"Unico/camera_stick_tab_bg"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"Unico/camera_stick_tab_bg_h"] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showStickerList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [buttomBtns addObject:btn];
    stickerTabBtn = btn;
    stickerTabBtn.selected = YES;
    
    btn = [UIButton new];
    btn.frame = CGRectMake(viewWidth/2, viewHeight-50, viewWidth/2, 50);
    [btn setTitle:@"滤镜" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"Unico/camera_stick_tab_bg"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"Unico/camera_stick_tab_bg_h"] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showFilterList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [buttomBtns addObject:btn];
    filterTabBtn = btn;*/
    
    
    _tabBarControl = [[CCTabBarControl alloc] initWithFrame:CGRectMake(0, viewHeight-50, viewWidth, 50)];
    
    [_tabBarControl addTarget:self action:@selector(tabBarControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //_tabBarControl.titles = @[@"贴纸", @"滤镜"];
    
    [self.view addSubview:_tabBarControl];
    
    // TODO: 图层管理，包括锁定，选中，排序，删除等，这个可以下个版本弄。
}

- (void)tabBarControlValueChanged:(CCTabBarControl *)tabBarControl
{
   /* if (tabBarControl.selectedIndex == 0)
    {
        //[self showStickerListWithAnimated:YES];
        
        
        
        
        
        
    }
    else if (tabBarControl.selectedIndex == 1)
    {
        //[self showFilterListWithAnimated:YES];
    }*/
    
    
    if (tabBarControl.selectedIndex != tabBarControl.preSelectedIndex)
    {
        float tx = (tabBarControl.preSelectedIndex - tabBarControl.selectedIndex) * [UIScreen mainScreen].bounds.size.width;
        
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
        filterScroll.layer.transform = CATransform3DTranslate(filterScroll.layer.transform, tx, 0, 0);
        stickerScroll.layer.transform = CATransform3DTranslate(stickerScroll.layer.transform, tx, 0, 0);
        _borderImageScrollView.layer.transform = CATransform3DTranslate(_borderImageScrollView.layer.transform, tx, 0, 0);
        
        } completion:^(BOOL finished) {
            
        }];
        
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            _titleLabel.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                _titleLabel.text = [NSString stringWithFormat:@"选择%@", tabBarControl.titles[tabBarControl.selectedIndex]];
                _titleLabel.alpha = 1;
                
            } completion:^(BOOL finished) {
                
            }];
        }];

    }
}

- (void)showStickerList
{
    //[self showStickerListWithAnimated:NO];
}

- (void)showStickerListWithAnimated:(BOOL)animated
{
  /*  if (animated)
    {
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            _titleLabel.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                _titleLabel.text = @"编辑贴纸";
                _titleLabel.alpha = 1;
                
            } completion:^(BOOL finished) {
                
            }];
        }];

        stickerScroll.layer.transform = CATransform3DMakeTranslation(-stickerScroll.bounds.size.width, 0, 0);
        [self.view addSubview:stickerScroll];

        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            stickerScroll.layer.transform = CATransform3DIdentity;
            filterScroll.layer.transform = CATransform3DMakeTranslation(filterScroll.bounds.size.width, 0, 0);
        } completion:^(BOOL finished) {
            [filterScroll removeFromSuperview];
        }];
    }
    else
    {
        _titleLabel.text = @"编辑贴纸";
        [self.view addSubview:stickerScroll];
        [filterScroll removeFromSuperview];
    }*/
}

- (void)showFilterList
{
    //[self showFilterListWithAnimated:NO];
}

- (void)showFilterListWithAnimated:(BOOL)animated
{
  /*  if (animated)
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            _titleLabel.alpha = 0;
    
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                _titleLabel.text = @"选择滤镜";
                
                _titleLabel.alpha = 1;
                
            } completion:^(BOOL finished) {
                
            }];

        }];

        
        filterScroll.layer.transform = CATransform3DMakeTranslation(filterScroll.bounds.size.width, 0, 0);;
        [self.view addSubview:filterScroll];
        
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            
            filterScroll.layer.transform = CATransform3DIdentity;
            
            stickerScroll.layer.transform = CATransform3DMakeTranslation(-stickerScroll.bounds.size.width, 0, 0);
            
        } completion:^(BOOL finished) {
            
            [stickerScroll removeFromSuperview];
        }];
    }
    else
    {
        _titleLabel.text = @"选择滤镜";
        [self.view addSubview:filterScroll];
        [stickerScroll removeFromSuperview];
    }*/
}

- (void)createStickerScroll:(NSDictionary*)info{
    
    _getStickerImageComplete = YES;
    
    if (info == nil)
    {
        return;
    }
    
    // load sticker list
    NSArray *list = info[@"stick"];
    
    if ((NSNull *)list == [NSNull null])
    {
        return;
    }
    
    if (list==nil || [list count]==0)
    {
        return;
    }
    
    CGRect rect = self.view.frame;
    CGSize size = rect.size;
    
    UIImage *image;
    if (photoVC)
    {
        image = photoVC.photo;
    }
    else
    {
        image = [playerVC snapImage];
    }
    stickerScroll = [UIScrollView new];
    stickerScroll.frame = CGRectMake(0, size.height-150, size.width, 100);
    stickerScroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:stickerScroll];
    
    int count = 0;
    for (NSDictionary* info in list) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(count++ * 95, 0, 100, 100)];
        UIImageView *imgViewBG = [[UIImageView alloc] initWithFrame:imgView.frame];
        imgViewBG.image = image;
        imgView.userInteractionEnabled = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        //imgViewBG.layer.cornerRadius = 10;
        imgViewBG.layer.masksToBounds = YES;
        
        //imgView.layer.cornerRadius = 10;
        imgView.layer.masksToBounds = YES;
        
        [imgView sd_setImageWithURL:info[@"img"] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            // touch event
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onStickTap:)];
            [imgView addGestureRecognizer:recognizer];
        }];
        imgView.center = imgViewBG.center = imgViewBG.center;
        imgView.bounds = imgViewBG.bounds = CGRectInset(imgViewBG.bounds, 10, 10);
        imgViewBG.layer.borderWidth = 1;
        imgViewBG.layer.borderColor = [UIColor blackColor].CGColor;
        
        [stickerScroll addSubview:imgViewBG];
        [stickerScroll addSubview:imgView];
    }
    
    stickerScroll.contentSize = CGSizeMake(count * 100, 100);
}

- (void)createBorderImageScroll:(NSDictionary*)info
{
    _getBorderImageComplete = YES;
    
    if (info == nil)
    {
        return;
    }
    
    // load sticker list
    NSArray *list = info[@"stick"];
    
    if ((NSNull *)list == [NSNull null])
    {
        return;
    }
    
    if (list==nil || [list count]==0)
    {
        return;
    }

    
    CGRect rect = self.view.frame;
    CGSize size = rect.size;
    
    UIImage *image;
    if (photoVC)
    {
        image = photoVC.photo;
    }
    else
    {
        image = [playerVC snapImage];
    }
    
    _borderImageScrollView = [UIScrollView new];
    _borderImageScrollView.frame = CGRectMake(0, size.height-150, size.width, 100);
    _borderImageScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_borderImageScrollView];
    
    
    _borderImageSelectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 82, 82)];
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIImageView *imgViewBG = [[UIImageView alloc] initWithFrame:imgView.frame];
    imgViewBG.image = image;
    imgView.userInteractionEnabled = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    _borderImageSelectedView.center = imgView.center;
    
    //imgViewBG.layer.cornerRadius = 10;
    imgViewBG.layer.masksToBounds = YES;
    
    //imgView.layer.cornerRadius = 10;
    imgView.layer.masksToBounds = YES;
    
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBorderImageTap:)];
    [imgView addGestureRecognizer:recognizer];
    
    imgView.center = imgViewBG.center = imgViewBG.center;
    imgView.bounds = imgViewBG.bounds = CGRectInset(imgViewBG.bounds, 10, 10);
    imgViewBG.layer.borderWidth = 1;
    imgViewBG.layer.borderColor = [UIColor blackColor].CGColor;
    
    [_borderImageScrollView addSubview:imgViewBG];
    [_borderImageScrollView addSubview:imgView];

    
    int count = 0;
    for (NSDictionary* info in list)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((count+1) * 95, 0, 100, 100)];
        UIImageView *imgViewBG = [[UIImageView alloc] initWithFrame:imgView.frame];
        imgViewBG.image = image;
        imgView.userInteractionEnabled = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        //imgViewBG.layer.cornerRadius = 10;
        imgViewBG.layer.masksToBounds = YES;
        
        //imgView.layer.cornerRadius = 10;
        imgView.layer.masksToBounds = YES;
        
        [imgView sd_setImageWithURL:info[@"img"] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            // touch event
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBorderImageTap:)];
            [imgView addGestureRecognizer:recognizer];
        }];
        imgView.center = imgViewBG.center = imgViewBG.center;
        imgView.bounds = imgViewBG.bounds = CGRectInset(imgViewBG.bounds, 10, 10);
        imgViewBG.layer.borderWidth = 1;
        imgViewBG.layer.borderColor = [UIColor blackColor].CGColor;
        
        [_borderImageScrollView addSubview:imgViewBG];
        [_borderImageScrollView addSubview:imgView];
        
        count++;
    }
    
    _borderImageSelectedView.layer.borderColor = COLOR_C1.CGColor;
    _borderImageSelectedView.layer.borderWidth = 3;
    //_borderImageSelectedView.layer.cornerRadius = 10;
    _borderImageSelectedView.layer.masksToBounds = YES;
    [_borderImageScrollView addSubview:_borderImageSelectedView];
    
    _borderImageScrollView.contentSize = CGSizeMake(count * 100, 100);
}


-(void)createFilterScroll{
    
    CGRect rect = self.view.frame;
    CGSize size = rect.size;
    
    UIImage *image;
    if (photoVC) {
        image = photoVC.photo;
    } else {
        image = [playerVC snapImage];
    }

    // filter scroll
    if (filterScroll == nil)
    {
        filterScroll = [UIScrollView new];
    }
    
    filterScroll.frame = CGRectMake(0, size.height-150, size.width, 100);
    filterScroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:filterScroll];
    
    _filterSelectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 82, 82)];
    
    NSArray *filterList = [SUTILITY_TOOL_INSTANCE recorderFilters];
    int count = 0;
    for (SCFilter *filter in filterList) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(count * 95, 0, 100, 100)];
        imgView.userInteractionEnabled = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        if (count == 0)
        {
            _filterSelectedView.center = imgView.center;
        }
        
        //imgView.layer.cornerRadius = 10;
        imgView.layer.masksToBounds = YES;
        
        CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
        ciImage = [filter imageByProcessingImage:ciImage];
        UIImage *uiImage = [UIImage imageWithCIImage:ciImage];
        imgView.image = uiImage;
        [filterScroll addSubview:imgView];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFilterTap:)];
        imgView.tag = count;
        [imgView addGestureRecognizer:recognizer];
        
        imgView.center = imgView.center;
        imgView.bounds = CGRectInset(imgView.bounds, 10, 10);
        imgView.layer.borderWidth = 1;
        imgView.layer.borderColor = [UIColor blackColor].CGColor;
        
        count++;
    }
    
    _filterSelectedView.layer.borderColor = COLOR_C1.CGColor;
    _filterSelectedView.layer.borderWidth = 3;
    //_filterSelectedView.layer.cornerRadius = 10;
    _filterSelectedView.layer.masksToBounds = YES;
    [filterScroll addSubview:_filterSelectedView];

    
    filterScroll.contentSize = CGSizeMake(count * 100, 100);
}

-(void)onFilterTap:(UITapGestureRecognizer*)recognizer{
    UIImageView* imgView = (UIImageView*)recognizer.view;
    NSInteger index = imgView.tag;
    [playerVC changeFilterTo:(int)index];
    [photoVC changeFilterTo:(int)index];
    
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _filterSelectedView.center = imgView.center;
        
    } completion:^(BOOL finished) {
        
    }];
}


-(void)onBorderImageTap:(UITapGestureRecognizer*)recognizer
{
    UIImageView* imgView = (UIImageView*)recognizer.view;
    
    UIImage *image;
    if (photoVC)
    {
        image = photoVC.photo;
    }
    else
    {
        image = [playerVC snapImage];
    }
    
    UIImageView *preBorderImageView = (UIImageView *)[self.renderView viewWithTag:100];
    [preBorderImageView removeFromSuperview];


    float k = image.size.width/image.size.height;
    
    
    if (imgView.image != nil)//有边框
    {
        UIImageView *borderImageView = [[UIImageView alloc] initWithImage:imgView.image];
        
        borderImageView.tag = 100;
        
        borderImageView.frame = CGRectMake(0, 0, self.renderView.width, self.renderView.width/k);
        
        [borderImageView setCenter:self.renderView.center];
        [self.renderView addSubview:borderImageView];
        
        self.borderModel = YES;
    }
    else
    {
        self.borderModel = NO;
    }
    
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _borderImageSelectedView.center = imgView.center;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setBorderModel:(BOOL)borderModel
{
    _borderModel = borderModel;
    
    if (_borderModel)
    {
        //拖动手势
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(photoVCViewPan:)];
        
        //缩放手势
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(photoVCViewPin:)];
        
        
        _renderView.gestureRecognizers = @[panGestureRecognizer, pinchGestureRecognizer];
    }
    else
    {
        _renderView.gestureRecognizers = nil;
        
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            photoVC.view.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
        
        photoVC.view.layer.transform = CATransform3DIdentity;
    }
}

-(void)onStickTap:(UITapGestureRecognizer*)recognizer{
    UIImageView* imgView = (UIImageView*)recognizer.view;
    [self addSticker:imgView.image];
}

#pragma mark - add Items

- (CoverStickerView*)addSticker:(UIImage*)img{
    // add a place holder first,then click to change
    CGRect frame = CGRectMake(CGRectGetMidX(self.renderView.frame),
                              CGRectGetMidY(self.renderView.frame),
                              200, 100);
    CoverStickerView* stickerView = [[CoverStickerView alloc] initWithFrame:frame];
    stickerView.type = CoverStickerTypeImage;
    stickerView.delegate = self;
    UIImageView* imageView = [[UIImageView alloc] initWithImage:nil];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [stickerView setContentView:imageView];
    [stickerView setCenter:self.renderView.center];
    [self.renderView addSubview:stickerView];
    
    [stickerView setImage:img];
    return stickerView;
}


#pragma mark - 保存模板
/*
 * renderView
 * - scrollView
 *   - imageView
 * - CoverStickerView
 */
- (NSArray*)saveTemplate{
    NSArray* ary = [self.renderView subviews];
    NSMutableArray* infoList = [NSMutableArray array];
    for (int i = 0; i < [ary count]; i++) {
        CoverStickerView* sticker = [ary objectAtIndex:i];
        if ([sticker isMemberOfClass:[CoverStickerView class]]) {
            // save frame & other info
            NSDictionary* info = [sticker getInfo];
            [infoList addObject:info];
        }
    }

    //    [[NSUserDefaults standardUserDefaults] setObject:infoList forKey:@"template"];
    return infoList;
}

- (NSString*)getTemplateJSON
{
    NSArray* info = [self saveTemplate];

    if ([NSJSONSerialization isValidJSONObject:info]) {
        NSError* error;
        NSData* registerData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
        return [[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
    }
    else {
        return nil;
    }
}


#pragma mark - Save Video
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    // TODO：此处是调试信息。
//    if (error == nil) {
//        [[[UIAlertView alloc] initWithTitle:@"Saved to camera roll" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//    } else {
//        [[[UIAlertView alloc] initWithTitle:@"Failed to save" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//    }
}


- (void)next
{
    UIImage *stickerLayerImage = [self snapshot2:_renderView];
    // TODO:这里处理video的publish，为了方便，可能需要重构部分代码。
    if(playerVC){
        STagEditController *vc = [[STagEditController alloc] initWithVideo:playerVC.recordSession
                                                           withFilterIndex:[playerVC getFilterIndex]];
        
        
        vc.playerVC.heightWidthRatio = self.heightWidthRatioForVideo;
        
        vc.stickerLayerImage = stickerLayerImage;
//        [self pushController:vc animated:YES];
        // pop掉再push
        UINavigationController *nav = self.navigationController;
        //[nav popViewControllerAnimated:NO];
        [nav pushViewController:vc animated:YES];
        return;
    }
    if (photoVC) {
        UIImage *image = [photoVC saveImage];
        STagEditController *vc = [[STagEditController alloc] initWithImage:image];
        vc.stickerLayerImage = stickerLayerImage;
        [self pushController:vc animated:YES];
        return;
    }
    
}


- (void)back
{
    [self popAnimated:YES];
}


// 后续独立放一个view存放需要snap的内容
// 另外，可能需要分层保存。这个后续再说
// 这个始终是全屏幕的
- (UIImage*)snapshot:(UIView*)view{
    [[CoverStickerView currentEditView] hideEditingHandles];

    // Mark : 第二个参数为 “不透明”
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // crop?
    

    return image;
}

- (UIImage*)previewImage {
    if (photoVC) {
        return photoVC.photo;
    }
    return [playerVC snapImage];
}

// 目前实际使用这个函数。 判断size相关优点啰嗦，后续改进。
// 尺寸根据背景图定。
- (UIImage*)snapshot2:(UIView*)view{
    [[CoverStickerView currentEditView] hideEditingHandles];
    
    UIImage *preview = [self previewImage];
    CGSize size = preview.size;
    float scale = view.frame.size.width/size.width;
    size.width *= scale;
    size.height *= scale;
    
    CGPoint origin = CGPointMake(0, 0);
    origin.y = (view.frame.size.height-size.height)/2;

    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    // 下面那个会让view交互丢失。
    //    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(),0, -origin.y);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // 根据UI Image裁剪，不能简单的判断不透明，因为装饰物可能超出区域。
    return image;
}

#pragma mark - Gesture,增加标签相关
// 取消选择，隐藏编辑界面。
- (void)touchOutside:(UITapGestureRecognizer*)touchGesture{
    
    if (touchGesture.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    [[CoverStickerView currentEditView] hideEditingHandles];
    
}


#pragma mark - scroll image 针对背景图片的缩放等。
- (void)refreshImageView{
    dispatch_async(dispatch_get_main_queue(), ^{
        _imageView.image = _originalImage;
        
        [self resetImageViewFrame];
        [self resetZoomScaleWithAnimate:NO];
    });
}
- (void)resetImageViewFrame{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rct = _imageView.frame;
        rct.size = CGSizeMake(_scrollView.zoomScale*_imageView.image.size.width, _scrollView.zoomScale*_imageView.image.size.height);
        _imageView.frame = rct;
    });
}
- (void)resetZoomScaleWithAnimate:(BOOL)animated{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat Rw = _scrollView.frame.size.width/_imageView.image.size.width;
        CGFloat Rh = _scrollView.frame.size.height/_imageView.image.size.height;
        CGFloat ratio = MIN(Rw, Rh);
        
        _scrollView.contentSize = _imageView.frame.size;
        _scrollView.minimumZoomScale = ratio;
        _scrollView.maximumZoomScale = MAX(ratio/240, 1/ratio);
        
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
    });
}

#pragma mark - ScrollView delegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView{
    return _imageView;
}
- (void)scrollViewDidZoom:(UIScrollView*)scrollView{
    CGFloat Ws = _scrollView.frame.size.width;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _originalImage.size.width * _scrollView.zoomScale;
    CGFloat H = _originalImage.size.height * _scrollView.zoomScale;

    CGRect rct = _imageView.frame;
    rct.origin.x = MAX((Ws - W) / 2, 0);
    rct.origin.y = MAX((Hs - H) / 2, 0);
    _imageView.frame = rct;
}

#pragma mark - no status bar

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - Sticker Delaget

- (void)stickerViewDidEndEditing:(CoverStickerView*)sticker{
    
}

- (void)stickerViewDidShowEditingHandles:(CoverStickerView*)sticker{
    
}
- (void)stickerViewDidHideEditingHandles:(CoverStickerView*)sticker{
    
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"Recorder Recieve memory warning");
}


@end
