//
//  SItemDetailViewController.m
//  Wefafa
//
//  Created by unico on 15/5/15.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//  废弃 不用 以前的单品详情页面


#import "SItemDetailViewController.h"
#import "SCollocationDetailViewController.h"
#import "MBGoodsDetailsModel.h"
#import "SUtilityTool.h"
#import "HttpRequest.h"
#import "MBGoodsDetailsShowPictureView.h"
#import "MBGoodsShowCollocationPictureView.h"
#import "MBCollocationInfoModel.h"
#import "UIImageView+AFNetworking.h"
#import "GoodsCommentView.h"
#import "MBAddShoppingViewController.h"
#import "Utils.h"
#import "ShoppingBagViewController.h"
#import "MyShoppingTrollyViewController.h"

#import "SDataCache.h"
#import "LNGood.h"
#import "LoginViewController.h"
#import "ShoppIngBagShowButton.h"
#import "WeFaFaGet.h"
#import "Toast.h"
#import "SitemRelevantCollocationModel.h"
#import "SActivityPromPlatModel.h"
#import "ShareRelated.h"
#import "CollocationPopView.h"

#import "SCollocationDetailNoneShopController.h"


@interface SItemDetailViewController ()<collocationPopViewDelegate,UIActionSheetDelegate>
{
    BOOL isScrollLoading;
    BOOL relevantCollocationListDone;
    BOOL waterFlowCollocationListDone;
    UIImageView *showBigImgView;
    UIImageView *bannerView;
    NSDictionary *bannerInfo;
    UIButton *likeBtn;  //中部收藏
    UIButton *leftButton;//底部收藏
    BOOL isWish;
    UIAlertView *showAlertView ;
}

@property (nonatomic, strong) MBGoodsDetailsModel *contentModel;
@property (nonatomic, strong) NSMutableArray *collocationInfoModelArray;
@property (nonatomic, strong) NSArray *sizeArray;
@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagButton;
@property (nonatomic, weak) CollocationPopView *popView;

@property (strong, readwrite, nonatomic)UILabel *carCountLabel;
@property (strong, readwrite, nonatomic)UIImageView *collectionImageView;

@end

@implementation SItemDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    relevantCollocationListDone = NO;
    waterFlowCollocationListDone = NO;
    //显示navigator
    //self.view.backgroundColor = [Utils HexColor:0xf2f2f2 Alpha:1];
    [self setupNavbar];
    //    [self initNavigationBar];
    
    [Toast makeToastActivity];
    
    [self getData];
}
//尽量写在getdata里
-(void)getData{
    if (!_productID) {
        self.view.userInteractionEnabled = NO;
        [Toast makeToast:@"没有商品数据" duration:3.0 position:@"center"];
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:3.0];
    }
    
    [self requestData];
    [self requestSizeInfo];
    [self requestCollocation];
    [self getCollocationList:NO];
}

- (void)requestData{
    __unsafe_unretained typeof(self) p = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"LoginUserId"] = sns.ldap_uid;
    
    if (!sns.isLogin) {
        sns.ldap_uid=@"";
    }
    if (_productID) {
        params[@"id"] = _productID;
        params[@"LoginUserId"] = sns.ldap_uid;
    }else if (_productCode){
        params[@"code"] = _productCode;
        params[@"LoginUserId"] = sns.ldap_uid;
    }else{
        NSLog(@"没有商品数据");
    }
    
    //    一分钱支付测试商品
    //    params[@"code"] = @"522916";
    //   params[@"ID"] = _productID;
    [HttpRequest productGetRequestPath:nil methodName:@"ProductClsFilter" params:params success:^(NSDictionary *dict)
     {
         NSArray *array = dict[@"results"];
         p.contentModel = [[MBGoodsDetailsModel alloc]initWithDictionary:[array firstObject]];
         p.productID= [NSString stringWithFormat:@"%@",p.contentModel.clsInfo.aID];
     } failed:^(NSError *error) {
         [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
     }];
}

- (void)requestCarCount{
    if(!sns.ldap_uid){
        [Toast hideToastActivity];
        return;
    }

    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
        //        [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]] forState:UIControlStateNormal];
        NSInteger total = [dict[@"total"] integerValue];
        if (total==0) {
            return ;
        }
        int count = [dict[@"results"][0][@"count"] intValue];
        if (count!=0) {
            self.shoppingBagButton.titleLabel.hidden = NO;
            [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]] forState:UIControlStateNormal];
            
            
            if (self.carCountLabel == nil)
            {
                self.carCountLabel = [[UILabel alloc] init];
            }
            
            if (count > 99)
            {
                self.carCountLabel.text = @"99+";
            }
            else
            {
                self.carCountLabel.text = [NSString stringWithFormat:@"%d", count];
            }
            
            self.carCountLabel.hidden = NO;

        }
        else
        {
            self.shoppingBagButton.titleLabel.hidden = YES;
            
            
            if (self.carCountLabel == nil)
            {
                self.carCountLabel = [[UILabel alloc] init];
            }
            
            self.carCountLabel.hidden = YES;

        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)requestCollocation{
    //相关搭配请求
    __unsafe_unretained typeof(self) p = self;
    
    
    NSInteger tid = [self.productID integerValue];
    [SDATACACHE_INSTANCE getRelevantCollocationForItem:tid complete:^(NSArray *data) {
        relevantCollocationListDone = YES;
        p.collocationInfoModelArray = [NSMutableArray array];
        NSDictionary * dict = (NSDictionary*)data;
        NSArray *array = dict[@"middle"];
        // bug fix
        NSInteger count = MIN(array.count, 10);
        for (int i = 0; i < count; i ++){
            NSDictionary *dictionary = array[i];
            SitemRelevantCollocationModel *model = [[SitemRelevantCollocationModel alloc]initWithDictionary:dictionary];
            [p.collocationInfoModelArray addObject:model];
        }
        
        // banner
        bannerInfo = dict[@"banner"][@"1007"][0];
        if( bannerView ){
            [bannerView sd_setImageWithURL:[NSURL URLWithString:bannerInfo[@"img"]]];
        }
        
        [self dealCollocationData];
    } failure:^(NSError *error) {
        relevantCollocationListDone = YES;
        self.goodsList = [NSMutableArray array];
        
    }];
    
}

- (void)requestAddData{
    LNGood *goods = [self.goodsList firstObject];
    NSInteger listCount = self.goodsList.count - (goods.show_type.boolValue? 1: 0);
    NSInteger pageIndex = (listCount + 9)/ 10;
    NSDictionary *param = @{
                            @"cid": self.productID,
                            @"page": @(pageIndex)
                            };
    [[SDataCache sharedInstance] get:@"Collocation" action:@"getCollocationListForDetails" param:param success:^(AFHTTPRequestOperation *operation, id object) {
        [self.collectionView footerEndRefreshing];
        NSArray *data = object[@"data"];
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LNGood *goods = [LNGood goodWithDict:obj];
            [self.goodsList addObject:goods];
        }];
        [self.collectionView reloadData];
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.collectionView footerEndRefreshing];
        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
    }];
}

