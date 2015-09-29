//
//  BrandDetailCollectionViewCell.m
//  Wefafa
//
//  Created by wave on 15/8/4.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "BrandDetailCollectionViewCell.h"
#import "SCollocationDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "SUtilityTool.h"
#import "SDataCache.h"
#import "SCVideoPlayerView.h"
#import "CommentsViewController.h"
#import "SCollocationLoversController.h"
#import "WeFaFaGet.h"
#import "ShareRelated.h"
#import "MBShoppingGuideInterface.h"
#import "MBSettingMainViewController.h"

#import "SCollocationDetailNoneShopController.h"

@interface BrandDetailCollectionViewCell()<UIActionSheetDelegate,UIAlertViewDelegate>{
    UIImageView *p_headImgView;
    UILabel *p_nameLabel;
    UILabel *p_beforeTime;
    UIImageView *p_clockView;
    UIImageView *p_bigImgView;
    UIImageView *p_likeView;
    UIImageView *p_stickerView;
    UIImageView *vipImgView;
    //    UILabel *p_likeNumUpLabel;
    UILabel *p_likeNumDownLabel;
    UILabel *p_textContentLabel;
    
    //    UIButton *p_likeBigBtn;
    UIButton *p_likeSmallBtn;
    
    UIView *p_likePeopleView;
    UIView *p_buttonListView;
    
    //初始化时各个组件的y轴坐标
    float p_textContentLabelY;
    float p_likePeopleViewY;
    float p_buttonListViewY;
    
    SCVideoPlayerView *playerView;
    
    SMDataModel *dataModel;
    NSMutableArray *tagViewArr;
    UIButton *tagControlBtn;
    UIAlertView * showAlertView;
}



@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation BrandDetailCollectionViewCell

#define LIKE_BG_TAG  100001
#define TAG_CONTROLLBTN_TAG 109000

