//
//  CommentsViewController.m
//  Wefafa
//
//  Created by unico_0 on 5/30/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentListModel.h"
#import "SCommentListTableViewCell.h"
#import "HttpRequest.h"
#import "SDataCache.h"
#import "WeFaFaGet.h"
#import "Toast.h"
#import "SUtilityTool.h"
#import "UIScrollView+MJRefresh.h"
#import "LoginViewController.h"
#import "SMineViewController.h"
#import "MBSettingMainViewController.h"
#import "SProductDetailCommentModel.h"

@interface CommentsViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, UIAlertViewDelegate, SCommentListTableViewCellDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>
{
    BOOL _isLoadFinish;
    NSInteger _pageIndex;
    CommentListModel *_selectedCommentModel;
    CommentListModel *_toUserModel;
    SCommentListTableViewCell *_selectedCell;
    
    //没有评论
    UIView *noneDataView;
    int  _requestType;//单品 或者搭配的类型.
}

@property (weak, nonatomic) IBOutlet UIView *showCommentLevelView;
@property (weak, nonatomic) IBOutlet UIView *commentContentBearingView;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIView *commentContentView;
@property (weak, nonatomic) IBOutlet UILabel *commentTotalScoreLabel;
@property (weak, nonatomic) IBOutlet UITextField *commentSendMessageTextFiled;
- (IBAction)commentSendButtonAction:(UIButton *)sender;

//_____________

@property (nonatomic, strong) NSMutableArray *contentModelArray;
@property (nonatomic, strong) UIView *commentLevelView;
@property (nonatomic, strong) UIView *commentLevelNoneView;
@property (nonatomic, strong) UIView *shieldView;

@end

static NSString *cellIdentifier = @"SCommentListTableViewCellIdentifier";
@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initSubViews];
    [self requestRefresh];
    
    [_commentCountLabel setAdjustsFontSizeToFitWidth:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupNavbar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenKeyBoard) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didhiddenKeyBoard) name:UIKeyboardDidHideNotification object:nil];
}

- (void)setupNavbar {
    [super setupNavbar];
    
    self.title = @"评论列表";
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
}

- (void)onBack:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_commentDetailCount deleteCharactersInRange:NSMakeRange(0, _commentDetailCount.length)];
    [_commentDetailCount appendFormat:@"%d", _commentCount];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_isLoadFinish) {
        [self showTotalScoreView];
    }else{
        _isLoadFinish = YES;
    }
}

- (void)hiddenKeyBoard{
    [self.commentSendMessageTextFiled resignFirstResponder];
    CGRect rect = self.commentContentView.frame;
    rect.origin.y = UI_SCREEN_HEIGHT - _commentLevelView.frame.size.height;
    rect.size.height = _commentLevelView.frame.size.height;
    
    CGRect bearingFrame = _commentContentBearingView.frame;
    CGRect frame = _commentLevelNoneView.frame;
    frame.size.width = 0;
    bearingFrame.origin.y = 0;
    self.commentContentView.frame = rect;
    _commentContentBearingView.frame = bearingFrame;
    _commentLevelNoneView.frame = frame;
    _shieldView.hidden = YES;
    //在这里隐藏解决消失的时候_commentLevelView闪动现象
    _commentLevelView.hidden = YES;
    
}
-(void)didhiddenKeyBoard{
     //在键盘彻底消失的时候再让其显示防止闪动现象及回复好友和评论交替不出现_commentLevelView问题
    _commentLevelView.hidden = NO;

}

- (void)showKeyBoard:(NSNotification*)userInfo{
    _commentLevelView.hidden = YES;
    CGRect rect = self.commentContentView.frame;
    NSDictionary *dict = userInfo.userInfo;
    NSValue *boundsValue = dict[@"UIKeyboardBoundsUserInfoKey"];
    CGSize size = boundsValue.CGRectValue.size;
    rect.origin.y = UI_SCREEN_HEIGHT - 88 - size.height;
    
    self.commentContentView.frame = rect;
}

