//
//  SBrandOtherCell.m
//  Wefafa
//
//  Created by metesbonweios on 15/8/5.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBrandOtherCell.h"
#import "SUtilityTool.h"
#import "DesignerModel.h"
#import "SCollocationDetailViewController.h"
#import "SProductDetailViewController.h"
#import "DailyNewViewController.h"
#import "SCollocationDetailNoneShopController.h"
#import "BrandDetailViewController.h"

@interface SBrandOtherCell () {
    UIImageView *headRoundView;
    UIImageView *headImgView;
    
    UIScrollView * collocationView;
    UIView *buttomBar;
    UILabel * imgCountLabel;
    UILabel * nameLabel;
}

@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation SBrandOtherCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    CGRect cellRect = [UIScreen mainScreen].bounds;
    UIView *contentView;
    NSInteger offset = 0;
    NSString *tempStr;
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, offset, cellRect.size.width, 50/2)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    offset += contentView.frame.size.height;
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, offset, cellRect.size.width, 320/2)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    UIView *tempUI = [[UIView alloc]initWithFrame:CGRectMake(20/2, -40/2, 120/2, 120/2)];
    tempUI.backgroundColor = COLOR_WHITE;
    tempUI.layer.borderWidth = 1;
    tempUI.layer.borderColor = (COLOR_C9).CGColor;
    [contentView addSubview:tempUI];
    
    headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120/2, 120/2)];
    [tempUI addSubview:headImgView];
    
    nameLabel = [SUTIL createUILabelByStyle:@"" fontStyle:FONT_T4 color:COLOR_C2 rect:CGRectMake(tempUI.frame.origin.x+tempUI.width+20/2, 15, 0, 0) isFitWidth:YES isAlignLeft:YES];
    [self addSubview:nameLabel];
    
    
    UIImageView * tempView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Unico/right_arrow"]];
    tempView.frame = CGRectMake(contentView.size.width - 14/2 - 10+4,offset - 28/2/2 , 14/2, 28/2);
    [contentView addSubview: tempView];
    
    tempStr = @"共 100 张照片";
    CGSize countLabelSize = [SUTIL getStrLenByFontStyle:tempStr fontStyle:[UIFont systemFontOfSize:12]];
    imgCountLabel = [SUTIL createUILabelByStyle:tempStr fontStyle:[UIFont systemFontOfSize:12] color:UIColorFromRGB(0xc4c4c4) rect:CGRectMake(contentView.size.width- 14/2 - countLabelSize.width,tempView.frame.origin.y + tempView.height/2-countLabelSize.height/2, 0, 0) isFitWidth:YES isAlignLeft:YES];
    imgCountLabel.hidden=YES;
    
    [contentView addSubview:imgCountLabel];
    offset = 10/2+120/2+24/2;
    //图片
    collocationView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, offset, cellRect.size.width, 200/2)];
    [self addSubview: collocationView];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 185, UI_SCREEN_WIDTH, 10)];
    backView.backgroundColor = COLOR_C4;
    [self addSubview:backView];
    
    offset  = 195;
    self.cellHeight = offset;
    //选择无模式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

