//
//  CustomGridListView.m
//  Wefafa
//
//  Created by mac on 14-8-19.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CustomGridListView.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"


/////////////////////////////////////////////////////////
@implementation CustomGridListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame column:(int)column
{
    self = [super initWithFrame:frame];
    if (self) {
        _columnNuber=column;
        
    }
    return self;
}

-(void)reloadData
{
    [self createGridListView];
}

- (id)initWithFrame:(CGRect)frame column:(int)column defaultImageName:(NSString *)defaultImageName
{
    _defaultImageName=defaultImageName;
    return [self initWithFrame:frame column:column];
}

-(void)createGridListView
{
    if (backScrollView!=nil)
    {
        for (UIView *view in backScrollView.subviews)
        {
            [view removeFromSuperview];
        }
        [backScrollView removeFromSuperview];
    }
    backScrollView=[[UIScrollView alloc] initWithFrame:self.frame];
    backScrollView.showsVerticalScrollIndicator=YES;
//    [backScrollView setContentSize:CGSizeMake(0, [self getGridListViewHeight])];
    [self addSubview:backScrollView];
    
    _gridViewArray=[[NSMutableArray alloc] initWithCapacity:10];
    for (int i=0;i<[_delegate gridNumber:self];i++)
    {
        int x=(i%_columnNuber)*SCREEN_WIDTH/_columnNuber;
        int y = floor(i/_columnNuber)*[self gridCellHeight];
        CustomGridCell *grid=[_delegate createGridCell:self ];
        grid.gridIndex=i;
        grid.frame=CGRectMake(x, y, grid.frame.size.width, grid.frame.size.height);
        [backScrollView addSubview:grid];
        
        [_gridViewArray addObject:grid];
        
        [self grid:self dataForIndex:grid.gridIndex];
    }
}

-(float)gridCellHeight
{
    int minH=[CustomGridCell MinGridHeight];
    int cellheight=SCREEN_WIDTH/_columnNuber;
    return cellheight>minH?cellheight:minH;
}

-(int)getGridListViewHeight
{
    int gridcount=[_delegate gridNumber:self];
    return (gridcount/_columnNuber + (gridcount%_columnNuber>0?1:0))*[self gridCellHeight];
}

-(id)createDefaultGrid:(int)index
{
    CustomGridCell *view=[[CustomGridCell alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH/_columnNuber,[self gridCellHeight])];
    view.delegate=self;
    view.gridIndex=index;
    return view;
}

-(void)setDefaultGrid:(CustomGridCell *)grid imageName:(NSString *)imageName title:(NSString *)title
{
    UIImage *img=nil;
    if (_defaultImageName.length==0)
    {
        img=[UIImage imageNamed:DEFAULT_LOADING_IMAGE];
    }
    else
    {
        img=[UIImage imageNamed:_defaultImageName];
    }
    [grid.image setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:img];
    grid.namelabel.text=title;
}

#pragma CustomGridDelegate gridClick
-(void)click:(id)sender forIndex:(int)index
{
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(gridView:clickedItemIndex:)])
    {
        [_delegate gridView:self clickedItemIndex:index];
    }
}

-(void)grid:(id)sender dataForIndex:(int)gridIndex
{
    [_delegate gridView:self gridDataForIndex:gridIndex];
}

@end
