//
//  LogisticsTrackingController.m
//  BanggoPhone
//
//  Created by Juvid on 14-6-30.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import "LogisticsTrackingController.h"
#import "DetectionSystem.h"

#import "LogisticsCell.h"

@interface LogisticsTrackingController (){
    NSArray *arrTableList;
    __weak IBOutlet UIImageView *imgGoods;
    __weak IBOutlet UILabel *labType;
    
    __weak IBOutlet UILabel *labNum;
}

@end

@implementation LogisticsTrackingController
@synthesize strOrderSn;
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IOS7) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    self.title=@"查看物流";
    arrTableList=@[@"物流公司：",@"快递单号：",@"物流跟踪",@"暂无物流信息",@"",@""];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)tableRowHight{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
     return 10;
//    else return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LogisticsCell";
    LogisticsCell *cell=(LogisticsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[LogisticsCell alloc]  initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
        if (indexPath.row==0) {
            cell.labTitle.textColor=[UIColor  colorWithRed:1 green:122.0/255.0 blue:0 alpha:1];
            cell.imgRedPoint.image=[UIImage imageNamed:@"icon_logistics_yellowdot"];
             cell.lineVertical.frame=CGRectMake(cell.lineVertical.frame.origin.x, cell.lineVertical.frame.origin.y+15, cell.lineVertical.frame.size.width, cell.lineVertical.frame.size.height-15);
        }
        
//        NSDictionary *dicItme=arrList[arrList.count-indexPath.row-1];
        cell.labTitle.text=@"浦东公司已收入";
        cell.labTime.text=@"2015.01.01 7:34";
        
        cell.cellLine.frame=CGRectMake(50, cell.cellLine.frame.origin.y, cell.cellLine.frame.size.width, cell.cellLine.frame.size.height);
       
    return cell;
}

    // Configure the cell...

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 48;
    }
    else{
//         return [DetectionSystem SizeString:arrList[arrList.count-indexPath.row-1][@"mark"] Width:253 Font:11]+31;
        return 48;
//        return [arrLineHight[indexPath.row] floatValue]+31;
    }
   
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
