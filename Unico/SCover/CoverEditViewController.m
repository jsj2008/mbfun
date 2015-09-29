//
//  ViewController.m
//
//
//  TODO：把贴纸的类整合进来。
// 

#import "CoverEditViewController.h"
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

#import "SStickerEditController.h"

// TODO:添加标签

// 1 单品标签
// 2 品牌标签
// 3 设计师标签
// 4 话题标签


@interface CoverEditViewController ()
<
CLImageEditorDelegate,
UIScrollViewDelegate,
UITextViewDelegate,
LLCameraControllerDelegate,
DCPathButtonDelegate,
CoverStickerViewDelegate,
DoImagePickerControllerDelegate,
SBlurGridMenuDelegate
>
{
    NSMutableArray *buttomBtns;
    SCVideoPlayerViewController *playerVC; // 播放视频用的
    SCImageDisplayerViewController *photoVC; // 显示图片用
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

@implementation CoverEditViewController
#pragma mark - static value
__strong static CoverEditViewController* sharedVC = nil;
__strong static NSArray* template;

+ (CoverEditViewController*)sharedVC{
    return sharedVC;
}

- (id)initWithImage:(UIImage*)image {
    self = [[CoverEditViewController alloc] initWithNibName:nil bundle:nil];

    // 这里是一个临时的容错处理
    _originalImage = [UIImage imageWithSize:CGSizeMake(10, 10) andColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"SCamera" bundle:nil];
    photoVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"SCImageDisplayerViewController"];
    photoVC.photo = image;
    

    __strong __typeof(self) strongSelf = self;
    sharedVC = strongSelf;

    _topicData = [NSMutableArray array];

    return self;
}

- (id)initWithVideo:(SCRecordSession*)video {
    
    self = [[CoverEditViewController alloc] initWithNibName:nil bundle:nil];
    
    // 这里是一个临时的容错处理
    _originalImage = [UIImage imageWithSize:CGSizeMake(10, 10) andColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"SCamera" bundle:nil];
    playerVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"SCVideoPlayerViewController"];
    playerVC.recordSession = video;
    
    __strong __typeof(self) strongSelf = self;
    sharedVC = strongSelf;
    
    _topicData = [NSMutableArray array];
    
    return self;
}

- (void)dealloc{
    if (sharedVC == self) {
        sharedVC = nil;
    }
    [playerVC.view removeFromSuperview];
    [playerVC removeFromParentViewController];
    playerVC = nil;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    [self createImageView];
    
    [self addGesture];

    [self refreshImageView];

    [self loadDefaultFont];

    [self createButtons];

    [self createStikerEdit];

    if (_templateJSON) {
        [self loadTempJSON:_templateJSON];
    }
    
    [self createPhotoView];
    [self createVideoPlayer];
    
    [self.navigationController setNavigationBarHidden:YES];
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
    
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressBackground:)];
    [longPress setMinimumPressDuration:0.6];
    [self.scrollView addGestureRecognizer:longPress];
    
    // 增加滑动手势，开始故事编辑
    UISwipeGestureRecognizer* swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpHandler:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeRecognizer];
    
    // swipe change filter
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftHandler:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightHandler:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRecognizer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

// 这里实际生效，隐藏navbar
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    // 暂时关闭手势返回，避免一些错误。
    [self.interactiveTransition detach];
}

- (void)longPressBackground:(UILongPressGestureRecognizer*)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self showBackgroundEditbar];
    }
}

- (void)swipeUpHandler:(UISwipeGestureRecognizer*)recognizer{
    NSLog(@"Swipe Up Here");
    [self showParticleEdit];
}

- (void)swipeLeftHandler:(UISwipeGestureRecognizer*)recognizer{
    [playerVC changeFilter:-1];
    [photoVC changeFilter:-1];
}

- (void)swipeRightHandler:(UISwipeGestureRecognizer*)recognizer{
    [playerVC changeFilter:1];
    [photoVC changeFilter:1];
}



