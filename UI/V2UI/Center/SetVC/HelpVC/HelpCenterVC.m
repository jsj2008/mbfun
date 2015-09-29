//
//  HelpCenterVC.m
//  Designer
//
//  Created by Juvid on 15/1/21.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "HelpCenterVC.h"
#import "HelpCenterCell.h"
#import "NewbieGuideVC.h"
@interface HelpCenterVC ()

@end

@implementation HelpCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"帮助中心";
    // Do any additional setup after loading the view from its nib.
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier=@"HelpCenterCell";
    HelpCenterCell *cell = (HelpCenterCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[HelpCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    NewbieGuideVC *newbieGuide=[[NewbieGuideVC alloc]init];
    [self.navigationController pushViewController:newbieGuide animated:YES];
}
//呼叫客服
- (IBAction)PressCall:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:4008219988"]]];
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
