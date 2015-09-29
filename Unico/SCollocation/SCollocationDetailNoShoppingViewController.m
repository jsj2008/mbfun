//
//  SCollocationDetailNoShoppingViewController.m
//  Wefafa
//
//  Created by chencheng on 15/7/14.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SCollocationDetailNoShoppingViewController.h"

#import "SCollocationCollectionViewCell.h"
#import "SCollocationCollectionViewLayout.h"
#import "SProductDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "LNGood.h"
#import "SDataCache.h"
#import "SUtilityTool.h"
#import "LNGood.h"
#import "SCVideoPlayerView.h"
#import "MBShoppingGuideInterface.h"
#import "MBAddShoppingViewController.h"
#import "HttpRequest.h"
#import "Toast.h"
#import "AppSetting.h"
#import "SMineViewController.h"
#import "MyShoppingTrollyViewController.h"
#import "SCollocationGoodsTagModel.h"
#import "STopicDetailViewController.h"
#import "CommentsViewController.h"
#import "SBrandSotryViewController.h"
#import "ShoppIngBagShowButton.h"
#import "LoginViewController.h"
#import "SActivityPromPlatModel.h"
#import "ShareRelated.h"
#import "STagDetailViewController.h"
#import "SActivutyOptimalTool.h"
#import "SCollocationLoversController.h"
#import "CollocationPopView.h"

#import "SWaterAdvertCollectionViewCell.h"
#import "SWaterCollectionViewCell.h"

#import "NoShoppingCommentsViewController.h"

@interface SCollocationDetailNoShoppingViewController()<collocationPopViewDelegate,UIActionSheetDelegate, UITextFieldDelegate>
{
    NSMutableDictionary *listDict;
    NSArray *listItem;
    SCVideoPlayerView *playerView;
    UIView* p_itemShowView;
    UILabel *p_nowPriceLabel;
    UILabel *p_originPriceLabel;
    CGFloat _preferentialValue;
    BOOL isReadItemListLoading;
    BOOL isScrollLoading;
    NSMutableArray *idList;
    NSDictionary *userInfoDict;
    NSMutableArray *likeUserAry;
    UIView *designerBg;
    NSInteger isLove;        //    1-----展示取消关注。执行取消关注操作 后变为0  ， 0 --- 展示关注  执行 加关注操作 后变为1
    
    UIImageView * concernImgView;
    UIButton *likeBtn;
    UIImageView *_collocationBuyImageView;
    UIButton *_collocationBuyButton;
    UIView *_collocationBuyView;
    
    UIView * noneDataView;
    
    // tag的图层
    UIImageView *tagView;
    
    UIScrollView *likerScroll;
    
    BOOL ifColocationDone;
    BOOL ifColocationListDone;
    
    UIImageView *showBigImgView;
    BOOL _isErrorRequest;
    
    //    int totalStock;
    //    int totalOffline;
    
    //    NSMutableDictionary *stockDict;
    //    NSMutableDictionary *offlineDict;
    //
    NSMutableArray *skuList;
    
    NoShoppingCommentsViewController *_noShoppingCommentsViewController;
    
    UIView *_shieldView;
    UIAlertView * showAlertView ;
    
}

@property (nonatomic, strong) NSArray *tagArray;
@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagButton;
@property (nonatomic, strong) UILabel *salePirce;
@property (nonatomic, strong) NSMutableString *commentCount;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *likeLabel;
@property (nonatomic, weak) CollocationPopView *popView;


@end
@implementation SCollocationDetailNoShoppingViewController
//static NSString* CollocationCellReuseIdentifier = @"CollocationCellReuseIdentifier";
static NSString* HeaderReuseIdentifier = @"HeaderReuseIdentifier";
static NSString* FooterReuseIdentifier = @"FooterReuseIdentifier";

#define BASE_LIKE_USER_INDEX  (BASE_BTN_TAG + 100)
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"SCollocationDetailNoShoppingViewController viewDidLoad");
    
    ifColocationDone = NO;
    ifColocationListDone = NO;
    [self initNavigationBar];
    //    UITapGestureRecognizer *taoGest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGest)];
    //    [self.view addGestureRecognizer:taoGest];
    //点击事件
    
}
-(void)tapGest
{
    [_popView hidePop];
}
- (void)initNavigationBar{
    //顶端背景
    UIImageView *topBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Unico/common_navi_transparentblack.png"]];
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
    
    //    tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyleAction:@"Unico/icon_report2" rect:CGRectMake(self.view.frame.size.width-44, 20,88/2,88/2) target:self action:@selector(showPopView)];//clickShare:
    //    [topBgView addSubview:tempView];
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn addTarget:self action:@selector(showPopView) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setFrame:CGRectMake(self.view.frame.size.width-44, 20,88/2,88/2)];
    [shareBtn setImage:[UIImage imageNamed:@"Unico/icon_report2"] forState:UIControlStateNormal];
    [topBgView addSubview:shareBtn];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    likeBtn = leftButton;
    [leftButton setFrame:CGRectMake(_shoppingBagButton.frame.origin.x-44, _shoppingBagButton.frame.origin.y, 44, 44)];

    [leftButton setImage:[UIImage imageNamed:@"Unico/like_big"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(likeContent:) forControlEvents:UIControlEventTouchUpInside];
    [topBgView addSubview:leftButton];
    [self.view addSubview:topBgView];
}

-(void)collocationPopViewSelected:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"分享");
            [self clickShare:nil];
            
        }
            break;
        case 1:
        {
            NSLog(@"举报");
            if (![BaseViewController pushLoginViewController]) {
                return;
            }
            NSString *title = @"举报不良内容";
            NSString *userIdStr =[NSString stringWithFormat:@"%@",listDict[@"user_id"]];
            if ([sns.ldap_uid isEqualToString:userIdStr]) {
                title = @"删除我的发布";
            }
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
        NSString *userIdStr =[NSString stringWithFormat:@"%@",listDict[@"user_id"]];
        NSString *collId = [NSString stringWithFormat:@"%ld",(long)self.collocationId];
        
        
        if (![sns.ldap_uid isEqualToString:userIdStr]) {
            [Toast makeToastActivity:@""];
            [[SDataCache sharedInstance] addMyComplaintsInfoWithCollocationId:collId complete:^(NSArray *data, NSError *error) {
                [Toast hideToastActivity];
//                if (error) {
//                    [Toast makeToast:@"举报失败!"];
//                    return ;
//                }
//                [Toast makeToast:@"举报成功!"];
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
        }else{
            
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示"
                                                           message:@"是否确定删除搭配？"
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定",nil];
            alert.tag=10000;
            [alert show];
        }
    }
}
-(void)hiddenShowAlertView
{
    [showAlertView dismissWithClickedButtonIndex:0 animated:NO];//important
}
- (void)getData{
    if (_mb_collocationId)
    {
        [self requestCollocationIdForMBCollocationID];
    }
    else
    {
        [self getCollocationInfo];
    }
    self.lastPageIndex = 0;
    self.goodsList = [NSMutableArray new];
    
    [self getCollocationList:NO];
}

- (void)requestCarCount{
    if(!sns.ldap_uid){
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
            self.shoppingBagButton.titleLabel.hidden=NO;
            [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]] forState:UIControlStateNormal];
        }
        else {
            self.shoppingBagButton.titleLabel.hidden=YES;
            [self.shoppingBagButton setTitle:@"" forState:UIControlStateNormal];
        }
    } failed:^(NSError *error) {
        
    }];
}
//底部 喜欢 联系客服 搭配购物
-(void)layoutUI{
    [super layoutUI];
    //    sale_all_banner@2x
    //    dpg_db_gray@2x
    if (_isErrorRequest) {
        self.collectionView.userInteractionEnabled = NO;
    }
    
    //[self.collectionView addFooterWithTarget:self action:@selector(requestAddData)];
    UIImageView *imageView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/dpg_db.png" rect:CGRectMake(0, UI_SCREEN_HEIGHT - 88/2, UI_SCREEN_WIDTH, 88/2)];
    _collocationBuyImageView = imageView;
    imageView.userInteractionEnabled = YES;
    CGRect rect = CGRectMake(UI_SCREEN_WIDTH/2-117/2/2, imageView.height/4 , 117/2, 38/2);
    UIButton *centerButton = [[UIButton alloc]initWithFrame:rect];
    if (idList.count <= 0) {
        imageView.image = [UIImage imageNamed:@"Unico/dpg_db_gray.png"];
        centerButton.userInteractionEnabled = YES;
    }
    _collocationBuyButton = centerButton;
    [centerButton setImage:[UIImage imageNamed:@"Unico/dpg_b"] forState:UIControlStateNormal];
    [centerButton addTarget:self action:@selector(onCollocationBuy:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:centerButton];
    //按钮大小
    float tempfloat = UI_SCREEN_WIDTH/3;
    CGRect frame = CGRectMake(50/2, 12, tempfloat, 20);
    
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:frame];
    [leftButton setTitle:@"喜欢" forState:UIControlStateNormal];
//    likeBtn = leftButton;
    //判断该搭配是否喜欢
    if (listDict[@"is_love"]) {
        BOOL isLike = [listDict[@"is_love"] boolValue];
        [self setLikeBtnStatus:isLike];
    }
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
    [rightButton addTarget:self action:@selector(contactKF:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setOrigin:CGPointMake(UI_SCREEN_WIDTH-tempfloat+tempfloat/2 - rightButton.width/2, rightButton.frame.origin.y)];
    [imageView addSubview:rightButton];
    
    //[self.view addSubview:imageView];
}


//显示无数据界面
-(void)layoutNoneDataView
{
    CGFloat originY = self.navigationController.navigationBar.size.height+20;
    CGRect  noneDataRect = CGRectMake(0, originY, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-originY);
    if (!noneDataView) {
        noneDataView = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:noneDataRect WithImage:NONE_DATA_ITEM andImgSize:CGSizeMake(52, 52) andTipString:@"未发现搭配详情" font:FONT_SIZE(18) textColor:[Utils HexColor:0x999999 Alpha:1.0] andInterval:10.0];
    }
    
    [self.view insertSubview:noneDataView belowSubview:self.navigationController.navigationBar];
}

