//
//  SPublishedController.m
//  StoryCam
//
//  Created by Ryan on 15/4/22.
//  Copyright (c) 2015年 Unico. All rights reserved.
//

#import "SPublishedController.h"
#import "CoverEditViewController.h"
#import "SUtilityTool.h"
#import "GCPlaceholderTextView.h"
#import "SDataCache.h"
#import "STagEditController.h"

#import "JCRBlurView.h"
#import "CoverStickerView.h"

#define PUBLISH_PLACE_HOLDER @"有范!"

@interface STagScrollView : UIScrollView
@property(nonatomic,strong)NSArray *selectTagArray;
@end

@implementation STagScrollView{
    NSMutableArray *uploadArray;
    NSArray *tagArray;
}

- (id)initWithFrame:(CGRect)frame withTagArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:COLOR_C4];
        tagArray = [NSArray arrayWithArray:array];
        uploadArray = [[NSMutableArray alloc] initWithCapacity:0];
        [self setTagArray:tagArray];
    }
    return self;
}

- (void)setTagArray:(NSArray *)array
{
    if (array == 0) {
        return;
    }
    CGFloat xPoint = 10;
    CGFloat yPoint = 0;
    for (int i =0; i < array.count; i ++) {
        NSString *nameStr = [array objectAtIndex:i];
        CGSize aSize = [nameStr sizeWithAttributes:[NSDictionary dictionaryWithObject:FONT_t5 forKey:NSFontAttributeName]];
        if ((UI_SCREEN_WIDTH -(xPoint + 6 + aSize.width + 10)) < 10) {
            xPoint = 10;
            yPoint += 40;
        }
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn.titleLabel setFont:FONT_t5];
        [btn.layer setCornerRadius:5.0];
        [btn.layer setBorderColor:COLOR_C9.CGColor];
        [btn.layer setBorderWidth:1.0];
        [btn setTag:i];
        [btn setSelected:YES];
        [btn setTitle:nameStr forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_C6 forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addTagWithIndex:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(xPoint, yPoint, 16 + aSize.width, 30)];
        [self addSubview:btn];
        xPoint += (btn.frame.size.width + 6);
    }
    [self setContentSize:CGSizeMake(UI_SCREEN_WIDTH, yPoint+40)];
}

- (void)addTagWithIndex:(UIButton *)btn
{
    [btn setSelected:!btn.isSelected];
    if (!btn.isSelected) {
        [btn setBackgroundColor:[UIColor blackColor]];
        [uploadArray addObject:btn.titleLabel.text];
    }else{
        [btn setBackgroundColor:[UIColor whiteColor]];
        for(NSString *str in uploadArray){
            if ([str isEqualToString:btn.titleLabel.text]) {
                [uploadArray removeObject:str];
                break;
            }
        }
    }
    
}

- (NSArray *)selectTagArray
{
    return uploadArray;
}

@end



@interface Preview : UIView
{
    UIImageView  *_imageView;
    
    SCPlayer     *_player;
    AVPlayerLayer *_playerLayer;
    
    UIImageView  *_stickImageView;
    
    NSArray *_tabInfoArray;
}

@property(strong, readonly, nonatomic)SCPlayer *player;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image stickImage:(UIImage *)stickImage tabInfoArray:(NSArray *)tabInfoArray;

- (id)initWithFrame:(CGRect)frame recordSession:(SCRecordSession*)recordSession stickImage:(UIImage *)stickImage tabInfoArray:(NSArray *)tabInfoArray;

@end


