//
//  ClickShareClassIfPushViewController.m
//  Wefafa
//
//  Created by mw on 15-1-13.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "ClickShareClassIfPushViewController.h"
#import "Utils.h"
#import "Toast.h"
#import "MyselfInfoViewController.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "JSON.h"
#import "MBShoppingGuideInterface.h"
#import "PullingRefreshTableView.h"
#import "MJRefresh.h"
#import "CommMBBusiness.h"
#import "CollocationDetailViewController.h"
#import "GetViewControllerFile.h"
#import "NavigationTitleView.h"
#import "CollocationClassViewController.h"
#import "ClickClassifyTableViewCell.h"
#import "NoDataView.h"
#import "ImageInfo.h"
#import "ImageWaterView.h"
#import "CollocationViewController.h"

@interface ClickShareClassIfPushViewController ()

@end

@implementation ClickShareClassIfPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tvColl_OnDidSelected:(ImageWaterView*)sender RowMessage:(id)message
{
    ImageInfo *info = message;
    NSDictionary *showMessage = [NSDictionary dictionaryWithDictionary:info.imageData];
    NSDictionary *native=self.functionXML[@"native"];
    if (native!=nil)
    {
        CollocationViewController *colloVC=[AppDelegate getTabViewControllerObject:@"CollocationViewController"];
        NSDictionary *rootXML=[colloVC getRootXML];
        NSDictionary *dict=[colloVC getCollocationXML];
        NSDictionary *native=dict[@"native"];
        
        if (native!=nil)
        {
            CollocationDetailViewController *colldetailVC=[[CollocationDetailViewController alloc] initWithNibName:@"CollocationDetailViewController" bundle:nil];
            colldetailVC.data=showMessage;
            colldetailVC.collocationLikeArray=[[NSMutableArray alloc] init];
            colldetailVC.maincell=nil;
            GetViewControllerFile *getvc=[GetViewControllerFile getVCFile];
            NSString *functionid=[getvc getXMLAttributes:native key:@"functionid" attributes:nil];
            colldetailVC.functionXML=[getvc getXMLFunction:rootXML functionId:functionid];
            colldetailVC.rootXML=rootXML;
            [self.navigationController pushViewController:colldetailVC animated:YES];
        }
        
        return;
        
        
        NSMutableArray *collocationList=[[NSMutableArray alloc] init];
        [Toast makeToastActivity:@"正在加载..." hasMusk:YES];
        NSMutableString *returnMessage=[[NSMutableString alloc]init];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //WxCollocationTagMappingByCollocationTagIdsFilter ?collocationTagIds=4
            BOOL rst=[SHOPPING_GUIDE_ITF requestGetUrlName:@"WxCollocationTagMappingByCollocationTagIdsFilter" param:@{@"collocationTagIds":[Utils getSNSInteger:showMessage[@"id"]]} responseList:collocationList  responseMsg:returnMessage];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (rst&&collocationList.count>0)
                {
                    
                }
                else
                {
                    [Utils alertMessage:@"数据错误！"];
                }
                [Toast hideToastActivity];
            });
        });
        
    }
    
    
    
}

@end
