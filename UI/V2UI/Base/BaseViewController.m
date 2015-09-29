//
//  BaseViewController.m
//  BanggoPhone
//
//  Created by issuser on 14-6-23.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"
#import "UIColor+extend.h"
#define QDCOMMONING_NAVI @"40-88.png"
#define QDCOMMONING_NAVI_70 @"40-128.png"

@interface BaseViewController ()

@end
@interface UINavigationBar (UINavigationBarCategory)
- (void)setBackgroundImage:(UIImage*)image;
@end

//CustomNavigationBar.m
@implementation UINavigationBar (UINavigationBarImage)

- (void)drawRect:(CGRect)rect {
    UIImage* img = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        img = [UIImage imageNamed:QDCOMMONING_NAVI_70];
    }else{
        img = [UIImage imageNamed:QDCOMMONING_NAVI];
    }
    UIImage *image = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
    assert(image!=nil);
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end
@implementation BaseViewController

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
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    if (self.parentViewController.childViewControllers.count>1) {
        [self SetLeftButton:nil Image:@"ion_back.png"];
    }
    else{
        if (self.presentingViewController) {
            [self SetLeftButton:nil Image:@"icon_close_big"];
        }
    }
    
    // Do any additional setup after loading the view.
    //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
    //        self.edgesForExtendedLayout = UIRectEdgeNone;
    //    }
    //    NSLog(@"孩子%@   其他%@",self.navigationController.childViewControllers,self.navigationController.viewControllers);
    
}