-(void)likeContent:(id)selector{
    if (![BaseViewController pushLoginViewController]){
        return;
    }
    
    BOOL isLike = [listDict[@"is_love"] boolValue];
    //喜欢
    if (!isLike) {
        [SDATACACHE_INSTANCE likeCollocation:self.collocationId complete:^(NSArray *data) {
            [self setLikeBtnStatus:YES];
            listDict[@"is_love"] = @(1);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"likeRefreshTableView" object:nil];
            
            NSDictionary *mydic = @{@"head_img":sns.myStaffCard.photo_path_big,
                                    @"nick_name":sns.myStaffCard.nick_name,
                                    @"user_id":sns.ldap_uid};
            [likeUserAry addObject:mydic];
            NSLog(@"喜欢");
            NSString *likeCount = [NSString stringWithFormat:@"%@",listDict[@"like_count"]];
            int likeC= [likeCount intValue]+1;
            listDict[@"like_user_list"]=likeUserAry;
            listDict[@"like_count"]=[NSString stringWithFormat:@"%d",likeC];
            _likeLabel.text=[NSString stringWithFormat:@"喜欢(%d)",likeC];
            likerScroll.hidden=NO;
            NSArray *views=[likerScroll subviews];
            for (UIView *view in views) {
                [view removeFromSuperview];
            }
            UIImageView *tempView;
            likerScroll.contentSize = CGSizeMake(10+(88/2+10)*likeUserAry.count, 0);
            for (int i=0; i<[likeUserAry count]; i++) {
                tempView = [SUTIL createRoundUIImageViewByUrl:likeUserAry[i][@"head_img"] rect:CGRectMake(10+i*(88/2+10), likerScroll.frame.size.height/2-88/2/2, 88/2, 88/2) cornerRadius:88/2/2];
                tempView.tag=BASE_LIKE_USER_INDEX+i;
                
                [SUTIL addViewAction:tempView target:self action:@selector(onSelectLikeUser:)];
                [likerScroll addSubview:tempView];
                
            }

        }];
    }//取消喜欢
    else{
        [SDATACACHE_INSTANCE delLikeCollocation:self.collocationId complete:^(NSArray *data) {
            [self setLikeBtnStatus:NO];
            listDict[@"is_love"] = @(0);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"likeRefreshTableView" object:nil];
            
            for (int a=0; a<[likeUserAry count]; a++) {
                NSString*user_id = [NSString stringWithFormat:@"%@",likeUserAry[a][@"user_id"]];
                if ([user_id isEqual:sns.ldap_uid]) {
                    [likeUserAry removeObjectAtIndex:a];
                    break;
                }
            }
            NSLog(@"取消喜欢");
            NSString *likeCount = [NSString stringWithFormat:@"%@",listDict[@"like_count"]];
            int likeC= [likeCount intValue]-1;
            listDict[@"like_user_list"]=likeUserAry;
            listDict[@"like_count"]=[NSString stringWithFormat:@"%d",likeC];
            _likeLabel.text=[NSString stringWithFormat:@"喜欢(%d)",likeC];
            NSArray *views=[likerScroll subviews];
            for (UIView *view in views) {
                [view removeFromSuperview];
            }
            UIImageView *tempView;
            likerScroll.contentSize = CGSizeMake(10+(88/2+10)*likeUserAry.count, 0);
            for (int i=0; i<[likeUserAry count]; i++) {
                tempView = [SUTIL createRoundUIImageViewByUrl:likeUserAry[i][@"head_img"] rect:CGRectMake(10+i*(88/2+10), likerScroll.frame.size.height/2-88/2/2, 88/2, 88/2) cornerRadius:88/2/2];
                tempView.tag=BASE_LIKE_USER_INDEX+i;
                
                [SUTIL addViewAction:tempView target:self action:@selector(onSelectLikeUser:)];
                [likerScroll addSubview:tempView];
                
            }

        }];
    }
    
}
-(void)contactKF:(id)selector{
    NSLog(@"联系客服");
    [SUTIL showService];
}

-(void)getOtherInfo:(NSString*) userIdStr{
    // 这个最好可以封装到请求函数中。
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (!userIdStr) {
        userIdStr = @"";
    }
    NSString *userId = sns.ldap_uid;
    if (!userId) {
        userId = userIdStr; // 未登录也允许进入。只是没有关注关系，但是必须有这个ID
    }
    NSDictionary *params = @{@"UserId": userIdStr, @"LoginUserId": userId};
    
    [HttpRequest collocationGetRequestPath:nil methodName:@"AnotherStore" params:params success:^(NSDictionary *dict) {
        NSLog(@"。。。。。。one two  three");
        
        //        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (!dict) {
            [self layoutNoneDataView];
            return;
        }
        userInfoDict = (NSDictionary*)dict[@"results"][0];
        [self dealUserInfo];
        
    } failed:^(NSError *error) {
        
        NSLog(@"他人店铺错误----------%@", error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)requestCollocationIdForMBCollocationID{
    NSDictionary *params = @{
                             @"m":@"Collocation",
                             @"a":@"getCollocationDetails",
                             @"token": @"",
                             @"mbfun_id": _mb_collocationId
                             };
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id object) {
        ifColocationDone = YES;
        if ([object[@"status"] intValue] != 1){
            [Toast makeToast:@"请求发生错误！" duration:1.5 position:@"center"];
            listDict = [NSMutableDictionary dictionary];
            _isErrorRequest = YES;
            headContent.userInteractionEnabled = NO;
        }else{
            if ([object[@"data"] count] <= 0) {
                [self layoutNoneDataView];
                return ;
            }
            self.collocationId = object[@"data"][@"id"] ;
            listDict = [NSMutableDictionary dictionaryWithDictionary:object[@"data"]];
        }
        [self dealCollocationData];
        
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
    }];
}

-(void)getCollocationInfo{
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[SDataCache sharedInstance] getCollocationInfo:self.collocationId complete:^(NSArray *data) {
        //        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        ifColocationDone = YES;
        NSLog(@"。。。。。走不走");
        if (data.count <= 0) {
            [self layoutNoneDataView];
            return ;
        }
        listDict = [NSMutableDictionary dictionaryWithDictionary:((NSDictionary*)data)];
        if (listDict[@"mbfun_id"] && [listDict[@"mbfun_id"] intValue] > 0) {
            self.mb_collocationId = listDict[@"mbfun_id"];
        }
        NSLog(@"%@",listDict);
        
        //[self layoutUI];
        //        NSString *userIdStr = listDict[@"user_id"];
        //TODO：
        [self dealCollocationData];
        
        [self.collectionView reloadData];
    }];
}

-(void) getCollocationList:(BOOL)isScrollUpdate
{
    self.collectionView.layer.borderColor = [UIColor redColor].CGColor;
    self.collectionView.layer.borderWidth = 3;
    
    NSDictionary *param = @{
                            @"cid":_collocationId,
                            @"page":@(self.lastPageIndex)
                            };
    [[SDataCache sharedInstance] get:@"Collocation" action:@"getCollocationListForDetails" param:param success:^(AFHTTPRequestOperation *operation, id object)
     {
         NSArray *data = object[@"data"];
         isScrollLoading = NO;
         ifColocationListDone = YES;
         if (data.count <= 0) {
             [self layoutNoneDataView ];
             return ;
         }
         [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
          {
              LNGood *goods = [LNGood goodWithDict:obj];
              [self.goodsList addObject:goods];
          }];
         self.lastPageIndex++;
         if (isScrollUpdate)
         {
             [self.collectionView reloadData];
         }
         else
         {
             [self dealCollocationData];
         }
     } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self layoutNoneDataView ];
     }];
    
    //
    //    [[SDataCache sharedInstance] getCollocationListForDetails:self.lastPageIndex complete:^(NSArray *data) {
    //
    //
    //    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LNGood *goodsModel = self.goodsList[indexPath.row];
    UICollectionViewCell *cell;
    if ([goodsModel.show_type boolValue])
    {
        SWaterAdvertCollectionViewCell *advertCell = [collectionView dequeueReusableCellWithReuseIdentifier:waterAdvertCellIdentifier forIndexPath:indexPath];
        advertCell.contentGoodsModel = goodsModel;
        cell = advertCell;
    }
    else
    {
        SWaterCollectionViewCell *waterCell = [collectionView dequeueReusableCellWithReuseIdentifier:waterCellIdentifier forIndexPath:indexPath];
        waterCell.contentGoodsModel = goodsModel;
        cell = waterCell;
    }
    // 创建可重用的cell
    
    cell.layer.borderColor = [UIColor redColor].CGColor;
    cell.layer.borderWidth = 3;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"numberOfItemsInSection self.collectionView.collectionViewLayout = %@", self.collectionView.collectionViewLayout);
    
    return 0;//self.goodsList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    NSLog(@"referenceSizeForHeaderInSection");
    return CGSizeMake(100, 820);
}

