//
//  SuggestionFeedbackViewController.m
//  Wefafa
//
//  Created by fafatime on 14/12/5.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "SuggestionFeedbackViewController.h"
#import "NavigationTitleView.h"
#import "MBShoppingGuideInterface.h"
#import "Utils.h"
#import "SUtilityTool.h"
#import "HttpRequest.h"

@interface SuggestionFeedbackViewController ()<UITextViewDelegate>
{
    GCPlaceholderTextView *_suggestionTextView;
    UIButton *submitBtn;
}
@end

@implementation SuggestionFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat yPoint = 0;
    
    [self.view setBackgroundColor:COLOR_C4];
//    CGRect headrect=CGRectMake(0,yPoint,UI_SCREEN_WIDTH,self.naviView.frame.size.height);
//    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
//    [view createTitleView:headrect delegate:self selectorBack:nil selectorOk:nil selectorMenu:nil];
//    view.lbTitle.text=@"设置";
////    [self.naviView addSubview:view];
//    [self.view setBackgroundColor:[UIColor whiteColor]];
//    
//    yPoint += self.naviView.frame.size.height;
//    [self setupNavbar];
    
    _suggestionTextView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(15, 64 + 56, SCREEN_WIDTH - 30, 256)];
    [_suggestionTextView setBackgroundColor:[UIColor whiteColor]];
    _suggestionTextView.placeholder=@"请输入您的宝贵意见~";
//    _suggestionTextView.layer.borderColor = [UIColor colorWithRed:0.918 green:0.918 blue:0.918 alpha:1.0].CGColor;
//    _suggestionTextView.layer.borderColor = [UIColor blackColor].CGColor;
//    _suggestionTextView.layer.borderWidth = 1;
    
    [_suggestionTextView setDelegate:self];
//    _suggestionTextView.layer.borderWidth = 0.5;
//    [_suggestionTextView.layer setCornerRadius:5.0];
//    [_suggestionTextView setContentSize:CGSizeMake(SCREEN_WIDTH - 30, 500)];
    [_suggestionTextView setShowsVerticalScrollIndicator:YES];
    [_suggestionTextView setScrollEnabled:YES];
    [self.view addSubview:_suggestionTextView];
    yPoint += 150;
    
//      CGRect textFrame=[[_suggestionTextView layoutManager]usedRectForTextContainer:[_suggestionTextView textContainer]];
//    [_suggestionTextView setFrame:textFrame];
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setFrame:CGRectMake(10, UI_SCREEN_HEIGHT -60, SCREEN_WIDTH - 20, 40)];
    [submitBtn setBackgroundColor:[Utils HexColor:0xfedc32 Alpha:1.0]];
    [submitBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [submitBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[Utils HexColor:0x3b3b3b Alpha:1.0] forState:UIControlStateNormal];
    [submitBtn.layer setCornerRadius:3.0];
    [submitBtn setEnabled:NO];
    [submitBtn addTarget:self action:@selector(btnOkClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavbar];
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
    self.title=@"意见反馈";
    
//    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
//    
//    
//    UIButton *tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
//    [tempBtn setTitle:@"意见反馈" forState:UIControlStateNormal];
//    tempBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
//    tempBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [tempView addSubview:tempBtn];
    // default40@2x.9
    
    
//    self.navigationItem.titleView = tempView;
}
- (void)onBack:(UIButton*)sender {
    [self unsetupForDismissKeyboard];
    [self unregisterForKeyboardNotifications];
    [self popAnimated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
//    [submitBtn setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]];
    [submitBtn setEnabled:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text length] <= 0) {
//        [submitBtn setBackgroundColor:[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1.0]];
        [submitBtn setEnabled:NO];
    }
}

-(void)btnOkClick:(UIButton*)sender
{
//    if (_suggestionTextView.text.length<10)
//    {
//        [Utils alertMessage:@"请输入您的宝贵意见(至少10个字)！"];
//        return;
//    }
    NSDictionary *param=@{
                          @"userId":sns.ldap_uid,
                          @"opinion":_suggestionTextView.text,
                          @"source":@"ios"
                          };

    [HttpRequest postRequestPath:kMBServerNameTypeUser methodName:@"SysUserOpinionCreate" params:param success:^(NSDictionary *dict) {
        if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
        {
            [Utils alertMessage:@"非常感谢您提出的宝贵意见！"];
            [self btnHome:nil];
        }
        else
        {
            [Utils alertMessage:@"意见提交失败！"];
        }
    } failed:^(NSError *error) {
        
        [Utils alertMessage:@"意见提交失败！"];
    }];
    /*
     NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
     
    @try {
        BOOL success=[SHOPPING_GUIDE_ITF requestPostUrlName:@"SysUserOpinionCreate" param:param responseAll:nil responseMsg:msg];
        if(success)
        {
            [Utils alertMessage:@"非常感谢您提出的宝贵意见！"];
            [self btnHome:nil];
        }
        else
        {
            [Utils alertMessage:@"意见提交失败！"];
        }
    }
    @catch (NSException *exception) {
        [Utils alertMessage:@"意见提交失败！"];
    }
    @finally {
        
    }
    */
}


-(void)btnHome:(id)sender
{
    [self unsetupForDismissKeyboard];
    [self unregisterForKeyboardNotifications];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
//    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
//    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    //    NSLog(@">>>>>>>>>keyboardRect.size.height=%f",keyboardRect.size.height); //216,252
//    [self autoMovekeyBoard:keyboardRect.size.height];
    
}

- (void)keyboardWillHide:(NSNotification *)notification{
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
//    [self autoMovekeyBoard: 0];
}

-(void) autoMovekeyBoard: (float) h
{
    float screenheight;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        CGRect screenRect=[[UIScreen mainScreen] bounds ];
        screenheight=screenRect.size.height;
    }
    else
    {
        CGRect screenRect=[[UIScreen mainScreen] applicationFrame ];
        screenheight=screenRect.size.height;
    }
    
    //    UIToolbar *toolbar = (UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
    //	toolbar.frame = CGRectMake(0.0f, (float)(480.0-h-108.0), 320.0f, 44.0f);
    //	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
    //	bottomView.frame = CGRectMake(0.0f, 0.0f, 320.0f,(float)(480.0-h-108.0));
    
    //    NSLog(@">>>>CGRectOffset:X=%f,Y=%f,w=%f,h=%f",self.view.frame.origin.x,self.view.frame.origin.y, 0.0, -h);
    
    const float movementDuration = 0.3f;
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    
	_suggestionTextView.frame = CGRectMake(_suggestionTextView.frame.origin.x, _suggestionTextView.frame.origin.y, _suggestionTextView.frame.size.width, (float)(screenheight-h-_suggestionTextView.frame.origin.y));
    
    [UIView commitAnimations];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_suggestionTextView resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
