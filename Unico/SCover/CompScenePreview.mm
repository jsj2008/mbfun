//
//  CompScenePreview.m
//  Wefafa
//
//  Created by chencheng on 15/7/20.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CompScenePreview.h"

#include <sys/time.h>
#import "OpenCVTool.h"

#import <opencv2/highgui/highgui_c.h>
#import <opencv2/imgproc/imgproc_c.h>

static double g_fps = 30;
static CvSize g_mp4Size = cvSize(750, 750);

static NSString *g_specialEffectsMovName = @"2";
static NSString *g_specialEffectsMovType = @"mp4";


static NSString *g_audioName = @"1";
static NSString *g_audioType = @"mp3";

#import "OpenCVTool.h"

@implementation CompScenePreview


- (void)startPreview
{
    //先播放音乐
    NSURL *mp3Url = [[NSBundle mainBundle] URLForResource:g_audioName withExtension:g_audioType];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:mp3Url error:nil];
    _player.delegate = self;
    [_player prepareToPlay];
    [_player play];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_previewPlayerView.bounds];
    
    imageView.contentMode = UIViewContentModeScaleToFill;
    
    [_previewPlayerView addSubview:imageView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSString *specialEffectsMovPath = [[NSBundle mainBundle] pathForResource:g_specialEffectsMovName ofType:g_specialEffectsMovType];
        
        CvCapture   *specialEffectsCapture = cvCreateFileCapture([specialEffectsMovPath UTF8String]);
        
        for (int i=0; i<[_imageMutableArray count]; i = (++i)%[_imageMutableArray count])
        {
            @autoreleasepool {
                IplImage *srcIplImage = OpenCVTool::createBGRIplImageFromUIImage([_imageMutableArray objectAtIndex:i]);
                
                //先适配尺寸
                IplImage *aspectFillToSizeIplImage = cvCreateImage(g_mp4Size, srcIplImage->depth, srcIplImage->nChannels);
                OpenCVTool::scaleAspectFillToSize(srcIplImage, aspectFillToSizeIplImage);
                cvReleaseImage(&srcIplImage);
                
                
                for (int j=1; j<=g_fps; j++)
                {
                    struct timeval time1;
                    gettimeofday(&time1, NULL);
                    
                    IplImage *waiShowIplImage = cvCreateImage(g_mp4Size, aspectFillToSizeIplImage->depth, aspectFillToSizeIplImage->nChannels);
                    
                    [self processingImage:aspectFillToSizeIplImage preImage:nil nextImage:nil inputIlpImageIndex:i inputIlpImageFrameIndex:j  specialEffectsCapture:&specialEffectsCapture outputIlpImage:waiShowIplImage];
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        @autoreleasepool {
                            
                            imageView.image = OpenCVTool::createRGBUIImageFromIplImage(waiShowIplImage);
                        }
                    });
                    
                    cvReleaseImage(&waiShowIplImage);
                    
                    struct timeval time2;
                    gettimeofday(&time2, NULL);
                    
                    long d = (time2.tv_sec * 1000000 + time2.tv_usec) - (time1.tv_sec * 1000000 + time1.tv_usec);
                    
                    if (d < 1000000.0/g_fps)
                    {
                        usleep(1000000.0/g_fps - d);
                    }
                    
                }
                cvReleaseImage(&aspectFillToSizeIplImage);
            }
        }
        
        cvReleaseCapture(&specialEffectsCapture);
    });
}