- (void)initSubViews{
    _shieldView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    _shieldView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    _shieldView.hidden = YES;
    [self.view insertSubview:_shieldView belowSubview:_commentContentView];
    
    _commentSendMessageTextFiled.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)];
    [self.shieldView addGestureRecognizer:tap];
    
    [_contentTableView addFooterWithTarget:self action:@selector(requestCommentAddListData)];
    [_contentTableView addHeaderWithTarget:self action:@selector(requestRefresh)];
    _contentTableView.tableFooterView = [[UIView alloc]init];
    [_contentTableView registerNib:[UINib nibWithNibName:@"SCommentListTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    CGRect rect = self.commentContentView.bounds;
    rect.size.width = UI_SCREEN_WIDTH;
    _commentLevelView = [[UIView alloc]initWithFrame:rect];
    _commentLevelView.backgroundColor = [UIColor whiteColor];
    [self.commentContentView insertSubview:_commentLevelView atIndex:0];
    
    _commentLevelNoneView = [[UIView alloc]initWithFrame:CGRectMake(80, 0, 0, self.commentContentView.bounds.size.height)];
    _commentLevelNoneView.backgroundColor = [UIColor whiteColor];
    _commentLevelNoneView.layer.masksToBounds = YES;
    _commentLevelNoneView.userInteractionEnabled = NO;
    [self.commentContentView insertSubview:_commentLevelNoneView aboveSubview:_commentLevelView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(selectedCommentScore:)];
    pan.delegate = self;
    [_commentLevelView addGestureRecognizer:pan];
    _showCommentLevelView.hidden = YES;
    _showCommentLevelView.backgroundColor = [UIColor clearColor];
    
    for (int i = 0; i < 5; i++) {
        for (int i = 0; i < 5; i++){
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * 20, 10, 20, 20)];
            [self.showCommentLevelView addSubview:imageView];
        }
    }
    
    for (int i = 0; i < 5; i ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(80 + 20 * i, 0, 20, 20)];
        CGPoint point = imageView.center;
        point.y = _commentLevelView.centerY;
        imageView.center = point;
        imageView.image = [UIImage imageNamed:@"Unico/add1"];
        [_commentLevelView addSubview:imageView];
    }
    for (int i = 0; i < 5; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20 * i, 0, 20, 20)];
        CGPoint point = imageView.center;
        point.y = _commentLevelNoneView.centerY;
        imageView.center = point;
        imageView.image = [UIImage imageNamed:@"Unico/add2"];
        [_commentLevelNoneView addSubview:imageView];
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, _commentLevelView.frame.size.height)];
    [_commentLevelView addSubview:label];
    label.text = @"搭配评分";
    label.font = FONT_t4;
    label.textColor = COLOR_C2;
    
    if (_productID) {
        self.commentContentView.hidden = YES;
        self.commentTotalScoreLabel.hidden = NO;
        self.showCommentLevelView.hidden = NO;
        self.commentCount = _commentCount;
        self.commentTotalScore = _commentTotalScore;
        self.contentTableView.contentInset = UIEdgeInsetsZero;
        [_contentTableView removeFooter];
        [_contentTableView addFooterWithTarget:self action:@selector(requestCommentAddListData)];
    }
    
    // 隐藏顶部评论
    if (_collocationID) {
        self.topCommentView.hidden = YES;
        self.contentTableView.frame = CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64);
    }
}

- (void)requestRefresh{
    _pageIndex = 0;
    
    if (_productID) {   // 单品 2
        _requestType=2;
    }else{              // 搭配 1
        _requestType=1;
    }
    [self requestData];
    [self requestCommentList];
}

- (void)requestData{
//    评论总分数
    NSString *requestID = @"";
    if (_requestType==1) {
        requestID = _collocationID;
    }else{
        requestID = _productID;
    }
    NSDictionary *data = @{
             @"m": @"Comment",
             @"a": @"getCommentInfo",
             @"type": @(_requestType),
             @"tid": requestID,
             };
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        self.commentCount = [responseObject[@"data"][@"count_score"] intValue];
        self.commentTotalScore = [responseObject[@"data"][@"total_score"] floatValue];
        if (_isLoadFinish) {
            [self showTotalScoreView];
        }else{
            _isLoadFinish = YES;
        }
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [Toast makeToast:kNoneInternetTitle duration:2.0 position:@"center"];
    }];
}