- (instancetype)init {
    if (self == [super init]) {
        CGRect cellRect = [UIScreen mainScreen].bounds;
        UIFont *fontStyle = [UIFont systemFontOfSize:17];
        
        NSInteger offset = 0;
        NSString *tempStr;
        CGSize labelSize;
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, offset, cellRect.size.width, 142/2)];
        contentView.backgroundColor = [UIColor whiteColor];
        UIImageView *tempView = [[UIImageView alloc]initWithImage:nil];
        tempView.frame = CGRectMake(10, contentView.frame.size.height/2 - 90/2/2, 90/2, 90/2);
        tempView.layer.cornerRadius = tempView.frame.size.height/2;
        tempView.clipsToBounds = YES;
        [contentView addSubview:tempView];
        tempView.userInteractionEnabled = YES;
        [SUTILITY_TOOL_INSTANCE addViewAction:tempView target:self action:@selector(onEnterDesigner:)];
        
        p_headImgView = tempView;
        
        vipImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10+p_headImgView.frame.size.width - 11, p_headImgView.frame.origin.y + p_headImgView.frame.size.height - 12, 12, 12)];
        [vipImgView setImage:[UIImage imageNamed:@"Unico/v"]];
        //    [vipImgView setHidden:YES];
        vipImgView.layer.cornerRadius=vipImgView.frame.size.width/ 2;
        vipImgView.layer.borderWidth = 1.0;
        vipImgView.layer.borderColor = [UIColor whiteColor].CGColor;
        vipImgView.layer.masksToBounds = YES;
        [contentView addSubview:vipImgView];
        
        labelSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle: tempStr fontStyle:fontStyle];
        UILabel *tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(tempView.frame.size.width+10+10,0, contentView.frame.size.width/2, contentView.frame.size.height)];
        tempLabel.text = tempStr;
        tempLabel.textColor = COLOR_C2;
        tempLabel.font = FONT_T2;
        [contentView addSubview:tempLabel];
        p_nameLabel = tempLabel;
        
        //时间
        labelSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:tempStr fontStyle:nil];
        
        tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(contentView.frame.size.width-10-labelSize.width,0, labelSize.width, contentView.frame.size.height)];
        tempLabel.text = tempStr;
        tempLabel.textColor = COLOR_C7;
        tempLabel.font = FONT_t7;
        [contentView addSubview:tempLabel];
        
        p_clockView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/icon_clock" rect:CGRectMake(UI_SCREEN_WIDTH - tempLabel.width - 20/2 - 24/2-10/2, tempLabel.height/2-24/2/2, 24/2, 24/2)];
        [contentView addSubview:p_clockView];
        
        p_beforeTime = tempLabel;
        
        
        [self addSubview:contentView];
        offset += contentView.frame.size.height;
        //show图
        tempView = [[UIImageView alloc]initWithImage:nil];
        tempView.frame = CGRectMake(0, offset, cellRect.size.width, 818/2);
        p_bigImgView = tempView;
        [SUTILITY_TOOL_INSTANCE addViewAction:tempView target:self action:@selector(enterCollocationView:)];
        
        [self addSubview:tempView];
        
        
        // FIXME,TODO: 喜欢标签貌似加在大图bg上了。
        p_stickerView = [[UIImageView alloc]initWithImage:nil];
        [p_stickerView setOrigin:CGPointZero];
        //    [self addSubview:p_stickerView];
        
        //offset += tempView.frame.size.height;
        offset += 5;
        
        //主题内容介绍
        labelSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:tempStr fontStyle:[UIFont systemFontOfSize:15] textWidth:cellRect.size.width-20];
        tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(10,offset, cellRect.size.width-20, labelSize.height)];
        tempLabel.text = tempStr;
        tempLabel.numberOfLines = 10;
        tempLabel.font = FONT_t3;
        tempLabel.textColor = COLOR_C2;
        [self  addSubview:tempLabel];
        //不添加高度，更新后另外计算
        // offset += tempLabel.frame.size.height;
        //    offset += 15;
        p_textContentLabel = tempLabel;
        p_textContentLabelY = p_textContentLabel.frame.origin.y;
        
        contentView =  [[UIView alloc] initWithFrame:CGRectMake(0, offset, cellRect.size.width, 35)];
        [self addSubview:contentView];
        NSInteger tempInt = 10;
        
        p_likePeopleView = contentView;
        p_likePeopleViewY = p_likePeopleView.frame.origin.y;
        
        UIImageView *tempBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"like_num_bg2"]];
        tempBg.frame = CGRectMake(tempInt,contentView.frame.size.height/2-40/2/2, 107/2, 40/2);
        [contentView addSubview:tempBg];
        tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(20,0, tempBg.frame.size.width-20, tempBg.frame.size.height)];
        tempLabel.font = FONT_t6;
        tempLabel.textColor = COLOR_C7;
        [tempBg  addSubview:tempLabel];
        p_likeNumDownLabel = tempLabel;
        
        offset += contentView.frame.size.height;
        offset += 5;
        //4个按钮
        contentView =  [[UIView alloc] initWithFrame:CGRectMake(0, offset, cellRect.size.width, 72/2+1+28/2)];
        [self addSubview:contentView];
        //加个线
        UIView *tempUI = [SUTILITY_TOOL_INSTANCE getNormalLineBySize:cellRect.size.width height:1 color:UIColorFromRGB(0xf2f2f2)];
        [contentView addSubview:tempUI];
        
        NSArray *tempAry = @[@"icon_comment2",@"icon_like2",@"icon_share2",@"icon_report2"];
        NSInteger btnWidth = (cellRect.size.width-3)/4;
        
        NSArray *funStrAry = @[
                               NSStringFromSelector(@selector(commentContent:)),
                               NSStringFromSelector(@selector(likeContent:)),
                               NSStringFromSelector(@selector(shareContent:)),
                               NSStringFromSelector(@selector(reportContent:))
                               ];
        
        
        UIButton *tempBtn;
        for (int i = 0; i<[tempAry count]; i++) {
            tempBtn = [[UIButton alloc]initWithFrame:CGRectMake(0+i*(btnWidth+1), 1, btnWidth, contentView.frame.size.height - 28/2)];
            SEL callback = NSSelectorFromString(funStrAry[i]);
            [tempBtn addTarget:self action:callback forControlEvents:UIControlEventTouchUpInside];
            [tempBtn setImage:[UIImage imageNamed:tempAry[i]] forState:UIControlStateNormal];
            tempUI = [SUTILITY_TOOL_INSTANCE getNormalLineByRect:CGRectMake(0+i*btnWidth, 1, 1, contentView.frame.size.height-28/2)  color:UIColorFromRGB(0xf2f2f2)];
            [contentView addSubview:tempUI];
            [contentView addSubview:tempBtn];
            if (i == 1) {
                p_likeSmallBtn = tempBtn;
            }
        }
        tempUI = [[UIView alloc] initWithFrame:CGRectMake(0, 72/2+1, cellRect.size.width, 28/2)];
        tempUI.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [contentView addSubview:tempUI];
        p_buttonListView = contentView;
        p_buttonListViewY = p_buttonListView.frame.origin.y;
        offset += contentView.frame.size.height;
        
        self.cellAdditionalHeight = 0;
        self.cellHeight = offset;
        
        tagControlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tagControlBtn setFrame:CGRectMake(UI_SCREEN_WIDTH - 42, 84, 30, 30)];
        [tagControlBtn setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
        tagControlBtn.hidden=YES;
        tagControlBtn.tag= TAG_CONTROLLBTN_TAG;
        [tagControlBtn addTarget:self action:@selector(controlTagState:) forControlEvents:UIControlEventTouchUpInside];
        [tagControlBtn setImage:[UIImage imageNamed:@"Unico/icon_showtag"] forState:UIControlStateNormal];
        [tagControlBtn setImage:[UIImage imageNamed:@"Unico/icon_hidetag"] forState:UIControlStateSelected];
        [self addSubview:tagControlBtn];
        
        [tagControlBtn setSelected:YES];
        
        tagViewArr = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

-(SCVideoPlayerView*)getPlayerView{
    if (!playerView) {
        SCPlayer *player = [SCPlayer player];
        player.loopEnabled = YES;
        player.muted = YES;
        playerView = [[SCVideoPlayerView alloc] initWithPlayer:player];
        playerView.userInteractionEnabled = NO;
        [playerView setOrigin:CGPointZero];
        playerView.size = p_bigImgView.size;
    }
    return playerView;
}

-(void)removeVideo{
    @autoreleasepool {
        if (playerView) {
            [playerView.player pause];
            [playerView removeFromSuperview];
            playerView = nil;
        }
    };
    
}

-(void)updateCellUI:(NSInteger)index{
    // NSLog(@"%@",self.cellData);
    UIImageView *tempView;
    CGSize labelSize;
    self.cellIndex = index;
    if (self.cellData.count <= 0) {
        return;
    }
    self.cellAdditionalHeight = 0;
    float offset = 0;
    //头像
    NSString *tempStr =@"";
    NSString *headImgViewStr=@"";
    tempStr = self.cellData[@"nick_name"];
    headImgViewStr = self.cellData[@"head_img"];
    
    //解决有时候自己发布的搭配的名字与 顶部展示名字不一样的bug  头像
    if([self.cellData[@"user_id"] isEqualToString:sns.ldap_uid])
    {
        tempStr = sns.myStaffCard.nick_name;
        headImgViewStr = sns.myStaffCard.photo_path;
    }
    if(!_noImage)[p_headImgView sd_setImageWithURL:[NSURL URLWithString:headImgViewStr] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    NSString *  head_v_type =[NSString stringWithFormat:@"%@",self.cellData[@"head_v_type"]];
    switch ([head_v_type integerValue]) {
        case 0:
        {
            vipImgView.hidden=YES;
        }
            break;
        case 1:
        {
            vipImgView.hidden=NO;
            [vipImgView setImage:[UIImage imageNamed:@"brandvip@2x"]];
        }
            break;
        case 2:
        {
            [vipImgView setImage:[UIImage imageNamed:@"peoplevip@2x"]];
            vipImgView.hidden=NO;
        }
            break;
        default:
            break;
    }
    
    p_nameLabel.text = tempStr;
    
    tempStr = self.cellData[@"create_time"];
    tempStr = [SUTILITY_TOOL_INSTANCE getTimeByTodayWithString:tempStr];
    //重新设置坐标和长度
    labelSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:tempStr fontStyle:FONT_t7];
    p_beforeTime.text = tempStr;
    [p_beforeTime setWidth:labelSize.width];
    [p_beforeTime setOrigin:CGPointMake(UI_SCREEN_WIDTH - 10 - p_beforeTime.width, p_beforeTime.frame.origin.y)];
    [p_clockView setOrigin:CGPointMake(p_beforeTime.frame.origin.x - 10/2-p_clockView.width, p_clockView.frame.origin.y)];
    
    //改变like按钮的颜色
    if (![self.cellData[@"is_love"] boolValue]){
        [self setLikeBtnStatus:NO];
    }else{
        [self setLikeBtnStatus:YES];
    }
    
    tempStr = self.cellData[@"like_count"];
    p_likeNumDownLabel.text = tempStr;
    
    float width = [self.cellData[@"img_width"] floatValue];
    float height = [self.cellData[@"img_height"] floatValue];
    
    if (width <= 0) {
        width = UI_SCREEN_WIDTH;
    }
    
    if (height<= 0) {
        height = UI_SCREEN_WIDTH;
    }
    
    tempStr = self.cellData[@"img"];
    CGSize size = CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_WIDTH/width*height);
    
    
    [p_bigImgView setContentMode:UIViewContentModeScaleToFill];
    //图片 过大
    //    [p_bigImgView setContentMode:UIViewContentModeScaleAspectFit];
    
    [p_bigImgView setSize:size];
    offset += p_bigImgView.height;
    
    //重用时，清除所有标签
    for(UIView *view in [p_bigImgView subviews])
    {
        if (view.tag == LIKE_BG_TAG) {
            continue;
        }
        if (view.tag==TAG_CONTROLLBTN_TAG) {
            continue;
        }
        [view removeFromSuperview];
    }
    
    // 视频和贴纸
    // Video，因为Cell Reuse的关系，理论上最多存在2个AVPlayer。
    // TODO：但是足够引起内存压力rr
    
    if( [_cellData[@"video_url"] length] > 0){
        SCVideoPlayerView *view = [self getPlayerView];
        [view setSize:size];
        [p_bigImgView addSubview:view];
        // TODO：FIXME ：部分模拟器会崩溃
#if TARGET_IPHONE_SIMULATOR
        view.hidden = YES;
#else
        [view.player pause];
        [view.player setItemByStringPath:_cellData[@"video_url"]];
        [view.player play];
        view.hidden = NO;
#endif
    } else {
        //        [view.player pause];
        [playerView.player pause];
        playerView.hidden = YES;
        
        // 这里是请求符合屏幕宽度的图片，避免不清晰，并且减少非必要流量
        //        tempStr = [NSString stringWithFormat:@"%@?imageView2/1/w/%d/h/%d",tempStr,(int)width,(int)height];
        // 这里用水印合成，图可以不用再加载stiker层，但是就不能拉尺寸了。
        // 水印有问题，暂时不用
        //        tempStr = [SUTIL getWatermarkImageURL:self.cellData];
    }
    
    // 此处代码比较乱，注意顺序。
    if(!_noImage)[p_bigImgView sd_setImageWithURL:[NSURL URLWithString:tempStr]];
    
    
    // Sticker，图片已经用水印解决，暂时只有视频用贴纸。
    if ([_cellData[@"stick_img_url"] length] > 0 ) {
        // png 不行
        //        if(!_noImage)[p_stickerView sd_setImageWithURL:[NSURL URLWithString:stickUrl]];
        if(!_noImage)[p_stickerView sd_setImageWithURL:[NSURL URLWithString:_cellData[@"stick_img_url"]]];
        [p_stickerView setSize:size];
        [p_bigImgView addSubview:p_stickerView];
        //        [self bringSubviewToFront:p_stickerView];
    } else {
        [p_stickerView setImage:nil];
    }
    
    // 喜欢的view提上来
    UIView *likeView = [p_bigImgView viewWithTag:LIKE_BG_TAG];
    [p_bigImgView addSubview:likeView];
    
    if (self.cellData[@"tag_list"]) {
        NSArray *tagArr = [SUTILITY_TOOL_INSTANCE getArray:self.cellData[@"tag_list"]];
        
        if ([tagArr isKindOfClass:[NSArray class]]) {
            
            if ([tagArr count]==0) {
                tagControlBtn.hidden=YES;
            }
            else
            {
                tagControlBtn.hidden=NO;
                
            }
            for (int i =0; i<tagArr.count; i++) {
                NSDictionary *tempDic = tagArr[i];
                
                //UIImageView *imgView = [[SUtilityTool shared] addTagWithDict:tempDic inView:p_bigImgView limited:YES];
                //[tagViewArr addObject:imgView]; 之前代码
                
                CoverStickerView *stickerView = [[SUtilityTool shared] addTagWithDict:tempDic inView:p_bigImgView];
                [tagViewArr addObject:stickerView];
            }
            
        }
        
        if (dataModel.isHidden) {
            tagControlBtn.hidden=NO;
            [tagControlBtn setSelected:NO];
            for(UIImageView *imgV in tagViewArr)
            {
                [imgV setHidden:YES];
            }
        }
        else
        {
            [tagControlBtn setSelected:YES];
        }
    }
    else
    {
        tagControlBtn.hidden=YES;
    }
    
    
    
    
    tempStr = self.cellData[@"content_info"];
    labelSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:tempStr fontStyle:FONT_SIZE(15) textWidth:UI_SCREEN_WIDTH-20];
    
    [p_textContentLabel setText:tempStr];
    //更改坐标
    [p_textContentLabel setOrigin:CGPointMake(p_textContentLabel.frame.origin.x, p_textContentLabelY + offset)];
    [p_textContentLabel setHeight:labelSize.height];
    
    offset += p_textContentLabel.height;
    
    //点赞的人的头像
    for(UIView *view in [p_likePeopleView subviews])
    {
        [view removeFromSuperview];
    }
    //更改坐标
    [p_likePeopleView setOrigin:CGPointMake(p_likePeopleView.frame.origin.x, p_likePeopleViewY + offset)];
    
    NSInteger tempInt = 10;
    UIView *tempBg;
    UILabel *tempLabel;
    //    UIImageView *vipImg;
    //喜欢的人的头像
    if (self.cellData[@"like_user_list"]) {
        
        NSArray *data = (NSArray*) self.cellData[@"like_user_list"];
        for (int i = 0; i<data.count; i++) {
            //tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic1"]];
            tempView = [UIImageView new];
            tempStr = data[i][@"head_img"];
            if(!_noImage)[tempView sd_setImageWithURL:[NSURL URLWithString:tempStr] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
            tempView.frame = CGRectMake(tempInt, p_likePeopleView.frame.size.height/2 - 15, 30, 30);
            tempView.layer.cornerRadius = tempView.frame.size.height/2;
            tempView.clipsToBounds = YES;
            [p_likePeopleView addSubview:tempView];
            
            UIImageView *vipImg = [[UIImageView alloc] initWithFrame:CGRectMake(10+tempInt+25 - 11, p_likePeopleView.frame.size.height/2 - 15 + 30 - 12, 12, 12)];
            vipImg.layer.cornerRadius=vipImg.frame.size.width/ 2;
            vipImg.layer.borderWidth = 1.0;
            vipImg.layer.borderColor = [UIColor whiteColor].CGColor;
            vipImg.layer.masksToBounds = YES;
            [p_likePeopleView addSubview:vipImg];
            NSString *listHead_v_type = [NSString stringWithFormat:@"%@",data[i][@"head_v_type"]];
            
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
            
            tempView.tag = BASE_BTN_TAG + i;
            [SUTILITY_TOOL_INSTANCE addViewAction:tempView target:self action:@selector(onLikeOther:)];
            tempInt += 30;
            tempInt += 5;
            if ((UI_SCREEN_WIDTH - tempInt - 107/2 - 30) < 10) {
                break;
            }
        }
        
        
        tempBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"like_num_bg2"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCollocationLovers)];
        [tempBg addGestureRecognizer:tap];
        [tempBg setUserInteractionEnabled:YES];
        tempBg.frame = CGRectMake(tempInt,p_likePeopleView.frame.size.height/2-40/2/2, 107/2, 40/2);
        [p_likePeopleView addSubview:tempBg];
        tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(20,0, tempBg.frame.size.width-20, tempBg.frame.size.height)];
        tempLabel.text = self.cellData[@"like_count"];
        tempLabel.font = FONT_SIZE(12);
        tempLabel.textColor = COLOR_C2;
        [tempBg  addSubview:tempLabel];
    }
    //更改坐标
    [p_buttonListView setOrigin:CGPointMake(0, p_buttonListViewY+offset)];
    self.cellAdditionalHeight = offset;
    
}

