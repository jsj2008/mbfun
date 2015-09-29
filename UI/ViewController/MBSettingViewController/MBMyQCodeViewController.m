//
//  MBMyQCodeViewController.m
//  Wefafa
//
//  Created by fafatime on 14-11-14.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MBMyQCodeViewController.h"
#import "Utils.h"
#import "Toast.h"
#import "AppSetting.h"
#import "SQLiteOper.h"
#import "WeFaFaGet.h"
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"
#import "MBShoppingGuideInterface.h"

@interface MBMyQCodeViewController ()
{
    NSCondition* download_lock;
}
@property (nonatomic,weak) IBOutlet UIImageView *lineImgView;
@property (weak, nonatomic) IBOutlet UIView *manageView;
@property (nonatomic,weak) IBOutlet UIView *titleView;
@property (nonatomic,weak)IBOutlet UIImageView *codeImgView;
@property (nonatomic,weak)IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageInQRCode;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@end

@implementation MBMyQCodeViewController

@synthesize staffFull;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [Utils HexColor:0xf2f2f2 Alpha:1];
    [self setupNavbar];
    CGFloat yPoint = 44;
    if ([[UIDevice currentDevice].systemVersion integerValue]>7.0) {
        yPoint = 64;
    }
    yPoint+=20;

    self.nameLabel.text = [NSString stringWithFormat:@"%@",[Utils getSNSString:self.staffFull.nick_name]];
    [_lineImgView setBackgroundColor:[Utils HexColor:0x6b6b6b Alpha:1]];
    [_manageView setFrame:CGRectMake(15, 84, UI_SCREEN_WIDTH-30, UI_SCREEN_HEIGHT-84)];
    
    [self.headerImageInQRCode setFrame:CGRectMake(( UI_SCREEN_WIDTH-30)/2-100, self.headerImageInQRCode.frame.origin.y, self.headerImageInQRCode.frame.size.width, self.headerImageInQRCode.frame.size.height)];
    
    [self.headerImageInQRCode setContentMode:UIViewContentModeScaleAspectFill];
    self.headerImageInQRCode.layer.borderWidth = 1;
    self.headerImageInQRCode.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headerImageInQRCode.layer.masksToBounds = YES;
    self.headerImageInQRCode.layer.cornerRadius = 2;

    [self.codeImgView setFrame:CGRectMake(_manageView.frame.size.width/2-self.codeImgView.frame.size.width/2, self.self.codeImgView.frame.origin.y, self.codeImgView.frame.size.width, self.codeImgView.frame.size.height)];
    
    [self.headImgView setFrame:CGRectMake(_manageView.frame.size.width/2-50, self.headImgView.frame.origin.y, 100, 100)];
    UIImageView *head_Vip_view=[[UIImageView alloc]initWithFrame:CGRectMake(self.headImgView.frame.origin.x+self.headImgView.frame.size.width-20, self.headImgView.frame.origin.y+self.headImgView.frame.size.height-25, 20, 20)];
    [head_Vip_view setImage:[UIImage imageNamed:@"peoplevip@2x"]];
    if(UI_SCREEN_WIDTH>375)
    {
        [head_Vip_view setFrame:CGRectMake(head_Vip_view.frame.origin.x-5, head_Vip_view.frame.origin.y, head_Vip_view.frame.size.width, head_Vip_view.frame.size.height)];
    }
    head_Vip_view.layer.cornerRadius=head_Vip_view.frame.size.width/ 2;
    head_Vip_view.layer.borderWidth = 1.0;
    head_Vip_view.layer.borderColor = [UIColor whiteColor].CGColor;
    head_Vip_view.layer.masksToBounds = YES;
    [_manageView addSubview:head_Vip_view];
    
    
    self.headImgView.layer.masksToBounds=YES;
    self.headImgView.layer.cornerRadius =self.headImgView.frame.size.width/2;
    self.headImgView.layer.borderColor = [UIColor clearColor].CGColor;//Utils HexColor:0xc7c7c7 Alpha:1.0
    self.headImgView.layer.borderWidth =1.0;
    self.headImgView.backgroundColor = TITLE_BG;
    //    //用户头像
    if (download_lock==nil){
        download_lock=[[NSCondition alloc] init];
        self.headImgView.image = [UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];
        self.headerImageInQRCode.image = [UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];
        
        self.staffFull.photo_path =[Utils getSNSString:self.staffFull.photo_path];
        
        UIImage *img1= [Utils getImageAsyn:self.staffFull.photo_path path:[AppSetting getSNSHeadImgFilePath] downloadLock:download_lock ImageCallback:^(UIImage * image,NSObject *recv_img_id){
            NSString *r_id=(NSString *)recv_img_id;
            if ([r_id isEqualToString:[Utils fileNameHash:self.staffFull.photo_path]])
            {
                self.headImgView.contentMode=UIViewContentModeScaleAspectFill;//UIViewContentModeScaleAspectFit;
                self.headImgView.image=image;
                self.headerImageInQRCode.contentMode=UIViewContentModeScaleAspectFit;
                self.headerImageInQRCode.image = image;
            }
        } ErrorCallback:^{
        }];
        if (img1!=nil){
            self.headImgView.image=img1;
            self.headerImageInQRCode.image = img1;
        }
   }
    
    self.staffFull.ldap_uid=[Utils getSNSString:self.staffFull.ldap_uid];
    NSString *myQCard=[NSString stringWithFormat:@"fun_%@",self.staffFull.ldap_uid];
    self.codeImgView.image = [QRCodeGenerator qrImageForString:myQCard imageSize: self.codeImgView.bounds.size.width];

    self.codeImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCodeImage:)];
    [self.codeImgView addGestureRecognizer:singleTap];

}

- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//    UIView *tempView;
//    CGRect navRect = self.navigationController.navigationBar.frame;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    self.title=@"我的二维码";
//    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
//    
//    
//    UIButton *tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
//    [tempBtn setTitle:@"我的二维码" forState:UIControlStateNormal];
//    tempBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
//    tempBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [tempView addSubview:tempBtn];
//    // default40@2x.9
//    
//    
//    self.navigationItem.titleView = tempView;
}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}

-(void)clickCodeImage:(id)sender
{

    UIActionSheet *actonsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到本地", nil];
    [actonsheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(_codeImgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error != NULL){
    }else{
//        [Toast makeToast:@"图片保存图片成功" duration:1 position:nil];
        [Toast makeToastSuccess:@"图片保存图片成功"];
    }
    
}
-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
