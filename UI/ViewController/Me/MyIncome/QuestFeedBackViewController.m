//
//  QuestFeedBackViewController.m
//  Wefafa
//
//  Created by fafatime on 15-1-27.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "QuestFeedBackViewController.h"
#import "Utils.h"
#import "NavigationTitleView.h"
#import "Toast.h"
#import "WeFaFaGet.h"
#import "MBShoppingGuideInterface.h"
#import "HttpRequest.h"

@interface QuestFeedBackViewController ()

@end

@implementation QuestFeedBackViewController
@synthesize setBalenceId;
@synthesize seller_id;
- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.title=@"反馈问题";
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(updateQuest:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    self.navigationItem.rightBarButtonItems=@[right];
    
    
    
}
-(void)onBack:(id)sender
{
    [self popAnimated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _headView.backgroundColor=TITLE_BG;
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:@selector(updateQuest:) selectorMenu:nil];
//    [view.btnMenu setTitle:@"提交" forState:UIControlStateNormal];
    [view.btnOk setTitle:@"提交" forState:UIControlStateNormal];
    view.lbTitle.text=@"反馈问题";
//    [self.headView addSubview:view];
    [self setupNavbar];
    
    [self.view setBackgroundColor:[Utils HexColor:0xf2f2f2 Alpha:1]];
    
    _writeTextView.textColor=[Utils HexColor:0xacacac Alpha:1];
    [_writeTextView setBackgroundColor:[UIColor whiteColor]];
    UITapGestureRecognizer *tapGest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGest];
    
   
}
-(void)dismissKeyboard
{
    [self.view endEditing:YES];
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _writeTextView.text=@"";
   _writeTextView.textColor=[UIColor blackColor];
    
}

-(void)textViewDidChange:(UITextView *)textView
{
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    //   NSLog(@"___________。/。。%@",textView.text);
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    else
    {
        return YES;
        
    }
    
}

-(void)updateQuest:(id)sender
{
    
//    NSString *userId=[NSString stringWithFormat:@"%@",sns.ldap_uid];
//    NSString *st = @"CommisionSettleQnDtlUpdate";
    NSDictionary *postDic=@{@"SETTLE_DTL_ID":self.setBalenceId,@"SELLER_ID":seller_id,@"REMARK":_writeTextView.text};
    [HttpRequest postRequestPath:kMBServerNameTypeCollocation methodName:@"CommisionSettleQnDtlUpdate" params:postDic success:^(NSDictionary *dict) {
        [Toast hideToastActivity];
        
        if ([dict[@"isSuccess"] integerValue] ==1) {
            if ([[dict allKeys] containsObject:@"message"])
            {
                NSString *str = [NSString stringWithFormat:@"%@",dict[@"message"]];
                [Utils alertMessage:str];
            }
        }
        else
        {
            if([[dict allKeys] containsObject:@"message"])
            {
                NSString *st = [NSString stringWithFormat:@"%@",dict[@"message"]];
                [Utils alertMessage:st];
            }
            else
            {
                
                [Utils alertMessage:@"提交失败"];
            }
        }
        
    } failed:^(NSError *error) {
        
        [Utils alertMessage:@"提交失败"];
        
    }];

/*
 NSMutableDictionary *returnDic=[[NSMutableDictionary alloc]init];
 NSMutableString *returnStr=nil;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL succes =[SHOPPING_GUIDE_ITF requestPostUrlName:@"CommisionSettleQnDtlUpdate" param:postDic responseAll:returnDic responseMsg:returnStr];
        
        NSLog(@"detailMutableSRRAY----%@",returnDic);
        if (succes)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[returnDic allKeys] containsObject:@"message"])
                {
                    NSString *str = [NSString stringWithFormat:@"%@",returnDic[@"message"]];
                        [Utils alertMessage:str];
                }
                
            });
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
               if([[returnDic allKeys] containsObject:@"message"])
               {
                   NSString *st = [NSString stringWithFormat:@"%@",returnDic[@"message"]];
                        [Utils alertMessage:st];
               }
                else
                {
                
                    [Utils alertMessage:returnStr];
                }
            });
        }
    });*/

}
-(void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
