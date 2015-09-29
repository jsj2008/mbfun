//
//  GuideViewController
//  MCPagerView
//
//  Created by wave on 15/9/17.
//
//

#import "GuideViewController.h"
#import "ParallaxView.h"
#import "WaveScrollView.h"

@interface GuideViewController ()
@property (nonatomic, strong) ParallaxView *parallaxView;
@property (weak, nonatomic) IBOutlet WaveScrollView *scrollView;
@property (weak, nonatomic) IBOutlet MCPagerView *pagerView;
@property (strong, nonatomic) UIButton *skipBtn;

- (void)skipAction:(id)sender;

@end

@implementation GuideViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];

    NSMutableArray *array = [@[] mutableCopy];
    NSString *str = [@"" mutableCopy];
    //第一页
    str = @"a1-01";
    [array addObject:str];
    str = @"a2-01";
    [array addObject:str];
    str = @"a3-01";
    [array addObject:str];
    str = @"a3-02";
    [array addObject:str];

    //第二页
    str = @"b1-01"; //4
    [array addObject:str];
    str = @"b2-01";
    [array addObject:str];
    str = @"b3-02";
    [array addObject:str];
    str = @"b3-03";
    [array addObject:str];
    str = @"b4-01";
    [array addObject:str];
    
    //第三页
    str = @"c1-01"; //9
    [array addObject:str];
    str = @"c2-01";
    [array addObject:str];
    str = @"c3-01";
    [array addObject:str];
    str = @"c4-01";
    [array addObject:str];
    str = @"c5-01";
    [array addObject:str];
    
    //第四页
    str = @"d1-01"; //14
    [array addObject:str];
    str = @"d2-01";
    [array addObject:str];
    str = @"d3-01";
    [array addObject:str];
    str = @"d4-01";
    [array addObject:str];
    _parallaxView = [[ParallaxView alloc] initWithFrame:CGRectZero andImageArray:array];

    [_scrollView addSubview:_parallaxView];
//    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 4, _scrollView.frame.size.height);
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 4, _scrollView.frame.size.height);
    
    _scrollView.delegate = self;
    
    // Pager
    [_pagerView setImage:[UIImage imageNamed:@"white"]
       highlightedImage:[UIImage imageNamed:@"black"]
                 forKey:@"a"];
    [_pagerView setImage:[UIImage imageNamed:@"white"]
       highlightedImage:[UIImage imageNamed:@"black"]
                 forKey:@"b"];
    [_pagerView setImage:[UIImage imageNamed:@"white"]
       highlightedImage:[UIImage imageNamed:@"black"]
                 forKey:@"c"];
    [_pagerView setImage:[UIImage imageNamed:@"white"]
       highlightedImage:[UIImage imageNamed:@"black"]
                 forKey:@"d"];
    
    [_pagerView setPattern:@"abcd"];
    
    _pagerView.delegate = self;
    
    _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _skipBtn.frame = CGRectMake(SCREEN_WIDTH - 50 - 10, 22, 50, 22);
    [_skipBtn setTitle:@"skip" forState:UIControlStateNormal];
    [_skipBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_skipBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_skipBtn addTarget:self action:@selector(skipAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_skipBtn];
    
    _skipBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _skipBtn.layer.borderWidth = 2;
    
    __weak __typeof(self) ws = self;
    _pagerView.SkipBlock = ^(){
        if (ws.skipBlock) {
            ws.skipBlock();
        }
    };
}

- (void)updatePager
{
    _pagerView.page = floorf(_scrollView.contentOffset.x / _scrollView.frame.size.width);
}

- (void)parallaxDidWork:(CGPoint) point {
    [_parallaxView updataUI:point];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self parallaxDidWork:scrollView.contentOffset];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePager];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self updatePager];
    }
}

#pragma mark - MCPagerViewDelegate
- (void)pageView:(MCPagerView *)pageView didUpdateToPage:(NSInteger)newPage
{
    CGPoint offset = CGPointMake(_scrollView.frame.size.width * _pagerView.page, 0);
    [_scrollView setContentOffset:offset animated:YES];
}

- (void)viewDidUnload
{
    _pagerView = nil;
    _scrollView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)skipAction:(id)sender {
    if (self.skipBlock) {
        self.skipBlock();
    }
}
@end
