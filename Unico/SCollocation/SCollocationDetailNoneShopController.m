//
//  SCollocationDetailNoneShopController.m
//  Wefafa
//
//  Created by Jiang on 8/2/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SCollocationDetailNoneShopController.h"
#import "SCollocationCommentCollectionViewCell.h"
#import "SCollocationDetailCollectionReusableView.h"
#import "SMineViewController.h"
#import "MBSettingMainViewController.h"
#import "SProductShowImageCell.h"
#import "CommentListModel.h"
#import "UIScrollView+MJRefresh.h"
#import "SCollocationDetailModel.h"
#import "LoginViewController.h"
#import "SUtilityTool.h"
#import "SDataCache.h"
#import "WeFaFaGet.h"
#import "CommentListModel.h"
#import "Toast.h"

@interface SCollocationDetailNoneShopController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, SCommentCollectionViewCellDelegate>
{
    NSInteger _pageIndex;
    CommentListModel *_selectedCommentModel;
    CommentListModel *_toUserModel;
    SCollocationCommentCollectionViewCell *_selectedCell;
}

@property (weak, nonatomic) IBOutlet UIView *commentContentView;
@property (weak, nonatomic) IBOutlet UIView *commentContentBearingView;
@property (weak, nonatomic) IBOutlet UITextField *commentSendMessageTextFiled;
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
- (IBAction)commentSendButtonAction:(UIButton *)sender;

//------------------
@property (nonatomic, strong) NSArray *contentTypeArray;
@property (nonatomic, strong) NSMutableArray *contentModelArray;
@property (nonatomic, strong) UIView *commentLevelView;
@property (nonatomic, strong) UIView *commentLevelNoneView;
@property (nonatomic, strong) UIView *shieldView;

@end

static NSString *headerIdentifier = @"SCollocationDetailHeaderIdentifier";
static NSString *commentCellIdentifier = @"SCollocationDetailNoneShopCellIdentifier";
static NSString *noneDataCellIdentifier = @"SProductShowImageCellIdentifier";
@implementation SCollocationDetailNoneShopController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initSubViews{
    [self initCommentView];
    self.contentTypeArray = @[@1, @5, @2, @0, @4, @0, @8, @999, @3, @0, @9, @0, @7];
    self.contentCollectionView.alwaysBounceVertical = YES;
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.backgroundColor = [UIColor whiteColor];
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SCollocationDetailCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SCollocationCommentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:commentCellIdentifier];
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SProductShowImageCell" bundle:nil] forCellWithReuseIdentifier:noneDataCellIdentifier];
    
    [_contentCollectionView addHeaderWithTarget:self action:@selector(requestRefreshCollocationList)];
    [_contentCollectionView addFooterWithTarget:self action:@selector(requestAddDataCollocationList)];
}

- (void)requestAddDataCollocationList{
    _pageIndex = (_contentModelArray.count+ 9)/ 10;
    [self requestCollocationListForCollocation];
}

- (void)requestRefreshCollocationList{
    _pageIndex = 0;
    [self requestData];
}
- (void)onBack:(UIBarButtonItem*)barItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestCollocationListForCollocation{
    if (!self.contentModel || !self.contentModel.aID) {
        [self.contentCollectionView footerEndRefreshing];
        return;
    }
    //    评论列表
    NSDictionary *data = @{
                           @"m": @"Comment",
                           @"a": @"getCommentList",
                           @"type": @1,
                           @"tid": self.contentModel.aID,
                           @"page": @(_pageIndex)
                           };
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        [_contentCollectionView footerEndRefreshing];
        if (_pageIndex == 0) {
            self.contentModelArray = [CommentListModel modelArrayForDataArray:responseObject[@"data"]];
        }else{
            if ([responseObject[@"data"] count] == 0) {
                [Toast makeToast:@"已经到底了！"];
            }else{
                [self.contentModelArray addObjectsFromArray:[CommentListModel modelArrayForDataArray:responseObject[@"data"]]];
                [self.contentCollectionView reloadData];
            }
        }
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [_contentCollectionView footerEndRefreshing];
        [Toast makeToast:kNoneInternetTitle duration:2.0 position:@"center"];
    }];
}

