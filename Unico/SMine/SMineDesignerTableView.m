//
//  SMineDesignerTableView.m
//  Wefafa
//
//  Created by unico_0 on 6/6/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SMineDesignerTableView.h"
#import "SMineTableViewCell.h"
#import "MBOtherUserInfoModel.h"
#import "Toast.h"
#import "HttpRequest.h"
#import "WeFaFaGet.h"
#import "SUtilityTool.h"
@interface SMineDesignerTableView () <UITableViewDataSource, UITableViewDelegate, SMineTableViewCellDelegate, UIAlertViewDelegate>
{
    NSInteger _currentIndex;
    UIButton *_attentionButton;
}
@end

static NSString *cellIdentifier = @"SMineTableViewCellIdentifier";
@implementation SMineDesignerTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerNib:[UINib nibWithNibName:@"SMineTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [[UIView alloc]init];
        
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.separatorColor = COLOR_C9;
         [self setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    }
    return self;
}

- (void)setContentArray:(NSMutableArray *)contentArray{
    _contentArray = contentArray;
    [self reloadData];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    MBOtherUserInfoModel *model = _contentArray[indexPath.row];
//    model.isConcerned=@3;
    cell.contentModel = model;
    if(_contentArray.count==indexPath.row+1){
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = COLOR_C9.CGColor;
        layer.frame = CGRectMake(0,cell.frame.size.height - 0.5, cell.frame.size.width, 0.5);
        layer.zPosition = 5;
        [cell.layer addSublayer:layer];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.opration) {
        self.opration(indexPath, _contentArray);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.tableViewDelegate respondsToSelector:@selector(listViewDidScroll:)]) {
        [self.tableViewDelegate listViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self.tableViewDelegate respondsToSelector:@selector(listViewWillBeginDraggingScroll:)]) {
        [self.tableViewDelegate listViewWillBeginDraggingScroll:scrollView];
    }
}

- (void)mineTableConetntModel:(MBOtherUserInfoModel *)model attentionButtonAction:(UIButton *)sender{
//    if ([sender isSelected]) {
//        _attentionButton = sender;
//        _currentIndex = [_contentArray indexOfObject:model];
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认取消关注" message:@"您将取消对此用户的关注！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//        alertView.delegate = self;
//        [alertView show];
//    }else{
//        NSString *userID = @"";
//        //他人粉丝中  concernid 是选中人的id  userid 是选中人的粉丝的id
//        //他人关注中 concernid 是选中人关注的人的id   userid 是当前选中人的id
//        if ([sns.ldap_uid isEqualToString:model.userId]) {
//            userID = model.concernId;
//            
//        }else{
//            userID = model.userId;
//        }
//        if (model.isAttend) {
//           userID = model.concernId;
//        }
//        else
//        {
//            userID = model.userId;
//        }
//        NSString *loginUserID = sns.ldap_uid? sns.ldap_uid: @"";
//        NSDictionary *data=@{@"m":@"Account",
//                             @"a":@"UserConcernCreate",
//                             @"userId":loginUserID,
//                             @"concernId":userID};
//        AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
//        [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id dict) {
//            [Toast hideToastActivity];
//            
//                        if ([[dict allKeys]containsObject:@"isSuccess"]) {
//                            BOOL  isSuccess = [dict[@"isSuccess"] boolValue];
//                            if(!isSuccess)
//                            {
//                                NSString *message =nil;
//                                message = dict[@"message"];
//                                [Toast makeToast:message duration:1.5 position:@"center"];
//                                return ;
//                            }
//                        }
//            
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAttend" object:nil];
//            
//                        model.isConcerned = @YES;
//                        self.isAbandonRefresh = @NO;
//                        [self reloadData];
//                        if([self.tableViewDelegate respondsToSelector:@selector(needRequestLoadData:)]){
//                            [self.tableViewDelegate needRequestLoadData:self];
//                        }
//            //            [Toast makeToast:@"关注成功!" duration:1.5 position:@"center"];
//                        [Toast makeToastSuccess:@"关注成功!"];
//                        NSDictionary *dic = @{@"type":@0};
//                        //            1是取消减一 0 是加一 关注
//            
//                        [[NSNotificationCenter defaultCenter] postNotificaftionName:@"changeNumber" object:nil userInfo:dic];
//        } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
//            [Toast makeToast:@"关注失败!" duration:1.5 position:@"center"];
//        }];
//
        switch ([model.isConcerned integerValue]) {
            case 0:
//            case 2:
            {
                NSString *userID = @"";
                //他人粉丝中  concernid 是选中人的id  userid 是选中人的粉丝的id
                //他人关注中 concernid 是选中人关注的人的id   userid 是当前选中人的id
                if ([sns.ldap_uid isEqualToString:model.userId]) {
                    userID = model.concernId;
                    
                }else{
                    userID = model.userId;
                }
                if (model.isAttend) {
                    userID = model.concernId;
                }
                else
                {
                    userID = model.userId;
                }
                NSString *loginUserID = sns.ldap_uid? sns.ldap_uid: @"";
                NSDictionary *data=@{@"m":@"Account",
                                     @"a":@"UserConcernCreate",
                                     @"userId":loginUserID,
                                     @"concernId":userID};
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
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAttend" object:nil];

                    model.isConcerned = @YES;
                    self.isAbandonRefresh = @NO;
                    [self reloadData];
                    if([self.tableViewDelegate respondsToSelector:@selector(needRequestLoadData:)]){
                        [self.tableViewDelegate needRequestLoadData:self];
                    }
                    //            [Toast makeToast:@"关注成功!" duration:1.5 position:@"center"];
                    [Toast makeToastSuccess:@"关注成功!"];
                    NSDictionary *dic = @{@"type":@0};
                    //            1是取消减一 0 是加一 关注
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeNumber" object:nil userInfo:dic];
                } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                    [Toast makeToast:@"关注失败!" duration:1.5 position:@"center"];
                }];
            }
                break;
            case 1:
            case 3:
            case 2:{
                _attentionButton = sender;
                _currentIndex = [_contentArray indexOfObject:model];
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认取消关注" message:@"您将取消对此用户的关注！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alertView.delegate = self;
                [alertView show];
                
            }
                break;
            default:
                break;
        }

//    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
    {
        MBOtherUserInfoModel *model = _contentArray[_currentIndex];
        NSString *userID = @"";
        if ([sns.ldap_uid isEqualToString:model.userId]) {
            userID = model.concernId;
        }else{
            userID = model.userId;
        }
        //他人粉丝中  concernid 是选中人的id  userid 是选中人的粉丝的id
        //他人关注中 concernid 是选中人关注的人的id   userid 是当前选中人的id
        if (model.isAttend) {
            userID = model.concernId;
        }
        else
        {
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
            _attentionButton.userInteractionEnabled = YES;
            
            [self reloadData];
            if([self.tableViewDelegate respondsToSelector:@selector(needRequestLoadData:)]){
                [self.tableViewDelegate needRequestLoadData:self];
            }
            
            NSDictionary *dic = @{@"type":@1};
            //            1是取消减一 0 是加一 关注
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeNumber" object:nil userInfo:dic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAttend" object:nil];
            //            [Toast makeToast:@"已取消关注!" duration:1.5 position:@"center"];
            [Toast makeToastSuccess:@"已取消关注!"];
            
        } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            _attentionButton.userInteractionEnabled = YES;
            [Toast makeToast:@"取消关注失败!" duration:1.5 position:@"center"];
        }];
    }else{
        _attentionButton.userInteractionEnabled = YES;
    }
}

@end
