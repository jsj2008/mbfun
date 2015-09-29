//
//  ViewController.m
//
//
//  TODO：把贴纸的类整合进来。
// 

#import "SImageCropController.h"
#import "SStickerEditController.h"

#import "SUtilityTool.h"


@interface SImageCropController ()<UIScrollViewDelegate>
{
    NSMutableArray *cropSizeBtnList;
}

@property (nonatomic) UIView* renderView;
@property (nonatomic) UIView* cropMasker;
@property (nonatomic) UIImageView* imageView;
@property (nonatomic) UIImageView* clipImageView;
@property (nonatomic) UIScrollView* scrollView;


@end

@implementation SImageCropController
#pragma mark - static value


- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    
    // 对UI用的。
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_masker_9_16"]];
    view.contentMode = UIViewContentModeScaleAspectFill;
    view.frame = self.view.frame;
    [self.view addSubview:view];

    [self createImageView];

    [self refreshImageView];

    [self updateCropMasker:0];
    
    UIView *navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    //navigationBarView.contentMode = UIViewContentModeScaleToFill;
    navigationBarView.backgroundColor = [UIColor blackColor];
    navigationBarView.alpha = 0.4;
    [self.view addSubview:navigationBarView];
    
    [self createButtons];
    

    [self.navigationController setNavigationBarHidden:YES];
}

-(void)updateCropMasker:(NSInteger)type {
    CGSize size = self.view.bounds.size;
    if (!_cropMasker) {
        _cropMasker = [UIView new];
        //_cropMasker.alpha = 0.3;
        //_cropMasker.backgroundColor = [UIColor redColor];
        _cropMasker.userInteractionEnabled = NO;
        [self.view addSubview:_cropMasker];
    }
    
    //NSLog(@"size.width = %f, size.height = %f", size.width, size.height);
    
    //self.view.layer.borderColor = [UIColor greenColor].CGColor;
    //self.view.layer.borderWidth = 2;
    
    CGFloat cropMaskerWidth = 0.0;
    CGFloat cropMaskerHeight = 0.0;
    
    switch (type) {
        case 0:
            cropMaskerWidth = size.width;
            cropMaskerHeight = size.width;
            break;
        case 1:
            
            cropMaskerWidth = size.width;
            cropMaskerHeight = size.width/3.0*4.0;
            break;
        case 2:
            
            cropMaskerWidth = size.width;
            cropMaskerHeight = size.width/9.0*16.0;
            break;
        default:
            break;
    }
    
    _cropMasker.frame = CGRectMake(0, (size.height-cropMaskerHeight)/2.0, cropMaskerWidth, cropMaskerHeight);
    _scrollView.frame = _cropMasker.frame;
    
    
    if (self.imageView.frame.size.height < _scrollView.frame.size.height
        && self.imageView.frame.size.width < _scrollView.frame.size.width)//图片的长宽都比滚动视图小，则把图片放滚动视图中间
    {
        self.imageView.center = CGPointMake(_scrollView.frame.size.width/2.0, _scrollView.frame.size.height/2.0);
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
        _scrollView.contentOffset = CGPointMake(0, 0);
    }
    
    if (self.imageView.frame.size.height < _scrollView.frame.size.height
             && self.imageView.frame.size.width >= _scrollView.frame.size.width)//图片比较短、但很宽
    {
        self.imageView.center = CGPointMake(self.imageView.center.x, _scrollView.frame.size.height/2.0);
        _scrollView.contentSize = CGSizeMake(self.imageView.frame.size.width, _scrollView.frame.size.height);
        _scrollView.contentOffset = CGPointMake((self.imageView.frame.size.width - _scrollView.frame.size.width)/2.0, 0);
    }
    
    if (self.imageView.frame.size.height >= _scrollView.frame.size.height
             && self.imageView.frame.size.width < _scrollView.frame.size.width)//图片比较高、但很窄
    {
        self.imageView.center = CGPointMake(_scrollView.frame.size.width/2.0, self.imageView.center.y);
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, self.imageView.frame.size.height);
        _scrollView.contentOffset = CGPointMake(0, (self.imageView.frame.size.height - _scrollView.frame.size.height)/2.0);
    }
    
    if (self.imageView.frame.size.height >= _scrollView.frame.size.height
        && self.imageView.frame.size.width >= _scrollView.frame.size.width) //图片比较高、也比较宽
    {
        self.imageView.frame = CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height);
        _scrollView.contentSize = CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height);
        _scrollView.contentOffset = CGPointMake((self.imageView.frame.size.width - _scrollView.frame.size.width)/2.0, (self.imageView.frame.size.height - _scrollView.frame.size.height)/2.0);
    }
}

