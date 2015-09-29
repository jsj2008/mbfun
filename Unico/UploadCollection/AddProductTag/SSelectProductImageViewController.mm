//
//  SSelectProductImageViewController.m
//  Wefafa
//
//  Created by chencheng on 15/8/17.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SSelectProductImageViewController.h"
#import "SUtilityTool.h"
#import "SAddProductTagViewControlCenter.h"
#import "OpenCVTool.h"

#import "SAVPlayerView.h"

@interface SSelectProductImageViewController ()<UIGestureRecognizerDelegate>
{
    UINavigationBar *_navigationBar;
    
    UIImageView *_imageView;
    UIImage *_originalImage;
    
    
    SAVPlayerView *_playerView;
    NSURL *_videoURL;
    
    CGSize _videoSize;
    
    
    UIView *_maskView;
    
    UIView *_leftMaskView;
    UIView *_upMaskView;
    UIView *_rightMaskView;
    UIView *_bottomMaskView;
    
    CGRect _maskMaxRect;
    
    void(^_didFinishPickingImage)(UIImage *originalImage, UIImage *productImage);
}

@end

@implementation SSelectProductImageViewController


#pragma mark - 属性接口


- (void)setOriginalImage:(UIImage *)originalImage
{
    _originalImage = originalImage;
    _videoURL = nil;
    
    if ([self isViewLoaded])
    {
        [_imageView removeFromSuperview];
        
        _imageView = [[UIImageView alloc] initWithFrame:_maskMaxRect];
        _imageView.image = _originalImage;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.view insertSubview:_imageView belowSubview:_maskView];
        [self layoutSubviews];
        
        [_playerView pause];
        [_playerView removeFromSuperview];
    }
}

- (void)setVideoURL:(NSURL *)videoURL
{
    _videoURL = videoURL;
    _originalImage = nil;
    
    AVAsset *avAsset = [AVAsset assetWithURL:videoURL];
    
    NSArray * tracks = [avAsset tracks];
    for(AVAssetTrack* track in tracks)
    {
        if ([[track mediaType] isEqualToString:AVMediaTypeVideo])
        {
            _videoSize = CGSizeMake(track.naturalSize.width, track.naturalSize.height);
            break;
        }
    }
    
    if ([self isViewLoaded])
    {
        [_playerView pause];
        [_playerView removeFromSuperview];
        _playerView = [[SAVPlayerView alloc] initWithAsset:avAsset];
        
        [self.view insertSubview:_playerView belowSubview:_maskView];
        [self layoutSubviews];
        
        [_imageView removeFromSuperview];
    }
}



#pragma mark - 构造与析构

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
        self.navigationItem.leftBarButtonItems = @[backButtonItem];
        
        UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonClick:)];
        self.navigationItem.rightBarButtonItems = @[nextButtonItem];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH-200)/2.0, 0, 200, 44)];
        titleLabel.font = FONT_SIZE(18);
        titleLabel.textColor = COLOR_WHITE;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"截取单品快照";
        
        self.navigationItem.titleView = titleLabel;
    }
    return self;
}

- (void)dealloc
{
    [_playerView pause];//注意：没有这句话，会出现内存泄露，_playerView不会释放,一直在后台播放
}

#pragma mark - 视图控制器接口

