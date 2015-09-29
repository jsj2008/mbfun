//
//  VRViewController.m
//  VideoRecorder
//
//  Created by Simon CORSIN on 8/3/13.
//  Copyright (c) 2013 SCorsin. All rights reserved.
//
//  TODO:
//  目前返回Recorder会有数组越界中断。
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SCTouchDetector.h"
#import "SCRecorderViewController.h"
#import "SCVideoPlayerViewController.h"
#import "SCImageDisplayerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SCSessionListViewController.h"
#import "SCRecordSessionManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CoverEditViewController.h"
#import "CoverVideoCropViewController.h"

#import "SUtilityTool.h"
#import "AppDelegate.h"

#import "PhotoVideoSceneSelecteViewController.h"
#import "OpenCVTool.h"

// 拍摄或选择后，先跳转到裁剪界面。
// 视频的裁剪需要有时间和尺寸2个维度
#import "SImageCropController.h"

#import "Dialog.h"


static  UIWindow *g_cameraStartSlideWindow = nil;

#define kVideoPreset AVCaptureSessionPresetHigh

////////////////////////////////////////////////////////////
// PRIVATE DEFINITION
/////////////////////

typedef NS_ENUM(NSInteger, UICameraMode) {
    CameraModePhotoMode = 0,
    CameraModeVideoMode
};


@interface SCRecorderViewController ()<UzysAssetsPickerControllerDelegate>{
    SCRecorder *_recorder;
    UIImage *_photo;
    //SCRecordSession *_recordSession;
    UIImageView *_ghostImageView;
    UIButton *gallaryButton;
    
    UILabel    *_photoModeLabel;
    UILabel    *_videoModeLabel;
    
    UICameraMode   _currentModel;
    
    
    //拍摄照片按钮
    UIButton *_pickPhotoButton;
    
    //开始拍摄视频按钮
    UIButton *_videoRecordBtn;
    
    //视频拍摄结束
    UIButton *_stopVideoRecordBtn;
    
    UIScrollView *_cameraModeScrollView;
    //指示拍摄模式的小黄点
    UIView *_yellowDotView;
    
    UILabel  *_videoTimeLabel;
    
    
    int _numberOfDisappear;//第几次显示该页面 ，一般情况下，从下级页面返回到该页，是第N次（N>=1, 从0开始计算）
    
    
    UIButton *_flashBtn;
    UIButton *_switchCameraBtn;
    
    UIButton *_multipleSelectionBtn;
    
    UIButton *_selectImagebutton;
    UIImageView *_recentImageView;
    
    NSMutableArray  *_recordProgressDividingLineMutableArray;
    
    UIButton *_deleteSegmentVideoButton;
    
    
    BOOL _backupStatusBarHidden;
    BOOL _backupNavigationBarHidden;
}

@property(assign, readwrite, nonatomic)BOOL rotate;//是否考虑旋转

@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UILabel *timeRecordedLabel;

@property (nonatomic) UIView *recordView; // 录像按钮
@property (nonatomic) UIButton *stopButton; // 录像结束
@property (nonatomic) UIButton *retakeButton;
@property (nonatomic) UIButton *videoBackPhotoBtn;
@property (nonatomic) UIButton *photoToVideoBtn;

@property (nonatomic) IBOutlet UIView *loadingView;

@property (nonatomic) IBOutlet UIView *downBar;

@property (nonatomic) IBOutlet UIButton *reverseCamera;
@property (nonatomic) IBOutlet UIButton *flashModeButton;
@property (nonatomic) IBOutlet UIButton *capturePhotoButton;
@property (nonatomic) IBOutlet UIButton *ghostModeButton;
@property (nonatomic) IBOutlet UIProgressView *recordProgress;
@property (strong, nonatomic) SCRecorderToolsView *focusView;

@end

////////////////////////////////////////////////////////////
// IMPLEMENTATION
/////////////////////

@implementation SCRecorderViewController

#pragma mark - UIViewController


#pragma mark - Left cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.masksToBounds = YES;
    
    
    
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initRecorder];
    
    
    
    [self prepareSession];
}


- (void)initRecorder
{
    _ghostImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _ghostImageView.contentMode = UIViewContentModeScaleAspectFill;
    _ghostImageView.alpha = 0.2;
    _ghostImageView.userInteractionEnabled = NO;
    _ghostImageView.hidden = YES;
    
    
    [self.view insertSubview:_ghostImageView aboveSubview:self.previewView];
    
    _recorder = [SCRecorder recorder];
    _recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    _recorder.maxRecordDuration = CMTimeMake(10, 1);
    
    _recorder.delegate = self;
    _recorder.autoSetVideoOrientation = YES;
    
    UIView *previewView = self.previewView;
    _recorder.previewView = previewView;
    CGRect bounds = self.view.bounds;
    self.focusView = [[SCRecorderToolsView alloc] initWithFrame:bounds];
    self.focusView.recorder = _recorder;
    [previewView addSubview:self.focusView];
    
    
    
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [_recorder.previewView addGestureRecognizer:leftSwipeGestureRecognizer];
    
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [_recorder.previewView addGestureRecognizer:rightSwipeGestureRecognizer];
    
    
    self.focusView.outsideFocusTargetImage = [UIImage imageNamed:@"Unico/camera_focus"];
    self.focusView.insideFocusTargetImage = nil;
    
    _recorder.initializeSessionLazily = NO;
    
    // progress bar的高度和图片
    _recordProgress = [UIProgressView new];
    _recordProgress.frame = CGRectMake(0, 0, bounds.size.width, 1);
    _recordProgress.transform = CGAffineTransformMakeScale(1.0f,8.0f);
    [_recordProgress setProgressImage:[UIImage imageNamed:@"Unico/camera_progress_bar"]];
    [_recordProgress setTrackImage:[UIImage imageNamed:@"Unico/camera_progress_bg"]];
    self.recordProgress.layer.masksToBounds = YES;
    [self.view addSubview:_recordProgress];
    
    //分端线
    _recordProgressDividingLineMutableArray = [[NSMutableArray alloc] init];
    
    
    // 拍摄相关的UI
    [self createCameraButtons];
    
    // 初始化切换到相机
    [self initCameraMode];
    
    NSError *error;
    if (![_recorder prepare:&error]) {
        NSLog(@"Prepare error: %@", error.localizedDescription);
    }
}

- (void)leftSwipe:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    if (self.recorderStyle == RecorderViewOnlyPhotoStyle)
    {
        return;
    }
    
    
    if (_currentModel == CameraModeVideoMode && [_recorder.session.segments count] > 0)
    {
        return;//正在录制视频  不能切换成照相模式
    }
    
    if (_currentModel != CameraModePhotoMode)
    {
        _currentModel = CameraModePhotoMode;
        [self switchCameraModeWithAnimated:YES];
    }
}

