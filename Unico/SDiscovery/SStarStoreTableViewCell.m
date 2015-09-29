//
//  SStarStoreTableViewCell.m
//  Wefafa
//
//  Created by lizhaoxiang on 15/5/27.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SStarStoreTableViewCell.h"
#import "SUtilityTool.h"
#import "SCollocationDetailViewController.h"
#import "SMineViewController.h"
#import "SCollocationDetailNoneShopController.h"
#import "SDiscoveryFlexibleModel.h"

#define BASE_COUNT 1000

@implementation SStarStoreTableViewCell
{
    UIView *contentView;
    UIImageView *headBGView;
    UIImageView *headImgView;
    UIImageView *head_V_View;
    UIImageView *bigImgView;
    UIImageView *middleImgView;
    UIImageView *smallImgView;
    UILabel * designerIntroLabel;
    UILabel * artNumLabel;
    UILabel * fansNumLabel;
    NSArray * ImgViewArr;
    UIImageView * rankImgBG;
    SStarStoreCellModel * _sStarModel;
    
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0];
    CGRect cellRect = [UIScreen mainScreen].bounds;
    
    NSInteger offset = 0;
    NSString *tempStr;
//    CGSize labelSize;
    
//    
//   
//    tempStr = @"Nike";
//    labelSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:tempStr fontStyle:[UIFont systemFontOfSize:12]];
//    
    CGFloat compareWidth = (UI_SCREEN_WIDTH-30)/2;
    CGFloat bigRitio = 16.0/9;
    CGFloat middleRitio = 1.0;
    CGFloat smallRitio = 3.0/4;
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0)];
    
    bigImgView  = [SUTILITY_TOOL_INSTANCE createRoundUIImageViewByUrl:nil rect:CGRectMake(10, 10, compareWidth, compareWidth * bigRitio) cornerRadius:0];
   bigImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    middleImgView  = [SUTILITY_TOOL_INSTANCE createRoundUIImageViewByUrl:nil rect:CGRectMake(20 +compareWidth, 10, compareWidth, compareWidth*middleRitio) cornerRadius:0];
    
    smallImgView  = [SUTILITY_TOOL_INSTANCE createRoundUIImageViewByUrl:nil rect:CGRectMake(20 +compareWidth,middleImgView.size.height+20, compareWidth, compareWidth*smallRitio) cornerRadius:0];
    [contentView addSubview:bigImgView];
    [contentView addSubview:middleImgView];
    [contentView addSubview:smallImgView];
    
    // aspect fill
    bigImgView.contentMode = middleImgView.contentMode = smallImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    offset += MIN(bigImgView.frame.size.height, (middleImgView.size.height+ smallImgView.size.height+10));
    
    CGFloat smallOffSet=0;

    headBGView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Unico/brand_quan"]];
    headBGView.frame = CGRectMake((UI_SCREEN_WIDTH-114/2)/2, offset-114/4, 114/2, 114/2);
    headBGView.userInteractionEnabled = YES;
    headImgView = [[UIImageView alloc]init];
    headImgView.frame = CGRectMake(headBGView.frame.size.width/2-110/2/2, headBGView.frame.size.height/2 - 110/2/2, 110/2, 110/2);
    headImgView.layer.cornerRadius = 110/4;
    headImgView.layer.masksToBounds = YES;
    [headBGView addSubview:headImgView];
    
    rankImgBG = [[UIImageView alloc]initWithFrame:CGRectMake(-20, 25, 32, 25)];
    rankImgBG.userInteractionEnabled = NO;
    rankImgBG.hidden = YES;
    [headBGView addSubview:rankImgBG];

    head_V_View =[[UIImageView alloc]initWithFrame:CGRectMake(headBGView.frame.origin.x+headBGView.frame.size.width-10,headBGView.frame.size.height+headBGView.frame.origin.y-15, 12, 12)];
    head_V_View.layer.masksToBounds = YES;
    head_V_View.layer.cornerRadius= head_V_View.frame.size.height/2;
    head_V_View.layer.borderWidth = 1.0;
    head_V_View.layer.borderColor = [UIColor whiteColor].CGColor;
    [head_V_View setImage:[UIImage imageNamed:@"peoplevip@2x"]];
    
    [self addSubview:head_V_View];
    
    smallOffSet += headBGView.size.height/2+5;
    
    tempStr = @"";
    designerIntroLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:tempStr fontStyle:[UIFont systemFontOfSize:13] color:UIColorFromRGB(0x3b3b3b) rect:CGRectMake(0,smallOffSet, 100, 13) isFitWidth:NO isAlignLeft:NO];
    [designerIntroLabel setOrigin:CGPointMake((cellRect.size.width-designerIntroLabel.size.width)/2, designerIntroLabel.frame.origin.y)];
