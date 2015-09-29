//
//  EnterpriseLicenceUploadViewController.m
//  Wefafa
//
//  Created by mac on 13-10-25.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "EnterpriseLicenceUploadViewController.h"
#import "Utils.h"
#import "Toast.h"
#import "AppSetting.h"
#import "WeFaFaGet.h"
#import "ASIHTTPRequest.h"
#import "Hash.h"
#import "SQLiteOper.h"

@interface EnterpriseLicenceUploadViewController ()

@end

@implementation EnterpriseLicenceUploadViewController

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
    // Do any additional setup after loading the view from its nib.

    CGRect headrect=CGRectMake(0,0,self.viewHead.frame.size.width,self.viewHead.frame.size.height);
    _titleView = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [_titleView createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:nil selectorMenu:nil];
    _titleView.lbTitle.text=@"企业认证";
//    [_titleView.btnOk setTitle:@"提交" forState:UIControlStateNormal];
    [self.viewHead addSubview:_titleView];
    
    _tableview.separatorColor=VIEW_BACKCOLOR2;
    _tableview.backgroundColor=VIEW_BACKCOLOR2;
    
    UIImage *bgimage = [UIImage imageNamed:@"greenbtn_normal.png"];
    bgimage = [bgimage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [_btnUpload setBackgroundImage:bgimage forState:UIControlStateNormal];
    [_btnUpload setBackgroundImage:bgimage forState:UIControlStateHighlighted];
    
    sections = @[@"", @[_cellTitle]
                 ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableview:nil];
    [self setCellTitle:nil];
    [self setBtnUpload:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return [sections count] / 2;
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return _viewHead.frame.size.height;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return _viewHead;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return _footView.frame.size.height;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return _footView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *tablesection = [sections objectAtIndex:section*2+1];
    return [tablesection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tablesection = [sections objectAtIndex:[indexPath section]*2+1];
    UITableViewCell *cellX = [tablesection objectAtIndex:[indexPath row]];
    NSString *AIdentifier =  [cellX reuseIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AIdentifier];
    if (cell == nil) {
        cell = cellX;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tablesection = [sections objectAtIndex:[indexPath section]*2+1];
    UITableViewCell *cellX = [tablesection objectAtIndex:[indexPath row]];
    float tableheight=cellX.frame.size.height;
    return tableheight;
}

- (IBAction)btnUploadClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
        initWithTitle:@"请选择上传方式"
        delegate:self
        cancelButtonTitle:@"取    消"
        destructiveButtonTitle:@"拍照上传"
        otherButtonTitles:@"从相册中选取",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            picker.mediaTypes = temp_MediaTypes;
            picker.delegate = self;
            //picker.allowsEditing = YES;
            picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:picker animated:YES completion:nil];
            
        }
        else
        {
            //no
        }
    }
    else if (buttonIndex==1)
    {
        UIImagePickerController *imgPickerController = [[UIImagePickerController alloc] init];
        imgPickerController.navigationBar.barStyle = UIBarStyleDefault;
        imgPickerController.delegate=self;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            NSArray *availableMediaTypeArr = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            
            imgPickerController.mediaTypes = availableMediaTypeArr;
            imgPickerController.allowsEditing = YES;
            [self presentViewController:imgPickerController animated:YES completion:nil];

        }
    }
    if (buttonIndex==2)
    {
        
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"])
    {
        //get selected image
        UIImage *selectedImg;
        //一直使用原图，不用修改后的
        //        if (picker.allowsEditing==YES)
        //        {
        //            //camera
        //            selectedImg = [info objectForKey:UIImagePickerControllerEditedImage];
        //        }
        //        else
        {
            //picture
            selectedImg = [info valueForKey:UIImagePickerControllerOriginalImage];
        }
        
        [self sendPictureThread:selectedImg];
        //延时返回
        usleep(300*1000);
    }
}
-(void)sendPictureThread:(UIImage *)selectedImg
{
    [Toast makeToastActivity:@"正在上传证件，请您耐心等待..." hasMusk:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try
        {
            NSString * createFileName=[[NSString alloc] initWithFormat:@"%f.JPG",[NSDate timeIntervalSinceReferenceDate]];
            NSString * createFilePath = [[NSString alloc] initWithFormat:@"%@/%@",[AppSetting getRecvFilePath], createFileName];
            
            
            //缩放及旋转
            UIImage* scaleImage = selectedImg;
            if (selectedImg.size.width > 640)
            {
                float fscale = 640 / selectedImg.size.width;
                CGSize cgsize = CGSizeMake(selectedImg.size.width * fscale, selectedImg.size.height * fscale);
                UIGraphicsBeginImageContext(cgsize);
                [selectedImg drawInRect:CGRectMake(0, 0, cgsize.width, cgsize.height)];
                scaleImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            
            NSData *imagedata=[Utils writeImage:scaleImage toFileAtPath:createFilePath];
            NSString *base64str=[ASIHTTPRequest base64forData:imagedata];
            
            /////////////////////////////////////////
            //改名HASH值
            NSString * NewFileName=[[NSString alloc] initWithFormat:@"%@.JPG",[Hash fileMD5:createFilePath] ];
            NSString * NewFilePath = [[NSString alloc] initWithFormat:@"%@/%@",[AppSetting getRecvFilePath], NewFileName];
            NSError *error = [[NSError alloc] init];
            if ([[NSFileManager defaultManager] fileExistsAtPath:NewFilePath])
                [[NSFileManager defaultManager] removeItemAtPath:NewFilePath error:&error];
            [[NSFileManager defaultManager] moveItemAtPath:createFilePath toPath:NewFilePath error:&error];
            
            
            NSMutableArray *circles=[[NSMutableArray alloc] initWithCapacity:10];
            [sns getCircles:circles];
            [sqlite saveCircles:circles];
            NSString *send_circleid=((SNSCircle *)circles[0]).circle_id;
            
            //上传证件
            NSMutableString *fileid=[[NSMutableString alloc] init];
            NSString *rstStr=[sns uploadFile:NewFileName FileDataBase64:base64str CircleID:send_circleid GroupID:nil FileID:fileid];
            
            //发审核申请
            BOOL rst=NO;
            NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
            if ([rstStr isEqualToString:SNS_RETURN_SUCCESS])
            {
                rstStr=[sns enterpriseAuthFile:fileid returnMsg:msg];
                if ([rstStr isEqualToString:SNS_RETURN_SUCCESS])
                {
                    rst=YES;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast hideToastActivity];
                if (rst)
                    [Toast makeToast:@"证件上传完成，您的身份将在24小时内完成审核！" duration:5.0 position:@"center"];
                else
                {
                    NSString *showmsg=[[NSString alloc] initWithFormat:@"证件上传出错，%@",(msg.length>0?msg:@"上传时请确保您的网络正常！")];
                    [Toast makeToast:showmsg duration:4.0 position:@"center"];
                }
            });
        }
        @catch(NSException *exception)
        {
            NSLog(@"%s Exception Name: %@, Reason: %@", __FUNCTION__, [ exception name ], [ exception reason ]);
        }
    });
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
