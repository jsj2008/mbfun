//
//  SMineLikeViewController.m
//  Wefafa
//
//  Created by Funwear on 15/8/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMineLikeViewController.h"
#import "WeFaFaGet.h"
#import "WaterFLayout.h"
#import "SUtilityTool.h"
#import "SelectedSubContentView.h"
#define ISSUE_HEIGHT 42
@interface SMineLikeViewController ()<SelectedSubContentViewDelegate>{
    //1男装 2女装
    NSInteger _num;
}
@property (nonatomic) WaterFLayout *flowLayout;
@property (nonatomic) NSMutableArray *btnArray;
@property (nonatomic, strong) SelectedSubContentView *selectedContentView;
@end

@implementation SMineLikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavbar];
    [self initSubViews];
}

-(void)setupNavbar
{
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(btnBackClick:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    //设置标头
    if ([sns.ldap_uid isEqualToString:_person_id]) {
        self.title=@"我的喜欢";
    }else{
        self.title=@"Ta的喜欢";
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _collectionView.block(_num);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)initSubViews{
    _num=2;
    
//    UIEdgeInsets edgeInset = UIEdgeInsetsMake(64+ISSUE_HEIGHT,0, 0, 0);
    _flowLayout = [[WaterFLayout alloc]init];
    _flowLayout.sectionInset = UIEdgeInsetsZero;
    _flowLayout.minimumColumnSpacing = 1.5;
    _flowLayout.minimumInteritemSpacing = 1;
    _flowLayout.columnCount = 2;
    
    _collectionView = [[CommunityCollectionView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, self.view.frame.size.height-64) collectionViewLayout:_flowLayout];
//    _collectionView.contentInset=edgeInset;
    _collectionView.userID=_person_id;
    _collectionView.parentVC = self;
    _collectionView.backgroundColor=COLOR_NORMAL;
    [self.view addSubview:_collectionView];
    
    
    CGFloat height = 40;
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, height)];
    btnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnView];
    
    NSArray *array = @[@"女装", @"男装"];
    _selectedContentView = [[SelectedSubContentView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, height) AndNameArray:array buttonType:normalType];
    _selectedContentView.backgroundColor = [UIColor whiteColor];
    _selectedContentView.delegate = self;
    _selectedContentView.isShowAnimation=YES;
    [_selectedContentView scrollViewEndAction:0];
    [btnView addSubview:_selectedContentView];
    
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = COLOR_C9.CGColor;
    layer.frame = CGRectMake(0, _selectedContentView.size.height - 0.5, _selectedContentView.size.width, 0.5);
    layer.zPosition = 5;
    [_selectedContentView.layer addSublayer:layer];

}

-(void)clicked:(UIButton*)sender {
    for (UIButton *btn in _btnArray) {
        btn.selected = btn == sender;
    }
    NSInteger num = 0;
    if ([sender.titleLabel.text isEqualToString:@"男装"]) {
        
        num = 1;
    }else if ([sender.titleLabel.text isEqualToString:@"女装"]) {
        num = 2;
    }
    _num=num;
    _collectionView.block(num);
}
//男=1，女=2，童=3
//页面显示顺序 女男童
- (void)selectedSubContentViewSelectedIndex:(NSInteger)index{
    switch (index) {
        case 0:
            _num=2;
             _collectionView.block(2);
            break;
        case 1:
            _num=1;
            _collectionView.block(1);
            break;
        default:
            break;
    }
}
- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
