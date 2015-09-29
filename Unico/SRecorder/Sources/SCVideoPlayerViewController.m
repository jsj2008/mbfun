//
//  SCVideoPlayerViewController.m
//  SCAudioVideoRecorder
//
//  Created by Simon CORSIN on 8/30/13.
//  Copyright (c) 2013 rFlex. All rights reserved.
//

#import "SCVideoPlayerViewController.h"
#import "SCEditVideoViewController.h"
#import "SCAssetExportSession+Animation.h"
#import "CAAnimation+EasingEquations.h"
#import "CAAnimation+Blocks.h"

#import "SUtilityTool.h"

@interface SCVideoPlayerViewController ()<SCPlayerDelegate>
{
    SCPlayer *_player;
    NSArray *_filters;
    NSInteger selectedIndex;
    
    SCRecordSession *_recordSession;
    
    UIImageView  *_videoCoverImageView;
}

@end

@implementation SCVideoPlayerViewController


- (void)setRecordSession:(SCRecordSession *)recordSession
{
    _recordSession = recordSession;
    
    if ([self isViewLoaded])
    {
        [self updatePlayerItem];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self) {
        // Custom initialization
        self.navigationController.navigationBarHidden = YES;
        self.navigationItem.leftBarButtonItem = nil;
    }
	
    return self;
}

- (void)dealloc {
    self.filterSwitcherView = nil;
    [_player pause];
    _player = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _videoCoverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    _videoCoverImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_videoCoverImageView];
    
	_player = [SCPlayer player];
    _player.muted = YES;
    _player.delegate = self;

    // TODO: 为什么需要分这两个？
    if ([[NSProcessInfo processInfo] activeProcessorCount] > 1)
    {
        // 设置video的背景，不然就是白色的
        self.filterSwitcherView.backgroundColor = [UIColor blackColor];

        self.filterSwitcherView.refreshAutomaticallyWhenScrolling = NO;
        self.filterSwitcherView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.filterSwitcherView.filters = [[SUtilityTool shared] recorderFilters];
        _filters = self.filterSwitcherView.filters;
        
        _player.CIImageRenderer = self.filterSwitcherView;
    }
    else
    {
        SCVideoPlayerView *playerView = [[SCVideoPlayerView alloc] initWithPlayer:_player];
        playerView.frame = self.filterSwitcherView.frame;
        playerView.autoresizingMask = self.filterSwitcherView.autoresizingMask;
        [self.filterSwitcherView.superview insertSubview:playerView aboveSubview:self.filterSwitcherView];
        [self.filterSwitcherView removeFromSuperview];
    }
    
    self.filterSwitcherView.userInteractionEnabled = NO;//禁止使用滤镜
    
	_player.loopEnabled = YES;
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)updatePlayerItem
{
    AVAsset *avAsset = _recordSession.assetRepresentingSegments;
    
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:avAsset];
    
    NSError *error=nil;
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:kCMTimeZero actualTime:&actualTime error:&error];
    if(error == nil)
    {
        CMTimeShow(actualTime);
        UIImage *image=[UIImage imageWithCGImage:cgImage];
        
        _videoCoverImageView.alpha = 1;
        _videoCoverImageView.image = image;
        
        CGImageRelease(cgImage);
    }
    
    [_player setItemByAsset:_recordSession.assetRepresentingSegments];
    [_player play];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    if (_player.item == nil)
    {
        [self updatePlayerItem];
    }
    else
    {
         [_player play];
    }
    
    [self previewAnimation];
}


- (void)player:(SCPlayer *)player itemReadyToPlay:(AVPlayerItem *)item
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _videoCoverImageView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_player pause];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[SCEditVideoViewController class]]) {
        SCEditVideoViewController *editVideo = segue.destinationViewController;
        editVideo.recordSession = self.recordSession;
    }
}

