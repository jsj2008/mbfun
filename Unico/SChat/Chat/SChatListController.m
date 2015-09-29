//
//  SChatListController.m
//  Unico
//
//  Created by Ryan on 15/6/6.
//  Copyright (c) 2015年 Unico. All rights reserved.
//

#import "SChatListController.h"
#import "SChatListCell.h"
#import "SChatLIstCellTableViewCell.h"
#import "SChatSystemListCellTableViewCell.h"
#import "SChatListModel.h"
#import "SChatController.h"
#import "SUtilityTool.h"
#import "SDataCache.h"
#import "SChatSystemListModel.h"
#import "WeFaFaGet.h"
#import "SChatSocket.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+MJRefresh.h"
#import "LoginViewController.h"
#import "SStarStoreViewController.h"
#import "ShoppIngBagShowButton.h"
#import "HttpRequest.h"
#import "MyShoppingTrollyViewController.h"
#import "SAgilityNavigationBarTool.h"
#import "Toast.h"
#import "SHomeViewController.h"
#import "SLeftMainView.h"
#import "SFashionViewCell.h"
#import "SMessageTableView.h"
#import "SMessageBannerModel.h"
#import "SMenuBottomModel.h"

@interface SChatListController ()<UITableViewDataSource,UITableViewDelegate, kLeftMainViewDelegate, UIScrollViewDelegate>{
//    int infoPage, messagePage, systemPage;      //请求页数
//    BOOL _hasNewMessage, _hasNewSysem;
//    int _firstPageNumMessage, _firstPageNumSystem;
    UIImageView *headerImgView;
    UIView *view;
    UIView *_unread_label;
    ShoppIngBagShowButton *_shoppingBagButton;
    UIView *_sysView, *_messageView;            //未读红点
}
@property (nonatomic, strong) UIScrollView *homeView;

@property (nonatomic, strong) UITableView *systemTableView;
//@property (nonatomic, strong) UITableView *messageTableView;
@property (nonatomic, strong) SMessageTableView *messageTableView;
@property (nonatomic, strong) UITableView *infoTableView;
@property (nonatomic, strong) UISegmentedControl *segment;

@property (nonatomic, strong) UIView *noDataView;
@property (nonatomic, assign) int infoPage;
@property (nonatomic, assign) int messagePage;
@property (nonatomic, assign) int systemPage;

@property (nonatomic, assign) BOOL hasNewMessage;
@property (nonatomic, assign) BOOL hasNewSysem;
@property (nonatomic, assign) int firstPageNumMessage;
@property (nonatomic, assign) int firstPageNumSystem;

@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, strong) UIView *btnView;
@property (nonatomic, strong) UIButton *systemBtn;
@property (nonatomic, strong) UIButton *messageBtn;
@property (nonatomic, strong) UIButton *infoBtn;
@property (nonatomic, strong) UIView *bottomView;

//@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSMutableArray *listMessage;
@property (nonatomic, strong) NSMutableArray *listSystem;
@property (nonatomic, strong) NSMutableArray *listInfo;

@property (nonatomic, assign) __block BOOL hasInfoDataRequested;

@end

static NSString *messageCellId = @"SChatMessageCellIdentity";
static NSString *systemCellId = @"SChatSystemCellIdentity";
static NSString *fashionCellId = @"SFashionCellIdentity";

@implementation SChatListController
/*
-(UIButton*)systemBtn {
    _systemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_systemBtn setTitle:@"通知" forState:UIControlStateNormal];
    [_systemBtn setTitle:@"通知" forState:UIControlStateHighlighted];
    [_systemBtn setTitleColor:COLOR_C3 forState:UIControlStateNormal];
    [_systemBtn setTitleColor:COLOR_C3 forState:UIControlStateHighlighted];
    _systemBtn.titleLabel.font = FONT_t3;
    CGSize size = [_systemBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : _systemBtn.titleLabel.font}];
    [_systemBtn intrinsicContentSize];
//    _systemBtn.frame = CGRectMake(size.width + 35, 0, size.width, 44);
    _systemBtn.frame = CGRectMake(size.width, 0, size.width, self.navigationController.navigationBar.frame.size.height);
    [_systemBtn addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventTouchUpInside];
    _systemBtn.tag = 0;
    
    _sysView = [[UIView alloc]initWithFrame:CGRectMake(_systemBtn.width, (_systemBtn.height - size.height)/2 - 3, 4, 4)];
    _sysView.layer.cornerRadius = _sysView.width/2;
    _sysView.backgroundColor = [Utils HexColor:0xfb5b4e Alpha:1];
    [_systemBtn addSubview:_sysView];
    
    return _systemBtn;
}
*/
- (UIButton*)messageBtn {
    _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_messageBtn setTitle:@"消息" forState:UIControlStateNormal];
    [_messageBtn setTitle:@"消息" forState:UIControlStateHighlighted];
    [_messageBtn setTitleColor:COLOR_C3 forState:UIControlStateNormal];
    [_messageBtn setTitleColor:COLOR_C3 forState:UIControlStateHighlighted];
    _messageBtn.titleLabel.font = FONT_t3;
    CGSize size = [_messageBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : _messageBtn.titleLabel.font}];
    [_messageBtn intrinsicContentSize];
