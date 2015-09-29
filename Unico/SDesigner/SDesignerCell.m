//
//  SDesignerCell.m
//  Wefafa
//
//  Created by 凯 张 on 15/5/28.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SDesignerCell.h"
#import "SUtilityTool.h"
#import "SCollocationDetailViewController.h"
#import "SCollocationDetailNoneShopController.h"



#define BASE_COUNT 10000
@interface SDesignerCell(){
    UIImageView *headImgView;
    UIImageView *head_V_view;
    UIScrollView * collocationView;
    UIView *buttomBar;
    UILabel * imgCountLabel;
    UILabel * nameLabel;
    DesignerModel * designModel;
    
    NSDictionary *designerDict;
}

@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation SDesignerCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    CGRect cellRect = [UIScreen mainScreen].bounds;
    UIView *contentView;
    NSInteger offset = 0;
    NSString *tempStr;
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, offset, cellRect.size.width, 60/2)];
    contentView.backgroundColor = COLOR_C4;
    [self addSubview:contentView];
    offset += contentView.frame.size.height;
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, offset, cellRect.size.width, 78/2)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(8, 8, 59, 59)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 59/ 2.0;
    [self addSubview:backView];
    
    headImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
    headImgView.frame = CGRectMake(10, 10, 55, 55);
    headImgView.layer.cornerRadius = 55/ 2.0;
    headImgView.layer.masksToBounds = YES;
    [self addSubview:headImgView];

    head_V_view=[[UIImageView alloc]initWithFrame:CGRectMake(headImgView.frame.origin.x+headImgView.frame.size.width-12, headImgView.frame.size.height+headImgView.frame.origin.y-16, 12, 12)];
    [head_V_view setImage:[UIImage imageNamed:@"peoplevip@2x"]];
    head_V_view.layer.cornerRadius=head_V_view.frame.size.width/ 2;
    head_V_view.layer.borderWidth = 1.0;
    head_V_view.layer.borderColor = [UIColor whiteColor].CGColor;
    head_V_view.layer.masksToBounds = YES;
    
    [self addSubview:head_V_view];
    
    nameLabel = [[UILabel alloc]initWithFrame: CGRectMake(headImgView.frame.size.width+10+5,0, 0, contentView.frame.size.height)];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font =[UIFont systemFontOfSize:12];
    [contentView addSubview:nameLabel];
    
    UIImageView * tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Unico/right_arrow"]];
    tempView.frame = CGRectMake(contentView.size.width - 14 - 10+4,contentView.frame.size.height/2 - 28/2/2 , 14/2, 28/2);
    [contentView addSubview: tempView];
    
    tempStr = @"共 100 张照片";
//    CGSize countLabelSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:tempStr fontStyle:[UIFont systemFontOfSize:12]];
    imgCountLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:tempStr fontStyle:[UIFont systemFontOfSize:12] color:UIColorFromRGB(0x999999) rect:CGRectMake(contentView.size.width- 14 - 210,0, 200, contentView.frame.size.height) isFitWidth:NO isAlignLeft:YES];
    imgCountLabel.textAlignment = NSTextAlignmentRight;
    [contentView addSubview:imgCountLabel];
    
    offset += contentView.frame.size.height;
    //图片
    collocationView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, offset, cellRect.size.width, 118)];
    collocationView.userInteractionEnabled = YES;
    [self addSubview: collocationView];
    
    
    offset += collocationView.frame.size.height;
    self.cellHeight = offset;
    //选择无模式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}
