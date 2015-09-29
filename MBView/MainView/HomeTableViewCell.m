//
//  HomeTableViewCell.m
//  Wefafa
//
//  Created by su on 15/1/22.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "AppSetting.h"
#import "CommMBBusiness.h"
#import "MBShoppingGuideInterface.h"
#import "Utils.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "BaseViewController.h"

#import "HttpRequest.h"
#import "Toast.h"
#import "ShareCellView.h"
#import "CustomActionSheet.h"
#import "UIImageView+WebCache.h"

#define kLabelHeight 10
#define kFavButtonXPoint 60

@interface LevelView : UIView
@property(nonatomic,assign)NSInteger levelNum;
@end

@implementation LevelView{
    UILabel *_levelLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24.5, 11.5)];
        [imageView setImage:[UIImage imageNamed:@"levelBg@2x.png"]];
        [self addSubview:imageView];
        
        _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 0, 12.5, 11.5)];
        [_levelLabel setTextColor:[UIColor colorWithRed:0.424 green:0.282 blue:0.008 alpha:1.0]];
        [_levelLabel setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:11]];
        [_levelLabel setAdjustsFontSizeToFitWidth:YES];
        [_levelLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_levelLabel];
    }
    return self;
}

- (void)setLevelNum:(NSInteger)levelNum
{
    NSString *title = @"";
    if (levelNum < 10) {
        if (levelNum == 0) {
            levelNum = 1;
        }
        title = [NSString stringWithFormat:@"0%ld",(long)levelNum];
    } else {
        title = [NSString stringWithFormat:@"%ld",(long)levelNum];
    }
    [_levelLabel setText:title];
}

@end