//    _messageBtn.frame = CGRectMake(_systemBtn.right + 50, 0, size.width, self.navigationController.navigationBar.frame.size.height);
    _messageBtn.frame = CGRectMake(_infoBtn.right + 50, 0, size.width, self.navigationController.navigationBar.frame.size.height);
    [_messageBtn addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventTouchUpInside];
    _messageBtn.tag = 1;
    
    _messageView = [[UIView alloc]initWithFrame:CGRectMake(_messageBtn.width, (_messageBtn.height - size.height)/2 - 3, 4, 4)];
    _messageView.layer.cornerRadius = _messageView.width/2;
    _messageView.backgroundColor = [Utils HexColor:0xfb5b4e Alpha:1];
    [_messageBtn addSubview:_messageView];
    
    return _messageBtn;
}

- (UIButton*)infoBtn {
    _infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_infoBtn setTitle:@"资讯" forState:UIControlStateNormal];
    [_infoBtn setTitle:@"资讯" forState:UIControlStateHighlighted];
    [_infoBtn setTitleColor:COLOR_C3 forState:UIControlStateNormal];
    [_infoBtn setTitleColor:COLOR_C3 forState:UIControlStateHighlighted];
    _infoBtn.titleLabel.font = FONT_t3;
    CGSize size = [_infoBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : FONT_t3}];
    [_infoBtn intrinsicContentSize];
    _infoBtn.frame = CGRectMake(0, 0, size.width, self.navigationController.navigationBar.frame.size.height);
    [_infoBtn addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventTouchUpInside];
    _infoBtn.tag = 0;
    
    return _infoBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!IS_STRING(sns.ldap_uid) || !sns.isLogin) {
        LoginViewController *VC = [LoginViewController new];
        [self pushController:VC animated:YES];
        return;
    }
//    _selectedIndex = self.index.length == 0 ? 2 : [self.index intValue];
    _selectedIndex = self.index.length == 0 ? 0 : [self.index intValue];
    _messagePage = _infoPage = 0;
    _hasNewMessage = _hasNewSysem = NO;
    _firstPageNumSystem = _firstPageNumMessage = 10;
    _hasInfoDataRequested = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMsg:) name:@"MBFUN_CHAT_MESSAGE_SOCKET" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRemote)  name:MBFUN_REMOTE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti_loginOut) name:@"noti_loginOut" object:nil];
    // Do any additional setup after loading the view.
    
    [self initBar];
    [self setupNavbar];
    [self uiconfig];
    [self segmentChanged:_infoBtn];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initBar];
    [self setupNavbar];
//    self.infoTableView.hidden=NO;
    [self updataTitle];
    [self updataBadgeView];
    
    [[SMessageTableView instance] reloadData_];
}

- (void)scrollToTop{
//    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self kLeftMainViewSwipeDelegate];
}

- (void)uiconfig {
    _listSystem = [NSMutableArray new];
    _listMessage = [NSMutableArray new];
    _listInfo = [NSMutableArray new];
    float navHeight = 65;
    CGRect rect = CGRectMake(0, 0,
                             self.view.frame.size.width, self.view.frame.size.height-navHeight);
    
    
    _homeView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64)];
    _homeView.contentSize = CGSizeMake(UI_SCREEN_WIDTH * 2, UI_SCREEN_HEIGHT - 64);
    _homeView.pagingEnabled = YES;
    _homeView.delegate = self;
    _homeView.bounces = NO;
    [self.view addSubview:_homeView];
    
    rect.origin.x = 0;
    self.infoTableView = [[UITableView alloc]initWithFrame:rect];
    self.infoTableView .delegate = self;
    self.infoTableView .dataSource = self;
    self.infoTableView .tableFooterView = [UIView new];
    [self.infoTableView registerClass:NSClassFromString(@"SFashionViewCell") forCellReuseIdentifier:fashionCellId];
    [_homeView addSubview:self.infoTableView ];