-(void)updateCellUIWithModel:(SMDataModel *)model atIndex:(NSInteger)index{
    // NSLog(@"%@",self.cellData);\\\
    
    
    
    UIImageView *tempView;
    CGSize labelSize;
    self.cellIndex = index;
    if (!model) {
        return;
    }
    dataModel = model;
    self.cellAdditionalHeight = 0;
    float offset = 0;
    //头像
    NSString *tempStr =@"";
    NSString *headImgViewStr=@"";
    tempStr = model.nick_name;
    headImgViewStr = model.head_img;
    
    //解决有时候自己发布的搭配的名字与 顶部展示名字不一样的bug  头像
    if([model.user_id isEqualToString:sns.ldap_uid])
    {
        tempStr = sns.myStaffCard.nick_name;
        headImgViewStr = sns.myStaffCard.photo_path;
    }
    if(!_noImage)[p_headImgView sd_setImageWithURL:[NSURL URLWithString:headImgViewStr] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    
    
    NSString *  head_v_type =[NSString stringWithFormat:@"%@",dataModel.head_v_type];
    switch ([head_v_type integerValue]) {
        case 0:
        {
            vipImgView.hidden=YES;
        }
            break;
        case 1:
        {
            vipImgView.hidden=NO;
            [vipImgView setImage:[UIImage imageNamed:@"brandvip@2x"]];
        }
            break;
        case 2:
        {
            [vipImgView setImage:[UIImage imageNamed:@"peoplevip@2x"]];
            vipImgView.hidden=NO;
        }
            break;
        default:
            break;
    }
    
    
    p_nameLabel.text = tempStr;
    
    tempStr = model.create_time;
    tempStr = [SUTILITY_TOOL_INSTANCE getTimeByTodayWithString:tempStr];
    //重新设置坐标和长度
    labelSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:tempStr fontStyle:FONT_t7];
    p_beforeTime.text = tempStr;
    [p_beforeTime setWidth:labelSize.width];
    [p_beforeTime setOrigin:CGPointMake(UI_SCREEN_WIDTH - 10 - p_beforeTime.width, p_beforeTime.frame.origin.y)];
    [p_clockView setOrigin:CGPointMake(p_beforeTime.frame.origin.x - 10/2-p_clockView.width, p_clockView.frame.origin.y)];
    
    //改变like按钮的颜色
    if (![model.is_love boolValue]){
        [self setLikeBtnStatus:NO];
    }else{
        [self setLikeBtnStatus:YES];
    }
    
    tempStr = model.like_count;
    p_likeNumDownLabel.text = tempStr;
    
    float width = [model.img_width floatValue];
    float height = [model.img_height floatValue];
    
    if (width <= 0) {
        width = UI_SCREEN_WIDTH;
    }
    
    if (height<= 0) {
        height = UI_SCREEN_WIDTH;
    }
    
    tempStr = model.img;
    CGSize size = CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_WIDTH/width*height);
    
    
    [p_bigImgView setContentMode:UIViewContentModeScaleToFill];
    [p_bigImgView setSize:size];
    offset += p_bigImgView.height;
    
    //重用时，清除所有标签
    for(UIView *view in [p_bigImgView subviews])
    {
        if (view.tag == LIKE_BG_TAG) {
            continue;
        }
        [view removeFromSuperview];
    }
    // 视频和贴纸
    // Video，因为Cell Reuse的关系，理论上最多存在2个AVPlayer。
    // TODO：但是足够引起内存压力rr
    
    if( [model.video_url length] > 0){
        SCVideoPlayerView *view = [self getPlayerView];
        [view setSize:size];
        [p_bigImgView addSubview:view];
        // TODO：FIXME ：部分模拟器会崩溃
#if TARGET_IPHONE_SIMULATOR
        view.hidden = YES;
#else
        [view.player pause];
        [view.player setItemByStringPath:model.video_url];
        [view.player play];
        view.hidden = NO;
#endif
    } else {
        //        [view.player pause];
        [playerView.player pause];
        playerView.hidden = YES;
        // 这里用水印合成，图可以不用再加载stiker层，但是就不能拉尺寸了。
        // 水印有问题，暂时不用
        //        tempStr = [SUTIL getWatermarkImageURL:self.cellData];
    }
    
    // 此处代码比较乱，注意顺序。
    if(!_noImage)[p_bigImgView sd_setImageWithURL:[NSURL URLWithString:tempStr]];
    
    
    // Sticker，图片已经用水印解决，暂时只有视频用贴纸。
    if ([model.stick_img_url length] > 0 ) {
        //        if(!_noImage)[p_stickerView sd_setImageWithURL:[NSURL URLWithString:stickUrl]];
        if(!_noImage)[p_stickerView sd_setImageWithURL:[NSURL URLWithString:model.stick_img_url]];
        [p_stickerView setSize:size];
        [p_bigImgView addSubview:p_stickerView];
        //        [self bringSubviewToFront:p_stickerView];
    } else {
        [p_stickerView setImage:nil];
    }
    
    // 喜欢的view提上来
    UIView *likeView = [p_bigImgView viewWithTag:LIKE_BG_TAG];
    [p_bigImgView addSubview:likeView];
    tagControlBtn.hidden=NO;
    
    if (model.tag_list.length>0&&![model.tag_list isEqualToString:@"[]"]) {
        
        
        NSDictionary *tempDic;
        NSArray *tempAry;
        if ([[SUTILITY_TOOL_INSTANCE getArray:model.tag_list] isKindOfClass:[NSArray class]]) {
            tempAry = [NSArray arrayWithArray: [SUTILITY_TOOL_INSTANCE getArray:model.tag_list]];
        }
        
        for (int i =0; i<tempAry.count; i++) {
            tempDic = tempAry[i];
            
            //            float x = [tempDic[@"x"] floatValue];
            //            float y = [tempDic[@"y"] floatValue];
            //
            //            UIImageView *imgView = [SUTILITY_TOOL_INSTANCE addTag:tempDic[@"text"]
            //                                 fontStyle:nil
            //                                 imageView:p_bigImgView
            //                                     point:CGPointMake(x, y)isLimited:YES];
            //UIImageView *imgView = [[SUtilityTool shared] addTagWithDict:tempDic inView:p_bigImgView limited:YES];
            //[tagViewArr addObject:imgView];
            
            CoverStickerView *stickerView = [[SUtilityTool shared] addTagWithDict:tempDic inView:p_bigImgView];
            [tagViewArr addObject:stickerView];
        }
        
        if (dataModel.isHidden) {
            tagControlBtn.hidden=NO;
            [tagControlBtn setSelected:NO];
            for(UIImageView *imgV in tagViewArr)
            {
                [imgV setHidden:YES];
            }
        }
        else
        {
            [tagControlBtn setSelected:YES];
        }
        
    }
    else
    {
        tagControlBtn.hidden=YES;
    }
    
    
    tempStr = model.content_info;
    if (model.content_info.length > 0) {
        labelSize = [model.content_info boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |
                     NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
        labelSize.height += 15;
    }else{
        labelSize = CGSizeZero;
    }
    
    
    [p_textContentLabel setText:tempStr];
    //更改坐标
    [p_textContentLabel setOrigin:CGPointMake(p_textContentLabel.frame.origin.x, p_textContentLabelY + offset)];
    [p_textContentLabel setHeight:labelSize.height];
    
    offset += p_textContentLabel.height;
    
    //点赞的人的头像
    for(UIView *view in [p_likePeopleView subviews])
    {
        [view removeFromSuperview];
    }
    //更改坐标
    [p_likePeopleView setOrigin:CGPointMake(p_likePeopleView.frame.origin.x, p_likePeopleViewY + offset)];
    
    NSInteger tempInt = 10;
    UIView *tempBg;
    UILabel *tempLabel;
    //喜欢的人的头像
    if (model.likeUserArray.count > 0) {
        for (int i = 0; i<model.likeUserArray.count; i++) {
            //tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic1"]];
            SMLikeUser *user = [model.likeUserArray objectAtIndex:i];
            tempView = [UIImageView new];
            if(!_noImage)[tempView sd_setImageWithURL:[NSURL URLWithString:user.head_img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
            tempView.frame = CGRectMake(tempInt, p_likePeopleView.frame.size.height/2 - 15, 30, 30);
            tempView.layer.cornerRadius = tempView.frame.size.height/2;
            tempView.clipsToBounds = YES;
            [p_likePeopleView addSubview:tempView];
            
            UIImageView *vipImg = [[UIImageView alloc] initWithFrame:CGRectMake(10+tempInt+25 - 11, p_likePeopleView.frame.size.height/2 - 15 + 30 - 12, 12, 12)];
            vipImg.layer.cornerRadius=vipImg.frame.size.width/ 2;
            vipImg.layer.borderWidth = 1.0;
            vipImg.layer.borderColor = [UIColor whiteColor].CGColor;
            vipImg.layer.masksToBounds = YES;
            [p_likePeopleView addSubview:vipImg];
            NSString *listHead_v_type = [NSString stringWithFormat:@"%@",user.head_v_type];
            
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
            
            
            
            tempView.tag = BASE_BTN_TAG + i;
            [SUTILITY_TOOL_INSTANCE addViewAction:tempView target:self action:@selector(onLikeOther:)];
            tempInt += 30;
            tempInt += 5;
            if ((UI_SCREEN_WIDTH - tempInt - 107/2 - 30) < 10) {
                break;
            }
        }
        
        
        tempBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"like_num_bg2"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCollocationLovers)];
        [tempBg addGestureRecognizer:tap];
        [tempBg setUserInteractionEnabled:YES];
        tempBg.frame = CGRectMake(tempInt,p_likePeopleView.frame.size.height/2-40/2/2, 107/2, 40/2);
        [p_likePeopleView addSubview:tempBg];
        tempLabel = [[UILabel alloc]initWithFrame: CGRectMake(20,0, tempBg.frame.size.width-20, tempBg.frame.size.height)];
        tempLabel.text = model.like_count;
        tempLabel.font = FONT_SIZE(12);
        tempLabel.textColor = COLOR_C2;
        [tempBg  addSubview:tempLabel];
    }else{
        offset -= 35.0;
    }
    //更改坐标
    [p_buttonListView setOrigin:CGPointMake(0, p_buttonListViewY+offset)];
    self.cellAdditionalHeight = offset;
    
}