// 显示图层编辑（TODO）
- (void)showLayer {
    // TODO：可以向下滑动
    SCoverLayerController *vc = [SCoverLayerController new];
    vc.list = [self.renderView subviews];
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}

// 显示图文编辑
- (void)showParticleEdit{
    
}

- (void)createButtons{
    buttomBtns = [NSMutableArray array];
    
    float viewWidth = CGRectGetWidth(self.view.frame);
    float viewHeight = CGRectGetHeight(self.view.frame);

    // 底部的向上按钮，进入图文编辑，用在swap无效时候。
    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0, viewHeight-20, viewWidth , 20);
    upButton.frame = frame;
    [upButton addTarget:self action:@selector(swipeUpHandler:) forControlEvents:(UIControlEventTouchUpInside)];
    //  隐形按钮。
//    [upButton setImage:[UIImage imageNamed:@"swipe_up"] forState:UIControlStateNormal];
    [self.view addSubview:upButton];
    [buttomBtns addObject:upButton];

    // 返回按钮
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 10, 50, 50);
    [btn setImage:[UIImage imageNamed:@"s_1_shangyibu"] forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn setTitle:@"上一步" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [buttomBtns addObject:btn];

    // 右下角，发布按钮，后面用图标。
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(viewWidth - 60, viewHeight - 60, 50, 50);
    [btn setImage:[UIImage imageNamed:@"s_1_xiayibu"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(publishPreview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [buttomBtns addObject:btn];
    
    // 左下角，编辑背景
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, viewHeight - 60, 50, 50);
    [btn setImage:[UIImage imageNamed:@"s_1_bianji"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showBackgroundEditbar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [buttomBtns addObject:btn];
    
    [self configureDCPathButton];
    
    // TODO: 图层管理，包括锁定，选中，排序，删除等，这个可以下个版本弄。
}

- (void)configureDCPathButton{
    DCPathButton* dcPathButton = [[DCPathButton alloc] initWithCenterImage:[UIImage imageNamed:@"s_1_tianjia"]
                                                            hilightedImage:[UIImage imageNamed:@"s_1_tianjia"]];
    dcPathButton.delegate = self;
    DCPathItemButton* itemButton_2 = [[DCPathItemButton alloc] initWithImage:[UIImage imageNamed:@"s_t_tianjiaxingzhuang"]
                                                            highlightedImage:[UIImage imageNamed:@"s_t_tianjiaxingzhuang"]
                                                             backgroundImage:nil
                                                  backgroundHighlightedImage:nil];

    DCPathItemButton* itemButton_3 = [[DCPathItemButton alloc] initWithImage:[UIImage imageNamed:@"s_t_tianjiatupian"]
                                                            highlightedImage:[UIImage imageNamed:@"s_t_tianjiatupian"]
                                                             backgroundImage:nil
                                                  backgroundHighlightedImage:nil];

    DCPathItemButton* itemButton_4 = [[DCPathItemButton alloc] initWithImage:[UIImage imageNamed:@"s_t_tianjiawenzi"]
                                                            highlightedImage:[UIImage imageNamed:@"s_t_tianjiawenzi"]
                                                             backgroundImage:nil
                                                  backgroundHighlightedImage:nil];
//    DCPathItemButton* itemButton_temp = [[DCPathItemButton alloc] initWithImage:[UIImage imageNamed:@"s_t_moban"]
//                                                            highlightedImage:[UIImage imageNamed:@"s_t_moban"]
//                                                             backgroundImage:nil
//                                                  backgroundHighlightedImage:nil];
    // 暂时去掉模板按钮
    [dcPathButton addPathItems:@[ itemButton_2, itemButton_3, itemButton_4 ]];
    dcPathButton.bloomRadius = 100.0f;
    dcPathButton.dcButtonCenter = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 35.0f);

    [self.view addSubview:dcPathButton];
    [buttomBtns addObject:dcPathButton];
}

#pragma mark - DCPathButton Delegate
- (void)itemButtonTappedAtIndex:(NSUInteger)index
{
    switch (index) {
    case 0:
        [self addLabel:CoverStickerTypeShape];
        //            [self addLabel: CoverStickerTypeShape];
        break;
    case 1:
        [self addLabel:CoverStickerTypeImage];
        break;
    case 2:
        [self addLabel:CoverStickerTypeText];
        break;
    case 3:
        // 显示模板选择。
        break;
    default:
        break;
    }
}

// 加载默认文字字体。
- (void)loadDefaultFont{
    // 暂时没放字体
    return;
    NSString* fontFileName = @"fzfys.ttf";
    NSURL* myFontURL = [[NSBundle mainBundle] URLForResource:fontFileName withExtension:@""];
    NSArray* fontPostScriptNames = [UIFont registerFontFromURL:myFontURL];
    NSString* fontName = [fontPostScriptNames objectAtIndex:0];
    _font = [UIFont fontWithName:fontName size:32.0f];
}

#pragma mark - add Items

// 添加一个贴纸对象。
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
    [stickerView setCenter:self.renderView.center];
    [self.renderView addSubview:stickerView];

    switch (type) {
    case CoverStickerTypeText:
        stickerView.font = _font;
        stickerView.text = TOPIC_TEXT_PLACEHOLDER;
        break;
    case CoverStickerTypeImage:
        [stickerView setImage:[UIImage imageNamed:@"edit_default"]];
        break;
    case CoverStickerTypeShape:
        [stickerView setShape:@"doo_bulb.png"];
        break;
    case CoverStickerTypeSVG:
//        [stickerView setSVG:@"du_beard1"];
        break;
        case CoverStickerTypeTag:
            [stickerView setTagName:@"test" withKey:@"test" withType:CoverTagTypeItem];
            break;
    default:
        break;
    }
    
    return stickerView;
}

#pragma mark - 保存模板
/*
 * renderView
 * - scrollView
 *   - imageView
 * - CoverStickerView
 */
- (NSArray*)saveTemplate{
    NSArray* ary = [self.renderView subviews];
    NSMutableArray* infoList = [NSMutableArray array];
    for (int i = 0; i < [ary count]; i++) {
        CoverStickerView* sticker = [ary objectAtIndex:i];
        if ([sticker isMemberOfClass:[CoverStickerView class]]) {
            // save frame & other info
            NSDictionary* info = [sticker getInfo];
            [infoList addObject:info];
        }
    }

    template = infoList;
    //    [[NSUserDefaults standardUserDefaults] setObject:infoList forKey:@"template"];
    return infoList;
}

- (NSString*)getTemplateJSON
{
    NSArray* info = [self saveTemplate];

    if ([NSJSONSerialization isValidJSONObject:info]) {
        NSError* error;
        NSData* registerData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
        return [[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
    }
    else {
        return nil;
    }
}

- (void)loadTempJSON:(NSString*)json
{
    NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    NSArray* info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    [self loadTemplate:info];
}

- (void)loadTemplate:(NSArray*)ary
{
    [self loadTemplate:ary toView:self.renderView];
}

- (void)loadTemplate:(NSArray*)ary toView:(UIView*)view
{
    for (int i = 0; i < [ary count]; i++) {
        NSDictionary* info = [ary objectAtIndex:i];
        CoverStickerView* sticker = [[CoverStickerView alloc] initWithInfo:info];
        // 不要忘记加delegete
        sticker.delegate = self;
        [view addSubview:sticker];
        //        [sticker setInfo:info];
        //        NSLog(@"%@", [NSValue valueWithCGRect:sticker.frame]);
        //        [sticker refresh];
    }
}


#pragma mark - Save Video
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    // TODO：此处是调试信息。
    if (error == nil) {
        [[[UIAlertView alloc] initWithTitle:@"Saved to camera roll" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Failed to save" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

#pragma mark - publish video & image
- (UIImage*)previewImage {
    if (photoVC) {
        return photoVC.photo;
    }
    return [playerVC snapImage];
}

- (void)publishPreview{
    
    SPublishedController *vc = [SPublishedController new];
    vc.editVC = self;
    
    vc.image = [self previewImage];
    
    
    
    [self pushController:vc animated:YES];
}

- (void)publish:(NSString*)contentInfo
{
    // 不再使用。
}

// 获得标签信息json


- (UIImage*)coverImage
{
    return [self snapshot2:self.renderView];
}

- (void)saveImage
{
    // 这个时候，隐藏所有的操作符号。
    [[CoverStickerView currentEditView] hideEditingHandles];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        UIImage *img = [self snapshot2:self.renderView];
        // 测试时候可以注视掉这里，避免总生成图
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
//        [self saveTemplateWithCover:img];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Save Suc");
            
            if (self.coverDelegate) {
                [self.coverDelegate coverEditController:self didFinishPickingImage:img editingInfo:nil];
            }
        });
    });
}

- (void)back
{
    [self popAnimated:YES];
}

- (void)changeImageWhite
{
    _clipImageView = (UIImageView*)[CoverStickerView currentEditView].contentView;
    [self onImageReady:[UIImage imageNamed:@"full_white"]];
}

- (void)changeImageBlack
{
    _clipImageView = (UIImageView*)[CoverStickerView currentEditView].contentView;
    [self onImageReady:[UIImage imageNamed:@"full_black"]];
}

- (void)editClipImage
{
    _clipImageView = (UIImageView*)[CoverStickerView currentEditView].contentView;
    UIImage* img = nil;
    if (_clipImageView && _clipImageView.image) {
        img = [_clipImageView.image deepCopy];
    }
    else {
        img = _originalImage;
    }
    CLImageEditor* editor = [[CLImageEditor alloc] initWithImage:img];
    editor.delegate = self;
    [self presentViewController:editor animated:NO completion:nil];
}

#pragma mark - 编辑文字内容
- (void)editText{

    if (!_editTextView) {
        _editTextView = [[VerticalAlignTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _editTextView.delegate = self;
        // 重新设置下字体大小。
        _editTextView.font = [UIFont fontWithName:_font.fontName size:20.0];
        _editTextView.textColor = [UIColor whiteColor];
        _editTextView.textAlignment = NSTextAlignmentCenter;
        //        _editTextView.text
        _editTextView.verticalAlignment = VerticalAlignmentMiddle;
        _editTextView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        //        _editTextView.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_editTextView];

        float btnSize = 40;
        float inset = 10;
        // add confirm button
        _textConfirm = [[UIButton alloc] initWithFrame:CGRectMake( self.view.frame.size.width - btnSize - inset, inset, btnSize, btnSize)];
        [_textConfirm setImage:[UIImage imageNamed:@"icon_cover_text_confirm"] forState:UIControlStateNormal];
        [_textConfirm addTarget:self action:@selector(onTextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editTextView addSubview:_textConfirm];

        _textCancel = [[UIButton alloc] initWithFrame:CGRectMake(inset, inset, btnSize, btnSize)];
        [_textCancel setImage:[UIImage imageNamed:@"icon_cover_text_cancel"] forState:UIControlStateNormal];
        [_textCancel addTarget:self action:@selector(onTextBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
        [_editTextView addSubview:_textCancel];
    }
    _editTextView.alpha = 1;
    _editTextView.text = [[CoverStickerView currentEditView] plainText];
    if ([_editTextView.text isEqualToString:TOPIC_TEXT_PLACEHOLDER]) {
        _editTextView.text = @"";
    }
    [_editTextView becomeFirstResponder];
}

- (void)onTextBtnCancel:(UIButton*)sender{
    if (_editTextView) {
        [_editTextView resignFirstResponder];
        _editTextView.alpha = 0;
    }
}

// 编辑文字。
- (void)onTextBtnClick:(UIButton*)sender{
    if (_editTextView) {
        CoverStickerView* view = [CoverStickerView currentEditView];
        if (_editTextView.text && _editTextView.text.length > 0) {
            [view setPlainText:_editTextView.text];        }

        [_editTextView resignFirstResponder];
        _editTextView.alpha = 0;
    }
}

#pragma mark - textview delegete
// 暂时不让输入换行
- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text{
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    if ([text length] + textView.text.length > 20) {
        return NO;
    }
    return YES;
}

// 后续独立放一个view存放需要snap的内容
// 另外，可能需要分层保存。这个后续再说
// 这个始终是全屏幕的
- (UIImage*)snapshot:(UIView*)view{
    [[CoverStickerView currentEditView] hideEditingHandles];

    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    // 下面那个会让view交互丢失。
    //    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // 根据UI Image裁剪，不能简单的判断不透明，因为装饰物可能超出区域。
    return image;
}

// 目前实际使用这个函数。 判断size相关优点啰嗦，后续改进。
// 尺寸根据背景图定。
- (UIImage*)snapshot2:(UIView*)view{
    [[CoverStickerView currentEditView] hideEditingHandles];

    CGSize rect = self.imageView.frame.size;
    CGSize screenRect = view.frame.size;
    // fix size
    if (rect.width > screenRect.width) {
        rect.width = screenRect.width;
    }
    if (rect.height > screenRect.height) {
        rect.height = screenRect.height;
    }

    CGRect frame = self.imageView.frame;
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

#pragma mark - Gesture,增加标签相关
// 取消选择，隐藏编辑界面。
- (void)touchOutside:(UITapGestureRecognizer*)touchGesture{
    
    if (touchGesture.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    [self showButtomBar];
    [[CoverStickerView currentEditView] hideEditingHandles];
    
    
    
}

#pragma mark - Menu delegate
- (void)gridMenuDidTapOnBackground:(SBlurGridMenu *)menu{
    [self dismissGridMenuAnimated:YES completion:nil];
}
- (void)gridMenu:(SBlurGridMenu *)menu didTapOnItem:(SBlurGridMenuItem *)item{
    
}



#pragma mark - **** TAG actions with control ****
/*
 [self createBtnList:@[ @"字体", @"颜色", @"阴影", @"方向", @"透明＋", @"透明－",@"字距＋", @"字距－" ]];
 [self createBtnList:@[ @"图库", @"相机", @"编辑", @"阴影", @"透明＋", @"透明－"]];
 [self createBtnList:@[ @"形状", @"颜色", @"阴影", @"透明＋", @"透明－"]];
 [self createBtnList:@[ @"图库", @"相机", @"编辑"]];
 */
- (void)editAction:(UIButton*)sender{
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"字体"]) {
        // 显示字体选择
        [self showFontSelect];
    }
    else if ([title isEqualToString:@"颜色"]) {
        [self switchColor];
    }
    else if ([title isEqualToString:@"阴影"]) {
        [self switchShadow];
    }
    else if ([title isEqualToString:@"方向"]) {
        [self switchTextDirection];
    }
    else if ([title isEqualToString:@"字距＋"]) {
        [self textPaddingAdd];
    }
    else if ([title isEqualToString:@"字距－"]) {
        [self textPaddingReduce];
    }
    else if ([title isEqualToString:@"图库"]) {
        [self showCustomLibray];
    }
    else if ([title isEqualToString:@"相机"]) {
        [self showFullscreenCamera];
    }
    else if ([title isEqualToString:@"编辑"]) {
        [self editClipImage];
    }
    else if ([title isEqualToString:@"透明＋"]) {
        [self editTransAdd];
    }
    else if ([title isEqualToString:@"透明－"]) {
        [self editTransReduce];
    }
    else if ([title isEqualToString:@"形状"]) {
        [self showShapeSelect];
    }
}

// 换形状
- (void)showShapeSelect{
    //    LocalShapeView* view = [[LocalShapeView alloc] initWithFrame:self.view.frame];
    //    [self.view addSubview:view];
    StickerViewController *vc = [StickerViewController new];
    __weak StickerViewController* weakVC = vc;
    vc.selectFunc = ^(NSString* file){
        [weakVC.view removeFromSuperview];
        [weakVC removeFromParentViewController];
        
        [[CoverStickerView currentEditView] setShape:file];
    };
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}

// 换文字
- (void)showFontSelect{
    
    
}

// 换图片
// TODO:因为要兼容视频，所以暂时替换另一个库。
- (void)showCustomLibray{
    DoImagePickerController* cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nMaxCount = 1; // larger than 1
    cont.nColumnCount = 3; // 2, 3, or 4

    cont.nResultType = DO_PICKER_RESULT_UIIMAGE; // get UIImage object array : common case
    // if you want to get lots photos, you had better use DO_PICKER_RESULT_ASSET.

    [self presentViewController:cont animated:NO completion:nil];
}

// 增加和减少文字间距，根据方向判断应该增加行距还是字距离
- (void)textPaddingAdd{
    if ([CoverStickerView currentEditView].textDirection) {
        if ([CoverStickerView currentEditView].textVerticalPadding < 2) {
            [CoverStickerView currentEditView].textVerticalPadding += 0.1;
        }
        return;
    }
    
    if ([CoverStickerView currentEditView].textHorizontalPadding < _font.pointSize) {
        [CoverStickerView currentEditView].textHorizontalPadding += 1;
    }
}

- (void)textPaddingReduce{
    if ([CoverStickerView currentEditView].textDirection) {
        if ([CoverStickerView currentEditView].textVerticalPadding > 0.5) {
            [CoverStickerView currentEditView].textVerticalPadding -= 0.1;
        }
        return;
    }
    if ([CoverStickerView currentEditView].textHorizontalPadding > 1) {
        [CoverStickerView currentEditView].textHorizontalPadding -= 1;
    }
}

// 透明度
- (void)editTransAdd
{
    if ([CoverStickerView currentEditView].contentAlpha < 1) {
        [CoverStickerView currentEditView].contentAlpha += 0.1;
    }
}
- (void)editTransReduce
{
    if ([CoverStickerView currentEditView].contentAlpha > 0.1) {
        [CoverStickerView currentEditView].contentAlpha -= 0.1;
    }
}
// 修改颜色，暂时只有黑和白。
- (void)switchColor{
    UIColor* color = [CoverStickerView currentEditView].textColor;

    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];

    if (red <= 0) {
        [self editColorWhite];
    }
    else {
        [self editColorBlack];
    }
}

- (void)switchShadow{
    [CoverStickerView currentEditView].showContentShadow = ![CoverStickerView currentEditView].showContentShadow;
}

- (void)switchTextDirection{
    [CoverStickerView currentEditView].textDirection = ![CoverStickerView currentEditView].textDirection;
}

- (void)editColorBlack
{
    // 必须使用rpb空间的颜色
    [[CoverStickerView currentEditView] setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
}
- (void)editColorWhite
{
    [[CoverStickerView currentEditView] setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
}

- (void)changeFont:(NSString*)name
{
    NSURL* myFontURL = [[NSBundle mainBundle] URLForResource:name withExtension:nil];
    NSArray* fontPostScriptNames = [UIFont registerFontFromURL:myFontURL];
    NSString* fontName = [fontPostScriptNames objectAtIndex:0];
    UIFont* font = [UIFont fontWithName:fontName size:32];
    [[CoverStickerView currentEditView] setFont:font];
}

// 全屏相机
- (void)showFullscreenCamera{
    _clipImageView = (UIImageView*)[CoverStickerView currentEditView].contentView;

    LLCameraViewController* homeVC = [[LLCameraViewController alloc] initWithNibName:nil bundle:nil];
    homeVC.cameraDelegate = self;
    
    // add a musker if there is some stickers,  v2  NEW
    NSArray* temp = [self saveTemplate];
    [homeVC loadTemplate:temp];

    [self pushController:homeVC animated:NO];
    
}

// 选择或者编辑完成图片后，更新视图。
// 可以尝试增加一个UI特效
- (void)onImageReady:(UIImage*)image{
    if ([CoverStickerView currentEditView] && [CoverStickerView currentEditView].type == CoverStickerTypeImage) {
        [[CoverStickerView currentEditView] setImage:image];
        _clipImageView = nil;
    } else {
        _originalImage = image;
        _imageView.image = _originalImage;
        [self refreshImageView];
    }
}

#pragma mark - CLImageEditor delegate

- (void)imageEditor:(CLImageEditor*)editor didFinishEdittingWithImage:(UIImage*)image{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self onImageReady:image];
}

#pragma mark - scroll image 针对背景图片的缩放等。
- (void)refreshImageView{
    dispatch_async(dispatch_get_main_queue(), ^{
        _imageView.image = _originalImage;
        
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
        CGFloat ratio = MIN(Rw, Rh);
        
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
    CGFloat W = _originalImage.size.width * _scrollView.zoomScale;
    CGFloat H = _originalImage.size.height * _scrollView.zoomScale;

    CGRect rct = _imageView.frame;
    rct.origin.x = MAX((Ws - W) / 2, 0);
    rct.origin.y = MAX((Hs - H) / 2, 0);
    _imageView.frame = rct;
}

#pragma mark - DoImagePickerControllerDelegate
- (void)didCancelDoImagePickerController{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController*)picker result:(NSArray*)aSelected{
    [self dismissViewControllerAnimated:NO completion:nil];

    if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE) {
        UIImage* image = aSelected[0];
        [self onImageReady:image];
    }
}

#pragma mark - LLCameraControllerDelegate
- (void)llCameraController:(LLCameraViewController*)cameraController didFinishPickingImage:(UIImage*)image editingInfo:(NSDictionary*)editingInfo{
    [self popAnimated:NO];
    // 测试新图片编辑
    [self onImageReady:image];
}

#pragma mark - no status bar

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - Sticker Delaget

- (void)stickerViewDidEndEditing:(CoverStickerView*)sticker{
    [self resetStickEditPosition:sticker];
}

- (void)stickerViewDidShowEditingHandles:(CoverStickerView*)sticker{
    [self hideButtomBar];
    _stikerEdit.alpha = 1;
    [_stikerEdit setType:sticker.type];
    [self resetStickEditPosition:sticker];
}
- (void)stickerViewDidHideEditingHandles:(CoverStickerView*)sticker{
    [self showButtomBar];
    _stikerEdit.alpha = 0;
    [self resetStickEditPosition:sticker];
}

- (void)resetStickEditPosition:(CoverStickerView*)sticker{
    if (sticker.center.y > CGRectGetHeight(self.view.frame)*0.8 ) {
        [_stikerEdit top];
    } else {
        [_stikerEdit bottom];
    }
}

- (void)showBackgroundEditbar{
    [self hideButtomBar];
    _stikerEdit.alpha = 1;
    [_stikerEdit setType:CoverStickerTypeBackground];
    [_stikerEdit bottom];
}

// 显示和隐藏底部的控制按钮。
- (void)hideButtomBar{
    _stikerEdit.alpha = 1;
    for (UIView *view in buttomBtns) {
        view.alpha = 0;
    }
}

- (void)showButtomBar{
    _stikerEdit.alpha = 0;
    for (UIView *view in buttomBtns) {
        view.alpha = 1;
    }
}

@end