extern NSString *const WaterFallSectionHeader;
/// A supplementary view that identifies the footer for a given section.
extern NSString *const WaterFallSectionFooter;


-(void)dealCollocationData{
    if ([self judgeRequestDone]) {
        if ((!listDict ) || (!self.goodsList || self.goodsList.count <= 0)) {
            [self layoutNoneDataView];
            return;
        }else{
            [self layoutUI];
        }
    }
    
}
-(BOOL)judgeRequestDone
{
    if (ifColocationListDone&&ifColocationDone) {
        return YES;
    }
    else return NO;
    
}



-(void)setLikeBtnStatus:(BOOL) isLike{
    if (isLike) {
        [likeBtn setImage: [UIImage imageNamed:@"Unico/like_big2"] forState:UIControlStateNormal];
    }else{
        [likeBtn setImage: [UIImage imageNamed:@"Unico/like_big"] forState:UIControlStateNormal];
    }
    
}

-(void)dealUserInfo{
    
    NSDictionary* tempDic = userInfoDict[@"userInfo"];
    NSString *tempStr = tempDic[@"headPortrait"];
    UIImageView *tempView;
    UILabel *tempLabel;
    float width = 0;
    float height = 0;
    if (!tempStr) {
        tempStr = DEFAULT_HEADIMG;
    }
    //头像
    //tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic1"]];
    tempView = [UIImageView new];
    [tempView sd_setImageWithURL:[NSURL URLWithString:tempStr]];
    tempView.frame = CGRectMake(10,24/2,  44, 44);
    tempView.layer.cornerRadius = tempView.frame.size.height/2;
    tempView.clipsToBounds = YES;
    [tempView setUserInteractionEnabled:YES];
    UITapGestureRecognizer * designerHeadTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(designerHeadTaped:)];
    [tempView addGestureRecognizer:designerHeadTap];
    [designerBg addSubview:tempView];
    UIImageView *vImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"v"]];
    vImage.frame = CGRectMake(tempView.frame.origin.x+tempView.width-AUTO_SIZE(22/2),tempView.frame.origin.y +tempView.height - AUTO_SIZE(22/2),  AUTO_SIZE(22/2), AUTO_SIZE(22/2));
    //[tempView addSubview:vImage];
    [designerBg addSubview:vImage];
    
    //designerBg.layer.borderColor = [UIColor redColor].CGColor;
    //designerBg.layer.borderWidth = 3;
    
    //姓名
    tempStr = tempDic[@"nickName"];
    if (!tempStr) {
        tempStr = @"　";
    }
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:tempStr fontStyle:FONT_SIZE(12) color:nil rect:CGRectMake(126/2,44/2, 0, 0) isFitWidth:YES isAlignLeft:YES];
    
    [designerBg addSubview:tempLabel];
    //地点暂时读取不到
    //    tempStr = tempDic[@"address"];
    tempStr = @"未知";
    if (!tempStr) {
        tempStr = @"　";
    }
    tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"ico_shipaddress" rect:CGRectMake(126/2,44/2+tempLabel.height+10/2, 25/2,25/2)];
    [designerBg addSubview:tempView];
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:tempStr fontStyle:FONT_SIZE(10) color:UIColorFromRGB(0xc4c4c4) rect:CGRectMake(126/2+25/2,44/2+tempLabel.height+10/2, 0, 0) isFitWidth:YES isAlignLeft:YES];
    [designerBg addSubview:tempLabel];
    //粉丝
    NSString *number = [NSString stringWithFormat:@"%@",userInfoDict[@"concernedCount"]];
    tempStr = [NSString stringWithFormat:@"粉丝 %@", [Utils getSNSInteger:number]];
    
    
    
    tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:tempStr fontStyle:FONT_SIZE(10) color:UIColorFromRGB(0xc4c4c4) rect:CGRectMake(tempLabel.frame.origin.x+tempLabel.frame.size.width+10,44/2+tempLabel.height+10/2+2.5, 0, 0) isFitWidth:YES isAlignLeft:YES];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:tempStr];
    //设置：在0-3个单位长度内的内容显示成红色
    [str addAttribute:NSForegroundColorAttributeName value:[Utils HexColor:0xfedc32 Alpha:1] range:NSMakeRange(0, 3)];
    //    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:15.0] range:NSMakeRange(0, 3)];
    tempLabel.attributedText = str;
    [designerBg addSubview:tempLabel];
    
    
    tempStr = tempDic[@"userSignature"];
    if (tempStr && ![tempStr isEqual: @""]) {
        
        tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"quotes_left" rect:CGRectMake(20/2, designerBg.height - 24/2-tempLabel.height/2, 25/2, 22/2)];
        [designerBg addSubview:tempView];
        //个性签名
        
        if (!tempStr) {
            tempStr = @"　";
        }
        tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle: tempStr fontStyle:nil color:nil rect:CGRectMake(10/2+tempView.frame.origin.x+tempView.width,designerBg.height, 0, 0) isFitWidth:YES isAlignLeft:YES];
        [tempLabel setOrigin:CGPointMake(tempLabel.frame.origin.x, designerBg.height - 24/2-tempLabel.height/2)];
        [designerBg addSubview:tempLabel];
        tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"quotes_right" rect:CGRectMake(tempLabel.frame.origin.x+tempLabel.width +10/2, designerBg.height - 24/2-tempLabel.height/2, 25/2, 22/2)];
        [designerBg addSubview:tempView];
    }
    isLove = [userInfoDict[@"isConcerned"]integerValue];
    if (isLove == 0) {
        tempStr = @"Unico/add_gz";
        width = 141/2;
        height = 56/2;
    }else{
        tempStr = @"Unico/ygz";
        //未登录所有的都是未关注
        if (sns.ldap_uid.length==0){
            
            tempStr = @"Unico/add_gz";
        }
        width = 141/2;
        height = 56/2;
    }
    //当设计师不是自己的时候才可以关注
    if (![sns.ldap_uid  isEqualToString: userInfoDict[@"userInfo"][@"userId"]]) {
        
        //关注图像
        concernImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:tempStr]];
        [concernImgView setUserInteractionEnabled:YES];
        concernImgView.frame =CGRectMake(designerBg.frame.size.width -AUTO_SIZE(width+10),designerBg.frame.size.height/2-AUTO_SIZE(height/2),  AUTO_SIZE(width), AUTO_SIZE(height));
        UITapGestureRecognizer * attendTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(attendClicked:)];
        [concernImgView addGestureRecognizer:attendTap];
        [designerBg addSubview:concernImgView];
    }
    else
    {
        concernImgView.hidden=YES;
        [concernImgView removeFromSuperview];
        
    }
}

-(SCVideoPlayerView*)getPlayerView{
    if (!playerView) {
        SCPlayer *player = [SCPlayer player];
        player.loopEnabled = YES;
        player.muted = YES;
        // 详情暂时关声音
        playerView = [[SCVideoPlayerView alloc] initWithPlayer:player];
        playerView.userInteractionEnabled = NO;
    }
    return playerView;
}

-(void)switchTagLayer{
    tagView.hidden = !tagView.hidden;
    //隐藏图标
    [_popView hidePop];
}

-(void) updateHeaderView:(UICollectionReusableView*) headerView
{
    NSInteger offset = 0;
    UILabel *tempLabel;
    NSString *tempStr;
    float tempfloat = 0;
    UIColor *tempColor;
    UIView *tempUI;
    
    tempStr = listDict[@"img"];
    //大图的大小
    
    UIImageView *tempView = [UIImageView new];
    tempView.userInteractionEnabled = YES;
    [tempView setOrigin:CGPointMake(0, 0)];
    
    float width = [listDict[@"img_width"] floatValue];
    float height = [listDict[@"img_height"] floatValue];
    CGSize tempSize = CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_WIDTH/width*height);
    // 这里是请求符合屏幕宽度的图片，避免不清晰，并且减少非必要流量
    
    // Video
    if( [listDict[@"video_url"] length] > 0)
    {
        SCVideoPlayerView *view = [self getPlayerView];
        [view setSize:tempSize];
        
        [view.player setItemByStringPath:listDict[@"video_url"]];
        [view.player play];
    }
    else
    {
        // 注意：如果是视频图片，不需要加参数，否则不能显示
        // 所以在此判断。
        tempStr = [NSString stringWithFormat:@"%@?imageView2/1/w/%d/h/%d",tempStr,(int)width,(int)height];
        
        // 这里用水印合成，图可以不用再加载stiker层，但是就不能拉尺寸了。
        // 有时候水印渲染有问题，暂时不用
        //        tempStr = [SUTIL getWatermarkImageURL:listDict];
    }
    
    [tempView setContentMode:UIViewContentModeScaleToFill];
