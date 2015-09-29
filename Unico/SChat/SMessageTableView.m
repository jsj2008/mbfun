//
//  SMessageTableView.m
//  Wefafa
//
//  Created by wave on 15/7/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMessageTableView.h"
#import "SPriseViewController.h"
#import "SMessageCell.h"
#import "SChatSocket.h"
#import "SFashionViewCell.h"
#import "Utils.h"
#import "SUtilityTool.h"
#import "SDataCache.h"

static NSString *messageCellID = @"messageCellID";
static NSString *messageBannerID = @"messageBannerID";

static SMessageTableView *g_SMessageTableView = nil;

@interface SMessageTableView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SMessageTableView
{
    NSMutableArray *_dataArray;
}

+ (instancetype)instance {
    return g_SMessageTableView;
}

- (void)reloadData_ {
    /*
    NSArray *count = @[@(LIKE_COUNT), @(COMMENT_COUNT), @(MESS_COUNT), @(SYS_COUNT)];
    for (int i = 0; i < count.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_dataArray[i]];
        [dic setValue:count[i] forKey:@"count"];
        [_dataArray replaceObjectAtIndex:i withObject:dic];
    }
    [self reloadData];
     */
    //重新请求消息个数
    [[SDataCache sharedInstance] get:@"Message" action:@"getMessageDetaisV2" param:nil success:^(AFHTTPRequestOperation *operation, id object) {
        if ([object[@"status"] intValue] == 1) {
            NSDictionary *dic = object[@"data"];
            //            MAIL_COUNT = [dic[@"mail_count"] intValue];
            //            MESS_COUNT = [dic[@"mess_count"] intValue];
            
            NSDictionary *dict = dic[@"count"];
            UNREAD_ALL_NUMBER = [dict[@"all_count"] intValue];
            COMMENT_COUNT = [dict[@"comment_count"] intValue];
            LIKE_COUNT = [dict[@"like_count"]intValue];
            MESS_COUNT = [dict[@"mess_count"] intValue];
            SYS_COUNT = [dict[@"sys_count"] intValue];
            NSArray *count = @[@(LIKE_COUNT), @(COMMENT_COUNT), @(MESS_COUNT), @(SYS_COUNT)];
            for (int i = 0; i < count.count; i++) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_dataArray[i]];
                [dic setValue:count[i] forKey:@"count"];
                [_dataArray replaceObjectAtIndex:i withObject:dic];
            }
            [self reloadData];
        }
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(instancetype)init {
    if (self == [super init]) {
        g_SMessageTableView = self;
    }
    return g_SMessageTableView;
}

- (void)setContentArray:(NSMutableArray *)contentArray {
    _contentArray = contentArray;
    [_dataArray addObjectsFromArray:_contentArray];
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64);
    if (self == [super initWithFrame:frame style:style]) {
        _dataArray = [NSMutableArray new];
        NSArray *aryImg = @[@"Unico/praise.png", @"Unico/comment.png", @"Unico/privatemessage.png", @"Unico/systemhead.png"];
        NSArray *aryText = @[@"新的赞" , @"新的评论" , @"私聊" , @"系统消息"];
        //FIXME: 未读消息个数后台确认
        NSArray *count = @[@(LIKE_COUNT), @(COMMENT_COUNT), @(MESS_COUNT), @(SYS_COUNT)];
        for (int i = 0; i < aryImg.count; i++) {
            NSDictionary *dic = @{ @"img" : aryImg[i],
                                   @"text" : aryText[i],
                                   @"count" : count[i] };
            [_dataArray addObject:dic];
        }
        self.tableFooterView = [UIView new];
        [self registerNib:[UINib nibWithNibName:@"SMessageCell" bundle:nil] forCellReuseIdentifier:messageCellID];
        self.dataSource = self;
        self.delegate = self;
//        [self reloadData];
    }
    return self;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.row <= 3) {
        SMessageCell *celll = [tableView dequeueReusableCellWithIdentifier:messageCellID forIndexPath:indexPath];
        celll.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dic = _dataArray[indexPath.row];
        celll.dic = dic;
        cell = celll;
    }else {
        NSDictionary *tempDic = _dataArray[indexPath.row];
        SFashionViewCell *celll = (SFashionViewCell *)[tableView dequeueReusableCellWithIdentifier:messageBannerID];
        if (!celll) {
            celll = [[SFashionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageBannerID];
            celll.selectionStyle = UITableViewCellSelectionStyleNone;
            celll.type = fashionCellTypeHideTransparentView;
        }
        celll.cellData = tempDic;
        [celll setCellData:tempDic];
        [celll updateCellUI];
        cell = celll;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < 4) {
        SPriseViewController *vc = [SPriseViewController new];
        vc.indexPath = indexPath;
        [_target.navigationController pushViewController:vc animated:YES];
    }else {
        NSDictionary *tempDict = _dataArray[indexPath.row];
        [SUTIL showWebpage:tempDict[@"url"] titleName:tempDict[@"name"] shareImg:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <= 3) {
        return 65;
    }else {
        NSDictionary *dict = _dataArray[indexPath.row];
        float tempHeight = [dict[@"img_height"] floatValue];
        float tempWidth = [dict[@"img_width"] floatValue];
        float floatPercent = UI_SCREEN_WIDTH/(tempWidth/2);
        tempHeight = floatPercent*tempHeight/2;
        return tempHeight + 20/2 - 10;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.target.tabBarController setValue:scrollView forKey:@"controlScrollView"];
}
@end
