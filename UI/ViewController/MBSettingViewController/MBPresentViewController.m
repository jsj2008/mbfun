//
//  MBPresentViewController.m
//  Wefafa
//
//  Created by wave on 15/5/29.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "MBPresentViewController.h"
#import "Utils.h"

@interface MBPresentTableViewCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *dic;
@end

@implementation MBPresentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //cell.height = 212;
//        UIImageView *backView = [UIImageView alloc]initWithFrame:CGRectMake(0, 15, UI_SCREEN_WIDTH, <#CGFloat height#>)
    }
}

- (void)setDic:(NSDictionary *)dic {
    
}

@end

@interface MBPresentViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataAry;
}
@end

@implementation MBPresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self setupNavbar];
    
}

- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO
     ];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIView *tempView;
    CGRect navRect = self.navigationController.navigationBar.frame;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    
    
    UIButton *tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    [tempBtn setTitle:@"我的范票" forState:UIControlStateNormal];
    tempBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
    tempBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [tempView addSubview:tempBtn];
    // default40@2x.9
    
    self.navigationItem.titleView = tempView;

}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}

#pragma mark - 
#pragma mark - UITableViewDataSource, UITableViewDelegate
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}

@end