- (void)requestCommentList{
    //    评论列表
    NSString *requestID = @"";
    if (_requestType==1) {
        requestID = _collocationID;
    }else{
        requestID = _productID;
    }
    NSDictionary *data = @{
                           @"m": @"Comment",
                           @"a": @"getCommentList",
                           @"type": @(_requestType),
                           @"tid": requestID,
                           @"page": @(_pageIndex)
                           };
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        [_contentTableView footerEndRefreshing];
        [_contentTableView headerEndRefreshing];
        if (_pageIndex == 0) {
            self.contentModelArray = [CommentListModel modelArrayForDataArray:responseObject[@"data"]];
        }else{
            [self.contentModelArray addObjectsFromArray:[CommentListModel modelArrayForDataArray:responseObject[@"data"]]];
            [self.contentTableView reloadData];
        }
        
        if(self.contentModelArray.count==0)
            [self initNoDataView];
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [_contentTableView footerEndRefreshing];
        [_contentTableView headerEndRefreshing];
        [Toast makeToast:kNoneInternetTitle duration:2.0 position:@"center"];
    }];
}

- (void)requestCommentAddListData{
    _pageIndex = (_contentModelArray.count + 9)/ 10;
    [self requestCommentList];
}

#pragma mark - 选择评价分数事件
- (void)selectedCommentScore:(UIPanGestureRecognizer*)pan{
    CGPoint point = [pan locationInView:_commentLevelView];
    [self commentScoreForPoint:point];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (gestureRecognizer.view == _commentLevelView) {
        CGPoint point = [gestureRecognizer locationInView:_commentLevelView];
        [self commentScoreForPoint:point];
    }
    return YES;
}

- (void)commentScoreForPoint:(CGPoint)point{
    CGRect frame = _commentLevelNoneView.frame;
    int num = (point.x - 80 + 10)/ 20;
    if (num<=0) {
        num = 1;
    }
    if (num>5) {
        num = 5;
    }
    frame.size.width = (5-num) * 20;
    frame.origin.x = 80+ num * 20;

    _commentLevelNoneView.frame = frame;
}

#pragma mark -

- (void)initTotalScoreView{
    int score = _commentTotalScore/ _commentCount * 2 / 1;
    int count = 0;
    for (int i = score; count < 5; count++){
        UIImageView *imageView = _showCommentLevelView.subviews[count];
        NSString *imageNameString = @"";
        if (i > 1) {
            i -= 2;
            imageNameString = @"Unico/add1";
        }else if(i > 0){
            i --;
            imageNameString = @"Unico/add3";
        }else{
            imageNameString = @"Unico/add2";
        }
        imageView.image = [UIImage imageNamed:imageNameString];
    }
}

- (void)showTotalScoreView{
    self.showCommentLevelView.layer.masksToBounds = YES;
    CGRect frame = self.showCommentLevelView.frame;
    CGFloat width = frame.size.width;
    frame.size.width = 0;
    _showCommentLevelView.hidden = NO;
    self.showCommentLevelView.frame = frame;
    frame.size.width = width;
    [UIView animateWithDuration:1 animations:^{
        self.showCommentLevelView.frame = frame;
    }];
}

#pragma mark - set get

- (void)setCommentCount:(int)commentCount{
    _commentCount = commentCount;
    NSString *string = @"";
    if (_productID) {
        string = @"评价";
    }else{
        string = @"评论";
    }
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@（%d）", string, commentCount];
}

- (void)setCommentTotalScore:(CGFloat)commentTotalScore{
    _commentTotalScore = commentTotalScore;
    [self initTotalScoreView];
    CGFloat score = commentTotalScore/ MAX(_commentCount, 1);
    self.commentTotalScoreLabel.text = [NSString stringWithFormat:@"综合评价：%.1f", score];
}

- (void)setContentModelArray:(NSMutableArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    [self.contentTableView reloadData];
}

