//
//  ImageDisplayViewController.m
//  FaFa
//
//  Created by mac on 12-11-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageDisplayViewController.h"
#import "WefafaGet.h"
#import "QuartzCore/QuartzCore.h"
#import "Utils.h"
#import "NavigationTitleView.h"
#import "Toast.h"
#import "MBProgressHUD+Add.h"

@interface ImageDisplayViewController ()

@end

@implementation ImageDisplayViewController
@synthesize scrollPage;
@synthesize imgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        orgScrollHeight = SCREEN_HEIGHT - 49;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGRect headrect=CGRectMake(0,0,self.viewHead.frame.size.width,self.viewHead.frame.size.height);
    NavigationTitleView* titleView = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [titleView createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:nil selectorMenu:@selector(delBtnClick:)];
    titleView.lbTitle.text=@"预览";
    titleView.btnMenu.hidden = YES;
    if (_isDelBtnShow) {
        titleView.btnMenu.hidden = NO;
    }
    [self.viewHead addSubview:titleView];
    

    self.view.backgroundColor = [UIColor blackColor];
    
    UIImage *tmpimg;
    if (imageFilePath!=nil && [imageFilePath isEqualToString:@""]==NO)
        tmpimg=[[UIImage alloc]initWithContentsOfFile:imageFilePath];
    else
        tmpimg=[[UIImage alloc] initWithData:UIImageJPEGRepresentation(imgSource, 1.0)];
    imgView.image= tmpimg;
    
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self resetImgViewSize:tmpimg.size.width height:tmpimg.size.height];        
        if (tmpimg.size.height>SCREEN_HEIGHT || tmpimg.size.width>SCREEN_WIDTH)
        {}
        else
        {
            [self zoom:1];
        }
    });
    
    _actView.backgroundColor=[Utils HexColor:0x080808 Alpha:0.5];
    CALayer *sublayer = [_actView layer];
    sublayer.cornerRadius = 7;
    [self stopAct];
    
    self.scrollPage.contentOffset=CGPointMake(0, 0);
    self.scrollPage.delegate = self;
    
    self.scrollPage.maximumZoomScale = 5.0f;
    self.scrollPage.minimumZoomScale = 0.01f;
}

- (void)viewDidUnload
{
    [self setScrollPage:nil];
    [self setImgView:nil];
    [self setTipLoading:nil];
    [self setActView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)resetImgViewSize:(CGFloat)Awidth height:(CGFloat)Aheight
{
    imgOrigWidth = Awidth;
    imgOrigHeight = Aheight;
    
    minimumScale = self.view.frame.size.width/imgOrigWidth * 0.75f;
    if (minimumScale > 1) minimumScale = 1;
    
    [self zoom:SCREEN_WIDTH/imgOrigWidth];
}

-(void)zoom:(float)scale
{
    float _scale = scale < minimumScale ? minimumScale : scale;
    float _w = imgOrigWidth * _scale;
    float _h = imgOrigHeight * _scale;
    float _x = _w < SCREEN_WIDTH ? (SCREEN_WIDTH - _w) / 2 : 0;
    float _y = _h < orgScrollHeight ? (orgScrollHeight - _h) / 2 : 0;
    
    self.imgView.frame = CGRectMake(_x, _y, _w, _h);
    self.scrollPage.contentSize = CGSizeMake(_w, self.imgView.frame.origin.y+self.imgView.frame.size.height);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setImageFilePath:(NSString *)path {
    imageFilePath=path;
}

- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setImageData:(UIImage *)img {
    imgSource=img;
}
- (void)setImageData:(UIImage *)img attach:(SNSAttach*)attach
{
    [self setImageData:img];
    [self view];  //可能还未载入view，先访问一次，确保已载入，后面的设置相关view控件的属性才有效
    [self startAct];
    [self resetImgViewSize:img.size.width height:img.size.height];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage * imgX = [WeFaFaGet getFile:attach.attach_id FileName:attach.file_name FileExt:attach.file_ext imagesize:SNS_IMAGE_ORIGINAL];
        dispatch_async(dispatch_get_main_queue(), ^{
            imgView.image = imgX;
            [self stopAct];
            [self resetImgViewSize:imgX.size.width height:imgX.size.height];
        });
    });
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imgView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    [self zoom:scale];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {

}

-(void)startAct
{
    _actView.hidden=NO;
    [_tipLoading startAnimating];
}

-(void)stopAct
{
    _actView.hidden=YES;
    [_tipLoading stopAnimating];
}

- (IBAction)delBtnClick:(id)sender {
    UIActionSheet *actonsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到本地", nil];
    [actonsheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(imgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if (error) {
        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
    } else {
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}
@end
