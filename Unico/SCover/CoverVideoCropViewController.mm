//
//  ViewController.m
//
//
//  TODO：把贴纸的类整合进来。
// 

#import "CoverVideoCropViewController.h"
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
#import "SStickerEditController.h"
#import "STagEditController.h"
// TODO:添加标签

// 1 单品标签
// 2 品牌标签
// 3 设计师标签
// 4 话题标签



@interface CCTimeSelectionControl : UIControl
{
    UIView  *_bgView;
}


@property(retain, readwrite, nonatomic)UIImageView *startImageView;
@property(retain, readwrite, nonatomic)UIImageView *endImageView;
@property(retain, readwrite, nonatomic)UILabel *currentSelectionLabel;

@property(assign, readwrite, nonatomic)float totalTime;
@property(assign, readwrite, nonatomic)float startTime;
@property(assign, readwrite, nonatomic)float endTime;



@end

@implementation CCTimeSelectionControl


- (id)initWithFrame:(CGRect)frame totalTime:(float)totalTime
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, self.bounds.size.width-10, self.bounds.size.height)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.4;
        
        _bgView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _bgView.layer.borderWidth = 3;
        
        _bgView.layer.cornerRadius = 6;
        _bgView.layer.masksToBounds = YES;
        
        [self addSubview:_bgView];
        
        
        self.currentSelectionLabel = [[UILabel alloc] init];
        self.currentSelectionLabel.backgroundColor = [UIColor yellowColor];
        self.currentSelectionLabel.textAlignment = NSTextAlignmentCenter;
        self.currentSelectionLabel.font = [UIFont systemFontOfSize:13];
        self.currentSelectionLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        self.currentSelectionLabel.layer.borderWidth = 3;
        self.currentSelectionLabel.layer.cornerRadius = 6;
        
        self.currentSelectionLabel.userInteractionEnabled = YES;
        
        UIPanGestureRecognizer *currentSelectionLabelPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(currentSelectionLabelPan:)];
        [self.currentSelectionLabel addGestureRecognizer:currentSelectionLabelPanGestureRecognizer];
        
        
        [self addSubview:self.currentSelectionLabel];
        
        self.startImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/thumb_icon"]];
        self.startImageView.userInteractionEnabled = YES;
        self.startImageView.frame = CGRectMake(0, 0, 10, self.bounds.size.height);
        UIPanGestureRecognizer *startImageViewPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(startImageViewPan:)];
        [self.startImageView addGestureRecognizer:startImageViewPanGestureRecognizer];
        
        [self addSubview:self.startImageView];
        
        self.endImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/thumb_icon"]];
        self.endImageView.userInteractionEnabled = YES;
        self.endImageView.frame = CGRectMake(0, 0, 10, self.bounds.size.height);
        
        UIPanGestureRecognizer *endImageViewPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(endImageViewPan:)];
        [self.endImageView addGestureRecognizer:endImageViewPanGestureRecognizer];
        
        [self addSubview:self.endImageView];
        
        
        [self setStartTime:0.0 endTime:10.0 totalTime:totalTime];
    }
    return self;
}

- (void)currentSelectionLabelPan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [panGestureRecognizer translationInView:self];
        
        if (point.x + self.startImageView.center.x < 5)
        {
            point.x = 5 - self.startImageView.center.x;
        }
        
        if (point.x + self.endImageView.center.x > self.bounds.size.width-5)
        {
            point.x = (self.bounds.size.width-5) -self.endImageView.center.x;
        }
        
        [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self];
        
        self.startImageView.center = CGPointMake(self.startImageView.center.x + point.x, self.startImageView.center.y);
        self.endImageView.center = CGPointMake(self.endImageView.center.x + point.x, self.endImageView.center.y);
        self.currentSelectionLabel.center = CGPointMake(self.currentSelectionLabel.center.x + point.x, self.currentSelectionLabel.center.y);
        
        
        
        self.startTime = ((self.startImageView.center.x-_bgView.frame.origin.x)/_bgView.bounds.size.width) * _totalTime;
        
        self.endTime = ((self.endImageView.center.x-_bgView.frame.origin.x)/_bgView.bounds.size.width) * _totalTime;
        
        
        [self performSelectorWithallTargets];
    }
}

