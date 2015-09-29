//
//  SActivityOnSaleViewController.m
//  Wefafa
//
//  Created by unico on 15/5/17.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SActivityOnSaleViewController.h"
#import "SActivityOnSaleCell.h"
#import "SUtilityTool.h"

@interface SActivityOnSaleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //滚动时加载
    BOOL scrollLoading;
}

@property (nonatomic) UIView *selectView;
@property (nonatomic) NSInteger cellNowHeight;
@end

@implementation SActivityOnSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // TODO: 判断登陆状态，如果没有登录，显示登录界面。
    _cellNowHeight = 100;
    [self setupTableView];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupNavbar];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void) edgePanHandler:(UIScreenEdgePanGestureRecognizer*)recognizer{
    NSLog(@"edgePanHandler");
    // 此处应该被swap覆盖了，不会执行
}

- (void) swipeLeftHandler:(UISwipeGestureRecognizer*)recognizer{
    NSLog(@"swipeLeftHandler");
    // 左滑显示个人信息暂时。
    // 有动画，独立处理下
    //[self showCamera];
}

- (void) swipeRightHandler:(UISwipeGestureRecognizer*)recognizer{
    NSLog(@"swipeRightHandler");
    // TODO : 滑动出现我的。
    
}


- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIView *tempView;
    CGRect navRect = self.navigationController.navigationBar.frame;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
    
    // 这里可以试试 UIBarButtonItem的customView来处理2个btn
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -10;// TODO 负数无效这里
    UIBarButtonItem *right1 =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_list"] style:UIBarButtonItemStylePlain target:self action:@selector(onList:)];
    
    UIBarButtonItem *right2 =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/cart"] style:UIBarButtonItemStylePlain target:self action:@selector(onCart:)];
    
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,right2,negativeSpacer,right1] ;
    
    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    
    
    UIButton *tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    [tempBtn setTitle:@"品牌" forState:UIControlStateNormal];
    tempBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
    tempBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [tempBtn addTarget:self action:@selector(bestSelect:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:tempBtn];
    
    
    
    self.navigationItem.titleView = tempView;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTitleTap:)];
    [self.navigationItem.titleView setUserInteractionEnabled:YES];
    [self.navigationItem.titleView addGestureRecognizer:recognizer];
    
}

-(void)onBack:(id)sender{
    [self popAnimated:YES];
}

-(void)searchContent:(id)sender{
    NSLog(@"搜索");
}
-(void)onTitleTap:(id)sender{
    
}

-(void)onList:(id)sender{
    NSLog(@"列表");
}

-(void)onCart:(id)sender{
    NSLog(@"购物车");
}







-(void)dealData:(NSArray*)data
{
    // track black screen
    NSLog(@"dealData");
    for(NSInteger i = 0;i<[data count];i++)
    {
        NSMutableDictionary *dataAry = [NSMutableDictionary dictionaryWithDictionary:[data objectAtIndex:i]];
        [SGLOBAL_DATA_INSTANCE.specialArray addObject:dataAry];
    }
    SGLOBAL_DATA_INSTANCE.specialLastIndex += [data count];
    [self.tableView reloadData];
}

-(UIView*)getHeaderView{
    NSInteger height = (UI_SCREEN_WIDTH/375)*(320/2);
    float offset = 0;
    UILabel *tempLabel;
    UILabel *tempLabel2;
    UIView *contentView = [SUTILITY_TOOL_INSTANCE createUIViewByHeight:height+80/2+1 coordY:offset];
    UIImageView *tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Unico/banner250"]];
    tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, AUTO_SIZE(height));
    [contentView addSubview:tempView];
    offset += height;
    //uiview2
    UIView *  tempUI = [SUTILITY_TOOL_INSTANCE createUIViewByHeight:80/2 coordY:offset];
    [contentView addSubview:tempUI];
    
    tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/icon_time2" rect:CGRectMake(20, tempUI.frame.size.height/2-24/2/2, 24/2, 24/2)];
    [tempUI addSubview:tempView];
    //倒计时
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"倒计时" fontStyle:nil color:[UIColor blackColor] rect:CGRectMake(tempView.frame.size.width + AUTO_SIZE(20+10),0,0,tempUI.frame.size.height) isFitWidth:YES isAlignLeft:YES];
    [tempUI addSubview:tempLabel];
    
    tempLabel2 = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"02日 16:12:57" fontStyle:nil color:UIColorFromRGB(0xfe7c94) rect:CGRectMake(tempView.frame.size.width + AUTO_SIZE(20+10)+tempLabel.frame.size.width+AUTO_SIZE(10),0,0,tempUI.frame.size.height) isFitWidth:YES isAlignLeft:YES];
    [tempUI addSubview:tempLabel2];
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"正在参与抢购" fontStyle:nil color:[UIColor blackColor] rect:CGRectMake(tempUI.frame.size.width -AUTO_SIZE(10),0,0,tempUI.frame.size.height) isFitWidth:YES isAlignLeft:NO];
    [tempUI addSubview:tempLabel];
    tempLabel2 = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"3245 人" fontStyle:nil color:UIColorFromRGB(0xfe7c94) rect:CGRectMake(tempUI.frame.size.width -AUTO_SIZE(10)-tempLabel.frame.size.width-AUTO_SIZE(10),0,0,tempUI.frame.size.height) isFitWidth:YES isAlignLeft:NO];
    [tempUI addSubview:tempLabel2];
    
    tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/icon_head" rect:CGRectMake(tempUI.frame.size.width -10-tempLabel.frame.size.width-10-tempLabel2.frame.size.width -20, tempUI.frame.size.height/2-AUTO_SIZE(24/2/2), AUTO_SIZE(24/2), AUTO_SIZE(24/2))];
    [tempUI addSubview: tempView];
    offset += tempUI.frame.size.height;
    
    tempUI = [SUTILITY_TOOL_INSTANCE getNormalLineBySize:UI_SCREEN_WIDTH height:1 color:UIColorFromRGB(0xc4c4c4)];
    tempUI.alpha = 0.2;
    [tempUI setOrigin:CGPointMake(0, offset)];
    [contentView addSubview:tempUI];
    offset += 1;
    
    
    
    
    
    
    return  contentView;
}


- (void)setupTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.height+20, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.height-20)];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self getHeaderView];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
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
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.row == 0) {
    //        return ;
    //    }
    return _cellNowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SActivityOnSaleCell";
    SActivityOnSaleCell *cell = (SActivityOnSaleCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SActivityOnSaleCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
    }
    _cellNowHeight = cell.cellHeight;
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


#pragma mark - UIScrollViewdelegate methods
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //    [self.blrView blurWithColor:[BLRColorComponents darkEffect]];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    
    CGRect bounds = scrollView.bounds;
    
    CGSize size = scrollView.contentSize;
    
    UIEdgeInsets inset = scrollView.contentInset;
    
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    
    CGFloat maximumOffset = size.height;
    //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。也可以根据这两个值的差来让他做点其他的什么事情
    if((maximumOffset-currentOffset) <= 0 && (maximumOffset-currentOffset)>-1)
    {
        
    }
}

#pragma mark - long press
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    
    
}
@end