-(void)commentContent:(id)selector{
    NSLog(@"评论");
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    CommentsViewController *controller = [[CommentsViewController alloc]initWithNibName:@"CommentsViewController" bundle:nil];
    if (dataModel) {
        controller.collocationID = [NSString stringWithFormat:@"%@",dataModel.idValue];
    }else{
        controller.collocationID =  [NSString stringWithFormat:@"%@",self.cellData[@"id"]];
    }
    [self.parentVc.navigationController pushViewController:controller animated:YES];
}

-(void)likeContent:(id)selector{
    NSLog(@"喜欢");
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    
    NSString * tempInt = nil;
    BOOL isLove = NO;
    if (dataModel) {
        tempInt = dataModel.idValue ;
        isLove = [dataModel.is_love boolValue];
    }else{
        tempInt =[NSString stringWithFormat:@"%@", self.cellData[@"id"]] ;
        isLove = [self.cellData[@"is_love"] boolValue];
    }
    
    //喜欢
    if (!isLove) {
        [SDATACACHE_INSTANCE likeCollocation:tempInt complete:^(id data) {
            NSNumber *dataInt = (NSNumber*)data;
            if(dataInt.intValue == 1){
                [self setLikeBtnStatus:YES];
                [self setLikeNum:1];
            }
        }];
    }//取消喜欢
    else{
        [SDATACACHE_INSTANCE delLikeCollocation:tempInt complete:^(id data) {
            NSNumber *dataInt = (NSNumber*)data;
            if(dataInt.intValue == 1){
                [self setLikeBtnStatus:NO];
                [self setLikeNum:-1];
            }
        }];
    }
    
}