-(void) getCollocationList:(BOOL)isScrollUpdate{
    NSInteger tid = [self.productID integerValue];
    [[SDataCache sharedInstance] getCollocationListForItem:tid page:0 complete:^(NSArray *data) {
        waterFlowCollocationListDone = YES;
        //转换成LNGood的数据模型
        if (!self.goodsList) {
            self.goodsList = [NSMutableArray arrayWithCapacity:data.count];
        }
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LNGood *goods = [LNGood goodWithDict:obj];
            [self.goodsList addObject:goods];
        }];
        if (isScrollUpdate) {
            [self.collectionView reloadData];
        }else{
            [self dealCollocationData];
        }
        
    } failure:^(NSError *error) {
        
        waterFlowCollocationListDone = YES;
        
        self.goodsList = [NSMutableArray array];
    }];
}
-(void)dealCollocationData{
    if ([self judgeRequestDone]) {
        if (!_sizeArray || !_contentModel || !self.goodsList || self.goodsList.count <= 0) {
            
            return;
        }else{
            [self layoutUI];
        }
    }
    
}
-(BOOL)judgeRequestDone
{
    if (relevantCollocationListDone && waterFlowCollocationListDone) {
        return YES;
    }
    else
        return NO;
    
}
- (void)collectionRequestFinish{
    if (!_sizeArray || !_contentModel || !self.goodsList) {
        return;
    }else{
        [self layoutUI];
        
    }
}

- (void)setContentModel:(MBGoodsDetailsModel *)contentModel{
    _contentModel = contentModel;
    if (!_sizeArray || !_collocationInfoModelArray || !self.goodsList) {
        return;
    }else{
        [self layoutUI];
    }
}

- (void)setSizeArray:(NSArray *)sizeArray{
    _sizeArray = sizeArray;
    if (!_contentModel || !_collocationInfoModelArray || !self.goodsList) {
        return;
    }else{
        [self layoutUI];
    }
}

- (void)requestSizeInfo{
    __unsafe_unretained typeof(self) p = self;
    if (!_productID) {
        [Toast makeToast:@"错误参数！" duration:1.5 position:@"center"];
        return;
    }
    //    self.sizeArray = [NSArray array];
    [HttpRequest productGetRequestPath:@"Product" methodName:@"ProductSizeTableFilter" params:@{@"proD_CLS_ID": _contentModel.clsInfo.code} success:^(NSDictionary *dict) {
        p.sizeArray = dict[@"results"];
    } failed:^(NSError *error) {
        
    }];
    
//    [HttpRequest productGetRequestPath:@"Product" methodName:@"ProductSizeTableFilter" params:@{@"proD_CLS_ID": _productID} success:^(NSDictionary *dict) {
//        p.sizeArray = dict[@"results"];
//    } failed:^(NSError *error) {
//        
//    }];
}

