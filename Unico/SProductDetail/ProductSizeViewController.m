//
//  ProductSizeViewController.m
//  Wefafa
//
//  Created by Jiang on 15/8/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "ProductSizeViewController.h"
#import "GoodsCommentView.h"
#import "SUtilityTool.h"

@interface ProductSizeViewController ()
{
    UIView *_showNoneData;
}
@property (nonatomic, strong) GoodsCommentView *sizeTableView;
@end

@implementation ProductSizeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"尺码参数";
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)setupNavbar
{
    [super setupNavbar];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
}

- (void)onBack:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavbar];
    
    if (self.modelArr.count == 0) {
        [self showNoneData];
        return;
    }
    
    [_showNoneData removeFromSuperview];
    _showNoneData = nil;
    
    self.view.backgroundColor = COLOR_C3;
    CGRect frame = CGRectMake(10, 64+15, UI_SCREEN_WIDTH-20, UI_SCREEN_HEIGHT-64-15);
    _sizeTableView = [[GoodsCommentView alloc]initWithFrame:frame];
    _sizeTableView.modelArray = self.modelArr;
    [self.view addSubview:_sizeTableView];
}

- (UIView *)showNoneData{
    if (!_showNoneData) {
        CGRect frame = CGRectMake(0, 100, self.view.frame.size.width, 200);
        UIView *view = [[UIView alloc]initWithFrame:frame];
        view.backgroundColor = [UIColor clearColor];
        view.opaque = NO;
        frame.origin.y = 0;
        frame.size.height = 160;
        UILabel *label = [[UILabel alloc]initWithFrame:frame];
        label.textColor = COLOR_C6;
        label.font = FONT_T3;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"没有相关的尺码";
        [view addSubview:label];
        
        [self.view addSubview:view];
        _showNoneData = view;
    }
    return _showNoneData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
