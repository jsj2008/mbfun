//
//  MBCollocationDetailsController.m
//  Wefafa
//
//  Created by Jiang on 5/7/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//
//  废弃 以前的 搭配详情
#import "MBCollocationDetailsController.h"
#import "NavigationTitleView.h"
#import "ShoppIngBagShowButton.h"
#import "MBCollocationCollectionViewCell.h"
#import "HttpRequest.h"
#import "MBShoppingGuideInterface.h"
#import "Utils.h"
#import "Toast.h"

#import "MBCollocationDetailsCollectionHeaderView.h"
#import "MyShoppingTrollyViewController.h"
#import "MBCollocationDetailModel.h"
#import "MBGoodsDetailListModel.h"
#import "TagDetailViewController.h"
#import "ShareRelated.h"

@interface MBCollocationDetailsController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MBCollocationDetailsCollectionHeaderDelegate, UIAlertViewDelegate>
{
    UIImageView *_collectionHeaderView;
    UIButton *_attentionButton;
}

@property (weak, nonatomic) IBOutlet UIView *navigationHeaderView;

//-------
@property (strong, nonatomic) UICollectionView *contentCollectionView;
@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagShowButton;
@property (nonatomic, strong) MBCollocationDetailModel *contentModel;
@property (nonatomic, strong) NSArray *goodsDetailArray;

//---------tab bar button

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
- (IBAction)shareButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
- (IBAction)likeButtonAction:(UIButton *)sender;

@end

static NSString *cellIndentifier = @"MBCollocationCollectionViewCellIdentifier";
static NSString *headerIndentifier = @"MBCollocationHeaderIdentifier";
@implementation MBCollocationDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initNavigationBar];
    [self initSubViews];
    [self requestData];
}

- (void)initNavigationBar{
    self.navigationHeaderView.layer.zPosition = 5;
    CGRect headrect = self.navigationHeaderView.bounds;
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:)  selectorOk:nil selectorMenu:nil];
    
    self.shoppingBagShowButton = [[ShoppIngBagShowButton alloc]initWithFrame:view.btnMenu.bounds];
    [view addSubview:self.shoppingBagShowButton];
    [self.shoppingBagShowButton addTarget:self action:@selector(navigationBarMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shoppingBagShowButton setImage:[UIImage imageNamed:@"shoppingbag"] forState:UIControlStateNormal];
    CGRect rect;
    rect.size = CGSizeMake(40, 40);
    rect.origin.x = view.frame.size.width - rect.size.width;
    rect.origin.y = view.frame.size.height - rect.size.height;
    self.shoppingBagShowButton.frame = rect;
    self.shoppingBagShowButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.shoppingBagShowButton setTitle:@"0" forState:UIControlStateNormal];
    self.shoppingBagShowButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.shoppingBagShowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    view.lbTitle.text=@"搭配详情";
    [self.navigationHeaderView addSubview:view];
}

- (void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationBarMenuAction:(id)sender{
    MyShoppingTrollyViewController *controller = [[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initSubViews{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 0.0;
    self.contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64) collectionViewLayout:layout];
    self.contentCollectionView.backgroundColor = [UIColor whiteColor];
    self.contentCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"MBCollocationCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIndentifier];
    UINib *aNib = [UINib nibWithNibName:@"MBCollocationDetailsCollectionHeaderView" bundle:nil] ;
    [self.contentCollectionView registerNib:aNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIndentifier];
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    
    [self.view insertSubview:self.contentCollectionView atIndex:0];
    
    self.contentCollectionView.userInteractionEnabled = NO;
    self.shareButton.userInteractionEnabled = NO;
    self.likeButton.userInteractionEnabled = NO;
}

- (void)requestData{
    if (!self.collocationID) {
        return;
    }
    [Toast makeToastActivity];
    NSDictionary *dictionary = @{@"ids": self.collocationID,
                                 @"LoginUserId": sns.ldap_uid};
    __unsafe_unretained typeof(self) p = self;
    [HttpRequest collocationGetRequestPath:nil methodName:@"WxCollocationBasicInfoFilter" params:dictionary success:^(NSDictionary *dict) {
        [Toast hideToastActivity];
        if (!dict[@"results"]) {
            [Toast makeToast:@"没有商品数据！" duration:3.0 position:@"center"];
        }else{
            p.contentModel = [[MBCollocationDetailModel alloc]initWithDictionary:dict[@"results"][0]];
            p.contentCollectionView.userInteractionEnabled = YES;
            p.likeButton.userInteractionEnabled = YES;
            p.shareButton.userInteractionEnabled = YES;
        }
    } failed:^(NSError *error) {
        [Toast hideToastActivity];
        [Toast makeToast:@"获取商品失败！" duration:3.0 position:@"center"];
        NSLog(@"搭配详情请求错误-----------%@", error);
    }];
    //单品列表请求
    NSDictionary *param = @{@"collocationId": self.collocationID};
    [HttpRequest collocationGetRequestPath:nil methodName:@"CollocationDetailFilter" params:param success:^(NSDictionary *dict) {
        p.goodsDetailArray = [MBGoodsDetailListModel modelArrayForDataArray:dict[@"results"]];
    } failed:^(NSError *error) {
        NSLog(@"搭配详情请求错误-----------%@", error);
    }];
}

#pragma mark - 分享回调

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadShareCount:) name:@"shareCountAdd" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shareCountAdd" object:nil];
}