//    [tempView sd_setImageWithURL:[NSURL URLWithString:tempStr]];
    [tempView sd_setImageWithURL:[NSURL URLWithString:tempStr] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_BIGLOADING]];
    
    showBigImgView = tempView;
    
    [tempView setSize:tempSize];
    [headerView addSubview:tempView];
    
    
    
    //    UITapGestureRecognizer *tapgest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGest)];
    //    [tempView addGestureRecognizer:tapgest];
    
    
    // 注意先后顺序
    if (playerView) {
        playerView.bounds = tempView.bounds;
        [tempView addSubview:playerView];
    }
    
    // Sticker
    if ([listDict[@"stick_img_url"] length] > 0 )
    {
        UIImageView *p_stickerView = [UIImageView new];
        [p_stickerView sd_setImageWithURL:[NSURL URLWithString:listDict[@"stick_img_url"]]];
        [p_stickerView setSize:tempSize];
        [tempView addSubview:p_stickerView];
        //        [self bringSubviewToFront:p_stickerView];
        
    }
    
#pragma mark - 处理Tag
    UIView *tagSwitcher = [UIView new];
    tagSwitcher.size = tempSize;
    [tempView addSubview:tagSwitcher];
    // 点击切换标签显示的事件加这里？
    [SUTIL addViewAction:tagSwitcher target:self action:@selector(switchTagLayer)];
    // 添加一个tag图层，便于处理隐藏
    tagView = [UIImageView new];
    tagView.userInteractionEnabled = YES;
    [tagView setSize:tempSize];
    [tempView addSubview:tagView];
    // 点击自己隐藏自己
    [SUTIL addViewAction:tagView target:self action:@selector(switchTagLayer)];
    
    _tagArray = [SCollocationGoodsTagModel modelArrayForDataArray:[SUTIL getArray:listDict[@"tag_list"]]];
    //判断商品数量
    NSString *topicInfoStr = @"";
    for (int i = 0; i < _tagArray.count; i++) {
        SCollocationGoodsTagModel *model = _tagArray[i];
        
        /*UIImageView *tagImageView = [SUTIL addTag:model.text fontStyle:fontStyle imageView:tagView point:CGPointMake(model.x.floatValue, model.y.floatValue)];
        tagImageView.tag = i + 160;
        UITapGestureRecognizer *tagTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tagTouchAction:)];
        tagImageView.userInteractionEnabled = YES;
        [tagImageView addGestureRecognizer:tagTap];*/
        
        
        UIView *stickerView = [[SUtilityTool shared] addTagWithDict:model.dict inView:tagView];
        stickerView.tag = i + 160;
        UITapGestureRecognizer *tagTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tagTouchAction:)];
        stickerView.userInteractionEnabled = YES;
        [stickerView addGestureRecognizer:tagTap];

        
        if (model.attributes.type.intValue == 3) {
            if ([topicInfoStr length] > 0) {
                topicInfoStr = [topicInfoStr stringByAppendingFormat:@",%@",model.text];
            }else{
                topicInfoStr = model.text;
            }
            
        }
        // 判断是否是商品，如果是则排列商品列表。
    }
    NSInteger itemNum = 0;
    tempStr = listDict[@"item_str"];
    NSArray *itemAry = [tempStr componentsSeparatedByString:@"_"];
    idList = [NSMutableArray array];
    for (int i=0;i < itemAry.count;i++) {
        if (![itemAry[i] isEqualToString:@""]) {
            NSNumber *num = [NSNumber numberWithInt:[itemAry[i] intValue]];
            [idList addObject:num];
        }
        
    }
    itemNum = idList.count;
    offset += tempView.height;
    
    
    //设计师介绍
    designerBg = [UIView new];
    designerBg.frame = CGRectMake(0, offset, self.view.frame.size.width, 90);
    designerBg.backgroundColor = [UIColor whiteColor];
    [headerView addSubview: designerBg];
    offset += designerBg.frame.size.height+1;
    
    
  //小三角
//    tempUI = [SUTIL getArrowLineUIView];
//    [tempUI setOrigin:CGPointMake(0, offset)];
    
    NSInteger bgOffset = 0;
    
    UIView *bgContent;

        bgContent = [SUTIL createUIViewByHeight:50 coordY:offset];
        
        [headerView addSubview:bgContent];//chencheng
    bgContent.backgroundColor = [UIColor whiteColor];

    //描述
    tempStr=  listDict[@"content_info"];
    if (tempStr.length!=0||![[Utils getSNSString:tempStr] isEqualToString:@""]) {
        
        tempLabel = [SUTIL createUILabelByStyleFitHeight:tempStr fontStyle:FONT_SIZE(13) color:UIColorFromRGB(0x3b3b3b) width:(UI_SCREEN_WIDTH - 30-20/2) point:CGPointMake(30/2+20/2+7/2, bgOffset)];
        [bgContent addSubview:tempLabel];
        [tempLabel setFrame:CGRectMake(tempLabel.frame.origin.x, tempLabel.frame.origin.y, tempLabel.frame.size.width, tempLabel.frame.size.height+15)];
//        [tempLabel setBackgroundColor:[UIColor blueColor]];
        tempView = [SUTIL createUIImageViewByStyle:@"Unico/record_progress_bar" rect:CGRectMake(20/2, tempLabel.frame.origin.y, 7/2, tempLabel.height)];
        [bgContent addSubview:tempView];
        bgOffset += tempLabel.height;
        bgOffset += 15;
        bgOffset += 48/2;
    }
 
 

//    [bgContent setBackgroundColor:[UIColor orangeColor]];
    //话题
    tempStr = listDict[@"tab_str"];

//    if (![[Utils getSNSString:tempStr] isEqualToString:@""]) {
    
        tempfloat = 0;
        UIColor *tabfontColor;
        UIFont *tabfontStyle;
        NSArray *aArray = [topicInfoStr length] > 0 ? [NSArray arrayWithArray:[topicInfoStr componentsSeparatedByString:@","]] : nil;
        NSInteger count = aArray.count;
        NSMutableArray *topicAry = [NSMutableArray arrayWithArray:aArray];
        [topicAry addObjectsFromArray:[tempStr componentsSeparatedByString: @","]];
        [topicAry removeObject:@""];
        if (topicAry.count > 0||![[Utils getSNSString:tempStr] isEqualToString:@""]) {
            tempView = [SUTIL createUIImageViewByStyle:@"biaoqian" rect:CGRectMake(20/2, bgOffset+5, 40/2, 40/2)];
            [bgContent addSubview:tempView];
            UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(tempView.width + 20, bgOffset, UI_SCREEN_WIDTH, 30)];
            [scroll setBackgroundColor:[UIColor whiteColor]];
            [bgContent addSubview:scroll];
           
            for (int i =0; i<topicAry.count; i++) {
                BOOL isTopic = NO;
                tempStr = topicAry[i];
                tempColor = UIColorFromRGB(0xc4c4c4);
                if(i < count && ![tempStr isEqual:@""]){
                    //                tempStr = OTHER_TO_STRING(@"#%@", tempStr);
                    tempColor = COLOR_C1;
                    tabfontColor = COLOR_C2;
                    tabfontStyle = FONT_T6;
                    isTopic = YES;
                    
                }else{
                    tempColor = COLOR_C6;
                    tabfontColor = COLOR_C3;
                    tabfontStyle = FONT_t6;
                }
                
                tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelMiddleText:tempStr fontStyle:tabfontStyle color:tabfontColor bgColor:tempColor rect:CGRectMake(tempfloat, 5, 0, 40/2)];
                tempLabel.layer.cornerRadius = 3;
                tempLabel.clipsToBounds = YES;
                
                if (isTopic) {
                    [tempLabel setTag:1010];
                }
                [scroll addSubview:tempLabel];
                [tempLabel setUserInteractionEnabled:YES];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIndexTag:)];
                [tempLabel addGestureRecognizer:tap];
                
                tempfloat += tempLabel.width + 18/2;
            }
        
            if (tempView.width + 20/2+20/2 +tempfloat > UI_SCREEN_WIDTH-10) {
                [scroll setContentSize:CGSizeMake(tempView.width + 20/2+20/2 +tempfloat + 10, 30)];
            }
            bgOffset += tempLabel.height;
            bgOffset += 26/2;
        }
