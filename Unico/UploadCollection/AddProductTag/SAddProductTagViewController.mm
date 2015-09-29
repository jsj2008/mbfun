//
//  SAddProductTagViewController.m
//  Wefafa
//
//  Created by chen cheng on 15/8/16.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SAddProductTagViewController.h"
#import "SUtilityTool.h"
#import "SUploadColllocationControlCenter.h"
#import "STagView.h"
#import "OpenCVTool.h"
#import "SAVPlayerView.h"
#import "OpenCVPlayerView.h"
#import "Dialog.h"
#import "SProductTagEditeInfo.h"

#define sizeK [UIScreen mainScreen].bounds.size.width/750.0

#import "SAddProductTagViewControlCenter.h"


@interface SAddProductTagViewController ()
{
    UINavigationBar *_navigationBar;
    UINavigationItem *_navigationItem;
    
    UIImageView *_imageView;
    UIImage *_image;
    
    SAVPlayerView *_playerView;
    NSURL *_videoURL;
    CGSize _videoSize;

    
    
    CGRect _maskImageViewRect;
    
    STagView *_defaultTagView;
    
    NSMutableArray *_tagMutableArray;//标签视图数组
    NSMutableArray *_productTagEditeInfoMutableArray;//标签信息数组
}

@end

@implementation SAddProductTagViewController


#pragma mark - 属性接口


- (void)setImage:(UIImage *)image
{
    _image = image;
    _videoURL = nil;
    
    
    if ([self isViewLoaded])
    {
//       之后再来写这里的逻辑
       /* [_imageView removeFromSuperview];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.image = _image;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.view addSubview:_imageView];
        [self fitCropSize];
        
        [_playerView pause];
        [_playerView removeFromSuperview];*/
    }

}

- (void)setVideoURL:(NSURL *)videoURL
{
    _videoURL = videoURL;
    _image = nil;
    
    AVAsset *avAsset = [AVAsset assetWithURL:videoURL];
    
    NSLog(@"获取size 1");
    
    NSArray * tracks = [avAsset tracks];
    for(AVAssetTrack* track in tracks)
    {
        if ([[track mediaType] isEqualToString:AVMediaTypeVideo])
        {
            _videoSize = CGSizeMake(track.naturalSize.width, track.naturalSize.height);
            break;
        }
    }
    
    NSLog(@"获取size _videoSize.width = %f, _videoSize.height = %f", _videoSize.width, _videoSize.height);
    
    if ([self isViewLoaded])
    {
        //       之后再来写这里的逻辑
       /* [_playerView pause];
        [_playerView removeFromSuperview];
        _playerView = [[SAVPlayerView alloc] initWithAsset:avAsset];
        
        [self.view addSubview:_playerView];
        [self fitCropSize];
        
        [_imageView removeFromSuperview];*/
    }
}



