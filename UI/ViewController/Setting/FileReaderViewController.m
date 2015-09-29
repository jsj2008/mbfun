//
//  FileReaderViewController.m
//  Wefafa
//
//  Created by mac on 14-7-30.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "FileReaderViewController.h"
#import "Utils.h"
#import "Base.h"
#import "NavigationTitleView.h"

@interface FileReaderViewController ()

@end

@implementation FileReaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    _textViewContent.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-49);
}
- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO
     ];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1];
    self.title=_fileName;
    //    UIView *tempView;
    //    CGRect navRect = self.navigationController.navigationBar.frame;
    //    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    //
    //    UIButton *tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    //    [tempBtn setTitle:@"关于" forState:UIControlStateNormal];
    //    tempBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
    //    tempBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    //    [tempView addSubview:tempBtn];
    //    // default40@2x.9
    //
    //    self.navigationItem.titleView = tempView;
    //    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTitleTap:)];
    //    [self.navigationItem.titleView setUserInteractionEnabled:YES];
    //    [self.navigationItem.titleView addGestureRecognizer:recognizer];
}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGRect headrect=CGRectMake(0,0,self.viewHead.frame.size.width,self.viewHead.frame.size.height);
    NavigationTitleView* titleView = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [titleView createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:nil selectorMenu:nil];
    titleView.lbTitle.text=_fileName;
//    [self.viewHead addSubview:titleView];
    [self setupNavbar];
    
    NSError *error;
    NSString *resourceName =[[NSBundle mainBundle] pathForResource:_fileName ofType:@"txt"];
    NSString *txt=[NSString stringWithContentsOfFile:resourceName encoding:NSUTF8StringEncoding error:nil];
    if (error) {
        NSLog(@"读取文件出错：%@", error);
        return;
    }
    
    _textViewContent.text=txt;
    _textViewContent.editable = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