-(void)reloadShareCount:(NSNotification*)status
{
    //    succeed
    //    failure
    //    cancel
    NSNumber *number = status.object;
    ShareStatus shareStatus = [number intValue];
    if (shareStatus == succeed) {
//        [Toast makeToast:@"分享成功！" duration:2.0 position:@"center"];
        [Toast makeToastSuccess:@"分享成功！"];
        int count = self.contentModel.collocationInfo.sharedCount.intValue;
        self.contentModel.collocationInfo.sharedCount = @(count + 1);
        [self.shareButton setTitle:self.contentModel.collocationInfo.sharedCount.stringValue forState:UIControlStateNormal];
    }else if(shareStatus == failure){
        [Toast makeToast:@"分享失败！" duration:2.0 position:@"center"];
        return;
    }else if(shareStatus == cancel){
        [Toast makeToast:@"您取消了分享！" duration:2.0 position:@"center"];
        return;
    }else{
        return;
    }
}

#pragma mark - set get
- (void)setContentModel:(MBCollocationDetailModel *)contentModel{
    _contentModel = contentModel;
    self.likeButton.selected = contentModel.isFavorite.boolValue;
    [self.shareButton setTitle:contentModel.collocationInfo.sharedCount.stringValue forState:UIControlStateNormal];
    [self.likeButton setTitle:contentModel.collocationInfo.favoriteCount.stringValue forState:UIControlStateNormal];
    [self.contentCollectionView reloadData];
}

- (void)setGoodsDetailArray:(NSArray *)goodsDetailArray{
    _goodsDetailArray = goodsDetailArray;
    [self.contentCollectionView reloadData];
}

#pragma mark - method
- (IBAction)shareButtonAction:(UIButton *)sender {
    
    
    if ([BaseViewController pushLoginViewController]) {
        
        NSString *shareUrl=[NSString stringWithFormat:@"%@",SHARE_URL];
        NSString *detailUrlStr= [NSString stringWithFormat:@"%@",shareUrl];
        NSString *lastStr = [detailUrlStr substringFromIndex:detailUrlStr.length-1];
        
        NSString *noLastUrlStr=detailUrlStr;
        
        if ([lastStr isEqualToString:@"?"]) {
            
            noLastUrlStr = [detailUrlStr substringToIndex:detailUrlStr.length-1];
            
        }
        
        shareUrl=[NSString stringWithFormat:@"%@",noLastUrlStr];
        
        NSString *jsonWeb =[NSString stringWithFormat:@"&f_code=co_detail&collocalID=%@",[Utils getSNSInteger:self.contentModel.collocationInfo.aID.stringValue]];
        
        NSString * web_urlStr = [shareUrl stringByAppendingFormat:@"%@",jsonWeb];
        ShareData *shareData = [[ShareData alloc]init];
        shareData.title = self.contentModel.collocationInfo.name;
        shareData.descriptionStr = self.contentModel.collocationInfo.aDescription;
        shareData.shareUrl = web_urlStr;
        shareData.image = [Utils reSizeImage:_collectionHeaderView.image toSize:CGSizeMake(57,57)];
        shareData.shopId = self.contentModel.collocationInfo.aID.stringValue;
        ShareRelated *view = [ShareRelated sharedShareRelated];
        [view showInTarget:self withData:shareData];
    }
}

- (IBAction)likeButtonAction:(UIButton *)sender {
    NSString *soureceKey = sender.selected ? @"sourceIdS" : @"SOURCE_ID";
    NSDictionary *param=@{
                          soureceKey:[NSString stringWithFormat:@"%@", self.contentModel.collocationInfo.aID],
                          @"userId":sns.ldap_uid,
                          @"SOURCE_TYPE":@"2",
                          @"Create_User":sns.myStaffCard.nick_name
                          };
    NSString *methodName = sender.selected ? @"FavoriteDelete" :@"FavoriteCreate";
    __unsafe_unretained typeof(self) weakSelf = self;
    [HttpRequest orderPostRequestPath:nil methodName:methodName params:param success:^(NSDictionary *dict) {
        if ([dict[@"isSuccess"] boolValue] == YES) {
            int count = 0;
            if (weakSelf.likeButton.selected) {
                count = weakSelf.contentModel.collocationInfo.favoriteCount.intValue - 1;
            }else{
                count = weakSelf.contentModel.collocationInfo.favoriteCount.intValue + 1;
            }
            weakSelf.contentModel.collocationInfo.favoriteCount = @(count);
            weakSelf.contentModel.isFavorite = @(!weakSelf.contentModel.isFavorite.boolValue);
            weakSelf.likeButton.selected = !weakSelf.likeButton.selected;
            [weakSelf.likeButton setTitle:weakSelf.contentModel.collocationInfo.favoriteCount.stringValue forState:UIControlStateNormal];
        }
        [Toast hideToastActivity];
    } failed:^(NSError *error) {
        [Toast hideToastActivity];
        [Toast makeToast:kNoneInternetTitle duration:3.0 position:@"center"];
    }];
}

