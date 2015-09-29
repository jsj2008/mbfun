//
//  ImageHeadListView.m
//  Wefafa
//
//  Created by mac on 14-9-17.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "AppSetting.h"
#import "WeFaFaGet.h"
#import "EAImageListView.h"
#import "Utils.h"
#import "ModelBase.h"
@implementation EAImageListGridData

- (id)init
{
    self = [super init];
    if (self) {
        _url=@"";
        _code=@"";
        _name=@"";
        _checked=NO;
    }
    return self;
}

@end


///////
@implementation EAImageListView

//static int LIST_COUNT=10000;
static int ROW_HEAD_LIST_CELL_HEIGHT=34;

- (id)initWithFrame:(CGRect)frame listCount:(NSInteger)listCount
{
//    LIST_COUNT=listCount;
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
    
    _margin=10;
    
    ROW_HEAD_LIST_CELL_HEIGHT=self.frame.size.height;
    _gridView.frame=CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    
    PSUICollectionViewFlowLayout *layout=(PSUICollectionViewFlowLayout*)_gridView.collectionViewLayout;
    layout.scrollDirection=PSTCollectionViewScrollDirectionHorizontal;
//    layout.minimumLineSpacing=4.0;
    
    [_gridView registerClass:[ImageGridCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    
    _actView.frame = CGRectMake((_gridView.frame.size.width-20.0)/2, (ROW_HEAD_LIST_CELL_HEIGHT-20.0)/2, 20.0f, 20.0f);
    
    
    _imageBorderColor=[Utils HexColor:0xacacac Alpha:1.0];
    _imageSelectedBorderColor=[Utils HexColor:0x353535 Alpha:1.0];
    _imageBorderWidth=1;
    _imageSelectedBorderWidth=1;
    _cornerRadius=0.0;
    _selectIndex=0;
    _imageSize=CGSizeMake(39,39);
    _imageSelectedSize=CGSizeMake(50,50);
    _margin=10;
}

#pragma mark -
#pragma mark Collection View Data Source

- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSInteger count=self.dataArray.count;
//    if (self.dataArray.count>=LIST_COUNT)
//        count=LIST_COUNT;
//    else
//        count++;
    return count;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    int count=self.dataArray.count;
//    if (self.dataArray.count>=LIST_COUNT)
//        count=LIST_COUNT;
//    else
//        count++;

    ImageGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    NSInteger x=_margin/2;
    int y=0;
    int cellwidth=0;
    int cellheight=0;
    if (indexPath.row==_selectIndex)
    {
        cellwidth=_imageSelectedSize.width;
        cellheight=_imageSelectedSize.height;
        y=ROW_HEAD_LIST_CELL_HEIGHT-_imageSelectedSize.height;
    }
    else
    {
        cellwidth=_imageSize.width;
        cellheight=_imageSize.height;
        y=ROW_HEAD_LIST_CELL_HEIGHT-_imageSize.height;
    }
    cell.backView.frame=CGRectMake(x,y,cellwidth,cellheight);//CGRectMake(0,0,ROW_HEAD_LIST_CELL_WIDTH,ROW_HEAD_LIST_CELL_HEIGHT);
    cell.image.frame=CGRectMake(0,0,cell.backView.frame.size.width,cell.backView.frame.size.height);
    
    int imgwidth=8;
    cell.imgIcon.frame=CGRectMake(cell.image.frame.origin.x,cell.image.frame.origin.y+cell.image.frame.size.height-imgwidth,imgwidth,imgwidth);
    
    cell.imgIcon.image=[UIImage imageNamed:@"btn_select@3x.png"];
    
    cell.label.frame=cell.image.frame;
    
    cell.backView.layer.masksToBounds=YES;
//    cell.backView.layer.cornerRadius =cell.backView.frame.size.width/2;
    if (indexPath.row==_selectIndex)
    {
        cell.backView.layer.borderColor = _imageSelectedBorderColor.CGColor;
        cell.backView.layer.borderWidth =_imageSelectedBorderWidth;
    }
    else
    {
        cell.backView.layer.borderColor = _imageBorderColor.CGColor;
        cell.backView.layer.borderWidth =_imageBorderWidth;
    }

//    cell.image.layer.masksToBounds=YES;
//    cell.image.layer.cornerRadius =cell.image.frame.size.width/2;
    
//    cell.image.image = [UIImage imageNamed:@"default_head_image.png"];
    cell.image.image = [UIImage imageNamed:DEFAULT_LOADING_SMALL];
    
    
    EAImageListGridData *data=[self.dataArray objectAtIndex:indexPath.row];
    cell.label.text = data.name;
    if (data.checked)
        cell.imgIcon.hidden=NO;
    else
        cell.imgIcon.hidden=YES;

    
    cell.recv_id=[[NSString alloc] initWithFormat:@"%@",data.url];
    UIImage *img1=[self getImageAsyn:data.url ImageCallback:^(UIImage *img, NSObject *recv_img_id)
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
    int cellwidth=0;
    if (indexPath.row==_selectIndex)
        cellwidth=_imageSelectedSize.width+_margin;
    else
        cellwidth=_imageSize.width+_margin;
    return CGSizeMake(cellwidth, ROW_HEAD_LIST_CELL_HEIGHT);
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

-(NSInteger)getViewWidth
{
    int viewwidth=_imageSelectedSize.width+_margin;
    viewwidth+=(_imageSize.width+_margin)*(self.dataArray.count-1);

    return viewwidth;
}

-(NSInteger)getCellWidth:(NSInteger)index
{
    //    NSLog(@"%d",ROW_HEAD_LIST_CELL_WIDTH*self.dataArray.count);
    int cellwidth=0;
    if (index==_selectIndex)
        cellwidth=_imageSelectedSize.width+_margin;
    else
        cellwidth=_imageSize.width+_margin;
    return cellwidth;
}
//-(void)setLikeChecked:(BOOL)checked
//{
//    _likeChecked=checked;
//}

-(NSInteger)selectIndex
{
    return _selectIndex;
}

-(void)setSelectIndex:(NSInteger)index
{
    if (index!=_selectIndex)
    {
        _selectIndex=index;
        [self reloadData];
    }
}

@end
