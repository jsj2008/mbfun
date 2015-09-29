//
//  BrandDetailCell.m
//  Wefafa
//
//  Created by wave on 15/8/5.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "BrandDetailCell.h"
#import "CommMBBusiness.h"
#import "SUtilityTool.h"
#import "CommentsViewController.h"
#import "SDataCache.h"
#import "ShareRelated.h"
#import "Utils.h"
#import "LNGood.h"
#import "BrandDetailLikeCollectionViewCell.h"
#import "BrandDetailViewController.h"
#import "CoverStickerView.h"
#import "SUtilityTool.h"
#import "BrandDetailLikeAccessoryCollectionViewCell.h"
#import "SCollocationLoversController.h"

static NSString *brandDetailLikeCellId = @"brandDetailLikeCellId";
static NSString *brandDetailLikeAccessoryCellId = @"brandDetailLikeAccessoryCellId";
@interface BrandDetailCell ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UIAlertView *showAlertView ;
}
@property (weak, nonatomic) IBOutlet UIImageView *contentIMG;
@property (weak, nonatomic) IBOutlet UIView *bottomBtnView;
@property (weak, nonatomic) IBOutlet UILabel *describleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headIMG;
@property (weak, nonatomic) IBOutlet UIImageView *head_V;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewLike;

@property (nonatomic) NSMutableArray *btnArray;
@property (nonatomic) NSMutableArray *tagViewArr;
@property (nonatomic, strong) NSMutableArray *dataArrayLikeCollectionView;
@property (nonatomic) UIButton *tagControlBtn;

@end

@implementation BrandDetailCell

- (void)awakeFromNib {
    // Initialization code
    __weak BrandDetailCell *ws = self;
    self.likeBlock = ^(){
        NSUInteger favCount = 0;
        NSString *collId = @"";
        favCount = _dataArrayLikeCollectionView.count;
        collId = ws.model.product_ID;
        
        if (favCount > 0 && [collId length] > 0) {
            SCollocationLoversController *loverController = [[SCollocationLoversController alloc] init];
            loverController.collocationId = collId;
            [ws.parentVc.navigationController pushViewController:loverController animated:YES];
        }
    };
    [self uiconfig];
}