- (void)showCollocationLovers
{
    NSInteger favCount = 0;
    NSString *collId = @"";
    if (dataModel) {
        favCount = [dataModel.like_count integerValue];
        collId = dataModel.idValue;
    }else{
        favCount = [self.cellData[@"like_count"] integerValue];
        collId = self.cellData[@"id"];
    }
    
    if (favCount > 0 && [collId length] > 0) {
        SCollocationLoversController *loverController = [[SCollocationLoversController alloc] init];
        loverController.collocationId = collId;
        [self.parentVc.navigationController pushViewController:loverController animated:YES];
    }
}

-(void)setLikeNum:(NSInteger)num{
    int likeNum = 0;
    int isLoveStatus = 0;
    likeNum = [p_likeNumDownLabel.text intValue];
    likeNum += num;
    if (likeNum <= 0) {
        likeNum = 0;
    }
    if (dataModel) {
        
        NSMutableArray *array = dataModel.likeUserArray;
        if (num < 0) {
            isLoveStatus = 0;
            NSMutableArray *array = dataModel.likeUserArray;
            NSString *idValue = [[SDataCache sharedInstance].userInfo objectForKey:@"id"];
            for (int i = 0; i < array.count; i ++) {
                SMLikeUser *user = [array objectAtIndex:i];
                if ([idValue isEqualToString:user.user_id]) {
                    [array removeObjectAtIndex:i];
                    break;
                }
            }
        }else{
            isLoveStatus = 1;
            NSString *header = sns.myStaffCard.photo_path;
            if ([header length] == 0) {
                header = [[SDataCache sharedInstance].userInfo objectForKey:@"headPortrait"];
            }
            NSString *idValue = [[SDataCache sharedInstance].userInfo objectForKey:@"id"];
            SMLikeUser *user = [[SMLikeUser alloc] init];
            if ([header length] > 0) {
                user.head_img = header;
            }
            if ([idValue length] > 0) {
                user.user_id = idValue;
            }
            [array insertObject:user atIndex:0];
        }
        dataModel.like_count = OTHER_TO_STRING(@"%d", likeNum);
        dataModel.is_love = [NSNumber numberWithBool:isLoveStatus];
    }else{
        if (num < 0) {
            isLoveStatus = 0;
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.cellData[@"like_user_list"]];
            NSString *idValue = [[SDataCache sharedInstance].userInfo objectForKey:@"id"];
            for (int i = 0; i < array.count; i ++) {
                NSDictionary *dict = [array objectAtIndex:i];
                NSString *userId = [dict objectForKey:@"user_id"];
                if ([userId isEqualToString:idValue]) {
                    [array removeObjectAtIndex:i];
                    break;
                }
            }
            [self.cellData setValue:array forKey:@"like_user_list"];
        }else{
            isLoveStatus = 1;
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.cellData[@"like_user_list"]];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSString *header = sns.myStaffCard.photo_path;
            if ([header length] == 0) {
                header = [[SDataCache sharedInstance].userInfo objectForKey:@"headPortrait"];
            }
            NSString *idValue = [[SDataCache sharedInstance].userInfo objectForKey:@"id"];
            if ([header length] > 0) {
                [dict setObject:header forKey:@"head_img"];
            }
            if ([idValue length] > 0) {
                [dict setObject:idValue forKey:@"user_id"];
            }
            [array insertObject:dict atIndex:0];
            [self.cellData setValue:array forKey:@"like_user_list"];
        }
        [self.cellData setValue:OTHER_TO_STRING(@"%d", likeNum) forKey:@"like_count"];
        [self.cellData setValue:@(isLoveStatus) forKey:@"is_love"];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(kMainViewCellUploadCellAtIndex:cellData:)]) {
        [_delegate kMainViewCellUploadCellAtIndex:self.cellIndex cellData:self.cellData];
    }
}

