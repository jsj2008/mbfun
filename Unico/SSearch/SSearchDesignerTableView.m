//
//  SSearchAttentionTableView.m
//  Wefafa
//
//  Created by unico_0 on 5/31/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SSearchDesignerTableView.h"
#import "SMineTableViewCell.h"
#import "MBOtherUserInfoModel.h"
#import "HttpRequest.h"
#import "SUtilityTool.h"
#import "WeFaFaGet.h"
#import "Toast.h"

@interface SSearchDesignerTableView ()<UITableViewDataSource, UITableViewDelegate, SMineTableViewCellDelegate>
{
    NSInteger _currentIndex;
}

@property (nonatomic, weak) UIView *showNoneData;

@end

static NSString *cellIdentifier = @"SMineTableViewCellIdentifier";
@implementation SSearchDesignerTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerNib:[UINib nibWithNibName:@"SMineTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [[UIView alloc]init];
        _contentModelArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)setContentArray:(NSArray *)contentArray
{
   /* NSMutableArray *tempArr = [NSMutableArray arrayWithArray:contentArray];
    [tempArr removeObjectsInArray:_contentArray];
    _contentArray = contentArray;
    NSArray *array = [MBOtherUserInfoModel modelArrayWithDataArray:tempArr];
    [_contentModelArray addObjectsFromArray:array];
    [self reloadData];*/
    
    _contentArray = contentArray;
    _contentModelArray = [NSMutableArray arrayWithArray:[MBOtherUserInfoModel modelArrayWithDataArray:contentArray]];
    [self reloadData];
}

- (UIView *)showNoneData{
    if (!_showNoneData) {
        CGRect frame = CGRectMake(0, -200, self.frame.size.width, 200);
        UIView *view = [[UIView alloc]initWithFrame:frame];
        view.backgroundColor = [UIColor whiteColor];
        frame.origin.y = 0;
        frame.size.height = 160;
        UILabel *label = [[UILabel alloc]initWithFrame:frame];
        label.textColor = COLOR_C6;
        label.font = FONT_t5;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"抱歉，没有找到相关的造型师，请重新搜索";
        [view addSubview:label];
        
        frame = CGRectMake(0, 160, self.frame.size.width, 40);
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:frame];
        nameLabel.backgroundColor = COLOR_C4;
        nameLabel.textColor = COLOR_C6;
        nameLabel.font = FONT_t4;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = @"热门造型师推荐";
        [view addSubview:nameLabel];
        
        frame = CGRectMake(10, 20, 100, 0.5);
        CALayer *leftLayer = [CALayer layer];
        leftLayer.backgroundColor = COLOR_C9.CGColor;
        leftLayer.frame = frame;
        leftLayer.zPosition = 5;
        [nameLabel.layer addSublayer:leftLayer];
        
        frame = CGRectMake(self.frame.size.width - 110, 20, 100, 0.5);
        CALayer *rightLayer = [CALayer layer];
        rightLayer.backgroundColor = COLOR_C9.CGColor;
        rightLayer.frame = frame;
        rightLayer.zPosition = 5;
        [nameLabel.layer addSublayer:rightLayer];
        
        [self addSubview:view];
        _showNoneData = view;
    }
    return _showNoneData;
}

- (void)setIsHotData:(NSNumber *)isHotData{
    _isHotData = isHotData;
    if (isHotData.boolValue) {
        if (_showNoneData) {
            return;
        }else{
            UIEdgeInsets edgeInset = self.contentInset;
            edgeInset.top = 200;
            self.contentInset = edgeInset;
            self.contentOffset = CGPointMake(0, - 200);
            [self showNoneData];
        }
    }else{
        UIEdgeInsets edgeInset = self.contentInset;
        edgeInset.top = 0;
        self.contentInset = edgeInset;
        [_showNoneData removeFromSuperview];
    }
}
#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentModelArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.contentModel = _contentModelArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.opration) {
        self.opration(indexPath, _contentModelArray);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.tableViewDelegate respondsToSelector:@selector(listViewDidScroll:)]) {
        [self.tableViewDelegate listViewDidScroll:scrollView];
    }
}

