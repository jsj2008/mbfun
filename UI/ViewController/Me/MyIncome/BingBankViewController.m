//
//  BingBankViewController.m
//  Wefafa
//
//  Created by fafatime on 14-8-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "BingBankViewController.h"
#import "MBShoppingGuideInterface.h"
#import "Base.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"
#import "NavigationTitleView.h"
@interface BingBankViewController ()
{
    UIScrollView *backScrollView;
    UITextField *nameTextField;
    UILabel *bankchooseLabel;
    UITextField *cardnameTextField;
    NSMutableDictionary *requestBankDic;
    NSArray *pickData;
    UIPickerView*pickerView;
    UIView *toolView;
    NSInteger selectInt;
    NSString *chooseSt;
    UILabel *cardnameLabel;
    UILabel *banknameLabel;
    UILabel *bingnameLabel;
    UIButton *doneBtn;
    UIAlertView *alertV;
//    UITextField *newTextField;
    
}
@end

@implementation BingBankViewController
@synthesize titleName;
@synthesize transDic;

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
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"绑定银行卡";
    [self.headView addSubview:view];
    requestBankDic = [[NSMutableDictionary alloc]init];
    
    _nameLabel.text=titleName;
    
    backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64)];
    [backScrollView setContentSize:CGSizeMake(0, 600)];
    [self.view addSubview:backScrollView];
    bingnameLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 5,196, 25)];
    bingnameLabel.text=@"绑定人姓名";
    bingnameLabel.backgroundColor=[UIColor clearColor];
    bingnameLabel.textAlignment=NSTextAlignmentLeft;
    [backScrollView addSubview:bingnameLabel];
    nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 35, UI_SCREEN_WIDTH-20, 30)];
    nameTextField.layer.masksToBounds = YES;
    nameTextField.layer.cornerRadius = 6.0;
    nameTextField.layer.borderWidth = 1.0;
    nameTextField.delegate=self;
    nameTextField.backgroundColor=[UIColor whiteColor];
    [nameTextField becomeFirstResponder];
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
//    [nameTextField setBackground:[UIImage imageNamed:@"SearchBackground.png"]];
    nameTextField.placeholder=@"请输入您要绑定的姓名";
    nameTextField.textAlignment=NSTextAlignmentLeft;
    nameTextField.textColor=[UIColor blackColor];
    [backScrollView addSubview:nameTextField];
    
    banknameLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 70,196, 25)];
    banknameLabel.text=@"绑定银行卡开户行";
    banknameLabel.backgroundColor=[UIColor clearColor];
    banknameLabel.textAlignment=NSTextAlignmentLeft;
    [backScrollView addSubview:banknameLabel];
    
    cardnameLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 135,196, 25)];
    cardnameLabel.text=@"绑定银行卡卡号";
    cardnameLabel.backgroundColor=[UIColor clearColor];
    cardnameLabel.textAlignment=NSTextAlignmentLeft;
    [backScrollView addSubview:cardnameLabel];
    
    cardnameTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 165, UI_SCREEN_WIDTH-20, 30)];
    nameTextField.secureTextEntry=NO;
    cardnameTextField.secureTextEntry=NO;//输入密码为星号
    cardnameTextField.layer.masksToBounds = YES;
    cardnameTextField.layer.cornerRadius = 6.0;
    cardnameTextField.layer.borderWidth = 1.0;
    cardnameTextField.backgroundColor=[UIColor whiteColor];
    cardnameTextField.borderStyle = UITextBorderStyleRoundedRect;
