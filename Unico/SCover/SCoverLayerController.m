//
//  SCoverLayerController.m
//  StoryCam
//
//  Created by Ryan on 15/4/22.
//  Copyright (c) 2015年 Unico. All rights reserved.
//  封面的图层选择。
//

#import "SCoverLayerController.h"
#import "SCoverLayerCell.h"
#import "SVPullToRefresh.h"
//#import 

@interface SCoverLayerController ()<UITableViewDataSource,UITableViewDelegate>{
//    UITableView *_tableView;
//    NSArray *_list;
}

@end

@implementation SCoverLayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    __weak SCoverLayerController *weakSelf = self;
    [_tableView addPullToRefreshWithActionHandler:^{
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        [weakSelf back];
    }];
}

- (void)back{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
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

#pragma mark - UITableViewDatasourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SCoverLayerCell";
    SCoverLayerCell *cell = (SCoverLayerCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SCoverLayerCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor redColor];
    
    
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"test---%ld",(long)indexPath.row);
}

@end
