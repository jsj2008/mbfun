//
//  GroupChatListViewController.m
//  Wefafa
//
//  Created by fafa  on 13-6-22.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "GroupChatListViewController.h"
#import "TreeNodeRosterGroup.h"
#import "TreeNodeRosterUser.h"
#import "TreeViewCellRosterUser.h"
#import "TreeNodeXmppGroupClass.h"
#import "TreeNodeXmppGroup.h"
#import "TreeNodeDept.h"
#import "TreeNodeEmployee.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "ChatBaseViewController.h"
#import "ChatBaseGroupViewController.h"
#import "MyselfInfoViewController.h"
#import "FindContactViewController.h"
#import "XMPPLogging.h"
#import "Authority.h"
#import "AppDelegate.h"
#import "AppSetting.h"




//
#import "ChineseString.h"
#import "pinyin.h"
#import "CircleHomePageViewController.h"

////////////////
#import "GroupChatViewController.h"
//
// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int xmppLogLevel = XMPP_LOG_LEVEL_INFO | XMPP_LOG_FLAG_TRACE;
#else
static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN;
#endif
#define kTreeViewCellButtonTag 501
#define kAlertViewTag1 1
#define kAlertViewTag2 1000

#define TABLEVIEW_TOP_GROUP_NUM 1

@interface GroupChatListViewController ()
{
    UIButton *_addButton;
}
@end