//    [cardnameTextField setBackground:[UIImage imageNamed:@"SearchBackground.png"]];
    cardnameTextField.placeholder=@"请输入您的银行卡号";
    cardnameTextField.textAlignment=NSTextAlignmentLeft;
    cardnameTextField.textColor=[UIColor blackColor];
    cardnameTextField.delegate=self;
    [backScrollView addSubview:cardnameTextField];
    
    doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setBackgroundColor:[UIColor colorWithRed:72/255.0 green:187/255.0 blue:11/255.0 alpha:1]];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setFrame:CGRectMake(5, 250, UI_SCREEN_WIDTH-10, 40)];
    [doneBtn addTarget:self
                action:@selector(doneBtnClick:)
      forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:doneBtn];
    
    if ([titleName isEqualToString:@"绑定银行卡"])
    {
        [self bingBankCard];
    }
    else
    {
        [self changePassWord];
    }
    
}
-(void)changePassWord
{
    bingnameLabel.text=@"请输入六位旧密码";
    banknameLabel.text=@"请输入六位新密码";
    cardnameLabel.text=@"请再次输入新密码";
    nameTextField.secureTextEntry=YES;
    cardnameTextField.secureTextEntry=YES;
    cardnameTextField.placeholder =@"请再次输入六位新密码";
    nameTextField.placeholder=@"请输入六位旧密码";
    UITextField *newTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, UI_SCREEN_WIDTH-20, 30)];
    newTextField.delegate=self;
    newTextField.layer.masksToBounds = YES;
    newTextField.layer.cornerRadius = 6.0;
    newTextField.layer.borderWidth = 1.0;
    newTextField.secureTextEntry=YES;
    newTextField.placeholder=@"请输入六位新密码";
    newTextField.borderStyle = UITextBorderStyleRoundedRect;
//    [newTextField setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SearchBackground.png"]]];
    newTextField.textAlignment=NSTextAlignmentLeft;
    newTextField.textColor=[UIColor blackColor];
    newTextField.userInteractionEnabled=YES;
    [backScrollView addSubview:newTextField];
    
    NSString *oldPass=[NSString stringWithFormat:@"%@",[[self.transDic objectForKey:@"responseMsg"]objectForKey:@"casH_PASSWORD"]];
    if (oldPass==nil||[[oldPass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual:@""])
    {
        bingnameLabel.hidden=YES;
        nameTextField.hidden=YES;
        [banknameLabel setFrame:CGRectMake(5, 5,196, 25)];
        [cardnameLabel setFrame:CGRectMake(5, 70,196, 25)];
        [newTextField setFrame:CGRectMake(10, 35, UI_SCREEN_WIDTH-20, 30)];
        [cardnameTextField setFrame:CGRectMake(10, 100, UI_SCREEN_WIDTH-20, 30)];
        [doneBtn setFrame:CGRectMake(5, 160, UI_SCREEN_WIDTH-10, 40)];
    }
    else
    {
//       nameTextField.text=[NSString stringWithFormat:@"%@",]
    }
}
-(void)bingBankCard
{
    bankchooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, UI_SCREEN_WIDTH-20, 30)];
    bankchooseLabel.layer.masksToBounds = YES;
    bankchooseLabel.layer.cornerRadius = 6.0;
    bankchooseLabel.layer.borderWidth = 1.0;
