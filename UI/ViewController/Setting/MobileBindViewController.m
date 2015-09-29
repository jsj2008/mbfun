//
//  MobileBindViewController.m
//  Wefafa
//
//  Created by fafa  on 13-9-13.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "MobileBindViewController.h"
#import "AppDelegate.h"
#import "WeFaFaGet.h"
#import "Utils.h"

#import "NavigationTitleView.h"


@interface MobileBindViewController ()

@end

@implementation MobileBindViewController

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
    NavigationTitleView *titleView = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [titleView createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:nil selectorMenu:nil];
    titleView.lbTitle.text=@"手机号绑定";
    [self.viewHead addSubview:titleView];
    
    _btnGetVaildCode.backgroundColor = [UIColor blackColor];
    _btnBind.backgroundColor = TITLE_BG;
    
    
    sections = @[@"请输入手机号并获取验证码", @[_mobileTableViewCell, _vaildcodeTableViewCell],
                 @"_bind", @[_bindTableViewCell]
                 ];
//    [sections retain];
    
//    UIImage *imgBindBG = [UIImage imageNamed: @"注册选中.png"];
//    [_btnBind setBackgroundImage:[imgBindBG stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    
    [_tvBindMobile setBackgroundColor:VIEW_BACKCOLOR2];
    _tvBindMobile.backgroundView=nil;
}
- (void)viewDidUnload {
    [self setMobileTableViewCell:nil];
    [self setVaildcodeTableViewCell:nil];
    [self setBindTableViewCell:nil];
    [self setTxtMobile:nil];
    [self setBtnGetVaildCode:nil];
    [self setTipGetVaildCode:nil];
    [self setTxtVaildCode:nil];
    [self setViewMsg:nil];
    [self setLblMsg:nil];
    [self setBtnBind:nil];
    [self setTipBind:nil];
    [self setTvBindMobile:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [self setupForDismissKeyboard];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self unsetupForDismissKeyboard];
}

#pragma mark setupForDismissKeyboard

id obKeyboardShow, obKeyboardHide;
- (void)setupForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    obKeyboardShow = [nc addObserverForName:UIKeyboardWillShowNotification
                                     object:nil
                                      queue:mainQuene
                                 usingBlock:^(NSNotification *note){
                                     [self.view addGestureRecognizer:singleTapGR];
                                 }];
    obKeyboardHide = [nc addObserverForName:UIKeyboardWillHideNotification
                                     object:nil
                                      queue:mainQuene
                                 usingBlock:^(NSNotification *note){
                                     [self.view removeGestureRecognizer:singleTapGR];
                                 }];
}

- (void)unsetupForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:obKeyboardShow];
    [nc removeObserver:obKeyboardHide];
    obKeyboardShow = nil;
    obKeyboardHide = nil;
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sections count] / 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headername = [sections objectAtIndex:section*2+0];
    if ([headername characterAtIndex:0] == '_') return nil;
    return headername;
}

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
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tablesection = [sections objectAtIndex:[indexPath section]*2+1];
    UITableViewCell *cellX = [tablesection objectAtIndex:[indexPath row]];
    return cellX.frame.size.height;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _txtMobile)
    {
        [self btnGetVaildCode_OnClick:_btnGetVaildCode];
    }
    else if(textField == _txtVaildCode)
    {
        [self btnBind_OnClick:_btnBind];
    }
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnGetVaildCode_OnClick:(id)sender {
    [_btnGetVaildCode setEnabled:NO];
    [_btnGetVaildCode setTitle:@"获取中..." forState:UIControlStateNormal];
    [_tipGetVaildCode setHidden:NO];
    
    NSString *mobile = _txtMobile.text;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:10];
        [sns mobilebindGetVaildCode:mobile result:result];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([@"1" isEqualToString:result[@"success"]])
            {
                [_txtVaildCode becomeFirstResponder];
                _lblMsg.text = @"短信验证码已发送至您的手机,请查收";
                _txtVaildCode.enabled = YES;
                _btnBind.enabled = YES;
            }
            else
            {
                NSString *msg = result[@"msg"];
                _lblMsg.text = (msg == nil ? @"获取验证码失败" : msg);
            }
            
            [_btnGetVaildCode setEnabled:YES];
            [_btnGetVaildCode setTitle:@"获取验证码" forState:UIControlStateNormal];

            [_tipGetVaildCode setHidden:YES];
            
            _viewMsg.alpha = 0;
            _viewMsg.hidden = NO;
            [UIView animateWithDuration:1
                             animations:^{
                                 _viewMsg.alpha = 1;
                             }
                             completion:^(BOOL finished){
                                 [UIView animateWithDuration:1.5
                                                  animations:^{ _viewMsg.alpha = 0.99;}
                                                  completion:^(BOOL finished){_viewMsg.hidden = YES;}];
                             }];
        });
    });
}

- (IBAction)btnBind_OnClick:(id)sender {
    [_btnBind setEnabled:NO];
    [_btnBind setTitle:@"绑定中..." forState:UIControlStateNormal];
    [_tipBind setHidden:NO];
    
    NSString *mobile = _txtMobile.text;
    NSString *vaildcode = _txtVaildCode.text;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:10];
        [sns mobilebindSave:mobile txtvaildcode:vaildcode result:result];
        dispatch_async(dispatch_get_main_queue(), ^{
            bool willreturn = false;
            if ([@"1" isEqualToString:result[@"success"]])
            {
                _lblMsg.text = @"绑定成功";
                willreturn = true;
                
                NSDictionary *dic=@{@"mobile":_txtMobile.text,@"mobileisbind":@"1"};
                
//                if (_preViewController != nil && [self.parentViewController class]==[MyselfInfoViewController class]) {
//                    [_preViewController performSelector:@selector(reloadMobile:) withObject:dic];
//                }
            }
            else
            {
                NSString *msg = result[@"msg"];
                _lblMsg.text = (msg == nil ? @"绑定失败" : msg);
            }
            
            [_btnBind setEnabled:YES];
            [_btnBind setTitle:@"绑定手机号" forState:UIControlStateNormal];
            [_tipBind setHidden:YES];
            
            _viewMsg.alpha = 0;
            _viewMsg.hidden = NO;
            [UIView animateWithDuration:1
                             animations:^{
                                 _viewMsg.alpha = 1;
                             }
                             completion:^(BOOL finished){
                                 [UIView animateWithDuration:1.5
                                                  animations:^{ _viewMsg.alpha = 0.99;}
                                                  completion:^(BOOL finished){
                                                      _viewMsg.hidden = YES;
                                                      if (willreturn) [self btnBackClick:nil];
                                                  }];
                             }];
        });
    });
}
@end