-(void)setLikeBtnStatus:(BOOL)isLike{
    if (!isLike) {
        //        [p_likeBigBtn setImage:[UIImage imageNamed:@"Unico/like_big"] forState:UIControlStateNormal];
        [p_likeSmallBtn setImage:[UIImage imageNamed:@"Unico/icon_like2"] forState:UIControlStateNormal];
    }else{
        //        [p_likeBigBtn setImage:[UIImage imageNamed:@"Unico/like_big2"] forState:UIControlStateNormal];
        [p_likeSmallBtn setImage:[UIImage imageNamed:@"Unico/icon_like22"] forState:UIControlStateNormal];
    }
}

-(void)shareContent:(id)selector{
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    NSString *urlStr=@"";
    
    ShareData *aData = [[ShareData alloc] init];
    if (dataModel) {
        NSDictionary *dic = @{@"id":dataModel.idValue};
        urlStr = [SUTIL getCollocationURL:dic];
    }else{
        urlStr = [SUTIL getCollocationURL:self.cellData];
    }
    
    
    if (!urlStr || [urlStr length] == 0) {
        urlStr = @"http://www.banggo.com";
    }
    aData.shareUrl = urlStr;
    aData.image = [Utils reSizeImage:[Utils snapshot:p_bigImgView] toSize:CGSizeMake(57,57)];
    aData.descriptionStr = self.cellData[@"content_info"];
    ShareRelated *share = [ShareRelated sharedShareRelated];
    [share showInTarget:_parentVc withData:aData];
}

