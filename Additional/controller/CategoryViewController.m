//
//  CategoryTableViewController.m
//  newdesigner
//
//  Created by Miaoz on 14-9-26.
//  Copyright (c) 2014年 mb. All rights reserved.
//
//废弃 不用
#define CONTENTINSET 44

#import "CategoryViewController.h"
#import "GoodsViewController.h"
#import "CategoryTableCell.h"
#import "GoodCategoryElement.h"
#import "Globle.h"
#import "MaterialMapping.h"
#import "GoodsCollectionCell.h"
#import "Utils.h"
#define  NavTopButtonWide    70

#define kNavHeight 65
#define kDeviceWidth self.view.bounds.size.width
#define kDeviceHeight self.view.bounds.size.height
#define kTabBarHeight 60

#define pagesize 21
@interface CategoryViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property(strong,nonatomic) UITableView *tableView;
@property(strong,nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property(strong,nonatomic)UILabel *centerLable;
@property(nonatomic,strong)NSMutableArray *dataarray;//一级分类
@property(nonatomic,strong)NSMutableArray *dataSecondarray;//二级分类

@property(nonatomic,strong)NSMutableArray *dataMaterialarray;


@property(nonatomic,assign) int  number;
@property(nonatomic,strong)UIButton *rightbutton;
@property(nonatomic,strong)NavTopTitleView *navTopTitleView;
@end

@implementation CategoryViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
//    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 69)];
//    [self.view addSubview:naviView];
//    CGRect headrect=CGRectMake(0,0,naviView.frame.size.width,naviView.frame.size.height);
//    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
//    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:)  selectorOk:nil selectorMenu:nil];
//    view.lbTitle.text=@"所有分类";
//    [naviView addSubview:view];

    _number = 0;
  

    [self createBackButton];
    if (_dataarray == nil) {
        _dataarray = [NSMutableArray new];
    }
    if (_dataSecondarray == nil) {
         _dataSecondarray = [NSMutableArray new];
    }
   
    if (_dataMaterialarray == nil) {
        _dataMaterialarray = [NSMutableArray new];
    }
    
   
    [self creatTableView];
    [self initCollectionView];
    [self creatCenterLable];


    [self requestfirstAndsubCategoty];
   
    //[AppSetting getUserID]
    //12.17 add  by miao
    if ([_replaceStr isEqualToString:@"replaceYES"]) {
       
        [_rightbutton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _rightbutton.hidden = YES;
        [self recordClickSelectShearWithclickint:1];
        self.title = @"相似商品";
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y -50, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    }else{
        
      [self createRightBarbtn];
     [self creatNavTitleView];
    }
    
}
-(void)createRightBarbtn{
    UIButton *rightbutton = [self setNavRightBarbtnWithimage:@"btn_camera_normal.png"];
    [rightbutton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    _rightbutton = rightbutton;
    [rightbutton addTarget:self action:@selector(creatActionSheet) forControlEvents:UIControlEventTouchUpInside];
}
-(void)creatCenterLable{
    if (_centerLable == nil) {
        UILabel *lab;
        lab = [UILabel new];
        lab.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
        CGFloat centerY = self.view.bounds.size.height - 100;
        lab.center = CGPointMake(self.view.bounds.size.width/2, centerY/2);
        //        lab.center = self.view.center;
        lab.text = @"没有喜欢的商品";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor grayColor];
        lab.font = [UIFont boldSystemFontOfSize:30.0f];
        _centerLable = lab;
        lab.hidden = YES;
        [self.collectionView addSubview:lab];
    }
    
}
#pragma mark -- 创建NavTitleView
-(void)creatNavTitleView{
    NavTopTitleView *navTopTitleView = [[NavTopTitleView alloc] initWithFrame:CGRectMake(0, 0, NavTopButtonWide*2, 30.0f)];
    _navTopTitleView = navTopTitleView;
   navTopTitleView.buttonWide = [NSString stringWithFormat:@"%d",NavTopButtonWide];
    navTopTitleView.titlearray  = @[@"所有",@"我的"];//
    
    [navTopTitleView navTopTitleViewBlockWithbuttontag:^(id sender) {
        NSString *btntagStr = [NSString stringWithFormat:@"%@",sender];
        int btntag = btntagStr.intValue;
        switch (btntag) {
            case 0:
               
                _tableView.hidden = NO;
                _searchBar.hidden = NO;
                _collectionView.hidden = YES;
                [_rightbutton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                break;
                
            case 1:
                _tableView.hidden = YES;
                _searchBar.hidden = YES;
                _collectionView.hidden = NO;
                _rightbutton.hidden = YES;
//                [_rightbutton setBackgroundImage:[UIImage imageNamed:@"btn_camera_normal.png"] forState:UIControlStateNormal];
                if (_dataMaterialarray.count == 0) {
//                    [self requestMaterialFilterWithdic:(NSMutableDictionary *)@{@"UserId":sns.ldap_uid,
//                                                                                @"pageIndex":[NSNumber numberWithInt:1],
//                                                                                @"pageSize":[NSNumber numberWithInt:300]}];//@"9999"
                    [self requestGetFavoriteProductClsFilterWithpageIndex:@"1"];
//
                }
               
                break;
            
            default:
                break;
        }
    }];
    self.navigationItem.titleView = navTopTitleView;
    
    
    
}

#pragma 焦点记忆效果

-(void)recordClickSelectShearWithclickint:(int) clickint {
    if (clickint != 0) {
        _rightbutton.hidden = NO;
        _tableView.hidden = YES;
        _searchBar.hidden = YES;
        _collectionView.hidden = NO;
        [_rightbutton setBackgroundImage:[UIImage imageNamed:@"btn_camera_normal.png"] forState:UIControlStateNormal];
        
    }else{
        _rightbutton.hidden = YES;
        _tableView.hidden = NO;
        _searchBar.hidden = NO;
        _collectionView.hidden = YES;
        [_rightbutton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    for ( int i = 0 ; i < _navTopTitleView.buttonarray.count; i ++) {
        UIButton *btn =_navTopTitleView.buttonarray[i];
        btn.layer.borderColor = [[UIColor colorWithHexString:@"#353535"] CGColor];//#acacac
        btn.layer.borderWidth = 1.0f;
        btn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        //        btn.titleLabel.textColor = [UIColor colorWithHexString:@"#353535"];
        [btn setTitleColor:[UIColor colorWithHexString:@"#353535"] forState:UIControlStateNormal];
        
        
    }
    
    UIButton *sender = _navTopTitleView.buttonarray[clickint];
    //点击操作
    sender.layer.borderColor = [[UIColor colorWithHexString:@"#353535"] CGColor];//#acacac
    sender.layer.borderWidth = 1.0f;
    sender.backgroundColor = [UIColor colorWithHexString:@"#353535"];
    sender.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    //    sender.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [sender setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
 
    
}
#pragma mar

#pragma mark-商品类别请求
-(void)requestfirstAndsubCategoty
{
    
    [[HttpRequest shareRequst] httpRequestGetProductCategorySubItemFilterWithdic:nil success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            id data = [obj objectForKey:@"results"];
            if ([data isKindOfClass:[NSArray class]])
            {
                //遍历数组解析
                for (NSDictionary *dic in data)
                {
                    
                    GoodCategoryElement *goodCategoryElement = [[GoodCategoryElement alloc] init];
                   
                    GoodCategoryObj *firstCategoryObj;
                    firstCategoryObj=[JsonToModel objectFromDictionary:dic className:@"GoodCategoryObj"];
                    goodCategoryElement.firstCategoryObj = firstCategoryObj;
                    
                    id subItemdata =[dic objectForKey:@"subItem"];
                    if ([subItemdata isKindOfClass:[NSArray class]])
                    {
                        for (NSDictionary *topicdic in subItemdata)
                        {
                            GoodCategoryObj *subCategoryObj ;
                            subCategoryObj = [JsonToModel objectFromDictionary:topicdic className:@"GoodCategoryObj"];
                            [goodCategoryElement.subCategoryarray addObject:subCategoryObj];
                        }
                        
                    }
                    
                    [_dataarray addObject:goodCategoryElement];
                }
               
               GoodCategoryObj *goodCategoryObj =  _dataarray[0];
                [_dataarray removeObjectAtIndex:0];
                [_dataarray addObject:goodCategoryObj];
                [self.tableView reloadData];
            }
            
          
        }
        
    } ail:^(NSString *errorMsg) {
        
    }];
}


#pragma mark-商品（喜欢）列表请求
-(void)requestGetFavoriteProductClsFilterWithpageIndex:(NSString *)pageindex{
    [[HttpRequest shareRequst] httpRequestGetFavoriteProductClsFilterWithDic:(NSMutableDictionary *)@{@"userId":sns.ldap_uid,@"LoginUserId": sns.ldap_uid,@"pageIndex":[NSNumber numberWithInt:pageindex.intValue],@"pageSize":[NSNumber numberWithInt:pagesize]} success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            id data = [obj objectForKey:@"results"];
            if ([data isKindOfClass:[NSArray class]])
            {
                //遍历数组解析
                for (NSDictionary *dic in data)
                {
                    GoodObj *good = [GoodObj new];
                    good.clsInfo = [ClsInfo new];
                    good.clsPicUrl = [ClsPicUrl new];
                    
                    good.clsInfo.id = dic[@"id"];
                    good.clsInfo.code = dic[@"code"];
                    good.clsInfo.price = dic[@"price"];
                    good.clsInfo.sale_price = dic[@"sale_price"];
                    good.clsInfo.name = dic[@"name"];
                    good.isFavorite = dic[@"isFavorite"];
                    good.clsPicUrl.filE_PATH = dic[@"clsPicUrl"];
                    [_dataMaterialarray addObject:good];
                }
            }
            [_collectionView reloadData];
        }
    } fail:^(NSString *errorMsg) {
        
    }];


}