-(void)updateDesignerModel:(DesignerModel*)model :(UITableView*)table :(NSIndexPath*)index
{
    
    designModel = model;
    NSString * imgCountStr = [NSString stringWithFormat:@"共 %ld 张照片",(unsigned long)[model.collocationList count]];
    
    [imgCountLabel setText:imgCountStr];
    
    NSString * headImgUrl = model.headPortrait;
    NSString * nameStr = model.userName;
    CGSize nameLabelSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:nameStr fontStyle:[UIFont systemFontOfSize:12]];
    nameLabel .size = CGSizeMake(nameLabelSize.width, nameLabel.size.height) ;
    [nameLabel setText:nameStr];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImgClicked:)];
    
    [headImgView sd_setImageWithURL:[NSURL URLWithString:headImgUrl] placeholderImage:[UIImage imageNamed: DEFAULT_LOADING_HEADIMGVIEW ]];
    [headImgView setTag:BASE_COUNT-1];
    headImgView.userInteractionEnabled = YES;
    [headImgView addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImgClicked:)];
    imgCountLabel.userInteractionEnabled = YES;
    imgCountLabel.tag = BASE_COUNT - 1;
    [imgCountLabel.superview bringSubviewToFront:imgCountLabel];
    [imgCountLabel addGestureRecognizer:tap];
    NSString *head_v_type=[NSString stringWithFormat:@"%@",model.head_v_type];
    
    switch ([head_v_type integerValue]) {
        case 0:
        {
            head_V_view.hidden=YES;
        }
            break;
        case 1:
        {
            head_V_view.hidden=NO;
            [head_V_view setImage:[UIImage imageNamed:@"brandvip@2x"]];
        }
            break;
        case 2:
        {
            [head_V_view setImage:[UIImage imageNamed:@"peoplevip@2x"]];
            head_V_view.hidden=NO;
        }
            break;
        default:
            break;
    }
    
    
    
    
    for (UIImageView * ImgView in [collocationView subviews]) {
        [ImgView removeFromSuperview];
    }
    
    for (int i = 0; i<[model.collocationList count]; i++) {
        NSString * imageStr = model.collocationList[i][@"img"];
        UIImageView * tempView = [[UIImageView alloc]init];
        tempView.userInteractionEnabled = YES;
        tempView.tag = BASE_COUNT +i;
        tempView.frame = CGRectMake(10+i*(100 + 6),collocationView.frame.size.height/2-200/2/2, 200/2, 200/2);
        [tempView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE ]];
         UITapGestureRecognizer * imgtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImgClicked:)];
        [tempView addGestureRecognizer:imgtap];

        [collocationView addSubview:tempView];
        
    }
    [collocationView setContentSize:CGSizeMake(10+(100+6)*model.collocationList.count, collocationView.size.height)];
    
    
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    
    designerDict = dict;
    
    NSArray *array = [dict objectForKey:@"collocation_list"];
    long number = [dict[@"collocation_count"] integerValue];
    NSString * imgCountStr = [NSString stringWithFormat:@"共 %ld 张照片",number];
    
    [imgCountLabel setText:imgCountStr];
    
    NSString * headImgUrl = [dict objectForKey:@"head_img"];
    NSString * nameStr = [dict objectForKey:@"nick_name"];
    CGSize nameLabelSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:nameStr fontStyle:[UIFont systemFontOfSize:12]];
    nameLabel .size = CGSizeMake(nameLabelSize.width, nameLabel.size.height) ;
    [nameLabel setText:nameStr];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImgClicked:)];
    
    [headImgView sd_setImageWithURL:[NSURL URLWithString:headImgUrl] placeholderImage:[UIImage imageNamed: DEFAULT_LOADING_HEADIMGVIEW ]];
    [headImgView setTag:BASE_COUNT-1];
    headImgView.userInteractionEnabled = YES;
    [headImgView addGestureRecognizer:tap];
    
    NSString *head_v_type=[NSString stringWithFormat:@"%@",dict[@"head_v_type"]];
    
    switch ([head_v_type integerValue]) {
        case 0:
        {
            head_V_view.hidden=YES;
        }
            break;
        case 1:
        {
            head_V_view.hidden=NO;
            [head_V_view setImage:[UIImage imageNamed:@"brandvip@2x"]];
        }
            break;
        case 2:
        {
            [head_V_view setImage:[UIImage imageNamed:@"peoplevip@2x"]];
            head_V_view.hidden=NO;
        }
            break;
        default:
            break;
    }
    
    
    for (UIImageView * ImgView in [collocationView subviews]) {
        [ImgView removeFromSuperview];
    }
    
    for (int i = 0; i<[array count]; i++) {
        NSString * imageStr = array[i][@"img"];
        UIImageView * tempView = [[UIImageView alloc]init];
        tempView.userInteractionEnabled = YES;
        tempView.tag = BASE_COUNT +i;
        tempView.frame = CGRectMake(10+i*(100 + 6),collocationView.frame.size.height/2-200/2/2, 200/2, 200/2);
        [tempView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE ]];
        UITapGestureRecognizer * imgtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImgClicked:)];
        [tempView addGestureRecognizer:imgtap];
        
        [collocationView addSubview:tempView];
        
    }
    [collocationView setContentSize:CGSizeMake(10+(100+6)*array.count, collocationView.size.height)];
}

//点击图片事件
-(void)ImgClicked:(UITapGestureRecognizer*)tap
{
    NSInteger index = [tap view].tag;
    
    switch (index) {
        case 9999:{
            SMineViewController * designerInforPage = [[SMineViewController alloc]init];
            NSString * temId = [designerDict objectForKey:@"user_id"];
            if (temId) {
                designerInforPage.person_id = temId;
                [self.parentVC.navigationController pushViewController:designerInforPage animated:YES];

            }
            
            break;}
       
            
        default:{
            NSArray *array = [designerDict objectForKey:@"collocation_list"];//id
            
          /*  SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
            collocationDetailVC.collocationId = [(array[index-BASE_COUNT][@"id"]) integerValue];
            [self.parentVC.navigationController pushViewController:collocationDetailVC animated:YES];*/
            
            
            
            extern BOOL g_socialStatus;
            if (g_socialStatus)//是否处于社交状态
            {
                SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
                
                
                detailNoShoppingViewController.collocationId = [NSString stringWithFormat:@"%@",array[index-BASE_COUNT][@"id"]];
                [self.parentVC.navigationController pushViewController:detailNoShoppingViewController animated:YES];
                
            }
            else
            {
                SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
                
                
                collocationDetailVC.collocationId = [NSString stringWithFormat:@"%@",array[index-BASE_COUNT][@"id"]];
                [self.parentVC.navigationController pushViewController:collocationDetailVC animated:YES];

            }

            
            
            

            break;
        }
    }
}

// 初始化底部栏目
- (void)setupBottonBar {
}
-(void)showOtherProfile:(id)selecter{
}
-(void)commentMsg:(id)selecter
{
    self.commentMsg(self.data);
}

-(void)shareContent:(id)selecter
{
    self.shareContent(self.data);
}

-(void)likeContent:(id)selecter
{
    
}


@end

