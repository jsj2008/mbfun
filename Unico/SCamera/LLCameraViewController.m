//
//  HomeViewController.m
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 29/10/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import "LLCameraViewController.h"
#import "ViewUtils.h"
#import "ImageViewController.h"
#import "ViewController.h"
#import "DoImagePickerController.h"
#import "CoverStickerView.h"

@interface LLCameraViewController ()<DoImagePickerControllerDelegate>{
    UIView *_maskerView;
    NSMutableDictionary *editInfo;
}
@property (strong, nonatomic) LLSimpleCamera* camera;
@property (strong, nonatomic) UILabel* errorLabel;
@property (strong, nonatomic) UIButton* snapButton;
@property (strong, nonatomic) UIButton* switchButton;
@property (strong, nonatomic) UIButton* flashButton;
@property (strong, nonatomic) UIButton* backButton;

@property (strong, nonatomic) UIButton* gallaryButton;
@property (strong, nonatomic) UIButton* templateButton;

@end

@implementation LLCameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    return;
    //    self.view.backgroundColor = [UIColor whiteColor];
    //    [self.navigationController setNavigationBarHidden:YES animated:NO];

    CGRect screenRect = [[UIScreen mainScreen] bounds];

    // ----- initialize camera -------- //

    // create camera vc
    self.camera = [[LLSimpleCamera alloc] initWithQuality:CameraQualityHigh andPosition:CameraPositionBack];

    // attach to a view controller
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];

    // read: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
    // you probably will want to set this to YES, if you are going view the image outside iOS.
    self.camera.fixOrientationAfterCapture = NO;

    // take the required actions on a device change
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera* camera, AVCaptureDevice* device) {
        
        NSLog(@"Device changed.");
        
        // device changed, check if flash is available
        if([camera isFlashAvailable]) {
            weakSelf.flashButton.hidden = NO;
            
            if(camera.flash == CameraFlashOff) {
                weakSelf.flashButton.selected = NO;
            }
            else {
                weakSelf.flashButton.selected = YES;
            }
        }
        else {
            weakSelf.flashButton.hidden = YES;
        }
    }];

    [self.camera setOnError:^(LLSimpleCamera* camera, NSError* error) {
        NSLog(@"Camera error: %@", error);
        
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodePermission) {
                if(weakSelf.errorLabel)
                    [weakSelf.errorLabel removeFromSuperview];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = @"We need permission for the camera.\nPlease go to your settings.";
                label.numberOfLines = 2;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0f];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                label.center = CGPointMake(screenRect.size.width / 2.0f, screenRect.size.height / 2.0f);
                weakSelf.errorLabel = label;
                [weakSelf.view addSubview:weakSelf.errorLabel];
            }
        }
    }];

    // ----- camera buttons -------- //
    float btnAlpha = 1.0;

    // snap button to capture image
    self.snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.snapButton.frame = CGRectMake(0, 0, 70.0f, 70.0f);
    self.snapButton.clipsToBounds = YES;
    
    [self.snapButton setImage:[UIImage imageNamed:@"s_camera_shot"] forState:UIControlStateNormal];
    [self.snapButton setAlpha:0.6];
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.snapButton];

    // button to toggle flash
    self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flashButton.frame = CGRectMake(0, 0, 45, 45);
    [self.flashButton setImage:[UIImage imageNamed:@"s_deng1.png"] forState:UIControlStateNormal];
    [self.flashButton setImage:[UIImage imageNamed:@"s_deng2.png"] forState:UIControlStateSelected];
    //    self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.flashButton setAlpha:btnAlpha];
    [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];

    // button to toggle camera positions
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchButton.frame = CGRectMake(0, 0, 45, 45);
    [self.switchButton setImage:[UIImage imageNamed:@"s_fanzhuang"] forState:UIControlStateNormal];
    //    self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.switchButton setAlpha:btnAlpha];
    [self.switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchButton];

    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0, 0, 45, 45);
    [self.backButton setImage:[UIImage imageNamed:@"s_back.png"] forState:UIControlStateNormal];
    //    self.backButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.backButton setAlpha:btnAlpha];
    [self.backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    // Gallary Button
    _gallaryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _gallaryButton.frame = CGRectMake(0, 0, 45, 45);
    [_gallaryButton setImage:[UIImage imageNamed:@"s_photograph"] forState:UIControlStateNormal];
    [_gallaryButton setAlpha:btnAlpha];
    [_gallaryButton addTarget:self action:@selector(gallaryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_gallaryButton];
    
    // Template Button
    _templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _templateButton.frame = CGRectMake(0, 0, 45, 45);
    [_templateButton setImage:[UIImage imageNamed:@"s_quxian.png"] forState:UIControlStateNormal];
    [_templateButton setAlpha:0];
    [_templateButton addTarget:self action:@selector(templateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_templateButton];
    
    [self.view bringSubviewToFront:_maskerView];
    
    [self addGesture];
}

- (void) addGesture {
    // 增加滑动手势，开始故事编辑
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftHandler:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightHandler:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRecognizer];
    
    
}

- (void) swipeLeftHandler:(UISwipeGestureRecognizer*)recognizer{
    NSLog(@"swipeLeftHandler");
    // change template ( 可以带滤镜信息 )
    if (_cameraDelegate) {
        [_cameraDelegate llCameraControllerDidSwipeLeft:self];
    }
}

- (void) swipeRightHandler:(UISwipeGestureRecognizer*)recognizer{
    NSLog(@"swipeRightHandler");
    // change template ( 可以带滤镜信息 )
    if (_cameraDelegate) {
        [_cameraDelegate llCameraControllerDidSwipeRight:self];
    }
}


/* other lifecycle methods */
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    float topPadding = 5.0f;
    float bottomPadding = 25.0f;
    
    self.camera.view.frame = self.view.contentBounds;
    
    self.snapButton.center = self.view.contentCenter;
    self.snapButton.bottom = self.view.height - bottomPadding;
    
    // 顶部左侧
    self.flashButton.top = topPadding;
    self.flashButton.left = topPadding;
    
    // 顶部右侧
    self.switchButton.top = topPadding;
    self.switchButton.right = self.view.width - topPadding;

    
    // 底部
    _backButton.bottom = self.view.height - bottomPadding;
    _backButton.left = bottomPadding;
    
    _gallaryButton.bottom = self.view.height - bottomPadding;
    _gallaryButton.right = self.view.width - bottomPadding;
    
    // 顶部中间
    _templateButton.center = self.view.contentCenter;
    _templateButton.top = topPadding;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES];
    // 这里启动时候，顶部有白条。
    self.view.backgroundColor = [UIColor blackColor];

    // 用上面的才有效果。