#pragma mark - textFiled delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self requestSendMessage];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _shieldView.hidden = NO;
    CGRect rect = self.commentContentView.frame;
    rect.size.height = _commentLevelView.frame.size.height * 2;
    self.commentContentView.frame = rect;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    _commentSendMessageTextFiled.placeholder = @"说点什么...";
    return YES;
}
-(void)canShowPraiseBox
{
    [SUTILITY_TOOL_INSTANCE showPraiseBox];
}
#pragma mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([_selectedCommentModel.user_id isEqualToString:sns.ldap_uid]){
            NSDictionary *data = @{@"cid": _selectedCommentModel.aID};
            [Toast makeToastActivity];
            
            [[SDataCache sharedInstance] get:@"Comment" action:@"delMyComment" param:data success:^(AFHTTPRequestOperation *operation, id object) {
                  [self performSelector:@selector(canShowPraiseBox) withObject:nil afterDelay:3.0];
                [self.contentModelArray removeObject:_selectedCommentModel];
                [self.contentTableView reloadData];
                [self requestData];
                [Toast hideToastActivity];
                [Toast makeToastSuccess:@"已删除评论！"];
            } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Toast hideToastActivity];
                [Toast makeToast:kNoneInternetTitle duration:2.0 position:@"center"];
            }];
        }else{
            NSString *type=@"";
            
            if(_productID)
            {
                type=@"2";
            }
            else
            {
                type=@"1";
            }
            NSDictionary *data = @{@"tid": _selectedCommentModel.aID,
                                   @"type": type};
            //搭配时1  单品时2
            [Toast makeToastActivity];
            
            [[SDataCache sharedInstance] get:@"Complaints" action:@"addComplaintsInfo" param:data success:^(AFHTTPRequestOperation *operation, id object) {
                [Toast hideToastActivity];
                  [self performSelector:@selector(canShowPraiseBox) withObject:nil afterDelay:3.0];
                [Toast makeToastSuccess:@"已提交举报信息！"];
            } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Toast hideToastActivity];
                [Toast makeToast:kNoneInternetTitle duration:2.0 position:@"center"];
            }];
        }
    }
}

#pragma mark - cell delegete
- (void)commentCellUserImage:(UIImageView *)imageView userID:(NSString *)userID{
    if ([userID isEqualToString:sns.ldap_uid]) {
        MBSettingMainViewController *controller = [MBSettingMainViewController new];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else{
        SMineViewController *vc = [[SMineViewController alloc]init];
        vc.person_id = userID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)commentCell:(SCommentListTableViewCell *)cell model:(CommentListModel *)model{
    if (_productID) return;
    if (_commentSendMessageTextFiled.text.length > 0 && _toUserModel && ![model.user_id isEqualToString:_toUserModel.user_id]) {
        _toUserModel = model;
        NSString *string = [NSString stringWithFormat:@"回复%@", model.nick_name];
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:string otherButtonTitles: nil];
        [actionSheet showInView:self.view];
        return;
    }
    _toUserModel = model;
    _commentLevelView.hidden = YES;
    _commentSendMessageTextFiled.placeholder = [NSString stringWithFormat:@"回复@%@", model.nick_name];
    [_commentSendMessageTextFiled becomeFirstResponder];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        _commentLevelView.hidden = YES;
        _commentSendMessageTextFiled.text = @"";
        _commentSendMessageTextFiled.placeholder = [NSString stringWithFormat:@"回复@%@", _toUserModel.nick_name];
        [_commentSendMessageTextFiled becomeFirstResponder];
    }
}

- (void)commentActionButton:(UIButton *)button model:(CommentListModel *)model{
    _selectedCommentModel = model;
    [self commentActionButton:button];
}

- (void)commentCell:(SCommentListTableViewCell *)cell actionButton:(UIButton *)button model:(CommentListModel *)model{
    [cell closeActionButton];
    _selectedCommentModel = model;
    [self commentActionButton:button];
}