- (void)rightSwipe:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    if (_currentModel != CameraModeVideoMode)
    {
        _currentModel = CameraModeVideoMode;
        [self switchCameraModeWithAnimated:YES];
    }
}

- (void)photoModeLabelTap:(UITapGestureRecognizer *)TapGestureRecognizer
{
    if (_currentModel == CameraModeVideoMode && [_recorder.session.segments count] > 0)
    {
        return;//正在录制视频  不能切换成照相模式
    }
    
    if (_currentModel != CameraModePhotoMode)
    {
        _currentModel = CameraModePhotoMode;
        [self switchCameraModeWithAnimated:YES];
    }
}

- (void)videoModeLabelTap:(UITapGestureRecognizer *)TapGestureRecognizer
{
    if (_currentModel != CameraModeVideoMode)
    {
        _currentModel = CameraModeVideoMode;
        [self switchCameraModeWithAnimated:YES];
    }
}


- (void)initCameraMode{
    self.recordView.alpha = 0.0;
    self.retakeButton.alpha = 1.0; // 显示一下，因为是用这个返回的目前
    self.stopButton.alpha = 0.0;
    self.recordProgress.alpha = 0;
    self.capturePhotoButton.alpha = 1.0;
    self.ghostModeButton.alpha = 0;
    gallaryButton.alpha = 1;
    
    //    _recorder.captureSessionPreset = kVideoPreset;
    [self.flashModeButton setImage:[UIImage imageNamed:@"s_flash_auto"] forState:UIControlStateNormal];
    _recorder.flashMode = SCFlashModeAuto;
}