//    designerIntroLabel.backgroundColor = [UIColor blueColor];
    smallOffSet += designerIntroLabel.size.height+5;
    
    artNumLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:tempStr fontStyle:[UIFont systemFontOfSize:10] color:UIColorFromRGB(0x999999) rect:CGRectMake(0,smallOffSet, 100, 11) isFitWidth:NO isAlignLeft:YES];
    [artNumLabel setOrigin:CGPointMake(cellRect.size.width/2-artNumLabel.size.width-5, artNumLabel.frame.origin.y)];
//    artNumLabel.backgroundColor = [UIColor orangeColor];

    
    fansNumLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:tempStr fontStyle:[UIFont systemFontOfSize:10] color:UIColorFromRGB(0x999999) rect:CGRectMake(cellRect.size.width/2 + artNumLabel.frame.origin.x+10,smallOffSet, 100, 11) isFitWidth:YES isAlignLeft:YES];
    [fansNumLabel setOrigin:CGPointMake(cellRect.size.width/2+5, fansNumLabel.frame.origin.y)];

//    fansNumLabel.backgroundColor = [UIColor yellowColor];
    smallOffSet += fansNumLabel.size.height + 10;

    
    
   
    UIView * tempView = [[UIView alloc]initWithFrame:CGRectMake(0, offset, UI_SCREEN_WIDTH, 71)];
    tempView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:tempView];
    [contentView bringSubviewToFront:tempView];
    [tempView addSubview:designerIntroLabel];
    [tempView addSubview:artNumLabel];
    [tempView addSubview:fansNumLabel];
    [contentView addSubview:headBGView];

    offset += tempView.size.height;
    
    
    self.cellHeight = offset;
    [contentView setSize:CGSizeMake(UI_SCREEN_WIDTH, offset)];
    [self.contentView addSubview:contentView];
    //选择无模式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, offset);
    return self;
}
- (void)updateStarCellModel:(SStarStoreCellModel*)model andIndex:(NSIndexPath*)RankIndex
{
    _sStarModel = model;
    designerIntroLabel .text = model.userName;
    designerIntroLabel.textAlignment = NSTextAlignmentCenter;
    artNumLabel.textAlignment = NSTextAlignmentRight;
    fansNumLabel.textAlignment = NSTextAlignmentLeft;
    
    [headImgView sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed: DEFAULT_LOADING_HEADIMGVIEW ]];
    headImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer * headTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImgClicked:)];
    [headImgView addGestureRecognizer:headTap];
    
    NSString *head_v_type=[NSString stringWithFormat:@"%@",model.head_v_type];
    
    switch ([head_v_type integerValue]) {
        case 0:
        {
            head_V_View.hidden=YES;
        }
            break;
        case 1:
        {
            head_V_View.hidden=NO;
            [head_V_View setImage:[UIImage imageNamed:@"brandvip@2x"]];
        }
            break;
        case 2:
        {
            [head_V_View setImage:[UIImage imageNamed:@"peoplevip@2x"]];
            head_V_View.hidden=NO;
        }
            break;
        default:
            break;
    }
    
    
    ImgViewArr = [[NSArray alloc]initWithObjects:bigImgView,middleImgView,smallImgView, nil];
    for (UIImageView * img in ImgViewArr) {
        img.image = nil;
    }
    

    int i = 0;
    for (; i<[model.collocationList count] && i<[ImgViewArr count]; i++) { //如果服务器数据过多，须使用i<[ImgViewArr count]过滤掉，避免闪退
        UIImageView * img = ImgViewArr[i];
        img.hidden = NO;
        [img setUserInteractionEnabled:YES];
        [img setTag:BASE_COUNT+i];
        
        NSString * imgUrlStr = model.collocationList[i][@"img"];
        [img sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
        UITapGestureRecognizer * gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgeTaped:)];
        [img addGestureRecognizer:gest];
    }
    
    for (; i<[ImgViewArr count]; i++)//如果服务器数据过少，须将多余的ImgViewArr[i]图片隐藏起来，不然cell复用时可能显示其他cell残留的数据，避免闪退
    {
        UIImageView * img = ImgViewArr[i];
        img.hidden = YES;
        [img setUserInteractionEnabled:NO];
    }

        switch (RankIndex.row) {
        case 0:{
            rankImgBG.hidden = NO;
            rankImgBG.image = [UIImage imageNamed:@"Unico/ico_no1"];
            break;
        }
        case 1:{
            rankImgBG.hidden = NO;
            rankImgBG.image = [UIImage imageNamed:@"Unico/ico_no2"];


            break;
        }case 2:{
            rankImgBG.hidden = NO;
            rankImgBG.image = [UIImage imageNamed:@"Unico/ico_no3"];


            break;
        }
            
        default:
        {
            rankImgBG.hidden = YES;

            break;
        }
    }

}