//    rect.origin.x = UI_SCREEN_WIDTH;
//    self.systemTableView = [[UITableView alloc] initWithFrame:rect];
//    self.systemTableView.delegate = self;
//    self.systemTableView.dataSource = self;
//    self.systemTableView.tableFooterView = [UIView new];
//    [self.systemTableView registerNib:[UINib nibWithNibName:@"SChatSystemListCellTableViewCell" bundle:nil] forCellReuseIdentifier:systemCellId];
//    [_homeView addSubview:self.systemTableView];
    
    rect.origin.x = UI_SCREEN_WIDTH;
    //    self.messageTableView = [[UITableView alloc] initWithFrame:rect];
    self.messageTableView = [SMessageTableView new];
    self.messageTableView.target = self;
    self.messageTableView.frame = rect;
//    self.messageTableView.delegate = self;
//    self.messageTableView.dataSource = self;
//    self.messageTableView.tableFooterView = [UIView new];
//    [self.messageTableView registerNib:[UINib nibWithNibName:@"SChatLIstCellTableViewCell" bundle:nil] forCellReuseIdentifier:messageCellId];
    [_homeView addSubview:self.messageTableView];
    __weak SChatListController *ws = self;
//    NSArray *tableAry = @[self.systemTableView, self.messageTableView, self.infoTableView];
    NSArray *tableAry = @[self.infoTableView];//, self.messageTableView];
    for (__weak UITableView *tableView in tableAry) {
        
        [tableView addHeaderWithCallback:^{
            _infoPage = 0;
            [self getInfoList];
        }];
        [tableView addFooterWithCallback:^{
            [ws updateData];
        }];
    }
}

- (void)updataBadgeView {
    if (MAIL_COUNT > 0) {   //系统消息
        _sysView.hidden = NO;
    }else {
        _sysView.hidden = YES;
    }
    
    if (UNREAD_ALL_NUMBER - MAIL_COUNT > 0) {
        _messageView.hidden = NO;
    }else {
        _messageView.hidden = YES;
    }
    SHomeViewController *homeVC = [SHomeViewController instance];
    homeVC.messageBadge = [NSString stringWithFormat:@"%d", UNREAD_ALL_NUMBER];
    if (UNREAD_ALL_NUMBER > 0) {
        _unread_label.hidden = NO;
    }else {
        _unread_label.hidden = YES;
    }
}

- (void)updataTitle {
//    self.title = [NSString stringWithFormat:@"%@(%d)", @"消息中心", UNREAD_ALL_NUMBER];
}

-(UIView*)createNoDataView{
    UIView *tempView = [SUTIL createUIViewByHeight:(UI_SCREEN_HEIGHT) coordY:0];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH - 52)/2, 130, 52, 60)];
    [imgView setImage:[UIImage imageNamed:@"Unico/home_light"]];
    [tempView addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 210, UI_SCREEN_WIDTH, 25)];
    [label setText:@"你还没有任何消息"];
    [label setTextColor:[Utils HexColor:0X3B3B3B Alpha:1.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont boldSystemFontOfSize:16.0F]];
    [tempView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, UI_SCREEN_WIDTH, 20)];
    [label1 setText:@"看看推荐给你的吧"];
    [label1 setTextColor:[Utils HexColor:0X666666 Alpha:1.0]];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [label1 setFont:[UIFont systemFontOfSize:14.0F]];
    [tempView addSubview:label1];
    
    UIButton *recommendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recommendBtn setTitle:@"推荐关注" forState:UIControlStateNormal];
    [recommendBtn addTarget:self action:@selector(recommendDesigner) forControlEvents:UIControlEventTouchUpInside];
    [recommendBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [recommendBtn setTitleColor:[Utils HexColor:0X3B3B3B Alpha:1.0] forState:UIControlStateNormal];
    [recommendBtn setBackgroundColor:[Utils HexColor:0XFFDE00 Alpha:1.0]];
    [recommendBtn.layer setCornerRadius:5.0];
    [recommendBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [recommendBtn.layer setBorderWidth:1.0];
    [recommendBtn setFrame:CGRectMake((UI_SCREEN_WIDTH - 110)/2, 270, 110, 35)];
    [tempView addSubview:recommendBtn];
    return tempView;
}

- (void)recommendDesigner
{
    if ([BaseViewController pushLoginViewController]) {
        SStarStoreViewController * starStoreVC = [[SStarStoreViewController alloc]init];
        [self.navigationController pushViewController:starStoreVC animated:YES];
    }
}

- (void)initBar {
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.tabBarController setValue:_layoutModel forKey:@"layoutModel"];
    [self titleView];
}

