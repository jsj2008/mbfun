//
//  CollocationTableView.m
//  Wefafa
//
//  Created by mac on 14-8-13.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CollocationTableView.h"
#import "CollocationTableViewCell.h"
#import "Utils.h"

@implementation CollocationTableView

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
    [super innerInit];
    
    self.dataSource = self;
    self.delegate = self;
    self.tableFooterView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    _onDidSelectedRow= [[CommonEventHandler alloc] init];
    
    CollocationTableViewCell *cell1=[[[NSBundle mainBundle] loadNibNamed:@"CollocationTableViewCell" owner:self options:nil] objectAtIndex:0];
    
    //Chengyb，暂时隐藏喜欢头像
    cellDefaultHeight=cell1.frame.size.height;
    
//#ifndef WEFAFA_IOS6_VERSION_COMPILE
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self setSeparatorInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
    }
//#endif
    self.pageIndex=1;
    self.pageSize=20;
}

#pragma mark table view datasource & delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.dataArray count]==0||self.dataArray==nil)
    {
        return 0;
    }
    else
    {
        if ([[self.dataArray[0] allKeys]containsObject:@"collocationList"])
        {
            return [self.dataArray count];
        }
        else
        {
            return 1;
        }
    }

}
-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    if ([self.dataArray count]==0||self.dataArray==nil)
    {
        return self.dataArray.count;
    }
    else
    {
        if ([[self.dataArray[section] allKeys]containsObject:@"collocationList"])
        {
            return [self.dataArray[section][@"collocationList"] count];
        }
        else
        {
            return self.dataArray.count;
        }
    }

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
    NSString *AIdentifier =  @"CollocationTableViewCell";
    CollocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CollocationTableViewCell" owner:self options:nil] objectAtIndex:0];
        [self setCellBackground:cell];
    }
    if (self.showBottom)
    {
        cell.viewBottom.hidden=NO;
    }
    else
    {
        cell.viewBottom.hidden=YES;
        
    }
    if ([[self.dataArray[indexPath.section] allKeys] containsObject:@"collocationList"])
    {
        cell.data = self.dataArray[indexPath.section][@"collocationList"][indexPath.row];
    }
    else
    {
        cell.data=self.dataArray[indexPath.row];
    }
 
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[self.dataArray[indexPath.section] allKeys] containsObject:@"collocationList"])
    {
        if (self.dataArray[indexPath.section][@"collocationList"][indexPath.row]==nil||[self.dataArray[indexPath.section][@"collocationList"][indexPath.row] allKeys].count==0) {
            
        }
        else{
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            CollocationTableViewCell *cell=(CollocationTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            [_onDidSelectedRow fire:self eventData:@[self.dataArray[indexPath.section][@"collocationList"][indexPath.row],cell]];
        }
    }
    else
    {
         [tableView deselectRowAtIndexPath:indexPath animated:YES];
         CollocationTableViewCell *cell=(CollocationTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
         [_onDidSelectedRow fire:self eventData:@[self.dataArray[indexPath.row],cell]];
     }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellDefaultHeight;
}

@end
