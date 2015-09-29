//
//  ImageHeadListView.m
//  Wefafa
//
//  Created by mac on 14-9-17.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "AppSetting.h"
#import "WeFaFaGet.h"
#import "ImageHeadListView.h"
#import "Utils.h"

@implementation ImageHeadListView

static int LIST_COUNT=7;
static int ROW_HEAD_LIST_CELL_HEIGHT=34;
static int ROW_HEAD_LIST_CELL_WIDTH=34;

- (id)initWithFrame:(CGRect)frame listCount:(int)listCount
{
    LIST_COUNT=listCount;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    ROW_HEAD_LIST_CELL_HEIGHT=self.frame.size.height;
    ROW_HEAD_LIST_CELL_WIDTH=self.frame.size.width/LIST_COUNT;
    _gridView.frame=CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    
    PSUICollectionViewFlowLayout *layout=(PSUICollectionViewFlowLayout*)_gridView.collectionViewLayout;
    layout.scrollDirection=PSTCollectionViewScrollDirectionHorizontal;
//    layout.minimumLineSpacing=4.0;
    
    [_gridView registerClass:[ImageGridCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    
    _actView.frame = CGRectMake((_gridView.frame.size.width-20.0)/2, (ROW_HEAD_LIST_CELL_HEIGHT-20.0)/2, 20.0f, 20.0f);
}

#pragma mark -
#pragma mark Collection View Data Source

- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    int count=(int)self.dataArray.count;
    if (self.dataArray.count>=LIST_COUNT)
        count=LIST_COUNT;
    else
        count++;
    return count;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int count=(int)self.dataArray.count;
    if (self.dataArray.count>=LIST_COUNT)
        count=LIST_COUNT;
    else
        count++;

    ImageGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    int x=(ROW_HEAD_LIST_CELL_WIDTH-ROW_HEAD_LIST_CELL_HEIGHT)/2;
    int y=0;
    cell.backView.frame=CGRectMake(x,y,ROW_HEAD_LIST_CELL_HEIGHT,ROW_HEAD_LIST_CELL_HEIGHT);//CGRectMake(0,0,ROW_HEAD_LIST_CELL_WIDTH,ROW_HEAD_LIST_CELL_HEIGHT);
    cell.image.frame=CGRectMake(0,0,cell.backView.frame.size.width,cell.backView.frame.size.height);
    cell.label.frame=cell.image.frame;
    
    cell.backView.layer.masksToBounds=YES;
    cell.backView.layer.cornerRadius =cell.backView.frame.size.width/2;
    cell.backView.layer.borderColor = [Utils HexColor:0xc7c7c7 Alpha:1.0].CGColor;
    cell.backView.layer.borderWidth =1.0;

    if (indexPath.row<count-1)
    {
        cell.image.layer.masksToBounds=YES;
        cell.image.layer.cornerRadius =cell.image.frame.size.width/2;
        
        cell.image.image = [UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];//@"default_head_image.png"];
        
        SNSStaff *user=[self.dataArray objectAtIndex:indexPath.row];
        cell.label.text = @"";//user.nick_name;
        cell.recv_id=[[NSString alloc] initWithFormat:@"%@",user.photo_path];
        // 喜欢头像
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
     
    }
    else
    {
        cell.image.layer.masksToBounds=NO;
        
        int button_icon_width=14;
        cell.image.frame=CGRectMake((cell.backView.frame.size.width-button_icon_width)/2,(cell.backView.frame.size.height-button_icon_width)/2,button_icon_width,button_icon_width);
        if (_likeChecked==NO)
            cell.image.image = [UIImage imageNamed:@"ico_favor.png"];
        else
            cell.image.image = [UIImage imageNamed:@"ico_favor_pressed.png"];
    }
    return cell;
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ROW_HEAD_LIST_CELL_WIDTH, ROW_HEAD_LIST_CELL_HEIGHT);
}

//////////////////////////////
-(CGSize)contentSize
{
    PSUICollectionViewFlowLayout *layout=(PSUICollectionViewFlowLayout*)_gridView.collectionViewLayout;
    return CGSizeMake(layout.collectionViewContentSize.width,ROW_HEAD_LIST_CELL_HEIGHT);
}

-(void)setBackgroundColor:(UIColor *)backgroundColor1
{
    _gridView.backgroundColor=backgroundColor1;
    [super setBackgroundColor:backgroundColor1];
}

-(void)setLikeChecked:(BOOL)checked
{
    _likeChecked=checked;
}

@end