- (void)startImageViewPan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [panGestureRecognizer translationInView:self];
        
        if (point.x + self.startImageView.center.x < 5)
        {
            point.x = 5 - self.startImageView.center.x;
        }

        
        float minL = (3.0 / _totalTime) * _bgView.bounds.size.width;
        BOOL  belowTheMaximum = NO;
        if (self.endImageView.centerX - (point.x + self.startImageView.center.x) < minL)
        {
            //已经低于最小值时、endImageView也跟着动，所以检查一下endImageView不要越界
            if (point.x + self.endImageView.center.x > self.bounds.size.width-5)
            {
                point.x = (self.bounds.size.width-5) -self.endImageView.center.x;
            }
            
            belowTheMaximum = YES;
        }
        
        float maxL = (10.0 / _totalTime) * _bgView.bounds.size.width;
        BOOL  exceedingTheMaximum = NO;
        if (self.endImageView.center.x - (self.startImageView.center.x+point.x) > maxL)
        {
            //已经大于最最大值时、endImageView也跟着动，但不需要检查一下endImageView是否越界，因为endImageView在startImageView的右边。
            exceedingTheMaximum = YES;
        }
        
        [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self];
        
        self.startImageView.center = CGPointMake(self.startImageView.center.x + point.x, self.startImageView.center.y);
        if (exceedingTheMaximum || belowTheMaximum)
        {
            self.endImageView.center = CGPointMake(self.endImageView.center.x + point.x, self.endImageView.center.y);
        }
        self.currentSelectionLabel.frame = CGRectMake(self.startImageView.center.x, 0, self.endImageView.center.x - self.startImageView.center.x, _bgView.bounds.size.height);
        
        
        
        self.startTime = ((self.startImageView.center.x-_bgView.frame.origin.x)/_bgView.bounds.size.width) * _totalTime;
        
        self.endTime = ((self.endImageView.center.x-_bgView.frame.origin.x)/_bgView.bounds.size.width) * _totalTime;
        
        
        float cropTime = _endTime - _startTime;
        
        if (cropTime > 9.8)
        {
            cropTime = 10.00;
        }
        else if (cropTime < 3.1)
        {
            cropTime = 3.00;
        }
        
        self.currentSelectionLabel.text = [NSString stringWithFormat:@"%0.02fs", cropTime];

        [self performSelectorWithallTargets];
    }
    
}

- (void)endImageViewPan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [panGestureRecognizer translationInView:self];
        
        

        if (point.x + self.endImageView.center.x > self.bounds.size.width-5)
        {
            point.x = (self.bounds.size.width-5) -self.endImageView.center.x;
        }
        
        float minL = (3.0 / _totalTime) * _bgView.bounds.size.width;
        BOOL  belowTheMaximum = NO;
        if (point.x + self.endImageView.center.x - self.startImageView.center.x < minL)
        {
            //已经低于最小值时、startImageView也跟着动，所以检查一下startImageView不要越界
            if (point.x + self.startImageView.center.x < 5)
            {
                point.x = 5 - self.startImageView.center.x;
            }
            belowTheMaximum = YES;
        }
        
        float maxL = (10.0 / _totalTime) * _bgView.bounds.size.width;
        BOOL  exceedingTheMaximum = NO;
        if (point.x + self.endImageView.center.x - self.startImageView.center.x > maxL)
        {
            //已经大于最最大值时、startImageView也跟着动，但不需要检查一下startImageView是否越界，因为startImageView在endImageView左边边。
            exceedingTheMaximum = YES;
        }
        
        
        [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self];
        
        if (exceedingTheMaximum || belowTheMaximum)
        {
            self.startImageView.center = CGPointMake(self.startImageView.center.x + point.x, self.startImageView.center.y);
        }
        
        self.endImageView.center = CGPointMake(self.endImageView.center.x + point.x, self.endImageView.center.y);
        
        self.currentSelectionLabel.frame = CGRectMake(self.startImageView.center.x, 0, self.endImageView.center.x - self.startImageView.center.x, _bgView.bounds.size.height);
        
        self.startTime = ((self.startImageView.center.x-_bgView.frame.origin.x)/_bgView.bounds.size.width) * _totalTime;
        
        self.endTime = ((self.endImageView.center.x-_bgView.frame.origin.x)/_bgView.bounds.size.width) * _totalTime;
        
        float cropTime = _endTime - _startTime;
        
        if (cropTime > 9.8)
        {
            cropTime = 10.00;
        }
        else if (cropTime < 3.1)
        {
            cropTime = 3.00;
        }
        
        self.currentSelectionLabel.text = [NSString stringWithFormat:@"%0.02fs", cropTime];
        
        [self performSelectorWithallTargets];
    }
}


