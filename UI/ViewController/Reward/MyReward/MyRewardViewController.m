//
//  MyRewardViewController.m
//  Wefafa
//
//  Created by Jiang on 3/17/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MyRewardViewController.h"
#import "NavigationTitleView.h"
#import "RewardContentTableViewCell.h"
#import "NoneHeightLightButton.h"
#import "RewardDetailsViewController.h"

@interface MyRewardViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;
@property (weak, nonatomic) UIView *navigationBar;
@property (strong, nonatomic) UIButton *barLeftButton;
@property (strong, nonatomic) UIButton *barRightButton;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

- (void)barButtonAction:(UIButton *)sender;

@end

static NSString *cellIdentifier = @"RewardContentTableViewCellIdentifier";
@implementation MyRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self initContentTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initContentTableView{
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentTableView registerNib:[UINib nibWithNibName:@"RewardContentTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    UIView *view = [[UIView alloc]init];
    self.contentTableView.tableFooterView = view;
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
}

- (void)initNavigationBar{
    
    CGRect headrect=CGRectMake(0,0,self.navigationBarView.frame.size.width,self.navigationBarView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:)  selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"";
    
    self.barLeftButton = [[NoneHeightLightButton alloc]initWithFrame:CGRectMake(92, 36, 70, 25)];
    self.barRightButton = [[NoneHeightLightButton alloc]initWithFrame:CGRectMake(158, 36, 70, 25)];
    self.barLeftButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.barRightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.barLeftButton setTitle:@"创建的悬赏" forState:UIControlStateNormal];
    [self.barRightButton setTitle:@"接单的悬赏" forState:UIControlStateNormal];
    [self.barLeftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.barRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.barLeftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.barRightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.barLeftButton setBackgroundImage:[UIImage imageNamed:@"grayBar.png"] forState:UIControlStateNormal];
    [self.barRightButton setBackgroundImage:[UIImage imageNamed:@"grayBar.png"] forState:UIControlStateNormal];
    [self.barLeftButton setBackgroundImage:[UIImage imageNamed:@"orangeBar.png"] forState:UIControlStateSelected];
    [self.barRightButton setBackgroundImage:[UIImage imageNamed:@"orangeBar.png"] forState:UIControlStateSelected];
    [self.barLeftButton addTarget:self action:@selector(barButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.barRightButton addTarget:self action:@selector(barButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.barLeftButton.selected = YES;
    
    [view addSubview:self.barRightButton];
    [view addSubview:self.barLeftButton];
    [self.navigationBarView addSubview:view];
    self.navigationBar = view;
//    self.navigationBarView = view;
}
-(void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)barButtonAction:(UIButton *)sender {
    if ([sender isSelected]) {
        return;
    }
    self.barLeftButton.selected = NO;
    self.barRightButton.selected = NO;
    [self.navigationBar bringSubviewToFront:sender];
    [sender setSelected:YES];
}

#pragma mark tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RewardContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RewardDetailsViewController *controller = [[RewardDetailsViewController alloc]initWithNibName:@"RewardDetailsViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