//static int pageindex = 1;

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    //    [_collectionView  removeFooter];
    // 添加上拉刷新尾部控件
    [self.collectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
      
        if (vc.dataMaterialarray.count%pagesize != 0 ) {//说明数据更新完
            [vc.collectionView footerEndRefreshing];
            return ;
        }
        int pageindex =  (int)(vc.dataMaterialarray.count/pagesize) + 1;
        //        if (vc.dataMaterialarray.count<vc.totalStr.intValue) {
        //            pageindex =  pageindex+1;
        //        }
        [vc requestGetFavoriteProductClsFilterWithpageIndex:[NSString stringWithFormat:@"%d",pageindex]];
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //            [vc.collectionView reloadData];
            // 结束刷新
            [vc.collectionView footerEndRefreshing];
        });
    }];
}


#pragma mark-创建TableView
-(void)creatTableView{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, _searchBar.bounds.size.height, kDeviceWidth, kDeviceHeight- _searchBar.bounds.size.height-kNavHeight) style:UITableViewStylePlain];
//        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        tableView.dataSource = self;
        _tableView = tableView;
        tableView.delegate = self;
        tableView.hidden = NO;
        //注册
        [self.tableView  registerClass:[CategoryTableCell class] forCellReuseIdentifier:@"categoryTableCell"];

        [self.view addSubview:tableView];
    }
}
#pragma mark-创建CollectionView
//初始化是这样初始化的。
-(void) initCollectionView{
    
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(107, 107);
        flowLayout.minimumInteritemSpacing = 0.0f;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, -CONTENTINSET, self.view.bounds.size.width+1, kDeviceHeight-kNavHeight) collectionViewLayout:flowLayout];//_searchBar.bounds.size.height-CONTENTINSET
        self.collectionView.backgroundColor = [UIColor whiteColor];
        //设置代理
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.tag = 333;
        //注册
        self.collectionView.hidden = YES;
        self.collectionView.contentInset = UIEdgeInsetsMake(CONTENTINSET, 0, 0, 0);
        [self.collectionView registerClass:[GoodsCollectionCell class] forCellWithReuseIdentifier:@"GoodsCollectionCell"];
      
        [self.view addSubview:self.collectionView];
        
