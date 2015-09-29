//
//  SCImageViewDisPlayViewController.m
//  SCAudioVideoRecorder
//
//

#import "SCImageDisplayerViewController.h"
#import "SUtilityTool.h"

#import "OpenCVTool.h"

@interface SCImageDisplayerViewController ()
{
    NSArray *_filters;
    NSInteger selectedIndex;
}

@end

@implementation SCImageDisplayerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.filterSwitcherView refresh];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveToCameraRoll)];
    
    self.filterSwitcherView.contentMode = UIViewContentModeScaleAspectFit;
    [self.filterSwitcherView setImageByUIImage:self.photo];
    self.filterSwitcherView.filters = [[SUtilityTool shared] recorderFilters];
    _filters = self.filterSwitcherView.filters;
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil)
    {
        [[[UIAlertView alloc] initWithTitle:@"Done!" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Failed :(" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)saveToCameraRoll
{
    UIImage *image = [self.filterSwitcherView currentlyDisplayedImageWithScale:self.photo.scale orientation:self.photo.imageOrientation];
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (UIImage*)saveImage
{
    UIImage *image = [self.filterSwitcherView currentlyDisplayedImageWithScale:self.photo.scale orientation:self.photo.imageOrientation];
    // resize to 750p
    CGSize newSize = CGSizeMake(750, 750.0f/image.size.width*image.size.height);
    
    
    UIImage *image2 = [image resize:newSize];
    
    float scale = self.view.layer.transform.m11;
    float tx = self.view.layer.transform.m41;
    float ty = self.view.layer.transform.m42;
    
    
    float k = 750.0 / UI_SCREEN_WIDTH;
    
    tx = tx * k;
    ty = ty * k;
    
    
    IplImage *iplImage1 = OpenCVTool::createBGRIplImageFromUIImage(image2);
    IplImage *iplImage2 = nil;
    
    //先缩放
    if (scale < 1)
    {
        iplImage2 = cvCreateImage(cvSize(iplImage1->width, iplImage1->height), iplImage1->depth, iplImage1->nChannels);
        OpenCVTool::scaleImage(iplImage1, iplImage2, scale, scale, cvScalarAll(0));
    }
    else
    {
        iplImage2 = cvCreateImage(cvSize(iplImage1->width*scale, iplImage1->height*scale), iplImage1->depth, iplImage1->nChannels);
        cvResize(iplImage1, iplImage2);
    }
    
    //再平移
    IplImage  *iplImage3 = cvCreateImage(cvSize(iplImage2->width, iplImage2->height), iplImage2->depth, iplImage2->nChannels);
    OpenCVTool::translationImage(iplImage2, iplImage3, tx, ty, cvScalarAll(0));
    
    //再适配尺寸
    IplImage  *iplImage4 = cvCreateImage(cvSize(iplImage1->width, iplImage1->height), iplImage1->depth, iplImage1->nChannels);
    cvSetImageROI(iplImage3, cvRect((iplImage3->width - iplImage1->width)/2.0, (iplImage3->height - iplImage1->height)/2.0, iplImage1->width, iplImage1->height));
    cvCopy(iplImage3, iplImage4);
    
    UIImage *image3 = OpenCVTool::createRGBUIImageFromIplImage(iplImage4);
    
    cvReleaseImage(&iplImage1);
    cvReleaseImage(&iplImage2);
    cvReleaseImage(&iplImage3);
    cvReleaseImage(&iplImage4);
    
    return image3;
}


-(void)changeFilterTo:(int)index
{
    selectedIndex = index;
    [self changeFilter:0];
}
-(void)changeFilter:(int)offsetIndex
{
    if (!_filters || _filters.count<=0)
    {
        return;
    }
    
    selectedIndex += offsetIndex;
    if (selectedIndex < _filters.count && selectedIndex >= 0)
    {
        
    }
    else
    {
        if ( offsetIndex > 0 )
        {
            selectedIndex = 0;
        }
        else
        {
            selectedIndex = _filters.count - 1;
        }
    }
    
    // TODO：用了粗暴的方式
    //
    SCFilter *filter = _filters[selectedIndex];
    
    self.filterSwitcherView.filters = @[filter];
    [self.filterSwitcherView refresh];
}

@end