@implementation GroupChatListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { 
        self.title = @"时尚圈";
        self.tabBarItem.image = [UIImage imageNamed:@"时尚圈.png"];
        loadDataCondition=[[NSCondition alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     _naviImage.backgroundColor = TITLE_BG;
    _scrollView1.backgroundColor = VIEWDARK_BACKCOLOR;
    
    topGroupArray=[[NSMutableArray alloc] init];
    [topGroupArray addObject:@{@"name":@"选择一个群", @"headimage":@"时尚圈.png", @"eventhandler":[CommonEventHandler instance:self selector:@selector(tableViewCell_CircleClick:)]}];
    
    _tvFriendSearch.tableViewTree.separatorColor = VIEWDARK_BACKCOLOR;
    _tvFriendSearch.tableViewTree.backgroundColor = VIEWDARK_BACKCOLOR;
    [_tvFriendSearch.onSelectedNode addListener:[CommonEventListener listenerWithTarget:self withSEL:@selector(_tvFriendSearch_OnSelectedNode:node:)]];
    [_tvFriendSearch.onConfigCell addListener:[CommonEventListener listenerWithTarget:self withSEL:@selector(_tvFriendSearch_OnConfigCell:cell:)]];
    [_tvFriendSearch.superview bringSubviewToFront:_tvFriendSearch];
    
    XMPPStream *xmppStreamX = [[AppDelegate xmppConnectDelegate] xmppStream];
    [xmppStreamX addDelegate:self delegateQueue:dispatch_get_main_queue()];
    XMPPRoster *xmppRosterX = [[AppDelegate xmppConnectDelegate] xmppRoster];
    [xmppRosterX addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [AppDelegate.xmppConnectDelegate.xmppAuth addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    UITapGestureRecognizer *singleTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageClick:)];
    [_imgHead addGestureRecognizer:singleTouch];
    _imgHead.userInteractionEnabled = YES;
    
    //////////////////////////meibang chengyubing 2014-08-02
    _tvFriendNew.separatorColor = VIEWDARK_BACKCOLOR;
    _tvFriendNew.backgroundColor = VIEWDARK_BACKCOLOR;
    _tvFriendNew.backgroundView=nil;

    friendDataArray=[[NSMutableArray alloc] initWithCapacity:10];
    sectionArray=[[NSMutableArray alloc] initWithCapacity:5];
    self.indexBar.delegate = self;
    
    _btnCancelFind.hidden=YES;
    
    [self createTreeNode];
    
    inviteMember=[[NSMutableArray alloc] initWithCapacity:5];

}

- (void)viewDidUnload {
    XMPPStream *xmppStreamX = [[AppDelegate xmppConnectDelegate] xmppStream];
    [xmppStreamX removeDelegate:self];
    XMPPRoster *xmppRosterX = [[AppDelegate xmppConnectDelegate] xmppRoster];
    [xmppRosterX removeDelegate:self];

    [AppDelegate.xmppConnectDelegate.xmppAuth removeDelegate:self];
    
    OBJC_RELEASE(_addButton);
    OBJC_RELEASE(lbNoAccess);
    OBJC_RELEASE(resTickDevice);

    [self setImgHead:nil];
    [self setScrollView1:nil];
    [self setViewFindFriend:nil];
    [self setTxtSearch:nil];
    [self setTvFriendSearch:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    XMPPLogTrace();

    XMPPStream *xmppStreamX = [[AppDelegate xmppConnectDelegate] xmppStream];
    [xmppStreamX removeDelegate:self];
    XMPPRoster *xmppRosterX = [[AppDelegate xmppConnectDelegate] xmppRoster];
    [xmppRosterX removeDelegate:self];
    [AppDelegate.xmppConnectDelegate.xmppAuth removeDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupForDismissKeyboard];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self unsetupForDismissKeyboard];
}

#pragma mark setupForDismissKeyboard

id obKeyboardShow, obKeyboardHide;
- (void)setupForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    obKeyboardShow = [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    obKeyboardHide = [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)unsetupForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:obKeyboardShow];
    [nc removeObserver:obKeyboardHide];
    obKeyboardShow = nil;
    obKeyboardHide = nil;
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

#pragma mark XMPPRosterDelegate

- (void)xmppRosterDidChange:(XMPPRosterSqliteStorage *)sender
{
    @synchronized (self)
    {
        //增、删好友时xmppRosterDidChange在didAddUser、didRemoveUser线程调用后被调用，数据不一致导致异常，增加同步锁与createTreeNodeFriend互斥，保证刷新过程中数据一致
//        [_tvFriendNew reloadData];
        [self createTreeNodeFriend];
    }
}

- (void)xmppRoster:(XMPPRosterSqliteStorage *)sender didUpdateUser:(XMPPUserSqliteStorageObject *)user
{
    XMPPStream *xmppStreamX = [[AppDelegate xmppConnectDelegate] xmppStream];
    if (![xmppStreamX.myJID isEqualToJID:user.jid options:XMPPJIDCompareBare]) return;
    
    [sqlite updateStaff:user.staffFull];
}

- (void)xmppRoster:(XMPPRosterSqliteStorage *)sender didAddUser:(XMPPUserSqliteStorageObject *)user
{
    [self createTreeNodeFriend];
}

- (void)xmppRoster:(XMPPRosterSqliteStorage *)sender didRemoveUser:(XMPPUserSqliteStorageObject *)user
{
    [self createTreeNodeFriend];
}

//设备变化
- (void)xmppRoster:(XMPPRosterSqliteStorage *)sender
    didAddResource:(XMPPResourceSqliteStorageObject *)resource
          withUser:(XMPPUserSqliteStorageObject *)user
{
    if ([AppDelegate.xmppConnectDelegate.xmppStream.myJID isEqualToJID:user.jid options:XMPPJIDCompareBare]
        && resource.presence.priority != FAFA_DEVICE_PRIORITY_IPHONE)
    {
        [self createTreeNodeFriend];
    }
}

- (void)xmppRoster:(XMPPRosterSqliteStorage *)sender
 didUpdateResource:(XMPPResourceSqliteStorageObject *)resource
          withUser:(XMPPUserSqliteStorageObject *)user
{
    if ([AppDelegate.xmppConnectDelegate.xmppStream.myJID isEqualToJID:user.jid options:XMPPJIDCompareBare]
        && resource.presence.priority != FAFA_DEVICE_PRIORITY_IPHONE)
    {
        [[[AppDelegate xmppConnectDelegate] xmppRosterStorage] fetchStaffFullInfo:user.staffFull.jid];
        
        [self createTreeNodeFriend];
    }
}

- (void)xmppRoster:(XMPPRosterSqliteStorage *)sender
 didRemoveResource:(XMPPResourceSqliteStorageObject *)resource
          withUser:(XMPPUserSqliteStorageObject *)user
{
    if ([AppDelegate.xmppConnectDelegate.xmppStream.myJID isEqualToJID:user.jid options:XMPPJIDCompareBare]
        && resource.presence.priority != FAFA_DEVICE_PRIORITY_IPHONE)
    {
        [self createTreeNodeFriend];
    }
}

#pragma mark alertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (alertView.tag) {
        case kAlertViewTag1:
        {
            if (buttonIndex==0)
            {
                
            }else _addButton=nil;
            break;
        }
    }
}