@implementation Preview

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image stickImage:(UIImage *)stickImage tabInfoArray:(NSArray *)tabInfoArray
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.layer.masksToBounds = YES;
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.image = image;
        [self addSubview:_imageView];
        
        _stickImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _stickImageView.image = stickImage;
        [self addSubview:_stickImageView];
        
        _tabInfoArray = tabInfoArray;
        
        for (NSDictionary *tabInfo in _tabInfoArray)
        {
            CoverStickerView* stickerView = [[CoverStickerView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
            
            stickerView.userInteractionEnabled = NO;
            
            UIImageView* imageView = [[UIImageView alloc] initWithImage:nil];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [stickerView setContentView:imageView];
            
            NSDictionary *attributes = [tabInfo objectForKey:@"attributes"];
            int type = [[attributes objectForKey:@"type"] intValue];
            
            stickerView.type = type;
            
            NSString *text = [tabInfo objectForKey:@"text"];
            
            float x =  [[tabInfo objectForKey:@"x"] floatValue] * self.frame.size.width;
            float y =  [[tabInfo objectForKey:@"y"] floatValue] * self.frame.size.height;
            
            
            
            [stickerView setTagName:text withKey:@"test" withType:CoverTagTypeItem];
            
            int flip = [[attributes objectForKey:@"flip"] intValue];
            if (flip == 0)
            {
                stickerView.flip = NO;
                x = x - 20;
            }
            else
            {
                stickerView.flip = YES;
                x = x + 20;
            }
            
            [stickerView setOrigin:CGPointMake(x, y)];

            [self addSubview:stickerView];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame recordSession:(SCRecordSession*)recordSession stickImage:(UIImage *)stickImage tabInfoArray:(NSArray *)tabInfoArray
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.layer.masksToBounds = YES;
        
        
        _player = [SCPlayer player];
        [_player setItemByAsset:recordSession.assetRepresentingSegments];
        _player.loopEnabled = YES;
        
        [_player setVolume:0];
        
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.frame = self.layer.bounds;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        
        [self.layer addSublayer:_playerLayer];
        
        
        _stickImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _stickImageView.image = stickImage;
        [self addSubview:_stickImageView];
        
        _tabInfoArray = tabInfoArray;
        
        for (NSDictionary *tabInfo in _tabInfoArray)
        {
            CoverStickerView* stickerView = [[CoverStickerView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
            
            stickerView.userInteractionEnabled = NO;
            
            UIImageView* imageView = [[UIImageView alloc] initWithImage:nil];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [stickerView setContentView:imageView];
            
            NSDictionary *attributes = [tabInfo objectForKey:@"attributes"];
            int type = [[attributes objectForKey:@"type"] intValue];
            
            stickerView.type = type;
            
            NSString *text = [tabInfo objectForKey:@"text"];
            
            float x =  [[tabInfo objectForKey:@"x"] floatValue] * self.frame.size.width;
            float y =  [[tabInfo objectForKey:@"y"] floatValue] * self.frame.size.height;
            
            
            
            [stickerView setTagName:text withKey:@"test" withType:CoverTagTypeItem];
            
            int flip = [[attributes objectForKey:@"flip"] intValue];
            if (flip == 0)
            {
                stickerView.flip = NO;
                x = x - 20;
            }
            else
            {
                stickerView.flip = YES;
                x = x + 20;
            }
            
            [stickerView setOrigin:CGPointMake(x, y)];
            
            [self addSubview:stickerView];
        }
    }
    return self;
}


@end



@interface SPublishedController ()<UITextViewDelegate>
{
    GCPlaceholderTextView *g_contentTextView;
    STagScrollView *tagScroll;
    
    
    Preview  *_smallPreview;
    
    Preview  *_bigPreview;
    
    JCRBlurView  *_blurView;//显示大预览图的时候做为阴影显示。
}
@end

@implementation SPublishedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = COLOR_C4;
    
    
    float k = _image.size.width/_image.size.height;
    
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/k);
    CGPoint center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0);
    NSArray *tabInfoArray = [NSMutableArray arrayWithArray:[self.editVC saveTemplate:_image]];
    
    UIImageView  *playIcon = nil;
    if (self.editVC.photoVC != nil)
    {
        _smallPreview = [[Preview alloc] initWithFrame:CGRectMake(center.x-size.width/2.0, center.y-size.height/2.0, size.width, size.height) image:_image stickImage:_stickerImage tabInfoArray:tabInfoArray];
    }
    else if (self.editVC.playerVC != nil)
    {
        _smallPreview = [[Preview alloc] initWithFrame:CGRectMake(center.x-size.width/2.0, center.y-size.height/2.0, size.width, size.height) recordSession:self.editVC.recordSession stickImage:_stickerImage tabInfoArray:tabInfoArray];
        
        playIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/play"]];
        playIcon.frame = CGRectMake(0, 0, 150, 150);
        playIcon.center = CGPointMake(_smallPreview.width/2.0, _smallPreview.height/2.0);
        
        [_smallPreview addSubview:playIcon];
    }

    
    CGRect smallPreviewFrame = CGRectMake(10, 74, 125, 125);
    
    float tx = (smallPreviewFrame.size.width/2.0+smallPreviewFrame.origin.x) - _smallPreview.center.x;
    float ty = (smallPreviewFrame.size.height/2.0+smallPreviewFrame.origin.y) - _smallPreview.center.y;
    
    CATransform3D transform = CATransform3DTranslate(_smallPreview.layer.transform, tx, ty, 0);

    float sx = smallPreviewFrame.size.width/_smallPreview.width;
    float sy = smallPreviewFrame.size.height/_smallPreview.height;
    
    transform = CATransform3DScale(transform, sx, sy, 1);
    
    _smallPreview.layer.transform = transform;
    
    if (fabs(sx - sy) > 0.001 && self.editVC.playerVC != nil)//sx sy不相等
    {
        playIcon.layer.transform = CATransform3DScale(playIcon.layer.transform, 1, sx/sy, 1);
    }

    [self.view addSubview:_smallPreview];
    
    
    UITapGestureRecognizer *smallPreviewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(smallPreviewImageTap:)];
    [_smallPreview addGestureRecognizer:smallPreviewTapGestureRecognizer];
    
    
    if (self.editVC.photoVC != nil)
    {
        _bigPreview = [[Preview alloc] initWithFrame:CGRectMake(center.x-size.width/2.0, center.y-size.height/2.0, size.width, size.height) image:_image stickImage:_stickerImage tabInfoArray:tabInfoArray];
    }
    else if (self.editVC.playerVC != nil)
    {
        _bigPreview = [[Preview alloc] initWithFrame:CGRectMake(center.x-size.width/2.0, center.y-size.height/2.0, size.width, size.height) recordSession:self.editVC.recordSession stickImage:_stickerImage tabInfoArray:tabInfoArray];
    }


    UITapGestureRecognizer *bigPreviewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigPreviewImageTap:)];
    [_bigPreview addGestureRecognizer:bigPreviewTapGestureRecognizer];
    
    _blurView = [[JCRBlurView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _blurView.blurTintColor = [UIColor blackColor];
    _blurView.layer.transform = CATransform3DMakeTranslation(0, 0, 200);//保证不会被后续的子视图遮住
    
    
    UILabel *describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, 100, 30)];
    [describeLabel setText:@"描述"];
    [describeLabel setTextColor:COLOR_C2];
    [describeLabel setFont:FONT_t1];
    [self.view addSubview:describeLabel];
    
    // input
    g_contentTextView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 250 , self.view.frame.size.width-20, 80 )];
    [g_contentTextView setBackgroundColor:[UIColor whiteColor]];
    [g_contentTextView setShowsVerticalScrollIndicator:YES];
    [g_contentTextView setScrollEnabled:YES];
    g_contentTextView.delegate = self;
    [g_contentTextView setPlaceholder:@"请输入相关搭配描述"];
    
    g_contentTextView.font = FONT_t3;
    
    [g_contentTextView.layer setCornerRadius:5.0];
    [g_contentTextView.layer setBorderColor:COLOR_C9.CGColor];
    [g_contentTextView.layer setBorderWidth:1.0];
    [self.view addSubview:g_contentTextView];
    
    UILabel *systemLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 350, 100, 30)];
    [systemLabel setText:@"系统标注"];
    [systemLabel setTextColor:COLOR_C2];
    [systemLabel setFont:FONT_t3];
    [self.view addSubview:systemLabel];
    
    __weak typeof(self) weakSelf = self;
    [[SDataCache sharedInstance] getStickImgWithTabList:@"" complete:^(id object) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            [weakSelf updateTagViewWithArray:[object objectForKey:@"tab"]];
            
        }
    }];
}

