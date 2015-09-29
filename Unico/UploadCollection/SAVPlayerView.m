//
//  SAVPlayerView.m
//  Wefafa
//
//  Created by chencheng on 15/8/26.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SAVPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SCPlayer.h"


@interface SAVPlayerView()
{
    AVPlayer *_player;
    AVAsset *_avAsset;
    AVPlayerLayer *_playerLayer;
    
    float _volume;
    BOOL _autoSetVolumeWithSystemVolume;
    
    float _startTime;//选取器的开始时间
    float _endTime;//选取器的结束时间
    
    UITapGestureRecognizer *_tapGestureRecognizer;
    
    BOOL _waitToPlay;
}

@end

@implementation SAVPlayerView


- (void)setVolume:(float)volume
{
    _volume = volume;
    _player.volume = volume;
}

- (void)setLoopEnabled:(BOOL)loopEnabled
{
    _loopEnabled = loopEnabled;
    
    _player.actionAtItemEnd = loopEnabled ? AVPlayerActionAtItemEndNone : AVPlayerActionAtItemEndPause;
}

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        //self.backgroundColor = [UIColor whiteColor];
        
        self.volume = 0;//默认不播放声音
        self.autoSetVolumeWithSystemVolume = NO;
        
        self.loopEnabled = YES;
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemVolumeDidChange:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        //self.backgroundColor = [UIColor whiteColor];
        
        self.volume = 0;//默认不播放声音
        self.autoSetVolumeWithSystemVolume = NO;
        
        self.loopEnabled = YES;
        
    
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemVolumeDidChange:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    }
    
    return self;
}

- (void)setAsset:(AVAsset *)asset
{
    if (_playerLayer != nil)
    {
        [_playerLayer removeFromSuperlayer];
    }
    
    _avAsset = asset;
    
    [_player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
    [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    _player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithAsset:asset]];
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews])
    {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"])
        {
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    float systemVolume = volumeViewSlider.value;
    
    if (self.autoSetVolumeWithSystemVolume)
    {
        _player.volume = systemVolume;
    }
    else
    {
        _player.volume = _volume;
    }
    
    
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    _playerLayer.frame = self.bounds;
    
    _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    _startTime = 0;
    
    _endTime = 10;
    
    [self.layer addSublayer:_playerLayer];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStalled:) name:AVPlayerItemPlaybackStalledNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [_player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [_player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)playbackStalled:(NSNotification *)notification
{
    NSLog(@"playbackStalled notification = %@", notification);
}


- (void)playToEndTime:(NSNotification *)notification
{
    NSLog(@"playToEndTime notification = %@", notification);
    if (_loopEnabled)
    {
        [self seekToTime:_startTime endTime:_endTime];
        if(![self isPlaying] && _waitToPlay)
        {
            [self play];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"])
    {
        if ([playerItem status] == AVPlayerStatusReadyToPlay)
        {
            NSLog(@"observeValueForKeyPath AVPlayerStatusReadyToPlay");
            if(![self isPlaying] && _waitToPlay)
            {
                [self play];
            }
        }
        else if ([playerItem status] == AVPlayerStatusFailed)
        {
            NSLog(@"observeValueForKeyPath AVPlayerStatusFailed");
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        if(![self isPlaying] && _waitToPlay)
        {
            [self play];
        }
    }
}


- (void)setURL:(NSURL *)url
{
    AVAsset *asset = [AVAsset assetWithURL:url];
    [self setAsset:asset];
}

- (void)setUrlForString:(NSString *)urlString
{
    [self setURL:[NSURL URLWithString:urlString]];
}


- (void)setTapForPlayOrPause:(BOOL)tapForPlayOrPause
{
    _tapForPlayOrPause = tapForPlayOrPause;
    if (tapForPlayOrPause)
    {
        if (_tapGestureRecognizer == nil)
        {
            _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        }
        
        if (self.gestureRecognizers == nil)
        {
            self.gestureRecognizers = @[_tapGestureRecognizer];
        }
        else if ([self.gestureRecognizers count] == 0)
        {
            self.gestureRecognizers = @[_tapGestureRecognizer];
        }
        else
        {
            NSArray *gestureRecognizers = self.gestureRecognizers;
            
            for (UIGestureRecognizer *gestureRecognizer in gestureRecognizers)
            {
                if (gestureRecognizer == _tapGestureRecognizer)
                {
                    return;
                }
            }
            
            [self addGestureRecognizer:_tapGestureRecognizer];
        }
    }
    else
    {
        if ([self.gestureRecognizers count] > 0)
        {
            NSMutableArray *gestureRecognizersMutableArray = [self.gestureRecognizers mutableCopy];
            [gestureRecognizersMutableArray removeObject:_tapGestureRecognizer];
            
            self.gestureRecognizers = [gestureRecognizersMutableArray copy];
        }
    }
}

- (id)initWithAsset:(AVAsset *)asset
{
    self = [super init];
    if (self != nil)
    {
        [self setAsset:asset];
        
        self.autoSetVolumeWithSystemVolume = YES;
        
        self.tapForPlayOrPause = YES;
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemVolumeDidChange:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    }
    return self;
}


- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self != nil)
    {
        AVAsset *asset = [AVAsset assetWithURL:url];
        [self setAsset:asset];
        
        self.volume = 0;//默认不播放声音
        self.autoSetVolumeWithSystemVolume = NO;
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemVolumeDidChange:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    }
    return self;

}

- (void)dealloc
{
    NSLog(@"SAVPlayerView dealloc");

    [_player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
    [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
}

- (void)systemVolumeDidChange:(NSNotification *)notification
{
    NSString *volume = notification.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"];
    
    if (self.autoSetVolumeWithSystemVolume)
    {
        _player.volume = [volume floatValue];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _playerLayer.frame = self.bounds;
}

- (BOOL)isPlaying
{
    return (_player.rate > 0);
}

- (UIImage *)currentFrame
{
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:_avAsset];
    
    NSError *error=nil;
    CMTime actualTime;
    
    UIImage *image= nil;
    
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:_player.currentTime actualTime:&actualTime error:&error];
    if(error == nil)
    {
        CMTimeShow(actualTime);
        image=[UIImage imageWithCGImage:cgImage];
        
        CGImageRelease(cgImage);
    }

    return image;
}

- (void)play
{
    _waitToPlay = YES;
    [_player play];
    
    NSLog(@"_player = %@ play", _player);
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer)userInfo:nil repeats:NO];
}

- (void)pause
{
    _waitToPlay = NO;
    [_player pause];
    
    NSLog(@"_player = %@ pause", _player);
}

- (void)tap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (self.tapForPlayOrPause)
    {
        if ([self isPlaying])
        {
            [self pause];
        }
        else
        {
            [self play];
        }
    }
}

- (void)timer
{
    Float64 currentSec = CMTimeGetSeconds(_player.currentItem.currentTime);
    
    if (currentSec >= _endTime)
    {
        [_player seekToTime:CMTimeMake(_startTime * _avAsset.duration.timescale, _avAsset.duration.timescale)];
    }
    
    if ([self isPlaying])
    {
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer)userInfo:nil repeats:NO];
    }
}

- (void)seekToTime:(float)startTime endTime:(float)endTime
{
    _startTime = startTime;
    _endTime = endTime;
    
    [_player seekToTime:CMTimeMake(_startTime * _avAsset.duration.timescale, _avAsset.duration.timescale)];
}

@end