- (void)titleView {
    [self infoBtn];
    [self messageBtn];
    
    _btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _systemBtn.width * 3 + 50 * 2, 44)];
    _btnView.backgroundColor = [UIColor clearColor];
    [_btnView addSubview:_messageBtn];
    [_btnView addSubview:_infoBtn];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _btnView.height - 3, 40, 3)];
//    [_bottomView setCenterX:_systemBtn.centerX];
    [_bottomView setCenterX:_infoBtn.centerX];
    _bottomView.backgroundColor = COLOR_C1;
    [_btnView addSubview:_bottomView];
    self.tabBarController.navigationItem.titleView = _btnView;
    
    [self topViewConfig];
}

- (void)leftMenu {
    [[SUtilityTool shared] showLeftMenuViewWithTarget:self];
}

- (void)onCart{
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *vc1=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}

- (void)segmentChanged:(UIButton*)sender {
    _selectedIndex = (int)sender.tag;
    if (!sns.isLogin || !IS_STRING(sns.ldap_uid)) {
        return;
    }
    
    if (_selectedIndex == 2) {
        [_homeView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (_selectedIndex == 0) {
        [_homeView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (_selectedIndex == 1) {
        [_homeView setContentOffset:CGPointMake(UI_SCREEN_WIDTH, 0) animated:YES];
    }

    [self topViewConfig];
    
    if (_selectedIndex == 1) {
        if (_noDataView) {
            [_noDataView removeFromSuperview];
            _noDataView = nil;
        }
        if (_listMessage.count > 0) {
            [self updateViewWithRequest];
            return;
        }
        [self getMessageList];
    }
    
    else if (_selectedIndex == 0) {
        /*
        [_listSystem removeAllObjects]; //为了能及时刷新未读状态 每次请求接口
        if (_listSystem.count == 0 || _hasNewSysem) {
            systemPage = 0;
            [self getNoticeList];
            _hasNewSysem = NO;
        }else{
            [self updateViewWithRequest];
        }
         */
        if (_listInfo.count != 0) {
            //iPhone6 8.1.2 系统在消息页面点击cell 会导致tableView刷新 cell的height会变成消息页面的cellheight 这里reloadata重新赋值cellheight
            [_infoTableView reloadData];
            return;
        }
        _infoPage = 0;
        [self getInfoList];
    }
}

- (void)topViewConfig {
    NSArray *ary = @[_infoBtn, _messageBtn];
    UIButton *selected = ary[_selectedIndex];
    [selected setTitleColor:COLOR_C3 forState:UIControlStateNormal];
    
    for (UIButton *btn in ary) {
        if (btn != selected) {
            [btn setTitleColor:COLOR_C6 forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [_bottomView setCenterX:selected.centerX];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)getNoticeList{
    __weak typeof(self) ws = self;
    [[SDataCache sharedInstance] get:@"Message" action:@"getMailList" param:@{@"page":@(_systemPage)} success:^(AFHTTPRequestOperation *operation, id object) {
        NSArray *ary = [object objectForKey:@"data"];
        /*
        if ((int)ary.count < _firstPageNumSystem) {
            --systemPage;
            systemPage = systemPage <= 0 ? 0 : systemPage;
        }
        if (_firstPageNumSystem==0) {
            return ;
        }
        if (_listSystem.count % _firstPageNumSystem != 0) {
            [self updateViewWithRequest];
            return;
        }
        if (systemPage == 0) {
            [_listSystem removeAllObjects];
        }
        */
        if (ws.systemPage == 0) {
//            [_listSystem removeAllObjects];
            [ws.listSystem removeAllObjects];
        }
//        if ((int)ary.count < _firstPageNumSystem) {
        if ((int)ary.count < ws.firstPageNumSystem) {
            --ws.systemPage;
            ws.systemPage = ws.systemPage <= 0 ? 0 : ws.systemPage;
        }
//        if (_listSystem.count % _firstPageNumSystem != 0) {
        if (ws.listSystem.count % _firstPageNumSystem != 0) {
            [ws updateViewWithRequest];
            return;
        }
        
        if ([[object objectForKey:@"status"] intValue] == 1) {
            for (NSDictionary *dictionary in ary) {
                SChatSystemListModel *model = [[SChatSystemListModel alloc]initWithDic:dictionary];
                [ws.listSystem addObject:model];
                if ([model.is_read intValue] != 1) {
                    --UNREAD_ALL_NUMBER;
                    --MAIL_COUNT;
                }
            }
        }
        [ws updataTitle];
        [ws updataBadgeView];
//        _list = [_listSystem copy];
        [ws.systemTableView reloadData];
        
        [ws updateViewWithRequest];
        
        if (ws.listSystem.count <= 0) {
            if (!ws.noDataView) {
                ws.noDataView = [ws createNoDataView];
                [ws.view addSubview:ws.noDataView];
            }
            return;
        } else {
            if (ws.noDataView) {
                [ws.noDataView removeFromSuperview];
                ws.noDataView = nil;
            }
        }
        
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ws updateViewWithRequest];
        if (!ws.noDataView) {
            ws.noDataView = [ws createNoDataView];
            [ws.view addSubview:ws.noDataView];
        }
    }];

}

- (void)getMessageList{
    /*
    __weak typeof(self) ws = self;
    [[SDataCache sharedInstance] get:@"Message" action:@"getMessageUserList" param:@{@"page":@(_messagePage)} success:^(AFHTTPRequestOperation *operation, id object) {

        NSArray *ary = object[@"data"];
        
        if (ws.messagePage == 0) {
            [ws.listMessage removeAllObjects];
        }
        if ((int)ary.count < ws.firstPageNumMessage) {
            --ws.messagePage;
            ws.messagePage = ws.messagePage <= 0 ? 0 : ws.messagePage;
        }

        if (ws.hasNewMessage || ws.listMessage.count == 0) {
            //有新消息接受新消息,没有新消息且请求聊天条数没变则不做响应
        }else if (ws.listMessage.count % ws.firstPageNumMessage == ary.count) {
            [ws updateViewWithRequest];
            return;
        }
        
        for (int i=0; i<ary.count; i++) {
            NSDictionary *info = ary[i];
            SChatListModel* model = [[SChatListModel alloc]initWithDict:info];
            [ws.listMessage addObject:model];
        }
        [ws.messageTableView reloadData];
        [ws updateViewWithRequest];
        
        if (ws.listMessage.count <= 0) {
            if (!ws.noDataView) {
                ws.noDataView = [ws createNoDataView];
                [ws.view addSubview:ws.noDataView];
            }
            return;
        } else {
            if (ws.noDataView) {
                [ws.noDataView removeFromSuperview];
                ws.noDataView = nil;
            }
        }
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ws updateViewWithRequest];
        if (!ws.noDataView) {
            ws.noDataView = [ws createNoDataView];
            [ws.view addSubview:ws.noDataView];
        }
    }];
    */
    [[SDataCache sharedInstance] get:@"Message" action:@"getMessageDetaisV2" param:nil success:^(AFHTTPRequestOperation *operation, id object) {
        if ([object[@"status"] intValue] == 1) {
            NSDictionary *dic = object[@"data"];
            for (NSDictionary *dict in [dic[@"banner"] objectForKey:@"1020"]) {
//                SMessageBannerModel *model = [[SMessageBannerModel alloc] initWithDic:dict];
//                [_listMessage addObject:model];
                [_listMessage addObject:dict];
            }
            _messageTableView.contentArray = _listMessage;
        }
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)getInfoList {
    __unsafe_unretained typeof(self) ws = self;
    _hasInfoDataRequested = YES;
    [SDATACACHE_INSTANCE getAllFashionList:_infoPage complete:^(NSArray *data) {
        if (_infoPage == 0) {
            [ws.listInfo removeAllObjects];
        }
        [ws.listInfo addObjectsFromArray:data];
//        ws.listInfo = [NSMutableArray arrayWithArray:data];
        NSLog(@"ws.listInfo.count ---- %d", (int)ws.listInfo.count);
        [ws.infoTableView reloadData];
        
        if (ws.listInfo.count <= 0) {
            if (!ws.noDataView) {
                ws.noDataView = [self createNoDataView];
                [ws.view addSubview:ws.noDataView];
            }
            return;
        } else {
            if (ws.noDataView) {
                [ws.noDataView removeFromSuperview];
                ws.noDataView = nil;
            }
        }
        
        [ws updateViewWithRequest];
        ws.hasInfoDataRequested = NO;
    }];
}

- (void)updateViewWithRequest {
//    NSArray *tableAry = @[_systemTableView, _messageTableView, _infoTableView,];
    NSArray *tableAry = @[_infoTableView, _messageTableView];
    UITableView *tableView = tableAry[_selectedIndex];
    [tableView headerEndRefreshing];
    [tableView footerEndRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)noti_loginOut
{
    _unread_label.hidden=YES;
    
    [Toast hideToastActivity];
    [[SDataCache sharedInstance] logout];
//    [self updateDataWhenLogOut];
    [_shoppingBagButton setTitle:@"" forState:UIControlStateNormal];
    
    _shoppingBagButton.titleLabel.hidden=YES;
}

- (void)onRemote {
    [self updataTitle];
    [self updataBadgeView];
    _hasNewSysem = YES;
}

- (void)onMsg:(NSNotification*)notification {
    [self.listMessage removeAllObjects];
    [self updataBadgeView];
    [self updataTitle];
    //IM服务器有时不会及时响应......
    _hasNewMessage = YES;
//    //服务器返回的数据不是针对最后一条返回而是将全部的数据返回
//    if (_selectedIndex == 1) {
////        self.list = self.listMessage;
//        [self getMessageList];
//    }
    
    [_messageTableView reloadData];
}

-(void)updateData{
    if (_selectedIndex == 0) {
        ++_infoPage;
        [self getInfoList];
    }else if (_selectedIndex == 1) {
//        ++_messagePage;
//        [self getMessageList];
        
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc");
}

#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tabBarController setValue:scrollView forKey:@"controlScrollView"];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.tabBarController setValue:scrollView forKey:@"scrollViewBegin"];
}

#pragma mark - data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedIndex == 0){   //系统消息
        NSDictionary *dict = _listInfo[indexPath.row];
        float tempHeight = [dict[@"img_height"] floatValue];
        float tempWidth = [dict[@"img_width"] floatValue];
        float floatPercent = UI_SCREEN_WIDTH/(tempWidth/2);
        tempHeight = floatPercent*tempHeight/2;
        return tempHeight + 20/2 - 10;
    }
    else if (_selectedIndex == 1)
        return 65; //聊天消息
    else {  //资讯消息
        NSDictionary *dict = _listInfo[indexPath.row];
        float tempHeight = [dict[@"img_height"] floatValue];
        float tempWidth = [dict[@"img_width"] floatValue];
        float floatPercent = UI_SCREEN_WIDTH/(tempWidth/2);
        tempHeight = floatPercent*tempHeight/2;
        return tempHeight + 20/2 - 10;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _systemTableView) {
        NSLog(@"system-----");
        return _listSystem.count;
    }else if (tableView == _messageTableView) {
        NSLog(@"message-----");
        return _listMessage.count;
    }else {
        return _listInfo.count;
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _messageTableView) {
        SChatLIstCellTableViewCell *celllist = [tableView dequeueReusableCellWithIdentifier:messageCellId];
//        SChatListCell *celllist = [tableView dequeueReusableCellWithIdentifier:messageCellId forIndexPath:indexPath];
        celllist.separatorInset = UIEdgeInsetsZero;
        SChatListModel *model = _listMessage[indexPath.row];
        celllist.model = model;
        return celllist;
    }
    else if (tableView == _systemTableView) {
        SChatSystemListCellTableViewCell *celllist = [tableView dequeueReusableCellWithIdentifier:systemCellId];
        SChatSystemListModel *model = _listSystem[indexPath.row];
        celllist.model = model;
        NSLog(@"model ---- %@ ---- %@", model, [model class]);
        return celllist;
    }else {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:_listInfo[indexPath.row]];
        SFashionViewCell *cell = (SFashionViewCell *)[tableView dequeueReusableCellWithIdentifier:fashionCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellData = tempDic;
        [cell updateCellUI];
        return  cell;
    }
}

#pragma mark - delegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedIndex == 1) {
        SChatController *vc = [SChatController new];
        __block SChatListModel *model = _listMessage[indexPath.row];//_list[indexPath.row];
        vc.targetName = model.name;
        vc.targetUserId = model.targetUserId;
        vc.img = model.img;
//        self.infoTableView.hidden=YES;
        [self.navigationController pushViewController:vc animated:YES];
        if ([model.num intValue] > 0) {
            
            int tempNum = [model.num intValue];
            
            SChatListModel *model2 = model;
            model2.num = @0;
            NSDictionary *param = @{@"toUserId" : model.targetUserId};
            [[SDataCache sharedInstance] get:@"Message" action:@"clearMessageWithUser" param:param success:^(AFHTTPRequestOperation *operation, id object) {
                model = model2;
                UNREAD_ALL_NUMBER -= tempNum;
                [self updataTitle];
                [self updataBadgeView];
            } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            
        }
        
    }else if (_selectedIndex == 0) {
/*
//        self.infoTableView.hidden=YES;
        SChatSystemListModel *model = _listSystem[indexPath.row];
        NSDictionary *dictionary = @{ @"is_h5" : model.SChatSystemListBannerInfo.is_h5,
                                      @"url" : model.SChatSystemListBannerInfo.url,
                                      @"name" : model.message,
                                      @"show_type" : model.SChatSystemListBannerInfo.type,
                                      @"tid" : model.SChatSystemListBannerInfo.tid };
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [[SUtilityTool shared] jumpControllerWithContent:dictionary target:self];
        //为什么要remove?
//        [_listSystem removeObjectAtIndex:indexPath.row];
//        _list = _listSystem;
        if ([model.is_read intValue] != 1) {
            --UNREAD_ALL_NUMBER;
            --MAIL_COUNT;
        }
        [self updataTitle];
        [self updataBadgeView];
  */
        NSDictionary *tempDict = _listInfo[indexPath.row];
        [SUTIL showWebpage:tempDict[@"url"] titleName:tempDict[@"name"] shareImg:nil];

    }else if (_selectedIndex == 2) {
        NSDictionary *tempDict = _listInfo[indexPath.row];
        
        [SUTIL showWebpage:tempDict[@"url"] titleName:tempDict[@"name"] shareImg:nil];
    }
}

// Editing
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if (_selectedIndex == 2) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
     */
    return UITableViewCellEditingStyleNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) {
    return @"删除";
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *userID;
        if (_selectedIndex == 1) {
            SChatListModel *model = _listMessage[indexPath.row];
            userID = model.targetUserId;
            UNREAD_ALL_NUMBER -= [model.num intValue];
            [self updataTitle];
            [self updataBadgeView];
            [[SDataCache sharedInstance] get:@"Message" action:@"deMessageByUserId" param:@{@"userId" : userID} success:^(AFHTTPRequestOperation *operation, id object) {
                [_listMessage removeObjectAtIndex:indexPath.row];
//                _list = _listMessage;
                [_messageTableView reloadData];
                if (!_noDataView && _listMessage.count == 0) {
                    _noDataView = [self createNoDataView];
                    [self.view addSubview:_noDataView];
                }
            } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }else if (_selectedIndex == 0) {
            SChatSystemListModel *model = _listSystem[indexPath.row];
            userID = model.aid;
            [[SDataCache sharedInstance] get:@"Message" action:@"deMailByid" param:@{@"mid" : userID} success:^(AFHTTPRequestOperation *operation, id object) {
                    [_listSystem removeObjectAtIndex:indexPath.row];
//                    _list = _listSystem;
                    [_systemTableView reloadData];
                if (!_noDataView && _listSystem.count == 0) {
                    _noDataView = [self createNoDataView];
                    [self.view addSubview:_noDataView];
                }
            } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
    }
}

#pragma mark - 
#pragma mark - kLeftMainViewDelegate
- (void)kLeftMainViewSwipeDelegate {
    [[SUtilityTool shared] hideLeftMenuView];
}

- (void)kLeftMainViewDidSelectWithType:(kLeftViewJumpType)type{
    [[SUtilityTool shared] jumpControllerWithType:type target:self];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    if (point.x == 0)   _selectedIndex = 0;
    else                _selectedIndex = 1;
    [self topViewConfig];
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
