//
//  MyCircleListCollectionView.m
//  Wefafa
//
//  Created by mac on 13-10-9.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "MyCircleListCollectionView.h"
#import "SNSDataClass.h"
#import "AppSetting.h"
#import "WeFaFaGet.h"
//#import "CircleHomePageViewController.h"
#import "AppDelegate.h"


@implementation MyCircleListCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)awakeFromNib
{
    CollectionViewCellIdentifier = @"MyCircleCellViewLeftId";
    [self configView];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(void)configView
{
    //    _onLabelLicenseClick=[[CommonEventHandler alloc] init];
    [super configView];
    
    [_gridView registerClass:[MyCircleGridCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
}

-(NSString *)circleHeadImage:(SNSCircle *)circle
{
//    NSString *innercircle=nil;
//    CircleHomePageViewController *vc = [AppDelegate getTabViewControllerObject:@"CircleHomePageViewController"];
//    if ([vc isKindOfClass:CircleHomePageViewController.class])
//    {
//        SNSCircle *circle = vc.circleArray[0];
//        innercircle = circle.circle_id;
//    }
    NSString *default_head_name=@"public_icon_out_circle.png";
//    if ([circle.enterprise_no isEqualToString:@""]==NO && [innercircle isEqualToString:circle.enterprise_no])
//        default_head_name=@"public_icon_inner_circle.png";
//    else if ([circle.circle_id isEqualToString:@"9999"])
//        default_head_name=@"public_icon_social_circle.png";
//    else if ([circle.circle_id isEqualToString:@"10000"])
//        default_head_name=@"public_icon_we_circle.png";
    return default_head_name;
}

#pragma mark -
#pragma mark Collection View Data Source
- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SNSCircle *circle=[self.dataArray objectAtIndex:indexPath.row];
    
    MyCircleGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    int x=SCREEN_WIDTH/2-MYCIRCLE_GRID_WIDTH-MYCIRCLE_GRID_LEFT_MARGIN;
    int y=0;
    if (indexPath.row%2==0) //第一列
        x=MYCIRCLE_GRID_LEFT_MARGIN;
    if (indexPath.row/2==0) //第一行
        y=MYCIRCLE_GRID_LEFT_MARGIN;
    cell.backView.frame=CGRectMake(x,y,MYCIRCLE_GRID_WIDTH,MYCIRCLE_GRID_HEIGHT);
    
    cell.label.text = circle.circle_name;
    cell.labelNum.text = [[NSString alloc] initWithFormat:@"%d",circle.staff_num ];
    
    if ([circle.circle_id isEqualToString:@"10000"])
        cell.isHideLabelNum=YES;
    else
        cell.isHideLabelNum=NO;
    
    cell.headImage.image = [UIImage imageNamed:[self circleHeadImage:circle]];
    cell.recv_id=[[NSString alloc] initWithFormat:@"%@",circle.logo_path];
    UIImage *img1=[self getImageAsyn:circle.logo_path ImageCallback:^(UIImage *img, NSObject *recv_img_id)
     {
         NSString *r_id=(NSString *)recv_img_id;
         if ([r_id isEqualToString:(NSString *)cell.recv_id])
         {
             cell.headImage.contentMode=UIViewContentModeScaleAspectFit;
             cell.headImage.backgroundColor=[UIColor whiteColor];
             cell.headImage.image=img;
         }
     } ErrorCallback:^{}];
    if (img1!=nil) cell.headImage.image=img1;
    
    return cell;
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    int h=MYCIRCLE_GRID_HEIGHT+MYCIRCLE_GRID_LEFT_MARGIN;
    if (indexPath.row/2==0)
        h=MYCIRCLE_GRID_HEIGHT+2*MYCIRCLE_GRID_LEFT_MARGIN;
    
    return CGSizeMake(SCREEN_WIDTH/2, h);
}

@end