- (void)createMP4FileWithUpdateProgress:(void (^)(float progress, NSString *mp4Filepath))updateProgress
{
    //生成视频文件
    NSString *videoFilePath = [NSString stringWithFormat:@"%@/tmp/video.mp4", NSHomeDirectory()];
    
    [[NSFileManager defaultManager] removeItemAtPath:videoFilePath error:nil];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        //即将要创建的视频
        CvVideoWriter *videoWriter = cvCreateVideoWriter([videoFilePath UTF8String], CV_FOURCC('M', 'J', 'P', 'G'), g_fps, g_mp4Size);
        
        //NSString *specialEffectsMovPath = [[NSBundle mainBundle] pathForResource:@"Yh1" ofType:@"mp4"];
        NSString *specialEffectsMovPath = [[NSBundle mainBundle] pathForResource:g_specialEffectsMovName ofType:g_specialEffectsMovType];
        CvCapture   *specialEffectsCapture = cvCreateFileCapture([specialEffectsMovPath UTF8String]);
        
        
        for (int i=0; i<[_imageMutableArray count]; i++)
        {
            @autoreleasepool {
                IplImage *srcIplImage = OpenCVTool::createBGRIplImageFromUIImage([_imageMutableArray objectAtIndex:i]);
                
                //先适配尺寸
                IplImage *aspectFillToSizeIplImage = cvCreateImage(g_mp4Size, srcIplImage->depth, srcIplImage->nChannels);
                OpenCVTool::scaleAspectFillToSize(srcIplImage, aspectFillToSizeIplImage);
                cvReleaseImage(&srcIplImage);
                
                
                for (int j=1; j<=g_fps; j++)
                {
                    IplImage *outIplImage = cvCreateImage(g_mp4Size, aspectFillToSizeIplImage->depth, aspectFillToSizeIplImage->nChannels);
                    
                    [self processingImage:aspectFillToSizeIplImage preImage:nil nextImage:nil inputIlpImageIndex:i inputIlpImageFrameIndex:j  specialEffectsCapture:&specialEffectsCapture outputIlpImage:outIplImage];
                    
                    int ret = cvWriteFrame(videoWriter, outIplImage);
                    if (ret != 1)
                    {
                        NSLog(@"cvWriteFrame err");
                    }
                    
                    cvReleaseImage(&outIplImage);
                }
                cvReleaseImage(&aspectFillToSizeIplImage);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (updateProgress != nil && i+1 != [_imageMutableArray count])
                {
                    updateProgress(float(i+1)/(float)[_imageMutableArray count], nil);
                }
            });
        }
        
        cvReleaseCapture(&specialEffectsCapture);
        cvReleaseVideoWriter(&videoWriter);
        
        
        AVAsset *videAsset = [AVAsset assetWithURL:[[NSURL alloc] initFileURLWithPath:videoFilePath]];
        
        AVMutableComposition *avMutableComposition = [[AVMutableComposition alloc] init];
        
        
        //创建一个视频轨道
        AVMutableCompositionTrack *videoTrack = [avMutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videAsset.duration) ofTrack:[[videAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
        
        NSURL *audioURL = [[NSBundle mainBundle] URLForResource:g_audioName withExtension:g_audioType];
        
        AVAsset *audioAsset = [AVAsset assetWithURL:audioURL];
        
        //创建一个音频轨道
        AVMutableCompositionTrack *audioTrack = [avMutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        
        //音乐为循环播放
        long videDuration = videAsset.duration.value/videAsset.duration.timescale;
        long audioDuration = audioAsset.duration.value/audioAsset.duration.timescale;
        
        long count = videDuration/audioDuration;
        
        
        for (int i=0; i<count; i++)
        {
            CMTime start = CMTimeMake(audioAsset.duration.value * i, audioAsset.duration.timescale);
            
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:start error:nil];
            
        }
        
        long leftTime = videDuration % audioDuration;
        
        if (leftTime > 0)
        {
            CMTime start = CMTimeMake(audioAsset.duration.value * count, audioAsset.duration.timescale);
            CMTime duration = CMTimeMake(leftTime * videAsset.duration.timescale, videAsset.duration.timescale);
            
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:start error:nil];
        }
        
        //生成视频文件
        NSString *videAndAudioFilePath = [NSString stringWithFormat:@"%@/tmp/videAndAudio.mp4", NSHomeDirectory()];
        [[NSFileManager defaultManager] removeItemAtPath:videAndAudioFilePath error:nil];
        
        NSURL *videAndAudioURL = [[NSURL alloc] initFileURLWithPath:videAndAudioFilePath];
        
        //设置输出对象
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc]initWithAsset:avMutableComposition presetName:AVAssetExportPresetHighestQuality];
        exporter.outputURL = videAndAudioURL;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.shouldOptimizeForNetworkUse = YES;
        
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (updateProgress != nil)
                {
                    updateProgress(1, videAndAudioFilePath);
                }
            });
        }];
    });
}