- (void)setContentModel:(SCollocationDetailModel *)contentModel{
    if (!contentModel) return;
    contentModel.isNoneShopping = YES;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@1, @5, @2, @0]];
    if (contentModel.product_list.count > 0) {
        [array addObjectsFromArray:@[@4, @0]];
    }
    if (contentModel.useBrand.count > 0){
        [array addObjectsFromArray:@[@8, @999]];
    }
    if(contentModel.tab_str.count > 0){
        [array addObjectsFromArray:@[@3, @0]];
    }
    if (contentModel.user_json) {
        NSString *stringAge = [NSString stringWithFormat:@"%@", contentModel.user_json[@"age"]];
        NSString *stringHeight = [NSString stringWithFormat:@"%@", contentModel.user_json[@"height"]];
        NSString *stringWeight = [NSString stringWithFormat:@"%@", contentModel.user_json[@"weight"]];
        if (!contentModel.user_json[@"info"]) {
            
        }else if ([stringAge length] <= 0 &&
                  [stringHeight length] <= 0 &&
                  [stringWeight length] <= 0){
            
        }else{
            [array addObjectsFromArray:@[@9, @0]];
        }
    }
    [array addObject:@7];
    self.contentTypeArray = array;
    [super setContentModel:contentModel];
    [self requestCollocationListForCollocation];
}

- (void)setContentModelArray:(NSMutableArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    [self.contentCollectionView reloadData];
}

#pragma mark - 评论方法
- (void)initCommentView{
    _shieldView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    _shieldView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    _shieldView.hidden = YES;
    [self.view insertSubview:_shieldView belowSubview:_commentContentView];
    
    _commentSendMessageTextFiled.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)];
    [self.shieldView addGestureRecognizer:tap];
    
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
    
    UITapGestureRecognizer *levelViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedCommentScore:)];
    [_commentLevelView addGestureRecognizer:levelViewTap];
    
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
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenKeyBoard) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didhiddenKeyBoard) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (IBAction)commentSendButtonAction:(UIButton *)sender{
    [self requestSendMessage];
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
    
    __weak __typeof(self) ws = self;
    
    NSString *toUserID = _toUserModel? _toUserModel.user_id: @"";
    NSDictionary *data = @{
                           @"m": @"Comment",
                           @"a": @"addCommentInfo",
                           @"type": @1,
                           @"toUserId": toUserID,
                           @"score": @(score),
                           @"tid": self.collocationId,
                           @"token": [SDataCache sharedInstance].userInfo[@"token"],
                           @"info": _commentSendMessageTextFiled.text
                           };
    _toUserModel = nil;
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation *operation, id object) {
        [Toast hideToastActivity];
        self.commentContentView.userInteractionEnabled = YES;
        if ([object[@"status"] intValue] == 1) {
            _commentSendMessageTextFiled.text = @"";
            self.contentModel.comment_score = @(self.contentModel.comment_score.intValue + score);
            self.contentModel.comment_count = @(self.contentModel.comment_count.intValue + 1);
            [self.contentCollectionView reloadData];
            [self requestCollocationListForCollocation];
            //用户评论搭配或订单之后3秒  APP store弹出框 评论
            [SUTILITY_TOOL_INSTANCE performSelector:@selector(showPraiseBox) withObject:nil afterDelay:3];
            //回调 社区-搭配
            if (ws.commentDidSuccessSend) {
                ws.commentDidSuccessSend(self.contentModel.comment_count);
            }
        }else {
            [Toast makeToast:@"评论失败！" duration:2.0 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Toast hideToastActivity];
        self.commentContentView.userInteractionEnabled = YES;
        [Toast makeToast:kNoneInternetTitle duration:2.0 position:@"center"];
    }];
}