@interface HomeTableViewCell ()<kHomeTagMapDelegate,kShareRelatedShareDelegate>{
    NSDictionary *_data;
    HomeSelectionModel *_homeModel;
    CustomActionSheet *actionView;
}
@property (nonatomic,strong) UIImageView *lookImage;
@property (nonatomic,strong) UIView *headerBg;
@property (nonatomic,strong) UIImageView *headerImage;
@property (nonatomic,strong) UILabel *nameLabel;
//@property (nonatomic,strong) UILabel *levelLabel;
//@property (nonatomic,strong) LevelView *levelImage;
@property (nonatomic,strong) UIButton *favButton;
//@property (nonatomic,strong) HomeStyleTableView *styleView;
//@property (nonatomic,strong) UILabel *lbTime;
//@property (nonatomic,strong) UIImageView *timeImg;
@property (nonatomic,strong) UIButton *btnShareNum;
@property (nonatomic,strong) UIButton *btnCommentNum;
//@property (nonatomic,strong) UILabel *lbCollocationName;
@property (nonatomic,strong) UILabel *detailLabel;
@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
//    return [self initWithStyle:style reuseIdentifier:reuseIdentifier isRight:NO cellHeight:0];
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.0]];
        _cornerView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, 409)];
        [_cornerView setBackgroundColor:[UIColor whiteColor]];
        [_cornerView.layer setCornerRadius:5.0];
        [_cornerView.layer setBorderColor:[UIColor clearColor].CGColor];
        [_cornerView.layer setBorderWidth:1.0];
        [_cornerView.layer setMasksToBounds:YES];
        [self.contentView addSubview:_cornerView];
        
        UIView *noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _cornerView.frame.size.width, 48)];
        UITapGestureRecognizer *notiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noticeTap)];
        [noticeView addGestureRecognizer:notiTap];
        [noticeView setBackgroundColor:[Utils HexColor:0XFFDE00 Alpha:1.0]];
        [_cornerView addSubview:noticeView];
        
        UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _cornerView.frame.size.width-20, 48)];
        [noticeLabel setBackgroundColor:[Utils HexColor:0XFFDE00 Alpha:1.0]];
        [noticeLabel setTextColor:[UIColor blackColor]];
        [noticeLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [noticeLabel setNumberOfLines:2];
        [noticeView addSubview:noticeLabel];
        [noticeLabel setText:@"明星达人推荐了一些搭配卡片，你还不快点去分享！机会难得呦！"];
        
        _cellSubView = [[UIView alloc] initWithFrame:_cornerView.bounds];
        [_cellSubView setBackgroundColor:[UIColor whiteColor]];
        [_cornerView addSubview:_cellSubView];
        
        _headerBg = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 50, 45)];
        [_headerBg setBackgroundColor:[UIColor whiteColor]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onShowMyHomepage:)];
        [_headerBg addGestureRecognizer:tap];
        [_cellSubView addSubview:_headerBg];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH - 30, 0.5)];
        line1.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.0];
        [_cellSubView addSubview:line1];
        
        _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 35, 35)];
        [self setCornerWith:_headerImage radius:35/2 borderColor:[UIColor whiteColor]];
        [_headerBg addSubview:_headerImage];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, SCREEN_WIDTH - 120, 35)];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]];
        [_headerBg addSubview:_nameLabel];
        
        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(_cornerView.frame.size.width - 40, 17, 6, 11)];
        [arrowImg setImage:[UIImage imageNamed:@"home_left_arrow@2x.png"]];
        [_headerBg addSubview:arrowImg];
        
        _lookImage=[[UIImageView alloc] initWithFrame:CGRectMake(25, 55, _cornerView.frame.size.width -50, 270)];
        [_lookImage setContentMode:UIViewContentModeScaleAspectFit];
        [_cellSubView addSubview:_lookImage];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 335, _cornerView.frame.size.width, 0.5)];
        line2.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.0];
        [_cellSubView addSubview:line2];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 336, _cornerView.frame.size.width-20, 30)];
        [_detailLabel setBackgroundColor:[UIColor whiteColor]];
        [_detailLabel setTextColor:[Utils HexColor:0X919191 Alpha:1.0]];
        [_detailLabel setTextAlignment:NSTextAlignmentLeft];
        [_detailLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_cellSubView addSubview:_detailLabel];
        [_detailLabel setText:@"dldkdkdkdkdkdkdk"];
        
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(10, 366, _cornerView.frame.size.width-20, 0.5)];
        line3.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.0];
        [_cellSubView addSubview:line3];

        
        UIView *shareBg = [[UIView alloc] initWithFrame:CGRectMake(0, 369,SCREEN_WIDTH - 30, 40)];//35
        [shareBg setBackgroundColor:[UIColor whiteColor]];
        [_cellSubView addSubview:shareBg];
        
        CGFloat btnXPoint = 100;
        _favButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_favButton setFrame:CGRectMake(40 , 7, btnXPoint, 25)];
        UIImageView *favImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 18, 15)];
        [favImage setImage:[UIImage imageNamed:@"btn_like_normal@2x.png"]];
        [favImage setTag:100];
        [_favButton addSubview:favImage];
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 80, 25)];
        [numLabel setTag:200];
        [numLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [numLabel setTextColor:[UIColor blackColor]];
        [numLabel setTextAlignment:NSTextAlignmentLeft];
        [_favButton addSubview:numLabel];
        [numLabel setText:@"点赞"];
        [_favButton addTarget:self action:@selector(favButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareBg addSubview:_favButton];
        
        //chengyb分享
        _btnShareNum = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnShareNum setFrame:CGRectMake(_cornerView.frame.size.width - btnXPoint, 7,btnXPoint, 25)];
        UIImageView *shareImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 15, 15)];
        [shareImage setImage:[UIImage imageNamed:@"btn_detail_share@2x.png"]];
        [shareImage setTag:100];
        [_btnShareNum addSubview:shareImage];
        UILabel *numLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 25)];
        [numLabel2 setTag:200];
        [numLabel2 setFont:[UIFont boldSystemFontOfSize:14]];
        [numLabel2 setTextColor:[UIColor blackColor]];
        [numLabel2 setTextAlignment:NSTextAlignmentCenter];
        [_btnShareNum addSubview:numLabel2];
        [numLabel2 setText:@"分享"];
        [_btnShareNum addTarget:self action:@selector(shareChannel:) forControlEvents:UIControlEventTouchUpInside];
        [shareBg addSubview:_btnShareNum];
        
    }
    return self;
}

- (void)favButtonClick:(UIButton *)btn
{
    if ([BaseViewController pushLoginViewController]){
        [Toast makeToastActivity:@"正在获取数据" hasMusk:YES];
        [self favourHandleType:_homeModel.isFavorite sourceId:_homeModel.idValue];
    }
}

- (void)favourHandleType:(BOOL)isDelete sourceId:(NSString *)source_id
{
    NSString *soureceKey = isDelete ? @"sourceIdS" : @"SOURCE_ID";
    NSDictionary *param=@{
                          soureceKey:[NSString stringWithFormat:@"%@",source_id],
                          @"userId":sns.ldap_uid,
                          @"SOURCE_TYPE":@"2",
                          @"Create_User":sns.myStaffCard.nick_name
                          };
    NSString *methodName = isDelete ? @"FavoriteDelete" :@"FavoriteCreate";
    [HttpRequest orderPostRequestPath:nil methodName:methodName params:param success:^(NSDictionary *dict) {
        if ([[dict objectForKey:@"isSuccess"] boolValue]) {
            if (isDelete) {
                _homeModel.favoritCount -= 1;
                _homeModel.isFavorite = NO;
            }else{
                _homeModel.favoritCount += 1;
                _homeModel.isFavorite = YES;
            }
            
            [self updateFrameWithButton:_favButton number:_homeModel.favoritCount isRight:NO];
        }
        [Toast hideToastActivity];
    } failed:^(NSError *error) {
        [Toast hideToastActivity];
    }];
}