#pragma mark event

-(BOOL)isMyFriend:(NSString *)jid
{
    if([jid isEqualToString:[AppSetting getFafaJid]] || [jid isEqualToString:[AppSetting getUserID]]) return YES;
    
    if ([AppDelegate.xmppConnectDelegate.xmppRosterStorage userExistsWithJID:[XMPPJID jidWithString:jid] xmppStream:AppDelegate.xmppConnectDelegate.xmppStream])
        return YES;
    return NO;
}

-(void)_tvFriend_OnSelectedNode:(TreeView*)sender node:(TreeNode*)node
{
    if (![node isKindOfClass:[TreeNodeRosterUser class]]) return;
    if ([node.key isEqualToString:AppDelegate.xmppConnectDelegate.xmppStream.myJID.bare]) return;
        
    XMPPUserSqliteStorageObject *userX = [XMPPUserSqliteStorageObject userForJIDFromCache:node.key];
    
    //是否客服
    if ([userX.jid.bare isEqualToString:FAFA_SERVICE_JID])
    {
        [ChatBaseViewController showChatWithJID:userX.jid];
    }
    else
    {
        [ChatBaseViewController showChatWithJID:(userX.isOnline?[userX.primaryResource jid]:userX.jid)];
    }
}

#define kDelSelfButtonTag 1091
-(void)_tvFriend_OnConfigCell:(TreeView*)sender cell:(TreeViewCell*)cell
{
    
    XMPPUserSqliteStorageObject *myuser = [XMPPUserSqliteStorageObject userForJIDFromCache:cell.treeNode.key];

    TreeNodeRosterUser *n = (TreeNodeRosterUser*)cell.treeNode;
    if ([n.key isEqualToString:AppDelegate.xmppConnectDelegate.xmppStream.myJID.bare])
    {
        UILabel *lbName=(UILabel *)[cell viewWithTag:kTreeViewCellLableNickNameTag];
        lbName.frame=CGRectMake(lbName.frame.origin.x,lbName.frame.origin.y,220,lbName.frame.size.height);
        UILabel *lbDesc=(UILabel *)[cell viewWithTag:kTreeViewCellLableDescTag];
        lbDesc.frame=CGRectMake(lbDesc.frame.origin.x,lbDesc.frame.origin.y,220,lbDesc.frame.size.height);
        
        UIImageView *imgS = (UIImageView*)[cell viewWithTag:kTreeViewCellRosterUserStatusImageViewTag];
        imgS.image = [myuser photoDevice:[[n.data presence] priority]];
   
        UIButton *btn=(UIButton *)[cell viewWithTag:kDelSelfButtonTag];
        if (btn == nil)
        {
            btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(cell.nodeContentView.frame.size.width-40-7 ,6,40,40);
            [btn setImage:[UIImage imageNamed:@"power_off.png"] forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
            [btn addTarget:self action:@selector(tickSelfButton_OnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=kDelSelfButtonTag;
            [cell.nodeContentView addSubview:btn];
        }        
        btn.hidden=NO;
    }
    else
    {
        if (myuser.subscription == nil || [@"" isEqualToString:myuser.subscription]) {
            NSDictionary *imRoster = [sqlite getIMRosterWithJid:cell.treeNode.key];
            myuser.subscription = [imRoster valueForKey:@"subscription"];
        }
        if (myuser.subscription!=nil && ![@"both" isEqualToString:myuser.subscription]) {
            UILabel *lbNickName = (UILabel *)[cell viewWithTag:kTreeViewCellLableNickNameTag];
            if (lbNickName!=nil) {
                lbNickName.text = [NSString stringWithFormat:@"%@【未认证】",myuser.staffFull.nick_name];
            }
        }
        UIButton *btn=(UIButton *)[cell viewWithTag:kDelSelfButtonTag];
        btn.hidden=YES;    
    }
}

-(void)tickSelfButton_OnClick:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"下线" message:[NSString stringWithFormat:@"是否退出该设备的登录？"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    alert.tag = 1000;
    resTickDevice = [[((TreeViewCell*)[[[sender superview] superview] superview]) treeNode] data];
    [alert show];
}

-(void)_tvFriendSearch_OnSelectedNode:(TreeView*)sender node:(TreeNode*)node
{
    if (![node isKindOfClass:[TreeNodeRosterUser class]]) return;
    
    _txtSearch.text = @"";
    [self txtSearchOnExit:nil];
    
    XMPPUserSqliteStorageObject *userX = [XMPPUserSqliteStorageObject userForJIDFromCache:node.key];
    [ChatBaseViewController showChatWithJID:(userX.isOnline?[userX.primaryResource jid]:userX.jid)];
    
}

-(void)_tvFriendSearch_OnConfigCell:(TreeView*)sender cell:(TreeViewCell*)cell
{
    CGRect frame = cell.nodeContentView.frame;
    cell.nodeContentView.frame = CGRectMake(frame.origin.x + 15, frame.origin.y, frame.size.width - 15, frame.size.height);
}

#pragma mark friend search

- (IBAction)txtSearchOnExit:(id)sender {
    [_txtSearch resignFirstResponder];
    [_tvFriendSearch setHidden:YES];
    _btnCancelFind.hidden=NO;
}

- (IBAction)txtSearch_OnChanged:(id)sender {
    NSString *namestr=_txtSearch.text;
    _btnCancelFind.hidden=NO;

    [_tvFriendSearch.tree.children removeAllObjects];
    [self searchFriend:namestr toTree:_tvFriendSearch.tree fromNodes:[self flatFriendList:friendDataArray]];
    
    if (_tvFriendSearch.tree.childrenCount > 0)
    {
        //设置显示数据集 
        [_tvFriendSearch reloadData];
        [_tvFriendSearch setHidden:NO];
    }
    else
    {
        //清空数据集 
        [_tvFriendSearch reloadData];
        [_tvFriendSearch setHidden:YES];
    }   
}

- (void)searchFriend:(NSString*)namestr toTree:(TreeNode*)toTree fromNodes:(NSArray*)fromNodes
{
    for (TreeNode *n in fromNodes) {
        if ([n isKindOfClass:TreeNodeRosterUser.class])
        {
            NSRange rangeName = [n.title rangeOfString:namestr];
            XMPPUserSqliteStorageObject *u = [XMPPUserSqliteStorageObject userForJIDFromCache:n.key];
            NSRange rangePingYin = [u.pingyin rangeOfString:namestr];
            if(rangeName.location != NSNotFound || rangePingYin.location != NSNotFound)
            {
                TreeNodeRosterUser *n1 = [[TreeNodeRosterUser alloc] init];            
                n1.title = n.title;
                n1.key = n.key;
                [toTree addChild:n1];
            }            
        }
        if (n.childrenCount > 0)
            [self searchFriend:namestr toTree:toTree fromNodes:n.children];
    }
}

- (IBAction)txtSearch_OnBeginEdit:(id)sender {
    //显示查询结果
    if ([_txtSearch.text isEqualToString:@""]==NO)
    {
        [self txtSearch_OnChanged:nil];
    }
    _btnCancelFind.hidden=NO;

}

//先创建群，添加群成员，然后跳转到聊天界面
- (IBAction)tureBtnClick:(id)sender {
    

    if ([NetUtils connectedToNetwork]&&([NetUtils isWifiConnected]||[NetUtils is3GConnected])) {
        [Toast makeToastActivity:@"创建中，请稍候..." hasMusk:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
            NSArray *rueslt= [AppDelegate.xmppConnectDelegate.xmppGroup  createGroup:@"群组名" GroupClass:@"discussgroup" GroupDesc:@"self.txtViewIntroduction.text" GroupPost:@"self.txtViewAnnouncement.text" AddMemberMethod:@"0"];

                NSLog(@"ruestlt---%@",rueslt);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                    if (rueslt==nil && [rueslt count] > 0) {
                        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"提示" message:@"群创建失败，请稍后重试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }else {
                        
                        groupId=[rueslt[0] attributeStringValueForName:@"groupid"];
                        NSLog(@"***************%@",groupId);
                        group=[[SNSGroup alloc] init];
                        group.group_id=groupId;
                        group.group_desc=[rueslt[0] attributeStringValueForName:@"groupdesc"];
                        group.group_name=[rueslt[0] attributeStringValueForName:@"groupname"];
                        group.create_staff=[rueslt[0] attributeStringValueForName:@"creator"];
                        group.join_method=[rueslt[0] attributeStringValueForName:@"add_member_method"];
                        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"提示" message:@"成功创建群" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert setTag:10001];
                        [alert show];
                        
                        [self timerRefresh];
                    }
                });
            });
    }
    
    //添加群成员
    [self addGroupChatperson];
    
    //    ChatBaseGroupViewController *chatBaseGroup = [[ChatBaseGroupViewController alloc]initWithNibName:@"ChatBaseGroupViewController" bundle:nil];
    //    [self.navigationController pushViewController:chatBaseGroup animated:YES];
    //跳转
    [ChatBaseViewController showChatWithGroupID:groupId];
    
  
}