- (void)createCameraButtons
{
    
    CGSize size = self.view.frame.size;
    float leftCenter = 40;
    float rightCenter = size.width - leftCenter;
    float btnSize = 50;
    float btnRecordSize = 100;
    // ------------------------------------------------------------------------------------
    // Buttom 底部的按钮
    // ------------------------------------------------------------------------------------
    
    //底部的背景
    UIView  *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height-130, size.width, 130)];
    bottomBgView.backgroundColor = [UIColor blackColor];
    bottomBgView.alpha = 0.5;
    [self.view addSubview:bottomBgView];
    
    
    UISwipeGestureRecognizer *bottomBgViewLeftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    bottomBgViewLeftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [bottomBgView addGestureRecognizer:bottomBgViewLeftSwipeGestureRecognizer];
    
    UISwipeGestureRecognizer *bottomBgViewRightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    bottomBgViewRightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [bottomBgView addGestureRecognizer:bottomBgViewRightSwipeGestureRecognizer];

    
    //指示拍摄模式的小黄点
    _yellowDotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    _yellowDotView.backgroundColor = [UIColor yellowColor];
    _yellowDotView.layer.cornerRadius = 4;
    _yellowDotView.layer.masksToBounds = YES;
    _yellowDotView.center = CGPointMake(size.width/2.0, bottomBgView.frame.origin.y + 10);
    [self.view addSubview:_yellowDotView];
    
    //在滚动视图上选择 拍照模式 或 拍视频 模式
    _cameraModeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH-180)/2.0, bottomBgView.frame.origin.y, 180, 50)];
    _cameraModeScrollView.backgroundColor = [UIColor clearColor];
    //_cameraModeScrollView.center = CGPointMake(size.width/2.0, bottomBgView.frame.origin.y + 30);
    _cameraModeScrollView.contentSize = CGSizeMake(_cameraModeScrollView.bounds.size.width*4.0/3.0, _cameraModeScrollView.bounds.size.height);
    _cameraModeScrollView.pagingEnabled = YES;
    _cameraModeScrollView.layer.masksToBounds = NO;
    _cameraModeScrollView.delegate = (id)self;
    _cameraModeScrollView.scrollEnabled = NO;//添加了手势来控制，所以在此干脆把这个属性禁止掉。
    _cameraModeScrollView.tag = 1;
    _cameraModeScrollView.showsHorizontalScrollIndicator = NO;
    _cameraModeScrollView.canCancelContentTouches = YES;
    _cameraModeScrollView.delaysContentTouches = NO;
    
    
    UISwipeGestureRecognizer *scrollViewLeftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    scrollViewLeftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *scrollViewRightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    scrollViewRightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;

    [_cameraModeScrollView addGestureRecognizer:scrollViewLeftSwipeGestureRecognizer];
    [_cameraModeScrollView addGestureRecognizer:scrollViewRightSwipeGestureRecognizer];
    
    
    //NSLog(@"bottomBgView.gestureRecognizers = %@", bottomBgView.gestureRecognizers);
    
    //_cameraModeScrollView.layer.borderColor = [UIColor redColor].CGColor;
    //_cameraModeScrollView.layer.borderWidth = 2;
    [self.view addSubview:_cameraModeScrollView];
    
    
    _videoModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_cameraModeScrollView.bounds.size.width/3.0, _cameraModeScrollView.bounds.size.height-30, _cameraModeScrollView.bounds.size.width/3.0, 30)];
    _videoModeLabel.userInteractionEnabled = YES;
    _videoModeLabel.backgroundColor = [UIColor clearColor];
    _videoModeLabel.text = @"视频";
    _videoModeLabel.textColor = [UIColor whiteColor];
    _videoModeLabel.font = [UIFont systemFontOfSize:15];
    _videoModeLabel.textAlignment = NSTextAlignmentCenter;
    
    UITapGestureRecognizer *videoModeLabelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoModeLabelTap:)];
    [_videoModeLabel addGestureRecognizer:videoModeLabelTapGestureRecognizer];

    [_cameraModeScrollView addSubview:_videoModeLabel];
    
    
    _photoModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_cameraModeScrollView.bounds.size.width * 2.0/3.0, _cameraModeScrollView.bounds.size.height-30, _cameraModeScrollView.bounds.size.width/3.0, 30)];
    _photoModeLabel.userInteractionEnabled = YES;
    _photoModeLabel.backgroundColor = [UIColor clearColor];
    _photoModeLabel.text = @"照片";
    _photoModeLabel.textColor = [UIColor yellowColor];//默认照片模式
    _photoModeLabel.font = [UIFont systemFontOfSize:15];
    _photoModeLabel.textAlignment = NSTextAlignmentCenter;
    
    if (self.recorderStyle == RecorderViewOnlyPhotoStyle)
    {
        bottomBgView.frame = CGRectMake(bottomBgView.frame.origin.x, bottomBgView.frame.origin.y + 50, bottomBgView.frame.size.width, bottomBgView.frame.size.height - 50);
        [_yellowDotView removeFromSuperview];
        [_cameraModeScrollView removeFromSuperview];
    }
    
    UITapGestureRecognizer *photoModeLabelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoModeLabelTap:)];
    [_photoModeLabel addGestureRecognizer:photoModeLabelTapGestureRecognizer];

    
    [_cameraModeScrollView addSubview:_photoModeLabel];
    _currentModel = CameraModePhotoMode;//默认照片模式
    _cameraModeScrollView.contentOffset = CGPointMake(_cameraModeScrollView.bounds.size.width/3.0, 0);//默认照片模式
    
    
    
    float buttomGap = 80;
    // 拍摄照片的按钮
    _pickPhotoButton = [UIButton new];
    [_pickPhotoButton setImage:[UIImage imageNamed:@"Unico/camera_pick_photo"] forState:UIControlStateNormal];
    _pickPhotoButton.bounds = CGRectMake(0, 0, btnRecordSize, btnRecordSize);
    _pickPhotoButton.center = CGPointMake(size.width/2, size.height-buttomGap+40);
    [_pickPhotoButton addTarget:self action:@selector(capturePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pickPhotoButton];
    
    //开始拍摄视频按钮
    _videoRecordBtn = [UIButton new];
    [_videoRecordBtn setImage:[UIImage imageNamed:@"Unico/camera_pick_video"] forState:UIControlStateNormal];
    _videoRecordBtn.bounds = CGRectMake(0, 0, btnRecordSize, btnRecordSize);
    _videoRecordBtn.center = CGPointMake(size.width/2, size.height-buttomGap+40);
    //[_videoRecordBtn addTarget:self action:@selector(videoRecordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_videoRecordBtn addGestureRecognizer:[[SCTouchDetector alloc] initWithTarget:self action:@selector(handleTouchDetected:)]];
    [self.view addSubview:_videoRecordBtn];
    _videoRecordBtn.hidden = YES;//默认照片模式
    
    
    _stopVideoRecordBtn = [UIButton new];
    [_stopVideoRecordBtn setImage:[UIImage imageNamed:@"Unico/camera_video_finish"] forState:UIControlStateNormal];
    _stopVideoRecordBtn.bounds = CGRectMake(0, 0, btnRecordSize, btnRecordSize);
    _stopVideoRecordBtn.center = CGPointMake(rightCenter, size.height-buttomGap+40);
    [_stopVideoRecordBtn addTarget:self action:@selector(stopVideoRecordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //[videoRecordBtn addGestureRecognizer:[[SCTouchDetector alloc] initWithTarget:self action:@selector(handleTouchDetected:)]];
    [self.view addSubview:_stopVideoRecordBtn];
    //_stopVideoRecordBtn.hidden = YES;
    
    // Video Finish Btn 视频拍摄完毕
    /* UIButton *videoFinishBtn = [UIButton new];
     [videoFinishBtn setImage:[UIImage imageNamed:@"Unico/camera_video_finish"] forState:UIControlStateNormal];
     videoFinishBtn.bounds = CGRectMake(0, 0, btnSize, btnSize);
     videoFinishBtn.center = CGPointMake(rightCenter, size.height-buttomGap);
     [videoFinishBtn addTarget:self action:@selector(handleStopButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:videoFinishBtn];*/
    
    
    // Video Back Photo 视频模式回到拍摄模式
    /*  UIButton *videoBackPhotoBtn = [UIButton new];
     [videoBackPhotoBtn setImage:[UIImage imageNamed:@"Unico/camera_switch_photo"] forState:UIControlStateNormal];
     videoBackPhotoBtn.bounds = CGRectMake(0, 0, btnSize, btnSize);
     videoBackPhotoBtn.center = CGPointMake(leftCenter, size.height-buttomGap);
     [videoBackPhotoBtn addTarget:self action:@selector(switchCameraMode:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:videoBackPhotoBtn];*/
    
    // 切换到视频模式
    /* UIButton *switchBtn = [UIButton new];
     [switchBtn setImage:[UIImage imageNamed:@"Unico/camera_switch_video"] forState:UIControlStateNormal];
     switchBtn.bounds = CGRectMake(0, 0, btnSize, btnSize);
     switchBtn.center = CGPointMake(rightCenter, size.height-buttomGap);
     [switchBtn addTarget:self action:@selector(switchCameraMode:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:switchBtn];*/
    
    
    //照片制作MV按钮 选择3 到6张照片
    _multipleSelectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_multipleSelectionBtn addTarget:self action:@selector(multipleSelectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _multipleSelectionBtn.bounds = CGRectMake(0, 0, btnSize, btnSize);
    _multipleSelectionBtn.center = CGPointMake(leftCenter, size.height-buttomGap+40);
    
    [_multipleSelectionBtn setImage:[UIImage imageNamed:@"Unico/mv"] forState:UIControlStateNormal];
    
   // [self.view addSubview:_multipleSelectionBtn];
    
    //视频分段删除按钮
    _deleteSegmentVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteSegmentVideoButton setImage:[UIImage imageNamed:@"Unico/camera_video_delete"] forState:UIControlStateNormal];
    
    _deleteSegmentVideoButton.bounds = CGRectMake(0, 0, btnRecordSize, btnRecordSize);
    _deleteSegmentVideoButton.center = CGPointMake(leftCenter, size.height-buttomGap+40);
    _deleteSegmentVideoButton.hidden = YES;
    [_deleteSegmentVideoButton addTarget:self action:@selector(deleteSegmentVideoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deleteSegmentVideoButton];
    
    
    // 选择视频或照片视图
    _recentImageView = [UIImageView new];
    [_recentImageView setContentMode:UIViewContentModeScaleAspectFill];
    _recentImageView.frame = CGRectMake(0, 0, btnSize, btnSize);
    _recentImageView.center = CGPointMake(btnSize/2, btnSize/2);
    _recentImageView.layer.cornerRadius = 5;
    _recentImageView.layer.masksToBounds = YES;
    _recentImageView.image = [UIImage imageNamed:@"Unico/nophoto"];//默认图片
    [[SUtilityTool shared] getRecentImage:_recentImageView assetsFilter:[ALAssetsFilter allPhotos]];//默认图片
    
    _selectImagebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectImagebutton addTarget:self action:@selector(selectAssets:) forControlEvents:UIControlEventTouchUpInside];
    [_selectImagebutton addSubview:_recentImageView];
    
    _selectImagebutton.bounds = CGRectMake(0, 0, btnSize, btnSize);
    _selectImagebutton.center = CGPointMake(rightCenter, size.height-buttomGap+40);
    
    [self.view addSubview:_selectImagebutton];
    
    // ------------------------------------------------------------------------------------
    //  Top 顶部的按钮
    // ------------------------------------------------------------------------------------
    
    float topGap = 42-17;
    // Back
    UIButton *backBtn = [UIButton new];
    [backBtn setImage:[UIImage imageNamed:@"Unico/camera_video_clear"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(7, 28-17, 30, 30);
    [backBtn addTarget:self action:@selector(handleRetakeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    // Flash
    _flashBtn = [UIButton new];
    [_flashBtn setImage:[UIImage imageNamed:@"Unico/camera_flash_on"] forState:UIControlStateNormal];
    _flashBtn.bounds = CGRectMake(0, 0, btnSize, btnSize);
    _flashBtn.center = CGPointMake(rightCenter - btnSize, topGap);
    [_flashBtn addTarget:self action:@selector(switchFlash:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_flashBtn];
    
    // Switch Camera
    _switchCameraBtn = [UIButton new];
    [_switchCameraBtn setImage:[UIImage imageNamed:@"Unico/camera_change_front"] forState:UIControlStateNormal];
    _switchCameraBtn.bounds = CGRectMake(0, 0, btnSize, btnSize);
    _switchCameraBtn.center = CGPointMake(rightCenter+10, topGap);
    [_switchCameraBtn addTarget:self action:@selector(handleReverseCameraTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_switchCameraBtn];
    
    
    _videoTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 8, [UIScreen mainScreen].bounds.size.width-120, 30)];
    _videoTimeLabel.textAlignment = NSTextAlignmentCenter;
    _videoTimeLabel.textColor = [UIColor whiteColor];
    _videoTimeLabel.font = [UIFont boldSystemFontOfSize:22];
    _videoTimeLabel.text = @"00";
    _videoTimeLabel.hidden = YES;
    _videoTimeLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    _videoTimeLabel.layer.shadowOffset = CGSizeMake(1, 1);
    _videoTimeLabel.layer.shadowOpacity = 1;
    _videoTimeLabel.layer.shadowRadius = 0;
    //[self.view addSubview:_videoTimeLabel];
    
    // ------------------------------------------------------------------------------------
    // 成员变量引用。
    // ------------------------------------------------------------------------------------
    
    gallaryButton = _selectImagebutton;
    
    self.retakeButton = backBtn;
    //self.stopButton = _stopVideoRecordBtn;
    self.reverseCamera = _switchCameraBtn;
    
    //self.recordView = videoRecordBtn;
    self.flashModeButton = _flashBtn;
    
    // self.videoBackPhotoBtn = videoBackPhotoBtn;
    // self.photoToVideoBtn = switchBtn;
}


/*- (void)videoRecordBtnClick:(id)sender//开始拍摄视频
{
    _ghostImageView.hidden = YES;
    [_recorder record];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _cameraModeScrollView.hidden = YES;
        _yellowDotView.hidden = YES;
        _videoRecordBtn.hidden = YES;
        
        _flashBtn.hidden = YES;
        _switchCameraBtn.hidden = YES;
        _multipleSelectionBtn.hidden = YES;
        _selectImagebutton.hidden = YES;
        
        
        
        
    } completion:^(BOOL finished) {
        
    }];
}*/

- (void)stopVideoRecordBtnClick:(id)sender//拍摄视频结束
{
    if (_recordProgress.progress < 0.1 )
    {
        return;
    }
    
    [_recorder pause:^{
        
        [self saveVideo];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    if (scrollView.tag == 1)
    {
        if (fabs(scrollView.contentOffset.x - 0) < 0.1)
        {
            if (_currentModel != CameraModeVideoMode)
            {
                _currentModel = CameraModeVideoMode;
                [self switchCameraMode];
            }
        }
        else if (fabs(scrollView.contentOffset.x - _cameraModeScrollView.bounds.size.width/3.0) < 0.1)
        {
            if (_currentModel != CameraModePhotoMode)
            {
                _currentModel = CameraModePhotoMode;
                [self switchCameraMode];
            }
        }
    }
}

- (void)multipleSelectionBtn:(id)sender
{
    UIImage *outsideFocusTargetImage = self.focusView.outsideFocusTargetImage;
    UIImage *insideFocusTargetImage = self.focusView.insideFocusTargetImage;
    self.focusView.outsideFocusTargetImage = nil;
    self.focusView.insideFocusTargetImage = nil;
    
    
    UzysAssetsPickerController *picker = [UzysAssetsPickerController new];
    picker.delegate = self;
    
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    
    picker.miniimumNumberOfSelectionMedia = 3;
    picker.maximumNumberOfSelectionMedia = 6;
    
    picker.showCameraCell = NO;
    
    [self presentViewController:picker animated:YES completion:^{
        
        self.focusView.outsideFocusTargetImage = outsideFocusTargetImage;
        self.focusView.insideFocusTargetImage = insideFocusTargetImage;
    }];
}

#pragma mark - uzysAssetsPicker
- (void)selectAssets:(UIButton*)sender{
    
    if ([self.delegate respondsToSelector:@selector(recorderViewControllerDidPickingSystemPhoto:)])
    {
        [self.delegate recorderViewControllerDidPickingSystemPhoto:self];
    }
    
    
  /*  // 显示一个过度，避免卡顿感。TODO:用一个比较好的界面
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    UIImage *outsideFocusTargetImage = self.focusView.outsideFocusTargetImage;
    UIImage *insideFocusTargetImage = self.focusView.insideFocusTargetImage;
    self.focusView.outsideFocusTargetImage = nil;//这里是避免和动画画面重叠
    self.focusView.insideFocusTargetImage = nil;
    
    //UzysAppearanceConfig *appearanceConfig = [UzysAppearanceConfig new];
    //appearanceConfig.finishSelectionButtonColor = [UIColor blackColor];
    //[UzysAssetsPickerController setUpAppearanceConfig:appearanceConfig];
    
    UzysAssetsPickerController *picker = [UzysAssetsPickerController new];
    picker.delegate = self;
    // AND
    picker.maximumNumberOfSelectionMedia = 1;
    picker.showCameraCell = YES;
    // OR
    
    if (_currentModel == CameraModePhotoMode)
    {
        picker.assetsFilter = [ALAssetsFilter allPhotos];
    }
    else if (_currentModel == CameraModeVideoMode)
    {
        picker.assetsFilter = [ALAssetsFilter allVideos];
    }
    
    [self presentViewController:picker animated:YES completion:^{
        
        //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        self.focusView.outsideFocusTargetImage = outsideFocusTargetImage;
        self.focusView.insideFocusTargetImage = insideFocusTargetImage;
    }];*/
}

- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    __weak typeof(self) weakSelf = self;
    
    if ([assets count] == 0)
    {
        return;
    }
    else if ([assets count] == 1) //单选模式
    {
        ALAsset *asset = assets[0];
        
        NSString *assetTypeString = [asset valueForProperty:ALAssetPropertyType];
        
        if([assetTypeString isEqualToString:ALAssetTypePhoto]) //Photo
        {
            ALAssetRepresentation *defaultRepresentation = asset.defaultRepresentation;
            UIImage *img = nil;
            
            if (defaultRepresentation.fullScreenImage != NULL)//优先使用全屏图像
            {
                img = [UIImage imageWithCGImage:defaultRepresentation.fullScreenImage];
            }
            else if (defaultRepresentation.fullResolutionImage != NULL)
            {
                img = [UIImage imageWithCGImage:defaultRepresentation.fullResolutionImage
                                          scale:defaultRepresentation.scale
                                    orientation:(UIImageOrientation)defaultRepresentation.orientation];
            }
            else if ([asset aspectRatioThumbnail] != NULL)
            {
                img = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
            }
            [weakSelf showPhoto:img animated:NO];
        }
        else if ([assetTypeString isEqualToString:ALAssetTypeVideo])
        {
            ALAssetRepresentation *defaultRepresentation = asset.defaultRepresentation;
            
            NSURL *url = defaultRepresentation.url;
            
            //NSLog(@"representation.url = %@", defaultRepresentation.url);
            
            [picker dismissViewControllerAnimated:YES completion:nil];
            
            SCRecordSessionSegment *segment = [SCRecordSessionSegment segmentWithURL:url info:nil];
            
            [_recorder.session addSegment:segment];
            
            //NSLog(@"[_recorder.session addSegment:segment]");
            
            //_recordSession = [SCRecordSession recordSession];
            //[_recordSession addSegment:segment];
            
            self.rotate = NO;//不考虑旋转
            
            [self showVideoWithAnimated:NO];
        }
    }
    else  //多选模式  用于制作照片电影
    {
        //MakingPhotoVideoViewController *makingPhotoVideoViewController = [[MakingPhotoVideoViewController alloc] init];
        
        //makingPhotoVideoViewController.assetsArray = assets;
        
        
        //[self.navigationController pushViewController:makingPhotoVideoViewController animated:NO];
        
        
        PhotoVideoSceneSelecteViewController *photoVideoSceneSelecteViewController = [[PhotoVideoSceneSelecteViewController alloc] init];
        
        photoVideoSceneSelecteViewController.assetsArray = assets;
        
        [self.navigationController pushViewController:photoVideoSceneSelecteViewController animated:NO];
    }
}

- (void)recorder:(SCRecorder *)recorder didSkipVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    NSLog(@"Skipped video buffer");
}

- (void)recorder:(SCRecorder *)recorder didReconfigureAudioInput:(NSError *)audioInputError {
    NSLog(@"Reconfigured audio input: %@", audioInputError);
}

- (void)recorder:(SCRecorder *)recorder didReconfigureVideoInput:(NSError *)videoInputError {
    NSLog(@"Reconfigured video input: %@", videoInputError);
}

- (void)removeAllSegments
{
    [_recorder.session removeAllSegments];
    
    for (UIView *progressDividingLine in _recordProgressDividingLineMutableArray)
    {
        [progressDividingLine removeFromSuperview];
    }
    
    [_recordProgressDividingLineMutableArray removeAllObjects];
    
    _deleteSegmentVideoButton.hidden = YES;
    
    _multipleSelectionBtn.hidden= NO;
    _cameraModeScrollView.hidden = NO;
    _yellowDotView.hidden = NO;
    _selectImagebutton.hidden = NO;
    
    [self updateTimeRecordedLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //清空目录
    NSString *tmpPath = [NSString stringWithFormat:@"%@/tmp", NSHomeDirectory()];
    
    BOOL ret = NO;
    NSError *error = nil;
    
    NSArray *subpathsArray = nil;
    
    subpathsArray = [[NSFileManager defaultManager] subpathsAtPath:tmpPath];
    for (NSString *subfile in subpathsArray)
    {
        NSString *subpath = [NSString stringWithFormat:@"%@/%@", tmpPath, subfile];
        
        error = nil;
        ret = [[NSFileManager defaultManager] removeItemAtPath:subpath error:&error];
        if (!ret || error != nil)
        {
            
        }
    }

    
    
    [self switchCameraMode];
    
    
    [self removeAllSegments];
    
    // if ([self photoMode]) {
    // self.stopButton.alpha = 0;
    // }
    
    
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
        [self.view removeGestureRecognizer:screenEdgePanGestureRecognizer];//此处禁止在相机界面里面屏幕边界右滑时返回上一级界面的手势
    }
    
    _backupStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    _backupNavigationBarHidden = self.navigationController.navigationBarHidden;
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [_recorder previewViewFrameChanged];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _focusView.recorder = _recorder;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (![_recorder videoEnabledAndReady])
        {
            UILabel *helpInfoLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2.0-100, [UIScreen mainScreen].bounds.size.width, 20)];
            helpInfoLabel1.backgroundColor = [UIColor clearColor];
            helpInfoLabel1.textAlignment = NSTextAlignmentCenter;
            helpInfoLabel1.textColor = [UIColor whiteColor];
            helpInfoLabel1.font = [UIFont boldSystemFontOfSize:19];
            
            NSURL *url=[NSURL URLWithString:@"prefs:root=Privacy"];
            BOOL ret = [[UIApplication sharedApplication] canOpenURL:url];
            
            if (ret)
            {
                helpInfoLabel1.text = @"使用有范拍照";
            }
            else
            {
                helpInfoLabel1.text = @"无法启用相机";
            }
            
            [_recorder.previewView addSubview:helpInfoLabel1];
            
            UILabel *helpInfoLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, helpInfoLabel1.frame.origin.y + helpInfoLabel1.frame.size.height + 5, [UIScreen mainScreen].bounds.size.width, 20)];
            helpInfoLabel2.backgroundColor = [UIColor clearColor];
            helpInfoLabel2.textAlignment = NSTextAlignmentCenter;
            helpInfoLabel2.textColor = [UIColor whiteColor];
            
            if ([UIScreen mainScreen].bounds.size.width > 320)
            {
                helpInfoLabel2.font = [UIFont systemFontOfSize:19];
            }
            else
            {
                helpInfoLabel2.font = [UIFont systemFontOfSize:16];
            }
            
            if (ret)
            {
                helpInfoLabel2.text = @"点击\"设置\"，允许 有范 使用您的相机拍摄";
            }
            else
            {
                helpInfoLabel2.text = @"您可以在隐私设置中设置相应权限";
            }
            
            
            [_recorder.previewView addSubview:helpInfoLabel2];
            
            
            if (ret)
            {
                UIButton  *openSettingPrivacyCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
                
                openSettingPrivacyCameraButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-170)/2.0, helpInfoLabel2.frame.origin.y + helpInfoLabel2.frame.size.height + 10, 170, 40);
                
                
                [openSettingPrivacyCameraButton setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:220.0/255.0 blue:20.0/255.0 alpha:1.0]];
                
                [openSettingPrivacyCameraButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                openSettingPrivacyCameraButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
                
                openSettingPrivacyCameraButton.layer.cornerRadius = 5;
                openSettingPrivacyCameraButton.layer.masksToBounds = YES;
                
                [openSettingPrivacyCameraButton setTitle:@"准许使用摄像机" forState:UIControlStateNormal];
                
                [openSettingPrivacyCameraButton addTarget:self action:@selector(openSettingPrivacyCameraButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [_recorder.previewView addSubview:openSettingPrivacyCameraButton];
            }
        }
        else
        {
            [_recorder startRunning];//该处需要长时间操作，为了不在此阻止UI线程，在此稍微延后执行，以到达打开相机的速度 —— 陈诚。
        }
    });
}