//    }

    //自适应背景大小
    bgContent.frame = CGRectMake(0, bgContent.frame.origin.y, self.view.frame.size.width, bgOffset);
       offset += bgOffset;

    tempUI = [SUTIL getNormalLineByRect:CGRectMake(0, offset, UI_SCREEN_WIDTH, 1) color:UIColorFromRGB(0xc4c4c4)];
    [headerView addSubview:tempUI];
    offset += tempUI.height;
    
    
    
    //喜欢和评论View
    long likeNum = [listDict[@"like_count"]integerValue];
    UIView *likeAndCommentView = [SUTIL createUIViewByHeight:10 coordY:offset];
    
    UIView *likeBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, likeAndCommentView.width, 58)];
    likeBgView.backgroundColor = [UIColor whiteColor];
    [likeAndCommentView addSubview:likeBgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentAndLikeCellTapGesture:)];
    [likeBgView addGestureRecognizer:tap];
    
    likeAndCommentView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:likeAndCommentView];
    
    float likeCommentOffset = 20/2;
    tempStr = OTHER_TO_STRING(@"喜欢(%ld)", likeNum);
    tempLabel = [SUTIL createUILabelByStyle:tempStr fontStyle:nil color:nil rect:CGRectMake(20/2,likeCommentOffset, 0, 0) isFitWidth:YES isAlignLeft:YES];
     _likeLabel =tempLabel;
    [likeAndCommentView addSubview: tempLabel];
    likeCommentOffset += tempLabel.height;
    //箭头
    tempView = [SUTIL createUIImageViewByStyle:@"Unico/right_arrow" rect:CGRectMake(UI_SCREEN_WIDTH-14/2-20/2, tempLabel.frame.origin.y, 14/2, 28/2)];
    [likeAndCommentView addSubview:tempView];
    
    
    //点赞人头像
    //如果没有喜欢取消状态
    likeUserAry = [NSMutableArray arrayWithArray:((NSArray*)listDict[@"like_user_list"])];
    
    likerScroll = [SUTILITY_TOOL_INSTANCE createScrollView:self rect:CGRectMake(0, likeCommentOffset+2, self.view.frame.size.width, 88/2)];
    likerScroll.contentSize = CGSizeMake(10+(88/2+10)*2, 0);
    likerScroll.hidden=YES;
    [likeAndCommentView addSubview: likerScroll];
    tempUI = [SUTILITY_TOOL_INSTANCE getNormalLineBySize:UI_SCREEN_WIDTH height:1 color:UIColorFromRGB(0xc4c4c4)];
    [tempUI setOrigin:CGPointMake(0, likeCommentOffset+2+likerScroll.height)];
    [likeAndCommentView addSubview:tempUI];

    
    
    
    //喜欢头像
    if (likeNum != 0)
    {
        if (likeUserAry.count > 0)
        {
//            likerScroll = [SUTILITY_TOOL_INSTANCE createScrollView:self rect:CGRectMake(0, likeCommentOffset, self.view.frame.size.width, 88/2)];
            likerScroll.contentSize = CGSizeMake(10+(88/2+10)*likeUserAry.count, 0);
            likerScroll.hidden=NO;
            [likeAndCommentView addSubview: likerScroll];
            likeCommentOffset += likerScroll.height;

            for (int i = 0; i<[likeUserAry count]; i++)
            {
                tempView = [SUTIL createRoundUIImageViewByUrl:likeUserAry[i][@"head_img"] rect:CGRectMake(10+i*(88/2+10), likerScroll.frame.size.height/2-80/2/2, 80/2, 80/2) cornerRadius:80/2/2];
                //获取喜欢人的list的index
                tempView.tag = BASE_LIKE_USER_INDEX + i;
                [SUTIL addViewAction:tempView target:self action:@selector(onSelectLikeUser:)];
                [likerScroll addSubview:tempView];
                UIImageView *vipImg = [[UIImageView alloc] initWithFrame:CGRectMake(tempView.frame.origin.x+tempView.frame.size.width-10, tempView.frame.size.height+tempView.frame.origin.y-15, 13, 13)];
                vipImg.layer.cornerRadius=vipImg.frame.size.width/ 2;
                vipImg.layer.borderWidth = 1.0;
                vipImg.layer.borderColor = [UIColor whiteColor].CGColor;
                vipImg.layer.masksToBounds = YES;
                [likerScroll addSubview:vipImg];
                NSString *listHead_v_type = [NSString stringWithFormat:@"%@",likeUserAry[i][@"head_v_type"]];
                
                switch ([listHead_v_type integerValue]) {
                    case 0:
                    {
                        vipImg.hidden=YES;
                    }
                        break;
                    case 1:
                    {
                        vipImg.hidden=NO;
                        [vipImg setImage:[UIImage imageNamed:@"brandvip@2x"]];
                    }
                        break;
                    case 2:
                    {
                        [vipImg setImage:[UIImage imageNamed:@"peoplevip@2x"]];
                        vipImg.hidden=NO;
                    }
                        break;
                    default:
                        break;
                }
            }
            
        }
        tempUI = [SUTILITY_TOOL_INSTANCE getNormalLineBySize:UI_SCREEN_WIDTH height:1 color:UIColorFromRGB(0xc4c4c4)];
        [tempUI setOrigin:CGPointMake(0, likeCommentOffset+2)];
        [likeAndCommentView addSubview:tempUI];
        likeCommentOffset += 1;
    }
    //获取设计者信息
    NSString *userIdStr = listDict[@"user_id"];
    [self getOtherInfo:userIdStr];
    offset += designerBg.height;
    
    

    
    /*likeCommentOffset +=20/2;
     long commentNum = [listDict[@"comment_count"]integerValue];
     tempStr = OTHER_TO_STRING(@"评论(%ld)", commentNum);
     _commentCount = [NSMutableString stringWithFormat:@"%ld", commentNum];
     
     tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:tempStr fontStyle:nil color:nil rect:CGRectMake(20/2, likeCommentOffset,0, 0) isFitWidth:YES isAlignLeft:YES];
     _commentLabel = tempLabel;
     [likeAndCommentView addSubview:tempLabel];
     tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/right_arrow" rect:CGRectMake(UI_SCREEN_WIDTH-14/2-20/2, tempLabel.frame.origin.y, 14/2, 28/2)];
     //[likeAndCommentView addSubview:tempView];
     
     if (commentNum != 0) {
     int score = [listDict[@"comment_score"] intValue];
     [self calcTotalScoreInView:likeAndCommentView score:score count:(int)commentNum xPoint:tempLabel.frame.origin.x + tempLabel.frame.size.width+20/2 yPoint:tempLabel.frame.origin.y];
     }
     
     likeCommentOffset += tempLabel.height;
     likeCommentOffset += 30/2;
     tempUI = [SUTILITY_TOOL_INSTANCE getNormalLineBySize:UI_SCREEN_WIDTH height:1 color:UIColorFromRGB(0xc4c4c4)];
     [tempUI setOrigin:CGPointMake(0, likeCommentOffset -1)];
     [likeAndCommentView addSubview:tempUI];*/
    
    
    //加一个显示评论的表视图
    if (_noShoppingCommentsViewController != nil)
    {
        [_noShoppingCommentsViewController.view removeFromSuperview];
    }
    _noShoppingCommentsViewController = [[NoShoppingCommentsViewController alloc] initWithNibName:@"NoShoppingCommentsViewController" bundle:nil];
    
    
    _noShoppingCommentsViewController.collocationID = _collocationId;
    _noShoppingCommentsViewController.commentDetailCount = _commentCount;
    int k =20;
    if (likeNum!=0) {
        k=64;
    }
    _noShoppingCommentsViewController.view.frame = CGRectMake(0, likeCommentOffset-k, UI_SCREEN_WIDTH, 400);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _noShoppingCommentsViewController.view.frame = CGRectMake(0, likeCommentOffset-k, UI_SCREEN_WIDTH, 400);
        
        _noShoppingCommentsViewController.commentSendMessageTextFiled.delegate = self;
        
    });
    
    [likeAndCommentView insertSubview:_noShoppingCommentsViewController.view atIndex:0];
    likeCommentOffset += 400-k;
    
    [likeAndCommentView setSize:CGSizeMake(UI_SCREEN_WIDTH, likeCommentOffset)];
    offset += likeAndCommentView.height;
    
    
    self.headerViewHeight = offset-100;
}

- (void)calcTotalScoreInView:(UIView *)view score:(int)totalScore count:(int)amount xPoint:(CGFloat)xPoint yPoint:(CGFloat)yPoint
{
    int score = (float)totalScore/ amount * 2 / 1;
    int count = 0;
    for (int i = score; count < 5; count++){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint+count*29/2, yPoint, 29/2, 29/2)];
        NSString *imageNameString = @"";
        if (i > 1) {
            i -= 2;
            imageNameString = @"Unico/add1";
        }else if(i > 0){
            i --;
            imageNameString = @"Unico/add3";
        }else{
            imageNameString = @"Unico/add2";
        }
        imageView.image = [UIImage imageNamed:imageNameString];
        [view addSubview:imageView];
    }
}

-(void)onSelectBanner:(UITapGestureRecognizer*)recognizer{
    NSDictionary *tempDict = ((NSArray*)listDict[@"banner"][@"1006"])[0];
    [SUTIL jumpControllerWithContent:tempDict target:self];
}
-(void)onSelectLikeUser:(UITapGestureRecognizer*)recognizer{
    NSInteger userIndex = recognizer.view.tag - BASE_LIKE_USER_INDEX;
    if (userIndex < 0 || userIndex >= likeUserAry.count) {
        NSLog(@"索引太大");
        return;
    }
    NSString *userIdStr = likeUserAry[userIndex][@"user_id"];
    SMineViewController *vc = [[SMineViewController alloc]init];
    vc.person_id = userIdStr;
    [self.navigationController pushViewController:vc animated:YES];
}

////创建喜欢人的scrollview列表
//-(void)createScrollViewLikeUser{
//    UIImageView *tempView;
//    for (int i = 0; i<[likeUserAry count]; i++) {
//        tempView = [SUTIL createRoundUIImageViewByUrl:likeUserAry[i][@"head_img"] rect:CGRectMake(10+i*(88/2+10), likeUserScrollView.frame.size.height/2-88/2/2, 88/2, 88/2) cornerRadius:88/2/2];
//        //获取喜欢人的list的index
//        tempView.tag = BASE_LIKE_USER_INDEX + i;
//        [SUTIL addViewAction:tempView target:self action:@selector(onSelectLikeUser:)];
//        [likeUserScrollView addSubview:tempView];
//    }
//
//}