#pragma mark - 构造与析构

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _navigationItem = [[UINavigationItem alloc] init];
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
        _navigationItem.leftBarButtonItems = @[backButtonItem];
        
        
        UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonClick:)];
        _navigationItem.rightBarButtonItems = @[nextButtonItem];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH-200)/2.0, 0, 200, 44)];
        titleLabel.font = FONT_SIZE(18);
        titleLabel.textColor = COLOR_WHITE;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"添加单品标签";
        
        _navigationItem.titleView = titleLabel;
        
        
        _tagMutableArray = [[NSMutableArray alloc] init];
        
        _productTagEditeInfoMutableArray = [[NSMutableArray alloc] init];
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
    
    [_playerView play];
    
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_playerView pause];
    
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavbar];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _maskImageViewRect = CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44-sizeK*234);
    
    if (_image != nil)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.image = _image;
        
        [self.view addSubview:_imageView];
    }
    
    if (_videoURL != nil)
    {
        _playerView = [[SAVPlayerView alloc] initWithAsset:[AVAsset assetWithURL:_videoURL]];
        //获取视频截图
        _videoImage=[_playerView currentFrame];
        _playerView.tapForPlayOrPause = YES;
        [self.view addSubview:_playerView];
    }
    
    [self fitCropSize];
    
    
    //添加默认标签
    _defaultTagView = [[STagView alloc] init];
    _defaultTagView.tagType = CoverTagTypeItem;
    _defaultTagView.title = @"这是什么品牌？";
    
    NSLog(@"viewDidLoad _defaultTagView");
    
    __weak typeof(self) weakSelf = self;
    _defaultTagView.addTagBlock = ^(CGPoint point){ [weakSelf addTagWithPoint:point];};
    _defaultTagView.tagStyle = STagViewStyleAdd;
    
    if (_image != nil)
    {
        _defaultTagView.center = CGPointMake(_imageView.bounds.size.width/2.0, _imageView.bounds.size.height/2.0);
        [_imageView addSubview:_defaultTagView];
    }
    else if (_videoURL != nil)
    {
        _defaultTagView.center = CGPointMake(_playerView.bounds.size.width/2.0, _playerView.bounds.size.height/2.0);
        [_playerView addSubview:_defaultTagView];
    }
    
    
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tagPan:)];
    [_defaultTagView addGestureRecognizer:panGestureRecognizer];
    
    //添加提示label
    UILabel *hintLabel1= [[UILabel alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - sizeK*234/2.0 - 25, UI_SCREEN_WIDTH, 25)];
    hintLabel1.textAlignment = NSTextAlignmentCenter;
    hintLabel1.font = FONT_t3;
    hintLabel1.textColor = COLOR_C6;
    hintLabel1.text = @"点击\"+\"号添加标签";
    [self.view addSubview:hintLabel1];
    
    UILabel *hintLabel2= [[UILabel alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - sizeK*234/2.0, UI_SCREEN_WIDTH, 25)];
    hintLabel2.textAlignment = NSTextAlignmentCenter;
    hintLabel2.font = FONT_t3;
    hintLabel2.textColor = COLOR_C6;
    hintLabel2.text = @"最多可添加9个单品标签";
    [self.view addSubview:hintLabel2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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
    [_navigationBar pushNavigationItem:_navigationItem animated:NO];
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/blackBarBg.jpg"] forBarMetrics:UIBarMetricsDefault];
    [_navigationBar setBarTintColor:[UIColor blackColor]];
    [self.view addSubview:_navigationBar];
    
    _navigationBar.layer.transform = CATransform3DMakeTranslation(0, 0, 5);
}


- (void)fitCropSize
{
    if (_image != nil)
    {
        float k = _image.size.height/_image.size.width;
        
        if (k >= _maskImageViewRect.size.height/_maskImageViewRect.size.width)//图片比较高
        {
            float width = _maskImageViewRect.size.height/k;
            float height = _maskImageViewRect.size.height;
            _imageView.frame = CGRectMake((_maskImageViewRect.size.width-width)/2.0 + _maskImageViewRect.origin.x, _maskImageViewRect.origin.y, width, height);
        }
        else//图片比较宽
        {
            float width = _maskImageViewRect.size.width;
            float height = _maskImageViewRect.size.width*k;
            _imageView.frame = CGRectMake(_maskImageViewRect.origin.x, _maskImageViewRect.origin.y, width, height);
        }
    }
    
    if (_videoURL != nil)
    {
        float k = _videoSize.height/_videoSize.width;
        
        if (k >= _maskImageViewRect.size.height/_maskImageViewRect.size.width)//视频比较高
        {
            float width = _maskImageViewRect.size.height/k;
            float height = _maskImageViewRect.size.height;
            _playerView.frame = CGRectMake((_maskImageViewRect.size.width-width)/2.0 + _maskImageViewRect.origin.x, _maskImageViewRect.origin.y, width, height);
        }
        else//视频比较宽
        {
            float width = _maskImageViewRect.size.width;
            float height = _maskImageViewRect.size.width*k;
            _playerView.frame = CGRectMake(_maskImageViewRect.origin.x, _maskImageViewRect.origin.y, width, height);
        }
    }

}

#pragma mark - 控件事件接口

- (void)backButtonClick:(id)sender
{
    if (self.back != nil)
    {
        self.back();
    }
}

