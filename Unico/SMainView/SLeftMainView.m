//
//  SLeftMainView.m
//  Wefafa
//
//  Created by su on 15/6/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SLeftMainView.h"
#import "SDWebImageManager.h"
#import "WeFaFaGet.h"
#import "SUtilityTool.h"
#import "SDataCache.h"

#import "LeftMainViewTableViewCell.h"
#import "SLeftMainViewModel.h"

typedef NS_ENUM(NSInteger, JumpType) {
    TabelViewCellDidSelectCell = 0,     //点击cell
    TabelViewCellDidSelectCellIcon  //点击icon
};

@interface SLeftMainView ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *mainTable;
    UIToolbar *toolBar;

    NSArray *cellArray;
    UIView *_contentView;
    UIView *_showBackView;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

static SLeftMainView *g_SLeftMainView = nil;

@implementation SLeftMainView

+ (SLeftMainView*)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_SLeftMainView = [[SLeftMainView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
        
    });
    return g_SLeftMainView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self configData];
    }
    return self;
}

- (void)initSubViews{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti_loginOut) name:@"noti_loginOut" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti_loginComplete) name:@"MBFUN_LOGIN_SUC" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeadImgView:) name:@"changeHeadImgView" object:nil];
    _showBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    _showBackView.alpha = 0;
    [_showBackView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.6]];
    [self addSubview:_showBackView];
    
    CGRect rect  = CGRectMake(0, 0, 255, UI_SCREEN_HEIGHT);
    _contentView = [[UIView alloc]initWithFrame:rect];
    [self addSubview:_contentView];
    [self setClipsToBounds:YES];
    toolBar = [[UIToolbar alloc] initWithFrame:rect];
    [toolBar setBarStyle:UIBarStyleDefault];
    [toolBar setTranslucent:YES];
    [_contentView.layer insertSublayer:toolBar.layer atIndex:0];
    [toolBar setUserInteractionEnabled:YES];
    
    
    mainTable = [[UITableView alloc] initWithFrame:rect];
    mainTable.scrollEnabled = NO;
    [mainTable setBackgroundColor:[UIColor clearColor]];
    mainTable.dataSource = self;
    mainTable.delegate = self;
    [mainTable setTableHeaderView:[self configTableHeaderView]];
//    [mainTable setTableFooterView:[self configTableFooterView]];
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.separatorColor = [UIColor clearColor];
    [_contentView addSubview:mainTable];
//    [mainTable registerClass:NSClassFromString(@"SLeftMainViewTableViewCell") forCellReuseIdentifier:leftMainViewTableViewCellID];
    [mainTable registerNib:[UINib nibWithNibName:@"LeftMainViewTableViewCell" bundle:nil] forCellReuseIdentifier:leftMainViewTableViewCellIdentifier];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftMainView)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipe];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEmptySpace)];
    [_showBackView addGestureRecognizer:tap];
    // @{@"imgName":@"Unico/ico_wallet",@"title":@"我的钱包",@"detail":@"买买买"}, 我的钱包 我的收益 屏蔽
    cellArray = @[@[@{@"imgName":@"Unico/ico_fanpiao",@"title":@"我的范票",@"detail":@"领取享优惠"},@{@"imgName":@"Unico/ico_collect",@"title":@"我的收藏"}],@[@{@"imgName":@"Unico/ico_scan",@"title":@"扫一扫"},@{@"imgName":@"Unico/ico_invite",@"title":@"我的邀请码",@"detail":@"有礼同分享"}],@[@{@"imgName":@"Unico/ico_bought",@"title":@"我买到的"},@{@"imgName":@"Unico/ico_service",@"title":@"联系客服"}]];
    //设置按钮
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - 80, 255, 80)];
    [footer setBackgroundColor:[UIColor clearColor]];
    [_contentView addSubview:footer];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(32, footer.frame.size.height - 30 - 30/*距离底部高度是30*/, 200, 30)];
    [btn addTarget:self action:@selector(clickSettingBtn) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btn];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 22, 22)];
    [imgV setImage:[UIImage imageNamed:@"Unico/ico_setting"]];
    [imgV setImage:[UIImage imageNamed:@"Unico/setting"]];
    [btn addSubview:imgV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 4, 40, 22)];
    [label setText:@"设置"];
    [label setTextColor:COLOR_C2];
    [label setFont:FONT_t4];
    [btn addSubview:label];
}

- (void)configData {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
        
        for (NSArray __strong *ary in SIDEBAR_ARRAY) {
            NSMutableArray *ary1 = [NSMutableArray new];
            [_dataArray addObject:ary1]; ary = ary;
        }
        for (NSArray *array in SIDEBAR_ARRAY) {
            NSMutableArray *tempArray = _dataArray[[SIDEBAR_ARRAY indexOfObject:array]];
            for (NSDictionary *dictionary in array) {
                SLeftMainViewModel *model = [[SLeftMainViewModel alloc] initWithDic:dictionary];
                [tempArray addObject:model];
            }
            _dataArray[[SIDEBAR_ARRAY indexOfObject:array]] = tempArray;
        }
    }
}