//
-(void)addGroupChatperson
{
//    TreeViewCell *cell = (TreeViewCell*)[[[[sender superview] superview] superview]superview] ;

    for (NSString *treeNodeKey in inviteMember) {
        
        if ([NetUtils connectedToNetwork]&&([NetUtils isWifiConnected]||[NetUtils is3GConnected])) {
            [Toast makeToastActivity:@"邀请发送中，请稍候..." hasMusk:YES];
            //IM群发送邀请
            if (circleId==nil || circleId==NULL || [circleId isEqualToString:@""]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                    [AppDelegate.xmppConnectDelegate.xmppGroup inviteGroupMember:groupId EmployeeId:treeNodeKey];
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [Toast hideToastActivity];
//                        [inviteMember addObject:cell.treeNode.key];
                    });
                });
            }
            
            else [self netConnectError:nil];
        }

        
    }
}

-(void)netConnectError:(NSString *)msg {
    if (msg==nil || [@"" isEqualToString:msg]) {
        msg=@"无法连接服务器，请稍后重试！";
    }
    [Toast makeToast:msg];
    [self timerHideToast];
}


- (void)timerRefresh{
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refreshGroup) userInfo:nil repeats:NO];
}

-(void)refreshGroup
{
    [AppDelegate.xmppConnectDelegate.xmppGroupSqliteStorage setGroupVer:@"0"];
    [[[AppDelegate xmppConnectDelegate] xmppGroup] queryGroup];
}