- (void)viewWillAppear:(BOOL)animated
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
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [_playerView play];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_playerView pause];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavbar];
    
    self.view.layer.masksToBounds = YES;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _maskMaxRect = CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44-80);
    
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor clearColor];
    _maskView.layer.borderColor = [UIColor whiteColor].CGColor;
    _maskView.layer.borderWidth = 1;
    [self.view addSubview:_maskView];
    
    _leftMaskView = [[UIView alloc] init];
    _leftMaskView.backgroundColor = [UIColor blackColor];
    _leftMaskView.alpha = 0.5;
    [self.view addSubview:_leftMaskView];
    
    _upMaskView = [[UIView alloc] init];
    _upMaskView.backgroundColor = _leftMaskView.backgroundColor;
    _upMaskView.alpha = _leftMaskView.alpha;
    [self.view addSubview:_upMaskView];
    
    _rightMaskView = [[UIView alloc] init];
    _rightMaskView.backgroundColor = _leftMaskView.backgroundColor;
    _rightMaskView.alpha = _leftMaskView.alpha;
    [self.view addSubview:_rightMaskView];
    
    _bottomMaskView = [[UIView alloc] init];
    _bottomMaskView.backgroundColor = _leftMaskView.backgroundColor;
    _bottomMaskView.alpha = _leftMaskView.alpha;
    [self.view addSubview:_bottomMaskView];
    
    
    
    if (_originalImage != nil)
    {
        _imageView = [[UIImageView alloc] initWithFrame:_maskMaxRect];
        _imageView.image = _originalImage;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view insertSubview:_imageView belowSubview:_maskView];
    }
    else if (_videoURL != nil)
    {
        _playerView = [[SAVPlayerView alloc] initWithAsset:[AVAsset assetWithURL:_videoURL]];
        _playerView.tapForPlayOrPause = YES;
        [self.view insertSubview:_playerView belowSubview:_maskView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:_playerView action:@selector(tap:)];
        [_maskView addGestureRecognizer:tapGestureRecognizer];
    }
    
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pin:)];
    pinchGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    
    [self layoutSubviews];
    
    
    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-80, UI_SCREEN_WIDTH, 80)];
    bottomBgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomBgView];
    
    //选择相册照片按钮
    UIImageView *recentImageView = [UIImageView new];
    [recentImageView setContentMode:UIViewContentModeScaleAspectFill];
    recentImageView.frame = CGRectMake(0, 0, 50, 50);
    recentImageView.center = CGPointMake(50/2, 50/2);
    recentImageView.layer.cornerRadius = 5;
    recentImageView.layer.masksToBounds = YES;
    recentImageView.image = [UIImage imageNamed:@"Unico/nophoto"];//默认图片
    [[SUtilityTool shared] getRecentImage:recentImageView assetsFilter:[ALAssetsFilter allAssets]];
    
    UIButton *selectImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectImageButton addTarget:self action:@selector(selectImagebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectImageButton addSubview:recentImageView];
    
    selectImageButton.bounds = CGRectMake(0, 0, 50, 50);
    selectImageButton.center = CGPointMake(50, UI_SCREEN_HEIGHT-40);
    
    [self.view addSubview:selectImageButton];
    
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *cameraImage = [UIImage imageNamed:@"Unico/ico_camera"];
    cameraButton.frame = CGRectMake(0, 0, cameraImage.size.width/2.0, cameraImage.size.height/2.0);
    cameraButton.center = CGPointMake(UI_SCREEN_WIDTH-50, UI_SCREEN_HEIGHT-40);
    [cameraButton setImage:cameraImage forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(cameraButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraButton];
    
    [self.view addSubview:_navigationBar];
}

- (void)layoutSubviews
{
    CGRect maskViewFrame;
    CGRect leftMaskViewFrame;
    CGRect upMaskViewFrame;
    CGRect rightMaskViewFrame;
    CGRect bottomMaskViewFrame;
    
    CGRect imageViewFrame;
    
    float maskViewWidth = UI_SCREEN_WIDTH;
    float maskViewHeight = maskViewWidth;
    
    maskViewFrame = CGRectMake((_maskMaxRect.size.width-maskViewWidth)/2.0 + _maskMaxRect.origin.x, (_maskMaxRect.size.height-maskViewHeight)/2.0 + _maskMaxRect.origin.y, maskViewWidth, maskViewHeight);
    
    leftMaskViewFrame = CGRectMake(0, maskViewFrame.origin.y, maskViewFrame.origin.x, maskViewFrame.size.height);
    upMaskViewFrame = CGRectMake(0, _maskMaxRect.origin.y, _maskMaxRect.size.width, maskViewFrame.origin.y - _maskMaxRect.origin.y);
    rightMaskViewFrame = CGRectMake(maskViewFrame.origin.x + maskViewFrame.size.width, leftMaskViewFrame.origin.y, leftMaskViewFrame.size.width, leftMaskViewFrame.size.height);
    bottomMaskViewFrame = CGRectMake(0, maskViewFrame.origin.y + maskViewFrame.size.height, upMaskViewFrame.size.width, upMaskViewFrame.size.height);
    
    _leftMaskView.frame = leftMaskViewFrame;
    _upMaskView.frame = upMaskViewFrame;
    _rightMaskView.frame = rightMaskViewFrame;
    _bottomMaskView.frame = bottomMaskViewFrame;

    _maskView.frame = maskViewFrame;

    if (_originalImage != nil)
    {
        if (_imageView.image.size.height/_imageView.image.size.width > 1)
        {
            float imageViewWidth = maskViewFrame.size.width;
            float imageViewHeight = imageViewWidth * (_imageView.image.size.height/_imageView.image.size.width);
            
            imageViewFrame = CGRectMake(maskViewFrame.origin.x, (maskViewFrame.size.height-imageViewHeight)/2.0 + maskViewFrame.origin.y, imageViewWidth, imageViewHeight);
        }
        else
        {
            float imageViewHeight =  maskViewFrame.size.height;
            float imageViewWidth = imageViewHeight/(_imageView.image.size.height/_imageView.image.size.width);
            
            imageViewFrame = CGRectMake((maskViewFrame.size.width-imageViewWidth)/2.0 + maskViewFrame.origin.x, maskViewFrame.origin.y, imageViewWidth, imageViewHeight);
        }

        _imageView.frame = imageViewFrame;
    }
    else if (_videoURL != nil)
    {
        if (_videoSize.height/_videoSize.width > 1)
        {
            float imageViewWidth = maskViewFrame.size.width;
            float imageViewHeight = imageViewWidth * (_videoSize.height/_videoSize.width);
            
            imageViewFrame = CGRectMake(maskViewFrame.origin.x, (maskViewFrame.size.height-imageViewHeight)/2.0 + maskViewFrame.origin.y, imageViewWidth, imageViewHeight);
        }
        else
        {
            float imageViewHeight =  maskViewFrame.size.height;
            float imageViewWidth = imageViewHeight/(_videoSize.height/_videoSize.width);
            
            imageViewFrame = CGRectMake((maskViewFrame.size.width-imageViewWidth)/2.0 + maskViewFrame.origin.x, maskViewFrame.origin.y, imageViewWidth, imageViewHeight);
        }
        
        _playerView.frame = imageViewFrame;
    }
}