-(void)reportContent:(id)selector{
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    NSString *title = @"举报不良内容";
    NSString *userIdStr = self.cellData[@"user_id"];
    if (dataModel) {
        userIdStr = dataModel.user_id;
    }
    if ([sns.ldap_uid isEqualToString:userIdStr]) {
        title = @"删除我的发布";
    }
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:title, nil];
    [sheet showInView:self.parentVc.view];
}

-(void)onEnterDesigner:(id)selector{
    NSString *userIdStr = @"";
    if (dataModel) {
        userIdStr = dataModel.user_id;
    }else{
        userIdStr = self.cellData[@"user_id"];
    }
    if ([userIdStr isEqualToString:sns.ldap_uid]) {
        MBSettingMainViewController *controller = [MBSettingMainViewController new];
        [self.parentVc.navigationController pushViewController:controller animated:YES];
    }else{
        SMineViewController *vc = [[SMineViewController alloc]init];
        vc.person_id = userIdStr;
        [self.parentVc.navigationController pushViewController:vc animated:YES];
    }
}
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(void)onLikeOther:(UITapGestureRecognizer*)recognizer{
    long index = recognizer.view.tag - BASE_BTN_TAG;
    //    if ([BaseViewController pushLoginViewController]){
    NSString *userIdStr = @"";
    if (dataModel) {
        SMLikeUser *userModel = [dataModel.likeUserArray objectAtIndex:index];
        userIdStr = userModel.user_id;
    }else{
        userIdStr = self.cellData[@"like_user_list"][index][@"user_id"];
    }
    
    SMineViewController *vc = [[SMineViewController alloc]init];
    vc.person_id = userIdStr;
    [self.parentVc.navigationController pushViewController:vc animated:YES];
    //    }
}
//进入搭配详情，判断是否登录暂时屏蔽
-(void)enterCollocationView:(id)selector{
    
    /*     SCollocationDetailViewController *vc = [SCollocationDetailViewController new];
     if (dataModel) {
     vc.collocationId = [dataModel.idValue intValue];
     }else{
     vc.collocationId = [self.cellData[@"id"] intValue];
     vc.collocationInfo = self.cellData;
     }
     [self.parentVc.navigationController pushViewController:vc animated:YES];*/
    
    
    
    
    extern BOOL g_socialStatus;
    if (g_socialStatus)//是否处于社交状态
    {
        SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
        
        
        if (dataModel)
        {
            detailNoShoppingViewController.collocationId = dataModel.idValue ;
        }
        else
        {
            detailNoShoppingViewController.collocationId = self.cellData[@"id"] ;
            detailNoShoppingViewController.collocationInfo = self.cellData;
        }
        [self.parentVc.navigationController pushViewController:detailNoShoppingViewController animated:YES];
        
    }
    else
    {
        SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
        
        
        if (dataModel)
        {
            collocationDetailVC.collocationId = dataModel.idValue;
        }
        else
        {
            collocationDetailVC.collocationId = self.cellData[@"id"];
            collocationDetailVC.collocationInfo = self.cellData;
        }
        [self.parentVc.navigationController pushViewController:collocationDetailVC animated:YES];
    }
    
    
}