#pragma mark - cell attention delegate
- (void)mineTableConetntModel:(MBOtherUserInfoModel *)model attentionButtonAction:(UIButton *)sender{
    if ([sender isSelected]) {
        _currentIndex = [_contentModelArray indexOfObject:model];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认取消关注" message:@"您将取消对此用户的关注！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.delegate = self;
        [alertView show];
    }else{
        NSString *userID = @"";
        if ([sns.ldap_uid isEqualToString:model.userId]) {
            userID = model.concernId;
        }else{
            userID = model.userId;
        }
//        NSDictionary *paramDic=@{@"UserId": sns.ldap_uid,
//                                 @"ConcernId": userID,
//                                 @"ConcernType":@"造型师"
//                                 };
//        
        NSDictionary *data=@{@"m":@"Account",
                             @"a":@"UserConcernCreate",
                             @"userId":sns.ldap_uid,
                             @"concernId":userID};
//        [HttpRequest accountPostRequestPath:nil methodName:@"UserConcernCreate" params:paramDic success:^(NSDictionary *dict) {
//            
//            if ([[dict allKeys]containsObject:@"isSuccess"]) {
//                BOOL  isSuccess = [dict[@"isSuccess"] boolValue];
//                if(!isSuccess)
//                {
//                    NSString *message =nil;
//                    message = dict[@"message"];
//                    [Toast makeToast:message duration:1.5 position:@"center"];
//                    return ;
//                }
//            }
//            model.isConcerned = @YES;
//            self.isAbandonRefresh = @NO;
//            [self reloadData];
////            [Toast makeToast:@"关注成功!" duration:1.5 position:@"center"];
//            [Toast makeToastSuccess:@"关注成功!"];
//        } failed:^(NSError *error) {
//            [Toast makeToast:@"关注失败!" duration:1.5 position:@"center"];
//        }];
        AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
        [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id dict) {
            [Toast hideToastActivity];
            if ([[dict allKeys]containsObject:@"isSuccess"]) {
                BOOL  isSuccess = [dict[@"isSuccess"] boolValue];
                if(!isSuccess)
                {
                    NSString *message =nil;
                    message = dict[@"message"];
                    [Toast makeToast:message duration:1.5 position:@"center"];
                    return ;
                }
            }
            model.isConcerned = @YES;
            self.isAbandonRefresh = @NO;
            [self reloadData];
            [Toast makeToastSuccess:@"关注成功!"];
            
        } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            [Toast makeToast:@"关注失败!" duration:1.5 position:@"center"];
        }];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
    {
        MBOtherUserInfoModel *model = _contentModelArray[_currentIndex];
        NSString *userID = @"";
        if ([sns.ldap_uid isEqualToString:model.userId]) {
            userID = model.concernId;
        }else{
            userID = model.userId;
        }
        NSString *loginUserID = sns.ldap_uid? sns.ldap_uid: @"";
        NSDictionary *data=@{@"m":@"Account",
                             @"a":@"UserConcernDelete",
                             @"userId":loginUserID,
                             @"concernIds":userID};
        AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
        [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id dict) {
            [Toast hideToastActivity];
            
            if ([[dict allKeys]containsObject:@"isSuccess"]) {
                BOOL  isSuccess = [dict[@"isSuccess"] boolValue];
                if(!isSuccess)
                {
                    NSString *message =nil;
                    message = dict[@"message"];
                    [Toast makeToast:message duration:1.5 position:@"center"];
                    return ;
                }
            }
            model.isConcerned = @NO;
            self.isAbandonRefresh = @NO;
            [self reloadData];
            [Toast makeToastSuccess:@"已取消关注!"];
            
        } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            [Toast makeToast:@"取消关注失败!" duration:1.5 position:@"center"];
        }];

        
//        NSDictionary *paramDic=@{@"UserId":sns.ldap_uid,
//                                 @"ConcernIds":userID};
//        [HttpRequest accountPostRequestPath:nil methodName:@"UserConcernDelete" params:paramDic success:^(NSDictionary *dict) {
//          
//            if ([[dict allKeys]containsObject:@"isSuccess"]) {
//                BOOL  isSuccess = [dict[@"isSuccess"] boolValue];
//                if(!isSuccess)
//                {
//                    NSString *message =nil;
//                    message = dict[@"message"];
//                    [Toast makeToast:message duration:1.5 position:@"center"];
//                    return ;
//                }
//            }
//            model.isConcerned = @NO;
//            self.isAbandonRefresh = @NO;
//            [self reloadData];
////            [Toast makeToast:@"已取消关注!" duration:1.5 position:@"center"];
//            [Toast makeToastSuccess:@"已取消关注!"];
//        } failed:^(NSError *error) {
//            [Toast makeToast:@"取消关注失败!" duration:1.5 position:@"center"];
//        }];
    }
}

@end
