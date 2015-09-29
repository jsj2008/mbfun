//
//  SBrandViewController.m
//  Wefafa
//
//  Created by Unico on 15/5/17.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//


#import "SBrandViewController.h"
#import "SBrandCell.h"
#import "SBannerViewCell.h"
#import "SUtilityTool.h"
#import "SDataCache.h"
#import "HttpRequest.h"
#import "DesignerModel.h"
#import "UIScrollView+MJRefresh.h"
#import "Toast.h"
#import "WeFaFaGet.h"
#import "ShoppIngBagShowButton.h"
#import "MyShoppingTrollyViewController.h"
#import "SBrandOtherCell.h"
#import "SUtilityTool.h"
#import "BrandDetailViewController.h"

@interface SBrandViewController (){
    //滚动时加载
    BOOL scrollLoading;
    NSInteger _pageIndex;
    NSMutableArray * dataArray;
    UIView * _unResultView;
    BOOL  isNewBrand;
    NSArray *newBannerList;
}

//@property (nonatomic) UIView *selectView;
//@property (nonatomic) NSInteger cellNowHeight;
@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagButton;
@end

@implementation SBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // TODO: 判断登陆状态，如果没有登录，显示登录界面。
    self.cellNowHeight = 100;
    [self.tableView addFooterWithTarget:self action:@selector(requestAddData)];
    [self.tableView addHeaderWithTarget:self action:@selector(requestRefreshData)];
//
    _pageIndex = 0;
    [self setupNavbar];
    [self getData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [Toast hideToastActivity];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
  
    [self requestCarCount];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)requestAddData{
    _pageIndex = (self.list.count + 9)/ 10;
    [self getData];
}

- (void)requestRefreshData{
    _pageIndex = 0;
    [self getData];
}

-(void)getData{
    NSDictionary *data=nil;
    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";

    if (_isComeFromTopic) {
        //品牌更多more

//        data = @{
//                 @"m":@"Brand",
//                 @"a":@"getRecommendBrandList",
//                 @"page":@(_pageIndex)
//                 };
        data = @{
                 @"m":@"BrandMb",
                 @"a":@"getRecommendBrandList",
                 @"page":@(_pageIndex)
                 };
    }else
    {
//        data = @{
//                 @"m":@"Brand",
//                 @"a":@"getAllBrandListWithItem",
//                 @"page":@(_pageIndex)
//                 };
        data = @{
                 @"m":@"BrandMb",
                 @"a":@"getAllBrandListWithItem",
                 @"page":@(_pageIndex)
                 };
    }

    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation *operation, id object) {
        [self.tableView footerEndRefreshing];
   
        if ([[object objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDic=[object objectForKey:@"data"];
            if ([[dataDic allKeys]containsObject:@"banner"]) {
                newBannerList = [NSArray arrayWithArray:dataDic[@"banner"][@"1020"]];
                self.tableView.tableHeaderView =[self  getHeaderView];
                
            }
            if ([[dataDic allKeys]containsObject:@"brandList"])
            {
                isNewBrand = YES;
                NSArray *array =  dataDic[@"brandList"];
              
                if (_pageIndex == 0) {
                    self.list = [NSMutableArray arrayWithArray:array];
                    [self.tableView reloadData];
                }else{
                    if (array.count == 0) {
                        //                [Toast makeToast:@"已经到底了！" duration:1.5 position:@"center"];
                        [Toast makeToast:@"已经到底了!"];
                    }
                    [self.list addObjectsFromArray:array];
                    [self.tableView reloadData];
                }
            }
 
        }
        else
        {
            NSArray *array = [object objectForKey:@"data"];
            if (_pageIndex == 0) {
                self.list = [NSMutableArray arrayWithArray:array];
                [self.tableView reloadData];
            }else{
                if (array.count == 0) {
                    //                [Toast makeToast:@"已经到底了！" duration:1.5 position:@"center"];
                    [Toast makeToast:@"已经到底了!"];
                }
                [self.list addObjectsFromArray:array];
                [self.tableView reloadData];
            }

        }
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView footerEndRefreshing];
    }];
}

