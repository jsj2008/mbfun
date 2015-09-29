//
//  MCPagerView.m
//  MCPagerView
//
//  Created by wave on 15/9/17.
//
//

#import "MCPagerView.h"

#define ENTER_BUTTON_TAG 1002

@implementation MCPagerView {
    NSMutableDictionary *_images;
    NSMutableArray *_pageViews;
    
    UIView *_tempView;
    CGPoint _centerPoint;
}

@synthesize page = _page;
@synthesize pattern = _pattern;
@synthesize delegate = _delegate;

- (void)commonInit
{
    _page = 0;
    _pattern = @"";
    _images = [NSMutableDictionary dictionary];
    _pageViews = [NSMutableArray array];
    // UIImageView的父视图 为了使UIImageView能够居中排布
    _tempView = [UIView new];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)setPage:(NSInteger)page
{
    // Skip if delegate said "do not update"
    if ([_delegate respondsToSelector:@selector(pageView:shouldUpdateToPage:)] && ![_delegate pageView:self shouldUpdateToPage:page]) {
        return;
    }
    
    _page = page;
    [self setNeedsLayout];
    
    // Inform delegate of the update
    if ([_delegate respondsToSelector:@selector(pageView:didUpdateToPage:)]) {
        [_delegate pageView:self didUpdateToPage:page];
    }
    
    // Send update notification
    [[NSNotificationCenter defaultCenter] postNotificationName:MCPAGERVIEW_DID_UPDATE_NOTIFICATION object:self];
}

- (NSInteger)numberOfPages
{
    return _pattern.length;
}

- (void)tapped:(UITapGestureRecognizer *)recognizer
{
    self.page = [_pageViews indexOfObject:recognizer.view];
}

- (UIImageView *)imageViewForKey:(NSString *)key
{
    NSDictionary *imageData = [_images objectForKey:key];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[imageData objectForKey:@"normal"] highlightedImage:[imageData objectForKey:@"highlighted"]];
    /**
     *  10 * 10
     */
    CGRect rect = imageView.frame;
    rect.size = CGSizeMake(10, 10);
    imageView.frame = rect;
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [imageView addGestureRecognizer:tgr];
    
    return imageView;
}

- (void)layoutSubviews
{
    [_pageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        [view removeFromSuperview];
    }];
    [_pageViews removeAllObjects];
    //第四页出现 ”立即进入“按钮
    if (_page == _pattern.length - 1) {
        UIView *view = [_tempView viewWithTag:ENTER_BUTTON_TAG];
        if (!view) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = ENTER_BUTTON_TAG;
            [btn setBackgroundColor:[UIColor yellowColor]];
            btn.layer.borderColor = [UIColor blackColor].CGColor;
            btn.layer.borderWidth = 2;
            [btn setTitle:@"立即进入" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn addTarget:self action:@selector(enterClicked) forControlEvents:UIControlEventTouchUpInside];
            CGRect rect = _tempView.bounds;
            rect.size.height += 5;
            btn.frame = rect;
            [_tempView addSubview:btn];

            [_tempView setWidth:btn.width * 1.5];
            [_tempView setHeight:btn.height * 2];
            [_tempView setCenter:_centerPoint];
            [btn setWidth:btn.width * 1.5];
            [btn setHeight:btn.height * 2];
        }
        return;
    }else {
        UIView *view = [_tempView viewWithTag:ENTER_BUTTON_TAG];
        if (view) {
            [view removeFromSuperview];
        }
    }
    NSInteger pages = self.numberOfPages;
    CGFloat xOffset = 0;
    for (int i=0; i<pages; i++) {
        NSString *key = [_pattern substringWithRange:NSMakeRange(i, 1)];
        UIImageView *imageView = [self imageViewForKey:key];
        
        CGRect frame = imageView.frame;
        frame.origin.x = xOffset;
        imageView.frame = frame;
        imageView.highlighted = (i == self.page);
        
        [_tempView addSubview:imageView];
        [_pageViews addObject:imageView];
        
        CGRect rect = CGRectMake(0, 0, (frame.size.width + 5)* pages, imageView.frame.size.height);
        _tempView.frame = rect;
        [_tempView setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width / 2, 0)];
        [self addSubview:_tempView];
        
        xOffset = xOffset + frame.size.width + 5;
        _centerPoint = _tempView.center;
    }
}

- (void)setImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage forKey:(NSString *)key
{
    NSDictionary *imageData = [NSDictionary dictionaryWithObjectsAndKeys:image, @"normal", highlightedImage, @"highlighted", nil];
    [_images setObject:imageData forKey:key];
    [self setNeedsLayout];
}

#pragma mark - 进入按钮事件
- (void)enterClicked {
    NSLog(@"立即进入");
    if (self.SkipBlock) {
        self.SkipBlock();
    }
}

@end
