//
//  PullDragTableView.m
//  Wefafa
//
//  Created by mac on 14-8-13.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "PullDragTableView.h"

@implementation PullDragTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
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
    _onLoadNewMessage = [[CommonEventHandler alloc] init];
    _onLoadMoreMessage= [[CommonEventHandler alloc] init];
    
    _dataArray = [NSMutableArray arrayWithCapacity:10];
    [self setUpRefreshView];
    [self setPullRefreshView];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark table view datasource & delegate methods

//-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
//    return self.dataArray.count;
//}
//
//-(void)setCellBackground:(UITableViewCell *)cell
//{
//    //    UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
//    //    backgrdView.backgroundColor=[self getcolor:[[[rootDict objectForKey:@"template"]objectForKey:@"nav"] objectForKey:@"_bgcolor" ]];
//    //    backgrdView.backgroundColor = TABLEVIEW_BACKCOLOR;
//    //    cell.backgroundView = backgrdView;
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    //设置selectionStyle = UITableViewCellSelectionStyleNone; 选中的背景无效
//    //    UIView *selectedView = [[UIView alloc] initWithFrame:cell.contentView.frame];
//    //    selectedView.backgroundColor = [UIColor orangeColor];
//    //    cell.selectedBackgroundView = selectedView;   //设置选中后cell的背景颜色
//    //    [selectedView release];
//}
//
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *AIdentifier =  @"PullDragTableViewCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AIdentifier];
//    }
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 40;
//}

#pragma mark pubic methods

-(NSMutableArray*)dataArray
{
    @synchronized (self)
    {
        return _dataArray;
    }
}

-(void)setDataArray:(NSMutableArray *)aDatas
{
    @synchronized (self)
    {
        _dataArray = [NSMutableArray arrayWithArray:aDatas];
        [self reloadData];
        
        //设置footer
        [self setFooterViewFrame];
    }
}

#pragma mark EGORefreshTableHeader Methods

-(void)setUpRefreshView
{
    if (headViewRefresh == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
		view.delegate = self;
		[self addSubview:view];
		headViewRefresh = view;
	}
	//  update the last update date
	[headViewRefresh refreshLastUpdatedDate];
}

//调用此方法来停止。
- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	isLoadData = NO;
	[headViewRefresh egoRefreshScrollViewDataSourceDidFinishedLoading:self];
	
}

#pragma mark EGORefreshTableHeader for tableview uiscroll Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < 200) {
        [headViewRefresh egoRefreshScrollViewDidScroll:scrollView];
    }
    else
    {
        [footViewRefresh egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y < 200)
    {
        [headViewRefresh egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else
    {
        [footViewRefresh egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    isLoadData = YES;
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
    if (_onLoadNewMessage!=nil)
    {
        [_onLoadNewMessage fire:self eventData:nil];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return isLoadData;
}

/////////////////////////////////////////////////
#pragma mark EGORefreshTableFooter Methods
//reloadData后设置位置
-(void)setFooterViewFrame
{
    //如果contentsize的高度比表的高度小，那么就需要把刷新视图放在表的bounds的下面
    int height = MAX(self.bounds.size.height, self.contentSize.height);
    footViewRefresh.frame =CGRectMake(0.0f, height, self.frame.size.width, self.bounds.size.height);
    if (footViewRefresh.frame.size.height>=self.frame.size.height)
    {
        [footViewRefresh setHidden:NO];
    }
    else
    {
        [footViewRefresh setHidden:YES];
    }
}

//创建PullView
-(void)setPullRefreshView
{
    if (footViewRefresh == nil) {
        int height = MAX(self.bounds.size.height, self.contentSize.height);
		EGORefreshTableFooterView *view = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, height, self.frame.size.width, self.bounds.size.height)];
		view.delegate = self;
		[self addSubview:view];
		footViewRefresh = view;
	}
    footViewRefresh.hidden=YES;
	//  update the last update date
	[footViewRefresh refreshLastUpdatedDate];
}

//调用此方法来停止。
- (void)doneLoadingPullTableViewData{
	//  model should call this when its done loading
	isLoadData = NO;
	[footViewRefresh egoRefreshScrollViewDataSourceDidFinishedLoading:self];
	
    if (_onLoadMoreMessage!=nil)
    {
        [_onLoadMoreMessage fire:self eventData:nil];
    }
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView*)view{
    isLoadData = YES;
    [self performSelector:@selector(doneLoadingPullTableViewData) withObject:nil afterDelay:1.0];
}

- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView*)view{
	return isLoadData;
}


@end