- (void)requestScoreData{
    //    评论总分数
    NSDictionary *data = @{
                           @"m": @"Comment",
                           @"a": @"getCommentInfo",
                           @"type": @1,
                           @"tid": self.collocationId,
                           };
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        self.contentModel.comment_count = responseObject[@"data"][@"count_score"];
        self.contentModel.comment_score = responseObject[@"data"][@"total_score"];
        [_contentCollectionView reloadData];
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [Toast makeToast:kNoneInternetTitle duration:2.0 position:@"center"];
    }];
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
//    隐藏评论
    _commentLevelView.hidden = YES;
    CGRect rect = self.commentContentView.frame;
    NSDictionary *dict = userInfo.userInfo;
    NSValue *boundsValue = dict[@"UIKeyboardBoundsUserInfoKey"];
    CGSize size = boundsValue.CGRectValue.size;
    rect.origin.y = UI_SCREEN_HEIGHT - 88 - size.height;
    rect.size.height = 88;
    self.commentContentView.frame = rect;
}

#pragma mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==10000) {
        if (buttonIndex == 1) {
            [[SDataCache sharedInstance] delCollocationInfo:@"" collocationId:[self.contentModel.aID integerValue] complete:^(NSArray *data, NSError *error) {
                [Toast hideToastActivity];
                if (error) {
                    [Toast makeToast:@"删除失败，请稍候再试"];
                    return ;
                }
                else
                {
                    //                    [Toast makeToast:@"删除成功!"];
                    [Toast makeToastSuccess:@"删除成功!"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteCollocation" object:nil];
                    
                    [self onBack:nil];
                    
                }
            }];
            
        }
        return;
    }
    
    if (buttonIndex == 1) {
        if ([_selectedCommentModel.user_id isEqualToString:sns.ldap_uid]){
            NSDictionary *data = @{@"cid": _selectedCommentModel.aID};
            [Toast makeToastActivity];
            
            [[SDataCache sharedInstance] get:@"Comment" action:@"delMyComment" param:data success:^(AFHTTPRequestOperation *operation, id object) {
                [self.contentModelArray removeObject:_selectedCommentModel];
                [_contentCollectionView reloadData];
                [self requestScoreData];
                [Toast hideToastActivity];
                [Toast makeToastSuccess:@"已删除评论！"];
            } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Toast hideToastActivity];
                [Toast makeToast:kNoneInternetTitle duration:2.0 position:@"center"];
            }];
        }else{
            NSDictionary *data = @{@"tid": _selectedCommentModel.aID,
                                   @"type": @2};
            [Toast makeToastActivity];
            
            [[SDataCache sharedInstance] get:@"Complaints" action:@"addComplaintsInfo" param:data success:^(AFHTTPRequestOperation *operation, id object) {
                [Toast hideToastActivity];
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

- (void)commentCell:(SCollocationCommentCollectionViewCell *)cell model:(CommentListModel *)model{
    if (_commentSendMessageTextFiled.text.length > 0 && _toUserModel && ![model.user_id isEqualToString:_toUserModel.user_id]) {
        _toUserModel = model;
        NSString *string = [NSString stringWithFormat:@"回复%@", model.nick_name];
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:string otherButtonTitles: nil];
        actionSheet.tag=100;
        [actionSheet showInView:self.view];
        return;
    }
    _toUserModel = model;
    _commentLevelView.hidden = YES;
    _commentSendMessageTextFiled.placeholder = [NSString stringWithFormat:@"回复@%@", model.nick_name];
    [_commentSendMessageTextFiled becomeFirstResponder];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==100) {
        if (buttonIndex == 0) {
            _commentLevelView.hidden = YES;
            _commentSendMessageTextFiled.text = @"";
            _commentSendMessageTextFiled.placeholder = [NSString stringWithFormat:@"回复@%@", _toUserModel.nick_name];
            [_commentSendMessageTextFiled becomeFirstResponder];
        }
    }
    else
    {
        if (buttonIndex == 0) {
            NSString *userIdStr =[NSString stringWithFormat:@"%@",self.contentModel.user_id];
            NSString *collId = [NSString stringWithFormat:@"%ld",(long)self.collocationId];
            
            
            if (![sns.ldap_uid isEqualToString:userIdStr]) {
                [Toast makeToastActivity:@""];
                [[SDataCache sharedInstance] addMyComplaintsInfoWithCollocationId:collId complete:^(NSArray *data, NSError *error) {
                    [Toast hideToastActivity];
                    if (error) {
                        [Toast makeToast:@"举报失败!"];
                        return ;
                    }
                    NSString *dataState=[NSString stringWithFormat:@"%@",data];
                    if ([dataState isEqualToString:@"1"]) {
                        [Toast makeToastSuccess:@"举报成功!"];
                        return;
                    }
                    if ([dataState isEqualToString:@"-1"]) {
                        [Toast makeToastSuccess:@"您已举报！"];
                        return;
                    }
                    
                    [Toast makeToastSuccess:@"举报成功!"];
                    
                }];
            }else{
                
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示"
                                                               message:@"是否确定删除搭配？"
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                     otherButtonTitles:@"确定",nil];
                alert.tag=10000;
                [alert show];
            }
        }
   
    
    }
}

