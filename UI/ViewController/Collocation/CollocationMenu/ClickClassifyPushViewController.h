//
//  ClickClassifyPushViewController.h
//  Wefafa
//
//  Created by fafatime on 14-9-16.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NoDataView.h"
#import "ImageWaterView.h"
#import "MBCustomClassifyModelView.h"
@interface ClickClassifyPushViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MBCustomClassifyModelViewDelegate>
{
    CGFloat heightCell;

    NSMutableArray *commentArray;
    int BUTTON_WIDTH;
    BOOL isZan;
    
    NoDataView *showNoView;
}

@property (nonatomic,strong)UIView *lineView;
@property (weak, nonatomic) IBOutlet UIScrollView *headScrollView;
@property (weak, nonatomic) IBOutlet UIView *naviView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)UILabel *ZanNumLb;
@property (nonatomic,strong)NSString *parentId;
@property (nonatomic,strong)NSString *titleName;
@property (nonatomic,assign)int btnTag;

@property (nonatomic,strong)NSMutableArray *listInfoArray;

@property (strong, nonatomic) NSDictionary *functionXML;
@property (strong, nonatomic) NSDictionary *rootXML;

@property (weak, nonatomic) IBOutlet UIScrollView *centerScrollView;
@property (strong, nonatomic) ImageWaterView *waterView;
@end