#pragma mark - 其他UI接口
/**
 *   构建导航栏
 */
- (void)setupNavbar
{
    [super setupNavbar];
    
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44)];
    [_navigationBar pushNavigationItem:self.navigationItem animated:NO];
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/blackBarBg.jpg"] forBarMetrics:UIBarMetricsDefault];
    [_navigationBar setBarTintColor:[UIColor blackColor]];
    [self.view addSubview:_navigationBar];
    
    _navigationBar.layer.transform = CATransform3DMakeTranslation(0, 0, 5);
}

#pragma mark - 控件事件接口

- (void)backButtonClick:(id)sender
{
    if (self.back != nil)
    {
        self.back();
    }
}

- (void)doneButtonClick:(id)sender
{
    if (_didFinishPickingImage != nil)
    {
        if (self.originalImage != nil)
        {
            _didFinishPickingImage(self.originalImage, [self cropImage]);
        }
        else if (self.videoURL != nil)
        {
            _didFinishPickingImage(nil, [self cropVideoCurrentFrame]);
        }
    }
}

- (void)selectImagebuttonClick:(id)sender
{
    [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showSelectProductImageAssetsPickerWithAnimated:YES];
}

- (void)cameraButtonClick:(id)sender
{
    [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showSelectProductImageCameraViewWithAnimated:YES];
}

#pragma mark - 手势接口