- (void)commentActionButton:(UIButton *)button model:(CommentListModel *)model{
    _selectedCommentModel = model;
    [self commentActionButton:button];
}

- (void)commentCell:(SCollocationCommentCollectionViewCell *)cell actionButton:(UIButton *)button model:(CommentListModel *)model{
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

- (void)commentOpenCell:(SCollocationCommentCollectionViewCell *)cell actionButton:(UIButton *)button model:(CommentListModel *)model{
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
    NSArray *array = [_contentCollectionView visibleCells];
    for (SCollocationCommentCollectionViewCell *cell in array) {
        [cell closeActionButton];
    }
    return NO;
}

#pragma mark - gesture delegate
- (void)selectedCommentScore:(UITapGestureRecognizer*)tap{
    if (tap.view == _commentLevelView) {
        CGPoint point = [tap locationInView:_commentLevelView];
        [self commentScoreForPoint:point];
    }
}

- (void)commentScoreForPoint:(CGPoint)point{
    CGRect frame = _commentLevelNoneView.frame;
    int num = (point.x - 80 + 20)/ 20;
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
    _commentSendMessageTextFiled.placeholder = @"评论";
    return YES;
}

#pragma mark - collectionview delegate
- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    SCollocationDetailCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
    reusableView.contentTypeArray = self.contentTypeArray;
    reusableView.contentModel = self.contentModel;
    reusableView.target = self;
    return reusableView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return MAX(_contentModelArray.count, 1);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGFloat headerHeight = 0.0;
    for (NSNumber *typeNumber in self.contentTypeArray) {
        headerHeight += [self cellHeightWithType:typeNumber.intValue];
    }
    return CGSizeMake(UI_SCREEN_WIDTH, headerHeight);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *returnCell = nil;
    if (_contentModelArray.count <= 0) {
        SProductShowImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:noneDataCellIdentifier forIndexPath:indexPath];
        cell.contentImageView.frame = CGRectMake(0, 20, UI_SCREEN_WIDTH, 40);
        cell.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.contentImageView.image = [UIImage imageNamed:@"Unico/collocation_nonecomment_sofa"];
        returnCell = cell;
    }else{
        SCollocationCommentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:commentCellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.contentModel = _contentModelArray[indexPath.row];
        returnCell = cell;
    }
    return returnCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.contentModelArray.count <= 0) {
        return CGSizeMake(UI_SCREEN_WIDTH, 80);
    }
    CommentListModel *model = _contentModelArray[indexPath.row];
    CGSize size = [model.info boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 100, 0)
                                           options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}
                                           context:nil].size;
    return CGSizeMake(UI_SCREEN_WIDTH, size.height - 10 + 50);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