-(void)updateItemShowView:(NSArray*)productList{
    //    int stock = 0;
    //    for (NSDictionary *dict in productList) {
    //        if ([dict[@"lisT_QTY"] intValue] <= 0 && [dict[@"status"] intValue] == 2) {
    //            stock ++;
    //        }
    //    }
    int total = 0;
    for (int i=0; i<skuList.count; i++) {
        total += [skuList[i] intValue];
    }
    
    if (total <= 0) {
        _collocationBuyView.layer.masksToBounds = YES;
        NSString *showStateImageName = @"Unico/sale_all_banner";
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:_collocationBuyView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:showStateImageName];
        _collocationBuyView.userInteractionEnabled = NO;
        [_collocationBuyView addSubview:imageView];
        _collocationBuyImageView.image = [UIImage imageNamed:@"Unico/dpg_db_gray.png"];
        [_collocationBuyButton setImage:[UIImage imageNamed:@"Unico/sale_all"] forState:UIControlStateNormal];
        _collocationBuyButton.userInteractionEnabled = NO;
    }
    
    NSInteger lineLen = 0;
    NSInteger lineX = 0;
    NSInteger lineY = 0;
    float nowPrice = 0;
    float original = 0;
    UIView *tempContent;
    UIImageView *tempView;
    NSString *tempStr;
    NSString *tempStr2;
    UILabel *tempLabel;
    NSInteger itemId;
    float bgOffset = 0;
    for (int i = 0 ; i<[productList count]; i++) {
        tempContent = [UIView new];
        itemId = [productList[i][@"lM_PROD_CLS_ID"] intValue];
        tempContent.tag = BASE_BTN_TAG+itemId;
        [SUTILITY_TOOL_INSTANCE addViewAction:tempContent target:self action:@selector(selectItem:)];
        
        tempContent.frame = CGRectMake(10,bgOffset, self.view.frame.size.width, AUTO_SIZE(115/2));
        [p_itemShowView addSubview:tempContent];
        tempStr = productList[i][@"coloR_FILE_PATH"];
        tempView = [UIImageView new];
        [tempView sd_setImageWithURL:[NSURL URLWithString:tempStr]];
        tempView.contentMode = UIViewContentModeScaleAspectFit;
        tempView.frame = CGRectMake(0,1, AUTO_SIZE(111/2), AUTO_SIZE(111/2));
        [tempContent addSubview:tempView];
        if (i == ([productList count] -1) ){
            lineLen = self.view.frame.size.width;
            lineX = 0;
            lineY = 1+AUTO_SIZE(111/2+ 10);
            bgOffset += 10;
        }else{
            lineLen = self.view.frame.size.width - AUTO_SIZE(111/2+10);
            lineX = AUTO_SIZE(111/2+10);
            lineY = 1+AUTO_SIZE(111/2);
        }
        
        tempView = [[UIImageView alloc]initWithImage: [SUTILITY_TOOL_INSTANCE getNormalLine]];
        tempView.alpha = 1;
        tempView.userInteractionEnabled=YES;
        
        tempView.frame = CGRectMake(lineX,lineY,lineLen, 1);
        [tempContent addSubview:tempView];
        
        
        tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"right_arrow" rect: CGRectMake(UI_SCREEN_WIDTH -14/2 -20,tempContent.height/2-28/2/2,14/2, 28/2)];
        tempContent.userInteractionEnabled=YES;
        [tempContent addSubview:tempView];
        
        NSString *saleprice=OTHER_TO_STRING(@"%0.2f", [productList[i][@"salE_PRICE"]floatValue]);
        NSString *price =OTHER_TO_STRING(@"%0.2f", [productList[i][@"price"]floatValue]);
        
        tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:productList[i][@"proD_NAME"] fontStyle:nil color:nil rect:CGRectMake(111/2+10,tempContent.frame.size.height/2-20, 0,0) isFitWidth:YES isAlignLeft:YES];
        [tempContent addSubview:tempLabel];
        tempStr = @"¥";
        tempStr2 = OTHER_TO_STRING(@"%0.2f", [productList[i][@"salE_PRICE"]floatValue]);
        tempStr = [tempStr stringByAppendingString:tempStr2];
        tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:tempStr fontStyle:nil color:[UIColor blackColor] rect:CGRectMake(AUTO_SIZE(111/2+10),tempContent.frame.size.height/2, 60, 20) isFitWidth:YES isAlignLeft:YES];
        [tempContent addSubview:tempLabel];
        if (![saleprice isEqualToString:price]) {
            tempStr = @"¥";
            tempStr2 = OTHER_TO_STRING(@"%0.2f", [productList[i][@"price"]floatValue]);
            tempStr = [tempStr stringByAppendingString:tempStr2];
            tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelMiddleLine:tempStr fontStyle:nil color:UIColorFromRGB(0xc4c4c4) rect: CGRectMake(AUTO_SIZE(111/2+10+60+20),tempContent.frame.size.height/2, 0, 20) isFitWidth:YES isAlignLeft:YES];
            [tempContent addSubview:tempLabel];
            //划线
            UIView * crossView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(tempLabel.frame), CGRectGetMidY(tempLabel.frame), tempLabel.size.width, 1.0)];
            crossView.backgroundColor = UIColorFromRGB(0x999999);
            [tempContent addSubview:crossView];
        }
        
        original  += [productList[i][@"price"]floatValue];
        nowPrice  += [productList[i][@"salE_PRICE"]floatValue];
        bgOffset+= 115/2;
    }
#pragma mark 优惠价格最优选择
    if (_promPlatModelArray) {
        SActivityPromPlatModel *promPlatModel = [_promPlatModelArray firstObject];
        CGFloat param = 0;
        if ([promPlatModel.condition isEqualToString:@"FULLMONEY"]) {//满额优惠
            param = nowPrice;
        }else if ([promPlatModel.condition isEqualToString:@"FULLPRODCLS"]) {//满款优惠
            param = idList.count;
        }
        NSDictionary *dict = [SActivutyOptimalTool activityOptimalForPromPlatModelArray:_promPlatModelArray price:nowPrice paramer:param];
        tempStr = dict[@"price"];
        _salePirce.text = dict[@"activityName"];
    }else{
        tempStr = OTHER_TO_STRING(@"¥%0.2f", nowPrice);
    }
    NSString *nowPriceChange= tempStr;
    NSString *originalPriceChange = OTHER_TO_STRING(@"¥%0.2f", original);
    
    CGSize labelSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:tempStr fontStyle:FONT_t1];
    [p_nowPriceLabel setText:tempStr];
    [p_nowPriceLabel setSize:CGSizeMake(labelSize.width, p_nowPriceLabel.height)];
    if(![nowPriceChange isEqualToString:originalPriceChange])
    {
        tempStr = OTHER_TO_STRING(@"¥%0.2f", original);
        labelSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:tempStr fontStyle:FONT_t6];
        UIView *lineView = [SUTIL getNormalLineBySize:labelSize.width height:1 color:COLOR_C6];
        
        [p_originPriceLabel setText:tempStr];
        [p_originPriceLabel setSize:CGSizeMake(labelSize.width, p_originPriceLabel.height)];
        [lineView setOrigin:CGPointMake(0, p_originPriceLabel.height/2)];
        [p_originPriceLabel addSubview:lineView];
    }
    else
    {
        p_originPriceLabel.hidden=YES;
    }
    
    
}

-(void)onCollocationBuy:(id)sender{
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    // TODO: 搭配购买
    if (!IS_STRING(sns.ldap_uid)) {
        LoginViewController *VC = [LoginViewController new];
        [self pushController:VC animated:YES];
        return;
    }
    MBAddShoppingViewController *controller = [[MBAddShoppingViewController alloc]initWithNibName:@"MBAddShoppingViewController" bundle:nil];
    if (!idList || idList.count <= 0) {
        NSLog(@"没有搭配商品");
        return;
    }
    controller.promotion_ID = _promotion_ID;
    controller.itemAry = idList;
    controller.collocationID = _collocationId;
    controller.mbCollocationID = _mb_collocationId;
    controller.collocationInfoDic = _collocationInfo;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)requestAddData{
    LNGood *goods = [self.goodsList firstObject];
    NSInteger listCount = self.goodsList.count - (goods.show_type.boolValue? 1: 0);
    NSInteger pageIndex = (listCount + 9)/ 10;
    NSDictionary *param = @{
                            @"cid":_collocationId,
                            @"page":@(pageIndex)
                            };
    /*[[SDataCache sharedInstance] get:@"Collocation" action:@"getCollocationListForDetails" param:param success:^(AFHTTPRequestOperation *operation, id object) {
     [self.collectionView footerEndRefreshing];
     NSArray *data = object[@"data"];
     [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
     LNGood *goods = [LNGood goodWithDict:obj];
     [self.goodsList addObject:goods];
     }];
     [self.collectionView reloadData];
     } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
     [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
     [self.collectionView footerEndRefreshing];
     [self layoutNoneDataView ];
     }];*/
}