- (CMTimeRange)getTimeRangeForThisVideo
{
    CMTime start = _player.loopStartTime;
    CMTime duration = start;
    duration.value = 10 * duration.timescale; // 10秒
    return CMTimeRangeMake(start, duration);
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

    if (error == nil) {
        [[[UIAlertView alloc] initWithTitle:@"保存到系统相册" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"保存失败" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

-(void)saveVideo:(SDataVideoFunc)completeFunc
{
    [self saveVideoWithYOffset:0 withCompletion:completeFunc];
}

-(void)saveVideoWithYOffset:(float)yOffsetPercent withCompletion:(SDataVideoFunc)competeFunc
{
    SCFilter *currentFilter = self.filterSwitcherView.selectedFilter;
    if (self.filterSwitcherView.filters.count == 1) {
        currentFilter = self.filterSwitcherView.filters[0];
    }

    CMTimeRange timeRange = [self getTimeRangeForThisVideo];

    if (currentFilter == nil || currentFilter.isEmpty) {
        // 没有滤镜的情况下
        [self.recordSession mergeSegmentsUsingPreset:AVAssetExportPresetMediumQuality withTimeRange:timeRange withYOffset:yOffsetPercent completionHandler:competeFunc];
    } else {
        SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:self.recordSession.assetRepresentingSegments];
        exportSession.videoConfiguration.filter = currentFilter;
        exportSession.videoConfiguration.preset = SCPresetHighestQuality;
        exportSession.audioConfiguration.preset = SCPresetHighestQuality;
        exportSession.videoConfiguration.maxFrameRate = 35;
        exportSession.outputUrl = self.recordSession.outputUrl;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.timeRange = timeRange;

        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            competeFunc(exportSession.outputUrl, exportSession.error);
        }];
    }
}

-(void)saveVideoWithYOffset:(float)yOffsetPercent startTime:(float)startTime endTime:(float)endTime withCompletion:(SDataVideoFunc)competeFunc
{
    SCFilter *currentFilter = self.filterSwitcherView.selectedFilter;
    if (self.filterSwitcherView.filters.count == 1) {
        currentFilter = self.filterSwitcherView.filters[0];
    }
    
    CMTime start = _player.loopStartTime;
    CMTime duration = start;
    duration.value = (endTime - startTime) * duration.timescale;
    CMTimeRange timeRange =  CMTimeRangeMake(start, duration);

    
    if (currentFilter == nil || currentFilter.isEmpty) {
        // 没有滤镜的情况下
        [self.recordSession mergeSegmentsUsingPreset:AVAssetExportPresetMediumQuality withTimeRange:timeRange withYOffset:yOffsetPercent completionHandler:competeFunc];
    } else {
        SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:self.recordSession.assetRepresentingSegments];
        exportSession.videoConfiguration.filter = currentFilter;
        exportSession.videoConfiguration.preset = SCPresetHighestQuality;
        exportSession.audioConfiguration.preset = SCPresetHighestQuality;
        exportSession.videoConfiguration.maxFrameRate = 35;
        exportSession.outputUrl = self.recordSession.outputUrl;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.timeRange = timeRange;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            competeFunc(exportSession.outputUrl, exportSession.error);
        }];
    }
}