- (void)noti_loginComplete
{
    sns.isLogin = YES;
    mainTable.tableHeaderView=nil;
    [mainTable setTableHeaderView:[self configTableHeaderView]];
    [mainTable reloadData];
    
}

- (void)noti_loginOut
{
    [[SDataCache sharedInstance] logout];
    sns.isLogin=NO;
    mainTable.tableHeaderView=nil;
     [mainTable setTableHeaderView:[self configTableHeaderView]];
    [mainTable reloadData];

}
-(void)changeHeadImgView:(NSNotification *)sender
{
    [self noti_loginComplete];
}
- (UIView *)configTableHeaderView
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 255 * SCALE_UI_SCREEN, 115 * SCALE_UI_SCREEN)];
    UIImageView *headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(20 * SCALE_UI_SCREEN, 35 * SCALE_UI_SCREEN, 45 * SCALE_UI_SCREEN, 45 * SCALE_UI_SCREEN)];
    [headerImg.layer setCornerRadius:headerImg.width / 2];
    [headerImg setClipsToBounds:YES];
    [header addSubview:headerImg];
    [headerImg setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginClick)];
    [headerImg addGestureRecognizer:tap];
    
    CGRect rect = headerImg.frame;
    rect.origin.y = (header.height - 20 - 45 * SCALE_UI_SCREEN) / 2 + 20;//从statusBar开始居中
    headerImg.frame = rect;
    
    NSString *imgPath = @"";
    if (sns.isLogin) {
        imgPath = sns.myStaffCard.photo_path;
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerImg.right + 15 * SCALE_UI_SCREEN, 35 * SCALE_UI_SCREEN, (255-80) * SCALE_UI_SCREEN, 30 * SCALE_UI_SCREEN)];
        [self configLabel:nameLabel color:COLOR_C2 font:FONT_T2];
        [nameLabel setText:sns.myStaffCard.nick_name];
        [nameLabel sizeToFit];
        [header addSubview:nameLabel];
        
        [nameLabel setTop:headerImg.top];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerImg.right + 15 * SCALE_UI_SCREEN, nameLabel.bottom + 8 * SCALE_UI_SCREEN, (255-100) * SCALE_UI_SCREEN, 200)];//20 * SCALE_UI_SCREEN)];
        [self configLabel:detailLabel color:COLOR_C2 font:FONT_t6];
        [header addSubview:detailLabel];
        [detailLabel setText:sns.myStaffCard.self_desc];
        [detailLabel sizeToFit];
        
        NSInteger param = [self hasChineseContained:sns.myStaffCard.nick_name] ? 0 : 1;
        param = [self hasChineseContained:sns.myStaffCard.self_desc] ? param : (param += 1);
        NSInteger paramSpacing = param == 1 ? 5 * SCALE_UI_SCREEN : 5 * SCALE_UI_SCREEN;
        [detailLabel setOrigin:CGPointMake(headerImg.right + 15 * SCALE_UI_SCREEN, nameLabel.bottom + 10 * SCALE_UI_SCREEN - paramSpacing)];
    }else{
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setFrame:CGRectMake(headerImg.right + 15 * SCALE_UI_SCREEN, 42, 150, 30 * SCALE_UI_SCREEN)];
        [loginBtn setBackgroundColor:COLOR_C1];
        [loginBtn setTitleColor:COLOR_C2 forState:UIControlStateNormal];
        [loginBtn.titleLabel setFont:FONT_t4];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn setCenterY:headerImg.centerY];
        [loginBtn.layer setCornerRadius:3.0];
        [loginBtn.layer setBorderWidth:1.0];
        [loginBtn.layer setBorderColor:[UIColor clearColor].CGColor];
        [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:loginBtn];
    }
    [headerImg sd_setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    return header;
}

- (UIView *)configTableFooterView
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 255, 80)];
    [footer setBackgroundColor:[UIColor clearColor]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(15, footer.frame.size.height - 30, 200, 30)];
    [btn addTarget:self action:@selector(clickSettingBtn) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btn];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 22, 22)];
    [imgV setImage:[UIImage imageNamed:@"Unico/ico_setting"]];
//    setting@2x
    
    [imgV setImage:[UIImage imageNamed:@"Unico/setting"]];
    [btn addSubview:imgV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 4, 40, 22)];
    [label setText:@"设置"];
    [label setTextColor:COLOR_C2];
    [label setFont:FONT_t4];
    [btn addSubview:label];
    
    return footer;
}