// 加载Goods列表。
-(void)loadGoodsList:(NSArray *)tagList
{
    
    // 注意：必须是NSNumber的Array
    [HttpRequest productPostRequestPath:@"Product" methodName:@"ProductFilter" params:@{@"prodClsIdList": tagList} success:^(NSDictionary *dict) {
        NSLog(@"TODO ： productInfoList: %@",dict);
        if (!dict) {
            return;
        }
        listItem = dict[@"results"];
        // TODO：缓存下来方便点击标签处理，并且创建商品列表。
        // 也可以update已经布局好的UI信息。
        NSMutableArray *muTempAry = [NSMutableArray arrayWithObjects:nil];
        NSMutableArray *keyAry = [NSMutableArray arrayWithObjects:nil];
        
        skuList = [NSMutableArray new];
        
        for (int i = 0; i<listItem.count; i++) {
            
            NSDictionary *productInfo = listItem[i][@"productInfo"];
            NSString *clsID = productInfo[@"lM_PROD_CLS_ID"];
            if ([keyAry indexOfObject:clsID] == NSNotFound) {
                //                    stockDict[clsID] = @(0);
                
                [muTempAry addObject:productInfo];
                [keyAry addObject:clsID];
                
            }
            
            if ([productInfo[@"status"] intValue] != 2) {
                skuList[i] = @(0);
            } else {
                skuList[i] = productInfo[@"lisT_QTY"];
            }
            
            
        }
        [self updateItemShowView:(NSArray*)muTempAry];
    } failed:^(NSError *error) {
    }];
    
}


-(void)selectItem:(UITapGestureRecognizer *)recognizer{
    long itemId = recognizer.view.tag-BASE_BTN_TAG;
#warning  要传商品的code
    NSLog(@"商品id %ld",itemId);
    SProductDetailViewController *vc = [SProductDetailViewController new];
    vc.productID = OTHER_TO_STRING(@"%ld", itemId);
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)goCart:(id)sender{
    // TODO: GOTO Cart
    //    [SUTIL showTodo];
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *controller = [[MyShoppingTrollyViewController alloc]initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self pushController:controller animated:YES];
    }
}

- (void)commentAndLikeCellTapGesture:(UITapGestureRecognizer*)tap
{
    if (![BaseViewController pushLoginViewController])
    {
        return;
    }
    //喜欢
    NSInteger favCount =[likeUserAry count];
    NSString *colloId = [NSString stringWithFormat:@"%ld",(long)self.collocationId];
    if (favCount > 0 && [colloId length] > 0)
    {
        SCollocationLoversController *loverController = [[SCollocationLoversController alloc] init];
        loverController.collocationId = colloId;
        [self.navigationController pushViewController:loverController animated:YES];
    }
}

-(void)toTopClick:(id)selector{
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)toCreateTopic:(id)selector{
    NSLog(@"创建");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenKeyBoard) name:UIKeyboardWillHideNotification object:nil];
    
    
    [self.navigationController setNavigationBarHidden:YES];
    [self requestCarCount];
    if (_commentCount) {
        NSString *tempStr = OTHER_TO_STRING(@"评论(%@)", _commentCount);
        _commentLabel.text = tempStr;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    
    //显示导航栏
    [self.navigationController setNavigationBarHidden:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_noShoppingCommentsViewController requestSendMessage];
    
    
    _noShoppingCommentsViewController.commentLevelView.hidden = YES;
    _noShoppingCommentsViewController.commentLevelNoneView.hidden = YES;
    
    [_shieldView removeFromSuperview];
    _shieldView = nil;
    
    _noShoppingCommentsViewController.commentSendMessageTextFiled.placeholder = @"说点什么吧...";
    
    self.view.layer.transform = CATransform3DIdentity;
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"_noShoppingCommentsViewController textFieldShouldBeginEditing");
    _noShoppingCommentsViewController.commentLevelView.hidden = NO;
    _noShoppingCommentsViewController.commentLevelNoneView.hidden = NO;

    _noShoppingCommentsViewController.commentLevelNoneView.frame = CGRectMake(_noShoppingCommentsViewController.commentLevelNoneView.frame.origin.x, _noShoppingCommentsViewController.commentLevelNoneView.frame.origin.y, 100, _noShoppingCommentsViewController.commentLevelNoneView.frame.size.height);//默认为5颗星
    
    _noShoppingCommentsViewController.commentLevelView.frame = CGRectMake(0, _noShoppingCommentsViewController.commentContentView.frame.origin.y-44, _noShoppingCommentsViewController.commentContentView.frame.size.width, 44);
    
    
    _noShoppingCommentsViewController.commentLevelNoneView.frame = CGRectMake(_noShoppingCommentsViewController.commentLevelNoneView.frame.origin.x, _noShoppingCommentsViewController.commentContentView.frame.origin.y-44, _noShoppingCommentsViewController.commentLevelNoneView.frame.size.width, 44);
    
    [_noShoppingCommentsViewController.view addSubview:_noShoppingCommentsViewController.commentLevelView];
    
    [_noShoppingCommentsViewController.view insertSubview:_noShoppingCommentsViewController.commentLevelNoneView aboveSubview:_noShoppingCommentsViewController.commentLevelView];
    
    
    if (_shieldView != nil)
    {
        [_shieldView removeFromSuperview];
    }
    _shieldView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-88)];
    _shieldView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    _shieldView.hidden = NO;
    [self.view insertSubview:_shieldView belowSubview:_noShoppingCommentsViewController.view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)];
    [_shieldView addGestureRecognizer:tap];
    
    
    self.view.superview.backgroundColor = [UIColor whiteColor];
    self.view.layer.transform = CATransform3DMakeTranslation(0, -280, 0);
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldEndEditing");
    
    _noShoppingCommentsViewController.commentLevelView.hidden = YES;
    _noShoppingCommentsViewController.commentLevelNoneView.hidden = YES;
    
    [_shieldView removeFromSuperview];
    _shieldView = nil;
    
    _noShoppingCommentsViewController.commentSendMessageTextFiled.placeholder = @"说点什么吧...";
    
    self.view.layer.transform = CATransform3DIdentity;
    
    return YES;
}


- (void)hiddenKeyBoard
{
    [_noShoppingCommentsViewController.commentSendMessageTextFiled resignFirstResponder];
    
    
    /* CGRect rect = self.commentContentView.frame;
     rect.origin.y = UI_SCREEN_HEIGHT - _commentLevelView.frame.size.height;
     rect.size.height = _commentLevelView.frame.size.height;
     
     CGRect bearingFrame = _commentContentBearingView.frame;
     CGRect frame = _commentLevelNoneView.frame;
     frame.size.width = 0;
     bearingFrame.origin.y = 0;
     self.commentContentView.frame = rect;
     _commentContentBearingView.frame = bearingFrame;
     _commentLevelNoneView.frame = frame;
     _shieldView.hidden = YES;*/
}

- (void)showKeyBoard:(NSNotification*)userInfo
{
    NSLog(@"showKeyBoard");
    
    /* CGRect rect = _noShoppingCommentsViewController.commentContentView.frame;
     NSDictionary *dict = userInfo.userInfo;
     NSValue *boundsValue = dict[@"UIKeyboardBoundsUserInfoKey"];
     CGSize size = boundsValue.CGRectValue.size;
     rect.origin.y = UI_SCREEN_HEIGHT - 88 - size.height;
     
     float dy = 88 + size.height;
     
     self.view.superview.backgroundColor = [UIColor whiteColor];
     
     NSLog(@"self.view.superview = %@", self.view.superview);
     
     self.view.layer.transform = CATransform3DMakeTranslation(0, -314, 0);
     
     //_noShoppingCommentsViewController.commentContentView.frame = rect;*/
}