- (void)openSettingPrivacyCameraButtonClick:(id)sender
{
    NSURL *url=[NSURL URLWithString:@"prefs:root=Privacy"];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
    [UIApplication sharedApplication].statusBarHidden = _backupStatusBarHidden;
    self.navigationController.navigationBarHidden = _backupNavigationBarHidden;
    
    // test just stop running
    // 确实退出相机速度明显加快。
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_recorder stopRunning];
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc{
    // remove observer
    _focusView.recorder = nil;
}

#pragma mark - Handle

- (void)showAlertViewWithTitle:(NSString*)title message:(NSString*) message {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}


- (void)showVideoWithAnimated:(BOOL)animated
{
    //CoverVideoCropViewController *vc = [[CoverVideoCropViewController alloc] initWithVideo:_recordSession];
    CoverVideoCropViewController *vc = [[CoverVideoCropViewController alloc] initWithVideo:_recorder.session];
    
    
    vc.rotate = self.rotate;
    
    NSLog(@"vc.rotate = %d", vc.rotate);
    
    [self pushController:vc animated:animated];
    
    // stopRunning for test
    // test just stop running
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) ,^{
    //        [_recorder stopRunning];
    //    });
    
    //    UINavigationController *nav = self.navigationController;
    //    [nav popViewControllerAnimated:NO];
    //    [nav pushViewController:vc animated:NO];
}

