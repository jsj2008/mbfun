//
//  MyLikeGoodsTableView.m
//  Wefafa
//
//  Created by mac on 14-10-20.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MyLikeGoodsTableView.h"
#import "MyLikeGoodsTableViewCell.h"
#import "Utils.h"

@implementation MyLikeGoodsTableView

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
    
    MyLikeGoodsTableViewCell *cell1=[[[NSBundle mainBundle] loadNibNamed:@"MyLikeGoodsTableViewCell" owner:self options:nil] objectAtIndex:0];
    cellDefaultHeight=cell1.frame.size.height;
}

#pragma mark table view datasource & delegate methods

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
    NSString *AIdentifier =  @"MyLikeGoodsTableViewCell";
    MyLikeGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:AIdentifier owner:self options:nil] objectAtIndex:0];
        [self setCellBackground:cell];
    }
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
