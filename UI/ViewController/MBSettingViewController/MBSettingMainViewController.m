//
//  MBSettingMainViewController.m
//  Wefafa
//
//  Created by wave on 15/5/25.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "MBSettingMainViewController.h"
#import "Utils.h"
#import "NetUtils.h"
#import "Toast.h"
#import "AppSetting.h"
#import "Globle.h"
#import "SQLiteOper.h"
#import "SDataCache.h"
#import "MBMyQCodeViewController.h"
#import "AlreadyBinDingBankCardViewController.h"
#import "MyAdderssViewController.h"
#import "MBChangeUserNameViewController.h"
#import "MBChangeDescriptionViewController.h"
#import "SUtilityTool.h"
#import "SMBRedPacketViewController.h"
#import "MBSettingViewController.h"
#import "ModifyPasswordViewController.h"
#import "SHomeViewController.h"
@interface MBSettingMainViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImageView *headerView;
    BOOL needReload;
    UITableView *settingTable;
     NSCondition *download_lock;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MBSettingMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    settingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    [settingTable setDataSource:self];
    [settingTable setDelegate:self];
    [settingTable setBackgroundColor:[Utils HexColor:0XF2F2F2 Alpha:1.0]];
    [self.view addSubview:settingTable];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavbar];
    if (needReload) {
        [settingTable reloadData];
    }
    needReload = NO;
}

- (void)setupNavbar {
    [super setupNavbar];
    [self.navigationController setNavigationBarHidden:NO
     ];
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIView *tempView;
    CGRect navRect = self.navigationController.navigationBar.frame;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;

    
    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    nameLabel.text=@"个人设置";
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.textColor=[UIColor whiteColor];
//    nameLabel.textColor = UIColorFromRGB(0xffffff);
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
//    System Bold
//    Helvetica-Bold
    [tempView addSubview:nameLabel];

    self.navigationItem.titleView = tempView;
    self.title=@"个人设置";
}


- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}


#pragma mark - uitableview  datasource delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNum = 0;
    switch (section) {
        case 0:
            rowNum = 3;
            break;
        case 1:
        {
            if (sns.isThirdLogin) {
                rowNum=4;//5
            }
            else
            {
               rowNum = 5;//6
            }
        }
            break;
        case 2:
            rowNum = 1;
            break;
        default:
            break;
    }
    return rowNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }
    return 10;
}

- (NSString *)cellTitleIndexSection:(NSInteger)section row:(NSInteger)row
{
    NSString *title = @"";
    if (section == 0) {
        NSArray *array = @[@"头像",@"昵称",@"个性签名"];
        title = [array objectAtIndex:row];
    }else if (section == 1){
        NSArray *array;
        if (sns.isThirdLogin) {
//            array = @[@"我的收货地址",@"我的二维码",@"我的银行卡",@"我的范票",@"我的推广码"];
              array = @[@"我的地址",@"我的二维码",@"我的范票",@"我的推广码"];//,@"我的银行卡"
        }
        else
        {
//            array = @[@"我的收货地址",@"我的二维码",@"我的银行卡",@"我的范票",@"我的推广码",@"修改密码"];
               array = @[@"我的地址",@"我的二维码",@"我的范票",@"我的推广码",@"修改密码"];
        }
        title = [array objectAtIndex:row];
    }else{
        title=@"退出账号";
    }
    return title;
}