-(void)layoutUI
{
    [super layoutUI];
    [Toast hideToastActivity];
    [self.collectionView setOrigin:CGPointMake(0, 0)];
    self.collectionView.contentInset = UIEdgeInsetsZero;
    [self.collectionView addFooterWithTarget:self action:@selector(requestAddData)];
    
    
    NSString *string;
    if (_contentModel.clsInfo.status.intValue != 2 || _contentModel.clsInfo.stockCount.intValue <= 0) {
        string = @"Unico/dpg_db_gray.png";
    }else{
        string = @"Unico/dpg_db.png";
    }
    
    
   /* UIImageView *imageView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:string rect:CGRectMake(0, UI_SCREEN_HEIGHT - 88/2, UI_SCREEN_WIDTH, 88/2)];
    imageView.userInteractionEnabled = YES;
    CGRect rect = CGRectMake(UI_SCREEN_WIDTH/2-158/2/2, imageView.height/4 , 158/2, 38/2);
    UIButton *centerButton = [[UIButton alloc]initWithFrame:rect];
    [centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (_contentModel.clsInfo.status.intValue != 2 || _contentModel.clsInfo.stockCount.intValue <= 0) {
        string = @"Unico/sale_all";
        centerButton.userInteractionEnabled = NO;
    }else{
        string = @"Unico/prompt_buy";
    }
    [centerButton setImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
    [centerButton addTarget:self action:@selector(touchBuyNowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:centerButton];
    

    
    float tempfloat = UI_SCREEN_WIDTH/3;
    CGRect frame = CGRectMake(50/2, 12, tempfloat, 22);

//    UIButton *leftButton = [[UIButton alloc]initWithFrame:frame];
    leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:frame];
    
    [leftButton setTitle:@"收藏" forState:UIControlStateNormal];
//    likeBtn = leftButton;
    //判断该搭配是否收藏
    //    if (_contentModel.isFavorite) {//listDict[@"is_love"]) {
    BOOL isLike = _contentModel.isFavorite;
    [self setLikeBtnStatus:isLike];
    NSLog(@"isLike ---- %d", isLike);
    //    }
    leftButton.titleLabel.font = FONT_t6;
    [leftButton addTarget:self action:@selector(likeContent:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setOrigin:CGPointMake(tempfloat/2 - leftButton.width/2, leftButton.frame.origin.y)];
    
    
    [imageView addSubview:leftButton];
    
    frame.origin.x = UI_SCREEN_WIDTH - 50/2 - 60;
    UIButton *rightButton = [[UIButton alloc]initWithFrame:frame];
    [rightButton setTitle:@"联系客服" forState:UIControlStateNormal];
     [rightButton setImage:[UIImage imageNamed:@"Unico/call_kf"] forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONT_t6;
    [imageView addSubview:rightButton];
    [rightButton addTarget:self action:@selector(touchConnectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setOrigin:CGPointMake(UI_SCREEN_WIDTH-tempfloat+tempfloat/2 - rightButton.width/2, rightButton.frame.origin.y)];
    [self.view addSubview:imageView];*/
    
    
    UIImageView *tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"to_top"]];
    tempView.frame = CGRectMake(UI_SCREEN_WIDTH - 40, UI_SCREEN_HEIGHT - 88/2 - 40 - 10, 60/2, 60/2);
    [self.view addSubview:tempView];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toTopClick:)];
    [tempView setUserInteractionEnabled:YES];
    [tempView addGestureRecognizer:recognizer];
    [self.view addSubview:tempView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - 88/2 - 10, UI_SCREEN_WIDTH, 88/2 + 10)];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor whiteColor];
    
    
    //参考线
    UIImageView  *horizontalBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageView.width, 1)];
    horizontalBar.image = [UIImage imageNamed:@"Unico/vertical_bar"];
    [imageView addSubview:horizontalBar];
    
    UIView *button1 = [[UIView alloc] initWithFrame:CGRectMake(0, 5, (imageView.width * (2.0/3.0)) * (1.0/3.0), imageView.height-5)];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/ico_service"]];
    imageView1.frame = CGRectMake((button1.width -  button1.height/2.0)/2.0, 0, button1.height/2.0, button1.height/2.0);
    [button1 addSubview:imageView1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, button1.height/2.0, button1.width, button1.height/2.0)];
    label1.text = @"联系客服";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:12];
    [button1 addSubview:label1];
    

    UITapGestureRecognizer *button1TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactKF:)];
    [button1 addGestureRecognizer:button1TapGestureRecognizer];
    [imageView addSubview:button1];
    
    //参考线
    UIImageView  *verticalBar1 = [[UIImageView alloc] initWithFrame:CGRectMake((imageView.width * (2.0/3.0)) * (1.0/3.0), 10, 1, imageView.height-20)];
    verticalBar1.image = [UIImage imageNamed:@"Unico/vertical_bar"];
    [imageView addSubview:verticalBar1];
    
    
    UIView *button2 = [[UIView alloc] initWithFrame:CGRectMake((imageView.width * (2.0/3.0)) * (1.0/3.0), 5, (imageView.width * (2.0/3.0)) * (1.0/3.0), imageView.height-5)];
    
    if (self.collectionImageView == nil)
    {
        self.collectionImageView = [[UIImageView alloc] init];
    }
    
    BOOL isLike = NO;
    
    if (_contentModel.isFavorite)
    {
        isLike = _contentModel.isFavorite;
    }
    
    if (isLike)
    {
        self.collectionImageView.image = [UIImage imageNamed:@"ico_collect_pressed"];
    }
    else
    {
        self.collectionImageView.image = [UIImage imageNamed:@"ico_collect_cancle"];
    }
    
    self.collectionImageView.frame = CGRectMake((button2.width -  button2.height/2.0)/2.0, 0, button2.height/2.0, button2.height/2.0);
    [button2 addSubview:self.collectionImageView];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, button2.height/2.0, button2.width, button2.height/2.0)];
    label2.text = @"收藏";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:12];
    [button2 addSubview:label2];
    
    UITapGestureRecognizer *button2TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeContent:)];
    [button2 addGestureRecognizer:button2TapGestureRecognizer];
    
    [imageView addSubview:button2];
    
    //参考线
    UIImageView  *verticalBar2 = [[UIImageView alloc] initWithFrame:CGRectMake((imageView.width * (2.0/3.0)) * (2.0/3.0), 10, 1, imageView.height-20)];
    verticalBar2.image = [UIImage imageNamed:@"Unico/vertical_bar"];
    [imageView addSubview:verticalBar2];
    
    
    UIView *button3 = [[UIView alloc] initWithFrame:CGRectMake((imageView.width * (2.0/3.0)) * (2.0/3.0), 5, (imageView.width * (2.0/3.0)) * (1.0/3.0), imageView.height-5)];
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NONE_DATA_SHOPPING_BAG]];
    imageView3.frame = CGRectMake((button3.width -  button3.height/2.0)/2.0, 0, button3.height/2.0, button3.height/2.0);
    [button3 addSubview:imageView3];
    
    if (self.carCountLabel == nil)
    {
        self.carCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
        self.carCountLabel.hidden = YES;
    }
    else
    {
        self.carCountLabel.frame = CGRectMake(0, 0, 17, 17);
    }
    
    self.carCountLabel.center = CGPointMake(imageView.width/4.0-40, 5);
    self.carCountLabel.backgroundColor = [UIColor redColor];
    self.carCountLabel.layer.cornerRadius = 8.5;
    self.carCountLabel.layer.masksToBounds = YES;
    self.carCountLabel.textAlignment = NSTextAlignmentCenter;
    self.carCountLabel.textColor = [UIColor whiteColor];
    self.carCountLabel.font = [UIFont boldSystemFontOfSize:9];
    
    
    
    [button3 addSubview:self.carCountLabel];
    
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, button3.height/2.0, button3.width, button3.height/2.0)];
    label3.text = @"购物袋";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:12];
    [button3 addSubview:label3];
    
    UITapGestureRecognizer *button3TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goCart:)];
    [button3 addGestureRecognizer:button3TapGestureRecognizer];
    
    [imageView addSubview:button3];
    
    
    UIButton  *button4 = [[UIButton alloc] initWithFrame:CGRectMake(imageView.width * 2.0/ 3.0, 0, imageView.width/3.0, imageView.height)];
    [button4 setTitle:@"立即购买" forState:UIControlStateNormal];
    
    [button4 setBackgroundColor:[Utils HexColor:0xfedc32 Alpha:1]];
    if(_contentModel.clsInfo.status.intValue != 2 )//已下架
    {
        [button4 setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
        button4.userInteractionEnabled=NO;
    }
    else if ( _contentModel.clsInfo.stockCount.intValue <= 0) {//已售罄 变为加入心愿单
        isWish = YES;
        [button4 setTitle:@"加入心愿单" forState:UIControlStateNormal];
        [button4 setBackgroundColor:[Utils HexColor:0xfedc32 Alpha:1]];
        button4.userInteractionEnabled=YES;
        
    }
    else
    {
        [button4 setBackgroundColor:[Utils HexColor:0xfedc32 Alpha:1]];
        button4.userInteractionEnabled=YES;
    }
    button4.titleLabel.font = FONT_T1;
    [button4 setTitleColor:[Utils HexColor:0x3b3b3b Alpha:1] forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(touchBuyNowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button4];
    
    [self.view addSubview:imageView];
}

-(void)toTopClick:(UITapGestureRecognizer*)recognizer{
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
}

//-(void)setLikeBtnStatus:(BOOL) {
////    http://10.100.20.28:8080/workspace/myWorkspace.action?projectId=3
//    NSDictionary *param = @{@"projectId" : @"2"};
//    [HttpRequest getRequestPath:kMBServerNameTypeProduct methodName:@"myWorkspace" params:param success:^(NSDictionary *dict) {
//
//    } failed:^(NSError *error) {
//
//    }];
//}

-(void)likeContent:(id)selector{
    if (![BaseViewController pushLoginViewController]){
        return;
    }
    
    if (!sns.isLogin) {
        LoginViewController *VC = [LoginViewController new];
        [self pushController:VC animated:YES];
        return;
    }
    
    BOOL isLike = _contentModel.isFavorite;
    //喜欢
    if (!isLike) {
        [Toast makeToastActivity:@"正在收藏..." hasMusk:NO];
        NSMutableArray *favoriteList = [NSMutableArray new];
        if(sns.ldap_uid.length==0)
            return;
        
        NSDictionary *param=@{
                              @"userId":sns.ldap_uid,
                              @"sourcE_TYPE":@(1),
                              @"sourcE_ID": [NSNumber numberWithInteger:[_contentModel.clsInfo.aID intValue]],
                              @"creatE_USER":sns.myStaffCard.nick_name
                              };
        [favoriteList addObject:param];
        
        [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"FavoriteCreateList" params:@{@"favoriteList":favoriteList} success:^(NSDictionary *dict) {
            [Toast hideToastActivity];
 
            NSLog(@"FavoriteCreateList -- %@", dict[@"message"]);
            if ([dict[@"isSuccess"] intValue] == 1) {
                [self setLikeBtnStatus:YES];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"productRefresh" object:nil userInfo:nil];
                
                _contentModel.isFavorite = YES;
            }
        } failed:^(NSError *error) {
            [Toast hideToastActivity];
            [Toast makeToast:@"收藏失败"];
        }];
    }else {
        [Toast makeToastActivity:@"正在取消收藏..." hasMusk:NO];
        NSDictionary *param=@{
                              @"sourcE_TYPE":@1,
                              @"sourceIdS":_contentModel.clsInfo.aID,
                              @"userId": sns.ldap_uid,
                              };
        
        [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"FavoriteDelete" params:param success:^(NSDictionary *dict) {
            [Toast hideToastActivity];
            //            [Toast makeToast:dict[@"message"]];
            NSLog(@"FavoriteDelete -- %@", dict[@"message"]);
            if ([dict[@"isSuccess"] intValue] == 1) {
                
                NSDictionary *dic=@{@"clsinfoid":[NSNumber numberWithInteger:[_contentModel.clsInfo.aID intValue]],
                                    @"method": @"delete",
                                    @"type": @"good"};
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDelete" object:nil userInfo:dic];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"productRefresh" object:nil userInfo:nil];
                
                [self setLikeBtnStatus:NO];
                _contentModel.isFavorite = NO;
            }
        } failed:^(NSError *error) {
            [Toast hideToastActivity];
            [Toast makeToast:@"收藏失败"];
        }];
    }
}

