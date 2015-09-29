//
//  支持视频的首次启动介绍。
//  TODO：传入front和bg view list
//
/*
 // Added Introduction View Controller
 NSArray *coverImageNames = @[@"img_index_01txt", @"img_index_02txt", @"img_index_03txt"];
 NSArray *backgroundImageNames = @[@"img_index_01bg", @"img_index_02bg", @"img_index_03bg"];
 self.introductionView = [[SIntroController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames];
 
 // Example 2
     UIButton *enterButton = [UIButton new];
     [enterButton setBackgroundImage:[UIImage imageNamed:@"bg_bar"] forState:UIControlStateNormal];
     self.introductionView = [[SIntroController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames button:enterButton];
 
 [self.window addSubview:self.introductionView.view];
 
 __weak AppDelegate *weakSelf = self;
 self.introductionView.didSelectedEnter = ^() {
 [weakSelf.introductionView.view removeFromSuperview];
 weakSelf.introductionView = nil;
 
 // enter main view , write your code ...
 //        ViewController *mainVC = [[ViewController alloc] init];
 //        weakSelf.window.rootViewController = mainVC;
 
 };
 */

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

typedef void (^DidSelectedEnter)();

@interface SIntroController : UIViewController
@property (nonatomic, assign) BOOL first;
@property (nonatomic, strong) UIScrollView *pagingScrollView;
@property (nonatomic, strong) UIButton *enterButton;

@property (nonatomic, copy) DidSelectedEnter didSelectedEnter;

@property(strong, readwrite, nonatomic)MPMoviePlayerController *moviePlayerController;

/**
 @[@"image1", @"image2"]
 */
@property (nonatomic, strong) NSArray *backgroundImageNames;

/**
 @[@"coverImage1", @"coverImage2"]
 */
@property (nonatomic, strong) NSArray *coverImageNames;


- (id)initWithCoverImageNames:(NSArray*)coverNames backgroundImageNames:(NSArray*)bgNames;


- (id)initWithCoverImageNames:(NSArray*)coverNames backgroundImageNames:(NSArray*)bgNames button:(UIButton*)button;

@end
