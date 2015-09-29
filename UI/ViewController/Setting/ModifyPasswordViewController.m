//
//  ModifyPasswordViewController.m
//  Wefafa
//
//  Created by mac on 14-7-28.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "Base.h"
#import "Toast.h"
#import "WeFaFaGet.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "NavigationTitleView.h"
#import "DetectionSystem.h"
#import "LoginViewController.h"
#import "ModifyPassWordTableViewCell.h"
#import "ForgetPassViewController.h"
#import "CustomAlertView.h"
#import "SHomeViewController.h"
#import "MBToastHud.h"

@interface ModifyPasswordViewController ()<UITextFieldDelegate,CustomAlertViewDelegate>{
    UITextField *oldPass;
    UITextField *newPass;
    UITextField *confimPass;
    UIButton *submitBtn;
    NSArray *titleArray;
    NSArray *placeHodeArray;
    NSMutableArray *writeArray;
    NSString *oldPassW;
    NSString *newPassW;
    NSString *surePassW;
    
    
    
    
}
//@property (weak, nonatomic) IBOutlet UITableView *modifyTabelView;

@end

@implementation ModifyPasswordViewController

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
    titleArray=@[@"旧密码",@"新密码",@"确认密码"];
    placeHodeArray=@[@"请输入旧密码",@"6～12位数字/字母",@"重复新密码"];

    writeArray =[NSMutableArray arrayWithArray:@[@"",@"",@""]];
    oldPassW=writeArray[0];
    newPass=writeArray[1];
    surePassW=writeArray[2];
    
    [self.view setBackgroundColor:[Utils HexColor:0xf2f2f2 Alpha:1]];
    
    UITableView *modifyTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+18, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64-18) style:UITableViewStylePlain];
    modifyTabelView.delegate=self;
    modifyTabelView.dataSource=self;
    modifyTabelView.backgroundColor=[Utils HexColor:0xf2f2f2 Alpha:1];
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44)];
    bottomView.userInteractionEnabled=YES;
    UILabel *forgestLabel=[[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-100, 0, 90, 44)];
    forgestLabel.textColor=[Utils HexColor:0x999999 Alpha:1];
    forgestLabel.font=[UIFont systemFontOfSize:14.0f];
    forgestLabel.text=@"忘记密码?";
    forgestLabel.userInteractionEnabled=YES;
    forgestLabel.textAlignment=NSTextAlignmentRight;
    [bottomView addSubview:forgestLabel];
    modifyTabelView.tableFooterView=bottomView;
    [self.view addSubview:modifyTabelView];
    
    UITapGestureRecognizer *tapGest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(forgetPassword:)];
    [forgestLabel addGestureRecognizer:tapGest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupForDismissKeyboard];
    [self setupNavbar];
    
//    CGFloat yPoint = self.viewHead.frame.size.height;
//    oldPass = [[UITextField alloc] init];
//    [self configSubview:oldPass yPoint:yPoint placeHold:@"输入旧密码"];
//    yPoint += 44;
//    newPass = [[UITextField alloc] init];
//    [self configSubview:newPass yPoint:yPoint placeHold:@"输入新密码"];
//    yPoint += 44;
//    confimPass = [[UITextField alloc] init];
//    [self configSubview:confimPass yPoint:yPoint placeHold:@"确认新密码"];
//    
//    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [submitBtn setFrame:CGRectMake(15, yPoint + 44 + 25, SCREEN_WIDTH - 30, 30)];
//    [submitBtn setBackgroundColor:[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1.0]];
//    [submitBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//    [submitBtn setTitle:@"确认" forState:UIControlStateNormal];
//    [submitBtn.layer setCornerRadius:5.0];
//    [submitBtn.layer setBorderColor:[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1.0].CGColor];
//    [submitBtn setEnabled:NO];
//    [submitBtn.layer setBorderWidth:0.5];
//    [submitBtn addTarget:self action:@selector(btnSaveClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:submitBtn];
}
- (void)setupNavbar {
    [super setupNavbar];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    self.title=@"修改密码";
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(btnSaveClick:)];
    
    self.navigationItem.rightBarButtonItem=right;
    
    
}
-(void)forgetPassword:(id)sender
{
    ForgetPassViewController *forgetPassvc = [[ForgetPassViewController alloc] init];
    [self.navigationController pushViewController:forgetPassvc animated:YES];
}
- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
- (void)configSubview:(UITextField *)field yPoint:(CGFloat)yPoint placeHold:(NSString *)placeHold
{
    return;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, yPoint, UI_SCREEN_WIDTH , 44)];
    [view setBackgroundColor:[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1.0]];
    [field setFrame:CGRectMake(0, 0, SCREEN_WIDTH , 43.5)];
    [field setBackgroundColor:[UIColor whiteColor]];
    [field setPlaceholder:placeHold];
    [field setFont:[UIFont systemFontOfSize:15]];
    [field setDelegate:self];
    [field setSecureTextEntry:YES];
    [view addSubview:field];
    [self.view addSubview:view];
}