- (void)setContentModel:(SDiscoveryFlexibleModel *)contentModel{
    _contentModel = contentModel;
    if (contentModel.config.count <= 0) return;
    [self updateStarCellModel:contentModel.config[0] andIndex:[NSIndexPath indexPathForRow:4 inSection:0]];
}

-(void)imgeTaped:(UITapGestureRecognizer *)gest
{
    UIImageView * tapView = (UIImageView*)[gest view];
    NSInteger  index = tapView.tag-BASE_COUNT;
    if (_sStarModel.collocationList.count <= 0 || !_sStarModel.collocationList) {
        return;
    }
    
    if (index<0 || index>_sStarModel.collocationList.count)
    {
        return;
    }
    
  /*  SCollocationDetailViewController  *  collocationDetailVC  =  [[SCollocationDetailViewController alloc]init];
    
    
    NSString * collocationId = _sStarModel.collocationList[index][@"id"];
    
    collocationDetailVC.collocationId = [collocationId integerValue] ;
    
    [self.parentVc pushController:collocationDetailVC animated:YES];*/
    
    
    
    
    
    extern BOOL g_socialStatus;
    if (g_socialStatus)//是否处于社交状态
    {
        SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
        
        
        NSString * collocationId = _sStarModel.collocationList[index][@"id"];
        
        detailNoShoppingViewController.collocationId =collocationId ;
        
        [self.parentVc.navigationController pushViewController:detailNoShoppingViewController animated:YES];

        
    }
    else
    {
        SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
        
        
        NSString * collocationId = _sStarModel.collocationList[index][@"id"];
        
        collocationDetailVC.collocationId = collocationId;
        
        [self.parentVc.navigationController pushViewController:collocationDetailVC animated:YES];
        
    }

}

-(void)headImgClicked:(UITapGestureRecognizer* )headTap
{
    NSString *userIdStr = _sStarModel.designId;
    SMineViewController *vc = [[SMineViewController alloc]init];
    vc.person_id = userIdStr;
    [self.parentVc.navigationController pushViewController:vc animated:YES];

}
@end
