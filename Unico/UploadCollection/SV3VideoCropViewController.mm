//
//  SV3VideoCropViewController.m
//  Wefafa
//
//  Created by chencheng on 15/8/26.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SV3VideoCropViewController.h"

#import "SUtilityTool.h"

#import "SUploadColllocationControlCenter.h"

#import "OpenCVTool.h"
#import <MediaPlayer/MediaPlayer.h>
#import "OpenCVPlayerView.h"
#import "Dialog.h"
#import "STimePeriodSelecterControl.h"
#import "SAVPlayerView.h"

#import "Toast.h"

@interface SV3VideoCropViewController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
{
    UINavigationBar *_navigationBar;
    
    UIImageView *_imageView;
    UIImage *_image;
    
    SAVPlayerView *_playerView;
    CvCapture   *_capture;
    AVAsset *_asset;
    CGSize _videoSize;
    float _videoDuration;
    STimePeriodSelecterControl *_timePeriodSelecterControl;
    
    
    UIView *_maskView;
    
    UIView *_leftMaskView;
    UIView *_upMaskView;
    UIView *_rightMaskView;
    UIView *_bottomMaskView;
    
    CGRect _maskMaxRect;
    
    UIButton *_crop16_9Button;
    UIButton *_crop4_3Button;
    UIButton *_crop1_1Button;
}

@end

@implementation SV3VideoCropViewController

#pragma mark - 属性接口


- (void)setVideoSize:(CGSize)videoSize
{
    _videoSize = videoSize;
    
    NSLog(@"_videoSize.width = %f, _videoSize.height = %f", _videoSize.width, _videoSize.height);
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    _asset = nil;
    
    if ([self isViewLoaded])
    {
        [_imageView removeFromSuperview];
        
        _imageView = [[UIImageView alloc] initWithFrame:_maskMaxRect];
        _imageView.image = _image;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.view insertSubview:_imageView belowSubview:_maskView];
        [self fitCropSizeWithAnimated:NO];
        
        [_playerView pause];
        [_playerView removeFromSuperview];
    }
}