-(void)setLikeBtnStatus:(BOOL) isLike{
    
    
    if (isLike)
    {
        self.collectionImageView.image = [UIImage imageNamed:@"ico_collect_pressed"];
    }
    else
    {
        self.collectionImageView.image = [UIImage imageNamed:@"ico_collect_cancle"];
    }

     UIImageView *imgView = (UIImageView *)[likeBtn viewWithTag:100];
//    [imgView setFrame:CGRectMake(0, 0, 22, 22)];
    if (isLike) {
//        [likeBtn setImage: [UIImage imageNamed:@"Unico/like_3026_y"] forState:UIControlStateNormal];ico_collect_pressed@2x
//            [imgView setImage:[UIImage imageNamed:@"Unico/like_big2"]];
//        [leftButton setImage: [UIImage imageNamed:@"Unico/like_3026_y"] forState:UIControlStateNormal];
        [imgView setImage:[UIImage imageNamed:@"ico_collect_pressed@2x"]];
        [leftButton setImage: [UIImage imageNamed:@"ico_collect_pressed"] forState:UIControlStateNormal];
//        [leftButton setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, -15)];// {top, left, bottom, right};
        
    }else{
//        [likeBtn setImage: [UIImage imageNamed:@"Unico/like_3026"] forState:UIControlStateNormal];
//          [imgView setImage:[UIImage imageNamed:@"Unico/like_big"]];
         [imgView setImage:[UIImage imageNamed:@"ico_collect_cancle@2x"]];
        [leftButton setImage: [UIImage imageNamed:@"ico_collect_cancle"] forState:UIControlStateNormal];
 
    }
}

#pragma mark - tab bar touch action
-(void)addMyWish
{
    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
    //取消delLikeWish($token, $tempId,$type=1)
    NSDictionary *data = @{
                           @"m": @"Wish",
                           @"a": @"likeWish",
                           @"token":userToken,
                           @"tempId":self.productID,
                           @"type":@"1",
                           };
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation *operation, id object) {
        
        if ([object[@"status"] intValue] == 1) {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"加入心愿单成功!"
                                                             message:@"此商品现已售罄,我们会尽快补货!"
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil];
            [alertView show];
            
        }
  
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"加入心愿单失败!"
                                                         message:@"请稍候重试!"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
        [alertView show];
    }];
}
- (void)touchBuyNowButtonAction:(UIButton*)sender{
    
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    if (isWish) {
        //加入心愿单
        [self addMyWish];
        return;
    }

    MBAddShoppingViewController *controller = [[MBAddShoppingViewController alloc]initWithNibName:@"MBAddShoppingViewController" bundle:nil];
    controller.showType = typeBuyNow;
    controller.contentModel = _contentModel;
    controller.promotion_ID = _promotion_ID;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)touchAddShoppingButtonAction:(UIButton*)sender{
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *vc1=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
    
}

- (void)contactKF:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [SUTIL showService];
}

- (void)touchConnectionButtonAction:(UIButton*)sender{
    
    [SUTIL showService];
}

- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    UIImageView *topBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_bg"]];
    topBgView.frame = CGRectMake(0, 0, self.view.frame.size.width, 128/2);
    
    
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBack:)];
    self.navigationItem.leftBarButtonItems = @[left1] ;
    
    _shoppingBagButton = [[ShoppIngBagShowButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    [_shoppingBagButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_shoppingBagButton setImage:[UIImage imageNamed:@"Unico/cart"] forState:UIControlStateNormal];
    [_shoppingBagButton addTarget:self action:@selector(onCart:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:_shoppingBagButton];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    button.contentEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5);
    [button setImage:[UIImage imageNamed:@"Unico/icon_navigation_share"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onlist:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[rightItem1, item1];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

/**/
- (void)initNavigationBar{
    //顶端背景
    UIImageView *topBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_bg"]];
    topBgView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
    topBgView.frame = CGRectMake(0, 0, self.view.frame.size.width, 128/2);
    [topBgView setUserInteractionEnabled:YES];
    
    //添加返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5, 25, 60, 44)];
    [backBtn addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Unico/icon_back"]];
    tempView.frame = CGRectMake(10, 11, 22, 22);
    
    [backBtn addSubview:tempView];
    [topBgView addSubview:backBtn];
    
    //购物袋
    _shoppingBagButton = [[ShoppIngBagShowButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-88,20,  88/2, 88/2)];
    [_shoppingBagButton setImage:[UIImage imageNamed:@"cart" ] forState:UIControlStateNormal];
    [_shoppingBagButton addTarget:self action:@selector(goCart:) forControlEvents:UIControlEventTouchUpInside];
    [topBgView addSubview:_shoppingBagButton];
    
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn addTarget:self action:@selector(showPopView) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setFrame:CGRectMake(self.view.frame.size.width-44, 20,88/2,88/2)];
    [shareBtn setImage:[UIImage imageNamed:@"Unico/icon_report2"] forState:UIControlStateNormal];
    [topBgView addSubview:shareBtn];
    
    [self.view addSubview:topBgView];
}
/**/

-(void)clickBack:(id)selector{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goCart:(id)sender{
    // TODO: GOTO Cart
    //    [SUTIL showTodo];
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *controller = [[MyShoppingTrollyViewController alloc]initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self pushController:controller animated:YES];
    }
}

-(void)showPopView
{
    if (!_popView) {
        CollocationPopView *view = [[CollocationPopView alloc] initCollocationPopView:CGRectMake(UI_SCREEN_WIDTH - 115, 50+5, 100, 100) withIsMy:NO];
        view.delegate = self;
        [self.view addSubview:view];
        _popView = view;
        [_popView showPop];
        return;
    }
    [_popView hidePop];
}
-(void)collocationPopViewSelected:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            [self onlist:nil];
        }
            break;
        case 1:
        {
            NSLog(@"举报");
            if (![BaseViewController pushLoginViewController]) {
                return;
            }
            NSString *title = @"举报不良内容";
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:title, nil];
            [sheet showInView:self.view];
        }
            break;
            
        default:
            break;
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [Toast makeToastActivity:@""];
        [[SDataCache sharedInstance] addMyComplaintsInfoWithCollocationId:self.productID complete:^(NSArray *data, NSError *error) { 
            [Toast hideToastActivity];
//            if (error) {
//                [Toast makeToast:@"举报失败!"];
//                return ;
//            }
//            [Toast makeToast:@"举报成功!"];
//            [Toast makeToastSuccess:@"举报成功!"];
            NSString *showStr=@"";
            if (error) {
                
                showStr=[NSString stringWithFormat:@"举报失败!"];
            }
            else
            {
                NSString *dataState=[NSString stringWithFormat:@"%@",data];
                if ([dataState isEqualToString:@"1"]) {
                    
                    showStr=[NSString stringWithFormat:@"举报成功!"];
                    
                }
                else if ([dataState isEqualToString:@"-1"]) {
                    
                    showStr = [NSString stringWithFormat:@"您已举报!"];
                    
                }
                else
                {
                    showStr=[NSString stringWithFormat:@"举报成功!"];
                }
                
            }
            
            showAlertView = [[UIAlertView alloc]initWithTitle:showStr
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
            [showAlertView show];
            [self performSelector:@selector(hiddenShowAlertView) withObject:nil afterDelay:1.0f];
            
            

        }];
    }
}
-(void)hiddenShowAlertView
{
    [showAlertView dismissWithClickedButtonIndex:0 animated:NO];//important
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setupnavi];
    [self requestCarCount];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadShareCount:) name:@"shareCountAdd" object:nil];
}