//    [bankchooseLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SearchBackground.png"]]];
    [bankchooseLabel setBackgroundColor:[UIColor whiteColor]];
    
    bankchooseLabel.textAlignment=NSTextAlignmentLeft;
    bankchooseLabel.textColor=[UIColor blackColor];
    
    bankchooseLabel.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapChooseLabel)];
    [bankchooseLabel addGestureRecognizer:tap];
    [backScrollView addSubview:bankchooseLabel];
    UILabel *boxLabel =[[UILabel alloc]initWithFrame:CGRectMake(5, 210, 100, 30)];
    [boxLabel setBackgroundColor:[UIColor clearColor]];
    boxLabel.text=@"是否默认";
    [backScrollView addSubview:boxLabel];
    
    [self initCheckboxWithCell];

    NSString *st = @"BaseBankFilter";
    pickData=[[NSArray alloc]init];
    NSMutableString *returnMsg=[[NSMutableString alloc]init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:st param:nil responseAll:requestBankDic responseMsg:returnMsg];
        if (success) {
                 pickData = [requestBankDic objectForKey:@"results"];
        }
   
        //银行
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self initPackView];
        });
    });
    

}
-(void)tapChooseLabel
{
    [nameTextField resignFirstResponder];
    [cardnameTextField resignFirstResponder];
    toolView.hidden=NO;
    pickerView.hidden=NO;
    if (pickData!=nil&&[pickData count]>0) {
        bankchooseLabel.text=[NSString stringWithFormat:@"%@",[[pickData objectAtIndex:0] objectForKey:@"name"]];
        cardnameTextField.placeholder = [NSString stringWithFormat:@"%@",[[pickData objectAtIndex:0] objectForKey:@"acC_EXAMPLE"]];
    }
    else
    {
    }
    
}
-(void)initPackView
{
    toolView=[[UIView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-162-44, UI_SCREEN_WIDTH, 44)];
    toolView.hidden=YES;
    [toolView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0  blue:244.0/255.0 alpha:1]];
    [self.view addSubview:toolView];
    
    UIButton *doneBar =[UIButton buttonWithType:UIButtonTypeCustom];
    [doneBar setFrame:CGRectMake(toolView.frame.size.width-80, 0, 80, 44)];
    [doneBar setTitle:@"确定" forState:UIControlStateNormal];
    [doneBar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBar addTarget:self
                action:@selector(doneBtn)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cacleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cacleBtn setFrame:CGRectMake(0, 0, 50, 44)];
    [cacleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cacleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cacleBtn addTarget:self
                 action:@selector(cacleBtn)
       forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:doneBar];
    [toolView addSubview:cacleBtn];
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,UI_SCREEN_HEIGHT-162,UI_SCREEN_WIDTH, 162)];
    pickerView.hidden=YES;
    //    指定Delegate
    pickerView.delegate=self;
    pickerView.dataSource=self;
    [pickerView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0  blue:244.0/255.0 alpha:1]];
    //    显示选中框
    pickerView.showsSelectionIndicator=YES;
    [self.view addSubview:pickerView];
}
#pragma mark -
#pragma mark Picker Date Source Methods

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    return [pickData count];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    return 30.0;
    
}
#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[pickData objectAtIndex:row] objectForKey:@"name"];
}
-(void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component
{
    selectInt = row;
    
    bankchooseLabel.text=[[pickData objectAtIndex:row] objectForKey:@"name"];
    cardnameTextField.placeholder = [NSString stringWithFormat:@"%@",[[pickData objectAtIndex:row] objectForKey:@"acC_EXAMPLE"]];
    
}
-(void)initCheckboxWithCell {
    
    ckBoxSelfM=[[CCheckBox alloc] initWithFrame:CGRectMake(140,212 ,40, 30) style:CHECKBOX_STYLE_SINGLESELECTED iconSize:tvcLabelFontSize fontSize:tvcLabelFontSize];
    
    [ckBoxSelfM setDelegate:self];
    [ckBoxSelfM setChecked:YES];
    [backScrollView addSubview:ckBoxSelfM];
    
    ckBoxSelfW=[[CCheckBox alloc] initWithFrame:CGRectMake(200, 212, 40, 30) style:CHECKBOX_STYLE_SINGLESELECTED iconSize:tvcLabelFontSize fontSize:tvcLabelFontSize];

    ckBoxSelfM.label.text=@"是";
    ckBoxSelfW.label.text=@"否";
    chooseSt = @"是";
    [ckBoxSelfW setDelegate:self];
    [ckBoxSelfW setChecked:NO];
    [backScrollView addSubview:ckBoxSelfW];

}
-(void)checkBoxClicked:(id)sender {
    CCheckBox *checkbox=(CCheckBox*)sender;
    if (checkbox.style==CHECKBOX_STYLE_SINGLESELECTED)
    {
    
        if (checkbox==ckBoxSelfM) {
            [ckBoxSelfM setChecked:YES];
            [ckBoxSelfW setChecked:NO];
            chooseSt = @"是";
        }else {
            [ckBoxSelfM setChecked:NO];
            [ckBoxSelfW setChecked:YES];
            chooseSt=@"否";
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
        pickerView.hidden=YES;
        toolView.hidden=YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
//    if ([string isEqualToString:@"\n"])  //按会车可以改变
//        
//    {
//        return YES;
//    }
//
    if ([titleName isEqualToString:@"绑定银行卡"])
    {
        return YES;
    }
    else
    {
        
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
        
        if ([toBeString length] > 6) { //如果输入框内容大于6则弹出警告
            
            textField.text = [toBeString substringToIndex:6];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请输入六位密码"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            
            return NO;
            
        }
        
        return YES; 

       
    }
    
}
#pragma toolBar PickDateView
-(void)doneBtn
{
    bankchooseLabel.text=[[pickData objectAtIndex:selectInt] objectForKey:@"name"];
    cardnameTextField.placeholder = [NSString stringWithFormat:@"%@",[[pickData objectAtIndex:selectInt] objectForKey:@"acC_EXAMPLE"]];
    pickerView.hidden=YES;
    toolView.hidden=YES;
}
-(void)cacleBtn
{
    pickerView.hidden=YES;
    toolView.hidden=YES;
}
- (BOOL)groupInfoVerification {
    
    if (nameTextField.text==NULL || [[nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual:@""]) {
        [nameTextField setBackgroundColor: [UIColor colorWithRed:255 green:0 blue:0 alpha:0.5]];
        
        return NO;
    }
    if (bankchooseLabel.text==NULL || [[bankchooseLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual:@""]) {
        
        [bankchooseLabel setBackgroundColor: [UIColor colorWithRed:255 green:0 blue:0 alpha:0.5]];
        
        return NO;
    }
    if(cardnameTextField.text==NULL||[[cardnameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual:@""])
    {

        [cardnameTextField setBackgroundColor: [UIColor colorWithRed:255 green:0 blue:0 alpha:0.5]];
        return NO;
        
    }
    [cardnameTextField setBackgroundColor: [UIColor whiteColor]];
    [nameTextField setBackgroundColor: [UIColor whiteColor]];
    [bankchooseLabel setBackgroundColor: [UIColor whiteColor]];
    return YES;
}


-(void)doneBtnClick:(id)sender
{
    return;
//    NSMutableDictionary *retureDic=[[NSMutableDictionary alloc]init];
//    NSMutableString *returnMessage=[[NSMutableString alloc]init];
//    NSDictionary *requestDic=[[NSDictionary alloc]init];
    NSMutableString* returnMsg=[[NSMutableString alloc]init];
    if ([_nameLabel.text isEqualToString:@"绑定银行卡"])
    {
        NSString *st = @"WxSellerCardCreate";
   
        NSDictionary *paramDic = @{@"ACCOUNT_ID":[[self.transDic objectForKey:@"responseMsg"]objectForKey:@"sellerId"],
                                   @"CARD_NO":cardnameTextField.text,
                                   @"CARD_NAME":nameTextField.text,
                                   @"IS_DEFAULT":chooseSt,
                                   @"BANK":[[pickData objectAtIndex:selectInt] objectForKey:@"id"]};
     
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            if (![self groupInfoVerification]) return;
            

            
            BOOL success=[SHOPPING_GUIDE_ITF requestPostUrlName:st param:paramDic responseAll:nil responseMsg:returnMsg];
//            NSLog(@"requestDic-bangding--%hhd--%@",success,requestDic);
            if (success) {
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{

                [Utils alertMessage:returnMsg];
            });

            
        });
    }
    else
    {
        NSString *st = @"WxSellerChangeCashPws";
        NSString  *sellerID=[NSString stringWithFormat:@"%@",[[self.transDic objectForKey:@"responseMsg"]objectForKey:@"sellerId"]];
        NSDictionary *paramDic = @{@"AccountID":sellerID,
                                   @"OldPws":nameTextField.text,
                                   @"NewPws":cardnameTextField.text};
        
        BOOL success=[SHOPPING_GUIDE_ITF requestPostUrlName:st param:paramDic responseAll:nil responseMsg:returnMsg];
//        NSLog(@"requestDic--绑定密码---%@",requestDic);
//        NSString *message = [NSString stringWithFormat:@"%@",[requestDic objectForKey:@"isSuccess"]];
//        NSString *messageStr =[NSString stringWithFormat:@"%@",[requestDic objectForKey:@"message"]];
        alertV = [[UIAlertView alloc]initWithTitle:@"提示"
                                           message:returnMsg
                                          delegate:nil
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"确定", nil];
        [alertV show];
        if (success)
        {
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
        }
        else
        {
//         [Utils alertMessage:[requestDic objectForKey:@"message"]];
        }
    }

}
-(void)dismiss
{
    [alertV dismissWithClickedButtonIndex:0 animated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
-(void)backHome:(UIButton*)sender
{
     [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