- (void)uiconfig {
    self.backgroundColor = [UIColor whiteColor];
    _bottomBtnView.backgroundColor = COLOR_C4;
    
    _tagViewArr = [NSMutableArray new];
    
    self.headIMG.layer.cornerRadius = self.headIMG.width / 2;
    self.headIMG.layer.masksToBounds = YES;
    
    CGFloat lineMargin = 1;
    CGFloat btnWidth = (UI_SCREEN_WIDTH - 3) / 4;
    CGFloat btnHeight = 35;
    NSArray *imgNormalArray = @[@"Unico/icon_comment2.png", @"Unico/icon_like2.png", @"Unico/icon_share2.png", @"Unico/icon_report2.png",];
    NSArray *imgHighLightArray = @[@"Unico/icon_comment2.png", @"Unico/icon_like22.png", @"Unico/icon_share2.png", @"Unico/icon_report2.png",];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * btnWidth, lineMargin, btnWidth, btnHeight);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTintColor:COLOR_C11];
        [btn setImage:[UIImage imageNamed:imgNormalArray[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgHighLightArray[i]] forState:UIControlStateSelected];
        [btn setTitleColor:COLOR_C5 forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBtnView addSubview:btn];
        if (_btnArray == nil) {
            _btnArray = [NSMutableArray arrayWithCapacity:4];
        }
        [_btnArray addObject:btn];
    }
    //time
    [_timeLabel setFont:FONT_t7];
    //like collectionView
    _collectionViewLike.backgroundColor = [UIColor whiteColor];
    _collectionViewLike.showsHorizontalScrollIndicator = NO;
    _collectionViewLike.delegate = self;
    _collectionViewLike.dataSource = self;
    [_collectionViewLike registerNib:[UINib nibWithNibName:@"BrandDetailLikeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:brandDetailLikeCellId];
    [_collectionViewLike registerNib:[UINib nibWithNibName:@"BrandDetailLikeAccessoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:brandDetailLikeAccessoryCellId];
    //tag控制按钮
    _tagControlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tagControlBtn setFrame:CGRectMake(UI_SCREEN_WIDTH - 42, 84, 30, 30)];
    [_tagControlBtn setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    _tagControlBtn.hidden=YES;
    [_tagControlBtn addTarget:self action:@selector(controlTagState:) forControlEvents:UIControlEventTouchUpInside];
    [_tagControlBtn setImage:[UIImage imageNamed:@"Unico/icon_showtag"] forState:UIControlStateNormal];
    [_tagControlBtn setImage:[UIImage imageNamed:@"Unico/icon_hidetag"] forState:UIControlStateSelected];
    [self addSubview:_tagControlBtn];
    
    [_tagControlBtn setSelected:YES];
}

- (void)setModel:(LNGood *)model {
    _model = model;
    //portrait
    [self.headIMG sd_setImageWithURL:[NSURL URLWithString:model.head_img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    [self.titleLabel setText:model.nick_name];
    // head_v_type

    switch ([model.head_v_type integerValue]) {
        case 0:
        {
            _head_V.hidden=YES;
        }
            break;
        case 1:
        {
            _head_V.hidden=NO;
            [_head_V setImage:[UIImage imageNamed:@"brandvip@2x"]];
        }
            break;
        case 2:
        {
            [_head_V setImage:[UIImage imageNamed:@"peoplevip@2x"]];
            _head_V.hidden=NO;
        }
            break;
        default:
            break;
    }
    
    //time
    NSMutableString *timeStr = [NSMutableString stringWithString:model.create_time];
    [self.timeLabel setText:[timeStr substringWithRange:NSMakeRange(0, 10)]];
    
    
    NSString *createDateStr = [CommMBBusiness getdate:model.create_time];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *createDate = [formatter dateFromString:createDateStr];
    NSTimeInterval timeoffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
    createDate = [createDate dateByAddingTimeInterval:timeoffset];
    
    NSDate *nowdate = [NSDate date];
    nowdate = [nowdate dateByAddingTimeInterval:timeoffset];
    
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit fromDate:createDate toDate:nowdate options:0];

    
    
    //content image
    [self.contentIMG sd_setImageWithURL:[NSURL URLWithString:model.img]];
    //describle
    [self.describleLabel setText:model.content_info];
    CGFloat height;
    if (model.content_info.length) {
        [self.describleLabel setHeight:40];
        height = 40;
    }else {
        height = 0;
    }
    for (NSLayoutConstraint *layout in _describleLabel.constraints) {
        if (layout.firstAttribute == NSLayoutAttributeHeight) {
//            layout.constant = height;
            layout.constant = model.infoHeight;
            _describleLabel.numberOfLines = 1;
            if (model.infoHeight > 40) {
                _describleLabel.numberOfLines = 0;
            }
        }
    }
    //like button
    ((UIButton*)_btnArray[1]).selected = [model.is_love intValue];
    //like collectionView
    _dataArrayLikeCollectionView =  [NSMutableArray arrayWithArray:_model.array_like_user_list];//[_model.array_like_user_list copy];
    [_collectionViewLike reloadData];
//    CGFloat height;
    /*
    if (_dataArrayLikeCollectionView.count == 0) {
        height = 0;
    }else {
        height = 36;
    }
     */
    height = 36;
    for (NSLayoutConstraint *layout in _collectionViewLike.constraints) {
        if (layout.firstAttribute == NSLayoutAttributeHeight) {
            layout.constant = height;
        }
    }
    //sticker img
    NSArray *tagArray = [SUTILITY_TOOL_INSTANCE getArray:model.tag_list];
    if ([tagArray isKindOfClass:[NSArray class]]) {
        _tagControlBtn.hidden = !tagArray.count;
        for (UIView *view in _contentIMG.subviews) {
            [view removeFromSuperview];
        }
        for (NSDictionary *tempDic in tagArray) {
            CoverStickerView *stickerView = (CoverStickerView*)[[SUtilityTool shared] addTagWithDict:tempDic inView:_contentIMG];
            [_tagViewArr addObject:stickerView];
        }
        if (_model.ishidden) {
            _tagControlBtn.hidden=NO;
            [_tagControlBtn setSelected:NO];
            for(UIImageView *imgV in _tagViewArr) {
                [imgV setHidden:YES];
            }
        }
        else {
            [_tagControlBtn setSelected:YES];
        }
    }else {
        _tagControlBtn.hidden = YES;
    }
}

- (void)click:(UIButton*)sender {
    switch (sender.tag) {
        case 0: //评论
        {
            //MARK:评论的对象是搭配 这里是单品
            NSLog(@"评论");
            if (![BaseViewController pushLoginViewController]) {
                return;
            }
            CommentsViewController *controller = [[CommentsViewController alloc]initWithNibName:@"CommentsViewController" bundle:nil];
            controller.collocationID = [NSString stringWithFormat:@"%@",_model.product_ID];
            [self.parentVc.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1: //like
        {
            if (![BaseViewController pushLoginViewController]) {
                return;
            }
            
            NSString * tempIntStr=nil;
            tempIntStr = _model.product_ID;
            //喜欢
            if (![_model.is_love intValue]) {
                [SDATACACHE_INSTANCE likeCollocation:tempIntStr complete:^(id data) {
                    NSNumber *dataInt = (NSNumber*)data;
                    if(dataInt.intValue == 1){
                        [self setLikeBtnStatus:YES];
                        [self changeLikeStatus:YES];
                    }
                }];
            }//取消喜欢
            else{
                [SDATACACHE_INSTANCE delLikeCollocation:tempIntStr complete:^(id data) {
                    NSNumber *dataInt = (NSNumber*)data;
                    if(dataInt.intValue == 1){
                        [self setLikeBtnStatus:NO];
                        [self changeLikeStatus:NO];
                    }
                }];
            }
//            ((BrandDetailViewController*)_parentVc).reloadBlock(self);
        }
            break;
        case 2: //share
        {
            if (![BaseViewController pushLoginViewController]) {
                return;
            }
            NSString *urlStr=@"";
            
            ShareData *aData = [[ShareData alloc] init];
            urlStr = [SUTIL getCollocationURL:@{@"id" : _model.product_ID}];
            
            if (!urlStr || [urlStr length] == 0) {
                urlStr = @"http://www.banggo.com";
            }
            aData.shareUrl = urlStr;
            aData.image = [Utils reSizeImage:[Utils snapshot:_contentIMG] toSize:CGSizeMake(57,57)];
            aData.descriptionStr = _model.content_info;//self.cellData[@"content_info"];
            ShareRelated *share = [ShareRelated sharedShareRelated];
            [share showInTarget:_parentVc withData:aData];

        }
            break;
        case 3: //举报
        {
            if (![BaseViewController pushLoginViewController]) {
                return;
            }
            NSString *title = @"举报不良内容";
            //             NSString *userIdStr = self.cellData[@"user_id"];
            NSString *userIdStr = _model.user_id;
            if ([sns.ldap_uid isEqualToString:userIdStr]) {
                title = @"删除我的发布";
            }
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:title, nil];
            [sheet showInView:self.parentVc.view];
        }
            break;
            
        default:
            break;
    }
}

- (void)setLikeBtnStatus:(BOOL)like {
    UIButton *btn = _btnArray[1];
    if (like) {
        _model.is_love = @"1";
        [btn setSelected:YES];
    }else {
        _model.is_love = @"0";
        [btn setSelected:NO];
    }
}

- (void)changeLikeStatus:(BOOL)status {
    if (status) {   //yes喜欢成功
        like_user_listModel *model = [like_user_listModel new];
        [model setValue:sns.myStaffCard.photo_path forKey:@"head_img"];
        [model setValue:sns.ldap_uid forKey:@"user_id"];
        [_dataArrayLikeCollectionView addObject:model];
        [self refreshCollectionView];
    }else {//喜欢失败
        [_dataArrayLikeCollectionView enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            like_user_listModel *model = (like_user_listModel*)obj;
            if ([model.user_id isEqualToString:sns.ldap_uid]) {
                [_dataArrayLikeCollectionView removeObjectAtIndex:[_dataArrayLikeCollectionView indexOfObject:obj]];
            }
            [self refreshCollectionView];
        }];
    }
}

- (void)refreshCollectionView {
    [_collectionViewLike reloadData];
}

- (void)controlTagState:(UIButton *)button {
    button.selected = !button.isSelected;
    BOOL isShow = button.isSelected;
    _model.ishidden = !isShow;
    
    for(UIImageView *imgV in _tagViewArr){
        [imgV setHidden:!isShow];
    }
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([_dataArrayLikeCollectionView count] > 8) {
//        return 9;
        return 8;
    }
    return [_dataArrayLikeCollectionView count] + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGSize size = CGSizeMake(30, 30);
//    if (indexPath.row) {
//        size = CGSizeMake(54, 20);
//    }
    
    CGSize size = CGSizeMake(30, 30);    
    if (_dataArrayLikeCollectionView.count > 8) {
        if (indexPath.row < 8) {
            size = CGSizeMake(30, 30);
        }else {
            size = CGSizeMake(42, 20);
        }
    }else{
        size = indexPath.row < _dataArrayLikeCollectionView.count ? CGSizeMake(30, 30) : CGSizeMake(54, 20);
    }
    
    return size;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell*returnCell;
    if (_dataArrayLikeCollectionView.count > 8) {
        if (indexPath.row < 7) {
            BrandDetailLikeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:brandDetailLikeCellId forIndexPath:indexPath];
            like_user_listModel *model = _dataArrayLikeCollectionView[indexPath.row];
            cell.imgUrlStr = model.head_img;
            returnCell = cell;
        }
        else {
            BrandDetailLikeAccessoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:brandDetailLikeAccessoryCellId forIndexPath:indexPath];
            cell.parentView = self;
            cell.numStr = [@(_dataArrayLikeCollectionView.count) stringValue];
            returnCell = cell;
        }
    }else {
        if (indexPath.row < _dataArrayLikeCollectionView.count) {
            BrandDetailLikeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:brandDetailLikeCellId forIndexPath:indexPath];
            like_user_listModel *model = _dataArrayLikeCollectionView[indexPath.row];
            cell.imgUrlStr = model.head_img;
            returnCell = cell;
        }else {
            BrandDetailLikeAccessoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:brandDetailLikeAccessoryCellId forIndexPath:indexPath];
            cell.parentView = self;
            cell.numStr = [@(_dataArrayLikeCollectionView.count) stringValue];
            returnCell = cell;
        }
    }
    return returnCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    like_user_listModel *model = _dataArrayLikeCollectionView[indexPath.row];
    ((BrandDetailViewController*)_parentVc).block(model.user_id);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSString *userIdStr = @"";
        NSString *collId = @"";
        
        if (![sns.ldap_uid isEqualToString:userIdStr]) {
            [Toast makeToastActivity:@""];
            [[SDataCache sharedInstance] addMyComplaintsInfoWithCollocationId:collId complete:^(NSArray *data, NSError *error) {
                [Toast hideToastActivity];
//                if (error) {
//                    return ;
//                }
//                [Toast makeToastSuccess:@"举报成功!"];
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
                                                           message:@"你确定删除吗？"
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定",nil];
            [alert show];
        }
    }
}
-(void)hiddenShowAlertView
{
    [showAlertView dismissWithClickedButtonIndex:0 animated:NO];//important
}

@end
