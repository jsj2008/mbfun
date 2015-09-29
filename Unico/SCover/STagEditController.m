//
//  ViewController.m
//
//
//  TODO：把贴纸的类整合进来。
// 

#import "STagEditController.h"
#import "CoverStickerView.h"
#import "CLImageEditor.h"
#import "UIImage+Utility.h"
#import "VerticalAlignTextView.h"
#import "LLCameraViewController.h"
#import "CoverStickerEditView.h"
#import "DCPathButton.h"
#import "DoImagePickerController.h"
//#import "TopicEditViewController.h"
#import "StickerViewController.h"
//#import "STopicEditController.h"
#import "SDataCache.h"
#import "SCoverLayerController.h"
//#import "FontDownloadController.h"
#import "SCVideoPlayerViewController.h"
#import "SCImageDisplayerViewController.h"
#import "UIImage+SizeColor.h"
#import "SUtilityTool.h"
#import "SBlurGridMenu.h"

// 品牌标签选择
#import "BrandListViewController.h"
#import "AppDelegate.h"
// 单品标签选择
#import "CollocationSearchController.h"
// 设计师标签
#import "SearchDesignerViewController.h"
// publish preview
#import "SPublishedController.h"

#import "SSearchResultViewController.h"

#import "STagEditTopicViewController.h"

// TODO:添加标签

// 1 单品标签
// 2 品牌标签
// 3 设计师标签
// 4 话题标签


@interface STagEditController ()
<
UIScrollViewDelegate,
CoverStickerViewDelegate,
SBlurGridMenuDelegate
>
{
    NSMutableArray *buttomBtns;
    //SCVideoPlayerViewController *playerVC; // 播放视频用的
    // 因为现在在这步之前，filter没有被真正录制到视频中，需要需要从前面的阶段传递过来
    // 但因为filter只有在playerVC的viewDidLoad之后才初始化，所以需要先临时保存一下
    int playerVCSelectedFilterIndex;
    
    //SCImageDisplayerViewController *photoVC; // 显示图片用
}

@property (nonatomic) UIView* renderView;
@property (nonatomic) UIImage* originalImage;
@property (nonatomic) UIImageView* imageView;
@property (nonatomic) UIImageView* clipImageView;
@property (nonatomic) UIScrollView* scrollView;
@property (nonatomic) UIFont* font;

@property (nonatomic) UIButton* textConfirm, *textCancel;

@property (nonatomic) VerticalAlignTextView* editTextView;
@property (nonatomic) CoverStickerEditView* stikerEdit;

@end

@implementation STagEditController


@synthesize photoVC = photoVC;
@synthesize playerVC = playerVC;


#pragma mark - static value
__strong static NSArray* template;

- (id)initWithImage:(UIImage*)image {
    self = [STagEditController new];

    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"SCamera" bundle:nil];
    photoVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"SCImageDisplayerViewController"];
    photoVC.photo = image;

    return self;
}

- (id)initWithVideo:(SCRecordSession*)video
{
    return [self initWithVideo:video withFilterIndex:0];
}

- (id)initWithVideo:(SCRecordSession *)video withFilterIndex:(int)filterIndex
{
    self = [STagEditController new];
    
    _recordSession = video;
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"SCamera" bundle:nil];
    playerVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"SCVideoPlayerViewController"];
    playerVC.recordSession = video;
    
    playerVCSelectedFilterIndex = filterIndex;

    return self;
}

- (void)dealloc{

    [playerVC.view removeFromSuperview];
    [playerVC removeFromParentViewController];
    playerVC = nil;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    [self createImageView];
    
    [self addGesture];
    
    UIView *navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    //navigationBarView.contentMode = UIViewContentModeScaleToFill;
    navigationBarView.backgroundColor = [UIColor blackColor];
    navigationBarView.alpha = 0.4;
    [self.view addSubview:navigationBarView];

    [self createButtons];
    
//    [self createStikerEdit];
    
    [self createPhotoView];
    
    [self createVideoPlayer];
    
    // 创建贴纸
    [self createStickerLayer];
    
//    [self.navigationController setNavigationBarHidden:YES];
    
    // Add Default Stick Info
    
    
    
    NSString *topicId = @"";
    NSDictionary* info = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCAMERA_TAG"];
    if (info && info[@"text"] && info[@"type"] && info[@"id"]) {
        NSNumber *type = info[@"type"];
        if ([type intValue] == CoverTagTypeTopic) {
            topicId = info[@"id"];
        }
    }
    
    if (info != nil)
    {
        CoverStickerView* coverStickerView = [self addLabel:CoverStickerTypeTag];
        [coverStickerView setTagName:info[@"text"] withKey:info[@"id"] withType:[info[@"type"] intValue]];
        coverStickerView.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2 - 40);
        
    }
    
    
    [self addDefaultTag];
}