//    [self.navigationController setNavigationBarHidden:YES animated:NO];

    // start the camera
    [self.camera start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.camera stop];
}

/* camera button methods */

- (void)gallaryButtonPressed:(UIButton*)button
{
//    if (self.cameraDelegate) {
//        [self.cameraDelegate llCameraControllerDidSelectGallary:self];
//    }
    
    // 这里如果是以相机为入口，这里直接Model一个普通选择。反过来也一样
    [self showCustomLibray];
    
}

- (void)templateButtonPressed:(UIButton*)button
{
//    if (self.cameraDelegate) {
//        [self.cameraDelegate llCameraControllerDidSelectTemplate:self];
//    }
    
    // 这里如果是以相机为入口，这里直接Model一个普通选择。反过来也一样
    
}

- (void)backButtonPressed:(UIButton*)button
{
    [self.camera stop];
    [self popAnimated:self.animatedBack];
}

- (void)switchButtonPressed:(UIButton*)button
{
    [self.camera togglePosition];
}

- (void)flashButtonPressed:(UIButton*)button
{

    if (self.camera.flash == CameraFlashOff) {
        BOOL done = [self.camera updateFlashMode:CameraFlashOn];
        if (done) {
            self.flashButton.selected = YES;
        }
    }
    else {
        BOOL done = [self.camera updateFlashMode:CameraFlashOff];
        if (done) {
            self.flashButton.selected = NO;
        }
    }
}

