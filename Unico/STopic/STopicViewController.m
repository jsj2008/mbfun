//
//  STopicViewController.m
//  Wefafa
//
//  Created by unico_0 on 6/1/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "STopicViewController.h"
#import "STopicListTableViewCell.h"
#import "SDataCache.h"
#import "StopicListModel.h"
#import "SUtilityTool.h"
#import "STopicDetailViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "Toast.h"

@interface STopicViewController ()<UITableViewDataSource, UITableViewDelegate, STopicListTableViewCellDelegate>
{
    NSInteger _pageIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

//-------------
@property (nonatomic, strong) NSMutableArray *contentArray;

@end

static NSString *cellIdentifier = @"STopicListTableViewCellIdentifier";
@implementation STopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavbar];
    [self initSubViews];
    [self requestData];
}

- (void)setupNavbar{
    [super setupNavbar];
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(btnBackClick:)];
    self.navigationItem.leftBarButtonItems = @[left1] ;
    self.navigationItem.title = @"话题列表";
}
-(void)btnBackClick:(id)sender
{
    [self popAnimated:YES];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)initSubViews{
    _contentTableView.backgroundColor = COLOR_C4;
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_contentTableView registerNib:[UINib nibWithNibName:@"STopicListTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    
    [_contentTableView addFooterWithTarget:self action:@selector(requestAddData)];
    [_contentTableView addHeaderWithTarget:self action:@selector(refreshData)];
}

- (void)requestData{
    SDataCache *dataCache = [SDataCache sharedInstance];
    NSDictionary *params = @{
                           @"m":@"Topic",
                           @"a":@"getTopicList",
                           @"page":@(_pageIndex)
                           };
    [dataCache quickGet:SERVER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id object) {
        [_contentTableView footerEndRefreshing];
        [_contentTableView headerEndRefreshing];
        NSArray *dataArray = object[@"data"];
        if (_pageIndex == 0) {
            self.contentArray = [StopicListModel modelArrayForDataArray:dataArray];
        }else{
            if (dataArray.count <= 0) {
//                [Toast makeToast:@"已经到底了！" duration:1.5 position:@"center"];
                [Toast makeToastSuccess:@"已经到底了！"];
                return;
            }
            [self.contentArray addObjectsFromArray:[StopicListModel modelArrayForDataArray:dataArray]];
            [self.contentTableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
        [_contentTableView footerEndRefreshing];
        [_contentTableView headerEndRefreshing];
    }];
}

- (void)refreshData{
    _pageIndex = 0;
    [self requestData];
}

- (void)requestAddData{
    _pageIndex = (_contentArray.count + 9)/ 10;
    [self requestData];
}

- (void)setContentArray:(NSMutableArray *)contentArray{
    _contentArray = contentArray;
    [self.contentTableView reloadData];
}

#pragma mark touche action
- (void)topicTouchNextAction:(UIButton *)button contentModel:(StopicListModel *)model{
    STopicDetailViewController *controller = [[STopicDetailViewController alloc]init];
    controller.topicID = model.aID;
    controller.titleName = model.name;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    STopicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.parentVC = self;
    StopicListModel *model = _contentArray[indexPath.row];
    cell.contentModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