- (void)setAsset:(AVAsset *)asset
{
    _asset = asset;
    _image = nil;

    _videoDuration = (float)(_asset.duration.value)/(float)(_asset.duration.timescale);
    
    if ([self isViewLoaded])
    {
       /* 这里之后要重新考虑逻辑
        
        [_playerView pause];
        [_playerView removeFromSuperview];
        _playerView = [[SAVPlayerView alloc] initWithAsset:_asset];
        
        [self.view insertSubview:_playerView belowSubview:_maskView];
        [self fitCropSizeWithAnimated:NO];
        
        [_imageView removeFromSuperview];
        
        
        if (_videoDuration > 10)
        {
            if (_timePeriodSelecterControl == nil)
            {
                _timePeriodSelecterControl = [[STimePeriodSelecterControl alloc] initWithFrame:CGRectMake(20, UI_SCREEN_HEIGHT - 130, UI_SCREEN_WIDTH - 40, 35) totalDuration:_videoDuration miniSelecterDuration:3.0 maxSelecterDuration:10];
                [_timePeriodSelecterControl addTarget:self action:@selector(timePeriodSelecterControlValueChanged:) forControlEvents:UIControlEventValueChanged];
                [self.view addSubview:_timePeriodSelecterControl];
            }
        }
        else
        {
            if (_timePeriodSelecterControl != nil)
            {
                [_timePeriodSelecterControl removeFromSuperview];
                _timePeriodSelecterControl = nil;
            }
        }*/

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
        
        UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonClick:)];
        self.navigationItem.rightBarButtonItems = @[nextButtonItem];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH-200)/2.0, 0, 200, 44)];
        titleLabel.font = FONT_SIZE(18);
        titleLabel.textColor = COLOR_WHITE;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"裁切";
        
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
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;

    
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
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.view.layer.masksToBounds = YES;
    
    
    
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor clearColor];
    _maskView.layer.borderColor = [UIColor whiteColor].CGColor;
    _maskView.layer.borderWidth = 1;
    [self.view addSubview:_maskView];
    
    _leftMaskView = [[UIView alloc] init];
    _leftMaskView.backgroundColor = [UIColor blackColor];
    _leftMaskView.alpha = 0.4;
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
    
    
    
    if (_image != nil)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = _image;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.view insertSubview:_imageView belowSubview:_maskView];
        
        UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-80, UI_SCREEN_WIDTH, 80)];
        bottomBgView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:bottomBgView];
        
        _maskMaxRect = CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44-80);
    }
    
    
    if (_asset != nil)
    {
        _playerView = [[SAVPlayerView alloc] initWithAsset:_asset];
        _playerView.tapForPlayOrPause = YES;
        
        [self.view insertSubview:_playerView belowSubview:_maskView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:_playerView action:@selector(tap:)];
        [_maskView addGestureRecognizer:tapGestureRecognizer];
        
        if (_videoDuration > 11)
        {
            UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-130, UI_SCREEN_WIDTH, 130)];
            bottomBgView.backgroundColor = [UIColor blackColor];
            [self.view addSubview:bottomBgView];
            
            _timePeriodSelecterControl = [[STimePeriodSelecterControl alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - 115, UI_SCREEN_WIDTH, 35) totalDuration:_videoDuration miniSelecterDuration:3.0 maxSelecterDuration:10];
            [_timePeriodSelecterControl addTarget:self action:@selector(timePeriodSelecterControlValueChanged:) forControlEvents:UIControlEventValueChanged];
            [self.view addSubview:_timePeriodSelecterControl];
            
            
            _maskMaxRect = CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44-130);
        }
        else
        {
            UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-80, UI_SCREEN_WIDTH, 80)];
            bottomBgView.backgroundColor = [UIColor blackColor];
            [self.view addSubview:bottomBgView];
            
            _maskMaxRect = CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44-80);
        }
    }
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    panGestureRecognizer.delaysTouchesBegan = YES;
    panGestureRecognizer.delaysTouchesEnded = YES;
    panGestureRecognizer.delegate = self;
    [_maskView addGestureRecognizer:panGestureRecognizer];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pin:)];
    pinchGestureRecognizer.delegate = self;
    [_maskView addGestureRecognizer:pinchGestureRecognizer];
    
    
    if (_asset != nil
        && UI_SCREEN_WIDTH==320
        && UI_SCREEN_HEIGHT==480)//iPhone 4 or 4s  不支持16：9的视频裁剪
    {
        _crop4_3Button = [UIButton new];
        _crop4_3Button.bounds = CGRectMake(0, 0, 55, 55);
        _crop4_3Button.center = CGPointMake(UI_SCREEN_WIDTH*1.0/4.0+15, UI_SCREEN_HEIGHT - 40);
        [_crop4_3Button setImage:[UIImage imageNamed:@"Unico/camera_crop_3_4"] forState:UIControlStateNormal];
        [_crop4_3Button setImage:[UIImage imageNamed:@"Unico/camera_crop_3_4_h"] forState:UIControlStateSelected];
        [_crop4_3Button addTarget:self action:@selector(crop4_3ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_crop4_3Button];
        
        _crop1_1Button = [UIButton new];
        _crop1_1Button.bounds = CGRectMake(0, 0, 55, 55);
        _crop1_1Button.center = CGPointMake(UI_SCREEN_WIDTH*3.0/4.0-15, UI_SCREEN_HEIGHT - 40);
        [_crop1_1Button setImage:[UIImage imageNamed:@"Unico/camera_crop_1_1"] forState:UIControlStateNormal];
        [_crop1_1Button setImage:[UIImage imageNamed:@"Unico/camera_crop_1_1_h"] forState:UIControlStateSelected];
        [_crop1_1Button addTarget:self action:@selector(crop1_1ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _crop1_1Button.selected = YES;//默认1：1
        [self.view addSubview:_crop1_1Button];
    }
    else
    {
        _crop16_9Button = [UIButton new];
        _crop16_9Button.bounds = CGRectMake(0, 0, 55, 55);
        _crop16_9Button.center = CGPointMake(UI_SCREEN_WIDTH/4.0, UI_SCREEN_HEIGHT - 40);
        [_crop16_9Button setImage:[UIImage imageNamed:@"Unico/camera_crop_9_16"] forState:UIControlStateNormal];
        [_crop16_9Button setImage:[UIImage imageNamed:@"Unico/camera_crop_9_16_h"] forState:UIControlStateSelected];
        [_crop16_9Button addTarget:self action:@selector(crop16_9ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_crop16_9Button];
        
        _crop4_3Button = [UIButton new];
        _crop4_3Button.bounds = CGRectMake(0, 0, 55, 55);
        _crop4_3Button.center = CGPointMake(UI_SCREEN_WIDTH/2.0, UI_SCREEN_HEIGHT - 40);
        [_crop4_3Button setImage:[UIImage imageNamed:@"Unico/camera_crop_3_4"] forState:UIControlStateNormal];
        [_crop4_3Button setImage:[UIImage imageNamed:@"Unico/camera_crop_3_4_h"] forState:UIControlStateSelected];
        [_crop4_3Button addTarget:self action:@selector(crop4_3ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_crop4_3Button];
        
        _crop1_1Button = [UIButton new];
        _crop1_1Button.bounds = CGRectMake(0, 0, 55, 55);
        _crop1_1Button.center = CGPointMake(UI_SCREEN_WIDTH*3.0/4.0, UI_SCREEN_HEIGHT - 40);
        [_crop1_1Button setImage:[UIImage imageNamed:@"Unico/camera_crop_1_1"] forState:UIControlStateNormal];
        [_crop1_1Button setImage:[UIImage imageNamed:@"Unico/camera_crop_1_1_h"] forState:UIControlStateSelected];
        [_crop1_1Button addTarget:self action:@selector(crop1_1ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _crop1_1Button.selected = YES;//默认1：1
        [self.view addSubview:_crop1_1Button];
    }
    
    
    [self.view addSubview:_navigationBar];
    
    [self fitCropSizeWithAnimated:NO];
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
    };
}

- (void)nextButtonClick:(id)sender
{
    if (_image != nil)
    {
        
        if (self.didFinishCropImage != nil)
        {
            self.didFinishCropImage([self cropImage]);
        };
    }
    else if (_asset != nil)
    {
        UIView *dialogView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
        dialogView.backgroundColor = [UIColor blackColor];
        dialogView.layer.cornerRadius = 8;
        dialogView.layer.masksToBounds = YES;
        dialogView.alpha = 0.8;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dialogView.frame.size.width, dialogView.frame.size.height/2.0)];
        titleLabel.text = @"正在裁切视频";
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        [dialogView addSubview:titleLabel];
        
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, dialogView.frame.size.height/3.0, dialogView.frame.size.width, dialogView.frame.size.height/2.0)];
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [activityIndicatorView startAnimating];
        [dialogView addSubview:activityIndicatorView];
        
        [CCDialog showDialogView:dialogView modal:YES showDialogViewAnimationOption:QFShowDialogViewAnimationNone completion:^(BOOL finished) {
            
        }];
        
        [_playerView pause];
        
        [self cropVideoWithcompletion:^(NSURL* cropVideoURL) {
            
            
            NSLog(@"全部完成 cropVideoURL = %@", cropVideoURL);
            
            if (self.didFinishCropVideo != nil)
            {
                self.didFinishCropVideo(cropVideoURL);
            };
        }];
    }
}


- (void)timePeriodSelecterControlValueChanged:(STimePeriodSelecterControl *)timePeriodSelecterControl
{
    NSLog(@"startSelecterTime = %f, endSelecterTime = %f", timePeriodSelecterControl.startSelecterTime, timePeriodSelecterControl.endSelecterTime);
    
    [_playerView seekToTime:timePeriodSelecterControl.startSelecterTime endTime:timePeriodSelecterControl.endSelecterTime];
}


- (void)crop16_9ButtonClick:(id)sender
{
    if (_crop16_9Button.selected)
    {
        return;
    }
    
    _crop16_9Button.selected = YES;
    _crop4_3Button.selected = NO;
    _crop1_1Button.selected = NO;
    
    [self fitCropSizeWithAnimated:YES];
}

- (void)crop4_3ButtonClick:(id)sender
{
    if (_crop4_3Button.selected)
    {
        return;
    }
    
    _crop16_9Button.selected = NO;
    _crop4_3Button.selected = YES;
    _crop1_1Button.selected = NO;
    
    [self fitCropSizeWithAnimated:YES];
}

- (void)crop1_1ButtonClick:(id)sender
{
    if (_crop1_1Button.selected)
    {
        return;
    }
    
    _crop16_9Button.selected = NO;
    _crop4_3Button.selected = NO;
    _crop1_1Button.selected = YES;
    
    [self fitCropSizeWithAnimated:YES];
}

- (void)fitCropSizeWithAnimated:(BOOL)animated
{
    CGRect maskViewFrame;
    CGRect leftMaskViewFrame;
    CGRect upMaskViewFrame;
    CGRect rightMaskViewFrame;
    CGRect bottomMaskViewFrame;
    
    
    NSLog(@"_videoSize.width = %f, _videoSize.height = %f", _videoSize.width, _videoSize.height);
    
    CGRect imageViewFrame;
    
    float k = 1;
    
    if (_crop1_1Button.selected)
    {
        k = 1.0;
    }
    else if (_crop4_3Button.selected)
    {
        k = 4.0/3.0;
    }
    else if (_crop16_9Button.selected)
    {
        k = 16.0/9.0;
    }
    
    if (_maskMaxRect.size.height/_maskMaxRect.size.width >= k)
    {
        float maskViewWidth = _maskMaxRect.size.width;
        float maskViewHeight = maskViewWidth * k;
        maskViewFrame = CGRectMake(0, (_maskMaxRect.size.height-maskViewHeight)/2.0 + _maskMaxRect.origin.y, maskViewWidth, maskViewHeight);
    }
    else
    {
        float maskViewHeight = _maskMaxRect.size.height;
        float maskViewWidth = maskViewHeight/k;
        
        maskViewFrame = CGRectMake((_maskMaxRect.size.width-maskViewWidth)/2.0, _maskMaxRect.origin.y, maskViewWidth, maskViewHeight);
    }
    
    leftMaskViewFrame = CGRectMake(0, maskViewFrame.origin.y, maskViewFrame.origin.x, maskViewFrame.size.height);
    upMaskViewFrame = CGRectMake(0, _maskMaxRect.origin.y, _maskMaxRect.size.width, maskViewFrame.origin.y - _maskMaxRect.origin.y);
    rightMaskViewFrame = CGRectMake(maskViewFrame.origin.x + maskViewFrame.size.width, leftMaskViewFrame.origin.y, leftMaskViewFrame.size.width, leftMaskViewFrame.size.height);
    bottomMaskViewFrame = CGRectMake(0, maskViewFrame.origin.y + maskViewFrame.size.height, upMaskViewFrame.size.width, upMaskViewFrame.size.height);
    
    if (_image != nil)
    {
        if (_imageView.image.size.height/_imageView.image.size.width > k)
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
    }
    
    if (_asset != nil)
    {
        if (_videoSize.height/_videoSize.width > k)
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
    }
    
    
    if (animated)
    {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _maskView.frame = maskViewFrame;
            
            _leftMaskView.frame = leftMaskViewFrame;
            _upMaskView.frame = upMaskViewFrame;
            _rightMaskView.frame = rightMaskViewFrame;
            _bottomMaskView.frame = bottomMaskViewFrame;
            
            _imageView.layer.transform = CATransform3DIdentity;
            _imageView.frame = imageViewFrame;
            
            _playerView.layer.transform = CATransform3DIdentity;
            _playerView.frame = imageViewFrame;
            
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        _maskView.frame = maskViewFrame;
        
        _leftMaskView.frame = leftMaskViewFrame;
        _upMaskView.frame = upMaskViewFrame;
        _rightMaskView.frame = rightMaskViewFrame;
        _bottomMaskView.frame = bottomMaskViewFrame;
        
        _imageView.layer.transform = CATransform3DIdentity;
        _imageView.frame = imageViewFrame;
        
        _playerView.layer.transform = CATransform3DIdentity;
        _playerView.frame = imageViewFrame;
    }
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
        CGPoint point = [panGestureRecognizer locationInView:self.view];
        if (! CGRectContainsPoint(_timePeriodSelecterControl.frame, point))
        {
            CGPoint translation = [panGestureRecognizer translationInView:self.view];
            
            float tx = translation.x;
            float ty = translation.y;
            
            if (_image != nil)//处理照片
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
            
            if (_asset != nil)//处理视频
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
        
        
        if (_image != nil)//处理照片
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
        
        if (_asset != nil)//处理视频
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


#pragma mark - 裁切接口

- (CGRect)cropRect
{
    CGRect cropRect = CGRectMake(0, 0, 0, 0);
    
    if (_image != nil)//图片的裁剪区域
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
    else if (_asset != nil)//视频裁剪区域
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
    
    IplImage *resizeIplImage = cvCreateImage(cvSize(750, 750 * (cropRect.size.height/cropRect.size.width)), destIplImage->depth, destIplImage->nChannels);
    
    cvResize(destIplImage, resizeIplImage);
    
    cvReleaseImage(&destIplImage);
    
    UIImage *retImage = OpenCVTool::createRGBUIImageFromIplImage(resizeIplImage);
    
    return retImage;
}

- (void)cropVideoWithcompletion:(void (^)(NSURL* cropVideoURL))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSString *temVideoFilePath = [NSString stringWithFormat:@"%@/tmp/video.mp4", NSHomeDirectory()];
        
        [[NSFileManager defaultManager] removeItemAtPath:temVideoFilePath error:nil];
        NSURL *temVideoFileURL = [[NSURL alloc] initFileURLWithPath:temVideoFilePath];
        
        
        AVAssetExportSession *tempExporter = [[AVAssetExportSession alloc]initWithAsset:_asset presetName:AVAssetExportPresetHighestQuality];
        tempExporter.outputURL = temVideoFileURL;
        tempExporter.outputFileType = AVFileTypeQuickTimeMovie;
        tempExporter.shouldOptimizeForNetworkUse = YES;
        
        if (_timePeriodSelecterControl != nil)
        {
            tempExporter.timeRange = CMTimeRangeMake(CMTimeMake(_timePeriodSelecterControl.startSelecterTime * _asset.duration.timescale, _asset.duration.timescale), CMTimeMake((_timePeriodSelecterControl.endSelecterTime - _timePeriodSelecterControl.startSelecterTime) * _asset.duration.timescale, _asset.duration.timescale));
        }
        
        [tempExporter exportAsynchronouslyWithCompletionHandler:^{
            
            NSLog(@"导出完成");
            AVAsset *avAsset = [AVAsset assetWithURL:temVideoFileURL];
            
            int fps = 24;
            
            
            NSArray * tracks = [avAsset tracks];
            for(AVAssetTrack* track in tracks)
            {
                if ([[track mediaType] isEqualToString:AVMediaTypeVideo])
                {
                    fps = track.nominalFrameRate;
                    //_videoSize = CGSizeMake(track.naturalSize.width, track.naturalSize.height);
                    break;
                }
            }
            

            //UISaveVideoAtPathToSavedPhotosAlbum(temVideoFilePath, self, @selector(video: didFinishSavingWithError: contextInfo:), nil);
            
            
            CGRect cropRect = [self cropRect];//裁切空间区域
            
            CvCapture *newCapture = cvCreateFileCapture([temVideoFilePath UTF8String]);
            
            //生成视频文件
            NSString *cropVideoFilePath = [NSString stringWithFormat:@"%@/tmp/cropVideo.mp4", NSHomeDirectory()];
            
            [[NSFileManager defaultManager] removeItemAtPath:cropVideoFilePath error:nil];
            
            //即将要创建的视频（抛弃音轨）
            CvVideoWriter *videoWriter = cvCreateVideoWriter([cropVideoFilePath UTF8String], CV_FOURCC('M', 'J', 'P', 'G'), fps, cvSize(750, 750 * (cropRect.size.height/cropRect.size.width)));
            
            int sumsFrames = 0;
            if (_timePeriodSelecterControl != nil)
            {
                sumsFrames  = (_timePeriodSelecterControl.endSelecterTime - _timePeriodSelecterControl.startSelecterTime)*fps;
            }
            
            int i = 0;
            while (1)
            {
                @autoreleasepool {
                    
                    IplImage *srcIplImage = cvQueryFrame(newCapture);
                    
                    if (srcIplImage == NULL)
                    {
                        break;
                    }

                    IplImage *srcIplImage2 = nil;
                    
                    //NSLog(@"srcIplImage->width = %d, _videoSize.width = %f", srcIplImage->width, _videoSize.width);
                    
                    if (((float)srcIplImage->width - _videoSize.width) > 1)//表示这里比例颠倒了 以后再来找原因，先暂时这样处理 这种情况左右出现黑边
                    {
                        srcIplImage2 = OpenCVTool::rotateImageAndResize(srcIplImage, -90);
                    }
                    
                    IplImage *destIplImage = cvCreateImage(cvSize(cropRect.size.width, cropRect.size.height), srcIplImage->depth, srcIplImage->nChannels);
                    
                    if (srcIplImage2 == nil)
                    {
                        OpenCVTool::clip(srcIplImage, destIplImage, cropRect.origin.x, cropRect.origin.y, cropRect.size.width, cropRect.size.height);
                    }
                    else
                    {
                        OpenCVTool::clip(srcIplImage2, destIplImage, cropRect.origin.x, cropRect.origin.y, cropRect.size.width, cropRect.size.height);
                        cvReleaseImage(&srcIplImage2);
                    }
                    
                    IplImage *resizeIplImage = cvCreateImage(cvSize(750, 750 * (cropRect.size.height/cropRect.size.width)), destIplImage->depth, destIplImage->nChannels);
                    
                    cvResize(destIplImage, resizeIplImage);
                    
                    cvReleaseImage(&destIplImage);
                    
                    int ret = cvWriteFrame(videoWriter, resizeIplImage);
                    if (ret != 1)
                    {
                        NSLog(@"cvWriteFrame err");
                    }
                    
                    cvReleaseImage(&resizeIplImage);
                    
                    i++;
                    if (_timePeriodSelecterControl != nil)
                    {
                        if (i >= sumsFrames)
                        {
                            break;
                        }
                        
                    }
                    
                }
               
            }
            
            cvReleaseVideoWriter(&videoWriter);
            cvReleaseCapture(&newCapture);
            
            
            
            AVAsset *videAsset = [AVAsset assetWithURL:[[NSURL alloc] initFileURLWithPath:cropVideoFilePath]];
            
            AVMutableComposition *avMutableComposition = [[AVMutableComposition alloc] init];
            
            //创建一个视频轨道
            AVMutableCompositionTrack *videoTrack = [avMutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            
            NSError *error = nil;
            
            //NSLog(@"[[videAsset tracksWithMediaType:AVMediaTypeVideo] count] = %d", (int)[[videAsset tracksWithMediaType:AVMediaTypeVideo] count]);
            
            BOOL ret = [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videAsset.duration) ofTrack:[[videAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
            
            //NSLog(@"视频轨道 ret = %d error = %@", ret, error);
            
            NSArray *originAudioTrackArray = [avAsset tracksWithMediaType:AVMediaTypeAudio];
            
            //NSLog(@"[originAudioTrackArray count] = %d", (int)[originAudioTrackArray count]);
            
            //加入音轨
            if ([originAudioTrackArray count] > 0)
            {
                //创建一个音频轨道
                AVMutableCompositionTrack *audioTrack = [avMutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
                
                //NSLog(@"audioTrack = %@", audioTrack);
                
                NSError *error = nil;
                
                BOOL ret = [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videAsset.duration) ofTrack:[originAudioTrackArray objectAtIndex:0] atTime:kCMTimeZero error: &error];
                
                NSLog(@"ret = %d error = %@", ret, error);
            }
            
            //生成视频文件
            NSString *corpVideAndAudioFilePath = [NSString stringWithFormat:@"%@/tmp/corpVideAndAudio.mp4", NSHomeDirectory()];
            [[NSFileManager defaultManager] removeItemAtPath:corpVideAndAudioFilePath error:nil];
            
            NSURL *corpVideAndAudioURL = [[NSURL alloc] initFileURLWithPath:corpVideAndAudioFilePath];
            
            
            //设置输出对象
            AVAssetExportSession *exporter = [[AVAssetExportSession alloc]initWithAsset:avMutableComposition presetName:AVAssetExportPresetHighestQuality];
            exporter.outputURL = corpVideAndAudioURL;
            exporter.outputFileType = AVFileTypeQuickTimeMovie;
            exporter.shouldOptimizeForNetworkUse = YES;
            
        
            //NSLog(@"[AVAssetExportSession allExportPresets] = %@", [AVAssetExportSession allExportPresets]);
            
            [exporter exportAsynchronouslyWithCompletionHandler:^{
                
                
                NSLog(@"11 exporter.error = %@", exporter.error);
                
                if (exporter.error == nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //UISaveVideoAtPathToSavedPhotosAlbum(corpVideAndAudioFilePath, self, @selector(video: didFinishSavingWithError: contextInfo:), nil);
                        
                        NSLog(@"裁剪完成");
                        
                        [[NSFileManager defaultManager] removeItemAtPath:temVideoFilePath error:nil];// 删除了只进行了时间轴裁剪的视频，原来的长宽尺寸
                        [[NSFileManager defaultManager] removeItemAtPath:cropVideoFilePath error:nil];// 删除了只进行了空间裁剪的视频，无音轨
                        
                        NSLog(@"删除完成");
                        
                        if (completion != nil)
                        {
                            completion([[NSURL alloc] initFileURLWithPath:corpVideAndAudioFilePath]);
                        }
                    });
                }
                else
                {
                    [CCDialog closeDialogViewWithAnimationOptions:QFCloseDialogViewAnimationNone completion:nil];
                    
                    [Toast makeToast:@"裁切失败"];
                }
            }];
        }];
    });
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"视频把保存完成 error = %@", error);
}

@end