-(void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIView *tempView;
    CGRect navRect = self.navigationController.navigationBar.frame;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
    _shoppingBagButton = [[ShoppIngBagShowButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    [_shoppingBagButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_shoppingBagButton setImage:[UIImage imageNamed:@"Unico/cart"] forState:UIControlStateNormal];
    [_shoppingBagButton addTarget:self action:@selector(onCart) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:_shoppingBagButton];
    self.navigationItem.rightBarButtonItems = @[rightItem1];
    
    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    NSString *titleStr=@"推荐品牌";
    if (_isComeFromTopic) {
        titleStr=@"品牌专区";
    }
    UIButton *tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    [tempBtn setTitle:titleStr forState:UIControlStateNormal];
    tempBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
    tempBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [tempView addSubview:tempBtn];

    self.navigationItem.titleView = tempView;
    
}

-(void)onBack:(id)sender{
    [self popAnimated:YES];
}

-(UIView*)getHeaderView{
    NSInteger height = (UI_SCREEN_WIDTH/375)*(258/2);
    UIView * tempUI = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    tempUI.userInteractionEnabled=YES;
    UIImageView *tempView = [[UIImageView alloc]init];//WithImage:[UIImage imageNamed:@"Unico/banner250"]
    tempView.userInteractionEnabled=YES;
    tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, tempUI.frame.size.height);
    [tempView sd_setImageWithURL:[NSURL URLWithString:[newBannerList firstObject][@"img"]] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    [tempUI addSubview:tempView];
    UITapGestureRecognizer *tapGest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBanner)];
    [tempView addGestureRecognizer:tapGest];
    
    return  tempUI;
}
-(void)clickBanner
{
   [[SUtilityTool shared] jumpControllerWithContent:[newBannerList firstObject] target:self];
}
-(void)onCart
{
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *vc1=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
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

#pragma mark - UITableViewDatasourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 195;
    NSDictionary *tempDic = self.list[indexPath.row];
    NSInteger type = [tempDic[@"show_type"] integerValue];
    if (type == 1) {
        SBannerViewCell *cell =  (SBannerViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        height = cell.cellHeight;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tempDic = self.list[indexPath.row];
    NSInteger type = [tempDic[@"show_type"] integerValue];
    if (type == 1) {
        static NSString *SBannerViewCellIdentifier = @"SBannerViewCell";
        SBannerViewCell *cell = (SBannerViewCell *)[tableView dequeueReusableCellWithIdentifier:SBannerViewCellIdentifier];
        if (!cell) {
            cell = [[SBannerViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:SBannerViewCellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        cell.cellData = tempDic;
        [cell updateCellUI];
        //高度
        self.cellNowHeight = cell.cellHeight + cell.cellAdditionalHeight;
        return  cell;

    }else{
        if (isNewBrand) {
//            if ([newBannerList count]>0) {
//                static NSString *SBannerViewCellIdentifier = @"SBannerViewCell";
//                SBannerViewCell *cell = (SBannerViewCell *)[tableView dequeueReusableCellWithIdentifier:SBannerViewCellIdentifier];
//                if (!cell) {
//                    cell = [[SBannerViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:SBannerViewCellIdentifier];
//                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//                }
//                cell.cellData = [newBannerList firstObject];
//                [cell updateCellUI];
//                //高度
//                self.cellNowHeight = cell.cellHeight + cell.cellAdditionalHeight;
//                return  cell;
//            }
                static NSString *cellIdentifier = @"SBrandOtherCell";
                SBrandOtherCell *cell = (SBrandOtherCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell = [[SBrandOtherCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
                }
                cell.isComeFromTopic=_isComeFromTopic;
                self.cellNowHeight = cell.cellHeight;
                cell.parentVc = self;
                cell.cellData = [NSMutableDictionary dictionaryWithDictionary:tempDic];
                [cell updateCellView];
                return cell;
  
        
            
        }
        else
        {
            static NSString *cellIdentifier = @"SBrandCell";
            SBrandCell *cell = (SBrandCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[SBrandCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
            }
            cell.isComeFromTopic=_isComeFromTopic;
            self.cellNowHeight = cell.cellHeight;
            cell.parentVc = self;
            cell.cellData = [NSMutableDictionary dictionaryWithDictionary:tempDic];
            [cell updateCellView];
            return cell;
        }


    }
    return nil;
}
-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *tempDic = self.list[indexPath.row];
     if (isNewBrand) {
         
     }
    [[SUtilityTool shared] jumpControllerWithContent:tempDic target:self];
}


#pragma mark - UIScrollViewdelegate methods
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //    [self.blrView blurWithColor:[BLRColorComponents darkEffect]];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    
    CGRect bounds = scrollView.bounds;
    
    CGSize size = scrollView.contentSize;
    
    UIEdgeInsets inset = scrollView.contentInset;
    
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    
    CGFloat maximumOffset = size.height;
    //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。也可以根据这两个值的差来让他做点其他的什么事情
    if((maximumOffset-currentOffset) <= 0 && (maximumOffset-currentOffset)>-1)
    {
        
    }
}

#pragma mark - long press
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    
    
}
@end