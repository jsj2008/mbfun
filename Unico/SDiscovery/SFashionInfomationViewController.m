//
//  SFashionInfomationViewController.m
//  Wefafa
//
//  Created by 凯 张 on 15/5/31.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SFashionInfomationViewController.h"
#import "SDataCache.h"
#import "SFashionViewCell.h"
#import "SUtilityTool.h"
#import "ShoppingBagViewController.h"
#import "SBannerViewCell.h"
#import "UIScrollView+MJRefresh.h"
#import "ShoppIngBagShowButton.h"
#import "WeFaFaGet.h"
#import "HttpRequest.h"
#import "MyShoppingTrollyViewController.h"

@interface SFashionInfomationViewController ()
{
    //滚动时加载
    BOOL scrollLoading;
    BOOL isScrollLoading;
}
@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagButton;
@end

@implementation SFashionInfomationViewController
static NSString *SFashionViewCellIdentifier = @"SFashionViewCell";
static NSString *SBannerViewCellIdentifier = @"SBannerViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavbar];
    
    // Do any additional setup after loading the view.
    // TODO: 判断登陆状态，如果没有登录，显示登录界面。
    self.cellNowHeight = 100;
    self.navigationController.navigationBar.hidden = NO;
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsZero;
    isScrollLoading = NO;
    self.list = [NSMutableArray new];
    self.lastPageIndex = 0;
    [self getData];
    __weak typeof(self) ws = self;
    /**
     *  下拉刷新顶部位置不对
     */
    /**/

    [self.tableView addHeaderWithCallback:^{
        [ws.list removeAllObjects];
        isScrollLoading = YES;
        ws.lastPageIndex = 0;
        [ws getData];
    }];
     /**/
    [self.tableView addFooterWithCallback:^{
        ws.lastPageIndex += 1;
        [ws getData];
    }];

}

-(void)getData{
    [SDATACACHE_INSTANCE getAllFashionList:self.lastPageIndex complete:^(NSArray *data) {
        [self updataWithRequest];
        [self.list addObjectsFromArray:data];
        [self.tableView reloadData];
    }];
}

- (void)updataWithRequest {
    if (self.lastPageIndex == 0) {
        [self.tableView headerEndRefreshing];
        if (isScrollLoading) {
            self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }
    }else {
        [self.tableView footerEndRefreshing];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self requestCarCount];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)setupNavbar {
    [super setupNavbar];
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    
    
    CGRect navRect = self.navigationController.navigationBar.frame;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil
                               action:nil];
    spacer.width = 0;//-20;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBack:)];
    self.navigationItem.leftBarButtonItems = @[left1] ;
    
    _shoppingBagButton = [[ShoppIngBagShowButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    [_shoppingBagButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_shoppingBagButton setImage:[UIImage imageNamed:@"Unico/cart"] forState:UIControlStateNormal];
    [_shoppingBagButton addTarget:self action:@selector(onCart:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:_shoppingBagButton];
    self.navigationItem.rightBarButtonItems = @[rightItem1];
    
    
//    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
//    
//    UILabel *tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"时尚资讯" fontStyle:FONT_SIZE(18) color:COLOR_WHITE rect:CGRectMake(0, 0, 0, self.navigationController.navigationBar.height) isFitWidth:YES isAlignLeft:YES];
//    [tempView setSize:CGSizeMake(tempLabel.width, self.navigationController.navigationBar.height)];
//    [tempView addSubview:tempLabel];
//    
//    self.navigationItem.titleView = tempView;
    self.title = @"时尚资讯";
    
}

-(void)clickBack:(id)selector{
    NSLog(@"返回");
    [self popAnimated:YES];
}
- (void)requestCarCount{
    if (!sns.isLogin) return;
    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
        
        NSInteger total = [dict[@"total"] integerValue];
        if (total==0) {
            return ;
        }
        int count = [dict[@"results"][0][@"count"] intValue];
        if (count!=0) {
            self.shoppingBagButton.titleLabel.hidden=NO;
            [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]] forState:UIControlStateNormal];
        }
        else
        {
            self.shoppingBagButton.titleLabel.hidden=YES;
            [self.shoppingBagButton setTitle:@"" forState:UIControlStateNormal];
        }

        
        [UIView animateWithDuration:0.25 animations:^{
            self.shoppingBagButton.titleLabel.transform = CGAffineTransformMakeScale(1.3, 1.3);
        }completion:^(BOOL finished) {
            self.shoppingBagButton.titleLabel.transform = CGAffineTransformIdentity;
        }];
    } failed:^(NSError *error) {
        
    }];
}
-(void)onCart:(id)sender{
    
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *vc1=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
    
}


#pragma mark UITableviewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self.list[indexPath.row]];
    SFashionViewCell *cell = (SFashionViewCell *)[tableView dequeueReusableCellWithIdentifier:SFashionViewCellIdentifier];
    if (!cell) {
        cell = [[SFashionViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:SFashionViewCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellData = tempDic;
    [cell updateCellUI];
    //高度
    self.cellNowHeight = cell.cellHeight - 10;
    return  cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.list[indexPath.row];
    float tempHeight = [dict[@"img_height"] floatValue];
    float tempWidth = [dict[@"img_width"] floatValue];
    float floatPercent = UI_SCREEN_WIDTH/(tempWidth/2);
    tempHeight = floatPercent*tempHeight/2;
    return tempHeight + 20/2 - 10;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *tempDict = self.list[indexPath.row];
//    [SUTIL jumpControllerWithContent:tempDict target:self];
    
    [SUTIL showWebpage:tempDict[@"url"] titleName:tempDict[@"name"] shareImg:tempDict[@"img"]];
}

@end

