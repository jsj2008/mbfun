//
//  ViewController.m
//  VideoCover
//
//  Created by Bi Chen Ka Kit on 2/6/14.
//  Copyright (c) 2014年 biworks. All rights reserved.
//

#import "SVideoWelcomeController.h"
#import <AVFoundation/AVFoundation.h>

@interface SVideoWelcomeController (){
    UIImageView *snapShotView;
    UIButton *playButton;
    AVPlayerItem *playerItem;
}

@property (nonatomic, strong) AVPlayer *avplayer;
@property (strong, nonatomic) IBOutlet UIView *movieView;
@property (strong, nonatomic) IBOutlet UIView *gradientView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation SVideoWelcomeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    for (UIView *subView in [self.view subviews])
    {
        subView.backgroundColor = [UIColor clearColor];
    }
    
    
    
    //Not affecting background music playing
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];

    // TODO: 这里还没有完成，需要默认显示视频截图（本地也要有placeholder）并且点击播放后，显示视频
    // 
    // 这个也配置到网络Config里。因为国际歌可能有政策风险，需要随时切换。
    
    // 创建一个视频截图
    snapShotView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //[snapShotView sd_setImageWithURL:[NSURL URLWithString:LAUNCH_VIDEO_SNAP] placeholderImage:[UIImage imageNamed:@"splash_welcome_bg"]];
    [snapShotView sd_setImageWithURL:[NSURL URLWithString:LAUNCH_VIDEO_SNAP] isLoadThumbnail:NO placeholderImage:[UIImage imageNamed:@"splash_welcome_bg"]];
    [self.view addSubview:snapShotView];
    
    // 视频的播放按钮，因为层次关系，所以在这里处理？？后面最好在Video那个VC组件里完成
    // 耦合性太强了
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat flo = 130/2;
    playButton.frame = CGRectMake((UI_SCREEN_WIDTH - flo)/2, 300, flo, flo);
    [playButton  setImage:[UIImage imageNamed:@"Unico/btn_video_play"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(loadVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
    //playButton.layer.borderColor = [UIColor blackColor].CGColor;
    //playButton.layer.borderWidth = 2;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadVideo) name:@"WELCOME_VIDEO_PLAY" object:nil];
}


- (void)loadVideo{
    // 解决重复Load的问题。
    if (playButton.hidden) {
        return;
    }
    playButton.hidden = YES;
    
//    [snapShotView removeFromSuperview];
    //Set up player
    NSURL *movieURL = [NSURL URLWithString:LAUNCH_VIDEO];
//    movieURL = [NSURL URLWithString:@"https://t.alipayobjects.com/images/T1T78eXapfXXXXXXXX.mp4"];
    AVAsset *avAsset = [AVAsset assetWithURL:movieURL];
    
    
    
    playerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
    
    self.avplayer = [[AVPlayer alloc]initWithPlayerItem:playerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    [avPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [avPlayerLayer setFrame:[[UIScreen mainScreen] bounds]];
    [self.movieView.layer addSublayer:avPlayerLayer];
    
    //Config player
    [self.avplayer seekToTime:kCMTimeZero];
    // 音量
    //    [self.avplayer setMuted:YES];
    [self.avplayer setVolume:0.1f];
    [self.avplayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    
//    [self.avplayer play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avplayer currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerStartPlaying)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //Config dark gradient view
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [[UIScreen mainScreen] bounds];
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x030303) CGColor], (id)[[UIColor clearColor] CGColor], (id)[UIColorFromRGB(0x030303) CGColor],nil];
    [self.gradientView.layer insertSublayer:gradient atIndex:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.avplayer pause];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.avplayer play];
}

- (void)dealloc
{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)playerStartPlaying
{
    [self.avplayer play];
}


- (IBAction)buttonPressed:(id)sender {
    NSLog(@"Press");
    if (self.parentViewController.childViewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 处理视频加载情况
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            [snapShotView removeFromSuperview];
            [self.avplayer play];
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        
    }
}


@end
