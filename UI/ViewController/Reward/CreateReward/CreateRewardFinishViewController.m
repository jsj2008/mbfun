//
//  CreateRewardFinishViewController.m
//  Wefafa
//
//  Created by Jiang on 3/17/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "CreateRewardFinishViewController.h"
#import "NavigationTitleView.h"
#import "RewardViewController.h"
#import "CreateRewardFinishTableViewCell.h"

@interface CreateRewardFinishViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet UIButton *determineButton;

@end

static NSString *cellIndentifier = @"CreateRewardFinishContentTableViewCellIdentifier";
@implementation CreateRewardFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self initSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSubView{
    self.contentView.layer.borderWidth = 1.0;
    self.contentView.layer.borderColor = [UIColor blackColor].CGColor;
    self.contentView.layer.cornerRadius = 3.0;
    
    [self.contentTableView registerNib:[UINib nibWithNibName:@"CreateRewardFinishTableViewCell" bundle:nil] forCellReuseIdentifier:cellIndentifier];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    
}

- (void)initNavigationBar{
    
    CGRect headrect=CGRectMake(0,0,self.navigationBarView.frame.size.width,self.navigationBarView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:)  selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"创建悬赏";
    [self.navigationBarView addSubview:view];
}

-(void)backHome:(id)sender
{
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[RewardViewController class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:YES]; //跳转
    }
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreateRewardFinishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    return cell;
}


@end