- (NSString *)cellAccessImageNameWithIndex:(NSInteger)row section:(NSInteger)section
{
    NSString *imageName = @"";
    if (section == 1) {
        NSArray *array=[NSArray new];
        
        if(sns.isThirdLogin)
        {
            
            array = @[@"myAddress",@"myCode",@"myIncom",@"myInvite"];
//             array = @[@"Unico/iconfont_shouhuodizhi",@"Unico/iconfont_erweima",@"Unico/ico_fanpiao",@"Unico/ico_invite"];
        }
        else
        {
         array = @[@"myAddress",@"myCode",@"myIncom",@"myInvite",@"moditifyPassWord"];
//            array = @[@"Unico/iconfont_shouhuodizhi",@"Unico/iconfont_erweima",@"Unico/ico_fanpiao",@"Unico/ico_invite",@"Unico/iconfont_wodehongbaoicon"];
        }

        
//        array = @[@"Unico/iconfont_shouhuodizhi",@"Unico/iconfont_erweima",@"Unico/iconfont_yinxingqia",@"Unico/ico_fanpiao",@"Unico/ico_invite",@"Unico/iconfont_wodehongbaoicon"];
       
        imageName = [array objectAtIndex:row];
    }else{
        imageName = @"Unico/iconfont_shezhi_2";
    }
    return imageName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ReuseCell = @"ReuseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseCell];
    
//    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseCell];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 15,UI_SCREEN_WIDTH - 90 , 20)];
        [label1 setTag:200];
        [label1 setBackgroundColor:[UIColor whiteColor]];
        [label1 setTextAlignment:NSTextAlignmentRight];
        [label1 setFont:[UIFont systemFontOfSize:14.0]];
        [label1 setTextColor:[Utils HexColor:0XE2E2E2 Alpha:1.0]];
        [cell.contentView addSubview:label1];
    
    UIImageView *imageview1=[[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-15-7,18, 7, 14)];
    [imageview1 setTag:300];
    [imageview1 setImage:[UIImage imageNamed:@"Unico/arrow_address"]];
    [cell.contentView addSubview:imageview1];
//    }
//    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:100];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:200];
    UIImageView *arroimIgView = (UIImageView *)[cell.contentView viewWithTag:300];
    NSString *detailStr = @"";
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            if (!imgView) {
                imgView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 60, 7, 45, 45)];
                [imgView.layer setCornerRadius:45.0/2.0];
                [imgView setContentMode:UIViewContentModeScaleToFill];
                [imgView setClipsToBounds:YES];
                [imgView setTag:100];
                [cell.contentView addSubview:imgView];
            }
            headerView = imgView;
            [headerView sd_setImageWithURL:[NSURL URLWithString:sns.myStaffCard.photo_path] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
            
//            UIImage* img1= [Utils getImageAsyn:sns.myStaffCard.photo_path_big path:[AppSetting getSNSHeadImgFilePath] downloadLock:download_lock ImageCallback:^(UIImage * image,NSObject *recv_img_id){
//                NSString *r_id=(NSString *)recv_img_id;
//                
//                if ([r_id isEqualToString:[Utils fileNameHash:sns.myStaffCard.photo_path_big]])
//                {
//                    //                        headImage.contentMode=UIViewContentModeScaleAspectFit;
//                    headerView.image=image;
//                }
//            } ErrorCallback:^{
//                NSLog(@"错误----");
//                headerView.image = [UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];
//            }];
//            if (img1!=nil) {
//                headerView.image=img1;
//                
//            }
            
        }else if (indexPath.row == 1){
            detailStr = sns.myStaffCard.nick_name;
        }else{
            detailStr = sns.myStaffCard.self_desc;
        }
    }
    else if (indexPath.section==2)
    {
        [arroimIgView  setImage:nil];
         label.hidden=YES;
         cell.textLabel.textAlignment=NSTextAlignmentCenter;
         [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    else{
        
        if (imgView) {
            [imgView removeFromSuperview];
            imgView = nil;
        }
        NSString *imageName = [self cellAccessImageNameWithIndex:indexPath.row section:indexPath.section];
        [cell.imageView setImage:[UIImage imageNamed:imageName]];
    }
    [label setText:detailStr];
    [label setTextColor:COLOR_C6];
    [label setFont:[UIFont systemFontOfSize:13.0f]];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [cell.textLabel setText:[self cellTitleIndexSection:indexPath.section row:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0 && !sns.isThirdLogin) {
        
        UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
        [action showInView:self.view];
        
    }else{
        needReload = YES;
    }
//    if (indexPath.section == 2) {   //二级设置页面
//        MBSettingViewController *setVC = [NSClassFromString(@"MBSettingViewController") new];
//        [self pushController:(SBaseViewController*)setVC animated:YES];
//    }
    if (indexPath.section == 1 && indexPath.row == 1) {  //我的二维码
        MBMyQCodeViewController *qrcVC = [MBMyQCodeViewController new];
        qrcVC.staffFull = sns.myStaffCard;
        [self pushController:qrcVC animated:YES];
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 0) { //收货地址
        MyAdderssViewController *addVC = [MyAdderssViewController new];
        [self pushController:(SBaseViewController*)addVC animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 1 && !sns.isThirdLogin) { //昵称
        MBChangeUserNameViewController *nameVC = [[MBChangeUserNameViewController alloc]initWithNibName:@"MBChangeUserNameViewController" bundle:nil];
        nameVC.currentName = sns.myStaffCard.nick_name;
        [self pushController:nameVC animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 2 && !sns.isThirdLogin) { //个性签名
        MBChangeDescriptionViewController *mbChangeDes=[[MBChangeDescriptionViewController alloc]initWithNibName:@"MBChangeDescriptionViewController" bundle:nil];
        [self pushController:mbChangeDes animated:YES];
        return;
    }if (indexPath.section == 1 && indexPath.row == 21) {    //我的银行卡
        AlreadyBinDingBankCardViewController *controller = [[AlreadyBinDingBankCardViewController alloc]initWithNibName:@"AlreadyBinDingBankCardViewController" bundle:nil];
        controller.myBankCardArray = nil;//self.myBankCardArray;
        UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:controller];
        [self presentViewController:navigation animated:YES completion:^{
            
        }];
        return;
    }if (indexPath.section == 1 && indexPath.row == 2) {    //红包

        SMBRedPacketViewController *redPacketVC=[[SMBRedPacketViewController alloc]initWithNibName:@"SMBRedPacketViewController" bundle:nil];
        redPacketVC.isFromOrder=NO;
        [self pushController:redPacketVC animated:YES];

        return;
    }if (indexPath.section == 1 && indexPath.row == 3) {    //推广码
        [[SUtilityTool shared] showWebpage:MDTG_URL titleName:@"我的推广码" shareImg:nil];
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 4) {    //修改密码
        if (!sns.isThirdLogin) {
            ModifyPasswordViewController *modifyPwdVC=[[ModifyPasswordViewController alloc] initWithNibName:@"ModifyPasswordViewController" bundle:nil];
            [self pushController:modifyPwdVC animated:YES];
         return;
        }
    }
    if (indexPath.section==2) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"退出登录" message:[NSString stringWithFormat:@"您确定退出当前帐号？"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"取消"];
        [alert show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0) {
        [[AppDelegate App] logout];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[SHomeViewController instance] setSelectedIndex:0];
        [BaseViewController pushLoginViewController];
//
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex");
    
    if ([actionSheet.title isEqualToString:@"选择头像"] && buttonIndex == 0) {  //相机
        [self cameraPhoto];
    }else if ([actionSheet.title isEqualToString:@"选择头像"] && buttonIndex == 1){ //本地
        [self localPhoto];
    }
}

#pragma mark -
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *editimage = [info objectForKey:UIImagePickerControllerEditedImage];
        [headerView setImage:editimage];
        if (editimage != nil) {
            if ([NetUtils connectedToNetwork]&&([NetUtils isWifiConnected]||[NetUtils is3GConnected])) {
                [Toast makeToastActivity:@"头像上传中，请稍等..." hasMusk:YES];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                    //准备头像
                    NSString *createFileName=[NSString stringWithFormat:@"%f.PNG",[NSDate timeIntervalSinceReferenceDate]];
                    NSString *createFilePath=[NSString stringWithFormat:@"%@/%@",[AppSetting getTempFilePath], createFileName];
                    NSData *imagedata = [Utils writeImage:editimage toFileAtPath:createFilePath];
                    
                    //上传头像
                    NSMutableDictionary *fileids=[NSMutableDictionary dictionary];
                    NSString *result=[sns uploadMyHeadPhotoWithFileData:imagedata Fileids:fileids];
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [Toast hideToastActivity];
                        if ([result isEqualToString:SNS_RETURN_SUCCESS]) {
                            
                            NSString *fileIDStr = [NSString stringWithFormat:@"%@",[fileids valueForKey:@"fileid"]];
                            if([fileIDStr hasPrefix:@"http://"]||[fileIDStr hasPrefix:@"https://"])
                            {
//                                sns.myStaffCard.photo_path=[fileids valueForKey:@"photo_path"];
//                                sns.myStaffCard.photo_path_big=[fileids valueForKey:@"fileid"];
//                                sns.myStaffCard.photo_path_small=[fileids valueForKey:@"photo_path_small"];
                                sns.myStaffCard.photo_path_big=[fileids valueForKey:@"photo_path"];
                                sns.myStaffCard.photo_path_small=[fileids valueForKey:@"photo_path"];
                                sns.myStaffCard.photo_path=[fileids valueForKey:@"photo_path"];
                            }
                            else
                            {
                                sns.myStaffCard.photo_path = [sns getHeadImgUrlWithImageName:[fileids valueForKey:@"fileid"] WithSize:0];
                                sns.myStaffCard.photo_path_big=[sns getHeadImgUrlWithImageName:[fileids valueForKey:@"fileid"] WithSize:0];;
                                sns.myStaffCard.photo_path_small=[sns getHeadImgUrlWithImageName:[fileids valueForKey:@"fileid"] WithSize:2];
                         
                            }
                            //所有头像同步改变
                            [self uploadImageUrlWithPHP:sns.myStaffCard.photo_path_big];


                        }else {
                            [Toast hideToastActivity];
                            [self netConnectError:@"上传失败,请稍后重试!"];//头像上传失败
                            [headerView sd_setImageWithURL:[NSURL URLWithString:sns.myStaffCard.photo_path] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
                        }
                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                    });
                });
            } else [self netConnectError:nil];
        }
    }
}

