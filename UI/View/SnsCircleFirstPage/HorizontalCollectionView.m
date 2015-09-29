//
//  HorizontalCollectionView.m
//  Wefafa
//
//  Created by mac on 13-10-9.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "HorizontalCollectionView.h"
#import "AppSetting.h"
#import "WeFaFaGet.h"


@implementation HorizontalCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)awakeFromNib
{
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
    [super configView];
    
    _gridView.frame=CGRectMake(0,0,SCREEN_WIDTH,ROW_GRID_CELL_HEIGHT);
    
    PSUICollectionViewFlowLayout *layout=(PSUICollectionViewFlowLayout*)_gridView.collectionViewLayout;
    layout.scrollDirection=PSTCollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing=4.0;
    
    [_gridView registerClass:[ImageGridCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    
    _actView.frame = CGRectMake((_gridView.frame.size.width-20.0)/2, (ROW_GRID_CELL_HEIGHT-20.0)/2, 20.0f, 20.0f);
}

#pragma mark -
#pragma mark Collection View Data Source

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SNSRecommendUser *user=[self.dataArray objectAtIndex:indexPath.row];
    
    ImageGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    int x=7;
    int y=8-cell.offsetY;
    if (indexPath.row==0) //第一个
        x=17;
    cell.backView.frame=CGRectMake(x,y,cell.backView.frame.size.width,cell.backView.frame.size.height);

    cell.label.text = user.nick_name;
    cell.image.image = [UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];//@"default_head_image.png"];
    cell.recv_id=[[NSString alloc] initWithFormat:@"%@",user.photo_path];
    UIImage *img1=[self getImageAsyn:user.photo_path ImageCallback:^(UIImage *img, NSObject *recv_img_id)
     {
         NSString *r_id=(NSString *)recv_img_id;
         if ([r_id isEqualToString:(NSString *)cell.recv_id])
         {
             cell.image.contentMode=UIViewContentModeScaleAspectFit;
             cell.image.backgroundColor=[UIColor whiteColor];
             cell.image.image=img;
         }
     } ErrorCallback:^{}];
    if (img1!=nil) cell.image.image=img1;
    
    return cell;
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    int w=ROW_GRID_CELL_WIDTH-10;
    if (indexPath.row==0)
        w=ROW_GRID_CELL_WIDTH;
    return CGSizeMake(w, ROW_GRID_CELL_HEIGHT);
}

//////////////////////////////
-(CGSize)contentSize
{
    PSUICollectionViewFlowLayout *layout=(PSUICollectionViewFlowLayout*)_gridView.collectionViewLayout;
    return CGSizeMake(layout.collectionViewContentSize.width,ROW_GRID_CELL_HEIGHT);
}

@end