//原来创建群方法
//这个方法。创建groupclass=discussgroup类型讨论组
- (NSArray *)createGroup:(NSString *)groupname GroupClass:(NSString *)groupclass GroupDesc:(NSString *)groupdesc GroupPost:(NSString *)grouppost AddMemberMethod:(NSString *)add_member_method

{
    //        NSArray *rueslt= [AppDelegate.xmppConnectDelegate.xmppGroup  createGroup:_txtGroupName.text GroupClass:_txtGroupClasses.text GroupDesc:self.txtViewIntroduction.text GroupPost:self.txtViewAnnouncement.text AddMemberMethod:addMemberMethod];
}
- (IBAction)backBtnCLick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark inner method

- (void)addFriend_OnClick:(id)sender {
    [_addButton setHidden:YES];
    
    AddFriendDetailView *view1=(AddFriendDetailView*)[sender superview];
    NSString *loginaccount = view1.txtLoginAccount.text;
    XMPPUserSqliteStorageObject *u = [XMPPUserSqliteStorageObject userForEmailFromCache:loginaccount];
    
    XMPPStream *xmppStreamX = [[AppDelegate xmppConnectDelegate] xmppStream];
    XMPPRosterSqliteStorage *xmppRosterSqliteStorageX = [[AppDelegate xmppConnectDelegate] xmppRosterStorage];
    XMPPUserSqliteStorageObject *myUser = [xmppRosterSqliteStorageX myUserForXMPPStream:xmppStreamX];
    
    NSString *tmpstatus=[NSString stringWithFormat:@"%@,%@,%@",myUser.displayName,view1.txtMemo.text,myUser.staffFull.ename];
    [AppDelegate.xmppConnectDelegate.xmppRoster addUser:u.jid withNickname:u.displayName status:tmpstatus];
    
    [self netConnectMessage:@"添加好友信息已发送，请等待验证！"];
}

-(void)netConnectMessage:(NSString *)msg
{
    [self hideToast];
    if (msg==nil || [@"" isEqualToString:msg]) {
        msg=@"无法连接服务器，请稍后重试！";
    }
    [Toast makeToast:msg];
    [self timerHideToast];
}

- (void)timerHideToast {
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hideToast) userInfo:nil repeats:NO];
}

- (void)hideToast {
    [Toast hideToastActivity];
}

-(void)createTreeNode
{
    [self createTreeNodeFriend];
}