- (void)setStartTime:(float)startTime endTime:(float)endTime totalTime:(float)totalTime
{
    _startTime = startTime;
    _endTime = endTime;
    _totalTime = totalTime;
    
    //NSLog(@"startTime = %f endTime = %f totalTime = %f", startTime, endTime, totalTime);
    
    if (self.totalTime > 0 && _startTime < self.totalTime)
    {
        float k = _startTime/self.totalTime;
        
        self.startImageView.center = CGPointMake(_bgView.bounds.size.width*k  + _bgView.frame.origin.x, _bgView.bounds.size.height/2.0);
    }
    
    if (self.totalTime > 0 && _endTime < self.totalTime && _endTime > _startTime)
    {
        float k = _endTime/self.totalTime;
        
        self.endImageView.center = CGPointMake(_bgView.bounds.size.width*k  + _bgView.frame.origin.x, _bgView.bounds.size.height/2.0);
    }
    
    self.currentSelectionLabel.frame = CGRectMake(self.startImageView.center.x, 0, self.endImageView.center.x - self.startImageView.center.x, _bgView.bounds.size.height);
    
    //self.currentSelectionLabel.text = [NSString stringWithFormat:@"%d:%dS", (int)(_endTime - _startTime), (int)((_endTime - _startTime)-(int)(_endTime - _startTime)) * 100];
    
    self.currentSelectionLabel.text = [NSString stringWithFormat:@"%0.02fs", _endTime - _startTime];
}


- (void)performSelectorWithallTargets
{
    NSUInteger allTargetsCount = [[self.allTargets allObjects] count];
    
    for (int i=0; i<allTargetsCount; i++)
    {
        id target = [[self.allTargets allObjects] objectAtIndex:i];
        NSArray *actions = [self actionsForTarget:target forControlEvent:UIControlEventValueChanged];
        
        for (NSString *actionString in actions)
        {
            SEL action = NSSelectorFromString(actionString);
            
            if ([target respondsToSelector:action])
            {
                [target performSelector:action withObject:self];
            }
        }
    }
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (controlEvents & UIControlEventValueChanged)
    {
        [super addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    }
}

@end






@interface CoverVideoCropViewController ()
{
    NSMutableArray *buttomBtns;
    SCVideoPlayerViewController *playerVC; // 播放视频用的
    
    // 对于我们自己选取的视频，如果视频的时间超过10秒，那么我们需要在这里让用户自己选择一段时间
    CCTimeSelectionControl *_timeSelectionControl;
    UISlider *timeSlider;
    CMTime videoStartTime;
    NSMutableArray *cropButtons;
}

@property (nonatomic) UIImage* originalImage;
@property (nonatomic) UIImageView* imageView;
@property (nonatomic) UIImageView* clipImageView;
@property (nonatomic) UIScrollView* scrollView;
@property (nonatomic) UIFont* font;

@property (nonatomic) UIButton* textConfirm, *textCancel;

@property (nonatomic) VerticalAlignTextView* editTextView;
@property (nonatomic) CoverStickerEditView* stikerEdit;

@end

@implementation CoverVideoCropViewController


- (id)initWithVideo:(SCRecordSession*)video {
    
    self = [CoverVideoCropViewController new];
    
    // 这里是一个临时的容错处理
    _originalImage = [UIImage imageWithSize:CGSizeMake(10, 10) andColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"SCamera" bundle:nil];
    playerVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"SCVideoPlayerViewController"];
    playerVC.recordSession = video;
    
    return self;
}

- (void)publish:(NSString*)contentInfo
{
    
}