- (void)commentActionButton:(UIButton *)sender{
    [_selectedCell closeActionButton];
    NSString *string = @"";
    if([_selectedCommentModel.user_id isEqualToString:sns.ldap_uid]){
        string = @"确定删除当前评论?";
    }else{
        string = @"举报不良内容?";
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:string message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)commentOpenCell:(SCommentListTableViewCell *)cell actionButton:(UIButton *)button model:(CommentListModel *)model{
    _selectedCommentModel = model;
    _selectedCell = cell;
    UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    
    CGRect frame = button.frame;
    frame.origin = [button convertPoint:CGPointZero toView:view];
    UIButton *addButton = [[UIButton alloc]initWithFrame:frame];
    [addButton addTarget:self action:@selector(commentActionButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addButton];
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]init];
    gesture.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    tap.delegate = self;
    [view addGestureRecognizer:gesture];
    [view addGestureRecognizer:tap];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    [gestureRecognizer.view removeFromSuperview];
    NSArray *array = [_contentTableView visibleCells];
    for (SCommentListTableViewCell *cell in array) {
        [cell closeActionButton];
    }
    return NO;
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SCommentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.isScrollAction = _productID? NO: YES;
    cell.contentModel = _contentModelArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = @"";
    CommentListModel *model = _contentModelArray[indexPath.row];
    string = model.info;
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 100, 0)
                                            options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}
                                            context:nil].size;
    return size.height - 10 + 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_productID) return;
    [_commentSendMessageTextFiled resignFirstResponder];
}

- (void)requestSendMessage{
    // add by miao
    int score = (100- _commentLevelNoneView.frame.size.width) / 20;
    
    if (!_commentLevelView.hidden) {
        if (score < 1) {
            [Toast makeToast:@"请评级，方可发送！" duration:1.5 position:@"center"];
            return;
        }
    }
    if(self.commentSendMessageTextFiled.text.length==0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入评论内容" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    if (self.commentSendMessageTextFiled.text.length > 120){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"最多输入140个文字" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    self.commentContentView.userInteractionEnabled = NO;
    [self hiddenKeyBoard];
    _commentLevelView.hidden = NO;
    [Toast makeToastActivity];
    
    if (!IS_STRING(sns.ldap_uid)) {
        [Toast hideToastActivity];
        LoginViewController *VC = [LoginViewController new];
        [self pushController:VC animated:YES];
        return;
    }
    
    NSString *toUserID = _toUserModel? _toUserModel.user_id: @"";
    //    评论列表
    NSString *requestID = @"";
    NSString *type=@"";
    if (_requestType==1) {
        requestID = _collocationID;
        type=@"1";
    }else{
        requestID = _productID;
        type=@"2";
    }
    NSDictionary *data = @{
                           @"m": @"Comment",
                           @"a": @"addCommentInfo",
                           @"type": type,
                           @"toUserId": toUserID,
                           @"score": @(score),
                           @"tid": requestID,
                           @"token": [SDataCache sharedInstance].userInfo[@"token"],
                           @"info": _commentSendMessageTextFiled.text
                           };
    _toUserModel = nil;
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation *operation, id object) {
        [Toast hideToastActivity];
        self.commentContentView.userInteractionEnabled = YES;
        if ([object[@"status"] intValue] == 1) {
            [self performSelector:@selector(canShowPraiseBox) withObject:nil afterDelay:3.0];
            _commentSendMessageTextFiled.text = @"";
            [_contentTableView headerBeginRefreshing];
        }else {
            [Toast makeToast:@"评论失败！" duration:2.0 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Toast hideToastActivity];
        self.commentContentView.userInteractionEnabled = YES;
        [Toast makeToast:kNoneInternetTitle duration:2.0 position:@"center"];
    }];
}

- (IBAction)commentSendButtonAction:(UIButton *)sender {
    [self requestSendMessage];
}


-(void)initNoDataView
{
    return;
    if(!noneDataView)
    {
        noneDataView = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:CGRectMake(0, 164, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-120) WithImage:NONE_DATA_COMMENT andImgSize:CGSizeMake(60, 60) andTipString:@"还没有人对此资讯进行评论哦" font:FONT_t1 textColor:COLOR_C6 andInterval:10.0];
        [self.view addSubview:noneDataView];
    }
    else
    {
        [noneDataView removeFromSuperview];
        noneDataView = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-120) WithImage:NONE_DATA_COMMENT andImgSize:CGSizeMake(60, 60) andTipString:@"还没有人对此资讯进行评论哦" font:FONT_t1 textColor:COLOR_C6 andInterval:10.0];
        [self.view addSubview:noneDataView];
        
    }
    
}
@end