- (void)updateHomeCell:(HomeSelectionModel*)model isFristRow:(BOOL)isFirstRow
{
    CGRect frame = _cellSubView.frame;
    
    if (!isFirstRow) {
        if (frame.origin.y==0) {
            frame.origin.y = 48;
            _cellSubView.frame = frame;
            [_cornerView setFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, 457)];
        }
    }else{
        if (frame.origin.y == 48) {
            frame.origin.y = 0;
            _cellSubView.frame = frame;
            [_cornerView setFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, 409)];
        }
    }
    [self updateHomeCell:model];
}

- (void)updateHomeCell:(HomeSelectionModel*)model
{
    
    _homeModel = model;
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:model.headPortrait] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    
    [_nameLabel setText:[NSString stringWithFormat:@"%@的店",model.storeInfo.storeName]];
    
    
    UIActivityIndicatorView *view = (UIActivityIndicatorView *)[_lookImage viewWithTag:1111];
    if (!view) {
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
        activity.center = CGPointMake((self.frame.size.width-30)/2, 100);
        activity.tag = 1111;
        [_lookImage addSubview:activity];
        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [activity startAnimating];
    }else{
        [view startAnimating];
    }
    
    __weak typeof(self) weakSelf = self;
    [_lookImage setImage:[UIImage imageNamed:@"home_cell_default@2x.png"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:model.pictureUrl]];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        [_lookImage setImageAFWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            if (image) {
                [weakSelf performSelectorOnMainThread:@selector(removeActivity:) withObject:image waitUntilDone:NO];
//                [weakSelf removeActivity:image];
            }else{
                [weakSelf performSelectorOnMainThread:@selector(removeActivity:) withObject:nil waitUntilDone:NO];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//            [weakSelf removeActivity:nil];
            [weakSelf performSelectorOnMainThread:@selector(removeActivity:) withObject:nil waitUntilDone:NO];
        }];
    });
   
    
    NSString *detailStr = [NSString stringWithFormat:@"%d 浏览 %ld 点赞 %ld 分享",100,(long)model.favoritCount,(long)model.sharedCount];
    [_detailLabel setText:detailStr];
//    [self updateFrameWithButton:_favButton number:model.favoritCount isRight:NO];
//    [self updateFrameWithButton:_btnShareNum number:model.sharedCount isRight:YES];
}

