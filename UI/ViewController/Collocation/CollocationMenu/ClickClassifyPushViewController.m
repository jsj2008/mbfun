//
//  ClickClassifyPushViewController.m
//  Wefafa
//
//  Created by fafatime on 14-9-16.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "ClickClassifyPushViewController.h"
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
@interface ClickClassifyPushViewController ()
{
    NSMutableArray *collArrayImage;
    NSMutableString *returnMessage;
    
}
@end

@implementation ClickClassifyPushViewController
@synthesize waterView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [Toast hideToastActivity];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //new headview
    CGRect headrect=CGRectMake(0,0,self.naviView.frame.size.width,self.naviView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=_titleName;
    [self.naviView addSubview:view];
//    NSMutableArray *collocationList=[NSMutableArray new];

    NSString *collocationTagIds=[NSString stringWithFormat:@"%@",_listInfoArray[_btnTag][@"tagInfo"][@"id"]];
    BUTTON_WIDTH=64;
    
    commentArray = [[NSMutableArray alloc]init];
//    [commentArray addObjectsFromArray:[_listInfoArray objectAtIndex:_btnTag][@"mappingList"]];
    showNoView=[[NoDataView alloc]initWithFrame:CGRectMake(0, 80, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-40)];
    showNoView.hidden=YES;
    showNoView.titleLabel.hidden=YES;
    showNoView.noDataImgView.hidden=NO;
    [showNoView.noDataImgView setImage:[UIImage imageNamed:@"shoppingNil.png"]];
    collArrayImage = [NSMutableArray new];
    
    [self creatHeadScrollview];
    _centerScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*(_listInfoArray.count), _centerScrollView.frame.size.height);
    _centerScrollView.pagingEnabled = YES;
    _lineView.frame = CGRectMake(BUTTON_WIDTH*_btnTag+(BUTTON_WIDTH/2-22), 38, 44, 2);
    if (_btnTag<=5) {
        
        [_centerScrollView setContentOffset:CGPointMake(0,0) animated:NO];
    }else{
        [_centerScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*_btnTag,0) animated:NO];
    }
    [_centerScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*_btnTag,0) animated:NO];
    [_centerScrollView setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1]];
    
    [Toast makeToastActivity:@"正在加载，请稍后..." hasMusk:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL rst=[SHOPPING_GUIDE_ITF requestGetUrlName:@"WxCollocationTagMappingByCollocationTagIdsFilter" param:@{@"collocationTagIds":[Utils getSNSInteger:collocationTagIds]} responseList:commentArray  responseMsg:returnMessage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (rst&&commentArray.count>0){

//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//                    dispatch_async(dispatch_get_main_queue(), ^{
                        for (int i=0; i<[commentArray count]; i++) {
                            NSDictionary *dataD = [commentArray objectAtIndex:i];
                            if (dataD) {
                                ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD WithGood:NO];
                                [collArrayImage addObject:imageInfo];
                            }
                        }
                        self.waterView = [[ImageWaterView alloc]initWithDataArray:collArrayImage withFrame:CGRectMake(SCREEN_WIDTH*_btnTag, 0,UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-69-50) withshow:NO];
                        [self.waterView setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1]];
                        [_centerScrollView addSubview:self.waterView];
                        [self.waterView.onDidSelectedRow addListener:self selector:@selector(tvColl_OnDidSelected:RowMessage:)];
                        [Toast hideToastActivity];
//                        
//                    });
//                });
            }
            else{
                 [Toast hideToastActivity];
            }
        });
    });
                   
    return;
    

   
    
}
-(void)creatHeadScrollview
{
//    NSMutableArray *titleArray = [NSMutableArray new];
//    for (int a=0; a<[_listInfoArray count]; a++) {
//        NSString *titleName=[NSString stringWithFormat:@"%@",[_listInfoArray objectAtIndex:a][@"tagInfo"][@"name"]];
//        [titleArray addObject:titleName];
//    }
//    NSLog(@"titleArray----%@",titleArray);
//    _headScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 40);
//    _headScrollView.showsHorizontalScrollIndicator = NO;
//    MBTabsView *customClassifyModelV=[[MBTabsView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40) WithTitleArray:titleArray withIconArray:nil useScroll:YES WithPicAndText:NO];
//    customClassifyModelV.delegate=self;
//    [_headScrollView addSubview:customClassifyModelV];
    

    if (BUTTON_WIDTH*(_listInfoArray.count)<SCREEN_WIDTH)
    {
        BUTTON_WIDTH=SCREEN_WIDTH/_listInfoArray.count;
    }
    _headScrollView.contentSize = CGSizeMake(BUTTON_WIDTH*(_listInfoArray.count), 40);
    _headScrollView.showsHorizontalScrollIndicator = NO;
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = [UIColor redColor];
    [_headScrollView addSubview:_lineView];
    
    //创建 头部按钮
    for (int a= 0; a<_listInfoArray.count; a++)
    {
        UIButton *classifyBtn = [[UIButton alloc]initWithFrame:CGRectMake(a*BUTTON_WIDTH, 0, BUTTON_WIDTH, 45)];
        classifyBtn.tag=100+a;
        classifyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [classifyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [classifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if (classifyBtn.tag == _btnTag+100) {
            _lineView.frame = CGRectMake(BUTTON_WIDTH*(classifyBtn.tag-100)+(BUTTON_WIDTH/2-22), 38, 44, 2);
            
            int offsetx=BUTTON_WIDTH*(classifyBtn.tag-100);
            if (offsetx+SCREEN_WIDTH>_headScrollView.contentSize.width)
            {
                offsetx=offsetx+BUTTON_WIDTH-SCREEN_WIDTH;
                offsetx=offsetx>0?offsetx:0;
            }
            _headScrollView.contentOffset=CGPointMake(offsetx, 0);
        }
        [classifyBtn setTitle:[NSString stringWithFormat:@"%@",[_listInfoArray objectAtIndex:a][@"tagInfo"][@"name"]] forState:UIControlStateNormal];
        
        [classifyBtn addTarget:self
                        action:@selector(clickBtn:)
              forControlEvents:UIControlEventTouchUpInside];
        
        [_headScrollView addSubview:classifyBtn];
    }
}
-(void)getWaterViewWithPageOrTag:(int)tag
{
    [commentArray removeAllObjects];
    [commentArray addObjectsFromArray:[_listInfoArray objectAtIndex:tag][@"mappingList"]];
    [collArrayImage removeAllObjects];
    NSString *collocationTagIds=[NSString stringWithFormat:@"%@",_listInfoArray[tag][@"tagInfo"][@"id"]];
    [Toast makeToastActivity:@"正在加载,请稍后" hasMusk:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL rst=[SHOPPING_GUIDE_ITF requestGetUrlName:@"WxCollocationTagMappingByCollocationTagIdsFilter" param:@{@"collocationTagIds":[Utils getSNSInteger:collocationTagIds]} responseList:commentArray  responseMsg:returnMessage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (rst&&commentArray.count>0){
                
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    for (int i=0; i<[commentArray count]; i++) {
//                        NSDictionary *dataD = [commentArray objectAtIndex:i];
//                        if (dataD) {
//                            ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD WithGood:NO];
//                            [collArrayImage addObject:imageInfo];
//                        }
//                    }
//                    dispatch_async(dispatch_get_main_queue(), ^{
                
                        for (int i=0; i<[commentArray count]; i++) {
                            NSDictionary *dataD = [commentArray objectAtIndex:i];
                            if (dataD) {
                                ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD WithGood:NO];
                                [collArrayImage addObject:imageInfo];
                            }
                        }
                        [self.waterView setFrame:CGRectMake(SCREEN_WIDTH*tag, 0,UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-69-50)];
                        [Toast hideToastActivity];
                        [self.waterView refreshView:collArrayImage];
//                    });
//                });
            }
            else{
                
                [Toast hideToastActivity];
            }
        });
    });
  
}
-(void)TabItemClick:(id)sender button:(id)param
{
    UIButton *menuBtn = (UIButton*)sender;
    int indexPage = menuBtn.tag-100;
    [_centerScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*indexPage,0) animated:NO];
    [self getWaterViewWithPageOrTag:indexPage];
}
-(void)clickBtn:(id)sender
{
    UIButton *menuBtn = (UIButton*)sender;
    int indexPage = menuBtn.tag-100;
    _lineView.frame = CGRectMake(BUTTON_WIDTH*indexPage+(BUTTON_WIDTH/2-22), 38, 44, 2);
    [_centerScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*indexPage,0) animated:NO];
    
    [self getWaterViewWithPageOrTag:indexPage];
    
