//
//  CustomerServiceViewController.m
//  Designer
//
//  Created by Charles on 15/1/16.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "CustomerServiceViewController.h"
#import "ReceiveChatCell.h"
#import "SendChatCell.h"

typedef enum : NSUInteger {
    ChatMessageSend,
    ChatMessageReceive,
} ChatMessageType;

@interface ChatObject : NSObject

@property(nonatomic,strong)NSString *content;

@property(nonatomic)ChatMessageType type;

@end

@implementation ChatObject

@end

@interface CustomerServiceViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *dataAry;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *input;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

static NSString *REUSE_RECCELL_ID = @"ReceiveChatCell";
static NSString *REUSE_SENDCELL_ID = @"SendChatCell";

@implementation CustomerServiceViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"联系客服";
    if (!_dataAry) {
        _dataAry = [NSMutableArray new];
        ChatObject *obj = [[ChatObject alloc]init];
        obj.content = @"您好，欢迎使用邦购商城!";
        obj.type = ChatMessageReceive;
        [_dataAry addObject:obj];
        [self.tableView reloadData];
    }
    [self registNib];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 58;
    typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter]addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        if (UIEdgeInsetsEqualToEdgeInsets(weakSelf.tableView.contentInset, UIEdgeInsetsZero)) {
            NSDictionary *info = [note userInfo];
            NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
            CGSize keyboardSize = [value CGRectValue].size;
//            weakSelf.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
            [self.view removeConstraint:_bottomConstraint];
            _bottomConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeBottom multiplier:1. constant:keyboardSize.height];
            [self.view addConstraint:_bottomConstraint];
            [UIView animateWithDuration:0.25 animations:^{
                [self.view layoutIfNeeded];
            }];
        }
    }];
    [[NSNotificationCenter defaultCenter]addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self.view removeConstraint:_bottomConstraint];
        _bottomConstraint = [NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1. constant:0];
        [self.view addConstraint:_bottomConstraint];
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
    }];
}

-(void)registNib
{
    [self.tableView registerNib:[UINib nibWithNibName:REUSE_RECCELL_ID bundle:nil] forCellReuseIdentifier:REUSE_RECCELL_ID];
    [self.tableView registerNib:[UINib nibWithNibName:REUSE_SENDCELL_ID bundle:nil] forCellReuseIdentifier:REUSE_SENDCELL_ID];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatObject *obj = _dataAry[indexPath.row];
    switch (obj.type) {
        case ChatMessageReceive:
        {
            ReceiveChatCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_RECCELL_ID];
            cell.contentLbl.text = obj.content;
            return cell;
        }
            break;
        case ChatMessageSend:
        {
            SendChatCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_SENDCELL_ID];
            cell.contentLbl.text = obj.content;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

-(void)sendMessage
{
    if (self.input.text.length) {
        ChatObject *obj = [[ChatObject alloc]init];
        obj.content = self.input.text;
        obj.type = ChatMessageSend;
        [_dataAry addObject:obj];
        self.input.text = @"";
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_dataAry.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataAry.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (IBAction)send:(UIButton *)sender {
    [self sendMessage];
//    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMessage];
//    [textField resignFirstResponder];
    return YES;
}

- (IBAction)showIssue:(UIControl *)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