- (void)nextButtonClick:(id)sender
{
    if ([_productTagEditeInfoMutableArray count] == 0)
    {
        UIView *dialogView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360*sizeK, 200*sizeK)];
        dialogView.backgroundColor = [UIColor blackColor];
        dialogView.layer.cornerRadius = 8;
        dialogView.layer.masksToBounds = YES;
        dialogView.alpha = 1;
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/warning"]];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.frame = CGRectMake(158*sizeK, 40*sizeK, 44*sizeK, 44*sizeK);
        [dialogView addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 114*sizeK, dialogView.frame.size.width, 26*sizeK)];
        titleLabel.text = @"至少添加一个标签";
        titleLabel.font = FONT_t5;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        [dialogView addSubview:titleLabel];
        
        
        [CCDialog showDialogView:dialogView modal:YES showDialogViewAnimationOption:QFShowDialogViewAnimationFromCenter completion:^(BOOL finished) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [CCDialog closeDialogViewWithAnimationOptions:QFCloseDialogViewAnimationNone completion:^(BOOL finished) {
                    
                }];
            });
            
        }];
    }
    else
    {
        if (self.didFinishProductTag)
        {
            self.didFinishProductTag(_productTagEditeInfoMutableArray,_videoSize);//这里传单品标签数组
        }
    }
}

#pragma mark - 手势接口

- (void) addTagWithPoint:(CGPoint)point;
{
    if (_image != nil)
    {
        UIImage *productImage = nil;
        
        float k = _imageView.image.size.width/_imageView.frame.size.width;
        
        float width = 350;
        float height = 350;
        
        float x = point.x * k - width/2.0;
        float y = point.y * k - height/2.0;
        
        if (x < 0)
        {
            x = 0;
        }
        
        if (x > _imageView.image.size.width - width)
        {
            x = _imageView.image.size.width - width;
        }
        
        if (y < 0)
        {
            y = 0;
        }
        
        if (y > _imageView.image.size.height - height)
        {
            y = _imageView.image.size.height - height;
        }
        
        IplImage *srcIplImage = OpenCVTool::createBGRIplImageFromUIImage(_imageView.image);
        
        IplImage *destIplImage = cvCreateImage(cvSize(width, height), srcIplImage->depth, srcIplImage->nChannels);
        
        OpenCVTool::clip(srcIplImage, destIplImage, x, y, width, height);
        
        cvReleaseImage(&srcIplImage);
        
        productImage = OpenCVTool::createRGBUIImageFromIplImage(destIplImage);
        
        cvReleaseImage(&destIplImage);
        
        SProductTagEditeInfo *productTagEditeInfo = [[SProductTagEditeInfo alloc] init];
        productTagEditeInfo.tagIndex = -1;//表示是新增标签
        productTagEditeInfo.productOriginImage = _imageView.image;
        productTagEditeInfo.productImage = productImage;
        productTagEditeInfo.productOriginImageBei=_imageView.image;
        productTagEditeInfo.tagViewFlip = _defaultTagView.flip;
        
        productTagEditeInfo.tagViewToPoint = CGPointMake(point.x/_imageView.frame.size.width, point.y/_imageView.frame.size.height);//归一化

        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showEditeProductTagViewWith:productTagEditeInfo animated:YES];
    }
    else if (_videoURL != nil)
    {
        UIImage *productImage = nil;
        
        float k = _videoSize.width/_playerView.frame.size.width;
        
        
        
        float width = 350 * (_videoSize.width/750.0);
        float height = 350 * (_videoSize.width/750.0);
        
        float x = point.x * k - width/2.0;
        float y = point.y * k - height/2.0;
        
        if (x < 0)
        {
            x = 0;
        }
        
        if (x > _videoSize.width - width)
        {
            x = _videoSize.width - width;
        }
        
        if (y < 0)
        {
            y = 0;
        }
        
        if (y > _videoSize.height - height)
        {
            y = _videoSize.height - height;
        }
        
        UIImage *originalImage = [_playerView currentFrame];
        
        IplImage *srcIplImage = OpenCVTool::createBGRIplImageFromUIImage(originalImage);
        
        IplImage *destIplImage = cvCreateImage(cvSize(width, height), srcIplImage->depth, srcIplImage->nChannels);
        
        OpenCVTool::clip(srcIplImage, destIplImage, x, y, width, height);
        
        cvReleaseImage(&srcIplImage);
        
        productImage = OpenCVTool::createRGBUIImageFromIplImage(destIplImage);
        
        cvReleaseImage(&destIplImage);
        
    
        SProductTagEditeInfo *productTagEditeInfo = [[SProductTagEditeInfo alloc] init];
        productTagEditeInfo.tagIndex = -1;//表示是新增标签
        productTagEditeInfo.productOriginVideoURL = _videoURL;
        productTagEditeInfo.productImage = productImage;
        productTagEditeInfo.productOriginImageBei=[self getdefaultTagViewToPointImage];
        
        productTagEditeInfo.tagViewFlip = _defaultTagView.flip;
        
        
        productTagEditeInfo.tagViewToPoint = CGPointMake(point.x/_playerView.frame.size.width, point.y/_playerView.frame.size.height);//归一化
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showEditeProductTagViewWith:productTagEditeInfo animated:YES];
    }
}