- (void)setupnavi {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/common_navi_transparentblack.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    _shoppingBagButton = [[ShoppIngBagShowButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    [_shoppingBagButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_shoppingBagButton setImage:[UIImage imageNamed:@"Unico/cart"] forState:UIControlStateNormal];
    [_shoppingBagButton addTarget:self action:@selector(goCart:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:_shoppingBagButton];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Unico/icon_report2"] style:UIBarButtonItemStylePlain target:self action:@selector(showPopView)];
    self.navigationItem.rightBarButtonItems = @[item1,rightItem1];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/common_navi_mixblack.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.alpha = 1;
    [Toast hideToastActivity];
    [[self.navigationController.navigationBar viewWithTag:222] removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shareCountAdd" object:nil];
}

-(void)clickShare:(id)selector{
    NSLog(@"分享");
    [self onlist:nil];
    
}
-(void)onLike:(UIButton *)button{
    //喜欢
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    UIImageView *imgView = (UIImageView *)[button viewWithTag:100];
    NSString *soureceKey = _contentModel.isFavorite ? @"sourceIdS" : @"SOURCE_ID";
    NSDictionary *param=@{
                          soureceKey:[NSString stringWithFormat:@"%@",_contentModel.clsInfo.aID],
                          @"userId":sns.ldap_uid,
                          @"SOURCE_TYPE":@"1",
                          @"Create_User":sns.myStaffCard.nick_name
                          };
    NSString *methodName = _contentModel.isFavorite ? @"FavoriteDelete" :@"FavoriteCreate";
    [HttpRequest orderPostRequestPath:nil methodName:methodName params:param success:^(NSDictionary *dict) {
        if ([[dict objectForKey:@"isSuccess"] boolValue]) {
            if (_contentModel.isFavorite) {
                [imgView setImage:[UIImage imageNamed:@"ico_collect_pressed@2x"]];
            }else{
                [imgView setImage:[UIImage imageNamed:@"ico_collect_cancle@2x"]];
            }
            
            _contentModel.isFavorite = !_contentModel.isFavorite;
        }
        [Toast hideToastActivity];
    } failed:^(NSError *error) {
        [Toast hideToastActivity];
    }];
}

-(void)onCart:(id)sender{
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    //    ShoppingBagViewController *controller = [[ShoppingBagViewController alloc]initWithNibName:@"ShoppingBagViewController" bundle:nil];
    //    [self.navigationController pushViewController:controller animated:YES];
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *controller = [[MyShoppingTrollyViewController alloc]initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self pushController:controller animated:YES];
    }
    //    [self.navigationController pushViewController:controller animated:YES];
    
    
    
}

- (void)onlist:(UIButton*)sender {
    
    //     NSString *tempStr = ((MBGoodsDetailsPictureModel*)_contentModel.clsPicUrl[0]).filE_PATH;
    //    showBigImgView = [[UIImageView alloc]init];
    //
    //    [showBigImgView sd_setImageWithURL:[NSURL URLWithString:tempStr] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_BIGLOADING]];//sd_setImageWithURL:[NSURL URLWithString:tempStr]];
    //
    //
    
    ShareData *shareData = [[ShareData alloc]init];
    shareData.title = self.contentModel.clsInfo.name;
    shareData.descriptionStr = self.contentModel.clsInfo.aDescription;
    
    NSString *url=[SHOPPING_GUIDE_ITF createShareGoodsUrl:sns.ldap_uid CollocationID:@"" ProductClsID:[Utils getSNSString:self.contentModel.clsInfo.aID] designerId:@""];
    
    shareData.shareUrl = url;
    
    shareData.image = [Utils reSizeImage:showBigImgView.image toSize:CGSizeMake(57,57)];
    shareData.shopId = self.contentModel.clsInfo.aID;
    ShareRelated *view = [ShareRelated sharedShareRelated];
    [view showInTarget:self withData:shareData];
    
    
    
    
    return;
    //如果点击速度过快  图片没请求下来 则图片分享会为默认图
    ShareData *aData = [[ShareData alloc] init];
    NSString *productID= [NSString stringWithFormat:@"%ld",(long)self.productID];
    
    NSString *urlStr = [NSString stringWithFormat:SHARE_URL,productID];
    
    if (!urlStr || [urlStr length] == 0) {
        urlStr = @"http://www.banggo.com";
    }
    aData.shareUrl = urlStr;
    aData.image = [Utils reSizeImage:showBigImgView.image toSize:CGSizeMake(57,57)];
    aData.descriptionStr =  self.contentModel.clsInfo.aDescription;
    ShareRelated *share = [ShareRelated sharedShareRelated];
    [share showInTarget:self withData:aData];
}

-(void)selectCollocation:(id)selector{
    
    UITapGestureRecognizer *recognizer = (UITapGestureRecognizer*)selector;
    NSInteger selectIndex = recognizer.view.tag-BASE_BTN_TAG;
    
    SitemRelevantCollocationModel * model =  (SitemRelevantCollocationModel*)_collocationInfoModelArray[selectIndex];
    NSString * selectID =[NSString stringWithFormat:@"%@", model.aID] ;
    
  /*  SCollocationDetailViewController *vc = [SCollocationDetailViewController new];
    vc.collocationId = selectID ;
    [self.navigationController pushViewController:vc animated:YES];*/
    
    
    
    extern BOOL g_socialStatus;
    if (g_socialStatus)//是否处于社交状态
    {
        SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
        
        
        detailNoShoppingViewController.collocationId = selectID ;
        [self.navigationController pushViewController:detailNoShoppingViewController animated:YES];
        
    }
    else
    {
        SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
        
        
        collocationDetailVC.collocationId = selectID ;
        [self.navigationController pushViewController:collocationDetailVC animated:YES];
        
    }

}
//设置上部分内容
-(void) updateHeaderView:(UICollectionReusableView*) headerView{
    NSInteger offset = 0;
    UIView *tempUIView;
    UILabel *tempLabel;
    float tempfloat;
    UIImageView *tempView;
    NSString *tempStr ;
    UIView *tempUI;
    MBGoodsDetailsShowPictureView *showPictureView = [[MBGoodsDetailsShowPictureView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, UI_SCREEN_WIDTH)];
    showPictureView.contentModelArray = _contentModel.clsPicUrl;
    [headerView addSubview:showPictureView];
    //字体
    UIFont *fontStyle = [UIFont systemFontOfSize:12];
    
    
    offset += 375;
    
    NSInteger bgOffset = 0;
    bgOffset += 30/2;
    
    UIView *bgContent = [SUTILITY_TOOL_INSTANCE createUIViewByHeight:0 coordY:0];
    bgContent.backgroundColor = COLOR_WHITE;
    [headerView addSubview:bgContent];
    //内容描述
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyleFitHeight:_contentModel.clsInfo.name fontStyle:FONT_SIZE(13) color:UIColorFromRGB(0x3b3b3b) width:UI_SCREEN_WIDTH - 57/2-30/2 point:CGPointMake(20/2+7/2+30/2, bgOffset)];
    [bgContent addSubview:tempLabel];
    
    tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/record_progress_bar" rect:CGRectMake(20/2, tempLabel.frame.origin.y, 7/2, tempLabel.height)];
    [bgContent addSubview:tempView];
    
    likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeBtn setFrame:CGRectMake(UI_SCREEN_WIDTH - 110/2,tempLabel.frame.origin.y,55, 45)];
//    [likeBtn addTarget:self action:@selector(onLike:) forControlEvents:UIControlEventTouchUpInside];
    [likeBtn addTarget:self action:@selector(likeContent:) forControlEvents:UIControlEventTouchUpInside];

    NSString *imgName = @"ico_collect_cancle@2x";
    if (_contentModel.isFavorite) {
        imgName = @"ico_collect_pressed@2x";
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((55 - 51/2.0)/2.0, 0,44/2, 44/2)];
    [imageView setImage:[UIImage imageNamed:imgName]];
//    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [imageView setTag:100];
    [likeBtn addSubview:imageView];
    
    UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(-2, 20, 55, 25)];
    [likeLabel setTextAlignment:NSTextAlignmentCenter];
    [likeLabel setFont:FONT_SIZE(10)];
    [likeLabel setTextColor:UIColorFromRGB(0x999999)];
    [likeLabel setText:@"收藏"];
    [likeBtn addSubview:likeLabel];
    
    //    tempUIView  = [SUTILITY_TOOL_INSTANCE createImageAndLabel:@"喜欢" color:UIColorFromRGB(0x999999) fontStyle:FONT_SIZE(10) interval:4/2 imageName:@"Unico/like_big" imageSize:CGSizeMake(51/2, 45/2)];
    //    [tempUIView setFrame:CGRectMake(UI_SCREEN_WIDTH - 110/2,tempLabel.frame.origin.y,110/2, 90/2)];
    //    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onLike:)];
    //    [tempUIView setUserInteractionEnabled:YES];
    //    [tempUIView addGestureRecognizer:recognizer];
    
    [bgContent addSubview:likeBtn];
    

    likeBtn.hidden = YES;
   
    bgOffset += tempLabel.height;
    bgOffset += 30/2;
    tempStr = OTHER_TO_STRING(@"%.2f", _contentModel.clsInfo.sale_price.floatValue);
    tempStr=[Utils getSNSRMBMoney:tempStr];
    
    NSString *salePrice = [Utils getSNSRMBMoney:OTHER_TO_STRING(@"%.2f", _contentModel.clsInfo.sale_price.floatValue)];
    NSString *priceStr =[Utils getSNSRMBMoney:OTHER_TO_STRING(@"%.2f", _contentModel.clsInfo.price.floatValue)];
    
    tempLabel =  [SUTILITY_TOOL_INSTANCE createUILabelByStyle:tempStr fontStyle:FONT_SIZE(15) color:UIColorFromRGB(0x3b3b3b) rect:CGRectMake(50/2, bgOffset, 0, 0) isFitWidth:YES isAlignLeft:YES];
    [bgContent addSubview:tempLabel];
    
    tempStr = OTHER_TO_STRING(@"%.2f", _contentModel.clsInfo.price.floatValue);
     tempStr=[Utils getSNSRMBMoney:tempStr];
#warning 优惠信息在这里！
    if (_promPlatModel) {
        UILabel *promPlatLabel = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 165, tempLabel.frame.origin.y, 150, 20)];
        promPlatLabel.textAlignment = NSTextAlignmentRight;
        promPlatLabel.text = _promPlatModel.name;
        promPlatLabel.font = FONT_t7;
        promPlatLabel.textColor = COLOR_C2;
        [bgContent addSubview:promPlatLabel];
    }
    

    UILabel * tempLabel1 =  [SUTILITY_TOOL_INSTANCE createUILabelByStyle:tempStr fontStyle:FONT_SIZE(15) color:UIColorFromRGB(0x999999) rect:CGRectMake(CGRectGetMaxX(tempLabel.frame)+15, bgOffset, 0, 0) isFitWidth:YES isAlignLeft:YES];
    //划线
    UIView * crossLine = [[UIView alloc]initWithFrame:CGRectMake(tempLabel1.frame.origin.x, CGRectGetMidY(tempLabel1.frame), tempLabel1.size.width, 1)];
    crossLine.backgroundColor = UIColorFromRGB(0xd9d9d9);
    
    if (![salePrice isEqualToString:priceStr]) {
        [bgContent addSubview:crossLine];
        [bgContent addSubview:tempLabel1];

    }

    
    bgOffset += tempLabel.height;
    bgOffset += 32/2;
    
    
    //    tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"biaoqian" rect:CGRectMake(20/2, bgOffset, 40/2, 40/2)];
    //    [bgContent addSubview:tempView];
    //    tempfloat = 0;
    //    UIColor *fontColor;
    //    NSArray *tempAry = @[@"#夏日",@"Converse",@"手工DIY",@"黑色"];
    //    for (int i =0; i<tempAry.count; i++) {
    //        if (i == 0) {
    //            tempColor = [UIColor yellowColor];
    //            fontColor = COLOR_BLACK;
    //        }
    //        else{
    //            tempColor = UIColorFromRGB(0xc4c4c4);
    //             fontColor = COLOR_WHITE;
    //        }
    //        tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelMiddleText:tempAry[i] fontStyle:nil color:fontColor bgColor:tempColor rect:CGRectMake(tempView.width + 20/2+20/2 +tempfloat, bgOffset, 0, 40/2)];
    //        [bgContent addSubview:tempLabel];
    //        tempfloat += tempLabel.width + 18/2;
    //    }
    //    bgOffset += tempLabel.height;
    
    bgOffset += 23/2;
    bgOffset += 10;
    tempUIView = [SUTILITY_TOOL_INSTANCE createUIViewByArrowLine:@"推荐搭配" height:70/2 bgColor:nil fontColor:nil fontStyle:nil];
    [tempUIView setOrigin:CGPointMake(0, bgOffset)];
    [bgContent addSubview:tempUIView];
    bgOffset += tempUIView.height;
    bgOffset += 20/2;
    
    //搭配详情
    NSInteger widthLen = (self.view.frame.size.width -AUTO_SIZE(20+6))/4;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, bgOffset, UI_SCREEN_WIDTH, widthLen)];
    scrollView.contentSize = CGSizeMake((widthLen + 2) * _collocationInfoModelArray.count + 2 * 10, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    [bgContent addSubview:scrollView];
    for (int i = 0 ; i < _collocationInfoModelArray.count; i++) {
        tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic_loading"]];
        tempView.contentMode = UIViewContentModeScaleAspectFit;
        tempView.frame = CGRectMake(10 +i*(widthLen+2),0, widthLen,widthLen);
        tempView.tag = BASE_BTN_TAG+i;
        [SUTILITY_TOOL_INSTANCE addViewAction:tempView target:self action:@selector(selectCollocation:)];
        SitemRelevantCollocationModel *model = _collocationInfoModelArray[i];
        [tempView sd_setImageWithURL:[NSURL URLWithString:model.img]];
        
        [scrollView addSubview:tempView];
    }
    bgOffset += tempView.height;
    bgOffset += 20/2;
    
    tempUIView = [SUTILITY_TOOL_INSTANCE createUIViewByArrowLine:@"商品详情" height:70/2 bgColor:nil fontColor:nil fontStyle:nil];
    [tempUIView setOrigin:CGPointMake(0, bgOffset)];
    bgOffset += tempUIView.height;
    [bgContent addSubview:tempUIView];
    //自适应背景大小
    bgContent.frame = CGRectMake(0, 375, self.view.frame.size.width, bgOffset);
    
    offset += bgOffset;
    
    //商品详情
    UIView *itemContent = [UIView new];
    NSInteger itemContentOffset = 0;
    itemContent.frame = CGRectMake(0, offset, self.view.frame.size.width, 200);
    itemContent.backgroundColor = [UIColor whiteColor];
    [headerView addSubview: itemContent];
    //编辑推荐
    itemContentOffset += 32/2;
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"编辑推荐" fontStyle:nil color:nil rect:CGRectMake(20/2, itemContentOffset, 0, 0) isFitWidth:YES isAlignLeft:YES];
    [itemContent addSubview:tempLabel];
    
    itemContentOffset += tempLabel.height;
    itemContentOffset += 20/2;
    tempUIView = [SUTILITY_TOOL_INSTANCE getNormalLineBySize:UI_SCREEN_WIDTH height:1 color:UIColorFromRGB(0xd9d9d9)];
    [tempUIView setOrigin:CGPointMake(20/2, itemContentOffset)];
    [itemContent addSubview:tempUIView];
    itemContentOffset += tempUIView.height;
    itemContentOffset += 40/2;
    NSString *editStr =  _contentModel.clsInfo.aDescription;
    tempLabel  = [SUTILITY_TOOL_INSTANCE createUILabelByStyleFitHeight:editStr fontStyle:fontStyle color:[UIColor blackColor] width:(UI_SCREEN_WIDTH-20) point:CGPointMake(30/2, itemContentOffset)];
    [itemContent addSubview:tempLabel];
    itemContentOffset += tempLabel.height;
    itemContentOffset += 74/2;
    //商品信息
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"商品信息" fontStyle:nil color:nil rect:CGRectMake(20/2, itemContentOffset, 0, 0) isFitWidth:YES isAlignLeft:YES];
    [itemContent addSubview:tempLabel];
    itemContentOffset += 40/2;
    
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:[NSString stringWithFormat:@"品牌：%@", _contentModel.clsInfo.brand] fontStyle:FONT_SIZE(12) color:UIColorFromRGB(0x999999) rect:CGRectMake(10,itemContentOffset, 0, 0) isFitWidth:YES isAlignLeft:YES];
    [itemContent addSubview:tempLabel];
    itemContentOffset += tempLabel.height;
    itemContentOffset += 16/2;