#pragma mark table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModifyPassWordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ModifyPassWordTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.headLabel.text=titleArray[indexPath.row];
    cell.writeTextField.placeholder=placeHodeArray[indexPath.row];
    cell.writeTextField.text=writeArray[indexPath.row];
    cell.writeTextField.delegate=self;
    cell.writeTextField.tag=indexPath.row;
    
    return cell;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length==1) {
        //这是删除键
    }
    else
    {
        if (textField.text.length>11) {
            return NO;
        }
    }
    if ([string isEqualToString:@"\n"]) {
        
        [textField resignFirstResponder];
        return NO;
    }
    NSString *toBeString=[textField.text stringByReplacingCharactersInRange:range withString:string];

    if (textField.tag==1) {
        
        if ([toBeString length] > 12) {
            textField.text = [toBeString substringToIndex:12];//(第n 位不算再内)
            toBeString=textField.text;
        }
    }
    [writeArray replaceObjectAtIndex:textField.tag withObject:[Utils getSNSString:toBeString]];

    switch (textField.tag) {
        case 0:
        {
            oldPassW = [NSString stringWithFormat:@"%@",writeArray[0]];
        }
            break;
        case 1:
        {
            newPassW= writeArray[1];
        }
            break;
        case 2:
        {
            surePassW= writeArray[2];
        }
            break;
            
        default:
            break;
    }
    return YES;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length>11) {
        textField.text = [textField.text substringToIndex:12];
    }
    return;
    if ([textField isEqual:oldPass]) {
        if ([newPass.text length] > 0 && [confimPass.text length] > 0) {
            [submitBtn setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]];
            [submitBtn setEnabled:YES];
        }
    }else if ([textField isEqual:newPass]){
        if ([oldPass.text length] > 0 && [confimPass.text length] > 0) {
            [submitBtn setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]];
            [submitBtn setEnabled:YES];
        }
    }else{
        if ([newPass.text length] > 0 && [oldPass.text length] > 0) {
            [submitBtn setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]];
            [submitBtn setEnabled:YES];
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length>11) {
        textField.text = [textField.text substringToIndex:12];
    }
    return;
    if ([oldPass.text length] <= 0 || [newPass.text length] <= 0 || [confimPass.text length] <=0) {
        [submitBtn setBackgroundColor:[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1.0]];
        [submitBtn setEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) autoMovekeyBoard: (float) h
{
//    CGRect screenRect=[[UIScreen mainScreen] bounds ];
//    const float movementDuration = 0.3f;
//    [UIView beginAnimations: @"anim" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    
////	_scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, (float)(screenRect.size.height-h-_scrollView.frame.origin.y));
//    
//    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    //    NSLog(@">>>>>>>>>keyboardRect.size.height=%f",keyboardRect.size.height); //216,252
    [self autoMovekeyBoard:keyboardRect.size.height];
    
}

- (void)keyboardWillHide:(NSNotification *)notification{
    // 恢复原理的大小
    
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self autoMovekeyBoard: 0];
}

