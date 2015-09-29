//
//  SMineFollowViewController.m
//  Wefafa
//
//  Created by Funwear on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMineFollowFollowerViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "WeFaFaGet.h"
#import "HttpRequest.h"
#import "Toast.h"
#import "MBOtherUserInfoModel.h"
#import "SMineViewController.h"
#import "ModelBase.h"
#import "SUtilityTool.h"
@interface SMineFollowFollowerViewController()<SMineDesignerTableViewDelegate>
{
    NSInteger _pageIndex;
    
    //无我的粉丝和关注背景视图
    UIView *placeholdView;
}

@end

@implementation SMineFollowFollowerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavbar];
    _pageIndex = 0;
    
    
    
    __unsafe_unretained typeof(self) p = self;
     UIEdgeInsets edgeInset = UIEdgeInsetsMake(64,0, 0, 0);
    
    _attentionTableView = [[SMineDesignerTableView alloc]initWithFrame:self.view.frame];
    _attentionTableView.contentInset=edgeInset;
    [_attentionTableView addFooterWithTarget:self action:@selector(requestListAddData)];
    _attentionTableView.tableViewDelegate = self;
    _attentionTableView.backgroundColor=COLOR_NORMAL;
    _attentionTableView.opration = ^(NSIndexPath *indexPath, NSArray *array){
        MBOtherUserInfoModel *model = array[indexPath.row];
        SMineViewController *vc = [[SMineViewController alloc]init];
        switch (p.selectedIndex) {
            case 1:
                vc.person_id = model.concernId;
                break;
            case 2:
                vc.person_id = model.userId;
                break;
            default:
                break;
        }
        
        [p.navigationController pushViewController:vc animated:YES];
        //46cfdc07-80ed-4a30-b0ef-c9d39d76bd8c(lldb) po sns.ldap_uid99c23812-4814-466e-b9ad-054b1c2262ef
    };
    
    [self.view addSubview:_attentionTableView];
    [self requestDesignerList];

}


-(void)setupNavbar
{
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(btnBackClick:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    //设置标头
    switch (_selectedIndex) {
        case 1:
            if ([sns.ldap_uid isEqualToString:_person_id]) {
                self.title=@"我的关注";
            }else{
                self.title=@"Ta的关注";
            }
            break;
        case 2:
            if ([sns.ldap_uid isEqualToString:_person_id]) {
                self.title=@"我的粉丝";
            }else{
                self.title=@"Ta的粉丝";
            }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)requestListAddData{
    
    _pageIndex = (_attentionTableView.contentArray.count + 19)/ 20;
    NSNumber *isAbandonRefresh = [_attentionTableView valueForKey:@"isAbandonRefresh"];
    if (isAbandonRefresh.boolValue) {
         [_attentionTableView footerEndRefreshing];
        return;
    }else{
        [_attentionTableView setValue:@YES forKey:@"isAbandonRefresh"];
    }
    [self requestDesignerList];
}
- (void)requestDesignerList{

    NSString *methodName = @"";
    NSString *uid=@"";
    BOOL isattend = NO;
    switch (_selectedIndex) {
        case 1://关注
            methodName = @"UserConcernFilter";
            uid=@"userId";
            isattend = YES;
            break;
        case 2://粉丝
            methodName = @"UserConcernByConcernIdFilter";
            uid=@"concernId";
            isattend = NO;
            break;
        default:
            break;
    }
    

    NSString *loginUserID = sns.ldap_uid? sns.ldap_uid: @"";
    NSDictionary *data = @{@"m": @"Account",
                             @"a": methodName,
                             uid:_person_id,
                             @"LoginUserId":loginUserID,
                             @"PageIndex":@(_pageIndex),
                             @"PageSize": @20};
    
    NSLog(@"params－－－%@",data);
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        [Toast hideToastActivity];
        NSLog(@"data－－－%@",responseObject);
        NSMutableArray * responseAry= (NSMutableArray *)responseObject[@"results"];
        if(responseAry.count==0&&_pageIndex==0){
            [_attentionTableView performSelector:@selector(setContentArray:) withObject:responseAry];
            [_attentionTableView footerEndRefreshing];
        }else{
            NSMutableArray *array = [MBOtherUserInfoModel modelArrayWithDataArray:responseAry WithType:isattend];
            
            [_attentionTableView footerEndRefreshing];
            if (_pageIndex == 0) {
                [_attentionTableView performSelector:@selector(setContentArray:) withObject:array];
            }else{
                [_attentionTableView.contentArray addObjectsFromArray:array];
                _attentionTableView.contentArray = _attentionTableView.contentArray;
            }
        }
        if(_attentionTableView.contentArray.count==0){
            [self configNotifyViewWithTitle];
        }
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [_attentionTableView footerEndRefreshing];
        NSLog(@"他人店铺我的粉丝请求错误---%@", error);
        [Toast hideToastActivity];
         [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
    }];
}
#pragma mark - scroll delegate
- (void)listViewWillBeginDraggingScroll:(UIScrollView *)scrollView{

}
- (void)listViewDidScroll:(UIScrollView *)scrollView{

}
#pragma mark - need reload data delegate
- (void)needRequestLoadData:(UITableView *)tableView{
    if(_attentionTableView.contentArray.count==1&&_selectedIndex==1){
        _pageIndex=0;
        
    }
    [self requestDesignerList];
}

- (void)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)configNotifyViewWithTitle{
    if (placeholdView) {
        [placeholdView removeFromSuperview];
        placeholdView = nil;
    }
    placeholdView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, _attentionTableView.frame.size.height-64)];
    [placeholdView setBackgroundColor:COLOR_NORMAL];
    
    
    
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (placeholdView.frame.size.height-20)/2, SCREEN_WIDTH, 20)];
    [messageLabel setFont:FONT_t5];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setTextColor:COLOR_C6];
    [messageLabel setTag:100];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60)/2, messageLabel.frame.origin.y-messageLabel.frame.size.height-60, 60, 60)];
    [imgView setImage:[UIImage imageNamed:@"Unico/ico_nofollower"]];
    imgView.contentMode=UIViewContentModeScaleAspectFill;
    [placeholdView addSubview:imgView];
    
    
    NSString *str=@"";
    switch (_selectedIndex) {
        case 1://关注
            str=@"还没有关注其他人";
            break;
        case 2://粉丝
            str=@"还没有粉丝";
            break;
        default:
            break;
    }
    if ([sns.ldap_uid isEqualToString:_person_id]){
        str=[NSString stringWithFormat:@"您%@",str];
    }else{
        str=[NSString stringWithFormat:@"Ta%@",str];
    }
    
    [messageLabel setText:str];
    
    [placeholdView addSubview:messageLabel];
    [_attentionTableView addSubview:placeholdView];
}

@end
