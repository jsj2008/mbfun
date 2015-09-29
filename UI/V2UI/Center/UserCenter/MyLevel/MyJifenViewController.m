//
//  MyJifenViewController.m
//  Wefafa
//
//  Created by Charles on 15/2/5.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//
//  废弃 不用 我的 积分
#import "MyJifenViewController.h"
#import "Utils.h"
#import "SQLiteOper.h"
#import "AppSetting.h"
#import "MBShoppingGuideInterface.h"
#import "NavigationTitleView.h"

@interface MyJifenViewController ()
@property (weak, nonatomic) IBOutlet UILabel *jifenLbl;

@end

@implementation MyJifenViewController

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//}
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
//}
-(void)backHome:(id)sender
{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect headrect=CGRectMake(0,0,self.naviView.frame.size.width,self.naviView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:)  selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"我的积分";
    [self.naviView addSubview:view];
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    typeof(self) __weak weakSelf = self;
    dispatch_async(concurrentQueue, ^{
        __block NSMutableArray *growthResult = nil;
        dispatch_sync(concurrentQueue, ^{
            NSMutableArray *growthResult_=[[NSMutableArray alloc]init];
            NSMutableString *growthReturnMessage=[[NSMutableString alloc]init];
            if ([SHOPPING_GUIDE_ITF requestGetUrlName:@"SysUserGrowthFilter" param:@{@"userId":self.openid} responseList:growthResult_  responseMsg:growthReturnMessage])
            {
                growthResult = growthResult_;
            }
        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"levelType == 3"];
            NSArray *temp = [growthResult filteredArrayUsingPredicate:pred];
            if (temp.count) {
                NSDictionary *data = [temp firstObject];
                weakSelf.jifenLbl.text = [NSString stringWithFormat:@"积分：%.2f",[data[@"points"] floatValue]];
            }
        });
    });
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