//        [self creatHeader];  素材相关 隐藏
    }
}

-(void)dealloc{

    NSLog(@"CategoryViewController---dealloc");

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//每个section显示的标题

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    GoodCategoryElement * goodCategoryElement = _dataarray[section];
    
    return goodCategoryElement.firstCategoryObj.name;
}  

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return _dataarray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 43;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

 
    // Return the number of rows in the section.
   GoodCategoryElement * goodCategoryElement = _dataarray[section];
    return goodCategoryElement.subCategoryarray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CategoryTableCell" owner:nil options:nil];
    CategoryTableCell *cell = [nib objectAtIndex:0];

    
    // Configure the cell...
   GoodCategoryElement *goodCategoryElement = _dataarray[indexPath.section];
    
   GoodCategoryObj * categoryObj = goodCategoryElement.subCategoryarray[indexPath.row];
    cell.label.text = categoryObj.name;
    
   NSString *imageurl = [CommMBBusiness changeStringWithurlString:categoryObj.url width:50 height:50];
    NSString *url = [imageurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImageFromURLTOCache([NSURL URLWithString:url], url, ^(UIImage *image) {
        cell.categotyImageView.image = image;
    }, ^{
        cell.categotyImageView.image = [UIImage imageNamed:DEFAULT_LOADING_MEDIUM];
    });

    
    return cell;
}
#pragma mark - Table view Delegate
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GoodCategoryElement * goodCategoryElement = _dataarray[section];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, tableView.bounds.size.height)];
//    headView.backgroundColor = [UIColor redColor];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, headView.bounds.size.width, headView.bounds.size.height)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor colorWithHexString:@"#353535"];
    titleLab.font = [UIFont systemFontOfSize:13.0f];
    
    titleLab.text = goodCategoryElement.firstCategoryObj.name;
    [headView addSubview:titleLab];
    
    return headView;
  
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 32.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    GoodCategoryElement *goodCategoryElement = _dataarray[indexPath.section];
    
    GoodCategoryObj * categoryObj = goodCategoryElement.subCategoryarray[indexPath.row];
  
    [self performSegueWithIdentifier:@"GoodsViewController" sender:categoryObj];
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
#pragma mark --UICollectionViewDelegateFlowLayout
/*
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(106, 106);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0, 0);
}
*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return -0.6f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataMaterialarray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsCollectionCell *cell =(GoodsCollectionCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsCollectionCell" forIndexPath:indexPath];
    cell.likeButton.hidden = YES;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    GoodObj *goodObj = _dataMaterialarray[indexPath.row];
    
   
    if (indexPath.row == 0||indexPath.row == 1 || indexPath.row == 2) {
        cell.topLineImageView.hidden = NO;
    }else{
        cell.topLineImageView.hidden = YES;
    }
    NSString *imageurl = [CommMBBusiness changeStringWithurlString:goodObj.clsPicUrl.filE_PATH width:200 height:200];
    
    UIImageFromURLTOCache([NSURL URLWithString:imageurl] , imageurl, ^(UIImage *image) {
        cell.imageView.image =  image;
         cell.imageView.frame = CGRectMake((106 - image.size.width/2)/2, (106-image.size.height/2)/2, image.size.width/2, image.size.height/2);
    }, ^{
        cell.imageView.image =  [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
        cell.imageView.frame = CGRectMake(0, 0, 106, 106);
    });
    
    return cell;
}


#pragma mark <UICollectionViewDelegate>



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodObj *goodobj = _dataMaterialarray[indexPath.row];
    //12.12 add by miao
    if (goodobj.clsPicUrl.filE_PATH == nil || goodobj.clsPicUrl.filE_PATH == NULL) {
        
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_ADDCHOOSEGOODS object:nil userInfo:@{@"GoodObj":goodobj}];
    [self.navigationController popViewControllerAnimated:YES];
    
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//        
//        if ([vc isKindOfClass:[PolyvoreViewController class]]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_ADDCHOOSEGOODS object:nil userInfo:@{@"GoodObj":goodobj}];
//            [self.navigationController popToViewController:vc animated:YES];
//            
//        }else if ([vc isKindOfClass:[TemplateCollocationMatchVC class]]) {
//            //            [self.navigationController popToViewController:vc animated:YES];
//            
//            [self performSegueWithIdentifier:@"GoodsDetailVC" sender:goodobj];
//        }
//    }

//    MaterialMapping *materialMapping = _dataMaterialarray[indexPath.row];
//    if (_myblock) {
//        _myblock(materialMapping);
//    }
//    
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark--block
-(void)categoryVCMaterialBlockWithMaterialMapping:(CategoryVCMaterialBlock) block{

    _myblock = block;
}

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */
/*
 #pragma mark --UICollectionViewDelegateFlowLayout
 
 //定义每个UICollectionView 的大小
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
 {
 return CGSizeMake(96, 100);
 }
 
 //定义每个UICollectionView 的 margin
 -(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
 {
 return UIEdgeInsetsMake(5, 5, 5, 5);
 }
 
 #pragma mark --UICollectionViewDelegate
 
 //UICollectionView被选中时调用的方法
 -(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
 {
 UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
 cell.backgroundColor = [UIColor whiteColor];
 }
 
 //返回这个UICollectionView是否可以被选择
 -(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
 {
 return YES;
 }
 */