+(TreeNodeRosterUser*)createFafaManager
{
    XMPPRosterSqliteStorage *xmppRosterSqliteStorageX = [[AppDelegate xmppConnectDelegate] xmppRosterStorage];
    [xmppRosterSqliteStorageX userForJIDStr:FAFA_SERVICE_JID];
    TreeNodeRosterUser *n1 = [[TreeNodeRosterUser alloc] init];
    n1.title = [[NSString alloc] initWithFormat:@"在线客服"];
    n1.key = [[NSString alloc] initWithFormat:@"%@",FAFA_SERVICE_JID];
    
    return n1;
}

- (void)createTreeNodeFriend
{
    //新用户列表显示ChengYuBing 2014-08-02
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void) {
        @synchronized (self)
        {
            NSMutableArray *tmpDataArray=[[NSMutableArray alloc] initWithCapacity:10];
            XMPPRosterSqliteStorage *xmppRosterSqliteStorageX = [[AppDelegate xmppConnectDelegate] xmppRosterStorage];
            NSArray *allGroup = [xmppRosterSqliteStorageX allGroups];
            
            NSString *myjidbare = AppDelegate.xmppConnectDelegate.xmppStream.myJID.bare;
            for (NSString *gname in allGroup) {
                NSArray *arrX = [xmppRosterSqliteStorageX sortedUsersByAvailabilityNameWithGroupName:gname];
                for (NSString *jidbare in arrX) {
                    XMPPUserSqliteStorageObject *user = [xmppRosterSqliteStorageX userForJIDStr:jidbare];
                    
                    if ([myjidbare isEqualToString:jidbare]
                        //                && [user.primaryResource presence].priority == FAFA_DEVICE_PRIORITY_IPHONE
                        ) continue;  //自己不显示
                    TreeNodeRosterUser *n1 = [[TreeNodeRosterUser alloc] init];
                    n1.title = user.displayName;
                    n1.key = jidbare;
                    n1.pinyin = [self getPinYin:user.displayName];
                    [tmpDataArray addObject:n1];
                }
            }

            
            [tmpDataArray sortUsingComparator:^NSComparisonResult(TreeNodeRosterUser *obj1, TreeNodeRosterUser *obj2) {
                return [obj1.pinyin compare:obj2.pinyin];
            }];
            
            sectionArray=[self createFriendIndex:tmpDataArray];
            friendDataArray=[self createFriendSortArray:tmpDataArray indexArray:sectionArray];
            
            dispatch_async( dispatch_get_main_queue(), ^(void){
                [_tvFriendNew reloadData];
            });
        }
    });
}
-(void)createTreeNodeGroup
{
    //兼容接口
}
-(void)createTreeNodeCompany
{
    //兼容接口
}

////////////////////////////////////////////////////////////////////////////////
//新用户列表显示ChengYuBing 2014-08-02

-(NSMutableArray *)createFriendIndex:(NSMutableArray *)arr
{
    NSMutableArray *firstLetterArray=[[NSMutableArray alloc] initWithCapacity:10];
    for (int i=0;i<arr.count;i++)
    {
        TreeNodeRosterUser *user1=arr[i];
        NSString *firstcase=[[user1.pinyin substringToIndex:1] uppercaseString];
        if(![firstLetterArray containsObject:firstcase])
        {
            [firstLetterArray addObject:firstcase];
        }
    }
    [firstLetterArray sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    return firstLetterArray;
}

-(NSMutableArray *)createFriendSortArray:(NSMutableArray *)arr indexArray:(NSArray *)indexArray
{
    NSMutableArray *sortArray=[[NSMutableArray alloc] initWithCapacity:indexArray.count];
    for (int i=0;i<indexArray.count;i++)
    {
        [sortArray addObject:[[NSMutableArray alloc] initWithCapacity:5]];
    }
    for (int i=0;i<arr.count;i++)
    {
        TreeNodeRosterUser *user1=arr[i];
        NSString *firstcase=[[user1.pinyin substringToIndex:1] uppercaseString];
        int idx=[indexArray indexOfObject:firstcase];
        [sortArray[idx] addObject:user1];
    }
    
    return sortArray;
}

-(NSMutableArray *)flatFriendList:(NSMutableArray *)friendsortarray
{
    NSMutableArray *rstarr=[[NSMutableArray alloc] initWithCapacity:10];
    for (int ii=0;ii<friendsortarray.count;ii++)
    {
        NSMutableArray *userarr=friendsortarray[ii];
        for (int i=0;i<userarr.count;i++)
        {
            TreeNodeRosterUser *user1=userarr[i];
            [rstarr addObject:user1];
        }
    }
    return rstarr;
}

- (NSString *)getPinYin:(NSString *)str{
    NSString *pinYinResult = [NSString string];
    for(int j = 0;j < str.length; j++) {
        NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                         pinyinFirstLetter([str characterAtIndex:j])]uppercaseString];
        
        pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
    }
    return pinYinResult;
}

- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort sectionHeaderList:(NSMutableArray *)sectionHeaderList{
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        ChineseString *chineseString=[[ChineseString alloc]init];
        chineseString.string=[NSString stringWithString:[arrToSort objectAtIndex:i]];
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            //join the pinYin
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseString.string.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr= [strchar substringToIndex:1];
        
        if(![sectionHeaderList containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [sectionHeaderList addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] initWithObjects:nil];
            checkValueAtIndex = NO;
        }
        if([sectionHeaderList containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    return arrayForArrays;
}

#pragma mark tableview delegate
//具体单元格
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSMutableArray *seca=[[NSMutableArray alloc] initWithArray:sectionArray];
    for (int i=0;i<TABLEVIEW_TOP_GROUP_NUM;i++)
    {
        [seca insertObject:@"" atIndex:0];
    }
    [_indexBar setIndexes:seca];
    return sectionArray.count+TABLEVIEW_TOP_GROUP_NUM;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section<TABLEVIEW_TOP_GROUP_NUM)
    {
        return @"";
    }
    else
    {
        section-=TABLEVIEW_TOP_GROUP_NUM; //前面的分组不显示
    }
    return [sectionArray objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section<TABLEVIEW_TOP_GROUP_NUM)
    {
        return 5;
    }
    else
    {
        section-=TABLEVIEW_TOP_GROUP_NUM;
    }
    return 22;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section<TABLEVIEW_TOP_GROUP_NUM)
    {
        return 1;
    }
    else
    {
        section-=TABLEVIEW_TOP_GROUP_NUM;
    }
    return [friendDataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int section=indexPath.section;
    if (indexPath.section<TABLEVIEW_TOP_GROUP_NUM)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupcell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"groupcell"];
        }
        cell.textLabel.text=topGroupArray[section][@"name"];
