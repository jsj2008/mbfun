//
//  SPriseViewController.m
//  Wefafa
//
//  Created by wave on 15/7/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SPriseViewController.h"
#import "SUtilityTool.h"
#import "Utils.h"
#import "SDataCache.h"
#import "UIScrollView+MJRefresh.h"
#import "SChatSystemListCellTableViewCell.h"    //system cell
#import "SChatSystemListModel.h"
#import "SChatLIstCellTableViewCell.h"          //private mess cell
#import "SChatListModel.h"
#import "SChatController.h"
#import "SChatSocket.h"
#import "SDataCache.h"
#import "SStarStoreViewController.h"

static NSString *cellid = @"SPriseCellID";

@interface SPriseViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int pageIndex;

@property (nonatomic) NSIndexPath *indexPathSelected;
@end

@implementation SPriseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //有选中cell
    if (_indexPathSelected) {
        if (_indexPath.row == 0 || _indexPath.row == 1 || _indexPath.row == 3) {
            [_tableView reloadRowsAtIndexPaths:@[_indexPathSelected] withRowAnimation:UITableViewRowAnimationNone];
        }else {
            [_tableView reloadData];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavbar];
    [self uiconfig];
    [self requestData];
}

- (void)setupNavbar {
    [super setupNavbar];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1];
}

- (void)uiconfig {
    self.view.backgroundColor = [UIColor whiteColor];
    switch (_indexPath.row) {
        case 0:
        {
            self.title = @"新的赞";
        }
            break;
        case 1:
        {
            self.title = @"新的评论";
        }
            break;
        case 2:
        {
            self.title = @"私聊";
        }
            break;
        case 3:
        {
            self.title = @"系统消息";
        }
            break;
            
        default:
            break;
    }
    
    if (_indexPath.row == 0 || _indexPath.row == 1 || _indexPath.row == 3) {
        [_tableView registerNib:[UINib nibWithNibName:@"SChatSystemListCellTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
    }else {
        [_tableView registerNib:[UINib nibWithNibName:@"SChatLIstCellTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
    }
    _pageIndex = 0;
    _dataArray = [NSMutableArray new];
    _tableView.tableFooterView = [UIView new];
    [_tableView addHeaderWithTarget:self action:@selector(requestNewData)];
    [_tableView addFooterWithTarget:self action:@selector(addMoreData)];
    
    UIBarButtonItem *barItem = [UIBarButtonItem new];
}

- (void)requestNewData {
    _pageIndex = 0;
    [self requestData];
}

- (void)addMoreData {
    _pageIndex = (int)(_dataArray.count + 9) / 10;
    [self requestData];
}

- (void)requestData {
    
    //    m=Message
    //    a=getMailList($token = null, $page = 0, $type = 0)
    //
    //    参数说明
    //    type=1 系统通知
    //    type=2 喜欢搭配通知
    //    type=3 评论搭配通知
    //    type=0 所有通知
    NSInteger type = 0;
    switch (_indexPath.row) {
        case 0:
            type = 2;
            break;
        case 1:
            type = 3;
            break;
        case 2:
        {
            //private message call another API
        }
            break;
        case 3:
            type = 1;
            break;
            
        default:
            break;
    }
    
//    m=Message
//    a=getMailList($token = null, $page = 0, $type = 0)
//    
//    参数说明
//    type=1 系统通知
//    type=2 喜欢搭配通知
//    type=3 评论搭配通知
//    type=0 所有通知
    
    if (_indexPath.row == 2) {  //私聊
        [[SDataCache sharedInstance] get:@"Message" action:@"getMessageUserList" param:@{@"page":@(_pageIndex)} success:^(AFHTTPRequestOperation *operation, id object) {
            if ([object[@"status"] intValue] == 1) {
             NSArray *ary = object[@"data"];
                if (ary.count == 0) {
                    if (_pageIndex == 0) {
                        [self.view addSubview:[self createNoDataView]];
                    }else {
                        [self uiconfigWithRequest];
                    }
                }else {
                    if (_pageIndex == 0) {
                        [_dataArray removeAllObjects];
                    }
                    for (NSDictionary *dic in ary) {
                        SChatListModel *model = [[SChatListModel alloc] initWithDict:dic];
                        [_dataArray addObject:model];
                    }
                    [_tableView reloadData];
                    [self uiconfigWithRequest];
                }
            }
        } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self uiconfigWithRequest];
        }];
        return;
    }
    
    NSDictionary *param = @{ @"m" : @"Message",
                             @"a" : @"getMailList",
                             @"page" : @(_pageIndex),
                             @"type" : @(type) };
    [[SDataCache sharedInstance] get:@"Message" action:@"getMailList" param:param success:^(AFHTTPRequestOperation *operation, id object) {
        if ([object[@"status"] intValue] == 1) {
            if ([((NSArray*)object[@"data"]) count] == 0) { //空数据占位图
                if (_pageIndex == 0) {
                    [self.view addSubview:[self createNoDataView]];
                }else {
                    [self uiconfigWithRequest];
                }
            }else {
                if (_pageIndex == 0) {
                    [_dataArray removeAllObjects];
                }
                for (NSDictionary *dic in object[@"data"]) {
                    SChatSystemListModel *model = [[SChatSystemListModel alloc] initWithDic:dic];
                    [_dataArray addObject:model];
                    if (type == 2) {  //prise
                        if ([dic[@"is_read"] intValue] != 1) {  //未读
                            LIKE_COUNT -= 1;
                            UNREAD_ALL_NUMBER -= 1;
                        }
                    }else if (type == 3) {  //comment
                        if ([dic[@"is_read"] intValue] != 1) {  //未读
                            COMMENT_COUNT -= 1;
                            UNREAD_ALL_NUMBER -= 1;
                        }
                    }else { //system
                        if ([dic[@"is_read"] intValue] != 1) {  //未读
                            SYS_COUNT -= 1;
                            UNREAD_ALL_NUMBER -= 1;
                        }
                    }
                }
                [_tableView reloadData];
                [self uiconfigWithRequest];
            }
        }
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self uiconfigWithRequest];
    }];
}

- (void)uiconfigWithRequest {
    [_tableView footerEndRefreshing];
    [_tableView headerEndRefreshing];
}

-(UIView*)createNoDataView{
    UIView *tempView = [SUTIL createUIViewByHeight:(UI_SCREEN_HEIGHT-64) coordY:64];
    tempView.backgroundColor=COLOR_NORMAL;
    NSString *imgName, *text;
    if (_indexPath.row == 2) {//私聊
        imgName = @"Unico/ico_noinformation";
        text = @"您还未收到私聊";
    }else if(_indexPath.row == 3){
        imgName = @"Unico/ico_noinformation";
        text = @"您还未收到系统消息";
    }else if(_indexPath.row == 0){
        imgName = @"Unico/ico_nofollower";
        text = @"您还未获得赞";
    }else if(_indexPath.row == 1){
        imgName = @"Unico/ico_nocomment";
        text = @"您还未获得评论";
    }
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (tempView.frame.size.height-20)/2, UI_SCREEN_WIDTH, 20)];
    [label setText:text];//@"你还没有任何消息"];
    [label setTextColor:COLOR_C6];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:FONT_t5];
    [tempView addSubview:label];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH - 60)/2, label.frame.origin.y-label.frame.size.height-60, 60, 60)];
    [imgView setImage:[UIImage imageNamed:imgName]];//@"Unico/home_light"]];
    [tempView addSubview:imgView];
    /*
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
     */
    return tempView;
}