#pragma mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar                      // return NO to not become first responder
{
    searchBar.showsCancelButton = YES;
    NSLog(@"searchBarShouldBeginEditing");
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar                     // called when text starts editing
{
    NSLog(@"searchBarTextDidBeginEditing");
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar                         // return NO to not resign first responder
{
    NSLog(@"searchBarShouldEndEditing");
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
   
    [self performSegueWithIdentifier:@"GoodsViewController" sender:@{@"Desc":searchBar.text}];
    
   
    
}                    // called when keyboard search button pressed
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    

    
}                  // called when bookmark button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
      searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar                       // called when text ends editing
{
    NSLog(@"searchBarTextDidEndEditing");
    
}






















#pragma mark -creatActionSheet

/**
 static int pageindex = 1;
 
 - (void)addFooter
 {
 __unsafe_unretained typeof(self) vc = self;
 //    [_collectionView  removeFooter];
 // 添加上拉刷新尾部控件
 [self.collectionView addFooterWithCallback:^{
 // 进入刷新状态就会回调这个Block
 NSLog(@"------%d",vc.dataMaterialarray.count);
 if (vc.dataMaterialarray.count%21 != 0 ) {//说明数据更新完
 [vc.collectionView footerEndRefreshing];
 return ;
 }
 int pageindex =  vc.dataMaterialarray.count/21 + 1;
 //        if (vc.dataMaterialarray.count<vc.totalStr.intValue) {
 //            pageindex =  pageindex+1;
 //        }
 [vc requestMaterialFilterWithdic:(NSMutableDictionary *)@{@"UserId":sns.ldap_uid,
 @"pageIndex":[NSNumber numberWithInt:pageindex],
 @"pageSize":[NSNumber numberWithInt:21]}];
 
 
 
 // 模拟延迟加载数据，因此2秒后才调用）
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 //            [vc.collectionView reloadData];
 // 结束刷新
 [vc.collectionView footerEndRefreshing];
 });
 }];
 }
 
 ***/


-(void)creatHeader{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,  -CONTENTINSET, self.view.bounds.size.width, CONTENTINSET)];
    
    view.backgroundColor = [UIColor colorWithHexString:@"#f3efef"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    //    button.frame = CGRectMake(10, -CONTENTINSET, self.view.bounds.size.width-20, CONTENTINSET);
    button.frame = CGRectMake(10, 5, self.view.bounds.size.width-20, 30);
    [button setTitle:@"点击上传素材" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button setTitleColor:[UIColor colorWithHexString:@"#acacac"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(uploadMaterial:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    [self.collectionView addSubview: view];
}
-(void)uploadMaterial:(UIButton *)sender{
    
    [self creatActionSheet];
    
}


-(void)creatActionSheet
{
    
    if([ [ UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone )
    {
        UIActionSheet *actionSheet;
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:@"相机"
                                         otherButtonTitles:
                       @"从相册选择",nil];
        actionSheet.tag = 444;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        
        [actionSheet showInView:[AppDelegate shareAppdelegate].window];
    }else
    {
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持此功能" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 444) {
        if (buttonIndex == 0) {
            if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self pickImageFromCamera];
            }else{
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持此功能" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                
            }
            
            //             [self pickImageFromAlbum];
        }else if(buttonIndex == 1){
            [self pickImageFromAlbum];
            
        }else{
//            [self dismissViewControllerAnimated:YES completion:^{
//                NSLog(@"选取相片完成");
//            }];
            
        }
    }
    

}






#pragma mark -从用户相册获取活动图片
- (void)pickImageFromAlbum
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePicker.allowsEditing = YES;
    
    [self presentViewController:_imagePicker animated:YES completion:^{
        
        
        NSLog(@"系统相册调用成功");
    }];
}





#pragma mark -从摄像头获取活动图片

- (void)pickImageFromCamera
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePicker.allowsEditing = YES;
    
    [self presentViewController:_imagePicker animated:YES completion:^{
        
        NSLog(@"系统相机调用成功");
    }];
}