- (void)setupForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)validatePassWord:(NSString *)passWord
{
    //只含有汉字、数字、字母
    //    NSString *phoneRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";//^[a-zA-Z0-9_\u4e00-\u9fa5]+$ 可加下划线位置不限
    //    1-18位 不能全部为数字 不能全部为字母 必须包含字母和数字
    //    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSString *regex =   @"^[0-9A-Za-z]{6,12}+$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [phoneTest evaluateWithObject:passWord];
}
- (void)btnSaveClick:(id)sender {
    if (oldPassW.length==0) {
        CustomAlertView *alertView=[[CustomAlertView alloc]initWithImage:@"Unico/warning" msg:@"请输入旧密码!" rightBtnTitle:nil leftBtnTitle:nil delegate:self];
        alertView.customDelegate=self;
        [alertView show];
        
        return;
    }
    if ([DetectionSystem isEmpty:[newPassW stringByReplacingOccurrencesOfString:@" " withString:@""]])
    {
        CustomAlertView *alertView=[[CustomAlertView alloc]initWithImage:@"Unico/warning" msg:@"请输入新密码!" rightBtnTitle:nil leftBtnTitle:nil delegate:self];
        [alertView show];
        return;
    }
    BOOL isPassWordMatch ;
    isPassWordMatch= [self validatePassWord:newPassW];
    if (!isPassWordMatch) {
        CustomAlertView *alertView=[[CustomAlertView alloc]initWithImage:@"Unico/warning" msg:@"密码由6-12位的数字或字母组成" rightBtnTitle:nil leftBtnTitle:nil delegate:self];
        [alertView show];
        return;
    }
    if ([DetectionSystem isEmpty:surePassW])
    {
        CustomAlertView *alertView=[[CustomAlertView alloc]initWithImage:@"Unico/warning" msg:@"请确认新密码!" rightBtnTitle:nil leftBtnTitle:nil delegate:self];
        [alertView show];
        return;
    }
    if (![[newPassW stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:surePassW])
    {
        CustomAlertView *alertView=[[CustomAlertView alloc]initWithImage:@"Unico/warning" msg:@"两次输入密码不一致！" rightBtnTitle:nil leftBtnTitle:nil delegate:self];
        [alertView show];
        return;
    }
    if ([[newPassW stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:oldPassW])
    {
        CustomAlertView *alertView=[[CustomAlertView alloc]initWithImage:@"Unico/warning" msg:@"新旧密码一致！" rightBtnTitle:nil leftBtnTitle:nil delegate:self];
        [alertView show];
        return;
    }
    /*
    if (oldPass.text.length==0)
    {
       [Utils alertMessage:@"请输入原密码！"];
        
        return;
    }
    if ([DetectionSystem isEmpty:[newPass.text stringByReplacingOccurrencesOfString:@" " withString:@""]])
    {
        [Utils alertMessage:@"请输入新密码！"];
        return;
    }
    if ([DetectionSystem isEmpty:confimPass.text])
    {
        [Utils alertMessage:@"请确认新密码！"];
        return;
    }
    if (![[newPass.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:confimPass.text])
    {
        [Utils alertMessage:@"新密码两次输入不一致！"];
        return;
    }
    if ([[newPass.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:oldPass.text])
    {
        [Utils alertMessage:@"新旧密码一致！"];
        return;
    }
    */
    
    NSMutableString *returnMsg=[[NSMutableString alloc] initWithCapacity:20];
    [Toast makeToastActivity:@"正在提交，请稍等..." hasMusk:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *result= [sns modifyPassword:oldPass.text newpwd:[newPass.text stringByReplacingOccurrencesOfString:@" " withString:@""] returnMsg:returnMsg];
          NSString *result= [sns modifyPassword:oldPassW newpwd:[newPassW stringByReplacingOccurrencesOfString:@" " withString:@""] returnMsg:returnMsg];
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast hideToastActivity];
            if ([result isEqualToString:SNS_RETURN_SUCCESS]) {
                if (returnMsg.length==0) {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"修改成功，请重新登录！"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    alert.tag = 1001;
                    [alert show];
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:returnMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    alert.tag = 1001;
                    [alert show];
                  
                }

            }else{
                if(returnMsg.length==0)
                {
//                   [Utils alertMessage:@"修改密码失败"];
//                    CustomAlertView *alertView=[[CustomAlertView alloc]initWithImage:@"Unico/fail" msg:@"修改密码失败" rightBtnTitle:nil leftBtnTitle:nil delegate:self];
//                    [alertView show];
                
                    [MBToastHud show:@"修改密码失败" image:[UIImage imageNamed:@"Unico/fail"] spin:NO hide:YES Interaction:NO];
                }
                else
                {
//                   [Utils alertMessage:returnMsg];
//                    CustomAlertView *alertView=[[CustomAlertView alloc]initWithImage:@"Unico/fail" msg:returnMsg rightBtnTitle:nil leftBtnTitle:nil delegate:self];
//                    [alertView show];
                    [MBToastHud show:returnMsg image:[UIImage imageNamed:@"Unico/fail"] spin:NO hide:YES Interaction:NO];
                    
                }
            }
        });
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1001)  //注销
    {
        if (buttonIndex==0) {
//            [[AppDelegate App] logout];
//            [self.tabBarController setSelectedIndex:0];
//            [self.navigationController popToRootViewControllerAnimated:YES];
////            [[AppDelegate App] logout];
//            [BaseViewController pushLoginViewController];
//            
            [[AppDelegate App] logout];
        
            [self.navigationController popToRootViewControllerAnimated:NO];
                [[SHomeViewController instance] setSelectedIndex:0];
            [BaseViewController pushLoginViewController];
        }
    }
   
    
}

- (IBAction)txtDidEndOnExit:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)DoneBtnClick:(id)sender {
    if (oldPass.text.length==0)
    {
        [Utils alertMessage:@"请输入原密码！"];
        return;
    }
    if ([[newPass.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]==0)
    {
        [Utils alertMessage:@"请输入新密码！"];
        return;
    }
    if (confimPass.text.length==0)
    {
        [Utils alertMessage:@"请确认新密码！"];
        return;
    }
    if ([[newPass.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:confimPass.text]==NO)
    {
        [Utils alertMessage:@"新密码两次输入不一致！"];
        return;
    }
    
    NSMutableString *returnMsg=[[NSMutableString alloc] initWithCapacity:20];
    [Toast makeToastActivity:@"正在提交，请稍等..." hasMusk:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *result= [sns modifyPassword:oldPass.text newpwd:[newPass.text stringByReplacingOccurrencesOfString:@" " withString:@""] returnMsg:returnMsg];
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast hideToastActivity];
            if ([result isEqualToString:SNS_RETURN_SUCCESS]) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"修改成功，请重新登录！"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alert.tag = 1001;
                [alert show];
//                [self.navigationController popViewControllerAnimated:YES];
                [self popToRootAnimated:YES];
                
            }else{
                [Utils alertMessage:returnMsg];
            }
        });
    });

}

@end