// 添加默认Tag
#define TAG_DEFAULT_TAG 9999
-(void)addDefaultTag {
    CoverStickerView* view = [self addLabel:CoverStickerTypeTag];
    view.tag = TAG_DEFAULT_TAG;
    [view setTagName:@"点击空白区域添加商品" withKey:@"" withType:CoverTagTypeItem];
    view.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    // TODO: 这里增加一个隐藏的tag
    // add hidden tag
    NSDictionary* info = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCAMERA_TAG"];
    if (info && info[@"text"] && info[@"type"] && info[@"id"]) {
        NSNumber *type = info[@"type"];
        
        CoverStickerView* view = [self addLabel:CoverStickerTypeTag];
        [view setTagName:info[@"text"] withKey:info[@"id"] withType:[type intValue]];
        // 外部，看不到
        view.center = CGPointMake(-self.view.frame.size.width*2, self.view.frame.size.height/2);
    }
}

-(int)tagNum {
    int count = 0;
    NSArray* ary = [self.renderView subviews];
    for (int i = 0; i < [ary count]; i++) {
        CoverStickerView* sticker = [ary objectAtIndex:i];
        if ([sticker isMemberOfClass:[CoverStickerView class]]) {
            count ++;
        }
    }
    return count;
}

-(void)removeDefaultTag {
    UIView *view = [self.renderView viewWithTag:TAG_DEFAULT_TAG];
    if (view) {
        [view removeFromSuperview];
    }
}

-(void)createStickerLayer{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:_stickerLayerImage];
    imgView.frame = self.view.frame;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view insertSubview:imgView belowSubview:_renderView];
}

-(void)createPhotoView{
    if (photoVC) {
        // 临时关闭scroll交互。
        _scrollView.userInteractionEnabled = NO;
        [self addChildViewController:photoVC];
        [self.view insertSubview:photoVC.view belowSubview:_renderView];
    }
}

-(void)createVideoPlayer{
    // video
    if (playerVC) {
        // 临时关闭scroll交互。
        _scrollView.userInteractionEnabled = NO;
        [self addChildViewController:playerVC];
        [self.view insertSubview:playerVC.view belowSubview:_renderView];
        
        [playerVC changeFilterTo:playerVCSelectedFilterIndex];
    }
}

// 背景图，TODO 换成 SCFilterSelectorView
-(void)createImageView{
    CGRect rect = self.view.frame;
    CGRect imageRect = CGRectMake(0, 0, _originalImage.size.width, _originalImage.size.height);
    self.imageView = [[UIImageView alloc] initWithFrame:imageRect];
    
    [self.imageView setImage:_originalImage];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:rect];
    self.scrollView.scrollEnabled = NO; // 去掉交互，替换成换滤镜。
    [self.scrollView addSubview:_imageView];
    [self.scrollView setBounces:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    
    self.renderView = [[UIView alloc] initWithFrame:rect];
    [self.renderView setBackgroundColor:[UIColor clearColor]];
//    [self.renderView addSubview:self.scrollView];
    [self.view addSubview:self.renderView];
}

-(void)createStikerEdit{
    _stikerEdit = [[CoverStickerEditView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [_stikerEdit setAlpha:0];
    [self.view addSubview:_stikerEdit];
}

-(void)addGesture{
    // 不要加在view上，避免和其他组件事件冲突。
    [self.renderView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOutside:)]];
    
//    
//    UISwipeGestureRecognizer* swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftHandler:)];
//    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [self.view addGestureRecognizer:swipeRecognizer];
//    
//    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightHandler:)];
//    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
//    [self.view addGestureRecognizer:swipeRecognizer];
}

-(void)viewWillAppear:(BOOL)animated{
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

    
    [self.navigationController setNavigationBarHidden:YES];
}

// 这里实际生效，隐藏navbar
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)longPressBackground:(UILongPressGestureRecognizer*)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
    }
}

- (void)swipeUpHandler:(UISwipeGestureRecognizer*)recognizer{
    NSLog(@"Swipe Up Here");
}

- (void)swipeLeftHandler:(UISwipeGestureRecognizer*)recognizer{
    [playerVC changeFilter:-1];
    [photoVC changeFilter:-1];
}