#pragma mark -imagePickerdelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
      NSData *data;
    UIImage *image1= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *  image;
//    if (image1.size.width>800) {
//        image = [self imageWithImageSimple:image1 scaledToSize:CGSizeMake(image1.size.width/2, image1.size.width/2)];
//    }else{
//        image = [self imageWithImageSimple:image1 scaledToSize:CGSizeMake(image1.size.width, image1.size.width)];
//    }
    
   image = [self imageCompressForSize:image1 targetSize:CGSizeMake(image1.size.width/4, image1.size.width/4)];
//    
//    image =  [Utils reSizeImage:image1 toSize:CGSizeMake(600,600)];
//    
    if (image != nil) {
       NSData *imagejpegdata =  UIImageJPEGRepresentation(image, 0.3);
        data = UIImagePNGRepresentation([UIImage imageWithData:imagejpegdata]);
    }else{
    
        [self dismissViewControllerAnimated:YES completion:^{
            
            [_imagePicker removeFromParentViewController];
            _imagePicker = nil;
            NSLog(@"data为nil");
        }];
    
    }

    [Toast makeToastActivity:@"素材上传中,请稍等..." hasMusk:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
        [_imagePicker removeFromParentViewController];
        _imagePicker = nil;
    
       
        NSString *d =[ASIHTTPRequest base64forData:data];
//        SNSStaffFull *userinfo =  [[Globle shareInstance] getUserInfo];
       //@"9999" @"miaozhang"[AppSetting getUserID]
        [CommMBBusiness getStaffInfoByStaffID:sns.ldap_uid staffType:STAFF_TYPE_OPENID defaultProcess:^{
        }complete:^(SNSStaffFull *staff, BOOL success){
            if (success)
            {
                NSDictionary *dic = @{@"UserId":sns.ldap_uid,
                                      @"PictureData":d,
                                      @"PictureType":@"png",
                                      @"CREATE_USER":staff.nick_name,
                                      @"Description":@"ios图片上传",
                                      @"Width":[NSNumber numberWithInt:image.size.width],
                                      @"Height":[NSNumber numberWithInt:image.size.height]};
               
                [self requestupdateImageWithpostDic:(NSMutableDictionary *)dic];
                
            }
        }];
       
       
        NSLog(@"选取相片完成");
    }];
    
    
}
#pragma mark--上传素材请求
-(void)requestupdateImageWithpostDic:(NSMutableDictionary *)postdic{
    [[HttpRequest shareRequst] httpRequestPostWXPicMaterialCreateWithDic:postdic success:^(id obj) {
        
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            [Toast hideToastActivity];
            NSString *updateurl = [obj objectForKey:@"message"];
            NSLog(@"%@",updateurl);

          
            [self requestMaterialFilterWithdic:(NSMutableDictionary *)@{@"UserId":sns.ldap_uid,
                                                                        @"pageIndex":[NSNumber numberWithInt:1],
                                                                        @"pageSize":[NSNumber numberWithInt:300]}];//@"9999"
        }//[AppSetting getUserID]

    } ail:^(NSString *errorMsg) {
        
    }];


}
#pragma mark--根据userid请求上传的素材列表
-(void)requestMaterialFilterWithdic:(NSMutableDictionary *)dic{
[[HttpRequest shareRequst] httpRequestGetWXPicMaterialFilterWithdic:dic success:^(id obj)
{
    if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
    {
        //防止数据重复
        if (_dataMaterialarray != nil||_dataMaterialarray.count != 0) {
            [_dataMaterialarray removeAllObjects];
        }
        
        id data = [obj objectForKey:@"results"];
        if ([data isKindOfClass:[NSArray class]])
        {
            //遍历数组解析
            for (NSDictionary *dic in data)
            {
                MaterialMapping *materialMapping;
                materialMapping=[JsonToModel objectFromDictionary:dic className:@"MaterialMapping"];
                [_dataMaterialarray addObject:materialMapping];
                
            }
            if (_dataMaterialarray == nil || _dataMaterialarray.count == 0) {
                _centerLable.hidden = NO;
            }else{
                _centerLable.hidden = YES;
            }
            [_collectionView reloadData];
        }
    }
} ail:^(NSString *errorMsg) {
    
}];


}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"cancle完成");
    }];
}
//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