- (void)uploadImageUrlWithPHP:(NSString*)url{
    [[SDataCache sharedInstance] get:@"User" action:@"updateUserImg" param:@{ @"newImg":url} success:^(AFHTTPRequestOperation *operation, id object) {
        NSLog(@"uploadImageUrlWithPHP Suc :%@",object);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noti_loginComplete" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeHeadImgView" object:nil];
        
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"uploadImageUrlWithPHP Error : %@",error);
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

- (void)cameraPhoto
{
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
//        imagepicker.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;
//        imagepicker.mediaTypes = @[(NSString*)kUTTypeImage];
        imagepicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        imagepicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        
        imagepicker.delegate = self;
        imagepicker.allowsEditing = YES;
        imagepicker.showsCameraControls = YES;
        imagepicker.cameraViewTransform = CGAffineTransformMakeRotation(M_PI*45/180);
        imagepicker.cameraViewTransform = CGAffineTransformMakeScale(1.5, 1.5);
        
        [self presentViewController:imagepicker animated:YES completion:nil];
    }
    else
    {
        NSLog(@"该设备无摄像头");
    }
}

- (void)localPhoto
{
    
    NSLog(@"localPhoto");
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    //    [self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH-200)/2.0, 0, 200, 44)];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = viewController.navigationItem.title;
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.font = FONT_T2;
    
    viewController.navigationItem.titleView = titleLabel;
}

-(void)netConnectError:(NSString *)msg
{
    UIAlertView *alert=nil;
    if (msg!=NULL && msg.length>0) {
        [Toast hideToastActivity];
        alert =[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    }
    else alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"无法连接服务器，请稍后重试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [alert setTag:10000];
    [alert show];
}

@end