- (void)swipeRightHandler:(UISwipeGestureRecognizer*)recognizer{
    [playerVC changeFilter:1];
    [photoVC changeFilter:1];
}

- (void)createButtons{
    buttomBtns = [NSMutableArray array];
    
    float viewWidth = CGRectGetWidth(self.view.frame);
    
    CGSize size = self.view.frame.size;
    UILabel *title = [UILabel new];
    title.font = FONT_T2;
    title.text = @"添加标签";
    title.textColor = COLOR_C3;
    [title sizeToFit];
    title.center = CGPointMake(size.width/2, 42);
    [self.view addSubview:title];


    // 返回按钮
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(7, 28, 30, 30);
    [btn setImage:[UIImage imageNamed:@"Unico/camera_navbar_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //btn.centerY = title.centerY;
    [self.view addSubview:btn];
    [buttomBtns addObject:btn];

    // 右下角，发布按钮，后面用图标。
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = FONT_t2;//[UIFont boldSystemFontOfSize:18];
    btn.frame = CGRectMake(viewWidth - 90, 10, 90, 50);
    [btn setTitleColor:COLOR_C3 forState:UIControlStateNormal];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(publishPreview) forControlEvents:UIControlEventTouchUpInside];
    btn.centerY = title.centerY;
    [self.view addSubview:btn];
    [buttomBtns addObject:btn];
    
}

#pragma mark - add Items

// 添加一个Tag
- (CoverStickerView*)addLabel:(CoverStickerType)type{
    // add a place holder first,then click to change
    CGRect frame = CGRectMake(CGRectGetMidX(self.renderView.frame),
        CGRectGetMidY(self.renderView.frame),
        200, 100);
    CoverStickerView* stickerView = [[CoverStickerView alloc] initWithFrame:frame];
    stickerView.type = type;
    stickerView.delegate = self;
    UIImageView* imageView = [[UIImageView alloc] initWithImage:nil];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [stickerView setContentView:imageView];
    //    [stickerView setNeedsDisplay];
    [stickerView setCenter:CGPointMake(self.renderView.width/2.0, self.renderView.height/2.0)];
    [self.renderView addSubview:stickerView];
    
    if (photoVC != nil)
    {
        stickerView.moveSize = photoVC.photo.size;
    }
    
    if (playerVC != nil)
    {
        NSLog(@"playerVC.heightWidthRatio = %f", playerVC.heightWidthRatio);
        stickerView.moveSize = CGSizeMake(UI_SCREEN_WIDTH, playerVC.heightWidthRatio * UI_SCREEN_WIDTH);
    }

    [stickerView setTagName:@"test" withKey:@"test" withType:CoverTagTypeItem];
    
    return stickerView;
}

#pragma mark - 保存模板
/*
 * renderView
 * - scrollView
 *   - imageView
 * - CoverStickerView
 */
- (NSArray*)saveTemplate:(UIImage*)image{
    
    [self removeDefaultTag];
    
    CGSize size = image.size;
    
    // fix成屏幕坐标，只改了height
    size.height *= self.renderView.frame.size.width/size.width;
    
    NSArray* ary = [self.renderView subviews];
    NSMutableArray* infoList = [NSMutableArray array];
    for (int i = 0; i < [ary count]; i++)
    {
        CoverStickerView* sticker = [ary objectAtIndex:i];
        if ([sticker isMemberOfClass:[CoverStickerView class]])
        {
            // save frame & other info
            NSDictionary* info = [sticker getInfo];
            
            [infoList addObject:info];
        }
    }

    float tempFloat = (UI_SCREEN_HEIGHT - size.height)/2;
    
    float tempf = 0;
    for (int i = 0; i<infoList.count; i++)
    {
        NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:infoList[i]];
        
        // 全部处理成 0~1 的值
        tempf = [temp[@"x"] floatValue];
        if (tempf < - UI_SCREEN_WIDTH) {
            [temp setObject:@(tempf) forKey:@"x"];
        } else {
            [temp setObject:@(tempf/UI_SCREEN_WIDTH) forKey:@"x"];
        }
        tempf =  [temp[@"y"] floatValue] - tempFloat;
        [temp setObject:@(tempf/size.height) forKey:@"y"];
        infoList[i] = [NSDictionary dictionaryWithDictionary:temp];
    }

    //    [[NSUserDefaults standardUserDefaults] setObject:infoList forKey:@"template"];
    return infoList;
}


#pragma mark - Save Video
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

#pragma mark - publish video & image
- (UIImage*)previewImage
{
    if (photoVC)
    {
        return photoVC.photo;
    }
    return [playerVC snapImage];
}