- (UIImage *) getdefaultTagViewToPointImage
{
    CGPoint    point = _defaultTagView.toPoint;
    UIImage *productImage = nil;
    
    if (_image != nil)
    {
        
        
        float k = _imageView.image.size.width/_imageView.frame.size.width;
        
        float width = 350;
        float height = 350;
        
        float x = point.x * k - width/2.0;
        float y = point.y * k - height/2.0;
        
        if (x < 0)
        {
            x = 0;
        }
        
        if (x > _imageView.image.size.width - width)
        {
            x = _imageView.image.size.width - width;
        }
        
        if (y < 0)
        {
            y = 0;
        }
        
        if (y > _imageView.image.size.height - height)
        {
            y = _imageView.image.size.height - height;
        }
        
        IplImage *srcIplImage = OpenCVTool::createBGRIplImageFromUIImage(_imageView.image);
        
        IplImage *destIplImage = cvCreateImage(cvSize(width, height), srcIplImage->depth, srcIplImage->nChannels);
        
        OpenCVTool::clip(srcIplImage, destIplImage, x, y, width, height);
        
        cvReleaseImage(&srcIplImage);
        
        productImage = OpenCVTool::createRGBUIImageFromIplImage(destIplImage);
        
        cvReleaseImage(&destIplImage);
        
    }
    else if (_videoURL != nil)
    {
        
        float k = _videoSize.width/_playerView.frame.size.width;
        
        
        
        float width = 350 * (_videoSize.width/750.0);
        float height = 350 * (_videoSize.width/750.0);
        
        float x = point.x * k - width/2.0;
        float y = point.y * k - height/2.0;
        
        if (x < 0)
        {
            x = 0;
        }
        
        if (x > _videoSize.width - width)
        {
            x = _videoSize.width - width;
        }
        
        if (y < 0)
        {
            y = 0;
        }
        
        if (y > _videoSize.height - height)
        {
            y = _videoSize.height - height;
        }
        
        UIImage *originalImage = [_playerView currentFrame];
        
        IplImage *srcIplImage = OpenCVTool::createBGRIplImageFromUIImage(originalImage);
        
        IplImage *destIplImage = cvCreateImage(cvSize(width, height), srcIplImage->depth, srcIplImage->nChannels);
        
        OpenCVTool::clip(srcIplImage, destIplImage, x, y, width, height);
        
        cvReleaseImage(&srcIplImage);
        
        productImage = OpenCVTool::createRGBUIImageFromIplImage(destIplImage);
        
        cvReleaseImage(&destIplImage);
        
        
    }
    
    return  productImage;
}



- (void)deleteTagWithIndex:(int)index
{
    STagView *tagView;
    for (STagView *stagv in _tagMutableArray) {
        if (stagv.tag==index) {
            tagView=stagv;
            break;
        }
    }
    if (!tagView) {
        return;
    }
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        tagView.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1);
        
    } completion:^(BOOL finished) {
        
        [tagView removeFromSuperview];
    }];
    
    [_tagMutableArray removeObjectAtIndex:index];
    [_productTagEditeInfoMutableArray removeObjectAtIndex:index];
    
    //更新索引信息
    for (int i=0; i<[_tagMutableArray count]; i++)
    {
        STagView *tagView = [_tagMutableArray objectAtIndex:i];
        tagView.tag = i;
        
        SProductTagEditeInfo *productTagEditeInfo = [_productTagEditeInfoMutableArray objectAtIndex:i];
        productTagEditeInfo.tagIndex = i;
    }
    
    if (_defaultTagView.superview == nil)
    {
        _defaultTagView.center = [self getDefaultTagViewNewCenter];
        
        if (_image != nil)
        {
            [_imageView addSubview:_defaultTagView];
        }
        else if (_videoURL != nil)
        {
            [_playerView addSubview:_defaultTagView];
        }
    }

}