- (void)recommendDesigner
{
    if ([BaseViewController pushLoginViewController]) {
        SStarStoreViewController * starStoreVC = [[SStarStoreViewController alloc]init];
        [self.navigationController pushViewController:starStoreVC animated:YES];
    }
}

- (void)onBack:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (_indexPath.row == 0) {  //prise
        SChatSystemListCellTableViewCell *celllist = [tableView dequeueReusableCellWithIdentifier:cellid];
        SChatSystemListModel *model = _dataArray[indexPath.row];
        celllist.model = model;
        cell = celllist;
    }else if (_indexPath.row == 1) {    //comment
        SChatSystemListCellTableViewCell *celllist = [tableView dequeueReusableCellWithIdentifier:cellid];
        SChatSystemListModel *model = _dataArray[indexPath.row];
        celllist.model = model;
        cell = celllist;
    }else if (_indexPath.row == 2) {    //private message
        SChatLIstCellTableViewCell *celllist = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
        celllist.separatorInset = UIEdgeInsetsZero;
        SChatListModel *model = _dataArray[indexPath.row];
        celllist.model = model;
        cell = celllist;
    }else if (_indexPath.row == 3) {    //system message
        SChatSystemListCellTableViewCell *celllist = [tableView dequeueReusableCellWithIdentifier:cellid];
        SChatSystemListModel *model = _dataArray[indexPath.row];
        celllist.model = model;
        cell = celllist;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_indexPath.row == 0 || _indexPath.row == 1 || _indexPath.row == 3) {
        return 70;
    }else {
        return 65;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _indexPathSelected = indexPath;
    switch (_indexPath.row) {
        case 0:
        {
            SChatSystemListModel *model = _dataArray[indexPath.row];
            NSDictionary *dictionary = @{ @"is_h5" : model.SChatSystemListBannerInfo.is_h5,
                                          @"url" : model.SChatSystemListBannerInfo.url,
                                          @"name" : model.message,
                                          @"show_type" : model.SChatSystemListBannerInfo.type,
                                          @"tid" : model.SChatSystemListBannerInfo.tid };
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [[SUtilityTool shared] jumpControllerWithContent:dictionary target:self];
            if ([model.is_read intValue] != 1) {
                --UNREAD_ALL_NUMBER;
//                --MAIL_COUNT;
                --LIKE_COUNT;
                //更改数据源     // 红色数字 is_read == 1 已经读取 is_read == 0 没有读取
                model.is_read = @"1";
                [_dataArray replaceObjectAtIndex:indexPath.row withObject:model];
            }
        }
            break;
        case 1:
        {
            SChatSystemListModel *model = _dataArray[indexPath.row];
            NSDictionary *dictionary = @{ @"is_h5" : model.SChatSystemListBannerInfo.is_h5,
                                          @"url" : model.SChatSystemListBannerInfo.url,
                                          @"name" : model.message,
                                          @"show_type" : model.SChatSystemListBannerInfo.type,
                                          @"tid" : model.SChatSystemListBannerInfo.tid };
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [[SUtilityTool shared] jumpControllerWithContent:dictionary target:self];
            if ([model.is_read intValue] != 1) {
                --UNREAD_ALL_NUMBER;
//                --MAIL_COUNT;
                --COMMENT_COUNT;
                //更改数据源     // 红色数字 is_read == 1 已经读取 is_read == 0 没有读取
                model.is_read = @"1";
                [_dataArray replaceObjectAtIndex:indexPath.row withObject:model];
            }
        }
            break;
        case 2: //private message
        {
            SChatController *vc = [SChatController new];
            __block SChatListModel *model = _dataArray[indexPath.row];
            vc.targetName = model.name;
            vc.targetUserId = model.targetUserId;
            vc.img = model.img;
            [self.navigationController pushViewController:vc animated:YES];
            if ([model.num intValue] > 0) {
                
                int tempNum = [model.num intValue];
                
                SChatListModel *model2 = model;
                model2.num = @0;
                NSDictionary *param = @{@"toUserId" : model.targetUserId};
                [[SDataCache sharedInstance] get:@"Message" action:@"clearMessageWithUser" param:param success:^(AFHTTPRequestOperation *operation, id object) {
                    model = model2;
                    UNREAD_ALL_NUMBER -= tempNum;
                    MESS_COUNT -= tempNum;
                    //                    [self updataTitle];
                    //                    [self updataBadgeView];
                } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                
            }
            
        }
            break;
        case 3:
        {
            SChatSystemListModel *model = _dataArray[indexPath.row];
            NSDictionary *dictionary = @{ @"is_h5" : model.SChatSystemListBannerInfo.is_h5,
                                          @"url" : model.SChatSystemListBannerInfo.url,
                                          @"name" : model.message,
                                          @"show_type" : model.SChatSystemListBannerInfo.type,
                                          @"tid" : model.SChatSystemListBannerInfo.tid };
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [[SUtilityTool shared] jumpControllerWithContent:dictionary target:self];
            if ([model.is_read intValue] != 1) {
                --UNREAD_ALL_NUMBER;
                --SYS_COUNT;
                //更改数据源     // 红色数字 is_read == 1 已经读取 is_read == 0 没有读取
                model.is_read = @"1";
                [_dataArray replaceObjectAtIndex:indexPath.row withObject:model];
            }
        }
            break;
        default:
            break;
    }
}

// Editing
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
     return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) {
    return @"删除";
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        /*
        NSString *userID;
        if (_selectedIndex == 1) {
            SChatListModel *model = _listMessage[indexPath.row];
            userID = model.targetUserId;
            UNREAD_ALL_NUMBER -= [model.num intValue];
//            [self updataTitle];
//            [self updataBadgeView];
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
        */
        NSString *userID = nil;
        if (_indexPath.row == 2) {  //private message
            SChatListModel *model = _dataArray[indexPath.row];
            userID = model.targetUserId;
            [[SDataCache sharedInstance] get:@"Message" action:@"deMessageByUserId" param:@{@"userId" : userID} success:^(AFHTTPRequestOperation *operation, id object) {
                UNREAD_ALL_NUMBER -= [model.num intValue];
                MESS_COUNT -= [model.num intValue];
                [_dataArray removeObjectAtIndex:indexPath.row];
                [_tableView reloadData];
                if (_dataArray.count == 0) {
                    [self.view addSubview:[self createNoDataView]];
                }
            } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }else {
            SChatSystemListModel *model = _dataArray[indexPath.row];
            userID = model.aid;
            [_dataArray removeObjectAtIndex:indexPath.row];
            [_tableView reloadData];
            if (_dataArray.count == 0) {
                [self.view addSubview:[self createNoDataView]];
            }
            [[SDataCache sharedInstance] get:@"Message" action:@"deMailByid" param:@{@"mid" : userID} success:^(AFHTTPRequestOperation *operation, id object) {
                
            } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
    }
}
//13112345678
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
