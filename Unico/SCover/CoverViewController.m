//
//  CoverViewController.m
//  StoryCam
//
//  Created by Ryan on 15/4/20.
//  Copyright (c) 2015年 Unico. All rights reserved.
//

#import "CoverViewController.h"
//#import "TopicEditViewController.h"
#import "LLCameraViewController.h"
#import "SDataCache.h"

//#import <SDWebImage/UIImageView+WebCache.h>

@interface CoverViewController ()<LLCameraControllerDelegate>{
    UIImageView *_coverImageView;
}

@end

@implementation CoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _coverImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    NSURL *url = [NSURL URLWithString:_data[@"cover_url"]];
    _coverImageView.clipsToBounds = YES;
    _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_coverImageView setImageWithURL:url];
    [self.view addSubview:_coverImageView];
    
    // 增加滑动手势，开始故事编辑
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpHandler:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeRecognizer];
    
    // swiper down
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownHandler:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftHandler:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightHandler:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
    [recognizer setMinimumPressDuration:0.5];
    [self.view addGestureRecognizer:recognizer];
    
    
    [self.navigationController setNavigationBarHidden:YES];
    
    NSArray *topic = [self topicData];
    if (topic && [topic count] > 0 ) {
//        [self showParticleEdit];
        UIButton *upButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = self.view.frame;
        frame.origin.y = frame.size.height - 40;
        frame.size.height = 40;
        upButton.frame = frame;
        [upButton addTarget:self action:@selector(onTouchSwipeUp:) forControlEvents:(UIControlEventTouchUpInside)];
        [upButton setImage:[UIImage imageNamed:@"swipe_up"] forState:UIControlStateNormal];
        [self.view addSubview:upButton];
        
        // 在自动跳转模式下，直接自动跳转
        if(_autoPop)[self onTouchSwipeUp:nil];
    }
    // TODO: 左右滑动时候，切换查看封面。
    // 覆盖在上面那个按钮上方，否则按不到测试按钮了。
    [self setupReadonlyButtons];
}

// 只读模式的按钮们
- (void)setupReadonlyButtons{
    // 测试暂时只显示自己
    NSDictionary *userInfo = [SDataCache sharedInstance].userInfo;
    if ([userInfo[@"id"] intValue] != [_data[@"user_id"] intValue]) {
        return;
    }
    
    float width = CGRectGetWidth(self.view.frame);
    float height = CGRectGetHeight(self.view.frame);
    float btnSize = 40;
    float btnInset = 10;
    UIButton *btn;
    // add back button
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setImage:[UIImage imageNamed:@"icon_navbar_back"] forState:UIControlStateNormal];
//    btn.frame = CGRectMake(btnInset, height - (btnSize + btnInset), btnSize, btnSize);
//    btn.backgroundColor = [UIColor blackColor];
//    btn.layer.cornerRadius = btnSize/2;
////    [btn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//    
//    btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
//    btn.frame = CGRectMake(width - (btnSize + btnInset)*3, height - (btnSize + btnInset), btnSize, btnSize);
//    btn.backgroundColor = [UIColor blackColor];
//    btn.layer.cornerRadius = btnSize/2;
//    //    [btn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//    
//    btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
//    btn.frame = CGRectMake(width - (btnSize + btnInset)*2, height - (btnSize + btnInset), btnSize, btnSize);
//    btn.backgroundColor = [UIColor blackColor];
//    btn.layer.cornerRadius = btnSize/2;
////    [btn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"…" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"icon_cover_text_cancel"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(width - (btnSize + btnInset), height - (btnSize + btnInset), btnSize, btnSize);
    btn.backgroundColor = [UIColor blackColor];
    btn.layer.cornerRadius = btnSize/2;
        [btn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)commentClick:(id)sender{
        
}

- (void)onTouchSwipeUp:(id)sender{
    [self showParticleEdit];
}

// 长按fork。
- (void)longPressHandler:(UILongPressGestureRecognizer*)recognizer{
    if( recognizer.state == UIGestureRecognizerStateBegan ){
        if ([[self childViewControllers] count]) {
            return;
        }
        
        if (_forkFunc) {
            _forkFunc(_data[@"cover_json"]);
        } else {
            LLCameraViewController* homeVC = [[LLCameraViewController alloc] initWithNibName:nil bundle:nil];
            homeVC.cameraDelegate = self;
            [homeVC loadTemplateJSON:_data[@"cover_json"]];
            [self pushController:homeVC animated:NO];
            
            // TODO : 修复这里，把相机的代理函数，写到SBaseController去。
        }
    }
}

- (void)swipeUpHandler:(UISwipeGestureRecognizer*)recognizer{
    NSLog(@"Swipe Up Here");
    NSArray *topic = [self topicData];
    if (topic && [topic count] > 0 ) {
        [self showParticleEdit];
    }
}

- (void)swipeDownHandler:(UISwipeGestureRecognizer*)recognizer{
//    来点动画效果。缩小到cell的frame
    
    CGRect newFrame = self.view.frame;
    newFrame.origin.y = newFrame.size.height/3;
    newFrame.size.height = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = newFrame;
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self back];
    }];

}


- (void) showParticleEdit {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray*)getArray:(NSString*)json
{
    
    NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    NSArray* info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return info;
}

-(NSMutableArray*)topicData{
    return [[self getArray:_data[@"text"]] mutableCopy];
}

- (void)back{
    [self popAnimated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