- (void)viewWillAppear:(BOOL)animated{
    //   MBCurrentControl *currentControl= [MBCurrentControl CurrentView];
    //    currentControl.view=self.view;
    [super viewWillAppear:animated];
    UIImage* image = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        image = [UIImage imageNamed:QDCOMMONING_NAVI_70];
    }else{
        image = [UIImage imageNamed:QDCOMMONING_NAVI];
    }
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2.0f topCapHeight:0];
    //判断设备的版本
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        //ios5 新特性
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        //        [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    }
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - back button
//返回
- (void)buttonAction_goback:(id)sender{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
/****************************************    zhu      ************************************/
//自定义natigationitem标题
-(void)setTitle:(NSString *)title{
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    customLab.backgroundColor=[UIColor clearColor];
    [customLab setTextColor:[UIColor whiteColor]];
    customLab.textAlignment=NSTextAlignmentCenter;
    customLab.numberOfLines = 2;
    [customLab setText:title];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    if ([title isEqualToString:@"banggo"]) {
        customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    }
    self.navigationItem.titleView=customLab;
}
//一级页面返回按钮
/*
 -(void)SetBackButton{
 UIButton *btnBack=[[UIButton alloc]init];
 btnBack.backgroundColor=[UIColor clearColor];
 btnBack.frame=CGRectMake(0, 0, 60, 30);
 [btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
 
 btnBack.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
 
 
 [btnBack setImage:[UIImage imageNamed:@"cancleBack"] forState:UIControlStateNormal];
 
 //    btnMessage.titleLabel.textColor=[UIColor blackColor];
 //    [btnMessage setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
 
 [btnBack addTarget:self action:@selector(BackReturn:) forControlEvents:UIControlEventTouchUpInside];
 UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
 if (IOS7) {
 UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
 initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
 target:nil action:nil];
 negativeSpacer.width = -10;
 self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
 }
 else{
 self.navigationItem.leftBarButtonItem=backItem;
 }
 //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
 //    self.navigationItem.leftBarButtonItem=backItem;
 
 }*/
//导航栏右边按钮
-(void)SetRightButton:(NSString *)title Image:(NSString *)image{
    UIButton *btnBack=[[UIButton alloc]init];
    btnBack.backgroundColor=[UIColor clearColor];
    btnBack.frame=CGRectMake(0, 0, 75, 44);
    [btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    if (title) {
        btnBack.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 10);
        [btnBack setTitle:title forState:UIControlStateNormal];
        btnBack.titleLabel.font=BUTTONBIGFONT;
        [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else{
        if (image) {
            btnBack.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 10);
            [btnBack setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        }
    }
    [btnBack addTarget:self action:@selector(RightReturn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, backItem];
    }
    else{
        self.navigationItem.rightBarButtonItem=backItem;
    }
}
//导航栏右边按钮事件
-(void)RightReturn:(UIButton *)sender{
    if (![self isMemberOfClass:[BaseViewController class]]) {
        // 如果是通过BaseViewController子类的实例调用了此处的RightReturn，则抛出一个异常：表明子类并没有重写RightReturn方法。
        // 注：在OC中并没有abstract class的概念，只有protocol，如果在基类中只定义接口(没有具体方法的实现)，
        //    则可以使用protocol，这样会更方便。
        [NSException raise:NSInternalInconsistencyException
                    format:BV_Exception_Format, [NSString stringWithUTF8String:object_getClassName(self)], NSStringFromSelector(_cmd)];
    }
    
    //    [self dismissViewControllerAnimated:YES completion:nil];
}

//导航栏左边按钮
-(void)SetLeftButton:(NSString *)title Image:(NSString *)image{
    UIButton *btnBack=[[UIButton alloc]init];
    btnBack.backgroundColor=[UIColor clearColor];
    btnBack.frame=CGRectMake(0, 0, 60, 44);
    [btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    if (title) {
        btnBack.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
        [btnBack setTitle:title forState:UIControlStateNormal];
        btnBack.titleLabel.font=BUTTONBIGFONT;
        [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else{
        btnBack.imageEdgeInsets=UIEdgeInsetsMake(0, -15, 0, 0);
        
        if (image) {
            [btnBack setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        }
        else{
            [btnBack setImage:[UIImage imageNamed:@"btn_profile_goback.png"] forState:UIControlStateNormal];
        }
    }
    [btnBack addTarget:self action:@selector(LeftReturn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -15;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
    }
    else{
        self.navigationItem.leftBarButtonItem=backItem;
    }
    
}
//导航栏左边按钮事件
-(void)LeftReturn:(UIButton *)sender{
    if (![self isMemberOfClass:[BaseViewController class]]) {
        if (self.parentViewController.childViewControllers.count>1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
        }
    }
    //    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - nav buttonitem
- (void)setLeftButton:(NSString*)buttonTitle titleImage:(NSString *)TitleImage action:(SEL)action
{
    
//    CGSize size = [buttonTitle sizeWithFont:BUTTONBIGFONT];
    CGSize size = [buttonTitle sizeWithAttributes:[NSDictionary dictionaryWithObject:BUTTONBIGFONT forKey:NSFontAttributeName]];
    UIImage* image = [UIImage imageNamed:TitleImage];
    UIImage* highlightedImage = [UIImage imageNamed:TitleImage];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = BUTTONBIGFONT;
    [button setFrame:CGRectMake(0, 0, MAX((size.width+30),40), MAX(30,size.height))];

    [button setBackgroundImage:[highlightedImage stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[image stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitle:buttonTitle forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, backItem];
    }
    else{
        self.navigationItem.rightBarButtonItem=backItem;
    }
    //    [self setLeftNavigationItemWithCustomView:button];
}

- (void)setRightButton:(NSString*)buttonTitle action:(SEL)action
{
    CGSize size = [buttonTitle sizeWithAttributes:[NSDictionary dictionaryWithObject:BUTTONBIGFONT forKey:NSFontAttributeName]];
    UIImage* image = [UIImage imageNamed:@""];
    UIImage* highlightedImage = [UIImage imageNamed:@""];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = BUTTONBIGFONT;
    [button setFrame:CGRectMake(0, 0, MAX((size.width+30),40), MAX(30,size.height))];
    [button setBackgroundImage:[highlightedImage stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[image stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitle:buttonTitle forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithHexString:@"#ffde00"] forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -20;
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, backItem];
    }
    else{
        self.navigationItem.rightBarButtonItem=backItem;
    }
}

- (void)setLeftNavigationItemWithCustomView:(UIView*)cusView
{
    UIBarButtonItem *m_buttonItem = [[UIBarButtonItem alloc] initWithCustomView:cusView];
    self.navigationItem.leftBarButtonItem = m_buttonItem;
}

- (void)setRightNavigationItemWithCustomView:(UIView*)cusView
{
    UIBarButtonItem *m_buttonItem = [[UIBarButtonItem alloc] initWithCustomView:cusView];
    self.navigationItem.rightBarButtonItem = m_buttonItem;
}
-(void)presentWithNavigationController:(UIViewController*)controller{
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:controller];
    if (self.navigationController) {
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else{
        [self presentViewController:nav animated:YES completion:nil];
    }
}

+(BOOL)presentLoginViewController:(UIViewController *)delegate
{
    if (!sns.isLogin)
    {
        LoginViewController *loginVC=[[LoginViewController alloc]init];
        if (delegate)
        {
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:loginVC];
            if (delegate.navigationController) {
                [delegate.navigationController presentViewController:nav animated:YES completion:nil];
            }else{
                [delegate presentViewController:nav animated:YES completion:nil];
            }
        }
    }
    return sns.isLogin;
}

+(BOOL)pushLoginViewController
{
    if (!sns.isLogin)
    {
        LoginViewController *loginVC=[LoginViewController new];
        [[AppDelegate rootViewController] pushViewController:loginVC animated:YES];
    }
    return sns.isLogin;

}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