//    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:[NSString stringWithFormat:@"款名：%@", _contentModel.clsInfo.name] fontStyle:FONT_SIZE(12) color:UIColorFromRGB(0x999999) rect:CGRectMake(10,itemContentOffset, 0, 0) isFitWidth:YES isAlignLeft:YES];
    
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyleFitHeight:[NSString stringWithFormat:@"款名：%@", _contentModel.clsInfo.name] fontStyle:FONT_SIZE(12) color:UIColorFromRGB(0x999999) width:UI_SCREEN_WIDTH - 57/2-30/2 point:CGPointMake(10, itemContentOffset)];
    [bgContent addSubview:tempLabel];
    [itemContent addSubview:tempLabel];
    itemContentOffset += tempLabel.height;
    itemContentOffset += 16/2;
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:[NSString stringWithFormat:@"款号：%@", _contentModel.clsInfo.code] fontStyle:FONT_SIZE(12) color:UIColorFromRGB(0x999999) rect:CGRectMake(10,itemContentOffset, 0, 0) isFitWidth:YES isAlignLeft:YES];
    [itemContent addSubview:tempLabel];
    itemContentOffset += tempLabel.height;
    itemContentOffset += 50/2;
    
    //下方大图
    for (int i = 0; i<_contentModel.clsPicUrl.count; i++) {
        tempStr = ((MBGoodsDetailsPictureModel*)_contentModel.clsPicUrl[i]).filE_PATH;
        tempView = [UIImageView new];
        tempView.contentMode = UIViewContentModeScaleAspectFit;
        [tempView sd_setImageWithURL:[NSURL URLWithString:tempStr] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_BIGLOADING]];//sd_setImageWithURL:[NSURL URLWithString:tempStr]];
        tempView.frame = CGRectMake(0, itemContentOffset, UI_SCREEN_WIDTH,UI_SCREEN_WIDTH);
        if (i==0) {
            showBigImgView  = tempView;
        }
        
        
        [itemContent addSubview:tempView];
        itemContentOffset += tempView.height;
        itemContentOffset += 10/2;
        
    }
    itemContentOffset += 50/2;
    
    
    
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"尺码参考" fontStyle:nil color:nil rect:  CGRectMake(10,itemContentOffset, 0, 0) isFitWidth:YES isAlignLeft:YES];
    [itemContent addSubview:tempLabel];
    itemContentOffset += tempLabel.height;
    itemContentOffset +=20/2;
    tempUIView = [SUTILITY_TOOL_INSTANCE getNormalLineBySize:UI_SCREEN_WIDTH height:1 color:COLOR_LINE];
    [tempUIView setOrigin:CGPointMake(20/2, itemContentOffset)];
    [itemContent addSubview:tempUIView];
    itemContentOffset += 1;
    itemContentOffset += 40/2;
    
    GoodsCommentView *sizeTableView = [[GoodsCommentView alloc]initWithFrame:CGRectMake(0, itemContentOffset, UI_SCREEN_WIDTH, AUTO_SIZE(100 - 40))];
    sizeTableView.modelArray = self.sizeArray;
    tempfloat = 0;
    [sizeTableView setSize:CGSizeMake(UI_SCREEN_WIDTH, tempfloat)];
    [sizeTableView.listTableView setSize:CGSizeMake(UI_SCREEN_WIDTH, tempfloat - 40)];
    [itemContent addSubview:sizeTableView];
    
    itemContentOffset += sizeTableView.height;
    itemContentOffset += 40/2;
    
    tempUIView = [SUTILITY_TOOL_INSTANCE createUIViewByArrowLine:@"有范承诺" height:70/2 bgColor:nil fontColor:nil fontStyle:nil];
    [tempUIView setOrigin:CGPointMake(0, itemContentOffset)];
    [itemContent addSubview: tempUIView];
    itemContentOffset += tempUIView.height;
    [itemContent setHeight:itemContentOffset];
    offset += itemContent.height;
    
    tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/youfanchengnuo" rect:CGRectMake(0, offset, UI_SCREEN_WIDTH, 104/2)];
    [headerView addSubview:tempView];
    
    
    
    offset += tempView.height;
    
    //    NSDictionary *bannerInfo = ((NSArray*)listDict[@"banner"][@"1006"])[0];
    //    if (bannerInfo) {
    //        float imgWidth = [bannerInfo[@"img_width"]floatValue];
    //        float imgHeight = [bannerInfo[@"img_height"]floatValue];
    //        tempStr = bannerInfo[@"img"];
    //        tempView = [UIImageView new];
    //        [tempView sd_setImageWithURL:[NSURL URLWithString:tempStr]];
    //        tempView.frame = CGRectMake(0,offset,UI_SCREEN_WIDTH, UI_SCREEN_WIDTH/(imgWidth/2)*(imgHeight/2));
    //        [SUTIL addViewAction:tempView target:self action:@selector(onSelectBanner:)];
    //        [headerView addSubview:tempView];
    //        offset += tempView.height;
    //    }
    
    tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"banner" rect:CGRectMake(0,offset,UI_SCREEN_WIDTH, AUTO_SIZE(189/2))];
    [headerView addSubview:tempView];
    offset += tempView.height;
    
    bannerView = tempView;
    [bannerView sd_setImageWithURL:[NSURL URLWithString:bannerInfo[@"img"]]];
    [SUTIL addViewAction:bannerView target:self action:@selector(onSelectBanner:)];
    
    //    UIView *tempUI = [SUTILITY_TOOL_INSTANCE createUIViewByArrowLine:@"人气" height:70/2 bgColor:UIColorFromRGB(0xf2f2f2) fontColor:nil fontStyle:nil];
    //    [tempUI setOrigin:CGPointMake(0, offset)];
    //    [headerView addSubview:tempUI];
    //    offset += tempUI.height;
    //    offset += 20/2;
    //    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"喜欢(2334)" fontStyle:nil color:nil rect:CGRectMake(20/2,offset, 0, 0) isFitWidth:YES isAlignLeft:YES];
    //    [headerView addSubview: tempLabel];
    //
    //    tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/right_arrow" rect:CGRectMake(UI_SCREEN_WIDTH-14/2-20/2, tempLabel.frame.origin.y, 14/2, 28/2)];
    //    [headerView addSubview:tempView];
    //    offset += tempLabel.height;
    //    offset += 20/2;
    //
    //    //点赞人头像
    //
    //    picAry = @[@"pic1",@"pic1",@"pic1",@"pic1",@"pic1",@"pic1",@"pic1",@"pic1"];
    //    UIScrollView *tempScrollView = [SUTILITY_TOOL_INSTANCE createScrollView:self rect:CGRectMake(0, offset, self.view.frame.size.width, 88/2)];
    //    tempScrollView.contentSize = CGSizeMake(10+(88/2+10)*picAry.count, 0);
    //    [headerView addSubview: tempScrollView];
    //    for (int i = 0; i<[picAry count]; i++) {
    //        tempView = [SUTILITY_TOOL_INSTANCE createRoundUIImageView:picAry[i] rect:CGRectMake(10+i*(88/2+10), tempScrollView.frame.size.height/2-88/2/2, 88/2, 88/2) cornerRadius:88/2/2];
    //        [tempScrollView addSubview:tempView];
    //    }
    //    offset += tempScrollView.height;
    //    offset += 20/2;
    //
    //
    //    tempUI = [SUTILITY_TOOL_INSTANCE getNormalLineBySize:UI_SCREEN_WIDTH height:1 color:UIColorFromRGB(0xc4c4c4)];
    //    [tempUI setOrigin:CGPointMake(20/2, offset)];
    //    [headerView addSubview:tempUI];
    //    offset += 1;
    //
    //    offset +=20/2;
    //    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"评论(9999)" fontStyle:nil color:nil rect:CGRectMake(20/2, offset,0, 0) isFitWidth:YES isAlignLeft:YES];
    //    [headerView addSubview:tempLabel];
    //    tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/right_arrow" rect:CGRectMake(UI_SCREEN_WIDTH-14/2-20/2, tempLabel.frame.origin.y, 14/2, 28/2)];
    //    [headerView addSubview:tempView];
    //
    //
    //
    //    for (int i = 0; i<5; i++) {
    //        tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add1"]];
    //        tempView.frame = CGRectMake(tempLabel.frame.origin.x + tempLabel.frame.size.width+20/2+i*29/2,tempLabel.frame.origin.y,29/2, 29/2);
    //        [headerView addSubview:tempView];
    //    }
    //    offset += tempLabel.height;
    tempUI = [SUTIL createUIViewByHeight:20/2 coordY:offset];
    tempUI.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:tempUI];
    offset += 20/2;
    tempUI = [SUTILITY_TOOL_INSTANCE getNormalLineBySize:UI_SCREEN_WIDTH height:1 color:UIColorFromRGB(0xc4c4c4)];
    [tempUI setOrigin:CGPointMake(0, offset -1)];
    [headerView addSubview:tempUI];
    
    
    //******uiview 6
    //推荐搭配
    tempUIView = [SUTILITY_TOOL_INSTANCE createUIViewByHeight:0 coordY:offset];
    
    tempUI = [SUTILITY_TOOL_INSTANCE createUILabeLine:@"推荐搭配" color:UIColorFromRGB(0xc4c4c4) fontStyle:FONT_SIZE(12) interval:20/2];
    [tempUI setOrigin:CGPointMake(0, 50/2)];
    [tempUIView addSubview:tempUI];
    [tempUIView setHeight:(50/2+30/2+tempUI.height)];
    tempUIView.backgroundColor = COLOR_NORMAL;
    
    [headerView addSubview:tempUIView];
    
    headerView.backgroundColor = COLOR_WHITE;
    offset += tempUIView.frame.size.height;
    
    self.headerViewHeight = offset;
}