- (void)configLabel:(UILabel *)label color:(UIColor *)color font:(UIFont *)font
{
    [label setTextColor:color];
    [label setFont:font];
}

#pragma mark uitableview datasource delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 255, 0.5)];
    [header setBackgroundColor:[UIColor clearColor]];
    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 215, 0.5)];
//    [line setBackgroundColor:[UIColor lightGrayColor]];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake((header.width - 215) / 2, 0, 215, 1)];
    [line setBackgroundColor:COLOR_C9];
    [header addSubview:line];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (15 + 22 + 10) * SCALE_UI_SCREEN;
    return 47;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return 3;
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 2;//3
//    }
//    return 2;
    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdenti = @"CellIdenti";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdenti];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdenti];
//    }
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell setBackgroundColor:[UIColor clearColor]];
//    [cell.textLabel setFont:FONT_t4];
//    [cell.textLabel setTextColor:COLOR_C2];
//    NSArray *array = [cellArray objectAtIndex:indexPath.section];
//    NSDictionary *dict = [array objectAtIndex:indexPath.row];
//    [cell.imageView setImage:[UIImage imageNamed:[dict objectForKey:@"imgName"]]];
//    [cell.textLabel setText:[dict objectForKey:@"title"]];
    
    LeftMainViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftMainViewTableViewCellIdentifier];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.model = [_dataArray[indexPath.section] objectAtIndex:indexPath.row];
    __weak __typeof(self) ws = self;
    //icon 图片 跳转
    cell.jumpBlock = ^(SLeftMainViewModel*model){
        [ws jumpMethordWithjumpType:TabelViewCellDidSelectCellIcon model:model];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self->mainTable deselectRowAtIndexPath:indexPath animated:YES];
    //侧边栏文字跳转
    SLeftMainViewModel *model = [_dataArray[indexPath.section] objectAtIndex:indexPath.row];
    [self jumpMethordWithjumpType:TabelViewCellDidSelectCell model:model];
}

- (void)jumpMethordWithjumpType:(JumpType)jumpType model:(SLeftMainViewModel*)model {
    //跳转方法
//    NSDictionary *dictionary = jumpType == TabelViewCellDidSelectCell ? model.JumpDic : model.Icon_JumpDic;
    NSDictionary *dictionary = jumpType == TabelViewCellDidSelectCell ? model.Icon_JumpDic : model.JumpDic;
    [SUTILITY_TOOL_INSTANCE jumpControllerWithContent:dictionary target:self];
    //隐藏侧边栏方法
    if (_delegate && [_delegate respondsToSelector:@selector(kLeftMainViewSwipeDelegate)]) {
        [_delegate kLeftMainViewSwipeDelegate];
    }
}

- (void)swipeLeftMainView
{
    if (_delegate && [_delegate respondsToSelector:@selector(kLeftMainViewSwipeDelegate)]) {
        [_delegate kLeftMainViewSwipeDelegate];
    }
}

- (void)loginClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(kLeftMainViewDidSelectWithType:)]) {
        [_delegate kLeftMainViewDidSelectWithType:kLeftViewJumpTypeUserCenter];
    }
}

- (void)clickSettingBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(kLeftMainViewDidSelectWithType:)]) {
        [_delegate kLeftMainViewDidSelectWithType:kLeftViewJumpTypeSetting];
    }
}

- (void)tapEmptySpace
{
    if (_delegate && [_delegate respondsToSelector:@selector(kLeftMainViewSwipeDelegate)]) {
        [_delegate kLeftMainViewSwipeDelegate];
    }
}

- (void)showWithtarget:(id <kLeftMainViewDelegate>)delegate {
    self.delegate = delegate;
    _contentView.frame = CGRectMake(-255, 0, 255, UI_SCREEN_HEIGHT);
    CGRect frame = _showBackView.frame;
    frame.origin.x = 255;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.15 animations:^{
        _showBackView.alpha = 1;
        _showBackView.frame = frame;
        [_contentView setFrame:CGRectMake(0, 0, 255, UI_SCREEN_HEIGHT)];
    }];

}

- (void)hide {
    __weak typeof(SLeftMainView*) leftView = self;
    
    if (leftView) {
        CGRect rect = _showBackView.frame;
        rect.origin.x = 0;
        CGRect frame = _contentView.frame;
        frame.origin.x = -255;
        [UIView animateWithDuration:0.5 animations:^{
            _contentView.frame = frame;
            _showBackView.frame = rect;
            _showBackView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [leftView removeFromSuperview];
            }
        }];
    }

}

#pragma mark - 判断NSString中是否包含中文
- (BOOL)hasChineseContained:(NSString*)str {
    return str.length == strlen(str.UTF8String);//StrLength(str.UTF8String);
}

@end