- (void)tagPan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    static CGPoint backupCenter;
    static BOOL backFlip;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        STagView *tagView = (STagView *)panGestureRecognizer.view;
        
        backupCenter = tagView.center;
        backFlip = tagView.flip;
    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged
        ||
        panGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        STagView *tagView = (STagView *)panGestureRecognizer.view;
        
        CGPoint point;
        
        if (_image != nil)
        {
            point = [panGestureRecognizer translationInView:_imageView];
            
            CGPoint newCenter = CGPointMake(tagView.center.x + point.x, tagView.center.y + point.y);
            
        
            BOOL flip = tagView.flip;
            
            if (newCenter.x < _imageView.frame.size.width/3.0)
            {
                flip = YES;
            }
            else if (newCenter.x > _imageView.frame.size.width*2.0/3.0)
            {
                flip = NO;
            }
            
            if (newCenter.x + tagView.frame.size.width/2.0 > _imageView.frame.size.width)
            {
                newCenter.x = _imageView.frame.size.width - tagView.frame.size.width/2.0;
            }
            
            if (newCenter.x < tagView.frame.size.width/2.0)
            {
                newCenter.x = tagView.frame.size.width/2.0;
            }
            
            if (newCenter.y + tagView.frame.size.height/2.0 > _imageView.frame.size.height)
            {
                newCenter.y = _imageView.frame.size.height - tagView.frame.size.height/2.0;
            }
            
            if (newCenter.y < tagView.frame.size.height/2.0)
            {
                newCenter.y = tagView.frame.size.height/2.0;
            }
            
            tagView.center = newCenter;
            
            tagView.flip = flip;
            
            [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:_imageView];
            
            
            if (tagView != _defaultTagView)
            {
                NSInteger index = tagView.tag;
                
                //更新对应标签的信息
                SProductTagEditeInfo *productTagEditeInfo = [_productTagEditeInfoMutableArray objectAtIndex:index];
                
                productTagEditeInfo.tagViewToPoint = CGPointMake(tagView.toPoint.x/_imageView.frame.size.width, tagView.toPoint.y/_imageView.frame.size.height) ;;

                productTagEditeInfo.tagViewFlip = tagView.flip;
            }
        }
        else if (_videoURL != nil)
        {
            point = [panGestureRecognizer translationInView:_playerView];
            
            CGPoint newCenter = CGPointMake(tagView.center.x + point.x, tagView.center.y + point.y);
            
            BOOL flip = tagView.flip;
            
            if (newCenter.x < _playerView.frame.size.width/3.0)
            {
                flip = YES;
            }
            else if (newCenter.x > _playerView.frame.size.width*2.0/3.0)
            {
                flip = NO;
            }
            
            if (newCenter.x + tagView.frame.size.width/2.0 > _playerView.frame.size.width)
            {
                newCenter.x = _playerView.frame.size.width - tagView.frame.size.width/2.0;
            }
            
            if (newCenter.x < tagView.frame.size.width/2.0)
            {
                newCenter.x = tagView.frame.size.width/2.0;
            }
            
            if (newCenter.y + tagView.frame.size.height/2.0 > _playerView.frame.size.height)
            {
                newCenter.y = _playerView.frame.size.height - tagView.frame.size.height/2.0;
            }
            
            if (newCenter.y < tagView.frame.size.height/2.0)
            {
                newCenter.y = tagView.frame.size.height/2.0;
            }
            
            tagView.center = newCenter;
            
            tagView.flip = flip;
            
            [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:_playerView];
            
            
            if (tagView != _defaultTagView)
            {
                NSInteger index = tagView.tag;
                
                //更新对应标签的信息
                SProductTagEditeInfo *productTagEditeInfo = [_productTagEditeInfoMutableArray objectAtIndex:index];
                
                productTagEditeInfo.tagViewToPoint = CGPointMake(tagView.toPoint.x/_playerView.frame.size.width, tagView.toPoint.y/_playerView.frame.size.height) ;
                
                productTagEditeInfo.tagViewFlip = tagView.flip;
            }
        }
    }
    
    
    //防止移动后的标签和现有标签有重合
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded
        ||
        panGestureRecognizer.state == UIGestureRecognizerStateCancelled
        ||
        panGestureRecognizer.state == UIGestureRecognizerStateFailed)
    {
        BOOL rectIntersectsRect = NO;
        
        CGRect  newFrame = panGestureRecognizer.view.frame;
        
        for (int i=0; i<[_tagMutableArray count]; i++)
        {
            STagView *tagView = [_tagMutableArray objectAtIndex:i];
            
            if (tagView == panGestureRecognizer.view)//当前标签
            {
                continue;
            }
            
            if (CGRectIntersectsRect(tagView.frame, newFrame))//当前标签和已有的标签有重合
            {
                rectIntersectsRect = YES;
            }
        }
        
        if (_defaultTagView != panGestureRecognizer.view
            &&
            CGRectIntersectsRect(_defaultTagView.frame, newFrame))//当前标签和默认的标签有重合
        {
            rectIntersectsRect = YES;
        }
        
        if (rectIntersectsRect)
        {
            STagView *tagView = (STagView *)panGestureRecognizer.view;
            
            [UIView animateWithDuration:.25 animations:^{
                tagView.flip = backFlip;
                tagView.center = backupCenter;
            }];
        }
    }
}