- (void)snapButtonPressed:(UIButton*)button
{

    // capture
    [self.camera capture:^(LLSimpleCamera* camera, UIImage* image, NSDictionary* metadata, NSError* error) {
        if(!error) {
            
            // we should stop the camera, since we don't need it anymore. We will open a new vc.
            // this very important, otherwise you may experience memory crashes
            [camera stop];
            
            if( self.cameraDelegate ){
                [self.cameraDelegate llCameraController:self didFinishPickingImage:image editingInfo:editInfo];
            }
            
            if (self.completeHandler) {
                self.completeHandler(image);
            }
            
            // show the image
//            ImageViewController *imageVC = [[ImageViewController alloc] initWithImage:image];
//            [self presentViewController:imageVC animated:NO completion:nil];
            
//            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            
//            ImageCropperViewController *cropper = [mainStoryboard instantiateViewControllerWithIdentifier:@"ImageCropperStoryboardID"];
//            cropper.isHiddenStyleSelect = YES;
//            cropper.myImage = image;
//            [cropper setDelegate:self];
            
//            [self pushViewController:cropper animated:YES];
//            [self presentViewController:cropper animated:YES completion:nil];
            
        }
        else {
            NSLog(@"An error has occured: %@", error);
        }
    } exactSeenImage:YES];
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Libray DoImagePickerController
- (void)showCustomLibray
{
    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nMaxCount = 1;     // larger than 1
    cont.nColumnCount = 3;  // 2, 3, or 4
    
    cont.nResultType = DO_PICKER_RESULT_UIIMAGE; // get UIImage object array : common case
    // if you want to get lots photos, you had better use DO_PICKER_RESULT_ASSET.
    
    [self presentViewController:cont animated:YES completion:nil];
}

- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if( self.cameraDelegate && [aSelected count] ){
        [self.cameraDelegate llCameraController:self didFinishPickingImage:aSelected[0] editingInfo:editInfo];
    }
    if (self.completeHandler) {
        self.completeHandler(aSelected[0]);
    }
}



#pragma mark - Template data load & create masker 临时处理
- (void)loadTemplateJSON:(NSString*)json
{
    NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    NSArray* info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    [self loadTemplate:info];
}

- (void)loadTemplate:(NSArray*)ary
{
    if(!ary){
        return;
    }
    if (_maskerView) {
        [_maskerView removeFromSuperview];
        _maskerView = nil;
    }
    // masker view
    
    _maskerView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _maskerView.userInteractionEnabled = NO;
    // for test
//    _maskerView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    
    [self loadTemplate:ary toView:_maskerView];
    
    [self.view addSubview:_maskerView];
    
    if (!editInfo) {
        editInfo = [NSMutableDictionary dictionary];
    }
    [editInfo setObject:[self getTemplateJSON:ary] forKey:@"temp_json"];
}

- (NSString*)getTemplateJSON:(NSArray*)info
{
    
    if ([NSJSONSerialization isValidJSONObject:info]) {
        NSError* error;
        NSData* registerData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
        return [[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
    }
    else {
        return nil;
    }
}

- (void)loadTemplate:(NSArray*)ary toView:(UIView*)view
{
    for (int i = 0; i < [ary count]; i++) {
        NSDictionary* info = [ary objectAtIndex:i];
        CoverStickerView* sticker = [[CoverStickerView alloc] initWithInfo:info];
        [view addSubview:sticker];
        
//        NSLog(@"%@", [NSValue valueWithCGRect:sticker.frame]);
//        [sticker refresh];
    }
}

@end
