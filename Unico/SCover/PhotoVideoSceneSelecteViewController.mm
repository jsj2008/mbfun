//
//  PhotoVideoSceneSelecteViewController.m
//  Wefafa
//
//  Created by moooc on 15/7/9.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "PhotoVideoSceneSelecteViewController.h"

#import "SUtilityTool.h"


#import "OpenCVTool.h"

//#import "RainbowLightScenePreview.h"
#import "CompScenePreview.h"
#import "Dialog.h"


NSString *g_sceneClassNameArray[] = {@"CompScenePreview", @"RainbowLightScenePreview"};

NSString *g_sceneNameArray[] = {@"Comp", @"虹光", @"Poster", @"黑与白", @"那些年", @"毕业季"};


@interface SceneCellView : UIView
{
    UIImageView  *_imageView;
    
    UILabel      *_titleLabel;
    
    BOOL _animated;
}

@property(strong, readwrite, nonatomic)UIImage *image;
@property(strong, readwrite, nonatomic)NSString *title;

@property(assign, readwrite, nonatomic)BOOL animated;

@end


@implementation SceneCellView

- (void)setAnimated:(BOOL)animated
{
    _animated = animated;
    
    if (_animated)
    {
        [self startAnimate];
    }
}

- (void)startAnimate
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _imageView.layer.transform = CATransform3DRotate(_imageView.layer.transform, 10.0/180.0 * 3.1415926, 0, 0, 1);
        
    } completion:^(BOOL finished) {
        
        if (_animated)
        {
            [self startAnimate];
        }
    }];
    
}

- (void)setImage:(UIImage *)image
{
    _imageView.image = image;
}

- (UIImage *)image
{
    return _imageView.image;
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (NSString *)title
{
    return _titleLabel.text;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _imageView.layer.cornerRadius = self.bounds.size.width/2.0;
        _imageView.layer.masksToBounds = YES;
        
        
        [self addSubview:_imageView];
        
        
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        
        [self addSubview:_titleLabel];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)];
        
        _imageView.layer.cornerRadius = self.bounds.size.width/2.0;
        _imageView.layer.masksToBounds = YES;
        
        
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20)];
        
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_titleLabel];
        
        
    }
    return self;
}


@end


@interface PhotoVideoSceneSelecteViewController ()

@end

@implementation PhotoVideoSceneSelecteViewController

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self createNavigationBar];
    
    
    _previewPlayerView = [[UIView alloc] initWithFrame:CGRectMake(0, (([UIScreen mainScreen].bounds.size.height-90-64)-[UIScreen mainScreen].bounds.size.width)/2.0+64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    
    [self.view addSubview:_previewPlayerView];
    
    [self createSceneScrollView];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startPreviewScene];
    });
}

- (void)createNavigationBar
{
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44)];
    _titleLabel.font = FONT_T2;
    _titleLabel.text = @"照片电影";
    _titleLabel.textColor = COLOR_C3;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
    
    // 返回按钮
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(7, 28, 30, 30);
    [backButton setImage:[UIImage imageNamed:@"Unico/camera_navbar_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // 下一步按钮。
    UIButton* nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextStepButton.titleLabel.font = FONT_t2;
    nextStepButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 90, 10, 90, 50);
    [nextStepButton setTitleColor:COLOR_C3 forState:UIControlStateNormal];
    [nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStepButton addTarget:self action:@selector(nextStepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextStepButton];
}

- (void)nextStepButtonClick:(id)sender
{
    
  /*  UIView *progressDialog = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
    
    progressDialog.backgroundColor = [UIColor blackColor];
    
    progressDialog.layer.cornerRadius = 10;
    progressDialog.layer.masksToBounds = YES;
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, progressDialog.bounds.size.width, progressDialog.bounds.size.height/2.0)];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.text = @"正在生成视频";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [progressDialog addSubview:titleLabel];
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, progressDialog.bounds.size.height/2.0, progressDialog.bounds.size.width, progressDialog.bounds.size.height/2.0)];
    progressView.progressTintColor = [UIColor whiteColor];
    progressView.trackTintColor = [UIColor yellowColor];
    
    [progressDialog addSubview:progressView];
    
    
    showDialogView(progressDialog, YES, QFShowDialogViewAnimationFromTop, ^(BOOL finished) {
        
    });*/
    
    [_scenePreview createMP4FileWithUpdateProgress:^(float progress, NSString *mp4Filepath) {
        
        NSLog(@"progress = %f mp4FilePath = %@", progress, mp4Filepath);
        
        //progressView.progress = progress;
        
        if (progress == 1)
        {
            UISaveVideoAtPathToSavedPhotosAlbum(mp4Filepath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"视频保存结束 error = %@", error);
}

- (void)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createSceneScrollView
{
    _sceneScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 90, [UIScreen mainScreen].bounds.size.width, 90)];
    
    _sceneScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_sceneScrollView];
    
    _sceneSelectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    
    ALAsset *asset = nil;
    if (self.assetsArray!=nil && [self.assetsArray count]>0)
    {
        asset = [self.assetsArray objectAtIndex:0];
    }
    
    for (int i = 0; i<sizeof(g_sceneNameArray)/sizeof(NSString *); i++)
    {
        SceneCellView  *cellView = [[SceneCellView alloc] initWithFrame:CGRectMake(i * 95, (100.0-82.0)/2.0, 60, 60+20)];
        
        cellView.image = [UIImage imageNamed:@"scene.png"];
        
        if (asset != nil)
        {
            cellView.image = [UIImage imageWithCGImage:asset.thumbnail];
        }
        
        cellView.title = g_sceneNameArray[i];
        
        if (i == 0)
        {
            _sceneSelectedView.center = CGPointMake( cellView.center.x,  cellView.center.y-20/2.0);
            
            cellView.animated = YES;
        }
        
        [_sceneScrollView addSubview:cellView];
        
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTap:)];
        cellView.tag = i;
        [cellView addGestureRecognizer:tapGestureRecognizer];
    }
    
    _sceneSelectedView.layer.borderColor = [UIColor yellowColor].CGColor;
    _sceneSelectedView.layer.borderWidth = 1.5;
    _sceneSelectedView.layer.cornerRadius = _sceneSelectedView.width/2.0;
    _sceneSelectedView.layer.masksToBounds = YES;
    [_sceneScrollView addSubview:_sceneSelectedView];
    
    _sceneScrollView.contentSize = CGSizeMake(sizeof(g_sceneNameArray)/sizeof(NSString *) * 100, 90);
}

- (void)cellTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _sceneSelectedView.center = CGPointMake(tapGestureRecognizer.view.center.x,  tapGestureRecognizer.view.center.y-20/2.0);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)startPreviewScene
{
    _scenePreview = [[NSClassFromString(g_sceneClassNameArray[_currentSceneIndex]) alloc] initWithFrame:_previewPlayerView.bounds];
    
    _scenePreview.assetsArray = self.assetsArray;
    
    [_previewPlayerView addSubview:_scenePreview];
    
    [_scenePreview startPreview];
}


@end

