//
//  RewardViewController.m
//  Wefafa
//
//  Created by Jiang on 3/17/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "RewardViewController.h"
#import "NavigationTitleView.h"
#import "RewardContentTableViewCell.h"
#import "CreateRewardViewController.h"

@interface RewardViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectedButton;
@property (strong, nonatomic) CALayer *selectedShowLayer;

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

- (IBAction)selectedButtonAction:(UIButton *)sender;

@end

static NSString *cellIdentifier = @"RewardContentTableViewCellIdentifier";
@implementation RewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self initSelectedShowLayer];
    [self initContentTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化导航条

- (void)initNavigationBar{
    
    CGRect headrect=CGRectMake(0,0,self.navigationBarView.frame.size.width,self.navigationBarView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:)  selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"查看悬赏";
    [self.navigationBarView addSubview:view];
    
    CGFloat menuButton_X = self.navigationBarView.frame.size.width - 40;
    CGFloat menuButton_Y = self.navigationBarView.frame.size.height - 40;
    UIButton *menuButton = [[UIButton alloc]initWithFrame:CGRectMake(menuButton_X, menuButton_Y, 40, 40)];
    menuButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [menuButton addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"createReward.png"];
    [menuButton setImage:image forState:UIControlStateNormal];
    [self.navigationBarView addSubview:menuButton];
}

- (void)menuButtonAction:(id)sender{
    CreateRewardViewController *controller = [[CreateRewardViewController alloc] initWithNibName:@"CreateRewardViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectedButtonAction:(UIButton *)sender {
    UIButton *button = [self.selectedButton lastObject];
    if (sender == button && self.selectedShowLayer.position.x == button.centerX) {
        [sender setSelected:![sender isSelected]];
    }
    CGPoint layerCenterPoint = self.selectedShowLayer.position;
    layerCenterPoint.x = sender.centerX;
    self.selectedShowLayer.position = layerCenterPoint;
}

- (void)initContentTableView{
  
    [self.contentTableView registerNib:[UINib nibWithNibName:@"RewardContentTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    UIView *view = [[UIView alloc]init];
    self.contentTableView.tableFooterView = view;
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    [self.contentTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)initSelectedShowLayer{
    self.selectedShowLayer = [CALayer layer];
    UIButton *button = [self.selectedButton firstObject];
    self.selectedShowLayer.frame = CGRectMake(button.frame.origin.x, self.selectedView.frame.size.height - 2, button.frame.size.width, 2);
    self.selectedShowLayer.zPosition = 5;
    self.selectedShowLayer.backgroundColor = [UIColor orangeColor].CGColor;
    [self.selectedView.layer addSublayer:self.selectedShowLayer];
    
}

#pragma mark - tabelView delegate
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
@end