- (void)pan:(UIPanGestureRecognizer *)panGestureRecognizer
{

    
    static BOOL  prePlaying = NO;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        prePlaying = [_playerView isPlaying];
        [_playerView pause];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded
             || panGestureRecognizer.state == UIGestureRecognizerStateCancelled
             || panGestureRecognizer.state == UIGestureRecognizerStateFailed)
    {
        if (prePlaying)
        {
            [_playerView play];
        }
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [panGestureRecognizer translationInView:self.view];
        
        float tx = point.x;
        float ty = point.y;
        
        if (_originalImage != nil)
        {
            //不过分往右拖动
            if (tx + _imageView.frame.origin.x >= _maskView.frame.origin.x)
            {
                tx = _maskView.frame.origin.x - _imageView.frame.origin.x;
            }
            
            //不过分往左拖动
            if (tx + _imageView.frame.origin.x + _imageView.frame.size.width <= _maskView.frame.origin.x + _maskView.frame.size.width)
            {
                tx = (_maskView.frame.origin.x + _maskView.frame.size.width) - (_imageView.frame.origin.x + _imageView.frame.size.width);
            }
            
            
            //不过分往下拖动
            if (ty + _imageView.frame.origin.y >= _maskView.frame.origin.y)
            {
                ty = _maskView.frame.origin.y - _imageView.frame.origin.y;
            }
            
            //不过分往上拖动
            if (ty + _imageView.frame.origin.y + _imageView.frame.size.height <= _maskView.frame.origin.y + _maskView.frame.size.height)
            {
                ty = (_maskView.frame.origin.y + _maskView.frame.size.height) - (_imageView.frame.origin.y + _imageView.frame.size.height);
            }
            
            float s = _imageView.layer.transform.m11;
            tx = tx / s;
            ty = ty / s;
            
            _imageView.layer.transform = CATransform3DTranslate(_imageView.layer.transform, tx, ty, 0);
        }
        else if (_videoURL != nil)
        {
            //不过分往右拖动
            if (tx + _playerView.frame.origin.x >= _maskView.frame.origin.x)
            {
                tx = _maskView.frame.origin.x - _playerView.frame.origin.x;
            }
            
            //不过分往左拖动
            if (tx + _playerView.frame.origin.x + _playerView.frame.size.width <= _maskView.frame.origin.x + _maskView.frame.size.width)
            {
                tx = (_maskView.frame.origin.x + _maskView.frame.size.width) - (_playerView.frame.origin.x + _playerView.frame.size.width);
            }
            
            //不过分往下拖动
            if (ty + _playerView.frame.origin.y >= _maskView.frame.origin.y)
            {
                ty = _maskView.frame.origin.y - _playerView.frame.origin.y;
            }
            
            //不过分往上拖动
            if (ty + _playerView.frame.origin.y + _playerView.frame.size.height <= _maskView.frame.origin.y + _maskView.frame.size.height)
            {
                ty = (_maskView.frame.origin.y + _maskView.frame.size.height) - (_playerView.frame.origin.y + _playerView.frame.size.height);
            }
            
            float s = _playerView.layer.transform.m11;
            tx = tx / s;
            ty = ty / s;
            
            _playerView.layer.transform = CATransform3DTranslate(_playerView.layer.transform, tx, ty, 0);
        }
    }
    
    [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void)pin:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    static BOOL prePlaying = NO;
    
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        prePlaying = [_playerView isPlaying];
        [_playerView pause];
    }
    else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded
             || pinchGestureRecognizer.state == UIGestureRecognizerStateCancelled
             || pinchGestureRecognizer.state == UIGestureRecognizerStateFailed)
    {
        if (prePlaying)
        {
            [_playerView play];
        }
    }
    else if (pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        float s = pinchGestureRecognizer.scale;
        
        if (_originalImage != nil)
        {
            if (s * _imageView.frame.size.width <= _maskView.frame.size.width)
            {
                s = _maskView.frame.size.width/_imageView.frame.size.width;
            }
            
            if (s * _imageView.frame.size.height <= _maskView.frame.size.height)
            {
                s = _maskView.frame.size.height/_imageView.frame.size.height;
            }
            
            _imageView.layer.transform = CATransform3DScale(_imageView.layer.transform, s, s, 1);
            
            float tx = 0;
            float ty = 0;
            
            //不过分往右拖动
            if (tx + _imageView.frame.origin.x >= _maskView.frame.origin.x)
            {
                tx = _maskView.frame.origin.x - _imageView.frame.origin.x;
            }
            
            //不过分往左拖动
            if (tx + _imageView.frame.origin.x + _imageView.frame.size.width <= _maskView.frame.origin.x + _maskView.frame.size.width)
            {
                tx = (_maskView.frame.origin.x + _maskView.frame.size.width) - (_imageView.frame.origin.x + _imageView.frame.size.width);
            }
            
            
            //不过分往下拖动
            if (ty + _imageView.frame.origin.y >= _maskView.frame.origin.y)
            {
                ty = _maskView.frame.origin.y - _imageView.frame.origin.y;
            }
            
            //不过分往上拖动
            if (ty + _imageView.frame.origin.y + _imageView.frame.size.height <= _maskView.frame.origin.y + _maskView.frame.size.height)
            {
                ty = (_maskView.frame.origin.y + _maskView.frame.size.height) - (_imageView.frame.origin.y + _imageView.frame.size.height);
                
            }
            
            tx = tx / _imageView.layer.transform.m11;
            ty = ty / _imageView.layer.transform.m11;
            
            _imageView.layer.transform = CATransform3DTranslate(_imageView.layer.transform, tx, ty, 0);
        }
        else if (_videoURL != nil)
        {
            if (s * _playerView.frame.size.width <= _maskView.frame.size.width)
            {
                s = _maskView.frame.size.width/_playerView.frame.size.width;
            }
            
            if (s * _playerView.frame.size.height <= _maskView.frame.size.height)
            {
                s = _maskView.frame.size.height/_playerView.frame.size.height;
            }
            
            _playerView.layer.transform = CATransform3DScale(_playerView.layer.transform, s, s, 1);
            
            float tx = 0;
            float ty = 0;
            
            //不过分往右拖动
            if (tx + _playerView.frame.origin.x >= _maskView.frame.origin.x)
            {
                tx = _maskView.frame.origin.x - _playerView.frame.origin.x;
            }
            
            //不过分往左拖动
            if (tx + _playerView.frame.origin.x + _playerView.frame.size.width <= _maskView.frame.origin.x + _maskView.frame.size.width)
            {
                tx = (_maskView.frame.origin.x + _maskView.frame.size.width) - (_playerView.frame.origin.x + _playerView.frame.size.width);
            }
            
            
            //不过分往下拖动
            if (ty + _playerView.frame.origin.y >= _maskView.frame.origin.y)
            {
                ty = _maskView.frame.origin.y - _playerView.frame.origin.y;
            }
            
            //不过分往上拖动
            if (ty + _playerView.frame.origin.y + _playerView.frame.size.height <= _maskView.frame.origin.y + _maskView.frame.size.height)
            {
                ty = (_maskView.frame.origin.y + _maskView.frame.size.height) - (_playerView.frame.origin.y + _playerView.frame.size.height);
                
            }
            
            tx = tx / _playerView.layer.transform.m11;
            ty = ty / _playerView.layer.transform.m11;
            
            _playerView.layer.transform = CATransform3DTranslate(_playerView.layer.transform, tx, ty, 0);
        }
    }
    
    pinchGestureRecognizer.scale = 1;
}

