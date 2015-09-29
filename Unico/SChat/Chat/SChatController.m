//
//  SChatController
// 
//  Mark：这里用推送＋长链接＋后台接口完成聊天功能。
//  支持语音，图片，搭配，商品信息等。
//

#import "SChatController.h"
#import "UUInputFunctionView.h"
#import "MJRefresh.h"
#import "UUMessageCell.h"
#import "ChatModel.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"

#import "SUtilityTool.h"
#import "SDataCache.h"
#import "WeFaFaGet.h"
#import "SChatSocket.h"

@interface SChatController ()<UUInputFunctionViewDelegate,UUMessageCellDelegate,UITableViewDataSource,UITableViewDelegate>{
}

@property (strong, nonatomic) MJRefreshHeaderView *head;
@property (strong, nonatomic) ChatModel *chatModel;

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (nonatomic, assign) int pageIndex;

@end

@implementation SChatController{
    UUInputFunctionView *IFView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self setupNavbar];
    [self initBar];

    [self addRefreshViews];
    [self loadBaseViewsAndData];
    [self loadChatData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMsg:) name:@"MBFUN_CHAT_MESSAGE_SOCKET" object:nil];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onMsg:(NSNotification *)noti{
    NSLog(@"onMsg : %@",noti.userInfo);
    NSDictionary *info = noti.userInfo[@"v"];
    
    if (![info isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    if ([sns.myStaffCard.ldap_uid isEqualToString:info[@"target_id"]]) {
        [self.chatModel addSocketPushItem:info];
        [self.chatTableView reloadData];
        [self tableViewScrollToBottom];
    } else {
        // not this user
    }
    NSDictionary *param = @{@"toUserId" : _targetUserId};
    [[SDataCache sharedInstance] get:@"Message" action:@"clearMessageWithUser" param:param success:^(AFHTTPRequestOperation *operation, id object) {
        --UNREAD_ALL_NUMBER;
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)loadChatData {
    [[SDataCache sharedInstance] get:@"Message" action:@"getMessageList" param:@{@"toUserId":_targetUserId,@"page":@(_pageIndex)} success:^(AFHTTPRequestOperation *operation, id object) {
        NSLog(@"Load : %@",object);
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSArray *array = [(NSDictionary *)object objectForKey:@"data"];
            
            BOOL isPageOne = _pageIndex == 0 ? YES : NO;
            // 不要调转顺序
            for (int i = (int)array.count-1; i >= 0; i --) {
                NSDictionary *info = array[i];
//                [self.chatModel addOtherItem:info];
                [self.chatModel addOtherItem:info withNum:(int)array.count pageOne:isPageOne];
            }
            [self.chatTableView reloadData];
            
            if (_pageIndex == 0) {
                [self tableViewScrollToBottom];
            }else {
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:previousCount inSection:0];
//                [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }
            
            [self updataUI];
        }
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Chat List Load Failed : %@",operation.request.URL);
        [self updataUI];
    }];
}

- (void)updataUI {
    [self.chatTableView headerEndRefreshing];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //add notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    imgView.layer.cornerRadius = imgView.height/2;
    imgView.layer.masksToBounds = YES;
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightTabClick:)];
    [imgView addGestureRecognizer:tap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imgView];
    if (_targetName) {
        self.title = _targetName;
    } else {
        self.title = @"消息";
    }
}
-(void)onBack:(id)sender
{
    [self popAnimated:YES];
}
- (void)initBar{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/common_navi_mixblack.png"] forBarMetrics:UIBarMetricsDefault];
    if (_targetName) {
        self.title = _targetName;
    } else {
        self.title = @"消息";
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

   
}
- (void)segmentChanged:(UISegmentedControl *)segment
{
    self.chatModel.isGroupChat = segment.selectedSegmentIndex;
    [self.chatModel.dataSource removeAllObjects];
    [self.chatTableView reloadData];
}

- (void)rightTabClick:(id)sender{
    if (_targetUserId) {
        [SUTIL showUser:_targetUserId];
    }
}

- (void)addRefreshViews
{
    __weak typeof(self) weakSelf = self;
    
    //load more
    int pageNum = 3;
    
//    _head = [MJRefreshHeaderView header];
    self.chatTableView.backgroundColor = [UIColor whiteColor];
//    self.chatTableView.header = _head;
    
//    _head.beginRefreshingCallback = ^(MJRefreshBaseView *refreshView) {
//        
//        if (weakSelf.chatModel.dataSource.count > pageNum) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pageNum inSection:0];
//            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakSelf.chatTableView reloadData];
//                [weakSelf.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//            });
//        }
//        [weakSelf.head endRefreshing];
//    };
    [self.chatTableView addHeaderWithCallback:^{
        ++_pageIndex;
        [weakSelf loadChatData];
    }];
}

- (void)loadBaseViewsAndData
{
    self.chatModel = [[ChatModel alloc]init];
    self.chatModel.isGroupChat = NO;
    [self.chatModel initDataSource];
    
    IFView = [[UUInputFunctionView alloc]initWithSuperVC:self];
    IFView.delegate = self;
    [self.view addSubview:IFView];
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height
    if (notification.name == UIKeyboardWillShowNotification) {
        self.bottomConstraint.constant = keyboardEndFrame.size.height+40;
        //弹出键盘时，立马刷新
        [self.view layoutIfNeeded];
    }else{
        self.bottomConstraint.constant = 40;
        //弹去键盘时，等下一个时间片执行
        [self.view setNeedsLayout];
    }
    
    //图片过多时，键盘弹下去用此方法会主线程堵塞
//    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = IFView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    IFView.frame = newFrame;
    
    [UIView commitAnimations];
    
}

//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
    if (self.chatModel.dataSource.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - InputFunctionViewDelegate
#pragma mark - Send Text
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    
    NSDictionary *dic = @{@"strContent": message,
                          @"type": @(UUMessageTypeText),
                          @"nick_name":sns.myStaffCard.nick_name,
                          @"photo_path":sns.myStaffCard.photo_path,
                          @"user_id":sns.myStaffCard.ldap_uid,
                          @"target_id":_targetUserId
                          };
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSString *mess = [data base64EncodedStringWithOptions:0];
    NSString *textMessage = [SUTIL getJSON:@{@"msg":mess}];

    //消息长度不能超过100
    if (textMessage.length >= 100) {
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:nil message:@"字数不能超过100" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alv show];
        return;
    }
    
    //不能空格 不能回车
    NSMutableString *mutStr = [NSMutableString stringWithString:message];
    NSRange range = {0,message.length};
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    if (mutStr.length == 0) {
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:nil message:@"不能发送空白消息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alv show];
        return;
    }
    
    
    funcView.TextViewInput.text = @"";
    [funcView changeSendBtnWithPhoto:YES];
    [self dealTheFunctionData:dic];
    
    // real send msg
    if ( _targetUserId ) {
        // 这里追加对各种内容的兼容。
        NSLog(@"send message ---- %@", textMessage);
        [[SDataCache sharedInstance] addMessageInfo:_targetUserId msg:textMessage complete:^(id object) {
            NSLog(@"%@",object);
        }];

        [[SChatSocket shared] call:@"msg" val:dic];
    }
    
}

#pragma mark - Send Image
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image
{
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePictureUrl),
                          @"nick_name":sns.myStaffCard.nick_name,
                          @"photo_path":sns.myStaffCard.photo_path,
                          @"user_id":sns.myStaffCard.ldap_uid,
                          @"target_id" : _targetUserId};
    
    // real upload
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SDataCache sharedInstance] uploadChatImage:image complete:^(NSString *str) {
        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:dic];
        info[@"img_url"] = str;
        [info removeObjectForKey:@"picture"];
        NSString *imgMessage = [NSString stringWithFormat:@"{\"img_url\":\"%@\"}",str];
        // real send msg
        [info setValue:str forKey:@"photo_path"];
        [self dealTheFunctionData:info];
        if ( _targetUserId ) {
            // 这里追加对各种内容的兼容。
            [[SDataCache sharedInstance] addMessageInfo:_targetUserId msg:imgMessage complete:^(id object) {
                NSLog(@"%@",object);
            }];
            [[SChatSocket shared] call:@"msg" val:info];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } fail:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RKDropdownAlert title:@"网络似乎不给力...图片发送失败了"];
    }];
    
}