- (void)tagTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    STagView *tagView = (STagView *)tapGestureRecognizer.view;
    SProductTagEditeInfo *productTagEditeInfo = [_productTagEditeInfoMutableArray objectAtIndex:tagView.tag];
    
    productTagEditeInfo.productOriginImageBei=[self getdefaultTagViewToPointImage];
    
    [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showEditeProductTagViewWith:productTagEditeInfo animated:YES];
}

- (void)addProductTagWithInfo:(SProductTagEditeInfo *)productTagEditeInfo
{
    //添加标签
    STagView *newTagView  = [[STagView alloc] init];
    newTagView.tagType = CoverTagTypeItem;
    newTagView.title = productTagEditeInfo.productBrandName;
    newTagView.flip = productTagEditeInfo.tagViewFlip;
    newTagView.tagStyle = STagViewStyleClose;
    
    if (_image != nil)
    {
        newTagView.toPoint = CGPointMake(productTagEditeInfo.tagViewToPoint.x * _imageView.frame.size.width, productTagEditeInfo.tagViewToPoint.y * _imageView.frame.size.height);
    }
    else if (_videoURL != nil)
    {
        newTagView.toPoint = CGPointMake(productTagEditeInfo.tagViewToPoint.x * _playerView.frame.size.width, productTagEditeInfo.tagViewToPoint.y * _playerView.frame.size.height);
    }
    
    
    int currentIndex = (int)[_tagMutableArray count];
    
    newTagView.tag = currentIndex;

    productTagEditeInfo.tagIndex = currentIndex;
    
    __weak typeof(self) weakSelf = self;
    newTagView.closeTagBlock = ^(){
    
        [weakSelf deleteTagWithIndex:productTagEditeInfo.tagIndex];
    };
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tagPan:)];
    [newTagView addGestureRecognizer:panGestureRecognizer];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagTap:)];
    [newTagView addGestureRecognizer:tapGestureRecognizer];
    
    
    if (_image != nil)
    {
        [_imageView addSubview:newTagView];
    }
    else if (_videoURL != nil)
    {
        [_playerView addSubview:newTagView];
    }
    
    [_tagMutableArray addObject:newTagView];

    [_productTagEditeInfoMutableArray addObject:productTagEditeInfo];
    
    NSLog(@"addProductTagWithInfo productTagEditeInfo 22");
    
    //移动默认标签  避免挡着新增标签
    if ([_tagMutableArray count] >= 9)
    {
        [_defaultTagView removeFromSuperview];
    }
    else
    {
        CGPoint newCenter = [self getDefaultTagViewNewCenter];
        
        if (newCenter.x < _defaultTagView.superview.frame.size.width/3.0)
        {
            _defaultTagView.flip = YES;
        }
        
        if (newCenter.x > _defaultTagView.superview.frame.size.width * 2.0/3.0)
        {
            _defaultTagView.flip = NO;
        }
        
        _defaultTagView.center = newCenter;
    }
}