#pragma mark - UIGestureRecognizerDelegate接口

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (CGRect)cropRect
{
    CGRect cropRect = CGRectMake(0, 0, 0, 0);
    
    if (_originalImage != nil)//图片的裁剪区域
    {
        float x = 0;
        float y = 0;
        
        float width = 0;
        float height = 0;
        
        float k = _imageView.image.size.width / _imageView.frame.size.width;
        
        x = (_maskView.frame.origin.x -  _imageView.frame.origin.x) * k;
        y = (_maskView.frame.origin.y -  _imageView.frame.origin.y) * k;
        
        width = _maskView.frame.size.width * k;
        height = _maskView.frame.size.height * k;
        
        cropRect = CGRectMake(x, y, width, height);
    }
    else if (_videoURL != nil)//视频裁剪区域
    {
        float x = 0;
        float y = 0;
        
        float width = 0;
        float height = 0;
        
        float k = _videoSize.width / _playerView.frame.size.width;
        
        x = (_maskView.frame.origin.x -  _playerView.frame.origin.x) * k;
        y = (_maskView.frame.origin.y -  _playerView.frame.origin.y) * k;
        
        
        width = _maskView.frame.size.width * k;
        height = _maskView.frame.size.height * k;
        
        cropRect = CGRectMake(x, y, width, height);
    }
    
    return cropRect;
}

- (UIImage *)cropImage
{
    CGRect cropRect = [self cropRect];
    
    IplImage *srcIplImage = OpenCVTool::createBGRIplImageFromUIImage(_imageView.image);
    
    
    IplImage *destIplImage = cvCreateImage(cvSize(cropRect.size.width, cropRect.size.height), srcIplImage->depth, srcIplImage->nChannels);
    
    OpenCVTool::clip(srcIplImage, destIplImage, cropRect.origin.x, cropRect.origin.y, cropRect.size.width, cropRect.size.height);
    
    cvReleaseImage(&srcIplImage);
    
    IplImage *resizeIplImage = cvCreateImage(cvSize(250, 250 * (cropRect.size.height/cropRect.size.width)), destIplImage->depth, destIplImage->nChannels);
    
    cvResize(destIplImage, resizeIplImage);
    
    cvReleaseImage(&destIplImage);
    
    UIImage *retImage = OpenCVTool::createRGBUIImageFromIplImage(resizeIplImage);
    
    return retImage;
}

- (UIImage *)cropVideoCurrentFrame
{
    CGRect cropRect = [self cropRect];
    
    IplImage *srcIplImage = OpenCVTool::createBGRIplImageFromUIImage([_playerView currentFrame]);
    
    
    IplImage *destIplImage = cvCreateImage(cvSize(cropRect.size.width, cropRect.size.height), srcIplImage->depth, srcIplImage->nChannels);
    
    OpenCVTool::clip(srcIplImage, destIplImage, cropRect.origin.x, cropRect.origin.y, cropRect.size.width, cropRect.size.height);
    
    cvReleaseImage(&srcIplImage);
    
    IplImage *resizeIplImage = cvCreateImage(cvSize(250, 250 * (cropRect.size.height/cropRect.size.width)), destIplImage->depth, destIplImage->nChannels);
    
    cvResize(destIplImage, resizeIplImage);
    
    cvReleaseImage(&destIplImage);
    
    UIImage *retImage = OpenCVTool::createRGBUIImageFromIplImage(resizeIplImage);
    
    return retImage;
}




@end