-(void)onSelectBanner:(UITapGestureRecognizer*)recognizer{
    [SUTIL jumpControllerWithContent:bannerInfo target:self];
}

-(BOOL)submitShareInfo:(NSString *)toDesc shareUrl:(NSString *)url
{
    //    路径	CollocationSharedCreate
    //    Http 协议方式	Post
    //    参数	类型	说明	备注
    //    SourceId	Int	搭配、商品款ID	必填
    //    SourceType	Int	来源类型	1 商品 2 搭配
    //    UserId	string	分享者UserId	必填
    //    Memo	string	分享信息	必填
    //    List<CollocationSharedDetailCreateDto> DetailList
    //	List	分享明细
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
    if(url.length==0)
    {
        url = @"";
    }
    return [SHOPPING_GUIDE_ITF requestPostUrlName:@"ProductSharedCreate" param:@{@"SourceId":_contentModel.clsInfo.aID, @"SourceType":@"1", @"UserId":sns.ldap_uid, @"Memo":url, @"DetailList":@[@{@"toSharedId":toDesc}]} responseAll:dict responseMsg:msg];
}
-(void)reloadShareCount:(NSNotification*)status
{
    NSNumber *number = status.object;
    ShareItemStatus shareStatus = [number intValue];
    if (shareStatus == itemSucceed) {
//        [Toast makeToast:@"分享成功！" duration:2.0 position:@"center"];
        [Toast makeToastSuccess:@"分享成功!"];
    }else if(shareStatus == itemFailure){
        [Toast makeToast:@"分享失败！" duration:2.0 position:@"center"];
        return;
    }else if(shareStatus == itemCancel){
        [Toast makeToast:@"您取消了分享！" duration:2.0 position:@"center"];
        return;
    }else{
        return;
    }
    
    
    return;
    
    //回调接口
    NSString *url=[SHOPPING_GUIDE_ITF createShareCollocationUrl:sns.ldap_uid CollocationID:_contentModel.clsInfo.aID];//
    //    __weak typeof(self) p = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *string = @"单品分享";
        ///......../////
        //分享 shartype有问题
        //        switch (shareType) {
        //            case QQZone:
        //                string = @"搭配分享到QQ空间";
        //                break;
        //            case WeiXinFriends:
        //                string = @"搭配分享给微信好友";
        //                break;
        //            case WeiXinClick:
        //                string = @"搭配分享到微信朋友圈";
        //                break;
        //            case WeiBo:
        //                string = @"搭配分享到Weibo";
        //                break;
        //            default:
        //                break;
        //        }
        
        BOOL success=[self submitShareInfo:string shareUrl:url];
        //数据异常
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
//                [Toast makeToast:@"分享成功！" duration:2.0 position:@"center"];
                [Toast makeToastSuccess:@"分享成功!"];
                //                int count = self.contentModel.commonCountTotal.sharedCount.intValue;
                //                self.contentModel.commonCountTotal.sharedCount = @(count + 1);
                
            }
            else
            {
                [Toast makeToast:@"分享失败！" duration:2.0 position:@"center"];
            }
        });
    });
}
@end