- (void)processingImage:(IplImage *)inputIlpImage preImage:(IplImage *)preIlpImage nextImage:(IplImage *)nextIlpImage inputIlpImageIndex:(int)inputIlpImageIndex inputIlpImageFrameIndex:(int)inputIlpImageFrameIndex specialEffectsCapture:(CvCapture **)specialEffectsCapture outputIlpImage:(IplImage *)outputIlpImage
{
    IplImage *waitAddWeightedImage = cvCreateImage(g_mp4Size, inputIlpImage->depth, inputIlpImage->nChannels);
    
    if (inputIlpImageIndex == -1)//第一张图片 1、首先高斯模糊，向左边移动，边移动边变清晰，2、再模糊、再变清晰
    {
        //为了保证左移后右边不露出空白、每次左移后放大1.3倍。
        
        //跳跃式左移
        IplImage *tempIplImage1 = cvCreateImage(g_mp4Size, inputIlpImage->depth, inputIlpImage->nChannels);
        
        if (inputIlpImageFrameIndex < g_fps/3.0)
        {
            IplImage *tempIplImage2 = cvCreateImage(g_mp4Size, inputIlpImage->depth, inputIlpImage->nChannels);
            OpenCVTool::scaleImage(tempIplImage1, tempIplImage2, 1.3, 1.3);

            cvSmooth(tempIplImage2, waitAddWeightedImage, CV_GAUSSIAN, 41, 41);
        }
        else if (inputIlpImageFrameIndex < g_fps*2.0/3.0)
        {
            IplImage *tempIplImage2 = cvCreateImage(g_mp4Size, inputIlpImage->depth, inputIlpImage->nChannels);
            OpenCVTool::scaleImage(tempIplImage1, tempIplImage2, 1.3, 1.3);
            
            OpenCVTool::translationImage(inputIlpImage, tempIplImage1, -40, 0);
            
            cvSmooth(tempIplImage2, waitAddWeightedImage, CV_GAUSSIAN, 1, 1);
        }
        else
        {
            OpenCVTool::translationImage(inputIlpImage, tempIplImage1, -80, 0);
        }
        

        IplImage *tempIplImage2 = cvCreateImage(g_mp4Size, inputIlpImage->depth, inputIlpImage->nChannels);
        OpenCVTool::scaleImage(tempIplImage1, tempIplImage2, 1.3, 1.3);
        
        cvReleaseImage(&tempIplImage1);
        
        static int gaussianSize = 1;
        if (inputIlpImageFrameIndex == 0)
        {
            gaussianSize = 1;
        }
        
        //由模糊变清晰 再模糊再清晰
        if (inputIlpImageFrameIndex == g_fps/2.0 || inputIlpImageFrameIndex == g_fps/2.0 + 1 || inputIlpImageFrameIndex == g_fps/2.0 - 1)
        {
            gaussianSize = 1;
        }
        cvSmooth(tempIplImage2, waitAddWeightedImage, CV_GAUSSIAN, gaussianSize, gaussianSize);
        gaussianSize += 6;

        cvReleaseImage(&tempIplImage2);
    }
    else
    {
        //先逐渐放大
        if (inputIlpImageFrameIndex < g_fps/2.0)
        {
            //逐渐放大
            OpenCVTool::scaleImage(inputIlpImage, waitAddWeightedImage, 1.0+((0.3/(g_fps/2.0)) * inputIlpImageFrameIndex), 1.0+((0.3/(g_fps/2.0)) * inputIlpImageFrameIndex));
        }
        else
        {
            //逐渐缩小
            //IplImage *tempIplImage = cvCreateImage(g_mp4Size, inputIlpImage->depth, inputIlpImage->nChannels);
            OpenCVTool::scaleImage(inputIlpImage, waitAddWeightedImage, 1.3-(0.3/g_fps * inputIlpImageFrameIndex), 1.3-(0.3/g_fps * inputIlpImageFrameIndex));
            
           /* if (inputIlpImageIndex == 1)//第2张缩小时变黑白
            {
                IplImage *tempIplImage2 = cvCreateImage(g_mp4Size, tempIplImage->depth, tempIplImage->nChannels);
                OpenCVTool::rgb2gray(tempIplImage, tempIplImage2);
                cvReleaseImage(&tempIplImage);
                tempIplImage = tempIplImage2;
            }
            
            
            //缩小的同时变得模糊
            int k = ((inputIlpImageFrameIndex+20) - g_fps/2.0);
            if (k % 2 == 0)
            {
                k++;
            }
            cvSmooth(tempIplImage, waitAddWeightedImage, CV_GAUSSIAN, k, k);
            
            cvReleaseImage(&tempIplImage);*/
        }
    }
    
    
    NSString *specialEffectsMovPath = [[NSBundle mainBundle] pathForResource:g_specialEffectsMovName ofType:g_specialEffectsMovType];
    
    //叠加特效
    IplImage *specialEffectsIplImage = OpenCVTool::cvQueryFrameRepeatMode(specialEffectsCapture, [specialEffectsMovPath UTF8String]);
    
    //NSLog(@"specialEffectsIplImage = %p", specialEffectsIplImage);
    //NSLog(@"specialEffectsIplImage->nChannels = %d", specialEffectsIplImage->nChannels);
    //NSLog(@"specialEffectsIplImage->depth = %d", specialEffectsIplImage->depth);
    
    IplImage *specialEffectsIplImage_BGR = cvCreateImage(cvSize(specialEffectsIplImage->width, specialEffectsIplImage->height), specialEffectsIplImage->depth, 3);
    
    cvCvtColor(specialEffectsIplImage, specialEffectsIplImage_BGR, CV_RGB2BGR); //颜色空间转换 重要!!
    
    IplImage *outPutSpecialEffectsIplImage = cvCreateImage(g_mp4Size, inputIlpImage->depth, inputIlpImage->nChannels);
    cvResize(specialEffectsIplImage_BGR, outPutSpecialEffectsIplImage);
    
    cvAddWeighted(waitAddWeightedImage, 0.3, outPutSpecialEffectsIplImage, 0.7, 0, outputIlpImage);
    
    //unsigned char alphaColor[] = {0x02, 0xFF, 0x00};//BGR
    
    //OpenCVTool::mergeImageLayer(outPutSpecialEffectsIplImage, waitAddWeightedImage, outputIlpImage, alphaColor);
    
    cvReleaseImage(&waitAddWeightedImage);
    cvReleaseImage(&specialEffectsIplImage_BGR);
    cvReleaseImage(&outPutSpecialEffectsIplImage);
}


@end

