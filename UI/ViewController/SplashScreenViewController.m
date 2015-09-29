//
//  SplashScreenViewController.m
//  splash
//
//  Created by mac on 14-12-19.
//  Copyright (c) 2014年 FafaTimes. All rights reserved.
//

#import "SplashScreenViewController.h"

//@interface SplashScreenViewController ()
//
//@end
//
//@implementation SplashScreenViewController
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//@end



#import <QuartzCore/QuartzCore.h>
#define DURATION 5

NSString *const PRPSplashScreenFadeAnimation = @"SplashScreenFadeAnimation";

@interface SplashScreenViewController ()
- (void)animate;
@end

@implementation SplashScreenViewController

@synthesize splashImage;
@synthesize maskImage;
@synthesize delegate;
@synthesize transition;
@synthesize maskImageName;
@synthesize delay;
@synthesize anchor;

- (void)showInWindow:(UIWindow *)window {
    [window addSubview:self.view];
}

- (void)viewDidLoad {
    self.view.layer.contentsScale = [[UIScreen mainScreen] scale];
    self.view.layer.contents = (id)self.splashImage.CGImage;
    self.view.contentMode =UIViewContentModeScaleAspectFill;
}

- (UIImage *)splashImage {
    if (splashImage == nil) {
        splashImage = [UIImage imageNamed:@"Default"];
    }
    return splashImage;
}

- (UIImage *)maskImage {
//    if (maskImage != nil) [maskImage release];
    NSString *defaultPath = [[NSBundle mainBundle]
                             pathForResource:self.maskImageName
                             ofType:@"png"];
    maskImage = [[UIImage alloc]
                 initWithContentsOfFile:defaultPath];
    return maskImage;
}

- (void)setMaskLayerwithanchor {
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.anchorPoint = self.anchor;
    maskLayer.frame = self.view.superview.frame;
    maskLayer.contents = (id)self.maskImage.CGImage;
    self.view.layer.mask = maskLayer;
}

- (void)viewDidAppear:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(splashScreenDidAppear:)]) {
        [self.delegate splashScreenDidAppear:self];
    }
    switch (self.transition) {
        case CircleFromCenter:
            self.maskImageName = @"Default";
            self.anchor = CGPointMake(0.5, 0.5);
            break;
        case ClearFromCenter:
            self.maskImageName = @"Default";
            self.anchor = CGPointMake(0.5, 0.5);
            break;
        case ClearFromLeft:
            self.maskImageName = @"Default";
            self.anchor = CGPointMake(0.0, 0.5);
            break;
        case ClearFromRight:
            self.maskImageName = @"RightStripMask";
            self.anchor = CGPointMake(1.0, 0.5);
            break;
        case ClearFromTop:
            self.maskImageName = @"TopStripMask";
            self.anchor = CGPointMake(0.5, 0.0);
            break;
        case ClearFromBottom:
            self.maskImageName = @"BottomStripMask";
            self.anchor = CGPointMake(0.5, 1.0);
            break;
        default:
            return;
    }
    [self performSelector:@selector(animate)
               withObject:nil
               afterDelay:self.delay];
}

- (void)animate {
    if ([self.delegate respondsToSelector:@selector(splashScreenWillDisappear:)]) {
        [self.delegate splashScreenWillDisappear:self];
    }
    
    [self setMaskLayerwithanchor];
    
    CABasicAnimation *anim = [CABasicAnimation
                              animationWithKeyPath:@"transform.scale"];
    anim.duration = DURATION;
    anim.toValue = [NSNumber numberWithInt:self.view.bounds.size.height/8];
    anim.fillMode = kCAFillModeBoth;
    anim.removedOnCompletion = NO;
    anim.delegate = self;
    [self.view.layer.mask addAnimation:anim forKey:@"scale" ];
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    
    self.view.layer.mask = nil;
    [self.view removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(splashScreenDidDisappear:)]) {
        [self.delegate splashScreenDidDisappear:self];
    }
}


- (void)dealloc {
//    [splashImage release], splashImage = nil;
//    [maskImage release], maskImage = nil;
//    [maskImageName release], maskImageName = nil;
//    [super dealloc];

    splashImage = nil;
    maskImage = nil;
    maskImageName = nil;
}

@end