-(void)saveVideoWithYOffset:(float)yOffsetPercent heightWidthRatio:(float)heightWidthRatio rotate:(BOOL)rotate startTime:(float)startTime endTime:(float)endTime withCompletion:(SDataVideoFunc)competeFunc
{
    self.heightWidthRatio = heightWidthRatio;
    
    SCFilter *currentFilter = self.filterSwitcherView.selectedFilter;
    if (self.filterSwitcherView.filters.count == 1) {
        currentFilter = self.filterSwitcherView.filters[0];
    }
    
    CMTime start = _player.loopStartTime;
    CMTime duration = start;
    duration.value = (endTime - startTime) * duration.timescale;
    CMTimeRange timeRange =  CMTimeRangeMake(start, duration);
    
    
    if (currentFilter == nil || currentFilter.isEmpty) {
        // 没有滤镜的情况下
        [self.recordSession mergeSegmentsUsingPreset:AVAssetExportPresetMediumQuality withTimeRange:timeRange withYOffset:yOffsetPercent heightWidthRatio:heightWidthRatio rotate:rotate completionHandler:competeFunc];
    } else {
        SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:self.recordSession.assetRepresentingSegments];
        exportSession.videoConfiguration.filter = currentFilter;
        exportSession.videoConfiguration.preset = SCPresetHighestQuality;
        exportSession.audioConfiguration.preset = SCPresetHighestQuality;
        exportSession.videoConfiguration.maxFrameRate = 35;
        exportSession.outputUrl = self.recordSession.outputUrl;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.timeRange = timeRange;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            competeFunc(exportSession.outputUrl, exportSession.error);
        }];
    }
}


