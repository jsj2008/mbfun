//
//  DesignerTopTenTableView.m
//  Wefafa
//
//  Created by mac on 14-9-26.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "DesignerTopTenTableView.h"
#import "DesignerTopTenTableViewCell.h"
#import "Utils.h"

@implementation DesignerTopTenTableView

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
    
//    self.bounces=NO;
//    self.pagingEnabled=YES;
    
    DesignerTopTenTableViewCell *cell1=[[[NSBundle mainBundle] loadNibNamed:@"DesignerTopTenTableViewCell" owner:self options:nil] objectAtIndex:0];
    cellDefaultHeight=cell1.frame.size.height;
    self.sectionHeaderHeight=35.0;
//    self.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    NSArray *superArray=@[@"ico_weekpopular@3x.png",@"ico_monthpopular@3x.png",@"ico_firstpopular@3x.png"];
    NSArray *activeArray=@[@"ico_assistlist@3x.png",@"ico_marklist@3x.png",@"ico_MBlist@3x.png"];
    allImgArray=@[superArray,activeArray];
    titleArray=@[@[@"本周人气王",@"本月人气王",@"人气总冠军"],@[@"点赞狂人",@"积分排行",@"美邦之星"]];
    
}

-(void)setDataArray:(NSMutableArray *)aDatas
{
    championArr=[[NSMutableArray alloc] init];
    NSMutableArray *championArr1=[[NSMutableArray alloc] init];
    NSMutableArray *championArr2=[[NSMutableArray alloc] init];
    [championArr addObject:championArr1];
    [championArr addObject:championArr2];
    for (NSArray *d1 in aDatas)
    {
        for (NSDictionary *dict in d1)
        {
            //达人
            if ([dict[@"week"] isEqualToString:@"本周"] && [self notExistChampion:@"本周"])
            {
                [championArr1 addObject:dict];
            }
            if ([dict[@"week"] isEqualToString:@"本月"] && [self notExistChampion:@"本月"])
            {
                [championArr1 addObject:dict];
            }
            if ([dict[@"week"] isEqualToString:@"季度"] && [self notExistChampion:@"季度"])
            {
                [championArr1 addObject:dict];
            }
            
            //活跃
            
        }
    }
    [super setDataArray:aDatas];
}

-(BOOL)notExistChampion:(NSString *)week
{
    for (NSArray *a1 in championArr)
    {
        for (NSDictionary *dict in a1)
        {
            if ([dict[@"week"] isEqualToString:week])
                return NO;
        }
    }
    return YES;
}

#pragma mark table view datasource & delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return [titleArray[section] count];
    
//    return self.dataArray.count;
}

-(void)setCellBackground:(UITableViewCell *)cell
{
    //    UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
    //    backgrdView.backgroundColor=[self getcolor:[[[rootDict objectForKey:@"template"]objectForKey:@"nav"] objectForKey:@"_bgcolor" ]];
    //    backgrdView.backgroundColor = TABLEVIEW_BACKCOLOR;
    //    cell.backgroundView = backgrdView;
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置selectionStyle = UITableViewCellSelectionStyleNone; 选中的背景无效
    //    UIView *selectedView = [[UIView alloc] initWithFrame:cell.contentView.frame];
    //    selectedView.backgroundColor = [UIColor orangeColor];
    //    cell.selectedBackgroundView = selectedView;   //设置选中后cell的背景颜色
    //    [selectedView release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 35;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"达人";
    }
    else
    {
        return @"活跃";
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *AIdentifier =  @"DesignerTopTenTableViewCell";
    DesignerTopTenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DesignerTopTenTableViewCell" owner:self options:nil] objectAtIndex:0];
//        [self setCellBackground:cell];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    [cell.titleImgView setImage:[UIImage imageNamed:[[allImgArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]]];
    cell.lbName.text=[NSString stringWithFormat:@"%@",[[titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    cell.imageHead.image = [UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];
    if ([championArr count]>indexPath.section && [championArr[indexPath.section] count]>indexPath.row)
        cell.data=championArr[indexPath.section][indexPath.row];
    
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([championArr count]>indexPath.section && [championArr[indexPath.section] count]>indexPath.row)
    {
        NSMutableArray *arr=[[NSMutableArray alloc] init];
        for (NSDictionary *dict in self.dataArray[indexPath.section])
        {
            if ([championArr[indexPath.section][indexPath.row][@"week"] isEqualToString:dict[@"week"]])
            {
                [arr addObject:dict];
            }
        }

        [_onDidSelectedRow fire:self eventData:@{@"selectedIndexPath":indexPath, @"data":arr}];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellDefaultHeight;
}

@end