- (void)controlTagState:(UIButton *)button
{
    button.selected = !button.isSelected;
    BOOL isShow = button.isSelected;
    dataModel.isHidden=!isShow;
    
    for(UIImageView *imgV in tagViewArr){
        [imgV setHidden:!isShow];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSString *userIdStr = @"";
        NSString *collId = @"";
        if (dataModel) {
            userIdStr = dataModel.user_id;
            collId = dataModel.idValue;
        }else{
            userIdStr = self.cellData[@"user_id"];
            collId = self.cellData[@"id"];
        }
        
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *collId = @"";
        if (dataModel) {
            collId = dataModel.idValue;
        }else{
            collId = self.cellData[@"id"];
        }
        [[SDataCache sharedInstance] delCollocationInfo:@"" collocationId:[collId integerValue] complete:^(NSArray *data, NSError *error) {
            [Toast hideToastActivity];
            if (error) {
                [Toast makeToast:@"删除失败，请稍候再试"];
                return ;
            }
            if (_delegate && [_delegate respondsToSelector:@selector(kMainViewCellDeleteCellAtIndex:)]) {
                [_delegate kMainViewCellDeleteCellAtIndex:self.cellIndex];
            }
        }];
        
    }
}
-(void)hiddenShowAlertView
{
    [showAlertView dismissWithClickedButtonIndex:0 animated:NO];//important
}
@end