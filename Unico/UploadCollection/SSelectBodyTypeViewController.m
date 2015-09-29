//
//  SSelectBodyTypeViewController.m
//  Wefafa
//
//  Created by shenpu on 15/8/26.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SSelectBodyTypeViewController.h"
#import "SUtilityTool.h"

#define sizeK UI_SCREEN_WIDTH/750.0

@interface SSelectBodyTypeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UINavigationBar *_navigationBar;
    UITableView *_myTable;
    
    UIButton *_finishButton;
    
    NSArray *_myTableArray;
}

@end

@implementation SSelectBodyTypeViewController

#pragma mark - 构造与析构


- (id)init
{
    self = [super init];
    if (self != nil)
    {
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(pulishButtonClick:)];
        backButtonItem.tag=1;
        self.navigationItem.leftBarButtonItems = @[backButtonItem];
        
        _finishButton=[UIButton buttonWithType:UIButtonTypeSystem];
        _finishButton.tag=2;
        _finishButton.frame=CGRectMake(0, 0, 36, 30);
        [_finishButton setTintColor:COLOR_C1];
        _finishButton.titleLabel.font=FONT_SIZE(18);
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_finishButton addTarget:self action:@selector(pulishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:_finishButton];
        
        UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_finishButton];
        self.navigationItem.rightBarButtonItems = @[nextButtonItem];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH-200)/2.0, 0, 200, 44)];
        titleLabel.font = FONT_SIZE(18);
        titleLabel.textColor = COLOR_WHITE;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"体型";
        
        self.navigationItem.titleView = titleLabel;
    }
    return self;
}

#pragma mark - 视图控制器接口

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if ([self.view.gestureRecognizers count] > 0)
    {
        for(UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers)
        {
            if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)gestureRecognizer;
            }
        }
    }
    if (screenEdgePanGestureRecognizer != nil)
    {
        [self.view removeGestureRecognizer:screenEdgePanGestureRecognizer];//此处禁止屏幕边界右滑时返回上一级界面的手势
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavbar];
    [self.view addSubview:_navigationBar];
    self.view.backgroundColor=COLOR_C4;
    
    if (_selectType<0) {
        _finishButton.hidden=YES;
    }
    
    _myTableArray=@[@"纤细",@"匀称",@"微胖",@"肥胖"];
    //
    _myTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44) style:UITableViewStylePlain];
    _myTable.backgroundColor=[UIColor whiteColor];
    _myTable.tableFooterView=[[UIView alloc] init];
    _myTable.rowHeight=100*sizeK;
    _myTable.dataSource=self;
    _myTable.delegate=self;
    [self.view addSubview:_myTable];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myTableArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //标题
        UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(34*sizeK, 0, UI_SCREEN_WIDTH-34*sizeK, 100*sizeK)];
        lblTitle.tag=10010;
        lblTitle.font=FONT_t4;
        lblTitle.textColor=COLOR_C2;
        [cell addSubview:lblTitle];
        //图片
        UIImageView *picView=[[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-104*sizeK, 15*sizeK, 70*sizeK, 70*sizeK)];
        picView.tag=2;
        picView.image=[UIImage imageNamed:@"Unico/item_unselect"];
        [cell addSubview:picView];
    }
    
    UILabel *lblTitle=(UILabel*)[cell viewWithTag:10010];
    lblTitle.text=_myTableArray[indexPath.row];
    UIImageView *picView=(UIImageView*)[cell viewWithTag:2];
    if (_selectType==indexPath.row)
    {
        picView.image=[UIImage imageNamed:@"Unico/item_select"];
    }
    else
    {
        picView.image=[UIImage imageNamed:@"Unico/item_unselect"];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _finishButton.hidden=NO;
    //取消上个选中
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectType inSection:0]];
    UIImageView *picView=(UIImageView*)[cell viewWithTag:2];
    picView.image=[UIImage imageNamed:@"Unico/item_unselect"];
    
    //选中
    cell=[tableView cellForRowAtIndexPath:indexPath];
    picView=(UIImageView*)[cell viewWithTag:2];
    picView.image=[UIImage imageNamed:@"Unico/item_select"];
    _selectType=indexPath.row;
}

#pragma mark - 其他UI接口
/**
 *   构建导航栏
 */
- (void)setupNavbar
{
    [super setupNavbar];
    
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44)];
    [_navigationBar pushNavigationItem:self.navigationItem animated:NO];
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/blackBarBg.jpg"] forBarMetrics:UIBarMetricsDefault];
    [_navigationBar setBarTintColor:[UIColor blackColor]];
    [self.view addSubview:_navigationBar];
    
    _navigationBar.layer.transform = CATransform3DMakeTranslation(0, 0, 5);
}


#pragma mark - 控件事件接口

- (void)pulishButtonClick:(UIButton*)sender
{
    if (self.didFinishBrand != nil)
    {
        if (sender.tag==2)
        {
            self.didFinishBrand(_selectType);
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