- (void)showPhoto:(UIImage *)photo animated:(BOOL)animated
{
    //    CoverEditViewController *vc = [[CoverEditViewController alloc] initWithImage:photo];
    //    [self pushController:vc animated:YES];
    
    if (photo.size.width > 750)
    {
        CGSize newSize = CGSizeMake(750, 750.0f/photo.size.width*photo.size.height);
        photo = [photo resize:newSize];
    }
    
    
    SImageCropController *vc = [SImageCropController new];
    vc.image = photo;
    [self pushController:vc animated:animated];
}

// 切换前后
- (void) handleReverseCameraTapped:(id)sender
{
    //[UIView transitionWithView:_recorder.previewView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
    //} completion:^(BOOL finished) {
        
    //}];
    
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_recorder switchCaptureDevices];
    //});
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSURL *url = info[UIImagePickerControllerMediaURL];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    SCRecordSessionSegment *segment = [SCRecordSessionSegment segmentWithURL:url info:nil];
    
    [_recorder.session addSegment:segment];
    //_recordSession = [SCRecordSession recordSession];
    //[_recordSession addSegment:segment];
    
    self.rotate = NO;//不考虑旋转
    [self showVideoWithAnimated:YES];
}
- (void) handleStopButtonTapped:(id)sender {
    if (_recordProgress.progress < 0.1 ) {
        return;
    }
    [_recorder pause:^{
        
        [self saveVideo];
    }];
}

