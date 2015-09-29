//
//  SBrandCell.m
//  Wefafa
//
//  Created by unico on 15/5/17.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SBrandCell.h"
#import "SUtilityTool.h"
#import "DesignerModel.h"
#import "SCollocationDetailViewController.h"
#import "SBrandSotryViewController.h"

#import "SCollocationDetailNoneShopController.h"
#import "BrandDetailViewController.h"

@interface SBrandCell(){
    UIImageView *headRoundView;
    UIImageView *headImgView;
    
    UIScrollView * collocationView;
    UIView *buttomBar;
    UILabel * imgCountLabel;
    UILabel * nameLabel;
}


@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation SBrandCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    CGRect cellRect = [UIScreen mainScreen].bounds;
    UIView *contentView;
    NSInteger offset = 0;
    NSString *tempStr;
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, offset, cellRect.size.width,10)];// 50/2
    contentView.backgroundColor = COLOR_C4;//
    [self addSubview:contentView];
    offset += contentView.frame.size.height;
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, offset, cellRect.size.width, 320/2)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    UIView *tempUI = [[UIView alloc]initWithFrame:CGRectMake(20/2,-5, 120/2, 120/2)];//-40/2
    tempUI.backgroundColor = COLOR_WHITE;
    tempUI.layer.borderWidth = 1;
    tempUI.layer.borderColor = (COLOR_C9).CGColor;
    [contentView addSubview:tempUI];
    
    headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120/2, 120/2)];
    [tempUI addSubview:headImgView];
    
    nameLabel = [SUTIL createUILabelByStyle:@"" fontStyle:FONT_T4 color:COLOR_C2 rect:CGRectMake(tempUI.frame.origin.x+tempUI.width+20/2, 16/2, 0, 0) isFitWidth:YES isAlignLeft:YES];
    [contentView addSubview:nameLabel];
    
    
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
    
    
    offset  = 370/2;
    self.cellHeight = offset;
    //选择无模式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

-(void)updateCellView{
    long number = [self.cellData[@"collocation_count"] integerValue];
    NSString *logoUrl = self.cellData[@"logo_img"];
    NSString *brandName = [NSString stringWithFormat:@"#%@",self.cellData[@"english_name"]];
    NSArray *collocationAry = (NSArray*)self.cellData[@"collocation_list"];
    UIImageView *imageView;
    [headImgView sd_setImageWithURL:[NSURL URLWithString:logoUrl]];
    if (!_isComeFromTopic) {//如果来自话题页面进入 则隐藏
        imgCountLabel.hidden=NO;
    }
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
        tempStr = collocationAry[i][@"img"];
        imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectMake(20/2 + i*(200/2 + 16/2), 0, 200/2, 200/2);
        [imageView sd_setImageWithURL:[NSURL URLWithString:tempStr]];
        imageView.tag = BASE_BTN_TAG + [collocationAry[i][@"id"]integerValue];
        [SUTIL addViewAction:imageView target:self action:@selector(onSelectCollocation:)];
        [collocationView addSubview:imageView];
    }
    [collocationView setContentSize:CGSizeMake(20/2 + (imageView.width + 16/2)*collocationAry.count, imageView.height)];
    UITapGestureRecognizer * selfTaped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(brandDetailClicked:)];
    [self addGestureRecognizer:selfTaped];
}

-(void)onSelectCollocation:(UITapGestureRecognizer*)recognizer{
    long collocationId = recognizer.view.tag -BASE_BTN_TAG;
    
   /* SCollocationDetailViewController *vc = [SCollocationDetailViewController new];
    vc.collocationId = collocationId;
    NSLog(@"%@",self.parentVc);
    [self.parentVc pushController:vc animated:YES];*/
    
#warning 搭配id 为字符串类型
    extern BOOL g_socialStatus;
    if (g_socialStatus)//是否处于社交状态
    {
        SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
        
        
        detailNoShoppingViewController.collocationId = [NSString stringWithFormat:@"%ld",collocationId];
        [self.parentVc pushController:detailNoShoppingViewController animated:YES];
    }
    else
    {
        SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
        
        
        collocationDetailVC.collocationId = [NSString stringWithFormat:@"%ld",collocationId];
        [self.parentVc pushController:collocationDetailVC animated:YES];
    }

    
    
    
    
}
-(void)brandDetailClicked:(UITapGestureRecognizer*)tap
{
#warning  brandid 为品牌code brand_code
    //
    extern BOOL g_socialStatus;
    if (g_socialStatus)//是否处于社交状态
    {
    BrandDetailViewController *brandVC=[[BrandDetailViewController alloc]init];
//    NSString *brandID =[NSString stringWithFormat:@"%@",self.cellData[@"temp_id"]];
//    brandVC.brandId = [brandID integerValue];
        brandVC.brandId = [NSString stringWithFormat:@"%@",self.cellData[@"brand_code"]];
        
       [self.parentVc.navigationController pushViewController:brandVC animated:YES];
    }
    else
    {
    SBrandSotryViewController * brandDetailVC  = [[SBrandSotryViewController alloc]init];
//    NSString * brandID = self.cellData[@"temp_id"];
//    brandDetailVC.brandId = [brandID integerValue];
    brandDetailVC.brandId = [NSString stringWithFormat:@"%@",self.cellData[@"brand_code"]];
    [self.parentVc.navigationController pushViewController:brandDetailVC animated:YES];
    }

}

@end