-(void)updateCellView{
    long number = [self.cellData[@"itemList"] count];
    NSString *logoUrl = self.cellData[@"logo_img"];
    NSString *brandName = [NSString stringWithFormat:@"%@",self.cellData[@"english_name"]];
    brandName = [Utils getSNSString:brandName];
    
    NSArray *collocationAry = (NSArray*)self.cellData[@"itemList"];
    UIImageView *imageView;
    [headImgView sd_setImageWithURL:[NSURL URLWithString:logoUrl]];
    
    NSString *tempStr;
    NSString *numberStr = OTHER_TO_STRING(@"共%ld张照片", number);
    CGSize labelSize = [SUTIL getStrLenByFontStyle:numberStr fontStyle:FONT_T4];
    imgCountLabel.text = numberStr;
    
    [imgCountLabel setSize:CGSizeMake(labelSize.width, imgCountLabel.height)];
    [imgCountLabel setOrigin:CGPointMake(UI_SCREEN_WIDTH - 34/2-20/2-14/2-imgCountLabel.width, imgCountLabel.frame.origin.y)];
    
    labelSize = [SUTIL getStrLenByFontStyle:brandName fontStyle:FONT_T4];
    nameLabel.text = brandName;
    [nameLabel setSize:CGSizeMake(labelSize.width, nameLabel.height)];
    
    for(UIView *view in [collocationView subviews]){
        [view removeFromSuperview];
    }
    
    if ([[NSNull null] isEqual:collocationAry]) {
        return;
    }
    
    for (int i =0 ; i<collocationAry.count; i++) {

        NSArray *clsPicUrlArray =collocationAry[i][@"clsPicUrl"];
        tempStr = [NSString stringWithFormat:@"%@",collocationAry[i][@"product_url"]];
    
        imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectMake(20/2 + i*(200/2 + 16/2), 0, 200/2, 200/2);
        imageView.layer.masksToBounds=YES;
        imageView.layer.borderWidth=1;
        imageView.layer.borderColor=[Utils HexColor:0xf2f2f2 Alpha:1].CGColor;
        
        imageView.tag = BASE_BTN_TAG + i ;
        if([clsPicUrlArray count]>0)
        {
            NSDictionary *clsPicDic= (NSDictionary *)[clsPicUrlArray firstObject];
            tempStr = clsPicDic[@"filE_PATH"];
//            imageView.tag = BASE_BTN_TAG + [collocationAry[i][@"clsInfo"][@"id"]integerValue];
        }
    
        [imageView sd_setImageWithURL:[NSURL URLWithString:tempStr]placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
        NSLog(@"imageview.tag--%ld",(long)imageView.tag);
        
        [SUTIL addViewAction:imageView target:self action:@selector(onSelectCollocation:)];
        [collocationView addSubview:imageView];
    }
    [collocationView setContentSize:CGSizeMake(20/2 + (imageView.width + 16/2)*collocationAry.count, imageView.height)];
    UITapGestureRecognizer * selfTaped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(brandDetailClicked:)];
    [self addGestureRecognizer:selfTaped];
}

-(void)onSelectCollocation:(UITapGestureRecognizer*)recognizer{
    //单品did
    long collocationId = recognizer.view.tag -BASE_BTN_TAG;
    NSString *  product_sys_code=@"";
    
     NSArray *collocationAry = (NSArray*)self.cellData[@"itemList"];
    if ([collocationAry count]>0) {

        NSDictionary *dic =collocationAry[collocationId];
        if ([[dic allKeys] containsObject:@"clsPicUrl"]) {
            NSArray *clsPicUrlArray =collocationAry[collocationId][@"clsPicUrl"];
            //以前老的
            if([clsPicUrlArray count]>0)
            {
                NSDictionary *clsPicDic= (NSDictionary *)[clsPicUrlArray firstObject];
                product_sys_code  = [NSString stringWithFormat:@"%@",clsPicDic[@"clsInfo"][@"id"]];
            }
        }else
        {//新的
            product_sys_code = [NSString stringWithFormat:@"%@",collocationAry[collocationId][@"product_sys_code"]];
            
        }
    }
   
    //跳单品
    SProductDetailViewController * sproductDVC=[[SProductDetailViewController alloc]init];
    sproductDVC.productID=[NSString stringWithFormat:@"%@",product_sys_code];
    [self.parentVc pushController:sproductDVC animated:YES];
}
-(void)brandDetailClicked:(UITapGestureRecognizer*)tap
{
    NSString * brandID = [NSString stringWithFormat:@"%@",self.cellData[@"brand_code"]];
    DailyNewViewController *dailyNewVC=[[DailyNewViewController alloc]init];
    dailyNewVC.brandId = [NSString stringWithFormat:@"%@", brandID];
    dailyNewVC.isCanSocial=NO;
    [self.parentVc.navigationController pushViewController:dailyNewVC animated:YES];
}


@end