- (void)saveVideo
{
    /*UIView *dialogView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
    dialogView.backgroundColor = [UIColor blackColor];
    dialogView.layer.cornerRadius = 8;
    dialogView.layer.masksToBounds = YES;
    dialogView.alpha = 0.9;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dialogView.frame.size.width, dialogView.frame.size.height/2.0)];
    titleLabel.text = @"正在压缩视频";
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
    
    
    NSString *temVideoFilePath = [NSString stringWithFormat:@"%@/tmp/video.mp4", NSHomeDirectory()];
    
    [[NSFileManager defaultManager] removeItemAtPath:temVideoFilePath error:nil];
    NSURL *temVideoFileURL = [[NSURL alloc] initFileURLWithPath:temVideoFilePath];
    
    
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:_recorder.session.assetRepresentingSegments];
    exportSession.videoConfiguration.preset = SCPresetMediumQuality;
    exportSession.audioConfiguration.preset = SCPresetLowQuality;
    exportSession.videoConfiguration.maxFrameRate = 24;
    exportSession.outputUrl = temVideoFileURL;
    exportSession.outputFileType = AVFileTypeMPEG4;

    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        if ([self.delegate respondsToSelector:@selector(recorderViewController:didFinishCaptureVideo:)])
        {
            [self.delegate recorderViewController:self didFinishCaptureVideo:temVideoFileURL];
        }
    }];*/
    
    if ([self.delegate respondsToSelector:@selector(recorderViewController:didFinishCaptureVideo:)])
    {
        [self.delegate recorderViewController:self didFinishCaptureVideo:_recorder.session.assetRepresentingSegments];
    }
}

- (void)saveAndShowSession:(SCRecordSession *)recordSession
{
    //[[SCRecordSessionManager sharedInstance] saveRecordSession:recordSession];
    
    //_recordSession = recordSession;
    //[self showVideoWithAnimated:YES];
}

