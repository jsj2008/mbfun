//
//  CollocationTopicTableView.m
//  Wefafa
//
//  Created by mac on 14-9-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "CollocationTopicTableView.h"
#import "CollocationTopicNormalTableViewCell.h"
#import "Utils.h"

@implementation CollocationTopicTableView

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
    
    _onDidSelectedRow= [[CommonEventHandler alloc] init];
    
    CollocationTopicNormalTableViewCell *cell1=[[[NSBundle mainBundle] loadNibNamed:@"CollocationTopicNormalTableViewCell" owner:self options:nil] objectAtIndex:0];
    cellDefaultHeight=cell1.frame.size.height;
    self.tableFooterView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 4)];
    self.pageIndex=1;
    self.pageSize=20;
}

#pragma mark table view datasource & delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section==0)
//        return 168;
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if (section==0)
//    {
//        UIView* myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 168)];
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 20)];
//        titleLabel.backgroundColor = [Utils HexColor:0xd8d8d8 Alpha:1.0];
//        titleLabel.font=[UIFont systemFontOfSize: 14];
//        titleLabel.shadowColor=[UIColor whiteColor];
//        titleLabel.shadowOffset=CGSizeMake(1,1);
//        titleLabel.text=@"对不起，发个小广告";
//        myView.backgroundColor=[UIColor whiteColor];
//        [myView addSubview:titleLabel];
//        return myView;
//    }
    
    return nil;
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
    NSString *AIdentifier =  @"CollocationTopicNormalTableViewCell";
    CollocationTopicNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:AIdentifier owner:self options:nil] objectAtIndex:0];
        [self setCellBackground:cell];
    }
    cell.row=(int)indexPath.row;
    cell.data=self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_onDidSelectedRow fire:self eventData:self.dataArray[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellDefaultHeight;
}

@end