- (void)dealloc{
    [playerVC.view removeFromSuperview];
    [playerVC removeFromParentViewController];
    playerVC = nil;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor blackColor];
    
   [self createVideoPlayer];

    [self createButtons];
    
    [self createTimeSlider];
    
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)createVideoPlayer{
    // 临时关闭scroll交互。
    _scrollView.userInteractionEnabled = NO;
    [self addChildViewController:playerVC];

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];

    [self.scrollView addSubview:playerVC.view];
    [self.scrollView setBounces:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    self.scrollView.contentSize = playerVC.view.bounds.size;
    self.scrollView.contentMode = UIViewContentModeScaleAspectFill;

    self.scrollView.autoresizesSubviews = NO;
    playerVC.view.contentMode = UIViewContentModeScaleAspectFill;

    [self.view addSubview:self.scrollView];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

// 这里实际生效，隐藏navbar
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
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

- (void)createButtons{
    CGSize size = self.view.frame.size;
    buttomBtns = [NSMutableArray array];
    cropButtons = [NSMutableArray array];
    
    float viewWidth = CGRectGetWidth(self.view.frame);
    float viewHeight = CGRectGetHeight(self.view.frame);
    
    UILabel *title = [UILabel new];
    title.font = [UIFont boldSystemFontOfSize:18];
    title.text = @"裁切";
    title.textColor = [UIColor whiteColor];
    [title sizeToFit];
    title.center = CGPointMake(size.width/2, 42);
    [self.view addSubview:title];

    // 底部的向上按钮，进入图文编辑，用在swap无效时候。
    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0, viewHeight-20, viewWidth , 20);
    upButton.frame = frame;
    [upButton addTarget:self action:@selector(swipeUpHandler:) forControlEvents:(UIControlEventTouchUpInside)];
    //  隐形按钮。
//    [upButton setImage:[UIImage imageNamed:@"swipe_up"] forState:UIControlStateNormal];
    [self.view addSubview:upButton];
    [buttomBtns addObject:upButton];

    // 返回按钮
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(7, 28, 30, 30);
    //btn.center = CGPointMake(40, 50);
    [btn setImage:[UIImage imageNamed:@"Unico/camera_navbar_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [buttomBtns addObject:btn];

    // 右上角，发布按钮，后面用图标。
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = FONT_t2;
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_C3 forState:UIControlStateNormal];
    btn.bounds = CGRectMake(0, 0, 100, 50);
    btn.center = CGPointMake(size.width/6*5+25, 42);
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [buttomBtns addObject:btn];
    
    
    // 先加上三个裁剪大小的按钮

    // Button
    // TODO: 这三个button的位置需要调整
    btn = [UIButton new];
    btn.bounds = CGRectMake(0, 0, 100, 100);
    btn.center = CGPointMake(size.width/4, size.height - 50);
    [btn setImage:[UIImage imageNamed:@"Unico/camera_crop_9_16"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Unico/camera_crop_9_16_h"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(changeCropSize:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 2;
    [cropButtons addObject:btn];
    [self.view addSubview:btn];
    
    // TODO : 3:4目前没有好。暂时让他也是方的。
    btn = [UIButton new];
    btn.bounds = CGRectMake(0, 0, 100, 100);
    btn.center = CGPointMake(size.width/4*2, size.height - 50);
    [btn setImage:[UIImage imageNamed:@"Unico/camera_crop_3_4"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Unico/camera_crop_3_4_h"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(changeCropSize:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 1;
    [cropButtons addObject:btn];
    [self.view addSubview:btn];
    
    btn = [UIButton new];
    btn.bounds = CGRectMake(0, 0, 100, 100);
    btn.center = CGPointMake(size.width/4*3, size.height - 50);
    [btn setImage:[UIImage imageNamed:@"Unico/camera_crop_1_1"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Unico/camera_crop_1_1_h"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(changeCropSize:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 0;
    [cropButtons addObject:btn];
    [self.view addSubview:btn];
    
   // [UIColor yellowColor];
    
   [self changeCropSize:btn];//默认1：1

    // TODO: 图层管理，包括锁定，选中，排序，删除等，这个可以下个版本弄。
}

- (void)createTimeSlider {
    // 如果超过10秒，那么需要显示，否则不显示
   /* int64_t videoLength = playerVC.recordSession.duration.value / playerVC.recordSession.duration.timescale;
    if (videoLength > 10) {
        float viewWidth = CGRectGetWidth(self.view.frame);
        float viewHeight = CGRectGetHeight(self.view.frame);

        timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, viewHeight - 160, viewWidth - 10 * 2, 30)];
        [timeSlider addTarget:self action:@selector(timeSliderValueChanged) forControlEvents:UIControlEventValueChanged];
        timeSlider.continuous = YES;
        timeSlider.minimumValue = 0;
        timeSlider.maximumValue = (float)videoLength;
        timeSlider.minimumValueImage = nil;    // TODO: 应该可以设置一个就不是默认蓝色的了。
        // timeSlider setThumbImage 可以尝试修改一下image，可以直接变得长条状 TODO:
        // 这个方案应该可以，根据总时间长度，来设置thumbImage的长度，大概表示一个比例。
        CGSize size = self.view.frame.size;
        float width = 10.0f/videoLength*size.width;
        if (width<20) {
            width = 20;
        }
        
       //  thumb_icon.png
        
        UIImage *img = [UIImage imageWithSize:CGSizeMake(10.0f/videoLength*size.width, 16) andColor:[UIColor yellowColor]];
        UIImage *imgTrack = [UIImage imageWithSize:CGSizeMake(10, 10) andColor:[UIColor lightGrayColor]];
        [timeSlider setThumbImage:img forState:UIControlStateNormal];
        
        [timeSlider setMinimumTrackImage:imgTrack forState:UIControlStateNormal];
        [timeSlider setMaximumTrackImage:imgTrack forState:UIControlStateNormal];
        
        [self.view addSubview:timeSlider];
    }*/
    
    
    int64_t videoLength = playerVC.recordSession.duration.value / playerVC.recordSession.duration.timescale;
    if (videoLength > 10)
    {
        float viewWidth = CGRectGetWidth(self.view.frame);
        float viewHeight = CGRectGetHeight(self.view.frame);
        
        UIView *timeSelectionControlBgView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight - 150, viewWidth, 80)];
        
        timeSelectionControlBgView.backgroundColor = [UIColor clearColor];

        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        
        [timeSelectionControlBgView addGestureRecognizer:panGestureRecognizer];
        
        [self.view addSubview:timeSelectionControlBgView];
        
        NSLog(@"self.navigationController = %@", self.navigationController);

        
        _timeSelectionControl = [[CCTimeSelectionControl alloc] initWithFrame:CGRectMake(20, (80-35)/2.0, viewWidth - 20 * 2, 35) totalTime:videoLength];
        
        [_timeSelectionControl addTarget:self action:@selector(timeSelectionControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [timeSelectionControlBgView addSubview:_timeSelectionControl];
    }
}

- (void)pan:(UIGestureRecognizer *)gestureRecognizer
{
    //NSLog(@"pan");//这里是为了屏蔽导航栏自带的滑动返回上级页面
}

- (void)timeSelectionControlValueChanged:(CCTimeSelectionControl *)timeSelectionControl
{
   /* CMTime seekTime = playerVC.recordSession.duration;
    seekTime.value = seekTime.timescale * (int)timeSlider.value;
    
    videoStartTime = seekTime;
    
    [playerVC seekToTimeAndReplay:seekTime];*/
    
    CMTime seekTime = playerVC.recordSession.duration;
    seekTime.value = seekTime.timescale * (int)timeSelectionControl.startTime;
    
    videoStartTime = seekTime;
    
    [playerVC seekToTimeAndReplay:seekTime];
}



#pragma mark - Save Video
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    // TODO：此处是调试信息。
    if (error == nil) {
//        [[[UIAlertView alloc] initWithTitle:@"Saved to camera roll" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Failed to save" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

#pragma mark - 修改视频的大小
-(void)changeCropSize:(UIButton*)sender{
    NSLog(@"button %ld selected.", (long)sender.tag);

    for (UIButton* btn in cropButtons) {
        btn.selected = NO;
    }
    sender.selected = YES;
    
    // sender.tag
    //    0 => 1:1
    //    1 => 4:3
    //    2 => 16:9
    if (sender.tag == 0)
    {
        // 让scrollView放到中间
        CGSize size = self.view.bounds.size;
        self.scrollView.frame = CGRectMake(0, 0, size.width, size.width);
        self.scrollView.center = CGPointMake(size.width/2.0, size.height/2.0);
        [self.scrollView setNeedsDisplay];
    }
    else if (sender.tag == 1)
    {
        CGSize size = self.view.bounds.size;
        self.scrollView.frame = CGRectMake(0, (size.height-size.width)/2, size.width, size.width * 4.0/3.0);
        self.scrollView.center = CGPointMake(size.width/2.0, size.height/2.0);
        [self.scrollView setNeedsDisplay];
    }
    else
    {
        // 让scrollView占满全部屏幕
        CGSize size = self.view.bounds.size;
        self.scrollView.frame = CGRectMake(0, (size.height-size.width)/2, size.width, size.width * 16.0/9.0);
        self.scrollView.center = CGPointMake(size.width/2.0, size.height/2.0);
        [self.scrollView setNeedsDisplay];
    }
    
    //self.scrollView.layer.borderColor = [UIColor redColor].CGColor;
    //self.scrollView.layer.borderWidth = 2;
}

#pragma mark - publish video & image
- (void)doNextWithURL:(NSURL*)imageUrl{
    
    // 创建一个新的SCRecordSession给下一步使用
    SCRecordSession* newRecordSession = [SCRecordSession recordSession];
    [newRecordSession addSegment:[SCRecordSessionSegment segmentWithURL:imageUrl info:nil]];

    SStickerEditController *vc = [[SStickerEditController alloc] initWithVideo:newRecordSession];
    
    
    float k = 1;
    
    for (UIButton *button in cropButtons)
    {
        if (button.selected)
        {
            if (button.tag == 0)
            {
                k = 1.0;
            }
            else if (button.tag == 1)
            {
                k = 4.0/3.0;
            }
            else if (button.tag == 2)
            {
                k = 16.0/9.0;
            }
        }
    }

    vc.heightWidthRatioForVideo = k;
    // pop 掉自己
    //    STagEditController *vc = [[STagEditController alloc] initWithVideo:newRecordSession];
    
    //[self.navigationController popViewControllerAnimated:NO];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)next
{
    // 先保存，然后跳转到下一步的操作
    SDataVideoFunc completionHandler = ^(NSURL *url, NSError *error)
    {
        // 完成的时候需要把progressView去掉
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (error == nil)
        {
//            UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            // upload here
            NSLog(@"URL: %@",url);
            // 真正的跳转
            [self doNextWithURL:url];
        }
        else
        {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            [[[UIAlertView alloc] initWithTitle:@"保存失败" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }
    };

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    float percent = (self.scrollView.contentOffset.y+1) / self.scrollView.contentSize.height;
    //[playerVC saveVideoWithYOffset:percent withCompletion:completionHandler];
    
    NSLog(@"percent = %f", percent);
    
    float k = 1;
    
    for (UIButton *button in cropButtons)
    {
        if (button.selected)
        {
            if (button.tag == 0)
            {
                k = 1.0;
            }
            else if (button.tag == 1)
            {
                k = 4.0/3.0;
            }
            else if (button.tag == 2)
            {
                k = 16.0/9.0;
            }
        }
    }
    
    NSLog(@"self.rotate = %d", self.rotate);
    
    [playerVC saveVideoWithYOffset:percent heightWidthRatio:k rotate:self.rotate startTime:_timeSelectionControl.startTime endTime:_timeSelectionControl.endTime withCompletion:completionHandler];
    
    return;
}

- (void)back
{
    [self popAnimated:YES];
}

-(void)timeSliderValueChanged
{
    CMTime seekTime = playerVC.recordSession.duration;
    seekTime.value = seekTime.timescale * (int)timeSlider.value;
    
    videoStartTime = seekTime;

    [playerVC seekToTimeAndReplay:seekTime];
}

#pragma mark - hide status bar

- (BOOL)prefersStatusBarHidden{
    return NO;
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"Recorder Recieve memory warning");
}
@end