//    [commentArray removeAllObjects];
//    [commentArray addObjectsFromArray:[_listInfoArray objectAtIndex:indexPage][@"mappingList"]];
//    [collArrayImage removeAllObjects];
//    
//    for (int i=0; i<[commentArray count]; i++) {
//        NSDictionary *dataD = [commentArray objectAtIndex:i];
//        if (dataD) {
//            ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD WithGood:NO];
//            [collArrayImage addObject:imageInfo];
//        }
//    }
//    [self.waterView refreshView:collArrayImage];
}
#pragma mark - UIScrollViewDelegate //只要滚动了就会触发
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x>=0) {
        int page = floorf(scrollView.contentOffset.x / SCREEN_WIDTH);
        
        _lineView.frame = CGRectMake(BUTTON_WIDTH*page+(BUTTON_WIDTH/2-22), 38, 44, 2);
        if (page>4) {
            [_headScrollView setContentOffset:CGPointMake(BUTTON_WIDTH*5,0) animated:NO];
        }
        else
        {
            
            [_headScrollView setContentOffset:CGPointMake(0,0) animated:NO];
        }
        
//        if (commentArray.count==0) {
//            showNoView.hidden = NO;
//        }
//        else
//        {
//            showNoView.hidden = YES;
            [self getWaterViewWithPageOrTag:page];
//        }
    }
    
 
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    
}
- (void)tvColl_OnDidSelected:(ImageWaterView*)sender RowMessage:(id)message
{
    ImageInfo *info = message;
    NSDictionary *showMessage = [NSDictionary dictionaryWithDictionary:info.imageData];
    NSDictionary *native=_functionXML[@"native"];
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
    
/*
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return commentArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 0.1;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *AIdentifier =  @"ClickClassifyTableViewCell";
    ClickClassifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClickClassifyTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.data = commentArray[indexPath.section];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CollocationClassViewController *collocationClass = [[CollocationClassViewController alloc]initWithNibName:@"CollocationClassViewController" bundle:nil];
//    GetViewControllerFile *getvc=[GetViewControllerFile getVCFile];
//    NSString *functionid=[getvc getXMLAttributes:_functionXML[@"native"] key:@"functionid" attributes:nil];  CollocationClassViewController *viewC=[[CollocationClassViewController alloc] initWithNibName:@"CollocationClassViewController"  bundle:nil];
//    viewC.functionXML=[getvc getXMLFunction:_rootXML functionId:functionid];
//    viewC.rootXML=_rootXML;
//    viewC.valueDict=_listInfoArray[indexPath.section][@"tagInfo"];
//  
//    [self.navigationController pushViewController:collocationClass animated:YES];
    
//    GetViewControllerFile *getvc=[GetViewControllerFile getVCFile];
    NSDictionary *native=_functionXML[@"native"];
    if (native!=nil)
    {
        NSString *statuses = [NSString stringWithFormat:@"2"];
        NSMutableArray *collocationList=[[NSMutableArray alloc] init];
        
        [Toast makeToastActivity:@"正在加载..." hasMusk:YES];
        NSMutableString *returnMessage=[[NSMutableString alloc]init];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            BOOL rst=[SHOPPING_GUIDE_ITF requestGetUrlName:@"WxCollocationSetFilter" param:@{@"id":[Utils getSNSInteger:commentArray[indexPath.section][@"id"]],@"statuses":statuses} responseList:collocationList  responseMsg:returnMessage];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (rst&&collocationList.count>0)
                {
//                    CollocationDetailViewController *colldetailVC=[[CollocationDetailViewController alloc] initWithNibName:@"CollocationDetailViewController" bundle:nil];
//                    colldetailVC.data=collocationList[0];
//////1812321418551952                    colldetailVC.collocationLikeArray=param[1];
//////                    colldetailVC.maincell=self;
//                    NSString *functionid=[getvc getXMLAttributes:native key:@"functionid" attributes:nil];
//                    colldetailVC.functionXML=[getvc getXMLFunction:_rootXML functionId:functionid];
//                    colldetailVC.rootXML=_rootXML;
//                    [self.navigationController pushViewController:colldetailVC animated:YES];
                    CollocationViewController *colloVC=[AppDelegate getTabViewControllerObject:@"CollocationViewController"];
                    NSDictionary *rootXML=[colloVC getRootXML];
                    NSDictionary *dict=[colloVC getCollocationXML];
                    NSDictionary *native=dict[@"native"];
                    
                    if (native!=nil)
                    {
                        CollocationDetailViewController *colldetailVC=[[CollocationDetailViewController alloc] initWithNibName:@"CollocationDetailViewController" bundle:nil];
                        colldetailVC.data=collocationList[0];
                        colldetailVC.collocationLikeArray=[[NSMutableArray alloc] init];
                        colldetailVC.maincell=nil;
                        GetViewControllerFile *getvc=[GetViewControllerFile getVCFile];
                        NSString *functionid=[getvc getXMLAttributes:native key:@"functionid" attributes:nil];
                        colldetailVC.functionXML=[getvc getXMLFunction:rootXML functionId:functionid];
                        colldetailVC.rootXML=rootXML;
                        [self.navigationController pushViewController:colldetailVC animated:YES];
                    }
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

- (void)setupRefresh
{
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}
- (void)footerRereshing
{
    // 1.添加数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i<5; i++) {
            NSMutableArray *list=[[NSMutableArray alloc] initWithCapacity:10];
            NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
            BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:@"WxCollocationSetFilter" param:nil responseList:list responseMsg:msg];
            if (success)
            {
                [commentArray addObjectsFromArray:list];
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 2.2秒后刷新表格UI
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 刷新表格
                [self.tableView reloadData];
                // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                [self.tableView footerEndRefreshing];
            });
        });
    });
    
}
*/
- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