#pragma mark - collectionView datasource delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsDetailArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MBCollocationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    MBGoodsDetailListModel *model = self.goodsDetailArray[indexPath.row];
    cell.contentModel = model;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MBCollocationDetailsCollectionHeaderView *collectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIndentifier forIndexPath:indexPath];
        collectionReusableView.headerImageView = _collectionHeaderView;
        collectionReusableView.headerDelegate = self;
        collectionReusableView.isConcerned = self.contentModel.isConcerned.boolValue;
        collectionReusableView.contentInfoModel = self.contentModel.collocationInfo;
        collectionReusableView.contentUserModel = self.contentModel.userPublicEntity;
        collectionReusableView.contentTagModel = self.contentModel.tagModelArray;
        view = collectionReusableView;
    }
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    MBGoodsDetailsViewController *controller = [[MBGoodsDetailsViewController alloc]initWithNibName:@"MBGoodsDetailsViewController" bundle:nil];
//    MBGoodsDetailListModel *model = self.goodsDetailArray[indexPath.row];
//    controller.contentModel = model.proudctList;
//    [self.navigationController pushViewController:controller animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(UI_SCREEN_WIDTH/ 2, UI_SCREEN_WIDTH/ 2);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGFloat tag_X = 40.0;
    CGFloat tag_Y = 50.0;
    for(int i = 0; i < self.contentModel.tagModelArray.count; i++){
        MBCollocationTagMappingModel *model = self.contentModel.tagModelArray[i];
        CGSize size = [model.showTagName boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 30, 0)
                       options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
            attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
        if (size.width + 20 + tag_X > UI_SCREEN_WIDTH - 15) {
            tag_X = 15.0;
            tag_Y += 30;
        }
        tag_X += size.width + 30;
    }
    CGFloat header_Height = tag_Y - 50.0 + 500;
    return CGSizeMake(UI_SCREEN_WIDTH, header_Height);
}

#pragma mark - headerView Delegate

- (void)collocationDetails:(MBCollocationDetailsCollectionHeaderView *)headerView AttentionButton:(UIButton *)attentionButton{
    attentionButton.userInteractionEnabled = NO;
    if([attentionButton isSelected])
    {
        _attentionButton = attentionButton;
        UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要取消关注吗?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertV show];
        return;
    }
    else
    {
        NSDictionary *param=@{@"UserId": sns.ldap_uid,
                @"ConcernId": self.contentModel.userPublicEntity.aID,
                @"ConcernType": @"造型师"};
        __unsafe_unretained typeof(self) p = self;
        [HttpRequest accountPostRequestPath:nil methodName:@"UserConcernCreate" params:param success:^(NSDictionary *dict) {
            p.contentModel.isConcerned = @YES;
            attentionButton.selected = YES;
            attentionButton.userInteractionEnabled = YES;
        } failed:^(NSError *error) {
            attentionButton.userInteractionEnabled = NO;
            [Toast makeToast:@"关注失败" duration:1.5 position:@"center"];
        }];
    }
}

- (void)collocationDetails:(MBCollocationDetailsCollectionHeaderView *)headerView BuyNowButton:(UIButton *)buyNowButton{
    
}

- (void)collocationDetails:(MBCollocationDetailsCollectionHeaderView *)headerView ShoppingBagButton:(UIButton *)shoppingBagButton{
    
}

- (void)collocationDetails:(MBCollocationDetailsCollectionHeaderView *)headerView TagIndex:(NSInteger)tagIndex{
    MBCollocationTagMappingModel *model = self.contentModel.tagMapping[tagIndex];
    TagDetailViewController *controller = [[TagDetailViewController alloc]init];
    controller.tagId = model.showTagId.stringValue;
    controller.isCustom = model.isCustom;
    controller.naviTitle = model.showTagName;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)collocationDetailsUserContentTouchTap:(MBCollocationDetailsCollectionHeaderView *)headerView{

}

#pragma mark alert view delegate

- (void) alertView:(UIAlertView *)alertview clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){
        NSDictionary *param=@{@"UserId": sns.ldap_uid,
                              @"ConcernIds": self.contentModel.userPublicEntity.aID};//self.user_ID
        __unsafe_unretained typeof(self) p = self;
        [HttpRequest accountPostRequestPath:nil methodName:@"UserConcernDelete" params:param success:^(NSDictionary *dict) {
            p.contentModel.isConcerned = @NO;
            _attentionButton.selected = NO;
            _attentionButton.userInteractionEnabled = YES;
        } failed:^(NSError *error) {
            [Toast makeToast:@"取消关注失败！" duration:1.5 position:@"center"];
        }];
    }
}

@end