#pragma mark - Send Voice
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(UUMessageTypeVoiceUrl),
                          @"nick_name":sns.myStaffCard.nick_name,
                          @"photo_path":sns.myStaffCard.photo_path,
                          @"user_id":sns.myStaffCard.ldap_uid,
                          @"target_id" : _targetUserId};
    
    // real upload
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SDataCache sharedInstance] uploadChatVoice:voice complete:^(NSString *str) {
        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:dic];
        info[@"voice_url"] = str;
        [info removeObjectForKey:@"voice"];
        NSString *jsonMessage = [NSString stringWithFormat:@"{\"voice_url\":\"%@\",\"voice_time\":\"%d\"}",str,(int)second];
        [self dealTheFunctionData:info];
        
        // real send msg
        if ( _targetUserId ) {
            // 这里追加对各种内容的兼容。
            [[SDataCache sharedInstance] addMessageInfo:_targetUserId msg:jsonMessage complete:^(id object) {
                NSLog(@"%@",object);
            }];
            [[SChatSocket shared] call:@"msg" val:info];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } fail:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RKDropdownAlert title:@"网络似乎不给力...语音发送失败了"];
    }];
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    NSMutableDictionary *info =  [NSMutableDictionary dictionaryWithDictionary:dic];
    [self.chatModel addSpecifiedItem:info];
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

#pragma mark - tableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        cell.delegate = self;
    }
    [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - cellDelegate
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId{
    if (_targetUserId && [cell.messageFrame.message.strId isEqualToString:sns.ldap_uid]) {
        [SUTIL showUser:sns.ldap_uid];
    }else {
        [SUTIL showUser:_targetUserId];
    }
}

- (void)cellContentDidClick:(UUMessageCell *)cell image:(UIImage *)contentImage {
    
}

@end