- (void)closeCamera{
    
    // show camera start slide
    UIImageView *upView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_up"]];
    UIImageView *downView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_down"]];
    
    if (g_cameraStartSlideWindow == nil)
    {
        g_cameraStartSlideWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    g_cameraStartSlideWindow.windowLevel = UIWindowLevelAlert;
    g_cameraStartSlideWindow.backgroundColor = [UIColor clearColor];
    [g_cameraStartSlideWindow makeKeyAndVisible];
    
    [g_cameraStartSlideWindow addSubview:upView];
    [g_cameraStartSlideWindow addSubview:downView];
    
    upView.frame = downView.frame = self.view.frame;
    
    [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
    [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
    
    
    
    // 关闭动画
    [UIView animateWithDuration:0.3 animations:^{
        [upView setOrigin:CGPointMake(0, 0)];
        [downView setOrigin:CGPointMake(0, 0)];
    } completion:^(BOOL finished) {
        
        //        [self popAnimated:NO];
        self.navigationController.navigationBarHidden = NO;
        [SUTIL showHome];
        // Open
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
            [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
            [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
        } completion:^(BOOL finished) {
            [upView removeFromSuperview];
            [downView removeFromSuperview];
            g_cameraStartSlideWindow = nil;
        }];
        
    }];
}

- (void)handleRetakeButtonTapped:(UIButton*)sender
{
   /* if (self.recordProgress.progress<=0.01 || _currentModel == CameraModePhotoMode)
    {
        sender.enabled = NO;
        [self closeCamera];
        return;
    }
    
    SCRecordSession *recordSession = _recorder.session;
    
    if (recordSession != nil) {
        _recorder.session = nil;
        
        // If the recordSession was saved, we don't want to completely destroy it
        if ([[SCRecordSessionManager sharedInstance] isSaved:recordSession]) {
            [recordSession endSegmentWithInfo:nil completionHandler:nil];
        } else {
            [recordSession cancelSession:nil];
        }
    }
    
    [self prepareSession];*/
    
    //[self closeCamera];
    
    
    
    if ([self.delegate respondsToSelector:@selector(recorderViewControllerDidCancel:)])
    {
        [self.delegate recorderViewControllerDidCancel:self];
    }
}

- (void)switchCameraMode
{
    [self switchCameraModeWithAnimated:NO];
}

- (void)switchCameraModeWithAnimated:(BOOL)animated
{
    if (self.recorderStyle == RecorderViewOnlyPhotoStyle)
    {
        return;
    }

    if (_currentModel == CameraModeVideoMode)
    {
        [[SUtilityTool shared] getRecentImage:_recentImageView assetsFilter:[ALAssetsFilter allVideos]];
        
        _videoModeLabel.textColor = [UIColor yellowColor];
        _photoModeLabel.textColor = [UIColor whiteColor];

        if (_cameraModeScrollView.contentOffset.x != 0)
        {
            id  backupDelegate = _cameraModeScrollView.delegate;
            
            _cameraModeScrollView.delegate = nil;
            
            if (animated)
            {
                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    
                    _cameraModeScrollView.contentOffset = CGPointMake(0, 0);

                } completion:^(BOOL finished) {
                    
                    _cameraModeScrollView.delegate = backupDelegate;
                    
                }];
            }
            else
            {
                _cameraModeScrollView.contentOffset = CGPointMake(0, 0);
                _cameraModeScrollView.delegate = backupDelegate;
            }
        }
        
        
        // 切换到视频模式
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //self.capturePhotoButton.alpha = 0.0;
            self.recordView.alpha = 1.0;
            //self.retakeButton.alpha = 1.0;
            //self.stopButton.alpha = 0.0; // 默认0，必须1秒以上才可以
            self.recordProgress.alpha = 1.0;
            //self.ghostModeButton.alpha = 0;
            //self.photoToVideoBtn.alpha = 0;
            //self.videoBackPhotoBtn.alpha = 1;
            //gallaryButton.alpha = 0;
            
            _pickPhotoButton.hidden = YES;
            _videoRecordBtn.hidden = NO;
            _videoTimeLabel.hidden = NO;
            
        } completion:^(BOOL finished) {
            _recorder.captureSessionPreset = kVideoPreset;
            [self.flashModeButton setImage:[UIImage imageNamed:@"s_flash_off"] forState:UIControlStateNormal];
            _recorder.flashMode = SCFlashModeOff;
        }];
    }
    else if (_currentModel == CameraModePhotoMode)
    {
        [[SUtilityTool shared] getRecentImage:_recentImageView assetsFilter:[ALAssetsFilter allPhotos]];
        
        _videoModeLabel.textColor = [UIColor whiteColor];
        _photoModeLabel.textColor = [UIColor yellowColor];

        if (_cameraModeScrollView.contentOffset.x != _cameraModeScrollView.bounds.size.width/3.0)
        {
            id  backupDelegate = _cameraModeScrollView.delegate;
            
            _cameraModeScrollView.delegate = nil;
            
            
            if (animated)
            {
                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    
                    _cameraModeScrollView.contentOffset = CGPointMake(_cameraModeScrollView.bounds.size.width/3.0, 0);
                    
                } completion:^(BOOL finished) {
                    
                    _cameraModeScrollView.delegate = backupDelegate;
                    
                }];
            }
            else
            {
                _cameraModeScrollView.contentOffset = CGPointMake(_cameraModeScrollView.bounds.size.width/3.0, 0);
                
                _cameraModeScrollView.delegate = backupDelegate;
            }

            
            
        }
        
        
        // 切换到相机模式
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.recordView.alpha = 0.0;
            //self.retakeButton.alpha = 1.0; // 显示一下，因为是用这个返回的目前
            //self.stopButton.alpha = 0.0; // 视频完成
            self.recordProgress.alpha = 0;
            //self.capturePhotoButton.alpha = 1.0;
            //self.ghostModeButton.alpha = 0;
            //self.photoToVideoBtn.alpha = 1;
            //self.videoBackPhotoBtn.alpha = 0;
            //gallaryButton.alpha = 1;
            
            _pickPhotoButton.hidden = NO;
            _videoRecordBtn.hidden = YES;
            _videoTimeLabel.hidden = YES;
            
        } completion:^(BOOL finished) {
            _recorder.captureSessionPreset = kVideoPreset;
            [self.flashModeButton setImage:[UIImage imageNamed:@"s_flash_auto"] forState:UIControlStateNormal];
            _recorder.flashMode = SCFlashModeAuto;
        }];
    }
}

- (IBAction)switchCameraMode:(id)sender
{
    if ([self photoMode])
    {
        // 切换到视频模式
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.capturePhotoButton.alpha = 0.0;
            self.recordView.alpha = 1.0;
            self.retakeButton.alpha = 1.0;
            self.stopButton.alpha = 0.0; // 默认0，必须1秒以上才可以
            self.recordProgress.alpha = 1.0;
            self.ghostModeButton.alpha = 0;
            self.photoToVideoBtn.alpha = 0;
            self.videoBackPhotoBtn.alpha = 1;
            gallaryButton.alpha = 0;
        } completion:^(BOOL finished) {
            _recorder.captureSessionPreset = kVideoPreset;
            [self.flashModeButton setImage:[UIImage imageNamed:@"s_flash_off"] forState:UIControlStateNormal];
            _recorder.flashMode = SCFlashModeOff;
        }];
    } else {
        // 切换到相机模式
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.recordView.alpha = 0.0;
            self.retakeButton.alpha = 1.0; // 显示一下，因为是用这个返回的目前
            self.stopButton.alpha = 0.0; // 视频完成
            self.recordProgress.alpha = 0;
            self.capturePhotoButton.alpha = 1.0;
            self.ghostModeButton.alpha = 0;
            self.photoToVideoBtn.alpha = 1;
            self.videoBackPhotoBtn.alpha = 0;
            gallaryButton.alpha = 1;
            
        } completion:^(BOOL finished) {
            _recorder.captureSessionPreset = kVideoPreset;
            [self.flashModeButton setImage:[UIImage imageNamed:@"s_flash_auto"] forState:UIControlStateNormal];
            _recorder.flashMode = SCFlashModeAuto;
        }];
    }
}

