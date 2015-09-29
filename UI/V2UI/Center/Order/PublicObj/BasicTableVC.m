//
//  BasicTableVC.m
//  Designer
//
//  Created by Juvid on 15/1/15.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "BasicTableVC.h"

@interface BasicTableVC ()

@end

@implementation BasicTableVC
@synthesize mlArrList;
- (void)viewDidLoad {
    [super viewDidLoad];
     self.tableView.rowHeight=44;
    mlArrList=[[NSMutableArray alloc]initWithArray:@[@"测试数据1",@"测试数据2",@"测试数据3",@"测试数据4",@"测试数据5"]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0)return mlArrList.count;
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor whiteColor];
    }
    else{ while ([cell.contentView.subviews lastObject]!=nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    }
    //    [cell.contentView addSubview:[GeneralView GeneralLine:44]];
//    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.text=mlArrList[indexPath.row];
//    cell.textLabel.textColor=kUIColorFromRGB(0x808080);
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
