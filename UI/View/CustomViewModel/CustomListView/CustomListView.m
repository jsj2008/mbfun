//
//  CustomListView.m
//  Wefafa
//
//  Created by mac on 14-8-19.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CustomListView.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "CustomNormalListViewCell.h"
#import "JSonKit.h"

@implementation CustomListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _style=CUSTOM_LISTVIEW_STYLE_NORMAL;
        _columnNuber=1;
//        [GetViewControllerFile dataSourceDictionaryMap:nil];
        [self createNormalListView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(CUSTOM_LISTVIEW_STYLE)style
{
    self = [super initWithFrame:frame];
    if (self) {
        _style=style;
        self.backgroundColor=[UIColor whiteColor];
        
//        [GetViewControllerFile dataSourceDictionaryMap:nil];
        switch (_style) {
            case CUSTOM_LISTVIEW_STYLE_NORMAL:
                _columnNuber=1;
                [self createNormalListView];
                break;
            case CUSTOM_LISTVIEW_STYLE_GRID3:
                _columnNuber=3;
                [self createGridListView];
                break;
            case CUSTOM_LISTVIEW_STYLE_GRID4:
                _columnNuber=4;
                [self createGridListView];
                break;
            default:
                break;
        }
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
-(void)createGridListView
{
    customGridView=[[CustomGridListView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) column:_columnNuber ];
    customGridView.delegate=self;
    [self addSubview:customGridView];
}

-(void)createNormalListView
{
    normalListView=[[CustomNormalListView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    normalListView.delegate=self;
    [self addSubview:normalListView];
}

//
#pragma gridview delegate
-(id)createGridCell:(id)sender
{
    id cell=nil;
    if (_listViewDelegate!=nil && [_listViewDelegate respondsToSelector:@selector(createCell:forIndex:)])
    {
        cell=[_listViewDelegate createCell:sender forIndex:0];
    }
    else
    {
        cell=[customGridView createDefaultGrid:0];
    }
    return cell;
}

-(void)gridView:(id)sender gridDataForIndex:(int)gridIndex
{
    if (_listViewDelegate!=nil && [_listViewDelegate respondsToSelector:@selector(gridView:gridImageNameForIndex:)])
    {
        return [_listViewDelegate gridView:sender gridDataForIndex:gridIndex];
    }
    else
    {
        NSString *imageurl=_dataArray[gridIndex][_dataMapDictionary[@"icon"]];
        NSString *title = _dataArray[gridIndex][_dataMapDictionary[@"title"]];
        //NSString *detailtitle = _dataArray[gridIndex][_dataMapDictionary[@"subtitle"]];
        CustomGridCell *grid=customGridView.gridViewArray[gridIndex];
        [customGridView setDefaultGrid:grid imageName:imageurl title:title];
    }
}

-(void)gridView:(id)sender clickedItemIndex:(int)itemIndex
{
    if (_listViewDelegate !=nil && [_listViewDelegate respondsToSelector:@selector(gridView:clickedCell:forIndex:)])
    {
        NSArray *grids=((CustomGridListView *)sender).gridViewArray;
        id cell;
        if (grids.count>=itemIndex)
            cell=grids[itemIndex];
        [_listViewDelegate gridView:sender clickedCell:cell forIndex:itemIndex];
    }
}

-(int)gridNumber:(id)sender
{
    return (int)_dataArray.count;
}

#pragma listview delegate
-(id)createListCell:(id)sender
{
    id cell=nil;
    if (_listViewDelegate!=nil && [_listViewDelegate respondsToSelector:@selector(createCell:forIndex:)])
    {
        cell=[_listViewDelegate createCell:sender forIndex:0];
    }
    else
    {
        //default
        cell=[normalListView createDefaultCell:0];
    }
    return cell;
}

-(void)listView:(id)sender cell:(id)cell cellForRowAtIndexPath:(NSIndexPath*)indexPath;
{
    if (_listViewDelegate!=nil && [_listViewDelegate respondsToSelector:@selector(listView:cell:cellForRowAtIndexPath:)])
    {
        [_listViewDelegate listView:sender cell:cell cellForRowAtIndexPath:indexPath];
    }
    else
    {
        NSArray *dictArray=((CustomNormalListView *)sender).dataArray;
        
        CustomNormalListViewCell *customcell1=(CustomNormalListViewCell *)cell;
        
        [customcell1.imageHead setImageWithURL:[NSURL URLWithString:dictArray[indexPath.row][_dataMapDictionary[@"icon"]]] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];

        customcell1.lbTitle.text = dictArray[indexPath.row][_dataMapDictionary[@"title"]];
        customcell1.lbDetail.text = dictArray[indexPath.row][_dataMapDictionary[@"subtitle"]];
    }
}

- (CGFloat)listView:(id)sender heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (_listViewDelegate!=nil && [_listViewDelegate respondsToSelector:@selector(listView:heightForRowAtIndexPath:)])
    {
        return [_listViewDelegate listView:sender heightForRowAtIndexPath:indexPath];
    }
    return CustomListViewCellHeight;
}

-(void)listView:(id)sender cell:(id)cell clickedItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (_listViewDelegate !=nil && [_listViewDelegate respondsToSelector:@selector(listView:clickedCell:indexPath:)])
    {
        [_listViewDelegate listView:sender clickedCell:cell indexPath:indexPath];
    }
}

-(void)setDataArray:(NSMutableArray *)dataarr
{
    @synchronized(self)
    {
        _dataArray=dataarr;
    }
    
    switch (_style) {
        case CUSTOM_LISTVIEW_STYLE_NORMAL:
            normalListView.dataArray=_dataArray;
            break;
        case CUSTOM_LISTVIEW_STYLE_GRID3:
            [customGridView reloadData];
            break;
        case CUSTOM_LISTVIEW_STYLE_GRID4:
            [customGridView reloadData];
            break;
        default:
            break;
    }
}

-(NSMutableArray *)dataArray
{
    @synchronized(self)
    {
        return _dataArray;
    }
}

@end
