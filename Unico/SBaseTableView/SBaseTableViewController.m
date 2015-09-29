//
//  SBaseTableViewController.m
//  Wefafa
//
//  Created by unico on 15/5/20.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SBaseTableViewController.h"
#import "SItemFilterCell.h"

#import "SUtilityTool.h"

@interface SBaseTableViewController ()
@end

@implementation SBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //默认高度为100
    _cellNowHeight = 100;
    [self setupTableView];
    
    __weak SBaseTableViewController *weakVc = self;
    
    //下拉刷新
    [self.tableView addPullToRefreshWithActionHandler:^{
        // TODO: STOP Animation 在数据拉到后，再调用
        [weakVc.tableView.pullToRefreshView stopAnimating];
        [weakVc updateData];
       
       
    }];

    // TODO:分状态设置PullView
    [self.tableView.pullToRefreshView setCustomView:[UIView new] forState:SVPullToRefreshStateAll];
}


-(void)updateData{
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavbar];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)setupTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.height+STATUS_BAR_HEIGHT_U, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.height-STATUS_BAR_HEIGHT_U)];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDatasourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellNowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    return cell;
}


-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(void)updateScrollViewDidScroll{
    
}

#pragma mark - UIScrollViewdelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    
    CGRect bounds = scrollView.bounds;
    
    CGSize size = scrollView.contentSize;
    
    UIEdgeInsets inset = scrollView.contentInset;
    
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    
    CGFloat maximumOffset = size.height;
    //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。也可以根据这两个值的差来让他做点其他的什么事情
    float tempFloat = UI_SCREEN_WIDTH/4;
    if(((maximumOffset-currentOffset) <= tempFloat && (maximumOffset-currentOffset)>(tempFloat-50)) || ((maximumOffset-currentOffset) < 0 && (maximumOffset-currentOffset) > -1))
    {
        [self updateScrollViewDidScroll];
    }
    
}
@end
