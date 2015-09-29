//
//  GroupChatListViewController.h
//  Wefafa
//
//  Created by fafa  on 13-6-22.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeView.h"
#import "RoundHeadImageView.h"
#import "XMPPResourceSqliteStorageObject.h"
#import "TreeViewCellXmppGroup.h"
#import "AddFriendDetailView.h"
#import "AIMTableViewIndexBar.h"


///////////////
#import "HistorySessionInfo.h"
#import "NoteView.h"
#import "AppDelegate.h"
#import "CCheckBox.h"
#import "GroupClassPickerViewController.h"
#import "Base.h"
#import "Utils.h"


@interface GroupChatListViewController : UIViewController<AIMTableViewIndexBarDelegate>
{
    UILabel *lbNoAccess;
    XMPPResourceSqliteStorageObject *resTickDevice;
    NSCondition *loadDataCondition;
    
    NSMutableArray *topGroupArray; //顶部分组
    NSMutableArray *sectionArray; //拼音首字母索引
    NSMutableArray *friendDataArray; //每个元素是tree数组
    
    //////////////////创建群组
    SNSGroup *group;
    NSString *groupClassid;
    NSString *groupId;
    NSString *circleId;
    
    
    //////////////////添加群组成员
    NSMutableArray *inviteMember;



}

@property (unsafe_unretained, nonatomic) IBOutlet RoundHeadImageView *imgHead;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView1;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *viewFindFriend;

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtSearch;

@property (unsafe_unretained, nonatomic) IBOutlet TreeView *tvFriendSearch;

- (IBAction)txtSearchOnExit:(id)sender;
- (IBAction)txtSearch_OnChanged:(id)sender;
- (IBAction)txtSearch_OnBeginEdit:(id)sender;



- (IBAction)tureBtnClick:(id)sender;
- (IBAction)backBtnCLick:(id)sender;

- (void)createTreeNodeFriend;
- (void)createTreeNodeGroup;
- (void)createTreeNodeCompany;

@property (strong, nonatomic) IBOutlet UIImageView *naviImage;

//
@property (strong, nonatomic) IBOutlet UITableView *tvFriendNew;
@property (strong, nonatomic) IBOutlet AIMTableViewIndexBar *indexBar;
@property (strong, nonatomic) IBOutlet UIButton *btnCancelFind;
- (IBAction)btnCancelFindClick:(id)sender;


///////roundIma
@property (nonatomic,assign)NSInteger indexRow;
@property (nonatomic,assign)NSInteger indexSection;
@property (nonatomic,strong)UIImageView *roundImg;


@end
