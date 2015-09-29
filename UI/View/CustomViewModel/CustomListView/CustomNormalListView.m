//
//  CustomNormalListView.m
//  Wefafa
//
//  Created by mac on 14-8-13.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CustomNormalListView.h"
#import "CustomNormalListViewCell.h"

@implementation CustomNormalListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableStyle=UITableViewStylePlain;
        [self innerInit];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableStyle=style;
        [self innerInit];
    }
    return self;
}

- (void)dealloc {
}

- (void)awakeFromNib
{
    [self innerInit];
}

- (void)innerInit
{
    pullDragTableView=[[PullDragTableView alloc] initWithFrame:self.frame style:_tableStyle];
    //scroll refresh delegate
    pullDragTableView.delegate=self;
    pullDragTableView.dataSource=self;
//    ((UIScrollView *)pullDragTableView).delegate=pullDragTableView;
    //tableview show delegate
    
    [self addSubview:pullDragTableView];
    [pullDragTableView.onLoadNewMessage addListener:self selector:@selector(tableview_OnLoadNewMessage:eventData:)];
    [pullDragTableView.onLoadMoreMessage addListener:self selector:@selector(tableview_OnLoadMoreMessage:eventData:)];
}

#pragma mark table view datasource & delegate methods
- (void)tableview_OnLoadMoreMessage:(PullDragTableView*)sender eventData:(id)eventData
{
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(listView:loadMoreData:)])
    {
        [_delegate listView:self loadMoreData:eventData];
    }
}

- (void)tableview_OnLoadNewMessage:(PullDragTableView*)sender eventData:(id)eventData
{
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(listView:reloadData:)])
    {
        [_delegate listView:self reloadData:eventData];
    }
}

-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(void)setCellBackground:(UITableViewCell *)cell
{
//    UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
//    backgrdView.backgroundColor=[self getcolor:[[[rootDict objectForKey:@"template"]objectForKey:@"nav"] objectForKey:@"_bgcolor" ]];
//    backgrdView.backgroundColor = TABLEVIEW_BACKCOLOR;
//    cell.backgroundView = backgrdView;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置selectionStyle = UITableViewCellSelectionStyleNone; 选中的背景无效
    //    UIView *selectedView = [[UIView alloc] initWithFrame:cell.contentView.frame];
    //    selectedView.backgroundColor = [UIColor orangeColor];
    //    cell.selectedBackgroundView = selectedView;   //设置选中后cell的背景颜色
    //    [selectedView release];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *AIdentifier =  @"CustomNormalListViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AIdentifier];
    if (cell == nil) {
        cell = [_delegate createListCell:self];
        [self setCellBackground:cell];
    }
    [_delegate listView:self cell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(listView:cell:clickedItemAtIndexPath:)])
    {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        [_delegate listView:self cell:cell clickedItemAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(listView:heightForRowAtIndexPath:)])
    {
        return [_delegate listView:self heightForRowAtIndexPath:indexPath];
    }
    else
    {
        return CustomListViewCellHeight;
    }
}

-(UITableViewCell*)createDefaultCell:(int)index
{
    CustomNormalListViewCell *cell=[[CustomNormalListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomNormalListViewCell"];
    cell.tag=index;
    return cell;
}

-(void)setDataArray:(NSMutableArray *)dataarr
{
    pullDragTableView.dataArray=dataarr;
}

-(NSMutableArray *)dataArray
{
    return pullDragTableView.dataArray;
}

@end