- (void)smallPreviewImageTap:(UITapGestureRecognizer *)smallPreviewTapGestureRecognizer
{
    _bigPreview.layer.transform = _smallPreview.layer.transform;
    _bigPreview.layer.transform = CATransform3DTranslate(_bigPreview.layer.transform, 0, 0, 200);
    [self.view addSubview:_bigPreview];
    
    _blurView.alpha = 0;
    
    [self.view insertSubview:_blurView belowSubview:_bigPreview];
    
    
    [_bigPreview.player play];
    
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _blurView.alpha = 0.95;
        
        _bigPreview.layer.transform = CATransform3DMakeTranslation(0, 0, 200);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)bigPreviewImageTap:(UITapGestureRecognizer *)bigPreviewTapGestureRecognizer
{
    [_bigPreview.player pause];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _bigPreview.layer.transform = _smallPreview.layer.transform;
        
        _blurView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [_bigPreview removeFromSuperview];
        
        [_blurView removeFromSuperview];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavbar];
}

- (void)setupNavbar {
    [super setupNavbar];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UIImageView *navigationBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    //navigationBarView.contentMode = UIViewContentModeScaleToFill;
    navigationBarView.image = [UIImage imageNamed:@"Unico/common_navi_mixblack.png"];
    navigationBarView.userInteractionEnabled = YES;
    [self.view addSubview:navigationBarView];
    
    /* self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
     UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
     target:nil action:nil];
     negativeSpacer.width = 0;*/
    
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 28, 30, 30)];
    [leftButton setImage:[UIImage imageNamed:@"Unico/camera_navbar_back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 28, 40, 30)];
    rightButton.titleLabel.font = FONT_t2;//[UIFont boldSystemFontOfSize:18];
    [rightButton setTitle:@"发布" forState:UIControlStateNormal];
    [rightButton setTitleColor:COLOR_C3 forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:rightButton];
    
    
    //self.navigationItem.hidesBackButton = YES;
    
    //UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    //UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    //self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    //self.navigationItem.leftBarButtonItems = @[leftButtonItem] ;
    
    //UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publish:)];
    //self.navigationItem.rightBarButtonItem = right;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-150)/2.0, 20, 150, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR_C3;
    titleLabel.font = FONT_T2;//[UIFont boldSystemFontOfSize:19];
    titleLabel.text = @"发布";
    [navigationBarView addSubview:titleLabel];
}

- (void)updateTagViewWithArray:(NSArray *)array
{
    if (array.count == 0) {
        return;
    }
    tagScroll = [[STagScrollView alloc] initWithFrame:CGRectMake(0, 390, UI_SCREEN_WIDTH, 140) withTagArray:array];
    
    //这里应有范07_03.xlsl改成不可滚动，所以重新根据contentSize调整frame
    tagScroll.frame = CGRectMake(tagScroll.frame.origin.x, tagScroll.frame.origin.y, tagScroll.contentSize.width, tagScroll.contentSize.height);
    tagScroll.alwaysBounceVertical = NO;
    [tagScroll setScrollEnabled:YES];
    
    [self.view addSubview:tagScroll];
}

-(void)back:(id)sender{
    
    //[self.navigationController popToViewController:<#(UIViewController *)#> animated:YES];
    [self popAnimated:YES];
}

-(void)publish:(id)sender{
    
    if (g_contentTextView.text.length > 100)
    {
        [RKDropdownAlert title:@"您输入的文字过长"];
        return;
    }
    
    NSString *tempStr = g_contentTextView.text;
    NSArray *array = tagScroll.selectTagArray;
    NSString *uploadTagStr = @"";
    for(NSString *tagStr in array)
    {
        uploadTagStr = [uploadTagStr stringByAppendingFormat:@"%@,",tagStr];
    }
    
    if ([uploadTagStr length] > 2)
    {
        uploadTagStr = [uploadTagStr substringToIndex:[uploadTagStr length] - 1];
    }
    
    
    [_editVC publish:tempStr withTag:uploadTagStr];
    
    [SUTIL showHome];
}

#pragma mark - TextViewDelagate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"Text Len :%d",(int)(textView.text.length));
}

- (void)textViewDidChange:(UITextView *)textView{
    static int TEXT_MAXLENGTH = 100;
    if (textView.text.length > TEXT_MAXLENGTH) {
        textView.text = [textView.text substringToIndex:TEXT_MAXLENGTH];
    }
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    static int TEXT_MAXLENGTH = 50;
//    
//    NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    NSInteger res = TEXT_MAXLENGTH-[new length];
//    if(res >= 0){
//        return YES;
//    } else{
//        NSRange rg = {0,[text length]+res};
//        if (rg.length>0) {
//            NSString *s = [text substringWithRange:rg];
//            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
//        }
//        return NO;
//    }
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [g_contentTextView resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    
    NSLog(@"Recorder Recieve memory warning");
}
@end