- (CGPoint)getDefaultTagViewNewCenter
{
    //给默认标签寻找新的位置，以免挡住已经添加的标签
    float offsetX = _defaultTagView.frame.size.width + 5;
    float offsetY = _defaultTagView.frame.size.height + 5;
    
    NSLog(@"_defaultTagView.superview = %@", _defaultTagView.superview);
    
    CGRect defaultTagViewFrame = _defaultTagView.frame;
    
    int number = 0;//最多选两遍，避免陷入死循环而不能自拔
    
    while (number < 2)
    {
        defaultTagViewFrame.origin.x += offsetX;
        
        if (defaultTagViewFrame.origin.x > _defaultTagView.superview.frame.size.width - _defaultTagView.frame.size.width)
        {
            defaultTagViewFrame.origin.x = 0;
            defaultTagViewFrame.origin.y += offsetY;
            if (defaultTagViewFrame.origin.y > _defaultTagView.superview.frame.size.height - _defaultTagView.frame.size.height)
            {
                defaultTagViewFrame.origin.y = 10;
                number++;
            }
        }
        
        BOOL done = YES;
        for (int i=0; i<[_tagMutableArray count]; i++)
        {
            STagView *tagView = [_tagMutableArray objectAtIndex:i];
            
            if (CGRectIntersectsRect(tagView.frame, defaultTagViewFrame))
            {
                done = NO;
                break;
            }
        }
        
        if (done)
        {
            break;
        }
    }
    
    return CGPointMake(defaultTagViewFrame.origin.x + defaultTagViewFrame.size.width/2.0, defaultTagViewFrame.origin.y + defaultTagViewFrame.size.height/2.0);
}

- (void)updateProductTagWithInfo:(SProductTagEditeInfo *)productTagEditeInfo
{
    SProductTagEditeInfo *oldProductTagEditeInfo =[_productTagEditeInfoMutableArray objectAtIndex:productTagEditeInfo.tagIndex];
    
    oldProductTagEditeInfo.productId = productTagEditeInfo.productId;
    oldProductTagEditeInfo.productCode = productTagEditeInfo.productCode;
    oldProductTagEditeInfo.productName = productTagEditeInfo.productName;
    
    oldProductTagEditeInfo.productImage = productTagEditeInfo.productImage;
    oldProductTagEditeInfo.productOriginImage = productTagEditeInfo.productOriginImage;
    oldProductTagEditeInfo.productOriginVideoURL = productTagEditeInfo.productOriginVideoURL;
    
    oldProductTagEditeInfo.productCategoryId = productTagEditeInfo.productCategoryId;
    oldProductTagEditeInfo.productCategoryName = productTagEditeInfo.productCategoryName;
    
    oldProductTagEditeInfo.productSubCategoryId = productTagEditeInfo.productSubCategoryId;
    oldProductTagEditeInfo.productSubCategoryCode = productTagEditeInfo.productSubCategoryCode;
    oldProductTagEditeInfo.productSubCategoryName = productTagEditeInfo.productSubCategoryName;
    
    oldProductTagEditeInfo.productBrandId = productTagEditeInfo.productBrandId;
    oldProductTagEditeInfo.productBrandCode = productTagEditeInfo.productBrandCode;
    oldProductTagEditeInfo.productBrandName = productTagEditeInfo.productBrandName;
    
    oldProductTagEditeInfo.productColorId = productTagEditeInfo.productColorId;
    oldProductTagEditeInfo.productColorCode = productTagEditeInfo.productColorCode;
    oldProductTagEditeInfo.productColorName = productTagEditeInfo.productColorName;
    
    STagView *tagView = [_tagMutableArray objectAtIndex:productTagEditeInfo.tagIndex];
    tagView.title = productTagEditeInfo.productBrandName;
}

@end

