-(void)createButtons{
    cropSizeBtnList = [NSMutableArray array];
    CGSize size = self.view.frame.size;
    // Top
    
    UILabel *title = [UILabel new];
    title.font = FONT_T2;
    title.text = @"裁切";
    title.textColor = COLOR_C3;
    [title sizeToFit];
    title.center = CGPointMake(size.width/2, 42);
    [self.view addSubview:title];
    
    UIButton *nextBtn = [UIButton new];
    nextBtn.titleLabel.font = FONT_t2;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:COLOR_C3 forState:UIControlStateNormal];
    nextBtn.bounds = CGRectMake(0, 0, 100, 50);
    nextBtn.center = CGPointMake(size.width/6*5+25, 42);
    [nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    UIButton *preBtn = [UIButton new];
    [preBtn setImage:[UIImage imageNamed:@"Unico/camera_navbar_back"] forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    preBtn.frame = CGRectMake(7, 28, 30, 30);
    //preBtn.center = CGPointMake(40, 50);
    [preBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:preBtn];
    
    // Button
    UIButton *btn = [UIButton new];
    btn.bounds = CGRectMake(0, 0, 100, 100);
    btn.center = CGPointMake(size.width/4, size.height - 50);
    [btn setImage:[UIImage imageNamed:@"Unico/camera_crop_9_16"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Unico/camera_crop_9_16_h"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(changeCropSize:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 2;
    [cropSizeBtnList addObject:btn];
    [self.view addSubview:btn];
    
    btn = [UIButton new];
    btn.bounds = CGRectMake(0, 0, 100, 100);
    btn.center = CGPointMake(size.width/4*2, size.height - 50);
    [btn setImage:[UIImage imageNamed:@"Unico/camera_crop_3_4"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Unico/camera_crop_3_4_h"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(changeCropSize:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 1;
    [cropSizeBtnList addObject:btn];
    [self.view addSubview:btn];
    
    btn = [UIButton new];
    btn.bounds = CGRectMake(0, 0, 100, 100);
    btn.center = CGPointMake(size.width/4*3, size.height - 50);
    [btn setImage:[UIImage imageNamed:@"Unico/camera_crop_1_1"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Unico/camera_crop_1_1_h"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(changeCropSize:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 0;
    [cropSizeBtnList addObject:btn];
    [self.view addSubview:btn];
    
    
    [self changeCropSize:btn];//默认1：1
}

-(void)next:(UIButton*)sender{
    
    UIImage *image = [self snapshot2:_renderView];
    
    SStickerEditController *vc = [[SStickerEditController alloc] initWithImage:image];
    [self pushController:vc animated:YES];
}

-(void)changeCropSize:(UIButton*)sender{
    for (UIButton* btn in cropSizeBtnList) {
        btn.selected = NO;
    }
    sender.selected = YES;
    [self updateCropMasker:sender.tag];
}

// 背景图，TODO 换成 SCFilterSelectorView
-(void)createImageView
{
    CGRect rect = self.view.frame;
    self.imageView = [[UIImageView alloc] initWithImage:_image];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self.scrollView addSubview:_imageView];
    [self.scrollView setBounces:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    

    self.renderView = [[UIView alloc] initWithFrame:rect];
    [self.renderView setBackgroundColor:[UIColor clearColor]];
    [self.renderView addSubview:self.scrollView];
    [self.view addSubview:self.renderView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if ([self.view.gestureRecognizers count] > 0)
    {
        for(UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers)
        {
            if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)gestureRecognizer;
            }
        }
    }
    if (screenEdgePanGestureRecognizer != nil)
    {
        [self.view removeGestureRecognizer:screenEdgePanGestureRecognizer];//此处禁止屏幕边界右滑时返回上一级界面的手势
    }

}



// 这里实际生效，隐藏navbar
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

// 获得标签信息json
- (void)back
{
    [self popAnimated:YES];
}


- (UIImage*)snapshot
{
    
    UIGraphicsBeginImageContextWithOptions(_scrollView.bounds.size, YES, 0);
    // 下面那个会让view交互丢失。
    //    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    [_scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 根据UI Image裁剪，不能简单的判断不透明，因为装饰物可能超出区域。
    return image;
}

- (UIImage*)snapshot2:(UIView*)view
{
    
    CGSize rect = self.scrollView.frame.size;
    CGSize screenRect = view.frame.size;
    // fix size
    if (rect.width > screenRect.width) {
        rect.width = screenRect.width;
    }
    if (rect.height > screenRect.height) {
        rect.height = screenRect.height;
    }
    
    CGRect frame = self.scrollView.frame;
    if (frame.origin.x < 0) {
        frame.origin.x = 0;
    }
    if (frame.origin.y < 0) {
        frame.origin.y = 0;
    }
    if (frame.size.width + frame.origin.x > screenRect.width) {
        frame.size.width = screenRect.width - frame.origin.x;
    }
    if (frame.size.height + frame.origin.y > screenRect.height) {
        frame.size.height = screenRect.height - frame.origin.y;
    }
    
    UIGraphicsBeginImageContextWithOptions(rect, YES, 0);
    // 下面那个会让view交互丢失。
    //    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), CGRectGetMinX(frame), -CGRectGetMinY(frame));
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 根据UI Image裁剪，不能简单的判断不透明，因为装饰物可能超出区域。
    return image;
}


#pragma mark - scroll image 针对背景图片的缩放等。
- (void)refreshImageView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _imageView.image = _image;
        
        [self resetImageViewFrame];
        [self resetZoomScaleWithAnimate:NO];
    });
}
- (void)resetImageViewFrame{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rct = _imageView.frame;
        rct.size = CGSizeMake(_scrollView.zoomScale*_imageView.image.size.width, _scrollView.zoomScale*_imageView.image.size.height);
        _imageView.frame = rct;
    });
}
- (void)resetZoomScaleWithAnimate:(BOOL)animated{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat Rw = _scrollView.frame.size.width/_imageView.image.size.width;
        CGFloat Rh = _scrollView.frame.size.height/_imageView.image.size.height;
        CGFloat ratio = MAX(Rw, Rh);
        
        _scrollView.contentSize = _imageView.frame.size;
        _scrollView.minimumZoomScale = ratio;
        _scrollView.maximumZoomScale = MAX(ratio/240, 1/ratio);
        
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
    });
}

#pragma mark - ScrollView delegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView{
    return _imageView;
}
- (void)scrollViewDidZoom:(UIScrollView*)scrollView{
    CGFloat Ws = _scrollView.frame.size.width;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _image.size.width * _scrollView.zoomScale;
    CGFloat H = _image.size.height * _scrollView.zoomScale;

    CGRect rct = _imageView.frame;
    rct.origin.x = MAX((Ws - W) / 2, 0);
    rct.origin.y = MAX((Hs - H) / 2, 0);
   _imageView.frame = rct;
}

#pragma mark - no status bar

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    
    NSLog(@"Recorder Recieve memory warning");
}

@end