-(void)clickBack:(id)selector{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showPopView
{
    if (!_popView) {
        //获取设计者信息
        NSString *userIdStr = [NSString stringWithFormat:@"%@",listDict[@"user_id"]];
        BOOL isMy;
        
        
        if ([userIdStr isEqualToString:sns.ldap_uid]) {
            isMy=YES;
        }
        else
        {
            isMy=NO;
        }
        CollocationPopView *view = [[CollocationPopView alloc] initCollocationPopView:CGRectMake(UI_SCREEN_WIDTH - 115, 50+5, 100, 100) withIsMy:isMy];
        view.delegate = self;
        [self.view addSubview:view];
        _popView = view;
        [_popView showPop];
        return;
    }
    [_popView hidePop];
}
-(void)clickShare:(id)selector{
    NSLog(@"分享");
    ShareData *aData = [[ShareData alloc] init];
    NSString *collocationId= [NSString stringWithFormat:@"%ld",(long)self.collocationId];
    
    NSString *urlStr = [NSString stringWithFormat:SHARE_URL,collocationId];
    
    if (!urlStr || [urlStr length] == 0) {
        urlStr = @"http://www.banggo.com";
    }
    aData.shareUrl = urlStr;
    aData.image = [Utils reSizeImage:[Utils snapshot:showBigImgView] toSize:CGSizeMake(57,57)];
    aData.descriptionStr =  listDict[@"content_info"];
    ShareRelated *share = [ShareRelated sharedShareRelated];
    [share showInTarget:self withData:aData];
    
}

- (void)tapIndexTag:(UITapGestureRecognizer *)gesture
{
    UILabel *label = (UILabel *)gesture.view;
    NSString *str = label.text;
    if ([str length] == 0) {
        return;
    }
    if (label.tag == 1010) {
        NSString *topicId;
        for(SCollocationGoodsTagModel *model in _tagArray){
            if ([model.text isEqualToString:str]) {
                topicId = model.attributes.aID;
                
                break;
            }
        }
        if ([topicId integerValue] > 0) {
            STopicDetailViewController *controller = [[STopicDetailViewController alloc]init];
            controller.topicID = topicId;
            controller.titleName = str;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }else{
        STagDetailViewController *tagControl = [[STagDetailViewController alloc] init];
        tagControl.tagTitle = str;
        
        [self.navigationController pushViewController:tagControl animated:YES];
    }
}

// 是否隐藏顶部状态栏
- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)attendClicked:(UITapGestureRecognizer*)tap
{
    //    1-----展示取消关注。执行取消关注操作 后变为0   0 --- 展示关注  执行 加关注操作 后变为1
    if (!IS_STRING(sns.ldap_uid)) {
        LoginViewController *VC = [LoginViewController new];
        [self pushController:VC animated:YES];
        return;
    }
    NSDictionary *paramDic;
    paramDic=@{@"UserId":sns.ldap_uid,
               @"ConcernId":userInfoDict[@"userInfo"][@"userId"],
               };
    
    NSString *file;
    if (isLove == 1)
    {
        file =@"UserConcernDelete";
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示"
                                                         message:@"确定要取消该关注" delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:@"取消", nil];
        [alertView show];
        
        return;
    }
    else
    {
        [Toast makeToastActivity:@"正在关注,请稍候..." hasMusk:YES];
        
        file =@"UserConcernCreate";
    }
    [HttpRequest accountPostRequestPath:nil methodName:@"UserConcernCreate" params:paramDic success:^(NSDictionary *dict) {
        
        if ([[dict allKeys]containsObject:@"isSuccess"]) {
            if ([dict[@"isSuccess"] integerValue] ==1)
            {
                [Toast hideToastActivity];
                [self AttenState];
                isLove = 1;
            }
        }
        else
        {
            [Toast hideToastActivity];
            NSString *messageStr=[NSString stringWithFormat:@"%@",dict[@"message"]];
            
            if (messageStr.length==0)
            {
                [Utils alertMessage:@"失败"];
            }
            else
            {
                [Utils alertMessage:dict[@"message"]];
            }
            
        }
        
    } failed:^(NSError *error) {
        [Toast makeToast:@"关注失败!" duration:1.5 position:@"center"];
    }];
/*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableString *returnMessage=[[NSMutableString alloc]init];
        NSMutableDictionary *returnDic=[[NSMutableDictionary alloc]init];
        
        BOOL sucess =
        [SHOPPING_GUIDE_ITF requestPostUrlName:file param:paramDic responseAll:returnDic responseMsg:returnMessage];
        
        //刷新我的关注人员
        if (sucess)
        {
            NSString *centerFilePath= [AppSetting getPersonalFilePath];
            NSString *filePath=[centerFilePath stringByAppendingPathComponent:@"attendFriend"];
            
            NSMutableArray *listAttend=[NSMutableArray arrayWithContentsOfFile:filePath];
            NSString *useId=[NSString stringWithFormat:@"%@",userInfoDict[@"userInfo"][@"userId"]];
            
            if ([file isEqualToString:@"UserConcernDelete"])
            {
                [listAttend removeObject:useId];
            }
            else
            {
                [listAttend addObject:useId];
                
            }
            NSArray *writeArray = [NSArray arrayWithArray:listAttend];
            [writeArray writeToFile:filePath atomically:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [Toast hideToastActivity];
                [self AttenState];
                isLove = 1;
                //                }
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast hideToastActivity];
                if (returnMessage.length==0)
                {
                    if ([[returnDic allKeys]containsObject:@"message"])
                    {
                        [Utils alertMessage:returnDic[@"message"]];
                    }
                    else
                    {
                        [Utils alertMessage:@"失败"];
                    }
                }
                else
                {
                    [Utils alertMessage:returnMessage];
                }
                
                
            });
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    */
}


//点击设计师头像到他的个人中心
-(void)designerHeadTaped:(UITapGestureRecognizer *)headTap
{
    NSString * designerID  = userInfoDict[@"userInfo"][@"userId"];
    SMineViewController *vc = [[SMineViewController alloc]init];
    vc.person_id = designerID;
    [self.navigationController pushViewController:vc animated:YES];
}




//#pragma collectionDelegate
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSInteger collocationId  = [((LNGood*)self.goodsList[indexPath.row]).product_ID integerValue];
//    if (collocationId<0) {
//        return;
//    }
//    SCollocationDetailViewController *vc = [SCollocationDetailViewController new];
//    vc.collocationId = collocationId;
//    [self pushController:vc animated:YES];
//
//}
#pragma mark  AlertView delegate method



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *file;
    NSDictionary *paramDic;
    if (alertView.tag==10000) {
        if (buttonIndex == 1) {
            NSString *collId =[NSString stringWithFormat:@"%ld",(long)self.collocationId];
            //        if (dataModel) {
            //            collId = dataModel.idValue;
            //        }else{
            //            collId = self.cellData[@"id"];
            //        }
            [[SDataCache sharedInstance] delCollocationInfo:@"" collocationId:[collId integerValue] complete:^(NSArray *data, NSError *error) {
                [Toast hideToastActivity];
                if (error) {
                    [Toast makeToast:@"删除失败，请稍候再试"];
                    return ;
                }
                else
                {
                    [Toast makeToast:@"删除成功!"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteCollocation" object:nil];
                    
                    [self clickBack:nil];
                    
                }
            }];
            
        }
        return;
    }
    if (buttonIndex==0)
    {
        [Toast hideToastActivity];
        [Toast makeToastActivity:@"正在取消,请稍候" hasMusk:YES];
        file =@"UserConcernDelete";
        paramDic=@{@"UserId":sns.ldap_uid,
                   @"ConcernIds":userInfoDict[@"userInfo"][@"userId"]};
        
        [HttpRequest accountPostRequestPath:nil methodName:file params:paramDic success:^(NSDictionary *dict) {
            
            if ([[dict allKeys]containsObject:@"isSuccess"]) {
                if ([dict[@"isSuccess"] integerValue] ==1)
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshAttend" object:nil];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Toast hideToastActivity];
                        [self CancelAttenState];
                        isLove = 0;
                    });
                }
            }
            else
            {
                [Toast hideToastActivity];
                [self CancelAttenState];
                NSString *messageStr=[NSString stringWithFormat:@"%@",dict[@"message"]];
                
                if (messageStr.length==0)
                {
                    [Utils alertMessage:@"失败"];
                }
                else
                {
                    [Utils alertMessage:dict[@"message"]];
                }
            }
            
        } failed:^(NSError *error) {
            [Toast hideToastActivity];
            [self CancelAttenState];
            [Toast makeToast:@"关注失败!" duration:1.5 position:@"center"];
        }];

        
        /*
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableString *returnMessage=[[NSMutableString alloc]init];
            NSMutableDictionary *returnDic=[[NSMutableDictionary alloc]init];
            BOOL sucess =
            [SHOPPING_GUIDE_ITF requestPostUrlName:file param:paramDic responseAll:returnDic responseMsg:returnMessage];
            
            //刷新我的关注人员
            if (sucess)
            {
                NSString *centerFilePath= [AppSetting getPersonalFilePath];
                NSString *filePath=[centerFilePath stringByAppendingPathComponent:@"attendFriend"];
                
                NSMutableArray *listAttend=[NSMutableArray arrayWithContentsOfFile:filePath];
                NSString *useId=[NSString stringWithFormat:@"%@",userInfoDict[@"userInfo"][@"userId"]];
                
                [listAttend removeObject:useId];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshAttend" object:nil];
                
                NSArray *writeArray = [NSArray arrayWithArray:listAttend];
                [writeArray writeToFile:filePath atomically:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                    [self CancelAttenState];
                    isLove = 0;
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                    
                    [self CancelAttenState];
                    if (returnMessage.length==0)
                    {
                        if ([[returnDic allKeys]containsObject:@"message"])
                        {
                            [Utils alertMessage:returnDic[@"message"]];
                        }
                        else
                        {
                            [Utils alertMessage:@"失败"];
                        }
                    }
                    else
                    {
                        [Utils alertMessage:@"失败"];
                    }
                    
                    
                });
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        */
    }
    else
    {
        [Toast hideToastActivity];
        //        [self CancelAttenState];
        //        _attentionBtn.tag=1;
    }
}

#pragma mark item touch action
- (void)itemTouchAction:(UITapGestureRecognizer*)tap{
    
}

#pragma mark tag touch action
- (void)tagTouchAction:(UITapGestureRecognizer*)tap{
    SCollocationGoodsTagModel *model = _tagArray[tap.view.tag - 160];
    switch (model.attributes.type.intValue) {
        case CoverTagTypeItem://单品
        {
#warning  要传商品的code
            SProductDetailViewController *controller = [[SProductDetailViewController alloc]init];
            controller.productID = model.attributes.aID;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case CoverTagTypeBrand://品牌
        {
#warning  brandid  要传入品牌code brand_code
            SBrandSotryViewController *controller = [[SBrandSotryViewController alloc]init];
            controller.brandId = [NSString stringWithFormat:@"%@",model.attributes.aID];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case CoverTagTypePerson://人
        {
            SMineViewController *vc = [[SMineViewController alloc]init];
            vc.person_id = model.attributes.aID;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case CoverTagTypeTopic://话题
        {
            STopicDetailViewController *controller = [[STopicDetailViewController alloc]init];
            controller.topicID = model.attributes.aID;
            controller.titleName = model.text;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)AttenState
{
    concernImgView.backgroundColor=[UIColor clearColor];
    
    [concernImgView setImage:[UIImage imageNamed:@"Unico/ygz"]];
    
    
}
//
-(void)CancelAttenState
{
    concernImgView.backgroundColor=[UIColor clearColor];
    
    [concernImgView setImage:[UIImage imageNamed:@"Unico/add_gz"]];
    
}
@end