- (void)saveToCameraRoll {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    void(^completionHandler)(NSURL *url, NSError *error) = ^(NSURL *url, NSError *error) {
        if (error == nil) {
            UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        } else {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];

            [[[UIAlertView alloc] initWithTitle:@"Failed to save" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    };
    
    [self saveVideo:completionHandler];
}

-(int)getFilterIndex
{
    return (int)selectedIndex;
}

-(void)changeFilter:(int)offsetIndex{
    [self changeFilterTo:(int)selectedIndex+offsetIndex];
}

-(void)changeFilterTo:(int)filterIndex{
    if (!_filters || _filters.count<=0) {
        return;
    }

    // 确保filterIndex在正确的范围内
    if (filterIndex >= _filters.count)
        filterIndex = (int)_filters.count-1;
    if (filterIndex < 0)
        filterIndex = 0;

    selectedIndex = filterIndex;

    // TODO：用了粗暴的方式
    //
    NSLog(@"Select filter:%ld",(long)selectedIndex);
    SCFilter *filter = _filters[selectedIndex];
    
    self.filterSwitcherView.filters = @[filter];
    
    _player.CIImageRenderer = nil;
    _player.CIImageRenderer = self.filterSwitcherView;
}

-(void)saveWithAnimation{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    SCFilter *currentFilter = self.filterSwitcherView.selectedFilter;
    
    void(^completionHandler)(NSURL *url, NSError *error) = ^(NSURL *url, NSError *error) {
        if (error == nil) {
            UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        } else {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            [[[UIAlertView alloc] initWithTitle:@"Failed to save" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    };
    
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:self.recordSession.assetRepresentingSegments];
    exportSession.videoConfiguration.filter = currentFilter;
    exportSession.videoConfiguration.preset = SCPresetMediumQuality;
    exportSession.audioConfiguration.preset = SCPresetMediumQuality;
    exportSession.videoConfiguration.maxFrameRate = 35;
    exportSession.outputUrl = self.recordSession.outputUrl;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.timeRange = [self getTimeRangeForThisVideo];

    // test animation
    
    
    exportSession.animationLayers = [self animations];
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        completionHandler(exportSession.outputUrl, exportSession.error);
    }];
}


// TODO： 这里可以对渲染和预览，返回2个不同的数组，来快速解决坐标系和缩放问题。
-(NSArray*)animations{
    return @[];
    CALayer *overlayLayer0 = [CALayer layer];
    overlayLayer0.contents = (id)[UIImage imageNamed:@"watermark0.png"].CGImage;
    overlayLayer0.frame = CGRectMake(100, 0, 150, 150);
    CALayer *overlayLayer1 = [CALayer layer];
    overlayLayer1.contents = (id)[UIImage imageNamed:@"watermark1.png"].CGImage;
    overlayLayer1.frame = CGRectMake(100, 100, 100, 100);
    CALayer *overlayLayer2 = [CALayer layer];
    overlayLayer2.contents = (id)[UIImage imageNamed:@"watermark2.png"].CGImage;
    overlayLayer2.frame = CGRectMake(100, 200, 128, 128);
    CALayer *overlayLayer3 = [CALayer layer];
    overlayLayer3.contents = (id)[UIImage imageNamed:@"watermark3.png"].CGImage;
    overlayLayer3.frame = CGRectMake(100, 300, 50, 50);
    
//    // layer 0
//    CABasicAnimation *animation;
//    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//    animation.duration=2.0;
//    animation.repeatCount=15;
//    animation.autoreverses=YES;
//    // rotate from 0 to 360
//    animation.fromValue=[NSNumber numberWithFloat:0.0];
//    animation.toValue=[NSNumber numberWithFloat:(2.0 * M_PI)];
//    animation.beginTime = AVCoreAnimationBeginTimeAtZero;
//    [overlayLayer0 addAnimation:animation forKey:@"rotation"];
//    
//    animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    animation.duration=1.0;
//    animation.repeatCount=5;
//    animation.autoreverses=YES;
//    // animate from half size to full size
//    animation.fromValue=[NSNumber numberWithFloat:0.5];
//    animation.toValue=[NSNumber numberWithFloat:1.0];
//    animation.beginTime=AVCoreAnimationBeginTimeAtZero;
//    [overlayLayer0 addAnimation:animation forKey:@"scale"];
//    
//    // rotate
//    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//    animation.duration=2.0;
//    animation.repeatCount=5;
//    animation.autoreverses=YES;
//    // rotate from 0 to 360
//    animation.fromValue=[NSNumber numberWithFloat:0.0];
//    animation.toValue=[NSNumber numberWithFloat:(2.0 * M_PI)];
//    animation.beginTime = AVCoreAnimationBeginTimeAtZero;
//    [overlayLayer1 addAnimation:animation forKey:@"rotation"];
//    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//    animation.duration=2.0;
//    animation.repeatCount=5;
//    animation.autoreverses=YES;
//    // rotate from 0 to 360
//    animation.fromValue=[NSNumber numberWithFloat:0.0];
//    animation.toValue=[NSNumber numberWithFloat:(2.0 * M_PI)];
//    animation.beginTime = AVCoreAnimationBeginTimeAtZero;
//    [overlayLayer2 addAnimation:animation forKey:@"rotation"];
//    // animate
//    animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
//    animation.duration=3.0;
//    animation.repeatCount=5;
//    animation.autoreverses=YES;
//    // animate from fully visible to invisible
//    animation.fromValue=[NSNumber numberWithFloat:1.0];
//    animation.toValue=[NSNumber numberWithFloat:0.0];
//    animation.beginTime = AVCoreAnimationBeginTimeAtZero;
//    [overlayLayer1 addAnimation:animation forKey:@"animateOpacity"];
//    animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
//    animation.duration=3.0;
//    animation.repeatCount=5;
//    animation.autoreverses=YES;
//    // animate from invisible to fully visible
//    animation.fromValue=[NSNumber numberWithFloat:1.0];
//    animation.toValue=[NSNumber numberWithFloat:0.0];
//    animation.beginTime = AVCoreAnimationBeginTimeAtZero;
//    [overlayLayer2 addAnimation:animation forKey:@"animateOpacity"];
//    
//    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//    animation.duration=2.0;
//    animation.repeatCount=15;
//    animation.autoreverses=YES;
//    // rotate from 0 to 360
//    animation.fromValue=[NSNumber numberWithFloat:0.0];
//    animation.toValue=[NSNumber numberWithFloat:(2.0 * M_PI)];
//    animation.beginTime = AVCoreAnimationBeginTimeAtZero;
//    [overlayLayer3 addAnimation:animation forKey:@"rotation"];
    
    return @[overlayLayer0,overlayLayer1,overlayLayer2,overlayLayer3];
}

-(void)previewAnimation{
    NSArray *ary = [self animations];
    UIView *view = [UIView new];
    view.userInteractionEnabled = NO;
//    view.backgroundColor = [UIColor redColor];
    view.frame = self.view.frame;
    [self.view addSubview:view];
    for (CALayer *layer in ary) {
        [view.layer addSublayer:layer];
    }
}

// 混合银牌
-(IBAction)mixarClicado:(id)sender{
    //disparando em uma nova thread
    //elaboracaodo mix audio e video pode demorar alguns miutos por isso disparamos o processo em uma thread secundaria
    [NSThread detachNewThreadSelector:@selector(elaborarComposicao) toTarget:self withObject:nil];
}

-(void)elaborarComposicao{
    //localizar os arquivos de audio e video
    NSString *pathVideo = [[NSBundle mainBundle] pathForResource:@"filme" ofType:@"mov"];
    NSString *pathAudio = [[NSBundle mainBundle] pathForResource:@"Paradise" ofType:@"m4a"];
    
    
    AVURLAsset *urlAudio = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:pathAudio] options:nil];
    AVURLAsset *urlVideo = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:pathVideo] options:nil];
    
    //composition vazia
    AVMutableComposition *composicao = [AVMutableComposition composition];
    
    //trilha de audio
    AVMutableCompositionTrack *trilhaAudio = [composicao addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //quando nao quiser identificar a track passa o kCMPersistentTrackID_Invalid como parametro
    
    //criando o asset track
    AVAssetTrack *audioTrack = [[urlAudio tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    //inserttime range momento da muscia onde vou comecar a inserir na composicao
    //offtrack e a trilha da musica que queremos adicionar a essa trilha da composicao
    
    
    [trilhaAudio insertTimeRange:CMTimeRangeMake(kCMTimeZero, urlAudio.duration) ofTrack:audioTrack atTime:CMTimeMake(1,1) error:nil];
    
    //trilha de video
    AVMutableCompositionTrack *trilhaVideo = [composicao addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //neste momento que esrtou pegando apenas as imagens do video descartando o audio
    AVAssetTrack *videoTrack = [[urlVideo  tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    //cmtimemake -> divide o primeiro valor pelo segundo parater como resultado o tempo em segfundos para a insercao na composicao
    [trilhaVideo insertTimeRange:CMTimeRangeMake(kCMTimeZero, urlVideo.duration) ofTrack:videoTrack atTime:CMTimeMake(1, 1) error:nil];
    
    //efetivamente criar uma composicao e exportar para um arquivo de video
    
    //definir onde sera salvo o arquivo
    NSString *pathArquivoExportado = [NSHomeDirectory() stringByAppendingString:@"/Documents/videoExportado.mov"];
    
    //verificando se o arquivo ja existe na pasta indicada pela string acima
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathArquivoExportado])
    {
        //apagar o arquivo anterior antes de friar um novo
        [[NSFileManager defaultManager] removeItemAtPath:pathArquivoExportado error:nil];
    }
    
    //estou inicializando o exportador com a composicao que criamos
    AVAssetExportSession *exportador = [[AVAssetExportSession alloc] initWithAsset:composicao presetName:AVAssetExportPresetPassthrough];
    
    //passar para o exportador onde sera salvo o arquivo
    exportador.outputURL = [NSURL fileURLWithPath:pathArquivoExportado];
    
    //passar p/o exportador qual o formato do arquivo
    exportador.outputFileType = AVFileTypeQuickTimeMovie;
    
    [exportador exportAsynchronouslyWithCompletionHandler:^{
        //ao final do processo de criacao do video, vamos executá-lo
        
        // finished pathArquivoExportado
    }];
}

-(void)seekToTimeAndReplay:(CMTime)time
{
    [_player pause];
    _player.loopStartTime = time;
    [_player seekToTime:time];
    [_player play];
}

-(UIImage*)snapImage{
    SCRecordSessionSegment *segment = [_recordSession.segments firstObject];
    return segment.lastImage;
}

@end