//根据 数量 改变 图片和 label 的 位置 ，是否 靠右对齐
- (void)updateFrameWithButton:(UIButton *)btn number:(NSInteger)num isRight:(BOOL)isRight
{
    UILabel *aLabel = (UILabel *)[btn viewWithTag:200];
    UIImageView *imgView = (UIImageView *)[btn viewWithTag:100];
    if (isRight) {
//        CGSize vodeSize = [[NSString stringWithFormat:@"%d",num] sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(200, 20)];
        
       CGSize vodeSize = [[NSString stringWithFormat:@"%ld",(long)num] boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        
        CGRect favFrame = btn.frame;
        [aLabel setFrame:CGRectMake(favFrame.size.width - vodeSize.width, 0, vodeSize.width, favFrame.size.height)];
        [imgView setFrame:CGRectMake(favFrame.size.width - vodeSize.width-25, 6, 15, 15)];
    }else{
        if (_homeModel.isFavorite) {
            [imgView setImage:[UIImage imageNamed:@"btn_like_pressed@2x.png"]];
        }else{
            [imgView setImage:[UIImage imageNamed:@"btn_like_normal@2x.png"]];
        }
    }
    
    [aLabel setText:[NSString stringWithFormat:@"%ld",(long)num]];
}

- (void)removeActivity:(UIImage *)image
{
    if (image) {
        [_lookImage setImage:image];
    }
    UIActivityIndicatorView *view = (UIActivityIndicatorView *)[_lookImage viewWithTag:1111];
    if (view) {
        [view stopAnimating];
//        [view removeFromSuperview];
//        view  =nil;
    }
}

- (void)setCornerWith:(UIView *)view radius:(CGFloat)radius borderColor:(UIColor *)color
{
    [view.layer setCornerRadius:radius];
    [view.layer setBorderColor:color.CGColor];
    [view.layer setBorderWidth:0.5];
    [view.layer setMasksToBounds:YES];
}

- (void)updateButton:(UIButton *)button withNumber:(NSInteger)count
{
//     CGSize vodeSize = [[NSString stringWithFormat:@"%d",count] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 20)];
    CGSize vodeSize = [[NSString stringWithFormat:@"%ld",(long)count] boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil].size;
    UILabel *aLabel = (UILabel *)[button viewWithTag:200];
    UIImageView *imgView = (UIImageView *)[button viewWithTag:100];
    
    CGFloat xPoint = (button.frame.size.width -26 - vodeSize.width) / 2;
    [imgView setFrame:CGRectMake(xPoint, 7, 15, 15)];
    [aLabel setFrame:CGRectMake(xPoint + 26, 5, vodeSize.width, 20)];
    [aLabel setText:[NSString stringWithFormat:@"%ld",(long)count]];
}

//更新 收藏数量
- (void)updateFavButtonWithFavNum:(UIButton *)btn number:(NSInteger)num
{
//    CGSize vodeSize = [[NSString stringWithFormat:@"%d",num] sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(200, 20)];
    CGSize vodeSize = [[NSString stringWithFormat:@"%ld",(long)num] boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName] context:nil].size;
    UILabel *aLabel = (UILabel *)[btn viewWithTag:200];
    UIImageView *imgView = (UIImageView *)[btn viewWithTag:100];
    CGRect favFrame = btn.frame;
    CGFloat aWidth = 25 + vodeSize.width;
    if (aWidth > kFavButtonXPoint) {
        
        if (aWidth > self.frame.size.width / 3 - 20) {
            aWidth = self.frame.size.width / 3 - 20;
        }
        CGFloat xPoint = 0;
        if (favFrame.origin.x < self.frame.size.width / 3.0) {
            xPoint = 15;
        }else if (favFrame.origin.x >= self.frame.size.width / 3.0 * 2){
            xPoint = self.frame.size.width - aWidth - 15;
        }else {
            xPoint = (self.frame.size.width / 3.0 - aWidth) / 2 + self.frame.size.width / 3 ;
        }
        favFrame.origin.x = xPoint;
        favFrame.size.width = aWidth;
        btn.frame = favFrame;
    }
    CGFloat xPoint = 10;
    [imgView setFrame:CGRectMake(xPoint, 5, 15, 15)];
    [aLabel setFrame:CGRectMake(xPoint + 20, 0, favFrame.size.width - xPoint - 20, 25)];
    [aLabel setText:[NSString stringWithFormat:@"%ld",(long)num]];
}

- (void)kDidSelecttIndexHomeTag:(NSDictionary *)dict indexRow:(NSInteger)indexRow
{
    if (_delegate && [_delegate respondsToSelector:@selector(kHomeTagDidSelect:indexRow:)]) {
        [_delegate kHomeTagDidSelect:dict indexRow:indexRow];
    }
}

- (void)noticeTap
{}

- (void)onShowMyHomepage:(id)sender
{
}

- (void)shareChannel:(UIButton *)btn
{

    
    if ([BaseViewController pushLoginViewController]) {
        
        ShareData *aData = [[ShareData alloc] init];
        
        NSString *shareUrl=[NSString stringWithFormat:@"%@",SHARE_URL];
        NSString *detailUrlStr= [NSString stringWithFormat:@"%@",shareUrl];
        NSString *lastStr = [detailUrlStr substringFromIndex:detailUrlStr.length-1];
        
        NSString *noLastUrlStr=detailUrlStr;
        
        if ([lastStr isEqualToString:@"?"]) {
            
            noLastUrlStr = [detailUrlStr substringToIndex:detailUrlStr.length-1];
            
        }
        
        shareUrl=[NSString stringWithFormat:@"%@",noLastUrlStr];
        
        NSString *jsonWeb =[NSString stringWithFormat:@"&f_code=co_detail&collocalID=%@",[Utils getSNSInteger:_homeModel.idValue]];
        
        NSString * web_urlStr = [shareUrl stringByAppendingFormat:@"%@",jsonWeb];
        aData.shareUrl = web_urlStr;
               aData.image = [Utils reSizeImage:_lookImage.image toSize:CGSizeMake(57,57)];
        aData.descriptionStr =  [NSString stringWithFormat:@"%@",_homeModel.detailStr];
        
        ShareRelated *share = [ShareRelated sharedShareRelated];
        [share showInTarget:_target withData:aData];
    }

    
    
}

- (void)kShareRelatedDidClickShareButtonWithType:(ShareReatedType)type
{
    if (_delegate && [_delegate respondsToSelector:@selector(kShareWityType:withRow:)]) {
        [_delegate kShareWityType:type withRow:_row];
    }
}

@end
