//
//  RecommendCircleCollectionView.m
//  Wefafa
//
//  Created by mac on 13-10-10.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "RecommendCircleCollectionView.h"
#import "SNSDataClass.h"

@implementation RecommendCircleCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SNSRecommendCircle *circle=[self.dataArray objectAtIndex:indexPath.row];
    
    ImageGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    int x=7;
    int y=8-cell.offsetY;
    if (indexPath.row==0) //第一个
        x=17;
    cell.backView.frame=CGRectMake(x,y,cell.backView.frame.size.width,cell.backView.frame.size.height);
    
    cell.label.text = circle.circle_name;
    cell.image.image = [UIImage imageNamed:@"public_icon_out_circle.png"];
    cell.recv_id=[[NSString alloc] initWithFormat:@"%@",circle.logo_path];
    UIImage *img1=[self getImageAsyn:circle.logo_path ImageCallback:^(UIImage *img, NSObject *recv_img_id)
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
    if (indexPath.row==[self.dataArray count]-1)
        w=ROW_GRID_CELL_WIDTH;
    return CGSizeMake(w, ROW_GRID_CELL_HEIGHT);
}

@end
