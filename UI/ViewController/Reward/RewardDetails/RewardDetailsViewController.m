//
//  RewardDetailsViewController.m
//  Wefafa
//
//  Created by Jiang on 3/18/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "RewardDetailsViewController.h"
#import "NavigationTitleView.h"
#import "RewardDetailsTableViewCell.h"
#import "RewardDetailsHeaderView.h"

@interface RewardDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@end

static NSString *cellIdentifier = @"RewardDetailsContentTableViewCellIdengtifier";
@implementation RewardDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self initContentTableView];
}

- (void)initContentTableView{
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentTableView registerNib:[UINib nibWithNibName:@"RewardDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    self.contentTableView.tableHeaderView = [[RewardDetailsHeaderView alloc]init];
    self.contentTableView.tableFooterView = [[UIView alloc]init];
}

- (void)initNavigationBar{
    
    CGRect headrect=CGRectMake(0,0,self.navigationBarView.frame.size.width,self.navigationBarView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:)  selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"悬赏详情";
    [self.navigationBarView addSubview:view];
}

-(void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tabelView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RewardDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

@end
