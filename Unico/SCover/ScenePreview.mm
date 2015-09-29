//
//  ScenePreview.m
//  Wefafa
//
//  Created by moooc on 15/7/9.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "ScenePreview.h"
#import "OpenCVTool.h"


@interface ScenePreview()

@end

@implementation ScenePreview

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _previewPlayerView = [[UIView alloc] init];
        _previewPlayerView.clipsToBounds = YES;
        
        _imageMutableArray = [[NSMutableArray alloc] init];
        
        [self addSubview:_previewPlayerView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        _previewPlayerView = [[UIView alloc] initWithFrame:self.bounds];
        _previewPlayerView.clipsToBounds = YES;
        
        _imageMutableArray = [[NSMutableArray alloc] init];
        
        [self addSubview:_previewPlayerView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _previewPlayerView.frame = self.bounds;
}

- (void)startPreview;//开始预览
{
    
}

- (void)createMP4FileWithUpdateProgress:(void (^)(float progress, NSString *mp4Filepath))updateProgress
{
    
}

- (void)setAssetsArray:(NSArray *)assetsArray
{
    _assetsArray = assetsArray;
    
    if (self.assetsArray!=nil && [self.assetsArray count]>0)
    {
        for (int i=0; i<[self.assetsArray count]; i++)
        {
            UIImage *image = nil;
            
            ALAsset *asset = [self.assetsArray objectAtIndex:i];
            
            ALAssetRepresentation *defaultRepresentation = asset.defaultRepresentation;
            
            if (defaultRepresentation.fullScreenImage != NULL)//优先使用全屏图像
            {
                image = [UIImage imageWithCGImage:defaultRepresentation.fullScreenImage];
            }
            else if (defaultRepresentation.fullResolutionImage != NULL)
            {
                image = [UIImage imageWithCGImage:defaultRepresentation.fullResolutionImage
                                                      scale:defaultRepresentation.scale
                                                orientation:(UIImageOrientation)defaultRepresentation.orientation];
            }
            else if ([asset aspectRatioThumbnail] != NULL)
            {
                image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
            }
            
            if (image != nil)
            {
                [_imageMutableArray addObject: image];
            }
            
        }
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag)
    {
        [player play];
    }
}


@end