//等比例压缩
-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *imgpathnamStr = [NSString stringWithFormat:@"portraitimage"];
    NSString *savepath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imgpathnamStr];
    
    NSFileManager *filesManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    
    BOOL existed = [filesManager fileExistsAtPath:savepath isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) )
    {
        [filesManager createDirectoryAtPath:savepath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    
    NSString *imageFilePath =[savepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]];
    [imageData writeToFile:imageFilePath atomically:NO];
    
    //    [[NSFileManager defaultManager] removeItemAtPath:<#(NSString *)#> error:nil];
    //        NSData *imageData = [NSData dataWithContentsOfFile:imageFilePath options:0 error:nil];
    //        UIImage *img = [UIImage imageWithData:imageData];
    //        self.m_SettingMainView.m_topbgdimgView.image = img;
    //        [self requestuploadimg:img];
    //    }
}
#pragma mark 从文档目录下获取Documents路径
- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"GoodsViewController"]) {
        GoodsViewController *viewController =segue.destinationViewController;
       
        if ([sender isKindOfClass:[GoodCategoryObj class]]) {
             GoodCategoryObj *categoryObj = (GoodCategoryObj *)sender;
            viewController.goodSecondCategoryid = [NSString stringWithFormat:@"%@",categoryObj.id];
            viewController.goodCategoryObj = categoryObj;
           
        }
        //搜索字段
        if ([sender isKindOfClass:[NSDictionary class]]) {
            viewController.getDic = (NSMutableDictionary *)sender;
            
            viewController.descContent = [(NSMutableDictionary *)sender objectForKey:@"Desc"];
            
        }
    
      

    }
}


- (IBAction)leftBarButtonItemClickevent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightBarButtonItemClickevent:(id)sender {
    
//    [self creatActionSheet];
}

-(void)createBackButton{
    UIImage *backButtonBackgroundImage = [UIImage imageNamed:@"ion_back"];
    // The background should be pinned to the left and not stretch.
    backButtonBackgroundImage = [backButtonBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backButtonBackgroundImage.size.width - 1, 0, 0)];
    
    id appearance = [UIBarButtonItem appearanceWhenContainedIn:[CategoryViewController class], nil];
    [appearance setBackButtonBackgroundImage:backButtonBackgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // Provide an empty backBarButton to hide the 'Back' text present by
    // default in the back button.
    //
    // NOTE: You do not need to provide a target or action.  These are set
    //       by the navigation bar.
    // NOTE: Setting the title of this bar button item to ' ' (space) works
    //       around a bug in iOS 7.0.x where the background image would be
    //       horizontally compressed if the back button title is empty.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:NULL];
    self.navigationItem.backBarButtonItem = backBarButton;

}
@end