- (IBAction)switchFlash:(id)sender {
    NSString *flashModeString = nil;
    // 暂时暴力判断
    if ([self photoMode]) {
        switch (_recorder.flashMode) {
            case SCFlashModeAuto:
                flashModeString = @"s_flash_off";
                _recorder.flashMode = SCFlashModeOff;
                break;
            case SCFlashModeOff:
                flashModeString = @"s_flash_on";
                _recorder.flashMode = SCFlashModeOn;
                break;
            case SCFlashModeOn:
                flashModeString = @"s_flash_light";
                _recorder.flashMode = SCFlashModeLight;
                break;
            case SCFlashModeLight:
                flashModeString = @"s_flash_auto";
                _recorder.flashMode = SCFlashModeAuto;
                break;
            default:
                break;
        }
    } else {
        switch (_recorder.flashMode) {
            case SCFlashModeOff:
                flashModeString = @"s_flash_on";
                _recorder.flashMode = SCFlashModeLight;
                break;
            case SCFlashModeLight:
                flashModeString = @"s_flash_off";
                _recorder.flashMode = SCFlashModeOff;
                break;
            default:
                break;
        }
    }
    
    [self.flashModeButton setImage:[UIImage imageNamed:flashModeString] forState:UIControlStateNormal];
}

- (BOOL)photoMode{
    return self.recordProgress.alpha <= 0;
}

- (void)prepareSession {
    if (_recorder.session == nil) {
        SCRecordSession *session = [SCRecordSession recordSession];
        session.fileType = AVFileTypeQuickTimeMovie;
        _recorder.session = session;
    }
    
    [self updateTimeRecordedLabel];
    [self updateGhostImage];
}

- (void)recorder:(SCRecorder *)recorder didCompleteSession:(SCRecordSession *)recordSession
{
    NSLog(@"didCompleteSession");
    [self saveVideo];
}

- (void)recorder:(SCRecorder *)recorder didInitializeAudioInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    if (error == nil) {
        NSLog(@"Initialized audio in record session");
    } else {
        NSLog(@"Failed to initialize audio in record session: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didInitializeVideoInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    if (error == nil) {
        NSLog(@"Initialized video in record session");
    } else {
        NSLog(@"Failed to initialize video in record session: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didBeginSegmentInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    NSLog(@"Began record segment: %@", error);
}

- (void)recorder:(SCRecorder *)recorder didCompleteSegment:(SCRecordSessionSegment *)segment inSession:(SCRecordSession *)recordSession error:(NSError *)error {
    NSLog(@"Completed record segment at %@: %@ (frameRate: %f)", segment.url, error, segment.frameRate);
    
    [self updateGhostImage];
}

- (void) deleteSegmentVideoButtonClick:(id)sender
{
    [_recorder.session removeLastSegment];
    
    UIView *lastRecordProgressDividingLine = [_recordProgressDividingLineMutableArray lastObject];
    
    [lastRecordProgressDividingLine removeFromSuperview];
    
    [_recordProgressDividingLineMutableArray removeLastObject];
    
    if ([_recordProgressDividingLineMutableArray count] == 0)
    {
        _deleteSegmentVideoButton.hidden = YES;
        
        _multipleSelectionBtn.hidden= NO;
        _cameraModeScrollView.hidden = NO;
        _yellowDotView.hidden = NO;
        _selectImagebutton.hidden = NO;
    }
    
    [self updateTimeRecordedLabel];
}

- (void)updateTimeRecordedLabel {
    CMTime currentTime = kCMTimeZero;
    
    if (_recorder.session != nil) {
        currentTime = _recorder.session.duration;
    }
    
    self.timeRecordedLabel.text = @"";
    //    self.timeRecordedLabel.text = [NSString stringWithFormat:@"Recorded - %.2f sec", CMTimeGetSeconds(currentTime)];
    
    
    _videoTimeLabel.text = [NSString stringWithFormat:@"%02.0f", CMTimeGetSeconds(currentTime)];
    
    self.recordProgress.progress = CMTimeGetSeconds(currentTime)/10;
    
    NSLog(@"self.recordProgress.progress = %f", self.recordProgress.progress);
    
    if (self.recordProgress.progress<=0.1)
    {
        _stopVideoRecordBtn.hidden = YES;
    }
    else
    {
        _stopVideoRecordBtn.hidden = NO;
    }
}

- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession
{
    [self updateTimeRecordedLabel];
}

- (void)handleTouchDetected:(SCTouchDetector*)touchDetector
{
    if (touchDetector.state == UIGestureRecognizerStateBegan)
    {
        _ghostImageView.hidden = YES;
        [_recorder record];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _yellowDotView.hidden = YES;
            
            _multipleSelectionBtn.hidden = YES;
            _selectImagebutton.hidden = YES;
            _cameraModeScrollView.hidden = YES;
            
        } completion:^(BOOL finished) {
            
        }];

    }
    else if (touchDetector.state == UIGestureRecognizerStateEnded)
    {
        [_recorder pause];
        
        UIView  *recordProgressDividingLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 8)];
        recordProgressDividingLine.backgroundColor = [UIColor colorWithRed:36.0/255.0 green:36.0/255.0 blue:36.0/255.0 alpha:255.0];
        
        [_recordProgressDividingLineMutableArray addObject:recordProgressDividingLine];
        
        recordProgressDividingLine.center = CGPointMake(self.recordProgress.progress * self.recordProgress.width, recordProgressDividingLine.center.y);
        
        [self.recordProgress addSubview:recordProgressDividingLine];
        
        _deleteSegmentVideoButton.hidden = NO;
    }
}

- (IBAction)capturePhoto:(UIButton*)sender
{
    [_recorder capturePhoto:^(NSError *error, UIImage *image){
        if (image != nil)
        {
            UIImage *newImage = OpenCVTool::rotateImage(image);
            
            if ([self.delegate respondsToSelector:@selector(recorderViewController:didFinishCaptureImage:)])
            {
                [self.delegate recorderViewController:self didFinishCaptureImage:newImage];
            }
        }
        else
        {
            [self showAlertViewWithTitle:@"拍摄失败" message:error.localizedDescription];
        }
    }];
}

#pragma mark - 洋葱皮效果
- (void)updateGhostImage
{
    UIImage *image = nil;
    
    if (_ghostModeButton.selected)
    {
        if (_recorder.session.segments.count > 0)
        {
            SCRecordSessionSegment *segment = [_recorder.session.segments lastObject];
            image = segment.lastImage;
        }
    }
    
    _ghostImageView.image = image;
    _ghostImageView.hidden = !_ghostModeButton.selected;
}

// 暂时按钮去掉了。
- (IBAction)switchGhostMode:(id)sender {
    _ghostModeButton.selected = !_ghostModeButton.selected;
    _ghostImageView.hidden = !_ghostModeButton.selected;
    
    [self updateGhostImage];
}


- (void)didReceiveMemoryWarning
{
    
    NSLog(@"Recorder Recieve memory warning");
}

@end