//        cell.imageView.image = [UIImage imageNamed:topGroupArray[section][@"headimage"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else
    {
        section=indexPath.section-TABLEVIEW_TOP_GROUP_NUM;
    }
    
    TreeNode* node = friendDataArray[section][indexPath.row];
    NSString* cellIdentifier = NSStringFromClass(node.class);
    
    TreeViewCell* cell = (TreeViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[node.class cellClass] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        cell.imageView.image = [UIImage imageNamed:@"roundNil.png"];
        
//        _roundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 20, 20)];
//        _indexRow = indexPath.section*10+indexPath.row;
//        _roundImg.tag = _indexRow;
//        _roundImg.image = [UIImage imageNamed:@"roundNil.png"];
//        [cell.contentView addSubview:_roundImg];
//        [cell.nodeContentView  addSubview:roundImg];
        
//        _roundImg = (UIImageView*)[cell viewWithTag:1001];
//        _roundImg.image = [UIImage imageNamed:@"roundNil.png"];

    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [cell setTreeNode:node];
    
    
    //调用修改
    [self _tvFriendNew_OnConfigCell:nil cell:cell];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _indexRow = indexPath.row;
    _indexSection = indexPath.section;
    
    
//    _indexRow = indexPath.section*10+indexPath.row;
//    if (_roundImg.tag == _indexRow) {
////        [self roundImgSelect:indexPath];
//        _roundImg.image = [UIImage imageNamed:@"roundColor.png"];
//
//
//    }
    
    
    if (indexPath.section!=0) {
        TreeViewCell *newCell = (TreeViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        if (newCell.accessoryType == UITableViewCellAccessoryCheckmark) {
            newCell.accessoryType = UITableViewCellAccessoryNone;
            if (inviteMember.count!=0) {
                [inviteMember removeObject:newCell.treeNode.key];
            }
            
        }
        else
        {
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            [inviteMember addObject:newCell.treeNode.key];

        }

    }
    
    NSLog(@" inviteMember ===================== %@",inviteMember);
    
    
    int section=indexPath.section;
    if (indexPath.section<TABLEVIEW_TOP_GROUP_NUM)
    {
        CommonEventHandler *eh = topGroupArray[section][@"eventhandler"];
        [eh fire:self eventData:nil];
        return;
    }
    else
    {
        section=indexPath.section-TABLEVIEW_TOP_GROUP_NUM;
    }
    
//    //调用修改
////    TreeNode* n = friendDataArray[section][indexPath.row];
////    [self _tvFriendNew_OnSelectedNode:nil node:n];
}

-(void)roundImgSelect:(NSIndexPath*)indexPath
{
//    UIImageView *imageRound = (UIImageView*)[self.view viewWithTag:_indexRow];
//    imageRound.image = [UIImage imageNamed:@"roundColor.png"];
    
//
//    if(_indexSection == indexPath.section&&_indexSection>=0)
//    {
//        if (_indexRow==indexPath.row&&_indexRow >=0) {
//            imageRound.image = [UIImage imageNamed:@"roundColor.png"];
//        }
//        
//        else
//        {
//            imageRound.image = [UIImage imageNamed:@"roundNil.png"];
//        }
//
//        
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section=indexPath.section;
    if (indexPath.section<TABLEVIEW_TOP_GROUP_NUM)
    {
        return 44;
    }
    else
    {
        section=indexPath.section-TABLEVIEW_TOP_GROUP_NUM;
    }
    TreeNode* n = friendDataArray[section][indexPath.row];
    return [n.class cellHeight];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return sectionArray;
}

#pragma mark - AIMTableViewIndexBarDelegate
- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index{
    if ([_tvFriendNew numberOfSections] > index && index > -1){   // for safety, should always be YES
        [_tvFriendNew scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
    }
}

-(void)tableViewCell_CircleClick:(id)sender
{
    GroupChatViewController *groupList = [[GroupChatViewController alloc]initWithNibName:@"GroupChatViewController" bundle:nil];
    [self.navigationController pushViewController:groupList animated:YES];
}

-(void)_tvFriendNew_OnSelectedNode:(TreeView*)sender node:(TreeNode*)node
{
    if (![node isKindOfClass:[TreeNodeRosterUser class]]) return;
    if ([node.key isEqualToString:AppDelegate.xmppConnectDelegate.xmppStream.myJID.bare]) return;
    
    XMPPUserSqliteStorageObject *userX = [XMPPUserSqliteStorageObject userForJIDFromCache:node.key];
    
    //是否客服
    if ([userX.jid.bare isEqualToString:FAFA_SERVICE_JID])
    {
        [ChatBaseViewController showChatWithJID:userX.jid];
    }
    else
    {
        [ChatBaseViewController showChatWithJID:(userX.isOnline?[userX.primaryResource jid]:userX.jid)];
    }
}

-(void)_tvFriendNew_OnConfigCell:(TreeView*)sender cell:(TreeViewCell*)cell
{
    CGRect frame = cell.nodeContentView.frame;
    cell.nodeContentView.frame = CGRectMake(frame.origin.x + 15, frame.origin.y, frame.size.width - 15, frame.size.height);
    
//    TreeNodeRosterUser *n = (TreeNodeRosterUser*)cell.treeNode;
//    UILabel *lbName=(UILabel *)[cell viewWithTag:kTreeViewCellLableNickNameTag];
//    lbName.frame=CGRectMake(lbName.frame.origin.x,lbName.frame.origin.y,180,lbName.frame.size.height);
//    UILabel *lbDesc=(UILabel *)[cell viewWithTag:kTreeViewCellLableDescTag];
//    lbDesc.frame=CGRectMake(lbDesc.frame.origin.x,lbDesc.frame.origin.y,180,lbDesc.frame.size.height);

    UIImageView *imgDesigner = (UIImageView*)[cell viewWithTag:kTreeViewCellRosterUserIconImageViewTag];
    if ([XMPPUserSqliteStorageObject isMeibangConsumer:cell.treeNode.key]==NO)
    {
        imgDesigner.image = [UIImage imageNamed:@"设计师标识.png"];
    }
    else
    {
        imgDesigner.image = nil;
    }
    
    //old method
    [self _tvFriend_OnConfigCell:sender cell:cell];
}

- (IBAction)btnCancelFindClick:(id)sender {
    _tvFriendSearch.hidden=YES;
}
@end