- (void)publishPreview
{
    SPublishedController *vc = [SPublishedController new];
    vc.editVC = self;
    
    
    
    vc.image = [self previewImage];
    
    
    vc.stickerImage = [self stickerLayerImage];
    [self pushController:vc animated:YES];
}

- (void)publish:(NSString*)contentInfo withTag:(NSString *)tag
{
    [MWKProgressIndicator show];
    [MWKProgressIndicator updateProgress:1.0f];
    [MWKProgressIndicator updateMessage:@"正在上传..."];
    
    // 失败信息
    [SDataCache sharedInstance].failedFunc = ^(AFHTTPRequestOperation* operation,NSError* error){
        [MWKProgressIndicator showErrorMessage:@"发布失败了，再试试吧~"];
    };
    
    NSDictionary *dic = @{@"contentInfo":contentInfo,@"tabStr":tag};
    // TODO:这里处理video的publish，为了方便，可能需要重构部分代码。
    if(playerVC)
    {
        SDataVideoFunc completionHandler = ^(NSURL *url, NSError *error)
        {
            if (error == nil) {
                // upload here
                [[SDataCache sharedInstance] uploadVideo:url stickerImage:_stickerLayerImage contentInfo:dic withData:[self saveTemplate:_stickerLayerImage] complete:^(NSString *str) {
                    // hide hud
                    [MWKProgressIndicator showSuccessMessage:@"您的创作内容已经成功发布!"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MBFUN_PUBLISH_SUCCESS" object:nil userInfo:nil];
                }];
            } else {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                [MWKProgressIndicator showErrorMessage:@"发布失败了，再试试是吧~"];
            }
        };
        
        [playerVC saveVideo:completionHandler];
        
        return;
    }
    
    if (photoVC)
    {
        UIImage *image = [photoVC saveImage];
        // TODO: 重新计算标签的相对于图片的坐标，高度差了20px，以后解决
        // status bar造成的？
        NSMutableArray *tempAry = [NSMutableArray arrayWithArray:[self saveTemplate:image]];
        
        
        // upload here： image 是原图，_stickerLayerImage 是贴纸，tempAry是标签信息
        [[SDataCache sharedInstance] uploadImage:image stickerImage:_stickerLayerImage contentInfo:dic withData:tempAry complete:^(NSString *str) {
            // hide hud
            [MWKProgressIndicator showSuccessMessage:@"您的创作内容已经成功发布!"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MBFUN_PUBLISH_SUCCESS" object:nil userInfo:nil];
        }];
        return;
    }
}

- (void)back
{
    [self popAnimated:YES];
}

#pragma mark - Gesture,增加标签相关
// 取消选择，隐藏编辑界面。
- (void)touchOutside:(UITapGestureRecognizer*)touchGesture{
    
    if (touchGesture.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    [[CoverStickerView currentEditView] hideEditingHandles];
    
    // 这个后续也可以配置
    int MAX_TAG = 5;
    if ([self tagNum] >= MAX_TAG) {
        [RKDropdownAlert title:@"您添加的标签数量已经达到上限"];
        return;
    }
    
    CGPoint touchLocation = [touchGesture locationInView:self.view];
    
    
    
    
    
    
    
    
    // 显示标签选择器
    SBlurGridMenuItem *btn1 = [SBlurGridMenuItem new];
    btn1.icon = [UIImage imageNamed:@"Unico/camera_tag_brand"];
    btn1.title = @"品牌";
    btn1.selectionHandler = ^(SBlurGridMenuItem *btn){
        [self dismissGridMenuAnimated:NO completion:nil];
        // 品牌标签
        SSearchResultViewController *vc = [SSearchResultViewController new];
        UINavigationController *navigationBarController = [[UINavigationController alloc]initWithRootViewController:vc];
        vc.selectedIndex = 3; // 话题
        vc.searchText = @"";
        vc.completeFunc = ^(NSString* bid,NSString* bname,NSString* brand){
            // add tag
            CoverStickerView* coverStickerView = [self addLabel:CoverStickerTypeTag];
            [coverStickerView setTagName:bname withKey:bid withType:CoverTagTypeBrand];
            
            coverStickerView.center = [coverStickerView adjustCenter:touchLocation];

            

            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            [self removeDefaultTag];
        };
        
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
       // });

        [self presentViewController:navigationBarController animated:YES completion:^{
            //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }];
    };
    
    SBlurGridMenuItem *btn2 = [SBlurGridMenuItem new];
    btn2.icon = [UIImage imageNamed:@"Unico/camera_tag_item"];
    btn2.title = @"商品";
    btn2.selectionHandler = ^(SBlurGridMenuItem *btn){
        [self dismissGridMenuAnimated:NO completion:nil];
        SSearchResultViewController *vc = [SSearchResultViewController new];
        UINavigationController *navigationBarController = [[UINavigationController alloc]initWithRootViewController:vc];
        vc.selectedIndex = 1;
        vc.searchText = @"";
        vc.completeFunc = ^(NSString* bid,NSString* bname,NSString* brand){
            // add tag
            CoverStickerView* coverStickerView = [self addLabel:CoverStickerTypeTag];
            [coverStickerView setTagName:bname withKey:bid withType:CoverTagTypeItem];
            
            coverStickerView.center = [coverStickerView adjustCenter:touchLocation];
            
            //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            [self removeDefaultTag];
        };
        
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        //});
        
        [self presentViewController:navigationBarController animated:YES completion:^{
            //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }];

    };
    
    // 搭配师
    SBlurGridMenuItem *btn3 = [SBlurGridMenuItem new];
    btn3.icon = [UIImage imageNamed:@"Unico/camera_tag_people"];
    btn3.title = @"造型师";
    btn3.selectionHandler = ^(SBlurGridMenuItem *btn){
        [self dismissGridMenuAnimated:NO completion:nil];
        
        SSearchResultViewController *vc = [SSearchResultViewController new];
        UINavigationController *navigationBarController = [[UINavigationController alloc]initWithRootViewController:vc];
        vc.selectedIndex = 2; // 话题
        vc.searchText = @"";
        vc.completeFunc = ^(NSString* bid,NSString* bname,NSString* brand){
            // add tag
            CoverStickerView* coverStickerView = [self addLabel:CoverStickerTypeTag];
            [coverStickerView setTagName:bname withKey:bid withType:CoverTagTypePerson];
        
            coverStickerView.center = [coverStickerView adjustCenter:touchLocation];
            
            //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            [self removeDefaultTag];
        };
        
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
       // });
        [self presentViewController:navigationBarController animated:YES completion:^{
            //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }];
    };
    
    // 话题
    SBlurGridMenuItem *btn4 = [SBlurGridMenuItem new];
    btn4.icon = [UIImage imageNamed:@"Unico/camera_tag_topic"];
    btn4.title = @"话题";
    btn4.selectionHandler = ^(SBlurGridMenuItem *btn){
        [self dismissGridMenuAnimated:NO completion:nil];
        // TODO : 选择话题。
       // SSearchResultViewController *vc = [SSearchResultViewController new];
        STagEditTopicViewController *tagEditTopicViewController = [STagEditTopicViewController new];
        UINavigationController *navigationBarController = [[UINavigationController alloc]initWithRootViewController:tagEditTopicViewController];
        //vc.selectedIndex = 4; // 话题
        //vc.searchText = @"";
        tagEditTopicViewController.completeFunc = ^(NSString* bid,NSString* bname,NSString* brand){
            // add tag
            CoverStickerView* coverStickerView = [self addLabel:CoverStickerTypeTag];
            [coverStickerView setTagName:bname withKey:bid withType:CoverTagTypeTopic];
            
            coverStickerView.center = [coverStickerView adjustCenter:touchLocation];
            
            //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            [self removeDefaultTag];
        };
        
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        //});
        [self presentViewController:navigationBarController animated:YES completion:^{
            //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }];
    };
    
    SBlurGridMenu *menu = [[SBlurGridMenu alloc] initWithMenuItems:@[btn1,btn2,btn3,btn4]];
    menu.delegate = self;
    [self presentGridMenu:menu animated:YES completion:^{
        NSLog(@"Grid Menu Presented");
    }];
}

#pragma mark - Menu delegate
- (void)gridMenuDidTapOnBackground:(SBlurGridMenu *)menu{
    [self dismissGridMenuAnimated:YES completion:nil];
}
- (void)gridMenu:(SBlurGridMenu *)menu didTapOnItem:(SBlurGridMenuItem *)item{
    NSLog(@"didTapOnItem item = %@", item);
}


#pragma mark - no status bar

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - Sticker Delaget

- (void)stickerViewDidEndEditing:(CoverStickerView*)sticker{
}
- (void)stickerViewDidShowEditingHandles:(CoverStickerView*)sticker{

}
- (void)stickerViewDidHideEditingHandles:(CoverStickerView*)sticker{
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"Recorder Recieve memory warning");
}

@end
